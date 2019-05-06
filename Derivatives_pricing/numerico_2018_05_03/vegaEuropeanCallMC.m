function [vega_MC,stdev_MC] = vegaEuropeanCallMC(S0,K,r,T,sigma,M)
%% vegaEuropeanCallMC: Vega of a European call option in the Black-Scholes model
%
%% SYNTAX:
%        [vega_MC,stdev_MC] = vegaEuropeanCallMC(S0,K,r,T,sigma,M)
%
%% INPUT:
%       S0 : Initial value of the underlying asset
%        K : Strike 
%        r : Risk-free interest rate 
%        T : Time to expiry 
%    sigma : Volatility 
%        M : Number of simulations
% 
%
%% OUTPUT:
% vega_MC  : MC estimate of the vega of the option in the Black-Scholes model  
% stdev_MC : MC estimate of the standard deviation  
%
%% EXAMPLE:   
%        S0 = 100; K = 90; r = 0.05; T = 2; sigma = 0.4;
%        M = 1e6; 
%        [vega_MC,stdev_MC] = vegaEuropeanCallMC(S0,K,r,T,sigma,M)
%
 
%% generate M samples from N(0,1)
X = randn (M,1); 

%% simulate M minus / plus trajectories in one step

h= 1.0e-6;
sigma_plus = sigma*(1+h);
sigma_minus = sigma*(1-h);
ST_plus = S0*exp((r-0.5*sigma_plus^2)*T + sigma_plus*sqrt(T)*X);
ST_minus = S0*exp((r-0.5*(sigma_minus)^2)*T + (sigma_minus)*sqrt(T)*X);

%% define minus / plus payoffs

payoff_plus = max(ST_plus-K,0);
payoff_minus = max(ST_minus-K,0);
 
%% compute vega along each trajectory

vega_m = (payoff_plus-payoff_minus)/(2*sigma*h); % para trabajar con trayectorias dependientes

%% MC estimate
discountFactor = exp(-r*T); 
vega_MC = discountFactor * mean(vega_m);
stdev_MC = discountFactor * (1/sqrt(M))*std(vega_m);
end