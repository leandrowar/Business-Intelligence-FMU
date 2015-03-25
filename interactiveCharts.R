#Selecionando o diretorio
setwd("C:/Users/Leandro/Google Drive/FMU")

#############################################
#### -        Manipulate package       - ####
#############################################

#Carrega a biblioteca
library(manipulate)

#Sintaxe básica
manipulate(
            plot(1:x, xlab = 'Eixo X',
                ylab = 'Eixo Y',
                main = 'Exemplo - Manipulate'), 
            x = slider(1, 60)
          )

#Usando múltiplos sliders
data(cars)
manipulate(
            plot(cars, xlim=c(x.min,x.max),
                 xlab = 'Velocidade',
                 ylab = 'Distância',
                 main = 'Múltiplos Sliders'),
            x.min=slider(0,20),
            x.max=slider(20,40))

#Avaliando um histograma
library(UsingR)
data(galton)
?galton

meuHist <- function(mu) {
  hist(galton$child, col = "red", breaks = 100,
       main = 'Histograma',
       ylab='Frequencia',
       xlab='Altura')
  lines(c(mu, mu), c(0, 150), col = "green", lwd = 5)
  mse <- mean((galton$child - mu)^2)
  text(63, 150, paste("mu = ", mu))
  text(66, 150, paste("MSE = ", round(mse, 2)))
}

manipulate(meuHist(mu), mu = slider(62, 74, step = 1))

#Usando uma lista suspensa
manipulate(
  barplot(as.matrix(longley[,factor]),
          beside = TRUE, main = factor),
  factor = picker("GNP", "Unemployed", "Employed"))

#Usando um botão
manipulate(
{
  if(reset)
    set.seed(sample(1:1000))
  hist(rnorm(n=100, mean=0, sd=3), breaks=bins)
},
bins = slider(1, 20, step=1, initial =5, label="Bins"),
reset = button("Reiniciar Seed")
)


#Exemplos mais sofisticados
#Instala a biblioteca quantmod
install.packages("quantmod")    
library("quantmod")             

#Seleção do período de análise
dataInicial = as.Date("2014-10-01") 
dataFinal = as.Date("2015-03-20")

#Seleção das ações
tickers <- c("GOOG","PETR4.SA","^BVSP","BBDC4.SA")

#Download dos dados
getSymbols(tickers, src = "yahoo", from = dataInicial, to = dataFinal)
save(BBDC4.SA, file="BBDC4.SA.RData")
save(BVSP, file="BVSP.RData")
save(PETR4.SA, file="PETR4.SA.RData")
save(GOOG, file="GOOG.RData")


#Trabalhando com data Frames
PETR4 <- data.frame(PETR4.SA)
GOOGLE <- data.frame(GOOG)
IBOVESPA <- data.frame(BVSP)
BBDC4 <- data.frame(BBDC4.SA)

manipulate(
  candleChart(get(factor)),
  factor = picker('PETR4','GOOGLE','IBOVESPA','BBDC4')
)

#############################################
#### -          rCharts Packge         - ####
#############################################
require(devtools)
install_github('rCharts', 'ramnathv')
library(rCharts)

## Iris dataset
names(iris) = gsub("\\.", "", names(iris))
rPlot(SepalLength ~ SepalWidth | Species,
      data = iris, color = 'Species', type = 'point')

## Gráficos de barras
hair_eye = as.data.frame(HairEyeColor)
rPlot(Freq ~ Hair | Eye, color = 'Eye', data = hair_eye, type = 'bar')


#############################################
#### - Grafico de Rede (Network Graph) - ####
#############################################

#Carrega as bibliotecas
install.packages('igraph')
library(igraph)

relacoes <- read.csv("redes_complexas2.txt",sep='|')

rede_paises <- graph.data.frame(relacoes, directed=F)
#Lista de vértices
V(rede_paises)

#Lista de nós
E(rede_paises)

#Número de relacionamentos
degree(rede_paises)

plot(rede_paises)


#Excluindo conexões pequenas
baixo_rel <- V(rede_paises)[degree(rede_paises) < 100]
rede_paises <- delete.vertices(rede_paises, baixo_rel)

V(rede_paises)$color <- ifelse(
                                V(rede_paises)$name=='Brasil',
                               'blue', 'red'
                               )

#Ajusta o tamanho dos vértices
V(rede_paises)$size <- degree(rede_paises)/20

#Plotando novamente
plot(rede_paises,
     layout=layout.fruchterman.reingold,
     main='Relacionamento entre os países',	
     vertex.label.dist = 1.6,			
     vertex.frame.color='black', 	
     vertex.label.color='black',	
     vertex.label.font=2,	
     vertex.label=V(rede_paises)$name,
     vertex.label.cex=1
  )


