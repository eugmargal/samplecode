function [price_MC,stdev_MC] = priceBasket2CallMC(S1_0,S2_0,c1,c2,K,r,T,sigma1,sigma2,rho,M)
%%  INPUT:
%   S1_0 : Initial value of the underling asset I
%   S2_0 : Initial value of the underling asset II
%     c1 : coefficient of asset I  in the basket
%     c2 : coefficient of asset II  in the basket
%      K : Strike
%      r : Risk-free interest rate
%      T : Time to expiry
% sigma1 : Volatility of asset I
% sigma2 : Volatility of asset II
%    rho : Correlation between two boths

%%  EXAMPLE 1:
%    S1_0 = 100; S2_0 = 100; c1 = 0.5; c2 = 0.5; K = 90; r = 0.05; T = 2;
%    sigma1 = 0.4; sigma2 = 0.4; rho = 1; M = 1e6;
%   [price_MC,stdev_MC] = priceBasket2CallMC(S1_0,S2_0,c1,c2,K,r,T,sigma1,sigma2,rho,M);

%% generate M samples from N(0,1)
x1 = randn(1,M);
x2 = randn(1,M);

%% simulate M trajectories in one step
S1_T = S1_0*exp((r-0.5*sigma1^2)*T+sigma1*sqrt(T).*x1);
S2_T = S2_0*exp((r-0.5*sigma2^2)*T+sigma2*sqrt(T)*(rho*x1+sqrt(1-rho^2).*x2));

%% define payoff
payoff = max((c1*S1_T+c2*S2_T)-K,0);
%% MC estimate
discountFactor = exp(-r*T);

price_MC = discountFactor*mean(payoff);

stdev_MC = sqrt(sum((payoff-price_MC).^2)./(M-1))./sqrt(M);