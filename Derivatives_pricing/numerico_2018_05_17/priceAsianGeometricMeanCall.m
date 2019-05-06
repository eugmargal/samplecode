function price = priceAsianGeometricMeanCall(S0,K,r,T,sigma,N)
%% priceAsianGeometricMeanCall: Price of a Asian call option on the geometric mean in the Black-Scholes model
%
%% SYNTAX:
%        price = priceAsianGeometricMeanCall(S0,K,r,T,sigma,N)
%
%% INPUT:
%       S0 : Initial value of the underlying asset
%        K : Strike 
%        r : Risk-free interest rate 
%        T : Time to expiry 
%    sigma : Volatility 
%        N : Number of monitoring times
%
%% OUTPUT:
%    price : Price of the option in the Black-Scholes model  
%
%% EXAMPLE:   
%        S0 = 100; r = 0.05; K = 90; T = 2; sigma = 0.4; N = 24;
%        price = priceAsianGeometricMeanCall(S0,K,r,T,sigma,N)
%        M = 1e6;
%        [price_MC,std_MC] = priceAsianGeometricMeanCallMC(S0,K,r,T,sigma,M,N)
%          

%% Auxiliary parameters
r_GM     = 0.5*(r*(N+1)/N - sigma^2*(1.0-1.0/N^2)/6.0); 
sigma_GM = sigma*sqrt((2.0*N^2 + 3.0*N + 1.0)/(6.0*N^2));

d_plus  = log(S0/(K*exp(-r_GM*T)))/(sigma_GM*sqrt(T)) + sigma_GM*sqrt(T)/2.0; 
d_minus = d_plus - sigma_GM*sqrt(T);
%
%
%% Pricing formula
price = exp(-r*T)*(S0*exp(r_GM*T)*normcdf(d_plus)-K*normcdf(d_minus)); 