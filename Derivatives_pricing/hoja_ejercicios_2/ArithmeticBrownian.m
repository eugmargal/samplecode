function B = ArithmeticBrownian(t0,T,M,N,mu,sigma,B0)
%% ArithmeticBrownian: Simulates M arithmetic Brownian movements
%
%% SYNTAX:
%        [B] = ArithmeticBrownian(t0,T,M,N,mu,sigma,B0)
%
%% INPUT:
%       t0 : Initial simulation time
%        T : Final simulation time
%        M : Number of simulations 
%        N : Numbers of step (from t0 to t0+T)
%       mu : Expected value
%    sigma : Variance
%       B0 : Initial value
%% OUTPUT:
%       B :  matrix representing M trajectories at N steps
%
%% EXAMPLE1:   
%       t0 = 2.0; T = 3.0; N = 300; M = 500;
%       mu = 5.0; sigma = 0.7; B0 = 100;
%       B = ArithmeticBrownian(t0,T,M,N,mu,sigma,B0);
%%
dT = T/N; % longitud del paso de simulación
X = randn(M,N); % X ~ N(0,1)
%% Simulación
t = t0:dT:(t0+T);% equivalente a: t = linspace(t0,t0+T,N+1)
factor = mu*dT+sigma*sqrt(dT)*X;
B = cumsum([B0*ones(M,1) factor], 2);
%%
figure(1); hold on
    plot(t,B(1:50,:)')
    plot(t, B0 + mu.*(t-t0),'r','LineWidth',2.5)
hold off
title ('Gráfico 1')
%%
figure(2); hold on
    for i=1:N+1
       desvt(i) = std(B(:,i));
    end
    plot(t,desvt)
    plot(t,sigma.*sqrt(t-t0))
hold off
title ('Desviación estandar')
%%
figure(3); hold on
    t1 = 3.0;
    for i=1:N+1
        covmatrix = cov(B(:,i),B(:,(t1-t0)/dT));
        autocov(i) = covmatrix(1,2);
    end
    plot(t,autocov)
    plot(t,sigma^2.*min(t-t0,t1-t0))
hold off
title ('Autocovarianza')
scale = 1;
t_refTot = [2.0 3.0 4.0 5.0];
%%
for i=1:4
    t_ref = t_refTot(i);
    modelPdf = @(b)(normpdf(b,B0+mu*(t_ref-t0),sigma*sqrt(t_ref-t0)));
    centro = mu*(t_ref-t0);
    radio = 4*sigma*sqrt(t_ref-t0);
    B_min = B0 + min(centro - radio);
    B_max = B0 + max(centro + radio);
    figure(3+i)
    graphicalComparisonPdf(B(:,100*(i-1)+1),modelPdf,scale,B_min,B_max)
    title([ 'Histograma del proceso para t = ',num2str(i+1)]) 
end
