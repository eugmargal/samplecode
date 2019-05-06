function [gamma,err] = gammaCallEU_MC(M,S0,K,r,T,sigma)
% gammaCallEU_MC: gamma de una call europea mediante MC
%
% EJEMPLO 1:
% S0 = 100; K = 90; r = 0.03; T = 2; sigma = 0.4;
% M = 1e6;
% [gamma,err] = gammaCallEU_MC(M,S0,K,r,T,sigma)
% h = 1e-5;
% gammaCallEU(h,S0,K,r,T,sigma)
% blsgamma(S0,K,r,T,sigma)
%
X = randn(M,1); h=1e-2;
%
ST_plus = S0*(1+h).*exp((r-sigma^2/2)*T+sigma.*sqrt(T).*X);
ST = S0.*exp((r-sigma^2/2)*T+sigma.*sqrt(T).*X);
ST_minus = S0*(1-h).*exp((r-sigma^2/2)*T+sigma.*sqrt(T).*X);
%
payoff_plus = max(ST_plus-K,0);
payoff = max(ST-K,0);
payoff_minus = max(ST_minus-K,0);
%
derivative = (payoff_plus - 2*payoff + payoff_plus)/(S0*h)^2;

gamma = exp(-r*T)*mean(derivative);
err = exp(-r*T)*std(derivative)/sqrt(M);
