clear
S = load('ibex35raw.txt');
X = 100*log(S(2:end)./S(1:end-1)); % rendimientos logaritmicos
%
%   Modelo normal : X_t = mu + sigma \eps_t; \eps_t ~ N(0,1)
%
%  Allow a user-specified OPTIONS structure if one exists, but set default 
%  to 'iterative display' with 'diagnostics' printed to the screen.
%
if exist('options','var') == 0 | isempty(options)
   options  =  optimset('fmincon');
   options  =  optimset(options , 'Diagnostics' , 'on');
   options  =  optimset(options , 'Display'     , 'iter');
   options  =  optimset(options , 'LargeScale'  , 'off');
end
%
phi0_0 = 0; phi1_0 = 0.1; 
kappa0 = 0.05; alpha0 = 0.08; beta0 = 0.88; nu0 = 1;
pars = fmincon(@(pars)minus_LL_tpdf_AR1_GARCH11(pars,X),...
               [phi0_0 phi1_0 kappa0, alpha0, beta0,  nu0],...
               [ 0      0     0       1       1       0],1,[],[],...
               [-Inf   -1     0       0       0       0],...
               [ Inf    1     Inf     Inf     Inf     Inf],[],options);
phi0 = pars(1), phi1 = pars(2), 
kappa = pars(3), alpha = pars(4), beta = pars(5),   nu = pars(6)
U(1) = X(1)-mean(X);
U(2:length(X)) = X(2:end)-(phi0+phi1*X(1:end-1));
h = U(1)^2;
for t = 2: length(X)
    h(t) = kappa + alpha*U(t-1).^2 + beta*h(1,t-1);
end
epsilon = U(2:end)./sqrt(h(2:end));
%
% Autocorrelaciones
% 
figure(1); subplot(2,3,1);  autocorr(epsilon); 
ylabel('Autocorr(innovaciones)');
figure(1); subplot(2,3,4);  autocorr(abs(epsilon)); 
ylabel('Autocorr(abs(innovaciones))'); title('');
%
% PDF
%
figure(1); subplot(1,3,2); 
nBins = 40; hist(epsilon,nBins);
dx = (max(epsilon)-min(epsilon))/nBins;
normFactor = dx*length(epsilon); 
a = 7; nPlot = 1e3;
uPlot = linspace(-a,a,nPlot);
yPlot = normFactor*tpdf(uPlot,nu);
hold on; plot(uPlot,yPlot,'r','linewidth',2); hold off;
f = 1.1; axis([f*min(X) f*max(X) 0 Inf]);
figure(1); subplot(1,3,3);
nQQplot = 1e5; qqplot(epsilon,trnd(nu,nQQplot,1));
f = 1.1; axis([f*min(X) f*max(X) f*min(X) f*max(X)]);

 