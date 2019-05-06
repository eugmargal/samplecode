a = 4; X1 = linspace(-a,a,50); X2 = linspace(-a,a, 50);
[X1,X2] = meshgrid(X1,X2);
f = @(x1,x2)(exp(-0.5*(x1.^2+x2.^2)));
figure(1); mesh(X1,X2,f(X1,X2))