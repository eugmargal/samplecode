mu = 1.35; 
sigma = 0.25; 
alpha = 2.0; 
f = @(x)normpdf(x,mu,sigma); 

% se construye la función de densidad de una variable aleatoria normal de media 1,35 y desviación típica 0,25, llamándola f

x_inf = mu-alpha*sigma; 
x_sup = mu+alpha*sigma; 

% se  establecen  unos valores (que van a ser los límites de integración) alrededor de la media: 1,35 ± 0,25*2.
 
TOL_ABS = 1.0e-6; 

% Se define también un error admitido para el cálculo de la integral de 0,000001
quadl(f,x_inf,x_sup,TOL_ABS) 
 
%Se calcula la integral con la función quadl de la función de densidad entre 0,85 y 1,85.
