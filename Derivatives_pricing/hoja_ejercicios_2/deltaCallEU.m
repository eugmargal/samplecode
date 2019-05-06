function delta = deltaCallEU(h,S0,K,r,T,sigma)
%% deltaCallEU:  delta of an european call (finite difference method)
%
%% SYNTAX:
%        delta = deltaCallEU_MC(h,S0,K,r,T,sigma)
%% INPUT:
%        h : Approximation error
%       S0 : Initial value of the underlying asset
%        K : Strike 
%        r : Risk-free interest rate 
%        T : Time to expiry 
%    sigma : Volatility 
%% OUTPUT:
%    delta : Value of the option delta trough finite differences  
%% EJEMPLO 1:
%       S0 = 100; K = 90; r = 0.03; T = 2; sigma = 0.4;
%       h = 1e-5;
%       delta = deltaCallEU(h,S0,K,r,T,sigma)
%       blsdelta(S0,K,r,T,sigma)
%
%% EJEMPLO 2:
%       S0 = 100; K = 90; r = 0.03; T = 2; sigma = 0.4;
%       for exponente=1:16
%            h = 10^-(exponente);
%            gamma(exponente) = deltaCallEU(h,S0,K,r,T,sigma);
%            contador(exponente) = -exponente;
%       end
%       real_value = blsdelta(S0,K,r,T,sigma);
%       array2table(cat(1, contador, gamma, abs((real_value-gamma)/real_value))','VariableNames',{'Exponente','Valor','rel_error'})
% 
%% Aplicando el metodo de diferencias finitas
fsup = priceEuropeanCall(S0*(1+h),K,r,T,sigma);
finf = priceEuropeanCall(S0*(1-h),K,r,T,sigma);
delta = (fsup - finf) ./ (2.0*S0*h);
