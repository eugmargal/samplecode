function [price_MC,stdev_MC] = priceEuropeanOptionMC(S0,r,T,sigma,payoff,M)
%% priceEuropeanCallMC: Price of a European call option in the Black-Scholes model
%
%% SYNTAX:
%        [price_MC,stdev_MC] = priceEuropeanCallMC(S0,r,T,sigma,payoff,M)
%
%% INPUT:
%       S0 : Initial value of the underlying asset
%        r : Risk-free interest rate 
%        T : Time to expiry 
%    sigma : Volatility 
%   payoff : Hande to the function of ST that specifies the payoff
%        M : Number of simulations
% 
%
%% OUTPUT:
% price_MC : MC estimate of the price of the option in the Black-Scholes model  
% stdev_MC : MC estimate of the standard deviation  
%
%% EXAMPLE:   
%        S0 = 100; K = 90; r = 0.05; T = 2; sigma = 0.4;
%        M = 1e4;
%        payoff = @(ST)(max(ST-K,0));
%        B = 100; %batch MC
%        for b=1:B
%           [prices_MC(b),stdev_MC] = priceEuropeanOptionMC(S0,r,T,sigma,payoff,M);
%        end
%        figure(1); nBins = 20; hist(prices_MC,nBins)
%        disp(sprintf('MC: %g \n Muestral %g', stdev_MC, std(prices_MC)))

%% generate M samples from N(0,1)
X = randn(M,1);

%% simulate M trajectories in one step
ST = S0.*exp((r-sigma^2/2)*T+sigma.*sqrt(T).*X);
  
%% MC estimate
discountFactor = exp(-r*T);

price_MC = discountFactor.*mean(payoff(ST));

stdev_MC = discountFactor.*std(payoff(ST)) ./ sqrt(M);