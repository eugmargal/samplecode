N=0;
valor=1;%este es el valor que meter en la funcion para calcular la diferencia
inflim=1;%valor inicial
while inflim ~= 0 %aquí acoto por arriba la potencia N
    N=N+1;
    inflim=(valor+10^-(N+1))-valor;
end
n1=10^-(N+1);
%En estos dos bucles ajusto, descomponiendo el número en base decimal e
%iterando para diferentes i,j para encontrar el máximo para cada posicion
%N es la precisión a la que quiero obtener el número máximo
for j=0:320
    for i=9:-1:0 %recorre todos los valores de esta posición
        n2=n1+i*10^-(N+j);%ajusto 
        dif=(valor+n2)-valor;
        if dif~=0 %si dif es distinto de 0 entonces salta a la siguiente iteración
            continue;
        else
            n1=n1+i*10^-(N+j);%Hasta aquí llega si me paso, así que escojo el anterior
        end
        break;
    end
end
limite=n1