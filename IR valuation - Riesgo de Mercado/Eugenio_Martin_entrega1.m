Nominal = 10^7;
fixed_coupon = 0.024215;

% Creo las patas de los pagos (anual y semianual)
for i = 1:20
    legs(1+2*(i-1)) = datetime(2018 + i,6,30);
    legs(2*i) = datetime(2018 + i,12,31);
end
legs2num = datenum(legs);

%%  Factor de descuento de OIS
[ois, data,~] = xlsread('Datos_Ejercicio_1','Euribor Curves','Z4:AG37');
dateOIS = datetime(data(:,2));
dOIS2num = datenum(dateOIS);
DF_OIS = spline(dOIS2num,ois(:,5),legs2num);
DF_OIS = [ois(1,5) DF_OIS];

%%  Factor de descuento de EUR-6M
[euribor, data2,~] = xlsread('Datos_Ejercicio_1','Euribor Curves','B4:H35');
date6M = datetime(data2(:,1),'InputFormat','MM/dd/uuuu');
d6M2num = datenum(date6M);
DF_6M = spline(d6M2num,euribor(:,5),legs2num);
DF_6M = [ois(1,5) DF_6M]; % para calcular el forward rate

legs1 = [datetime(2018,12,31) legs];

%% Gráfica spline DF_OIS y EURIBOR 6M
figure; subplot(1,2,1)
hold on
scatter(dateOIS(1:28),ois(1:28,5)); plot(legs1,DF_OIS); title('OIS DF interpolation');
hold off
subplot(1,2,2)
hold on
scatter(date6M(1:25),euribor(1:25,5)); plot(legs1,DF_6M); title('EUR-6M DF interpolation');
hold off

%% IRS NPV (fixed pov)
NPV_fix = -Nominal * fixed_coupon * DF_OIS(2:2:end) .* yearfrac(legs1(1:2:end-2),legs1(3:2:end),6);
L = (DF_6M(1:end-1)./DF_6M(2:end)-1)./yearfrac(legs1(1:end-1),legs1(2:end),2);
NPV_float = Nominal * L .* DF_OIS(2:end) .* yearfrac(legs1(1:end-1),legs1(2:end),2);
IRS_NPV = sum([NPV_fix, NPV_float]);

figure; scatter(legs,L,20,'filled'); title('\fontsize{14}6M implicit forward'); ylim([-0.01 0.025])

figure; hold on
stem(legs1(3:2:end),NPV_fix/Nominal)
stem(legs1(2:end),NPV_float/Nominal)
title('Interest Rate Swap NPV'); ylabel('NPV as % nominal'); xlabel('Swap legs')
legend('NPV fixed','NPV float','Location','NorthWest')
hold off

for i =1:20
    fixed(2*i) = NPV_fix(i);
end
pagos = table(legs',fixed',NPV_float');
pagos.Properties.VariableNames = {'PayDate' 'FixedLeg' 'FloatingLeg'}

sprintf('Valoración de Interest Rate Swap')
sprintf('NPV pata fija: %f €',sum(NPV_fix))
sprintf('NPV pata flotante: %f €',sum(NPV_float))
sprintf('NPV del IRS: %f €',IRS_NPV)
display('________________________________________________________________________')


strike = 0.015133;
%% IR Cap NPV Normal model
[vol, voldata,~] = xlsread('Datos_Ejercicio_1','Normal Volatility','D4:S20');
vol = [vol(:,1:3),vol(:,5:end)];

vol_K = spline(vol(1,:),vol(15,:)',strike);
DCF = yearfrac(legs1(1:end-1),legs1(2:end),2);
t = cumsum(DCF);
d = (L(2:end)-strike)./(vol_K/10000.*sqrt(t(1:end-1)));
caplet1 = DF_OIS(2)*DCF(1)*max(L(1)-strike,0);
caplet = [caplet1, DCF(2:end).*((L(1:end-1) - strike).*normcdf(d) + vol_K/10000.*sqrt(t(1:end-1)).*normpdf(d)).*DF_OIS(3:end)];
NPV_cap = -sum(caplet)*Nominal;
figure; scatter(legs,caplet*100,'filled'); title('Caplet NPV vs maturity'); ylabel('Caplet as % Nominal'); xlabel('Maturity (years)')

sprintf('El NPV del cap vendido con K=1.5133% es %f ', NPV_cap)
display('________________________________________________________________________')

%% Shifted lognormal
func = @(volatility)(cap_shifted(L,strike, volatility, t, DCF, DF_OIS(2:end)) + NPV_cap/Nominal);
vol_shifted = fzero(func,1);

sprintf('La volatilidad a vencimiento del modelo shifted log-normal es %f%%', vol_shifted*100)
display('________________________________________________________________________')

function capNPV = cap_shifted(forward_rate, strike, volatility, time, DCF, DFOIS)

theta = 0.03;
d1 = log((forward_rate(2:end)+theta)/(strike+theta)) + time(2:end)/2.*(volatility).^2./(volatility.*sqrt(time(2:end)));
d2 = log((forward_rate(2:end)+theta)/(strike+theta)) - time(2:end)/2.*(volatility).^2./(volatility.*sqrt(time(2:end)));
caplet76 = DCF(2:end).*DFOIS(2:end).*((forward_rate(2:end)+theta).*normcdf(d1) - (strike+theta).*normcdf(d2));
capNPV = sum(caplet76) + DCF(1)*DFOIS(1)*max(forward_rate(1)-strike,0);
end

