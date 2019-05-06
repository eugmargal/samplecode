[sensitivity] =  xlsread('Datos_Ejercicio_2','Inputs 1','E3:N8');
vertex = [0.25, 0.5, 1, 2, 3, 5, 10, 15, 20, 30];
risk_weight = [0.024, 0.024, 0.0225, 0.0188, 0.0173, 0.015, 0.015, 0.015, 0.015, 0.015]/sqrt(2);
theta = 0.03;
lambda = [0.75, 1, 1.25];
sensEUR = [sensitivity(1,:), sensitivity(2,:), sensitivity(3,:)];
sensUSD = [sensitivity(4,:), sensitivity(5,:)];

for i =1:length(lambda)
    [S_EUR(i), K_EUR(i)] = deltaCC(lambda(i), vertex, risk_weight, sensEUR, 3);       % EURO BUCKET
    [S_USD(i), K_USD(i)] = deltaCC(lambda(i), vertex, risk_weight, sensUSD, 2);       % USD BUCKET
    Delta_normal(i) = sqrt(K_EUR(i)^2 + K_USD(i)^2 + lambda(i)*S_EUR(i)*S_USD(i));    % Delta Capital Charge
end

type = {'low','normal','high'};
resultados = table(type',K_EUR',K_USD',Delta_normal');
resultados.Properties.VariableNames = {'stress_scn' 'K_EUR' 'K_USD' 'Delta'}

sprintf('SBM Capital Charge: %f',max(Delta_normal))


function [S_B, K_B] = deltaCC(lambda, vertex, risk_weight, sensitivity, n_curves)
%% INPUT
%        lambda = stress factor
%        vertex = sensitivities vertex
%   risk_weight = ponderation of each vertex
%   sensitivity = sensitivies to each vertex
%      n_curves = number of curves inside the bucket
%% OUTPUT
%           S_B = summed weighted sensitivity
%           K_B = aggregation at bucket level
%%
theta = 0.03;
correlation = @(x,y)(max(exp(-theta*abs(x-y)./min(x,y)),0.4));
base = correlation(vertex',vertex);
basecorr = correlation(vertex',vertex);     % matriz base de correlaciones, hay un cap si corr=1
corrdiff = 0.999*basecorr;
covmatrix = repmat(basecorr,n_curves,n_curves);
for i = 1:n_curves
    for j = 1:n_curves
        if i ~= j
            covmatrix(10*(i-1)+1:10*i,10*(j-1)+1:10*j) = corrdiff;
        end
    end
end
lambdamatrix = ones(size(covmatrix)).*lambda + diag(ones(1,length(covmatrix))).*(1-lambda)
covmatrix = min(lambdamatrix.*covmatrix,1);

weightvec = repmat(risk_weight,1,n_curves)*10000;
weightedsens = sensitivity.*weightvec;
S_B = sum(weightedsens);
K_B = sqrt(weightedsens*covmatrix*weightedsens');
end