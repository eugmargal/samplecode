function [price_MC_antithetic,stdev_MC_antithetic] = priceEuropeanOptionMC_antithetic(S0,r,T,sigma,payoff,M)
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
%        M = 1e7;
%        payoff = @(ST)(max(ST-K,0));
%        [price_MC,stdev_MC] = priceEuropeanOptionMC(S0,r,T,sigma,payoff,M);
%        [price_MC_antithetic,stdev_MC_antithetic] = priceEuropeanOptionMC_antithetic(S0,r,T,sigma,payoff,M);
%        disp(sprintf('Precio MC (estándar): %g(%g)',price_MC,stdev_MC))
%        disp(sprintf('Precio MC (antitética): %g(%g)',price_MC_antithetic,stdev_MC_antithetic))


%% generate M samples from N(0,1)
X = randn(M,1);

%% simulate M trajectories in one step
STplus = S0.*exp((r-sigma^2/2)*T+sigma.*sqrt(T).*X);
STminus = S0.*exp((r-sigma^2/2)*T-sigma.*sqrt(T).*X);

%% MC estimate
discountFactor = exp(-r*T);
payoff_plus = payoff(STplus);
payoff_minus = payoff(STminus);
payoff = (payoff_plus+payoff_minus)/2;
price_MC_antithetic = discountFactor.*mean(payoff);

stdev_MC_antithetic = std(payoff) ./ sqrt(M);