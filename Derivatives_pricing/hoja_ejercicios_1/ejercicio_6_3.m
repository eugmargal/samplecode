clear
mu = 1.35;
sigma = 0.25;
alpha=1;
f = @(x)normpdf(x,mu,sigma);
%
x_inf = mu-alpha*sigma;
x_sup = mu+alpha*sigma;
%
TOL_ABS = 10^-16;
f1=0;
f2=1;
while f1 ~=  f2
    alpha=alpha+1;
    x_inf = mu-alpha*sigma;
    x_sup = mu+alpha*sigma;
    f1=quadl(f,x_inf,x_sup,TOL_ABS);
    f2=quadl(f,x_inf-alpha*sigma,x_sup+alpha*sigma,TOL_ABS);
end
alpha=alpha-2;
    %N es la precisión a la que quiero obtener el número máximo
    for j=1:20
        for i=1:10 %recorre todos los valores de esta posición
            test=alpha+i*10^-j;
            if quadl(f,mu-test*sigma,mu+test*sigma,TOL_ABS)~=1
                continue;
            else
                alpha=alpha+(i-1)*10^-j;
            end
            break;
        end
    end
    vpa(alpha,16)
