install.packages("clusterGeneration")
require(clusterGeneration)

# https://beckmw.wordpress.com/2013/03/04/visualizing-neural-networks-from-the-nnet-package/
# http://gekkoquant.com/2012/05/26/neural-networks-with-r-simple-example/

set.seed(2)
num.vars<-8
num.obs<-1000

#arbitrary correlation matrix and random variables
cov.mat<-genPositiveDefMat(num.vars,covMethod=c("unifcorrmat"))$Sigma
rand.vars<-mvrnorm(num.obs,rep(0,num.vars),Sigma=cov.mat)
parms<-runif(num.vars,-10,10)

#response variable as linear combination of random variables and random error term
y<-rand.vars %*% matrix(parms) + rnorm(num.obs,sd=20)

install.packages("nnet")
require(nnet)

rand.vars<-data.frame(rand.vars)
y<-data.frame((y-min(y))/(max(y)-min(y)))
names(y)<-'y'

mod1<-nnet(rand.vars,y,size=10,linout=T,
           rang = 0.1,decay = 5e-4, maxit = 200)

source("./plot.net.R")
par(mar=numeric(4),mfrow=c(1,2),family='serif')
plot(mod1,nid=F)
plot(mod1)

#example data and code from nnet function examples
ir<-rbind(iris3[,,1],iris3[,,2],iris3[,,3])
targets<-class.ind( c(rep("s", 50), rep("c", 50), rep("v", 50)) )
samp<-c(sample(1:50,25), sample(51:100,25), sample(101:150,25))
ir1<-nnet(ir[samp,], targets[samp,], size = 2, rang = 0.1,decay = 5e-4, maxit = 200)

#plot the model with different default values for the arguments
par(mar=numeric(4),family='serif')
plot.nnet(ir1,pos.col='darkgreen',neg.col='darkblue',alpha.val=0.7,rel.rsc=15,
          circle.cex=10,cex=1.4,
          circle.col='brown')


#############################################################

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

set.seed(611)
library(caret)
inTrain <- createDataPartition(y=base2$depositoyes,p = 0.70, list=FALSE)
training <- base2[inTrain,]
testing <- base2[-inTrain,]
dim(training); dim(testing)


x_training <- training[,-44]
y_training <- training$depositoyes

x_testing <- testing[,-44]


nn1<-nnet(x_training,y_training,size=10,linout=T,
           rang = 0.1,decay = 5e-4, maxit = 10000)

prediction <- predict(nn1,x_testing) 

evaluation <- cbind(prediction,testing$depositoyes)
write.csv2(evaluation,file='evaluation_2.csv')

plot.nnet(nn1,pos.col='darkgreen',neg.col='darkblue',alpha.val=0.3,rel.rsc=5,
          circle.cex=1,cex=1,
          circle.col='brown')

