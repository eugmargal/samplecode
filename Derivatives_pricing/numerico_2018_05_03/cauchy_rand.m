function  X = cauchy_rand(M,N,a,b)
%% cauchy_rand: generate random numbers with a Cauchy distribution
%
%% SYNTAX:
%        X = cauchy_rand(M,N,a,b)
%
%% INPUT:
%             M   : number of rows
%             N   : number of columns
%             a,b : Parameters of the Cauchy distribution
%                   default values: a = 0, b = 1
%       
%% OUTPUT:
%               X : [M x N] matrix of Cauchy iidrv's  
%
%% EXAMPLE 1:
%
%    a = 2.5; b = 0.5;
%    M = 10000; N = 100;
%    X = cauchy_rand(M,N,a,b);
%    nBins = 100;
%    figure(1); hist(X(:),nBins)   
%    figure(2); hist(cauchy_cdf(X(:),a,b),nBins)
%    figure(3); alpha=5; hist(X(abs(X-a)<alpha*b),nBins) 
%
if (nargin == 2)
    a = 0; % default center
    b = 1; % default scale
end
U = rand(M,N);
X = cauchy_inv(U,a,b);