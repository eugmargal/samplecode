%% Importo los datos
% Para el apartado 3b
% y1= xlsread('ibex','C3:C1456');
% y2= xlsread('ibex','C1457:C1557');
% y1= xlsread('ibex','C3:C1557');
% [date1,date2,date3] = xlsread('ibex','B3:B1557');

y1 = xlsread('datos_financieros','S6612:S8176');
y2 = xlsread('datos_financieros','S8177:S8277');
[date1,date2,date3] = xlsread('datos_financieros','A6612:A8277');
%  yr1=log(y1(2:end)./y1(1:end-1));    % creo los rendimientos logarítmicos
%  yr2=log(y2(2:end)./y2(1:end-1));    % creo los rendimientos logarítmicos
 yr1 = y1(2:end);      % precios
 yr2 = y2(1:end-1);      % precios
%% Definición de los parámetros
n = 100; % observaciones a estimar
size_data = length(y1);         % longitud del vector de datos
size_forecast = length(y2);     % longitud del numero de datos a predecir
%% Estimación estática del modelo
ARLAG = [1,2];
MALAG = [12];
Model = arima('ARlags',ARLAG,'MAlags',MALAG);   % no consigo quitar la cte de la estimación
[ModelFit,a,b,coef] = estimate(Model,yr1);
[Y,YMSE] = forecast(ModelFit,n,'Y0',yr1);
lower = Y - 1.96*sqrt(YMSE);
upper = Y + 1.96*sqrt(YMSE);

%% Estimación dinámica del modelo
max_lag = max(max(ARLAG),max(MALAG));   % cantidad máxima de lags entre AR y MA
% Estimación del ruido a partir de los datos anteriores
for i = 1:max_lag
    ruido(i) = yr1(end+1-i)-yr1(end-i:-1:end-i-length(ARLAG)+1)'*coef.X(2:1+length(ARLAG));
end
% Se incluye la opción de simular varias trayectorias
sim = 1;
ruido = [repmat(ruido,sim,1) , randn(sim,100)];
% Posteriormente la 2a parte del vector es escalado con la varianza del modelo
r_din = repmat(yr1(end-max_lag+1:end)',sim,1);
coeficiente = [coef.X(1:end-1) ; sqrt(coef.X(end))]
% Generación de la previsión dinámica
for i=max_lag+1:length(yr2)
    r_din(:,i) = [zeros(sim,1),r_din(:,i-1), r_din(:,i-2),  ruido(:,i-12), ruido(:,i)] * coeficiente;
end
% prob = sum(r_din(:,end)>0)/sim
%% Gráfica de las predicciones
figure(1)
% Fecha y formato de la gráfica
date2 = cell2mat(date2);
a1=datetime(date2,'InputFormat','dd/MM/yyyy');
plot(a1(end-200:end-100),yr1(end-100:end),'Color',[.7,.7,.7]);
xlim([a1(end)-200  a1(end)+4]);
xticks(a1(end)-200:30:a1(end)+4)
xtickformat('MM-yy')
% Introduzco las series en la gráfica
hold on
r_estimated = plot(a1(end-99:end),r_din,'g');
serie_real = plot(a1(end-99:end),yr2);
h1 = plot(a1(end-99:end),lower,'r:','LineWidth',2);
plot(a1(end-99:end),upper,'r:','LineWidth',2)
h2 = plot(a1(end-99:end),Y,'k','LineWidth',2);
legend([h2 h1 r_estimated, serie_real],'Previsión estática','95% Intervalo','Previsión dinámica','Serie real',...
	     'Location','NorthWest')
title(' Rendimiento IBEX35')
ylabel('Rendimiento');
hold off

%% ACF, PACF e histograma de modelo
% figure(2)
% subplot(2,2,1)
% autocorr(yr1)
% subplot(2,2,3)
% parcorr(yr1)
% subplot(2,2,[2 4])
% hist(yr1,20)
% title('Histogram')

%% Estadísticos de bondad de predicción
% Error cuadrático medio
RMSE = sqrt(mean((Y-yr2).^2))
% Error absoluto medio
MAE = sum(abs(Y-yr2))
% Raíz del error cuadrático porcentual
RMSEp = sqrt(mean(((Y-yr2)./yr2)).^2)
% Error del error medio porcentual
MAEp = mean(abs((Y-yr2)./yr2))