muestras = 1000;
h = zeros(muestras,9); p_value = zeros(muestras,9);
jbstat = zeros(muestras,9) ; critval = zeros(muestras,9);
alpha = [0.05];
simsizechi = 10:5:100;
for j = 1:length(simsizechi)
    %sim = exprnd(1,muestras,simsize(k));
    %sim = lognrnd(0,1,muestras, simsize(k));
    sim = chi2rnd(2,muestras, simsizechi(j));
%     sim = randn(muestras,simsizerand(j));
    for i = 1:muestras
            [h(i,j)] = jbtest(sim(i,:),alpha);
    end
end
 tamanochi = sum(h,1)/muestras;
figure(1)
subplot(2,1,1)
plot(simsizechi,tamanochi)
title('Distribución \chi_{2}')
subplot(2,1,2)
plot(simsizerand,tamanorand)
title('Distribución normal')

