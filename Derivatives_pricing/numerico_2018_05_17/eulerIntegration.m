function [t,f] = eulerIntegration(t0,f0,a,T,N)

% % dsigma(t) = -alpha(sigma(t)-sigma_infty)dt
% sigma_0 = 0.5; sigma_infty = 0.2; alpha = 1/2;
% a = @(t,sigma)(-alpha*(sigma-sigma_infty))
% t0 = 0; T = 20;
% N = 100;
% [t,sigma] = eulerIntegration(t0,sigma_0,a,T,N);
% figure(1); plot(t,sigma);

deltaT = T/N;
t = linspace(t0,t0+T,N+1);
f = zeros(1,N+1);
f(1) = f0;
for n = 1:N
    f(n+1) = f(n)+a(t(n),f(n))*deltaT;
end
