mu0=mu;
delta10=0.8;
alpha10=0.12;
delta10tr=log(delta10/(1-delta10-alpha10));
alpha10tr=log(alpha10/(1-alpha10-delta10));
k0=(1-delta10-alpha10)*0.4;  %*std(vyt)^2;
k0tr=log(k0);
th0tr=[mu0,k0tr,delta10tr,alpha10tr];
options=optimset('Display','iter','MaxFunEvals',10000,...
    'MaxIter',10000,'TolFun',0.00001);
thtropt=fminsearch(@(thtr)(lfv1c(thtr,vyt)),th0tr,options); %thtropt=fminunc('lfv',thtr0,options);
muopt=thtropt(1);
delta1opt=exp(thtropt(3))/(1+exp(thtropt(4))+exp(thtropt(3)));
alpha1opt=exp(thtropt(4))/(1+exp(thtropt(3))+exp(thtropt(4)));
kopt=exp(thtropt(2));
[lfv,vsigma2]=lfv1c(thtropt,vyt);
figure;
plot([vsigma2t vsigma2]);


N = 1000 % num simulaciones
%% Paso 1
at = vyt - thtropt(1);

%% Paso 2
epsilont = at./sqrt(vsigma2);

%% Paso 3
for i = 1:N
    epsrand(:,i) = epsilont(randperm(length(epsilont)));
end

%% Paso 4
anew = sqrt(vsigma2).*epsrand;

%% Paso 5
rnew = thtropt(1)*ones(length(vyt),1) + anew;

%% Paso 6
for i = 1:N
    thtropt=fminsearch(@(thtr)(lfv1c(thtr,rnew(:,i))),th0tr,options); %thtropt=fminunc('lfv',thtr0,options);
    muopt=thtropt(1);
    delta1opt=exp(thtropt(3))/(1+exp(thtropt(4))+exp(thtropt(3)));
    alpha1opt=exp(thtropt(4))/(1+exp(thtropt(3))+exp(thtropt(4)));
    kopt=exp(thtropt(2));
    [lfv,sigma2new(:,i)]=lfv1c(thtropt,vyt);
    param(:,i) = [muopt', delta1opt', alpha1opt', kopt'];
end

%% Paso 7
mediana = median(sigma2new,2);
quantile5 = quantile(sigma2new, 0.05, 2);
quantile1 = quantile(sigma2new, 0.01, 2);

figure; hold on
plot(mediana, 'Color', 'k');
plot(quantile5, 'Color', 'r');
plot(mediana + (mediana - quantile5), 'Color', 'r');
plot(vsigma2t,'Color', 'b');
title('Banda de confianza al 5%'); ylabel('\sigma')
legend('varianza media','banda de confianza', 'banda de confianza', 'varianza rend','Location','NorthWest')
hold off

figure; hold on
plot(mediana, 'Color', 'k');
plot(quantile1, 'Color', 'r');
plot(mediana + (mediana - quantile1), 'Color', 'r');
plot(vsigma2t,'Color', 'b');
title('Banda de confianza al 1%'); ylabel('\sigma')
legend('varianza media','banda de confianza', 'banda de confianza', 'varianza rend','Location','NorthWest')
hold off
