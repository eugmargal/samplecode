clear
N=0;
%Da a escoger entre buscar m�ximo y m�nimo
prompt= 'Insertar 1 si quiere valor positivo m�s grande, 0 si m�s peque�o representable ';
%Inicializa la variable de b�squeda
inflim=1;
choose=input(prompt);
if choose==1 %En este bucle delimito inferiormente el n�mero m�s alto representable
    while inflim ~= Inf
        N=N+1;
        inflim=10^(N+1);
    end
    n1=10^N;
%En estos dos bucles ajusto, descomponiendo el n�mero en base decimal e
%iterando para diferentes i,j para encontrar el m�ximo para cada posicion
%N es la precisi�n a la que quiero obtener el n�mero m�ximo
    for j=0:N
        for i=1:10 %recorre todos los valores de esta posici�n
            n2=n1+i*10^(N-j);
            if n2~=Inf %si n2 es distinto de inf entonces salta a la siguiente iteracci�n
                continue;
            else
                n1=n1+(i-1)*10^(N-j);%Hasta aqu� llega si me paso, as� que escojo el anterior
            end
            break;
        end
    end
    maximo=vpa(n1,10)
elseif choose==0 %Busco el minimo, en este caso no necesito afinar la busqueda como antes
    while inflim ~= 0 
        N=N+1;
        inflim=10^-(N+1); %
    end
        n1=10^-N;
        minimo=vpa(n1,10)
else disp('Error');
end
    
    