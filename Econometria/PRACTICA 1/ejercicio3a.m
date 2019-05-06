n = 10^6; %num muestras
r(:,1) = ones(n,1)*0.12;
for i = 2:3
    r(:,i) = 0.01 + 0.9 * r(:,i-1)+0.02*randn(n,1);
end
r_order = sort(r(:,3));

%% Percentil 1%
VaR = 10000*(r_order(round(n*0.5))-r_order(round(n*0.01)))
hist(r_order,30)

