function [X,u,h] = simARMAGARCH(M,T,phi0,phi1,theta,kappa,alpha,beta,X0,u0,h0)
% simARMAGARCH : Simulación de un proceso ARMA(p,q) + GARCH(r,s)
%
%% Sintaxis:
% X = simARMAGARCH(M,T,phi0,phi1,theta,kappa,alpha,beta,X0,u0,h0)
%
%% INPUT:
%                    M : Numero de trayectorias simuladas
%                    T : Pasos para la simulación
%       phi0,phi1,theta : Parámetros que caracterizan el proceso ARMA(p,q)
%     kappa,alpha,beta : Parámetros que caracterizan el proceso GARCH(r,s)
%                   X0 : Valores iniciales de la serie temporal
%                   u0 : Valores iniciales de las innovaciones
%                   h0 : Valores iniciales de la volatilidad
%
%% OUTPUT:
%                    X : Matriz (M,T) que contiene las M trayectorias simuladas
%                    u : Matriz (M,T) que contiene la matriz de errores sqrt(ht)*error_t
%                    h : Matriz (M,T) que contiene el modelo GARCH(r,s)
%
%% Ejemplo 1: Simulación ARMA(2,3) + GARCH(1,2)
% M = 3; T = 1000; d = 3;
% phi0 = 0.0; phi1 = [0.4 -0.2]; theta = [0.3 -0.6 0.1];
% kappa = 0.1; alpha = 0.1; beta = [0.6 0.2];
% X0 = [0 0 0]; u0 = [0 0 0]; h0 =kappa/(1-sum(alpha)-sum(beta))*ones(1,d);
% [X,u,h]=simARMAGARCH(M,T,phi0,phi1,theta,kappa,alpha,beta,X0,u0,h0);
% diasEnAnyo = 250;
% S0 = 100; dT = 1/diasEnAnyo; S = cumprod([S0*ones(M,1) exp(X*dT)],2);
% figure(1); subplot(3,1,1); plot(1:T,X(:,1:T)); ylabel('Rendimiento');
% subplot(3,1,2); plot(1:T,S(:,1:T)); ylabel('Precio');
% subplot(3,1,3);
% plot(1:T,sqrt(diasEnAnyo*h(1,1:T)));ylabel('Volatilidad');
% figure(2); autocorr(X(1,:),30);
% figure(3); subplot(2,1,1); autocorr(u(1,:),30);
% subplot(2,1,2); autocorr(abs(u(1,:)),30);
%
%% Ejemplo 2: Simulación AR(1)
% M = 1; T = 1000; phi0 = 0.0; phi1 = -0.7; sigma = 0.25;
% theta = []; kappa = sigma; alpha = []; beta = []; % simula AR(1)
% X0 = 0; u0 = 0; h0 = sigma;
% [X,u,h]=simARMAGARCH(M,T,phi0,phi1,theta,kappa,alpha,beta,X0,u0,h0);
% figure(1); plot(1:T,X(:,1:T));
% figure(2); T1 = 50; plot(1:T1,X(:,1:T1));
% figure(3); autocorr(X(1,:),30);
% figure(4); subplot(2,1,1); autocorr(u(1,:),30);
% subplot(2,1,2); autocorr(abs(u(1,:)),30);
% figure(5); plot(1:T,h(1,:));
%
%% Ejemplo 3: Simulación AR(1) + GARCH(1,1)
% M = 1; T = 1000;
% phi0 = 0.0; phi1 = 0.15;
% theta = [];
% kappa = 0.1; alpha = 0.10; beta = 0.7;
% X0 = 0; u0 = 0; h0 = kappa/(1-alpha-beta);
% [X,u,h]=simARMAGARCH(M,T,phi0,phi1,theta,kappa,alpha,beta,X0,u0,h0);
% diasEnAnyo = 250;
% S0 = 100; dT = 1/diasEnAnyo; S = cumprod([S0*ones(M,1) exp(X*dT)],2);
% figure(1); subplot(3,1,1); plot(1:T,X(:,1:T)); ylabel('Rendimiento');
% subplot(3,1,2); plot(1:T,S(:,1:T)); ylabel('Precio');
% subplot(3,1,3);
% plot(1:T,sqrt(diasEnAnyo*h(1,1:T)));ylabel('Volatilidad');
% figure(2); autocorr(X(1,:),30);
% figure(3); subplot(2,1,1); autocorr(u(1,:),30);
% subplot(2,1,2); autocorr(abs(u(1,:)),30);
%
%%   Introducir los vectores en fila->indican columna de t=1,2...
%                               1   4   X13    X14 ...
%     [1 2 3 ; 4 5 6]    ->     2   5   X23    X24 ...
%                               3   6   X33    X34 ...
%%   Define el valor de p,q,r,s
P = length(phi1);
Q = length(theta);
R = length(alpha);
S = length(beta);
%% si el vector esta vacio entonces se rellena con 0, evita errores despues
if isempty(phi0) == 1 phi0=0; end
if isempty(phi1) == 1 phi1=0;  end
if isempty(theta) == 1 theta=0;  end
if isempty(kappa) == 1 kappa=0;  end
if isempty(alpha) == 1 alpha=0;  end
if isempty(beta) == 1 beta=0;  end
%% Inicializa las variables y las organiza adecuadamente
t0 = max([size(X0,2),size(u0,2),size(h0,2)]);   %calcula el vector inicial de mayor longitud
h=zeros(M,T); X = zeros(M,T); u = zeros(M,T); perturb = rand(M,T); %Create all matrix
h(:,1:size(h0,1)) = h0'; X(:,1:size(X0,1)) = X0'; u(:,1:size(u0,1)) = u0'; %Escribe los valores iniciales a las primeras columnas de los finales
%Para h0,X0,u0 se consideran 3 casos:
%   - que sean vectores vacios ->se rellenan con num aleat uniformes
%   - que tengan dim multiplo de t0->se rellenan en los vacios
%   - no multiplos: las columnas restantes se rellenan con n aleat uniformes
if size(h0',2) < t0
    if isempty(h0) == 1
        h(:,1:t0) =rand(M,t0);
    elseif mod(t0,size(h0',2)) ~= 0
        h(:,size(h0',2)+1:t0) = rand(M,t0-size(h0',2));
    else
        h(:,size(h0',2)+1:t0) = repmat(h0',1,t0-size(h0',2));
    end
end
if size(u0',2) < t0
    if isempty(u0) == 1
        u(:,1:t0) =rand(M,t0);
    elseif mod(t0,size(u0',2)) ~= 0
        u(:,size(u0',2)+1:t0) = rand(M,t0-size(u0',2));
    else
        u(:,size(u0',2)+1:t0) = repmat(u0',1,t0-size(u0',2));
    end
end
if size(X0',2) < t0
    if isempty(X0) == 1
        X(:,1:t0) =rand(M,t0);
    elseif mod(t0,size(X0',2))~= 0
        X(:,size(X0',2)+1:t0) = rand(M,t0-size(X0',2));
    else
        X(:,size(X0',2)+1:t0) = repmat(X0',1,t0-size(X0',2));
    end
end
%% Implementacion de las proceso estocastico ARMA(p,q)+GARCH(r,s)
%   Los sumatorios se realizan seleccionando los elementos correspondientes
%   del vector, dandoles la vuelta (flip), multiplicarlo por los
%   coeficientes y sumando los elementos del vector resultante
for j=t0+1:T
    h(:,j) = kappa+sum(alpha.*flip(u(:,j-R:j-1)),2)+sum(beta.*flip(h(:,j-S:j-1)),2);
    u(:,j) = sqrt(h(:,j)).*perturb(:,j);
    X(:,j) = phi0 + sum(phi1.*flip(X(:,j-P:j-1)),2) + sum(theta.*flip(u(:,j-Q:j-1)),2)+u(:,j);
end
