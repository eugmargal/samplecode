    function [X,u] = simAR1(M,T, phi0,phi1,sigma,X0)
%% simAR1 : Simulacion de un proceso AR(1)
%
%% SYNTAX:
%           X = simAR1(M,T,phi0,phi1,sigma,X0)
%
%% INPUT: 
%               X : Matriz (M,T) que contiene los M trayectorias simuladas
%               M : Numero de trayectorias simuladas
%               T : Tiempos para la simulación
%              X0 : Valor inicial de la serie temporal
% phi0,phi1,sigma : Parámetros que caracterizan el proceso AR(1)
%
% Ejemplo 1:
% M = 3; T = 1000; X0 = 0; phi0 = 0.0; phi1 = 0.7; sigma = 0.25;
% [X,u] = simAR1(M,T,phi0,phi1,sigma,X0);
% figure(1); plot(1:30,X(:,1:30));
% figure(2); autocorr(X(1,:),30);
% figure(3); subplot(2,1,1); autocorr(u(1,:),30);
% subplot(2,1,2); autocorr(abs(u(1,:)),30);
%
% Ejemplo 2: Simulación aprox. estacionaria
% M = 1; T = 1000; X0 = 0; phi0 = 0.0; phi1 = -0.7; sigma = 0.25;
% [X,u] = simAR1(M,T,phi0,phi1,sigma,X0);
% figure(1); plot(1:T,X);
% figure(2); autocorr(X(1,:),30);
% figure(3); subplot(2,1,1); autocorr(u(1,:),30);
% subplot(2,1,2); autocorr(abs(u(1,:)),30);
%
% Ejemplo 3: Simulación no estacionaria
% M = 1; T = 500; X0 = 10; phi0 = 0.0; phi1 = 0.95; sigma = 0.25;
% [X,u] = simAR1(M,T,phi0,phi1,sigma,X0);
% figure(1); plot(1:T,X);
%%
3X = zeros(M,T);
u = sigma*randn(M,T); % X ~ N(0,1)
X(:,1) = X0;
for i = 2:T
    X(:,i) = phi0+phi1*X(:,i-1)+u(:,i);
end
