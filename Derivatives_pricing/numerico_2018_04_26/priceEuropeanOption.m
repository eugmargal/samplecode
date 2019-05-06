function  price = priceEuropeanOption(S0,r,T,sigma,payoff)
%% priceEuropeanOption: Price of a European option in the Black-Scholes model
%
%% SYNTAX:
%        price = priceEuropeanOption(S0,r,T,sigma,payoff)
%
%% INPUT:
%       S0 : Initial value of the underlying asset
%        r : Risk-free interest rate 
%        T : Time to expiry 
%    sigma : Volatility 
%   payoff : Handle to the function of ST that specifies the payoff
%
%% OUTPUT:
%    price : Price of the option in the Black-Scholes model  
%
%% EXAMPLE:   
%        S0 = 100; K = 90; r = 0.05; T = 2; sigma = 0.4;
%        payoff = @(ST)(max(ST-K,0)); % payoff of a European call option
%        price  = priceEuropeanOption(S0,r,T,sigma,payoff)
%%
%Underlying asset BS price
ST = @(x)(S0.*exp((r-0.5.*sigma.^2).*T+sigma.*sqrt(T)*x)); %Definition of St

%Valoration through quadrature
integrando = @(x)(normpdf(x).*payoff(ST(x)));
R = 10; %integral limit that simulates \int_{-Inf}^{Inf} for N(0,1)
TOL_ABS = 1.0e-10;
price = exp(-r*T).*quadl(integrando,-R,R,TOL_ABS);

