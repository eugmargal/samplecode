mu = 1.35; 
sigma = 0.25; 
alpha = 2.0; 
f = @(x)normpdf(x,mu,sigma); 

% se construye la funci�n de densidad de una variable aleatoria normal de media 1,35 y desviaci�n t�pica 0,25, llam�ndola f

x_inf = mu-alpha*sigma; 
x_sup = mu+alpha*sigma; 

% se  establecen  unos valores (que van a ser los l�mites de integraci�n) alrededor de la media: 1,35 � 0,25*2.
 
TOL_ABS = 1.0e-6; 

% Se define tambi�n un error admitido para el c�lculo de la integral de 0,000001
quadl(f,x_inf,x_sup,TOL_ABS) 
 
%Se calcula la integral con la funci�n quadl de la funci�n de densidad entre 0,85 y 1,85.
