N=0;
valor=1;%este es el valor que meter en la funcion para calcular la diferencia
inflim=1;%valor inicial
while inflim ~= 0 %aqu� acoto por arriba la potencia N
    N=N+1;
    inflim=(valor+10^-(N+1))-valor;
end
n1=10^-(N+1);
%En estos dos bucles ajusto, descomponiendo el n�mero en base decimal e
%iterando para diferentes i,j para encontrar el m�ximo para cada posicion
%N es la precisi�n a la que quiero obtener el n�mero m�ximo
for j=0:320
    for i=9:-1:0 %recorre todos los valores de esta posici�n
        n2=n1+i*10^-(N+j);%ajusto 
        dif=(valor+n2)-valor;
        if dif~=0 %si dif es distinto de 0 entonces salta a la siguiente iteraci�n
            continue;
        else
            n1=n1+i*10^-(N+j);%Hasta aqu� llega si me paso, as� que escojo el anterior
        end
        break;
    end
end
limite=n1