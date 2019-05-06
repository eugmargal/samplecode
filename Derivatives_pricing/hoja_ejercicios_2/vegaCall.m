function vega = vegaCall(h,S0,K,r,T,sigma,payoff)
%% vegaCall: vega de una call (en función del payoff, metodo diferencias finitas)
%
%% SYNTAX:
%        vega = vegaCall(S0,K,r,T,sigma,payoff)
%
%% INPUT:
%        h : Approximation error
%       S0 : Initial value of the underlying asset
%        K : Strike 
%        r : Risk-free interest rate 
%        T : Time to expiry 
%    sigma : Volatility 
%   payoff : Handle to the function of ST that specifies the payoff
%
%% OUTPUT:
%    gamma : Value of the option gamma sensitivity  
% 
%% EXAMPLE 1:
% S0 = 100; K = 90; r = 0.05; T = 2; sigma = 0.1; A = 10; h = 1e-6;
% payoff = @(ST)(A.*(ST>K)); % payoff of a digital call option
% vega = vegaCall(h,S0,K,r,T,sigma,payoff);
%
% % EXAMPLE 2:
% S0 = 100; K = 90; r = 0.05; T = 2; A = 10; h = 1e-6;
% payoff = @(ST)(A.*(ST>K)); % payoff of a digital call option
% sigma_ini = 0.1; sigma_final = 0.5; n = 1000;
% for i=1:n
%     sigma = sigma_ini + (sigma_final-sigma_ini)*i/n;
%     yPlot(i) = vegaCall(h,S0,K,r,T,sigma,payoff);
% end
% xPlot=linspace(sigma_ini,sigma_final,n);
% plot(xPlot,yPlot);  %Plots vega for different volatilities
% title('Vega call digital'); xlabel('Volatilidad'); ylabel('Vega');
% orden = 0; err_rel = 1; %Initialize variables
% while err_rel>0.01   %Stopping condition
%     orden = orden+1;
%     polinomio = polyfit(xPlot,yPlot, orden); %fit polynomial of order orden
%     for i = 1:n
%         sigma = xPlot(i);
%         base = flip(sigma.^linspace(0,orden,orden+1));
%         est_value(i) = sum(polinomio.*base);
%         error(i) = abs((est_value(i)-yPlot(i))/yPlot(i));     %error vector
%     end
%     err_rel = max(error); %stores the greatest value of the error vector
% end
% orden
%% CODE
price = @(sigma)(priceEuropeanOption(S0,r,T,sigma,payoff));
vega = numericalDerivative(price,sigma,h);