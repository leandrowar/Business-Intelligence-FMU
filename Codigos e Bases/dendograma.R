#Selecionando o diretorio de trabalho
source('C:/Users/Leandro/Google Drive/FMU/dendograma.R')


#############################
### Criando um Dendograma ###
#############################

#Base mtcars
#Limpando os NAs
base_mtcars <- na.omit(mtcars) 

#Padronizando as variáveis
base_mtcars <- scale(base_mtcars)

#Cria uma clusterização hierarquica
#Cria a matriz de distâncias
distancia <- dist(base_mtcars, method = "euclidean")
dendo <- hclust(distancia, method="ward.D") 

#Plota o dendograma
plot(dendo)

#Divide o dendograma em 5 grupos
grupos <- cutree(dendo, k=5)
#Desenha uma borda azul 
rect.hclust(dendo, k=5, border="blue")

#Exibe o dendrograma com menos níveis
#Primeiro convertemos em um objeto de dendograma
dendo <- as.dendrogram(dendo)

#Agora o plot
plot(cut(dendo , h = 4)$upper, main = "Corte superior com h=4")



a <- cut(dendo , h = 4)$upper
a
plot(cut(hcd, h = 75)$lower[[2]],
     main = "Second branch of lower tree with cut at h=75")

