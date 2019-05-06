function demoWienerGeneralizado
M = 1000;   %Número de trayectorias simuladas
N = 100;    %Número de intervalos
%
T = 2;  %Simulación en [0,T]
dT = T/N;   %Paso de tiempo para simulación
B0 = 100; mu = 0.5; sigma = 0.2;
X = randn(M,N);
d = mu*dT+sigma*sqrt(dT)*X;
t = 0:dT:T;
B = cumsum([B0*ones(M,1) d],2);

n_trajectories_plot = 50;
figure(1); plot(t,B(1:n_trajectories_plot,:)');
figure(2);
subplot(1,3,1); hist(B(:,1));
subplot(1,3,2); hist(B(:,round(N/2)));
subplot(1,3,3); hist(B(:,end));
figure(1);
hold on
mean_B = mean(B);
stdev_B = std(B);
plot(t,mean_B,'k','linewidth',3)
plot(t,mean_B+2*stdev_B,'b','linewidth',3)
plot(t,mean_B-2*stdev_B,'b','linewidth',3)

hold off
n_intermedio = round((T/2.0)/dT);
for n=1:length(t)
    autocovarianza(n) = mean((B(:,n)-mean(B(:,n))).*(B(:,n_intermedio)-mean(B(:,n_intermedio))));
end
figure(3);
plot(t,autocovarianza);