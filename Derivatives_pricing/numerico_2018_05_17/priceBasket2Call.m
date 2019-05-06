function price = priceBasket2Call(S1_0,S2_0,c1,c2,K,r,T,sigma1,sigma2,rho)
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
%    S1_0 = 100; S2_0 = 100; c1 = 0.5; c2 = 0.5; K = 90; r = 0.05; T = 2; sigma1 = 0.4; sigma2 = 0.4; rho = 1;
%   price = priceBasket2Call(S1_0,S2_0,c1,c2,K,r,T,sigma1,sigma2,rho);
%%

discount_factor = exp(-r*T);
R = 10;
TOL_ABS = 1e-4;
externalIntegrand = @(x1)(integrand_priceBasket2Call(x1,S1_0,S2_0,c1,c2,K,r,T,sigma1,sigma2,rho));
price = discount_factor*quadl(externalIntegrand,-R,R,TOL_ABS);