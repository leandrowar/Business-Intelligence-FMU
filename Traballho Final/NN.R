#Leandro Guerra
#www.artedosdados.com.br
#leandro.guerra@artedosdados.com.br

install.packages("nnet")
library(nnet)
source("./plot.net.R")


base <- read.csv("banco_UMF.csv",header = TRUE, sep = ';')
head(base)
names(base)
dummies <- as.data.frame(
                        model.matrix( 
                          ~ job + marital + education + default + housing
                          + loan + contact + month + poutcome + deposito -1 ,
                          data=base)
                        )
base2 <- cbind(base$age,base$balance,base$day,base$duration,
               base$campaign,base$pdays,base$previous,dummies)
names(base2)

library(caret)

set.seed(611)
inTrain <- createDataPartition(y=base2$depositoyes,p = 0.70, list=FALSE)
training <- base2[inTrain,]
testing <- base2[-inTrain,]
dim(training); dim(testing)


x_training <- training[,-44]
y_training <- training$depositoyes

x_testing <- testing[,-44]


nn1<-nnet(x_training,y_training,size=5,linout=T,
           rang = 0.1,decay = 5e-2, maxit = 1000)

prediction <- predict(nn1,x_testing) 

evaluation <- cbind(prediction,testing$depositoyes)
write.csv2(evaluation,file='evaluation_2.csv')

plot.nnet(nn1,pos.col='blue',neg.col='red',alpha.val=0.3,rel.rsc=5,
          circle.cex=1,cex=1,
         circle.col='brown')

prediction2 <- (prediction > 2*mean(prediction)) + 0

table(testing$depositoyes,prediction2)

