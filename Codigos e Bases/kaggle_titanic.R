#Escolhendo o diretorio de trabalho
setwd("C:/Users/Leandro/Google Drive/FMU/Kaggle/TITANIC")

#Carregando as bases de treinamento e teste
library(data.table)
?data.table

treinamento<-data.table(read.csv("train.csv"))
validacao<-data.table(read.csv("test.csv"))

#Conhecendo as bases
names(treinamento) #Quais são meu atributos?
summary(treinamento) #Uma análise descritiva

#Carregando as bases para a árvore de decisão
library(rpart)
library(stats)
library(caret)
library(ROCR)
library(rattle)
library(rpart.plot)
library(RColorBrewer)

#######################################
### Construindo a árvore de decisão ###
#######################################

arvore1 <- rpart(Survived ~ Pclass + Sex + Age + Fare, 
                 data=treinamento, method="class")

fancyRpartPlot(arvore1)

#Fazendo a predição
predicao1 <- predict(arvore1, validacao, type = "class")
avaliacao1 <- data.frame(PassengerId = validacao$PassengerId, 
                         Survived = predicao1)
write.csv(avaliacao1, file = "avaliacao1.csv", row.names = FALSE)

#Nosso kaggle - 0.78469


#########################################
### Construindo a árvore de decisão 2 ###
#########################################

#Cria a variável FamilySize: 1-Pequena 0-Grande
treinamento$FamilySize <- treinamento$SibSp + treinamento$Parch + 1
validacao$FamilySize <- validacao$SibSp + validacao$Parch + 1

i <- 0
for (i in 1:length(treinamento$Survived)) {
  if (treinamento$FamilySize[i] < 4) {
    treinamento$FamilySize[i] <- 1
  } else {
    treinamento$FamilySize[i] <- 0
  }
}

i <- 0
for (i in 1:length(validacao$PassengerId)) {
  if (validacao$FamilySize[i] < 4) {
    validacao$FamilySize[i] <- 1
  } else {
    validacao$FamilySize[i] <- 0
  }
}


arvore2 <- rpart(Survived ~ Pclass + Sex + Age + Fare +
                 Embarked + FamilySize,
                 data=treinamento, method="class")
fancyRpartPlot(arvore2)

#Fazendo a predição
predicao2 <- predict(arvore2, validacao, type = "class")
avaliacao2 <- data.frame(PassengerId = validacao$PassengerId, Survived = predicao2)
write.csv(avaliacao2, file = "avaliacao2.csv", row.names = FALSE)

#Nosso kaggle - Subimos 2 posições!
#Será que conseguimos melhorar?

#########################################
### Construindo a árvore de decisão 3 ###
#########################################

#Tratando a variável Cabin
treinamento$Cabin_Tratada <- 0
i <- 0
for (i in 1:length(treinamento$Survived)) {
  if (treinamento$Cabin[i] == treinamento$Cabin[1]) {
    treinamento$Cabin_Tratada[i] <- "SI"
  } else {
    treinamento$Cabin_Tratada[i] <- "CA"
  }
}
treinamento$Cabin_Tratada <- as.factor(treinamento$Cabin_Tratada)

validacao$Cabin_Tratada <- 0
i <- 0
for (i in 1:length(validacao$PassengerId)) {
  if (validacao$Cabin[i] == validacao$Cabin[1]) {
    validacao$Cabin_Tratada[i] <- "SI"
  } else {
    validacao$Cabin_Tratada[i] <- "CA"
  }
}
validacao$Cabin_Tratada <- as.factor(validacao$Cabin_Tratada)


arvore3 <- rpart(Survived ~ Pclass + Sex + Age + Fare +
                   Embarked + FamilySize + Cabin_Tratada,
                 data=treinamento, method="class")
fancyRpartPlot(arvore3)

#Fazendo a predição
predicao3 <- predict(arvore3, validacao, type = "class")
avaliacao3 <- data.frame(PassengerId = validacao$PassengerId, Survived = predicao3)
write.csv(avaliacao3, file = "avaliacao4.csv", row.names = FALSE)

#Nosso kaggle 0.78947 - Subimos 230 posições!

