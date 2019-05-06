t = [1/12 1/4 1/2 1 3 5 ]
precioBono = [0.9985 0.9962 0.9930 0.9836 0.9181 0.8479]
B = 1;
b0 = 4 ; b1 = -2; b2 = -5; tau = 0.5;
parameters = [b0 b1 b2 tau];
x0 = parameters;
fun = @(parameters)ECM_BonoNS(parameters,t,precioBono,B);
[parameters,ECM] = fminunc(fun,x0);
parameters
[r,precioBonoNS] = NelSieg(t,parameters(1),parameters(2),parameters(3),parameters(4),B)
figure(1);plot(t,r);
figure(2);plot(precioBono,t,precioBonoNS,t)