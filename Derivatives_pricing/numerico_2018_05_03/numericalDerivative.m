function  derivative = numericalDerivative(f,x0,h)
% numericDerivative: Numerical estimate of the derivative of f at x0
%
% SYNTAX:
%        derivative = numericalDerivative(f,x0,h)
%
% INPUT:
%            f : Handle to the function whose derivative is being calculated
%           x0 : Point at which the derivative is calculated
%            h : Parameter for divided differences (1e-5 - 1e-6)
%
% OUTPUT:
%   derivative : Value of the derivative of f at x0  
%
% EXAMPLE:   
%            N = 8; h = logspace(-N,-1,N);
%            log10(h)
%            log10_error = log10(abs(1.0- numericalDerivative(@sin,2*pi,h)))
%            log10_error = log10(abs(1.0- numericalDerivative(@exp,0,h)))
%
% EXAMPLE 2:
%            S0 = 100; K = 90; r = 0.05; T = 2; sigma = 0.4;
%            h = 1.0e-6;
%            payoff = @(ST)(max(ST-K,0)); % payoff of a European call option
%            price = @(S0)(priceEuropeanOption(S0,r,T,sigma,payoff));
%            delta = numericalDerivative(price,S0,h)
% 
%            M = 1e6;
%            price_MC = @(S0)(priceEuropeanOptionMC(S0,r,T,sigma,payoff,M))
%            delta_MC = numericalDerivative(price_MC,S0,h)
 
if x0 == 0
    derivative = (f(h)-f(-h)) ./ (2.0*h);
else
    derivative = (f(x0*(1.0+h))-f(x0*(1.0-h))) ./ (2.0*x0*h);
end    
