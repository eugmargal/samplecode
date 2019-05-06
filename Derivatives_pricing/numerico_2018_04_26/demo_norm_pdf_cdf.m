function demo_norm_pdf_cdf()
mu = 1.0;
sigma = 2.5;
a = 5;
nPlot = 1000;
xPlot = linspace(mu-a*sigma,mu+a*sigma,nPlot);

figure(1);
subplot(2,1,1); plot( xPlot, normcdf( xPlot, mu, sigma),'b')
subplot(2,1,2); plot( xPlot, normpdf( xPlot, mu, sigma),'r','linewidth',3)
M = 500000;
X = mu+sigma*randn(M,1); %X~N(mu,sigma)
subplot(2,1,2);
hold on
indices = 1:50; %indices es un vector 1:50, por lo tanto X(indices) solo muestra los 50 primeros M
plot(X(indices),zeros(size(X(indices))),'kx') %crea matriz de ceros del mismo tamaño de X
nBins = 40;
[altura, centro] = hist(X,nBins);
factor_normalizacion = (max(X)-min(X))*M/nBins; %quiero que el area debajo del histograma sea  la misma que debajo de la pdf
bar(centro,altura/factor_normalizacion)
hold off

%%
%[a,b]=hist(rand(100,1),5)
%crea un histograma con cinco cajas 
