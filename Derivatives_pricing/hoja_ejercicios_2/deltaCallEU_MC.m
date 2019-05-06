function [delta_MC,err_MC] = deltaCallEU_MC(M,S0,K,r,T,sigma)
%% deltaCallEU_MC:  delta of an european call through MC method
%
%% SYNTAX:
%        [delta_MC,err_MC] = deltaCallEU_MC(M,S0,K,r,T,sigma)
%% INPUT:
%        M : Number of simulations
%       S0 : Initial value of the underlying asset
%        K : Strike 
%        r : Risk-free interest rate 
%        T : Time to expiry 
%    sigma : Volatility 
%% OUTPUT:
% delta_MC : MC estimate of the price of the option in the Black-Scholes model  
%   err_MC : MC estimate error (standard deviation)  
%% EJEMPLO 1:
%       S0 = 100; K = 90; r = 0.03; T = 2; sigma = 0.4;
%       M = 1e6;
%       [delta_MC,err_MC] = deltaCallEU_MC(M,S0,K,r,T,sigma)
%       h = 1e-5;
%       deltaCallEU(h,S0,K,r,T,sigma)
%       blsdelta(S0,K,r,T,sigma)
%%
%Simulate M random trajectories
X = randn(M,1);
h=1e-6;

%Simulate M trajectories in one step
ST_plus = S0*(1+h).*exp((r-sigma^2/2)*T+sigma.*sqrt(T).*X);
ST_minus = S0*(1-h).*exp((r-sigma^2/2)*T+sigma.*sqrt(T).*X);

%Define payoff for finite difference method
payoff_plus =max(ST_plus-K,0);
payoff_minus = max(ST_minus-K,0);
delta = (payoff_plus-payoff_minus) ./(2*S0*h);

%Compute delta value and error
delta_MC = exp(-r*T)*mean(delta);
err_MC = exp(-r*T)*std(delta)/sqrt(M);


