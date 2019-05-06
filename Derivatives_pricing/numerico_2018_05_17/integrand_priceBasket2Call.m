function externalIntegrand = integrand_priceBasket2Call(x1,S1_0,S2_0,c1,c2,K,r,T,sigma1,sigma2,rho)

%%  INPUT:
%       x1 : integration variable
%     S1_0 : Initial value of the underlying asset I
%     S2_0 : Initial value of the underlying asset II
%       c1 : coefficint of asset I  in the basket
%       c2 : coefficint of asset II  in the basket
%        K : Strike
%%
for i = 1:length(x1)
    S1_T = S1_0*exp((r-0.5*sigma1^2)*T+sigma1*sqrt(T)*x1(i));
    S2_T = @(x2)(S2_0*exp((r-0.5*sigma2^2)*T+sigma2*sqrt(T)*(rho*x1(i)+sqrt(1-rho^2)*x2)));
    
    basketValue = @(x2)(c1*S1_T+c2*S2_T(x2));
    payoff = @(x2)(max(basketValue(x2)-K,0));
    
    internalIntegrand = @(x2)(normpdf(x2).*payoff(x2));
    
    R = 10.0;
    TOL = 1.0e-4;
    externalIntegrand(i) = normpdf(x1(i))*quadl(internalIntegrand,-R,R,TOL);
end