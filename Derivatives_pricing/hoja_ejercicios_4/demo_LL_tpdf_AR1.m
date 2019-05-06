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
phi0_0 = 0; phi1_0 = 0.1; sigma0 = 1.0; nu0 = 1.0;
               
pars = fmincon(@(pars)minus_LL_tpdf_AR1(pars,X),...
               [phi0_0 phi1_0 sigma0   nu0],[],[],[],[],...
               [-Inf   -1     0        0],...
               [Inf     1     Inf      Inf],[],options);
phi0 = pars(1), phi1 = pars(2),
sigma = pars(3), nu = pars(4)
U = X(2:end)-(phi0+phi1*X(1:end-1));
%
% Autocorrelaciones
% 
figure(1); subplot(2,3,1);  autocorr(U); 
ylabel('Autocorr(innovaciones)');
figure(1); subplot(2,3,4);  autocorr(abs(U)); 
ylabel('Autocorr(abs(innovaciones))'); title('');
%
% PDF
%
figure(1); subplot(1,3,2); 
nBins = 40; hist(U,nBins);
dx = (max(U)-min(U))/nBins;
normFactor = dx*length(U); 
a = 7; nPlot = 1e3;
uPlot = linspace(-a*sigma,a*sigma,nPlot);
yPlot = normFactor*tpdf(uPlot,nu);
hold on; plot(uPlot,yPlot,'r','linewidth',2); hold off;
f = 1.1; axis([f*min(X) f*max(X) 0 Inf]);
figure(1); subplot(1,3,3);
nQQplot = 1e5; qqplot(U/sigma,trnd(nu,nQQplot,1));
f = 1.1; axis([f*min(X) f*max(X) f*min(X) f*max(X)]);

 