#########################################
### Construindo a árvore de decisão 4 ###
#########################################
arvore4 <- rpart(Survived ~ Pclass + Sex + Age + Fare +
                   Embarked + as.factor(FamilySize) + Cabin_Tratada,
                 data=treinamento, method="class")
fancyRpartPlot(arvore4)

#Fazendo a predição
predicao4 <- predict(arvore4, validacao, type = "class")
avaliacao4 <- data.frame(PassengerId = validacao$PassengerId, 
                         Survived = predicao4)
write.csv(avaliacao4, file = "avaliacao4.csv", row.names = FALSE)

#Nosso kaggle 0.79426 - Subimos mais 105 posições!

########################
### Random Forests 1 ###
########################

treinamento <- data.frame(treinamento)
validacao <- data.frame(validacao)


#Tratando a variável Fare
summary(validacao$Fare)
which(is.na(validacao$Fare))
validacao$Fare[153] <- median(validacao$Fare, na.rm=TRUE)


#Tratando a variável Embarked
summary(treinamento$Embarked)
treinamento$Embarked <- as.character(treinamento$Embarked)

for (i in 1:length(treinamento$Embarked)) {
  if (treinamento$Embarked[i] == "") {
    treinamento$Embarked[i] <- "S"
  }
}

treinamento$Embarked <- as.factor(treinamento$Embarked)

#Tratando a variável Age
summary(treinamento$Age)
summary(validacao$Age)

AgeAjuste <- rpart(Age ~ Pclass + Sex + SibSp + Parch +
                     Fare + Embarked + FamilySize + Cabin_Tratada,
                   data=treinamento[!is.na(treinamento$Age),], method="anova")

treinamento$Age[is.na(treinamento$Age)] <- 
  predict(AgeAjuste, treinamento[is.na(treinamento$Age),])

validacao$Age[is.na(validacao$Age)] <- 
  predict(AgeAjuste, validacao[is.na(validacao$Age),])

#Criando a variável Distancia_Fare
#Distancia_Fare= Fare - mean(Fare da Pclass)
#Quem pagar menos que a média viverá?

#Calcula a média para cada classe
Trein_class1 <- subset(treinamento, Pclass == 1)
Trein_class2 <- subset(treinamento, Pclass == 2)
Trein_class3 <- subset(treinamento, Pclass == 3)
Trein_fare1 <- mean(Trein_class1$Fare, na.rm = TRUE)
Trein_fare2 <- mean(Trein_class2$Fare, na.rm = TRUE)
Trein_fare3 <- mean(Trein_class3$Fare, na.rm = TRUE)

#Cria a coluna Fare_avg
treinamento$Fare_avg[treinamento$Pclass == 1] <- Trein_fare1
treinamento$Fare_avg[treinamento$Pclass == 2] <- Trein_fare2
treinamento$Fare_avg[treinamento$Pclass == 3] <- Trein_fare3
validacao$Fare_avg[validacao$Pclass == 1] <- Trein_fare1
validacao$Fare_avg[validacao$Pclass == 2] <- Trein_fare2
validacao$Fare_avg[validacao$Pclass == 3] <- Trein_fare1

#Atribui variável Distancia_Fare
treinamento$Distancia_Fare <- treinamento$Fare - treinamento$Fare_avg
validacao$Distancia_Fare <- validacao$Fare - validacao$Fare_avg

