function [precio,error] = precioCesta_MC(M,S0,K,r,T,sigma,Rho)
%precioCesta_MC: Estimación del precio de una cesta por Monte Carlo
%
%% SINTAXIS: [precio,error] = precioCesta_MC(M,S0,r,Rho,sigma,K,T)
%
%%  INPUT:
%   precio: estimación MC del precio de una call sobre cesta de
%           subyacentes (con los mismos pesos)
%   error : estimación del error MC
%
%%  OUTPUT:
%       M : Número de trayectorias a simular
%      S0 : Precios iniciales del subyacente (nSubyacente x 1)% K : Precio de ejercicio
%       r : Tipo de interés libre de riesgo
%       T : Vencimiento
%   sigma : Volatilidades (nSubyacente x 1)
%     Rho : Matriz de correlaciones (nSubyacente x nSubyacente)
%
% Ejemplo 1:
% S0 = [100 100 100]; sigma = [0.3 0.3 0.3];
% r = 0.05; T = 2; K = 100;
% Rho = ones(3)%+eps*eye(3);
% % ¿Qué ocurre si quitamos a Rho el término proporcional a eps?
% M = 5e6;
% [precio,error] = precioCesta_MC(M,S0,K,r,T,sigma,Rho)
% blsprice(S0(1),K,r,T,sigma(1)) % ¿Por qué?
%
% Ejemplo 2:
% S0 = [100 120 80]; sigma = [0.3 0.2 0.4];
% r = 0.05; T = 2; K = 100;
% Rho = [1 0.3 -0.5; 0.3 1 0.4; -0.5 0.4 1];
% M = 1e6;
% [precio,error] = precioCesta_MC(M,S0,K,r,T,sigma,Rho)
%
nSubyacentes = length(S0); % Número de subyacentes en la cesta
L = chol(Rho,'lower'); % Para n Subyacentes

%% generate M samples for N underlying assets from N(0,1)
X = randn(nSubyacentes,M);
%% simulates M trajectories for N underlying assets
ST = S0'.*exp((r-0.5*sigma'.^2)*T+sigma'.*L*X*sqrt(T));
%% define payoff
payoff = max(mean(ST,1)-K,0);
%% MC estimate
discountFactor = exp(-r*T);

precio = discountFactor*mean(payoff);
error = sqrt(sum((payoff-precio).^2)./(M-1))./sqrt(M);