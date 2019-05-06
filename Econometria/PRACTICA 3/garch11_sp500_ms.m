%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
global vyt
load sp500.txt -ascii;
r=log(sp500(2:end)./sp500(1:end-1)); vyt=r;
T=length(r);
mu=mean(r);
vsigma2t=(r-mu).^2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mu0_1=mu;
mu0_2=mu+0.000001;
delta10=0.5;
alpha10=0.3;
delta10tr=log(delta10/(1-delta10-alpha10));
alpha10tr=log(alpha10/(1-alpha10-delta10));
k0_1=(1-delta10-alpha10)*std(vyt)^2;
k0_2=(1-delta10-alpha10)*std(vyt)^2+0.000000001;
k0tr_1=log(k0_1);
k0tr_2=log(k0_2);
p11=0.95;
p22=0.95;
p11tr=log(p11/(1-p11));
p22tr=log(p22/(1-p22));
th0tr=[mu0_1,mu0_2,k0tr_1,k0tr_2,delta10tr,alpha10tr,p11tr,p22tr];
% th0tr = [mean(r), mu+0.000001, var_largo plazo, var largo plazo+0.00001,
% alpha, beta, log(p11/(1-p11)), log(p22/(1-p22))]
options=optimset('Display','iter','MaxFunEvals',10000,...
    'MaxIter',10000,'TolFun',0.00001);
thtropt=fminsearch('lfv1c_ms2',th0tr,options);  %fminsearch('lfv1c',th0tr,options); %thtropt=fminunc('lfv',thtr0,options);
% thtropt=fminsearch('lfv1c_ms2',th0tr,options);  %fminsearch('lfv1c',th0tr,options); %thtropt=fminunc('lfv',thtr0,options);
muopt_1=thtropt(1);
muopt_2=thtropt(2);
kopt_1=exp(thtropt(3));
kopt_2=exp(thtropt(4));
delta1opt=exp(thtropt(5))/(1+exp(thtropt(6))+exp(thtropt(5)));
alpha1opt=exp(thtropt(6))/(1+exp(thtropt(5))+exp(thtropt(6)));
p11=exp(thtropt(7))/(1+exp(thtropt(7)));
p22=exp(thtropt(8))/(1+exp(thtropt(8)));
%
P=[p11    1-p22;
   1-p11  p22];
%
[lfv,vsigma2,xitt,xit1t]=lfv1c_ms(thtropt);
%
%smoothing (Kim's algorithm)
xitT=zeros(T-1,2);
xitT=[xitT; xitt(T,:)];
for t=1:T-1
    a=xitt(T-t,:)'.*(P'*(xitT(T-t+1,:)'./xit1t(T+1-t,:)'));
    xitT(T-t,:)=a';
end
figure;
%xx=1:1:length(vsigma2);xx=xx';
subplot(3,1,1);
plot([vsigma2t vsigma2]);
legend('resid^2','sigma^2 estimated');
subplot(3,1,2);
plot(vsigma2);
title('sigma^2 estimated');
subplot(3,1,3)
plot(xitT(:,1));
title('probabilidad del régimen 1')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
thopt=[muopt_1 muopt_2 kopt_1 kopt_2 delta1opt alpha1opt p11 p22]'; 
x0=thopt; n=length(x0);
%     % Calculando el gradiente numéricamente
%     auxi=1e-7*eye(n); auxi(2,2)=0.000000001;
%     Grad0=zeros(n,1);
%     for i=1:n
%         Grad0(i)=(feval('lfv_s1',x0+auxi(:,i))-feval('lfv_s1',x0-auxi(:,i)))/...
%             (2*auxi(i,i));
%     end
    
    % Calculando el hessiano numéricamente
    H0=zeros(n,n);
    auxi=diag(x0.*1e-6); auxi(7,7)=0.00001; auxi(8,8)=auxi(7,7); %1e-5*eye(n);auxi(2,2)=0.000000001;
    for i=1:n
        for j=1:n
            H0(i,j)=(feval('lfv_s1_ms',x0+auxi(:,i)+auxi(:,j))-...
                        feval('lfv_s1_ms',x0+auxi(:,i))-...
                        feval('lfv_s1_ms',x0+auxi(:,j))+...
                        feval('lfv_s1_ms',x0))/(auxi(j,j)^2);
        end
    end   
informd=inv(H0);
sgd=sqrt(diag(informd));
display('estimaciones de mu,alpha,delta y k y sus desviaciones típicas');
format long;
%[x0 sgd]

% Tabla de estimaciones
names_var={'mu_1       ';
           'mu_2       ';
           'alpha_{0,1}';
           'alpha_{0,2}';
           'beta_1     ';
           'alpha_1    ';
           'p_{11}     ';
           'p_{22}     '};
coefficient=x0;
Std_Error=sgd;
t_statistic=coefficient./Std_Error;
p_value=1-normcdf(abs(t_statistic),0,1);p_value=2*p_value; %dos colas
disp('_________________________________________________________________________________________________________________')
disp('Coeficientes estimados')
TABLA1=table(coefficient,Std_Error,t_statistic,p_value,'RowNames',names_var)
