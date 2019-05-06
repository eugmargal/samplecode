[values,data] = xlsread('Datos_Ejercicio_2','Inputs 2', 'C3:I263');
sensitivity = values(2,:); confidence_level = 0.975;
valor13ad = (values(5:end-10,1:3)-values(15:end,1:3))*10000.*sensitivity(1:3);
valor4mul = (values(5:end-10,4)./values(15:end,4)-1).*sensitivity(4)*100;
valor57mul = (values(5:end-10,5:7)./values(15:end,5:7)-1).*sensitivity(5:7)*100;

display('Los vectores P&L a un horizonte de 10 dias para cada factor de riesgo son:')
MtM = [valor13ad, valor4mul, valor57mul]


IR10 = sum(MtM(:,1:3),2);
IR20 = MtM(:,3);
FX10 = MtM(:,4);
EQ10 = sum(MtM(:,5:7),2);
EQ20 = sum(MtM(:,6:7),2);
EQ60 = MtM(:,7);
TOTAL10 = sum(MtM,2);
TOTAL20 = MtM(:,3) + sum(MtM(:,6:7),2);
TOTAL60 = MtM(:,7);

display('Vectores P&L requeridos para el cálculo del IMCC')
PLvectors = table(IR10,IR20,FX10,EQ10,EQ20,EQ60,TOTAL10,TOTAL20,TOTAL60)

ESIR10 = ExpectedShortfall(IR10,confidence_level);
ESIR20 = ExpectedShortfall(IR20,confidence_level);
ESFX10 = ExpectedShortfall(FX10,confidence_level);
ESEQ10 = ExpectedShortfall(EQ10,confidence_level);
ESEQ20 = ExpectedShortfall(EQ20,confidence_level);
ESEQ60 = ExpectedShortfall(EQ60,confidence_level);
ESTO10 = ExpectedShortfall(TOTAL10,confidence_level);
ESTO20 = ExpectedShortfall(TOTAL20,confidence_level);
ESTO60 = ExpectedShortfall(TOTAL60,confidence_level);

IMCCIR = sqrt(ESIR10^2+(ESIR20*sqrt((20-10)/10))^2);
IMCCFX = sqrt(ESFX10^2);
IMCCEQ = sqrt(ESEQ10^2 + (ESEQ20*sqrt((20-10)/10))^2 + (ESEQ60*sqrt((40-20)/10))^2 + (ESEQ60*sqrt((60-40)/10))^2);
IMCCTOTAL = sqrt(ESTO10^2 + (ESTO20*sqrt((20-10)/10))^2 + (ESTO60*sqrt((40-20)/10))^2 + (ESTO60*sqrt((60-40)/10))^2);
IMCC = 0.5 * IMCCTOTAL + (1-0.5)*(IMCCIR + IMCCFX + IMCCEQ);

display('IMCC(Ci) requeridos para el cálculo del IMCC total')
resultados = table(IMCCIR, IMCCFX, IMCCEQ, IMCCTOTAL)
sprintf('El IMCC total es: %f',IMCC)


function [ES] = ExpectedShortfall(series,level)

cuantil = quantile(series,1-level);
ES_values = series<=cuantil;
ES = sum(series.*ES_values)/sum(ES_values);
end