#Cria a variável Tratamento
library(stringr)
treinamento$Tratamento <- 0
validacao$Tratamento <- 0
treinamento$Tratamento[!is.na(str_extract(treinamento$Name, "Mr"))] <- "Mr"
treinamento$Tratamento[!is.na(str_extract(treinamento$Name, "Mrs"))] <- "Mrs"
treinamento$Tratamento[!is.na(str_extract(treinamento$Name, "Mme"))] <- "Mrs"
treinamento$Tratamento[!is.na(str_extract(treinamento$Name, "Miss"))] <- "Miss"
treinamento$Tratamento[!is.na(str_extract(treinamento$Name, "Ms"))] <- "Miss"
treinamento$Tratamento[!is.na(str_extract(treinamento$Name, "Mlle"))] <- "Miss"
treinamento$Tratamento[!is.na(str_extract(treinamento$Name, "Capt"))] <- "Mr"
treinamento$Tratamento[!is.na(str_extract(treinamento$Name, "Major"))] <- "Mr"
treinamento$Tratamento[!is.na(str_extract(treinamento$Name, "Col"))] <- "Mr"
treinamento$Tratamento[!is.na(str_extract(treinamento$Name, "Master"))] <- "Mast"
treinamento$Tratamento[!is.na(str_extract(treinamento$Name, "Rev"))] <- "Mr"
treinamento$Tratamento[!is.na(str_extract(treinamento$Name, "Dr"))] <- "Mr"
treinamento$Tratamento[!is.na(str_extract(treinamento$Name, "Don"))] <- "Mr"
treinamento$Tratamento[!is.na(str_extract(treinamento$Name, "Countess"))] <- "Mrs"
treinamento$Tratamento[!is.na(str_extract(treinamento$Name, "Jonkheer"))] <- "Mr"

validacao$Tratamento[!is.na(str_extract(validacao$Name, "Mr"))] <- "Mr"
validacao$Tratamento[!is.na(str_extract(validacao$Name, "Mrs"))] <- "Mrs"
validacao$Tratamento[!is.na(str_extract(validacao$Name, "Mme"))] <- "Mrs"
validacao$Tratamento[!is.na(str_extract(validacao$Name, "Miss"))] <- "Miss"
validacao$Tratamento[!is.na(str_extract(validacao$Name, "Ms"))] <- "Miss"
validacao$Tratamento[!is.na(str_extract(validacao$Name, "Mlle"))] <- "Miss"
validacao$Tratamento[!is.na(str_extract(validacao$Name, "Capt"))] <- "Mr"
validacao$Tratamento[!is.na(str_extract(validacao$Name, "Major"))] <- "Mr"
validacao$Tratamento[!is.na(str_extract(validacao$Name, "Col"))] <- "Mr"
validacao$Tratamento[!is.na(str_extract(validacao$Name, "Master"))] <- "Mast"
validacao$Tratamento[!is.na(str_extract(validacao$Name, "Rev"))] <- "Mr"
validacao$Tratamento[!is.na(str_extract(validacao$Name, "Dr"))] <- "Mr"
validacao$Tratamento[!is.na(str_extract(validacao$Name, "Don"))] <- "Mr"
validacao$Tratamento[!is.na(str_extract(validacao$Name, "Countess"))] <- "Mrs"
validacao$Tratamento[!is.na(str_extract(validacao$Name, "Jonkheer"))] <- "Mr"

validacao$Name[validacao$Tratamento == 0]
treinamento$Name[treinamento$Tratamento == 0]

treinamento$Tratamento <- factor(treinamento$Tratamento)
validacao$Tratamento <- factor(validacao$Tratamento)

summary(treinamento$Tratamento)
#Remove a coluna PassengerId
treinamento2 <- treinamento[,-1]

#Remove a variável Name
treinamento2 <- treinamento2[,-3]

#Remove a variável Ticket
treinamento2 <- treinamento2[,-7]

#Remove a variável Cabin
treinamento2 <- treinamento2[,-8]

# install randomForest package
install.packages('randomForest')
library(randomForest)

# set a unique seed number so you get the same results everytime you run the below model,
# the number does not matter

set.seed(2013)
# create a random forest model using the target field as the response and all 93 features as inputs
system.time({
  forest1 <- randomForest(as.factor(Survived) ~ Tratamento + Pclass +
                            Distancia_Fare + Cabin_Tratada + Sex +
                            FamilySize + Age + Fare + Embarked + Age/Fare +
                            Distancia_Fare*FamilySize
                          , data=treinamento2
                          , importance=TRUE, ntree=200)
})
forest1
# OOB estimate of  error rate: 15.82%


# create a dotchart of variable/feature importance as measured by a Random Forest
varImpPlot(forest1)

# use the random forest model to create a prediction
prediction <- predict(forest2,validacao, OOB=TRUE, type="response")
submit <- data.frame(PassengerId = validacao$PassengerId, Survived = prediction)
write.csv(submit, file = "avaliacao5.csv", row.names = FALSE)
