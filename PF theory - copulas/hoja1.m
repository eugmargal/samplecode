yield = [0.25; 0.09; 0.05]
covmatriz = [0.7, 0.1, -0.06; 0.1, 0.5, -0.1; -0.06, -0.1, 0.1]
%% Matriz de correlaciones
corr_matriz = corrcov(covmatriz);

%% Apartado B (PCTR)
weight = ones(1,3)/3;
%weight = [0.2, 0.6, 0.2];
std_B = sqrt(dot(weight,(covmatriz*weight')',2)); 
MCTR = (covmatriz*weight'/std_B)'
PCTR = weight.*MCTR/std_B

%% Apartado C - MV portfolio for stocks 1 & 3
weight = rand(4000,2);
weight = [weight./sum(weight,2)];
covmatriz13 = covmatriz([1,3],[1,3]);
yield13 = yield([1,3]);
mean1 = weight*yield13;
std1 = sqrt(dot(weight,(covmatriz13*weight')',2));
[PRisk, PRoR, PWts] = NaiveMV(yield13, covmatriz13, 1000);
figure(1);
title('Frontera Media-Varianza')
ylabel 'Rendimiento medio';
xlabel 'Desviación típica';
hold on
scatter(std1,mean1,1)
scatter(PRisk,PRoR);
hold off
[min_risk,position] = min(std1);
disp(['The mean of the MV portfolio is: ', num2str(mean1(position))])
disp(['Composition of the MV portfolio is:     ', num2str(weight(position,:))])
disp(['The risk of the MV portfolio is: ', num2str(min_risk)])

%% Apartado D - Long position graphic
%rng(1)
weight = rand(4000,3);
weight = [weight./sum(weight,2)];
%control = sum(weight,2);
mean1 = weight*yield;
std1 = sqrt(dot(weight,(covmatriz*weight')',2));
figure(2);
scatter(std1,mean1,1)
title('Conjunto de oportunidades de inversión (solo posciciones largas)')
ylabel 'Rendimiento medio de la cartera';
xlabel 'Volatilidad de la cartera';
%% Apartado E - short positions
l = ones(size(yield,1),1);
A = l'*inv(covmatriz)*yield;
B = yield'*inv(covmatriz)*yield;
C = l'*inv(covmatriz)*l;
D = B*C - A^2;
g = (B*(inv(covmatriz)*l)-A*(inv(covmatriz)*yield))/D;
h = (C*(inv(covmatriz)*yield)-A*(inv(covmatriz)*l))/D;
short_weight = g' + (weight*yield)*h';
std_short = sqrt(dot(short_weight,(covmatriz*short_weight')',2));
points = linspace(0,1,1000);
limsup = A/C + sqrt(D/C)*points;
figure(3);
title('Frontera eficiente (EF) permitiendo posiciones cortas')
ylabel 'Rendimiento medio de la cartera';
xlabel 'Volatilidad de la cartera';
hold on
scatter(std_short,mean1,1)
plot(points,A/C + sqrt(D/C)*points,'Color',[.7,.7,.7])
plot(points,A/C - sqrt(D/C)*points,'Color',[.7,.7,.7])


%% Apartado F
%w_d = inv(covmatriz)*yield/A;
w_gmv = inv(covmatriz)*l/C;
gmv_yield = w_gmv'*yield
gmv_theo_y = A/C
gmv_var = w_gmv'*covmatriz*w_gmv
gmv_theo_var = 1/C
scatter(sqrt(gmv_var),gmv_yield,30,'filled')
text(sqrt(gmv_var),gmv_yield,'\leftarrow mvp')
% scatter(sqrt(gmv_theo_var),gmv_theo_y,30,'filled')
% text(sqrt(gmv_theo_var),gmv_theo_y,'\leftarrow theoretical mvp')

%% Apartado E
w_d = inv(covmatriz)*yield/A;
d_yield = w_d'*yield;
d_var = w_d'*covmatriz*w_d;
d_std = d_var^0.5;
scatter(sqrt(d_var),d_yield,30,'filled')
text(sqrt(d_var),d_yield,'\leftarrow max return/unit risk')

%% Apartado F
% rendimiento esperado 5%
alpha_1 = (0.05-d_yield)/(gmv_yield-d_yield)
variation_1 = alpha_1^2*gmv_var + (1-alpha_1)^2*d_var + 2*alpha_1*(1-alpha_1)*(w_d'*covmatriz*w_gmv);
scatter(sqrt(variation_1),0.05,30,'filled')
text(sqrt(variation_1),0.05,'\leftarrow 5% return')

% rendimiento esperado 15%
alpha_2 = (0.15-d_yield)/(gmv_yield-d_yield)
variation_2 = alpha_2^2*gmv_var + (1-alpha_2)^2*d_var + 2*alpha_2*(1-alpha_2)*(w_d'*covmatriz*w_gmv);
scatter(sqrt(variation_2),0.15,30,'filled')
text(sqrt(variation_2),0.15,'\leftarrow 15% return')
hold off

%% Apartado H
w_dummy = A*(w_d - w_gmv);
b = [0.5 0.3 0.1];
for i = 1:length(b)
    w_G(:,i) = w_gmv + w_dummy/b(i);
end
w_pfH = w_G * [0.6 ; 0.25 ; 0.15];
mean_H = w_pfH'*yield;
std_H = sqrt(dot(w_pfH',(covmatriz*w_pfH)',2));
w_G_b =w_G';
mean_G = w_G_b*yield;
var_G = w_G_b*(covmatriz*w_G_b');
%var_G_b=var_G';
diag_var_G = diag(var_G);
std_G = diag_var_G.^(0.5);
stdTotal = [std_H;std_G];
meanTotal =[mean_H ; mean_G];

%covmatriz_pfH = w_G'*covmatriz*w_G;
%std_H = [std_H ; [0.6 ; 0.25 ; 0.15]'*covmatriz_pfH*[0.6 ; 0.25 ; 0.15]]
figure(4)
title('Frontera eficiente (EF) permitiendo posiciones cortas')
ylabel 'Rendimiento medio de la cartera';
xlabel 'Volatilidad de la cartera';
scatter(std_short,mean1,1)
hold on
scatter(std_H,mean_H,50,'filled')
scatter(std_G,mean_G,50,'filled')
% for i =1:length(mean_H)
%     scatter(std_H(i),mean_H(i),30,'filled')
%     %text(std_H(i),mean_H(i),'\leftarrow return')
% end
hold off


alpha_H = (mean_H-d_yield)/(gmv_yield-d_yield); %ponderaion maxima rentabilidad: alpha // 1-alpha:ponderacion gmv
w_H_mvp_d = alpha_H'*w_gmv'+(1-alpha_H)'*(w_d');
mu_H_mvp_d = d_yield + alpha_H*(gmv_yield-d_yield);

%% Apartado I
r = 0.04;
weight_i = covmatriz\(yield-r*ones(3,1))/(ones(1,3)*(covmatriz\(yield-r*ones(3,1))));
mean_i = weight_i'*yield;
std_i = sqrt(weight_i'*covmatriz*weight_i);
weight_ii = [0.5 , 0.15, 0.2, 0.15];
mean_ii = weight_ii * [r ; yield];
rcovmatriz = zeros(4);
rcovmatriz(2:4,2:4) = covmatriz;
std_ii = sqrt(weight_ii*rcovmatriz*weight_ii');
graph_i = r + (mean_i - 0.04)/std_i*points;
figure(5);
title('Línea de asignación de capital (CAL)')
ylabel 'Rendimiento medio de la cartera';
xlabel 'Volatilidad de la cartera';
hold on
scatter(std_short,mean1,1)
scatter(std_i,mean_i,30,'filled')
scatter(std_ii,mean_ii,30,'filled')
plot(points,graph_i)
hold off
legend('','','','Location','northwest');

%% Apartado M
[PRisk, PRoR, PWts] = NaiveMV(yield, covmatriz, 1000);
figure(6);
title('Frontera eficiente (EF) no permitiendo posiciones cortas');
ylabel 'Rendimiento medio de la cartera';
xlabel 'Volatilidad de la cartera';
scatter(PRisk,PRoR,5,'filled');

%% Apartado N
lambda = chol(corr_matriz,'lower');
diag_dt = diag(sqrt(diag(covmatriz)));
weights_z = randn(100000,3);
% weights_z = weights_z./sum(weights_z,2);
R = (yield + diag_dt*lambda*weights_z')';
N_mean = mean(R*w_gmv)
N_std = std(R*w_gmv).^2
N_skew = skewness(R*w_gmv)
N_kurt = kurtosis(R*w_gmv)

tableN = array2table([ N_mean, N_std, N_skew, N_kurt; gmv_yield, gmv_var, 0,3])
tableN.Properties.VariableNames = {'mean' 'var' 'skewness' 'kurtosis'}

