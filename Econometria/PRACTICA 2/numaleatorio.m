clear;
global vyt
rng(1)
T=500;
mu=0.01;
phi=0.96;
a=4;
b=0.2;
vsigma2t=[];
vyt=[];
sigma2t0=a*b;
for t=1:T
u=rand(1,1);
if u<phi
sigma2t=sigma2t0;
yt=mu+sigma2t*randn(1);
vsigma2t=[vsigma2t;sigma2t];
vyt=[vyt;yt];
sigma2t0=sigma2t;
else
sigma2t=gamrnd(a,b);
yt=mu+sigma2t*randn(1);
vsigma2t=[vsigma2t;sigma2t];
vyt=[vyt;yt];
sigma2t0=sigma2t;
end
end
figure;
subplot(2,1,1);
plot(vyt);
title('niveles');
subplot(2,1,2);
plot(vsigma2t);
title('varianza');
