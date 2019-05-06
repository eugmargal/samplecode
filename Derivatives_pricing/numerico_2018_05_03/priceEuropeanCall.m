function price = priceEuropeanCall(S0,K,r,T,sigma)
%% priceEuropeanCall: Price of a European call option in the Black-Scholes model
%
%% SYNTAX:
%        price = priceEuropeanCall(S0,K,r,T,sigma)
%
%% INPUT:
%       S0 : Initial value of the underlying asset
%        K : Strike 
%        r : Risk-free interest rate 
%        T : Time to expiry 
%    sigma : Volatility 
%
%% OUTPUT:
%    price : Price of the option in the Black-Scholes model  
%
%% EXAMPLE:   
%        S0 = 100; r = 0.05; K = 90; T = 2; sigma = 0.4;
%        price = priceEuropeanCall(S0,K,r,T,sigma)
%          

%%
%Underlying asset BS price
ST = @(x)(S0*exp((r-0.5*sigma^2)*T+sigma*sqrt(T)*x));

%Valoration through quadrature
integrando = @(x)(normpdf(x).*max(ST(x)-K,0));
R = 10; %integral limit that simulates \int_{-Inf}^{Inf} for N(0,1)
TOL_ABS = 1.0e-6;
price = exp(-r*T)*quadl(integrando,-R,R,TOL_ABS);

