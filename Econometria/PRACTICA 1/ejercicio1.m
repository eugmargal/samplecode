muestras = 10000;
h = zeros(muestras,9); p_value = zeros(muestras,9);
jbstat = zeros(muestras,9) ; critval = zeros(muestras,9);
alpha = [0.01, 0.05, 0.1];
simsize = [20, 50, 100];
for k = 1:length(alpha)
    sim = exprnd(1,muestras,simsize(k));
    %sim = lognrnd(0,1,muestras, simsize(k));
%    sim = chi2rnd(2,muestras, simsize(k));
%     sim = randn(muestras,simsize(k));
    for j = 1:length(simsize)
        for i = 1:size(sim,1)
            [h(i,3*(k-1)+j), p_value(i,3*(k-1)+j), jbstat(i,3*(k-1)+j), critval(i,3*(k-1)+j)] = jbtest(sim(i,:),alpha(j));
        end
    end
end
tamano = sum(h,1)/muestras*100;
%% tabla con los datos
veinte = tamano(1:3)';
cincuenta = tamano(4:6)';
cien = tamano(7:9)';
p_value = alpha';
T_exp = table(p_value,veinte,cincuenta,cien)

%chi2cdf(jbstat,2)