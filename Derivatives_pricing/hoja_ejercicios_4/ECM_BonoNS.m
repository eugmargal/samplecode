function ECM = ECM_BonoNS(parameters,t,precioBono,B)
% ECM_BonoNS
%
% parameters : Vector de parámetros del modelo Nelson-Siegel
% [b0, b1, b2, tau]
% t : Vector de tiempos
% precioBono : Vector de precios de bonos.
%
% EJEMPLO:
%
% t = [1/12 1/4 1/2 1 3 5 ]
% precioBono = [0.9985 0.9962 0.9930 0.9836 0.9181 0.8479]
% B = 1;
% b0 = 4 ; b1 = -2; b2 = -5; tau = 0.5;
% parameters = [b0 b1 b2 tau];
% ECM = ECM_BonoNS(parameters,t,precioBono,B)
%%
if exist('options','var') == 0 | isempty(options)
   options  =  optimset('fmincon');
   options  =  optimset(options , 'Diagnostics' , 'on');
   options  =  optimset(options , 'Display'     , 'iter');
   options  =  optimset(options , 'LargeScale'  , 'off');
end
[~,precioBonoNS] = NelSieg(t,parameters(1),parameters(2),parameters(3),parameters(4),B);

ECM = mean((precioBono-precioBonoNS).^2);
