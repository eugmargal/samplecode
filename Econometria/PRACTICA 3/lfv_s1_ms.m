function [lfv,vsigma2_rc,xitt,xit1t]=lfv_s1_ms(th)
% el modelo: y(t)=mu+z(t)*sigma(t), z(t)~N(0,1), e(t)=z(t)*sigma(t)
% sigma2(t)=k+alpha*e(t)^2+delta*sigma2(t)
%
global vyt
T=length(vyt);
th=real(th);
N=2;
%
mu_1=th(1);
mu_2=th(2);
k_1=th(3);
k_2=th(4);
delta1=th(5);
alpha1=th(6);
p11=th(7);
p22=th(8);
%
P=[p11    1-p22;
   1-p11  p22];  %matriz de probabilidad de transición de la cadena de markov
A=[eye(N)-P; ones(1,N)];
eN1=[zeros(N,1);
        1];
ppi=inv(A'*A)*A'*eN1;  %probabilidades ergódicas
%
e20=std(vyt)^2;%0.4; %std(vyt)^2;
sigma20=std(vyt)^2;%0.4; %std(vyt)^2;
eta=zeros(T,N);
xitt=zeros(T,N);
xit1t=zeros(T,N);
vsigma2_1=zeros(T,1);
vsigma2_2=zeros(T,1);
vsigma2_rc=zeros(T,1); %varianza recombinada
%Condición inicial para la probabilidad de estar en el régimen i={1,2} en
%el instante t condicionado a la información hasta t-1
xi10=ppi';   %condición inicial=probabilidades ergódicas
p10=xi10(1);
p20=xi10(2);
%
for t=1:T
    resid_1=vyt(t)-mu_1;
    resid_2=vyt(t)-mu_2;
    %
    sigma21_1=k_1+delta1*sigma20+alpha1*e20;
    vsigma2_1(t)=sigma21_1;
    sigma21_2=k_2+delta1*sigma20+alpha1*e20;
    vsigma2_2(t)=sigma21_2;
    eta(t,1)=(1/((2*pi*sigma21_1)^0.5))*exp(-0.5*(resid_1^2)/sigma21_1);
    eta(t,2)=(1/((2*pi*sigma21_2)^0.5))*exp(-0.5*(resid_2^2)/sigma21_2);
    %
    xitt(t,:)=(xi10.*eta(t,:))/((xi10.*eta(t,:))*ones(N,1));
    xit1t(t,:)=xitt(t,:)*P';
    %
    p10=xit1t(t,1);
    % Varianza recombinada
    sigma2_rc=p10*(mu_1^2+sigma21_1)+(1-p10)*(mu_2^2+sigma21_2)-...
              (p10*mu_1+(1-p10)*mu_2)^2;
    vsigma2_rc(t)=sigma2_rc;  
    % Residuos recombinados
    residrc=p10*resid_1+(1-p10)*resid_2;
    %Actualizar
    sigma20=sigma2_rc;
    e20=residrc^2;
    xi10=xit1t(t,:);
end
xit1t=[xi10;xit1t];
f=(xit1t(1:T,:).*eta)*ones(N,1);
lf=log(f);
lfv=ones(1,T)*lf;
lfv=-lfv;
end

