function minus_LL  = minus_LL_tpdf_AR1_GARCH11(pars,X)
%
phi0 = pars(1); phi1 = pars(2); 
kappa = pars(3); alpha = pars(4); beta = pars(5); nu = pars(6);
U(1) = X(1)-mean(X);
U(2:length(X)) = X(2:end)-(phi0+phi1*X(1:end-1));
h(1) = U(1)^2;
for t = 2: length(X)
    h(t) = kappa + alpha*U(t-1).^2 + beta*h(t-1);
end
sigma = sqrt(h);
minus_LL = -mean(log(tpdf(U(2:end)./sigma(2:end),nu)./sigma(2:end) + eps));








