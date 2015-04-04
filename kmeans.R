#Selecionando o diretorio de trabalho
source('C:/Users/Leandro/Google Drive/FMU/kmeans.R')

############################
### Preparação dos dados ###
############################
#Limpando o environment
rm(list=ls())

#Limpando os NAs
base <- na.omit(iris) 

#Padronizando as variáveis
base2 <- data.frame(scale(base[,1:4]))
base2$Species <- base$Species
base <- base2

#Determinando o número de clusters
wss <- (nrow(base)-1)*sum(apply(base[,1:4],2,var))

#15 será o número de Cluster máximo para teste
for (i in 2:15){
	wss[i] <- sum(kmeans(base[,1:4],centers=i)$withinss)
	}

#Cria o gráfico mostrando o número de clusters x erro
plot(1:15, wss, type="b", xlab="Número de Clusters",
     ylab="Soma dos quadradados - Erro", main = "Clusters x Erro")

############################
### Executando o K-Means ###
############################

#Agrupamento com o K-Means
kmedias <- kmeans(base[,1:4], 3) #3 clusters

#Calcula a media dos clusters
aggregate(base[,1:4],by=list(kmedias$cluster),FUN=mean)

#Atribui o resultado dos cluster na base
base <- data.frame(base, kmedias$cluster)

#Verificação do Resultado
table(base$kmedias.cluster,base$Species)

#########################################
### Exibe os clusters, utilizando PCA ###
#########################################
library(cluster) 
clusplot(base, kmedias$cluster, color=TRUE, shade=TRUE, 
         labels=2, lines=0,main = "Cluster - Espécies")


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
rect.hclust(dendo, k=8, border="blue")



