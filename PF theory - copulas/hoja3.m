%%Ejercicio 3:
%% Apartado d:

lambda1=0.9;
[x,y]=meshgrid(0:0.01:1,0:0.01:1);
z1 = 1+lambda1*(2*x-1).*(2*y-1);
figure(1)
contour(x,y,z1)
title ('Curvas de nivel - Lambda = 0.9');

lambda2=-0.8;
z2 = 1+lambda1*(2*x-1).*(2*y-1);
figure(2)
contour(x,y,z2)
title ('Curvas de nivel - Lambda = -0.8');

%% Primera parte: Generación números aleatorios dependientes

N=10000; 
rand('state',10)
epsi = rand(N,2);%indep. U(0,1) random matrix of order (N,2)
u = rand(N,1);
v = rand(N,1);
A = 1+lambda1*(1-2*u);
B = sqrt(A.^2 - 4*(A-1).*v);
w = 2*v./(A+B);

epsi = [u,w];
lambda=0.5;

%Parameters of the bivariate pdf given by (I)
%f(r1,r2)=alfa2 + beta2*r1 + gamma2*r2

alfa2=0.0642;
beta2=0.0049;
gamma2=0.0296;

%Conditional sampling
%Conditional distribution from bivar. distrib. = F(r1|r2)

%(a) Marginal cumulative distribution of r2 (section b): G(r2)
% G(u_2)=u_2;

G0=0;
G1=1;
G2=0;

%(b) Marginal pdf of u2 = 1 (section a)
% u2 belongs to [0,1]


v2=zeros(N,1); %draws from r2
v1=zeros(N,1); %draws from r1

for i=1:N
    
 i   
    
 G3=G0-w(i);
 
 A=[G2 G1 G3];   
 R=roots(A);
 
 if R(1)<0 
 
   v2(i)=R(2);
      
 elseif R(1)> 1
     
   v2(i)=R(2);
 
 else
     
   v2(i)=R(1);
 
 end
 
end


%(c) r1 by conditional sampling
% u belongs to [0,1]


for i=1:N
    
 c1=1;
 c2=0;
 c3=1-2*v2(i)*lambda+lambda;
 c4=2*v2(i)*lambda-lambda;
 
 c5=c2-epsi(i,1)/c1; 
  
 B=[c4 c3 c5];   
 R=roots(B);
 
 if R(1)<0 
 
   v1(i)=R(2);
      
 elseif R(1)> 1
     
   v1(i)=R(2);
 
 else
     
   r1(i)=R(1);
 
 end
 
end

figure(3)
plot(v1,v2,'.')
title('Números aleatorios dependientes')

figure(4)
plot(u,v,'.')
title('Números aleatorios independientes')


tic;
 
%% Generación de las variables r1 y r2 a partir de la cópula generada (v1,v2):

%Parameters of the bivariate pdf given by (I)
%f(r1,r2)=alfa2 + beta2*r1 + gamma2*r2
 
alfa2=0.0642;
beta2=0.0049;
gamma2=0.0296;

%(b) Marginal cumulative distribution of r1 (section b): H(r1)
% H(r1)=H0+H1*r1+H2*r1^2

H0=0.31117;
H1=0.3222;
H2=0.01103;

r1=zeros(N,1); %draws from r1

for i=1:N
     
 i   
     
 H3=H0-v1(i);
  
 A=[H2 H1 H3];   
 R=roots(A);
  
 if R(1)<-1 
  
   r1(i)=R(2);
       
 elseif R(1)> 2
      
   r1(i)=R(2);
  
 else
      
   r1(i)=R(1);
  
 end
end 

%(b) Marginal cumulative distribution of r2 (section b): G(r2)
% G(r2)=G0+G1*r2+G2*r2^2
 
G0=0.2222;
G1=0.2;
G2=0.0444;

r2=zeros(N,1); %draws from r2

for i=1:N
     
 i   
     
 G3=G0-v2(i);
  
 B=[G2 G1 G3];   
 R=roots(B);
  
 if R(1)<-2 
  
   r2(i)=R(2);
       
 elseif R(1)> 2.5
      
   r2(i)=R(2);
  
 else
      
   r2(i)=R(1);
  
 end
end 
 
%(d) Monte Carlo, w1
 
w1=0.3;
w2=1-w1;
 
Rp=w1*r1+w2*r2;
mRpMC=mean(Rp)  %mean
stdRpMC=std(Rp) %std 


figure(5)
histfit(Rp)
title('Histograma de los rendimientos simulados de la cartera A')
 
% Apartado f:

VaR1=quantile(Rp,0.01); % quantile(1%)
%VaR5=quantile(Rp,0.05) % quantile(5%)

P = Rp<=VaR1;
P_ES = Rp.*P;
P_ES(P_ES==0)=[];
ES = mean(P_ES);