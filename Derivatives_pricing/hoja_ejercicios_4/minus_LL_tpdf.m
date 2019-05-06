function minus_LL  = minus_LL_tpdf(pars,X)
%
mu = pars(1); sigma = pars(2); nu = pars(3)
minus_LL = -mean(log(tpdf((X-mu)/sigma,nu)/sigma + eps));








