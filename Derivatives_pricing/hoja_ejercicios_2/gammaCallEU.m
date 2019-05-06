function gamma = gammaCallEU(h,S0,K,r,T,sigma)
%% gammaCallEU: gamma de una call europea
%
%% SYNTAX:
%        gamma = gammaCallEU(h,S0,K,r,T,sigma)
%
%% INPUT:
%        h : Approximation error
%       S0 : Initial value of the underlying asset
%        K : Strike 
%        r : Risk-free interest rate 
%        T : Time to expiry 
%    sigma : Volatility 
%
%% OUTPUT:
%    gamma : Value of the option gamma sensitivity  
%
%% EXAMPLE 1:
% S0 = 100; K = 90; r = 0.03; T = 2; sigma = 0.4;
% h = 1e-4
% gamma = gammaCallEU(h,S0,K,r,T,sigma)
% blsgamma(S0,K,r,T,sigma)
%
%% EXAMPLE 2:
% S0 = 100; K = 90; r = 0.03; T = 2; sigma = 0.4;
% for exponente=1:16
%     h = 10^-(exponente);
%     gamma(exponente) = gammaCallEU(h,S0,K,r,T,sigma);
%     contador(exponente) = -exponente;
% end
% real_value = blsgamma(S0,K,r,T,sigma);
% table(contador', gamma', abs(real_value-gamma)','VariableNames',{'Exponente','Valor','ABS_error'})
% %
payoff = @(ST) max(ST-K,0);

C = @(S0) priceEuropeanOption(S0,r,T,sigma,payoff);

gamma = (C(S0*(1+h))-2*C(S0)+C(S0*(1-h)))/(S0*h)^2;