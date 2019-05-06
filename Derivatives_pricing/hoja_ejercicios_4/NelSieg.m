function [r,precioBono] = NelSieg(t,b0,b1,b2,tau,B)
% NelSieg: Modelo TI Nelson y Siegel
%
% SINTAXIS:
% [r,precioBono] = NelSieg(t,b0,b1,b2,tau,B)
%
% r : Vector de tipos de interés futuros calculados
% por NS
% precioBono : Vector de precios de bonos que paga B
% calculados por NS.
% B : Pago del bono a vencimiento
% t : Vector de tiempos
% parameters : Vector de parámetros del modelo Nelson-Siegel
% [b0, b1, b2, tau]
% Se supone que b0,b1,b2 están en % y tau en años
%
% EJEMPLO 1:
% t = [1/12 3/12 6/12 1 3 5 10] ;
% b0 = 4; b1 = -2; b2 = -5; tau = 0.5; B = 100;
% [r,precioBonoNS] = NelSieg(t,b0,b1,b2,tau,B);
% 
% for n = 1: length(t)
% precioBonoNS_quadl(n) = ...
% B*exp(-0.01*quadl(@(t)NelSieg(t,b0,b1,b2,tau,B),0,t(n)));
% end
% precioBonoNS_quadl
% precioBonoNS % Deberia dar el mismo valor
%
r = b0+b1*exp(-t/tau)+b2*t.*exp(-t/tau)/tau;
integral = b0*t+b1*tau*(1-exp(-t/tau))+b2*tau-b2*(t+tau).*exp(-t/tau);
precioBono = B*exp(-integral/100);