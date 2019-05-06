%Definición de las condiciones iniciales
t0 = 2.0; T = 3.0; N = 10; M = 100;
mu = 0; sigma = 1; B0 = 100;
B = ArithmeticBrownian(t0,T,M,N,mu,sigma,B0);
Bup = B0+mu+sigma; Blow = B0-mu-sigma;
out = zeros(M,5);
for i = 1:M    %comprueba las condiciones especificadas (estan en orden)
    out(i,1) = any(B(i,:)>Bup);  
    out(i,2) = any(B(i,:)>Bup) || any(B(i,:)<Blow);
    out(i,3) = (any(B(i,:)>Bup)) && (any(B(i,:)<Blow));
    out(i,4) = all(B(i,:)<Bup);
    out(i,5) = (all(B(i,:)<Bup)) || (all(B(i,:)>Blow));
end

