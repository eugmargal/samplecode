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
mu0 = 0; sigma0 = 1.0; nu0 = 1;
pars = fmincon(@(pars)minus_LL_tpdf(pars,X),...
                [mu0  sigma0 nu0],[],[],[],[],...
                [-Inf 0     0    ],...
                [Inf  Inf   Inf  ]);
mu = pars(1), sigma = pars(2), nu = pars(3)
%
% Autocorrelaciones
% 
nBins = 40; 
figure(1); subplot(2,3,1);  autocorr(X); 
ylabel('Autocorr(rendimientos)'); 
figure(1); subplot(2,3,4);  autocorr(abs(X)); 
ylabel('Autocorr(abs(rendimientos))'); title('');
%
% PDF
%
figure(1); subplot(1,3,2);
nBins = 40; hist(X,nBins); 
dx = (max(X)-min(X))/nBins;
normFactor = dx*length(X); 
a = 7; nPlot = 1e3;
xPlot = linspace(mu-a*sigma,mu+a*sigma,nPlot);
yPlot = normFactor*tpdf(xPlot,nu);
hold on; plot(xPlot,yPlot,'r','linewidth',2); hold off;
f = 1.1; axis([f*min(X) f*max(X) 0 Inf]);
figure(1); subplot(1,3,3);
nQQplot = 1e5; qqplot((X-mu)/sigma,trnd(nu,nQQplot,1));
f = 1.1; axis([f*min(X) f*max(X) f*min(X) f*max(X)]);
%
