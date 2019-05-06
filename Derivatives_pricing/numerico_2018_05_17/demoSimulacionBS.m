function demoSimulacionBS
M = 1000000;   %Número de trayectorias simuladas
N = 100;    %Número de intervalos
%
T = 2;  %Simulación en [0,T]
dT = T/N;   %Paso de tiempo para simulación
S0 = 100; mu = 0.5; sigma = 0.2;
X = randn(M,N);
r = 0.05; K = 90;
% Simulacion para valoracion
e = exp((r-0.5*sigma^2)*dT+sigma*sqrt(dT)*X);
% Simulacion para riesgos
%e = exp((mu-0.5*sigma^2)*dT+sigma*sqrt(dT)*X);
t = 0:dT:T;
S = cumprod([S0*ones(M,1) e],2);

n_trajectories_plot = 50;
figure(1); plot(t,S(1:n_trajectories_plot,:)');
figure(2);
subplot(1,3,1); hist(S(:,1));
subplot(1,3,2); hist(S(:,round(N/2)));
subplot(1,3,3); hist(S(:,end));
figure(1);
hold on
mean_S = mean(S,1);
plot(t,mean_S,'k','linewidth',3)
hold off

%valoración asiatica
media_aritmetica = mean(S(:,2:end),2);
payoff = max(media_aritmetica-K,0);
factor_descuento = exp(-r*T);
precio_MC = factor_descuento*mean(payoff)
stdev_MC = factor_descuento*std(payoff)/sqrt(M)
