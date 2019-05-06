N=10000;
%crea la tabla a partir de las dos funciones definidas anteriormente
[s11,s12,s13]=sumaDelante(N);
[s21,s22,s23]=sumaAtras(N);
array=[s11,s12,s13,s21,s22,s23];
tabla=array2table(array,'VariableNames', {'sumaA','err_abs_A','err_rel_SA','sumaD','err_abs_D','err_rel_D'})
sum=0;


function [S_N,err_abs,err_rel]=sumaDelante(N)
S=pi^4/90
S_N(1,1)=1%valor inicial
for i=2:N
    suma=0;
    for j=1:i%realiza la suma desde 1 hasta i
        suma=suma+1/j^4;
    end
    S_N(i,1)=suma;%calcula suma y errores absolutos y relativos
    err_abs(i,1)=abs(S_N(i,1)-S);
    err_rel(i,1)=abs((S_N(i,1)-S)/S);
    %Para obtener el N óptimo, cuando dos seguidos sean iguales para
    if S_N(i,1)==S_N(i-1,1)
        break;
    else continue;
    end
end
end

function [S_N,err_abs,err_rel]=sumaAtras(N)
S=pi^4/90;
S_N(1,1)=1;%valor inicial
for i=2:N
    suma=0;
    for j=i:-1:1
          suma=suma+1/j^4;
    end
    S_N(i,1)=suma;%realiza la suma desde 1 hasta i
    err_abs(i,1)=abs(S_N(i,1)-S);
    err_rel(i,1)=abs((S_N(i,1)-S)/S);
    %Para obtener el N óptimo, cuando dos seguidos sean iguales para
    if S_N(i,1)==S_N(i-1,1)
        break;
    else continue;
    end
end

end