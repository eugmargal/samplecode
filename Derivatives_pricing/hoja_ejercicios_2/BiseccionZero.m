function [x_med, err] = BiseccionZero(f,a,b)
%% SYNTAX:
%        [x_med, err] = BiseccionZero(f,a,b)
%
%% ENTRADA:
%            f: funcion
%        [a,b]: Intervalo que acota al cero
%
%% SALIDA:
%        x_med: estimación del cero de la función
%          err: error de la estimación
%
%% PROCESAMIENTO:
% Inicialmente, el error de estimacion es: err = (b-a)
% Repetir hasta convergencia
% 1. Calculamos el punto medio del intervalo: x_med = (a+b)/2.0;
% 2. Actualizamos el error de estimacion: err = err/2
% 3. Si f(a)*f(x_med) < 0, buscamos el cero en [a,x_med]
% 4. Si f(b)*f(x_med) < 0, buscamos el cero en [x_med,b]

%% EJEMPLO 1:
%       S0 = 100; K = 90; r = 0.1; T = 2; precio = 7.81; A = 10;
%       a = 0; b = 1;
%       payoff = @(ST) A .* (ST>K); %Opcion digital que paga A si ST>K
%       f = @(sigma)(priceEuropeanOption(S0,r,T,sigma,payoff)- precio);
%       [x_med, err] = BiseccionZero(f,a,b)
%       x_med_newton = fzero(f,0.5)
%%
TOL_ABS = 1e-6;         % error absoluto
TOL_REL = 1e-16;        % error relativo
TOL_f = 1e-10;          % valor minimo positivo que puede distinguir f
err= b-a;
x_med = (a+b)/2;
while err>TOL_ABS || abs(err/x_med) < TOL_REL || abs(f(x_med)) < TOL_f
    x_med = (a+b) / 2;
    if f(a).*f(x_med) < 0
        b = x_med;
    else a = x_med;
    end
    err = err / 2;
end

