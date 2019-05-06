function S = GeometricBrownian(t0,T,M,N,mu,sigma,S0)
%% ArithmeticBrownian: Simulates M geometric Brownian movements
%
%% SYNTAX:
%        [B] = GeometricBrownian(t0,T,M,N,mu,sigma,B0)
%
%% INPUT:
%       t0 : Initial simulation time
%        T : Final simulation time
%        M : Number of simulations 
%        N : Numbers of step (from t0 to t0+T)
%       mu : Expected value
%    sigma : Variance
%       S0 : Initial value
%% OUTPUT:
%       S :  matrix representing M trajectories at N steps
%
%% EXAMPLE1:   
%       t0 = 2.0; T = 12.0; N = 300; M = 500;
%       mu = 0.15; sigma = 0.1; S0 = 100;
%       gbrown = GeometricBrownian(t0,T,M,N,mu,sigma,S0);
%%
dT = T/N; % longitud del paso de simulación
X = randn(M,N); % X ~ N(0,1)
%% Simulación
t = t0:dT:(t0+T);% equivalente a: t = linspace(t0,t0+T,N+1)
factor = exp((mu-0.5*sigma^2)*dT+sigma*sqrt(dT)*X);
S = cumprod([S0*ones(M,1) factor], 2);
figure(1); hold on
    plot(t,S(1:50,:)')
    plot(t, S0*exp(mu.*(t-t0)),'r','LineWidth',2.5)
hold off
title('50 trayectorias - Browniano geometrico')

%%
t_refTot = [2.0 6.0 10.0 14.0];
scale = 0;
for i=1:4
    t_ref = t_refTot(i);
    modelPdf = @(b) (lognpdf(b,log(S0)+(mu-0.5*sigma^2)*(t_ref-t0),sigma*sqrt(t_ref-t0)));
    centro = (mu-0.5*sigma^2)*(t_ref-t0);
    radio = 4.0*sigma*sqrt(t_ref-t0);
    S_min = S0*exp(min(centro - radio));
    S_max = S0*exp(max(centro + radio));
    figure (1+i)    
    graphicalComparisonPdf(S(:,100*(i-1)+1),modelPdf,scale,S_min,S_max)
    title([ 'Histograma del proceso para t = ',num2str(4*(i-1)+2)]) 
end
