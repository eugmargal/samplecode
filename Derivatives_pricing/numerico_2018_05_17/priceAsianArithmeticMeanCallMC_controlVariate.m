function  [price_MC,stdev_MC] = priceAsianArithmeticMeanCallMC_controlVariate(S0,K,r,T,sigma,M,N)
%% priceAsianArithmeticMeanCall_controlVariate: Control variate variance reduction for the 
%  price of a Asian call option on the arithmetic mean in the Black-Scholes model
%
%% SYNTAX:
%        [price_MC,stdev_MC] = priceAsianArithmeticMeanCallMC_controlVariate(S0,K,r,T,sigma,M,N)
%
%% INPUT:
%       S0 : Initial value of the underlying asset
%        K : Strike 
%        r : Risk-free interest rate 
%        T : Time to expiry 
%    sigma : Volatility 
%        M : Number of simulations
%        N : Number of observations
%
%% OUTPUT:
% price_MC : MC estimate of the price of the option in the Black-Scholes model  
% stdev_MC : MC estimate of the standard deviation  
%
%% EXAMPLE:   
%        S0 = 100; K = 90; r = 0.05; T = 2; sigma = 0.4;
%        M = 1e5; N = 24;
%        [price_MC,stdev_MC] = priceAsianArithmeticMeanCallMC_controlVariate(S0,K,r,T,sigma,M,N)
%          
%% Generate M x N samples from N(0,1)
X = rand(M,N); 
 
%% Simulate M trajectories in N steps
deltaT = T/N;
e = exp((r-0.5*sigma^2)*deltaT+sigma*sqrt(deltaT)*X);
S = cumprod([S0*ones(M,1) e],2);
%% Compute the payoff for each trajectory
media_geometrica = geomean(S(:,2:end),2);
payoff_geometrica = max(media_geometrica-K,0);
media_aritmetica = mean(S(:,2:end),2);
payoff_aritmetica = max(media_aritmetica-K,0);

%% MC estimate of the price and the error of the option
discountFactor = exp(-r*T);

price_MC_geometrica = discountFactor*mean(payoff_geometrica);
stdev_MC_geometrica = discountFactor*std(payoff_geometrica)/sqrt(M);

price_MC_aritmetica = discountFactor*mean(payoff_aritmetica);
stdev_MC_aritmetica = discountFactor*std(payoff_aritmetica)/sqrt(M);

cov_MC = cov(payoff_aritmetica,payoff_geometrica);
rho_cuadrado = cov_MC(1,2)^2/(cov_MC(1,1)*cov_MC(2,2));

price_MC = price_MC_aritmetica-(cov_MC(1,2)/cov_MC(2,2))*(price_MC_geometrica-priceAsianGeometricMeanCall(S0,K,r,T,sigma,N));
stdev_MC = sqrt(1-rho_cuadrado)*stdev_MC_aritmetica;


