# Prevendo o preço de venda de automóveis usados


## Problema de negócio:

Precisamos construir um modelo para prever o preço de venda de automóveis usados. 
Esse é um projeto para exemplificar como solucionar problemas de regressão em machine learning utilizando o scikit-learn e o pandas.


## Metodologia:

Esse é um típico problema de regressão. 

Iremos utilizar os dados históricos para construir um modelo de regressão com Linear Regression, Random Forest Regression e 
XGBoost.



Os dados foram retirados do [Kaggle](https://www.kaggle.com/nehalbirla/vehicle-dataset-from-cardekho?ref=hackernoon.com&select=Car+details+v3.csv)


Linguagem Utilizada: Python (pandas,numpy, scikit-learn, matplotlib, seaborn)


## Resultados:


### Qual foi o desempenho dos modelos ?

Comparamos as métricas dos modelos no Cross Validation de 5 fold para identificar o modelo mais promissor. 

Mas antes de prosseguirmos,  o que é um Cross - Validation ? 

É uma técnica que visa entender como o modelo generaliza. É uma técnica importante para sabermos como o modelo está generalizando e para checar se estamos overfittando/underfittando. 
O método K-Fold irá repartir os dados de treino em K-Fold (no nosso caso 5). Na primeira iteração ele usará 4 partes para treinar e 1 para validar. Na segunda irá utilizar outras 4 partes para treinar e 1 para validar.... 
Abaixo uma imagem que ajuda a entender o que é o Cross-Validation:

![cv-5fold](https://user-images.githubusercontent.com/75284489/191073294-f16bd5f6-d8f5-4a83-8940-9d02c145bb75.png)



### Quais são as métricas que estamos utilizando para avaliar os modelos ?

Estamos avaliando o modelo com base em 2 métricas: RMSE e R2

RMSE - O RMSE é o "root mean squared error", ou a raiz quadrada da média dos erros (diferença entre os valores reais e os valores previstos).
Quanto menor o valor, melhor!

Abaixo a fórmula do RMSE:

![rmse](https://user-images.githubusercontent.com/75284489/191073298-8853a9cf-81c7-4662-b9d8-4c029e654e6d.png)


O R2 "R-Quadrado" ou Coeficiente de Determinação é uma métrica estatística usada em modelos de regressão que expressa o quanto da variabilidade
da variável resposta é explicada pelo modelo. É uma métrica que varia entre 0% e 100%. 

Esta métrica - como todas as outras - possui suas limitações. Não necessariamente um modelo com alto R2 seja bom.Por exemplo,
o aumento do número de variáveis no modelo aumenta por si só o valor do R2, ou seja,
quanto mais variáveis tiverem no modelo, maior será o R2.


Agora que já sabemos o que é Cross Validation e as métricas utilizadas,vamos verificar o desempenho dos modelos!


Como podemos ver na imagem abaixo, o XGBOOST e o Random Forest Regression tiveram o melhor desempenho.


![Comparativo_entre_modelos](https://user-images.githubusercontent.com/75284489/191073290-700be51d-5f13-4d55-941b-2ac9e66d1530.png)



Optamos por selecionar o XGBoost. Mas afinal, qual foi o desempenho do modelo de XGBoost na base de teste ?


![métricas_finais](https://user-images.githubusercontent.com/75284489/191073295-3a30749b-0298-4e8c-8b75-8e4adb8fdd7f.png)




