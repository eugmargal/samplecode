M = 1000;   %N�mero de trayectorias simuladas
N = 100;    %N�mero de intervalos
%
T = 2;  %Simulaci�n en [0,T]
dT = T/N;   %Paso de tiempo para simulaci�n
t = 0:dT:T;
X = randn(M,N);
W0 = 0;
W = cumsum([W0*ones(M,1) sqrt(dT)*X],2);
figure(1); plot(t,W(1:50,:)');
figure(2);
subplot(1,3,1); hist(W(:,1));
subplot(1,3,2); hist(W(:,round(N/2)));
subplot(1,3,3); hist(W(:,end));
figure(1);
hold on
mean_W = mean(W);
stdev_W = std(W);
plot(t,mean_W,'k','linewidth',3)
plot(t,mean_W+2*stdev_W,'b','linewidth',3)
plot(t,mean_W-2*stdev_W,'b','linewidth',3)

hold off