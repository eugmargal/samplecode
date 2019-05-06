function  x = cauchy_inv(p,a,b)
%% cauchy_inv: inverse of a Cauchy distribution
%
%% SYNTAX:
%        p = cauchy_inv(p,a,b)
%
%% INPUT:
%               p : Probability value
%             a,b : Parameters of the Cauchy distribution
%                   default values: a = 0, b = 1
%       
%% OUTPUT:
%               x : Value of the percentile  
%
%% EXAMPLE 1:
%
%    alpha = 5;
%    a = 2.5; b = 0.5;
%    p = 2/3;
%    cauchy_cdf(cauchy_inv(p,a,b),a,b) %evaluates to p
%%
if (nargin == 1)
    a = 0; % default center
    b = 1; % default scale
end
x=a+b*tan(pi*(p-0.5)); %despejando x de la función de prob de cauchy