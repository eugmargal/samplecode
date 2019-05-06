function minus_LL  = minus_LL_tpdf_AR1(pars,X)
%
phi0 = pars(1); phi1 = pars(2); 
sigma = pars(3); nu = pars(4)
U = X(2:end)-(phi0+phi1*X(1:end-1));
minus_LL = -mean(log(tpdf(U/sigma,nu)/sigma+ eps));








