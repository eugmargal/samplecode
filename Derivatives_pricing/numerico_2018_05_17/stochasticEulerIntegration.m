function [t,f] = stochasticEulerIntegration(t0,f0,a,b,T,N,M)
%% EXAMPLE1: 
% S0 =100; mu=0.05; sigma=0.4;
% %a = @(t,S)(mu*S)
% %b = @(t,S)(sigma*S)

%% EXAMPLE2:
% sigma_0 = 0.5; sigma_infty = 0.2; alpha=0.5; xi = 0.1;
% a = @(t,sigma)(-alpha*(sigma-sigma_infty));
% b = @(t,sigma)(sigma*xi);
% 
% t0 = 0; T = 20;
% N = 100; M = 50;
% [t,sigma_t] = stochasticEulerIntegration(t0,sigma_0,a,b,T,N,M);
%   
%   figure(1); plot(t,sigma_t); xlabel('t'); ylabel('\sigma(t)');
%   hold on
%   figure(1); plot(t,mean(sigma_t),'r','linewidth',3);
%   figure(1); plot(t,sigma_infty+(sigma_0-sigma_infty)*exp(-alpha*(t-t0)),'b','linewidth',3);
%   hold off
%%
X = rand(M,N);
deltaT = T/N;
t = linspace(t0,t0+T,N+1);
f = zeros(M,N+1);
f(:,1) = f0;
for n = 1:N
    f(:,n+1) = f(:,n)+a(t(n),f(:,n))*deltaT + b(t(n),f(:,n)).*sqrt(deltaT).*X(:,n);
end