
#library
#to run this file :  source("C:/Ava/android/Trace/myRtrace.r")
require(arules)

##############READ DATA
Trace <-read.transactions("C:/Ava/android/Trace/theZoo2.csv", sep=",") #theZoo2.csv", sep="," , rm.duplicates=TRUE)#APItracesServices.csv", sep=",") #myTrace4.csv", sep=",")# it is malware traces
TraceGoogleplay <-read.transactions("C:/Ava/android/Trace/GooglePlayTracesC2.csv", sep=",")

itemsets<-eclat(Trace,parameter=list(sup=0.3, minlen=2,maxlen=2))
itemsetsGooglePlay<- eclat(TraceGoogleplay ,parameter=list(sup=0.3,minlen=2,maxlen=2))


itemsets<-setdiff(itemsets,itemsetsGooglePlay)

ISmatrixZooInGoogleplay <- is.subset(itemsets,TraceGoogleplay)
tISmatrixZooInGoogleplay<-t(ISmatrixZooInGoogleplay)

ISmatrixTraceInZoo <- is.subset(itemsets,Trace)
tISmatrixTraceInZoo<-t(ISmatrixTraceInZoo)

#add result coulumn
C = matrix( ,nrow=nrow(tISmatrixTraceInZoo), ncol=1)
B = matrix( ,nrow=nrow(tISmatrixTraceInZoo), ncol=1)
colnames(C) <- c("Result")
colnames(B) <- c("Color")
for(i in 1:nrow(tISmatrixTraceInZoo))
{
	C[i, ]<-1
	B[i, ]<-'Malware'

}

cISmatrixTraceInZoo<-cbind(tISmatrixTraceInZoo, B)
tISmatrixTraceInZoo<-cbind(tISmatrixTraceInZoo, C)

C = matrix( ,nrow=nrow(tISmatrixZooInGoogleplay), ncol=1)
B = matrix( ,nrow=nrow(tISmatrixZooInGoogleplay), ncol=1)

colnames(C) <- c("Result")
colnames(B) <- c("Color")

for(i in 1:nrow(tISmatrixZooInGoogleplay))
{
	C[i, ]<-0
	B[i, ]<-'Benign'
}
cISmatrixZooInGoogleplay<-cbind(tISmatrixZooInGoogleplay, B)
tISmatrixZooInGoogleplay<-cbind(tISmatrixZooInGoogleplay, C)

###############bind two data, malware and Normal
ZooItemGoogle<-rbind(tISmatrixTraceInZoo,tISmatrixZooInGoogleplay)
cZooItemGoogle<-rbind(cISmatrixTraceInZoo,cISmatrixZooInGoogleplay)



############### Use SMOTE to repeat 
library(DMwR)
ZooItemGoogle <- as.data.frame( ZooItemGoogle)
ZooItemGoogle$Result <- as.factor(ZooItemGoogle$Result)
SMOTEZooItemGoogle <- SMOTE(Result ~ ., data=ZooItemGoogle, perc.over = 100, perc.under=200)
prop.table(table(SMOTEZooItemGoogle$Result))


#####
library(DMwR)
cZooItemGoogle <- as.data.frame( cZooItemGoogle)
ZooItemGoogle$Color <- as.factor(cZooItemGoogle$Color)
cSMOTEZooItemGoogle <- SMOTE(Color ~ ., data=cZooItemGoogle, perc.over = 100, perc.under=200)
prop.table(table(cSMOTEZooItemGoogle$Color))

################PCA for feature reduction

#my_data<- subset(SMOTEZooItemGoogle, select = -c(Result))
#pca1<-prcomp(my_data, scores=TRUE, cor=TRUE)
#summary(pca1)
#plot(pca1)
#screeplot(pca1, npcs = 24, type = "lines")
#biplot(pca1)
#names(pca1)
#ZooItemGoogle <- as.data.frame( ZooItemGoogle)
#train.data <- data.frame(Result = ZooItemGoogle$Result, pca1$x)
#train.data <- train.data[,1:274]

my_data<- subset(SMOTEZooItemGoogle, select = -c(Result))
pca1<-prcomp(my_data, scores=TRUE, cor=TRUE)
summary(pca1)
#plot(pca1)
#biplot(pca1)
##screeplot(pca1, main="a", xlab="# of PCs" npcs = 130, type = "lines")

names(pca1)
SMOTEZooItemGoogle<- as.data.frame( SMOTEZooItemGoogle)
train.data <- data.frame(Result = SMOTEZooItemGoogle$Result, pca1$x)
train.data <- train.data[,1:274]

library(devtools)
library(ggplot2)
library(ggfortify)
##d#SMOTEZooItemGoogleResult1<-SMOTEZooItemGoogle$Result+1
##d#SMOTEZooItemGoogleResult <- factor(SMOTEZooItemGoogle$Result)
##d#SMOTEZooItemGoogleResult1f <- factor(SMOTEZooItemGoogleResult1)

autoplot(pca1, data= cSMOTEZooItemGoogle, col='Color')
###nsform test into PCA
#test.data <- predict(pca1, newdata = pca.test)
#test.data <- as.data.frame(test.data)

#select the first 274 components
#test.data <- test.data[,1:274]


##############Save data
write.csv(SMOTEZooItemGoogle, file = "C:/Ava/android/Trace/SMOTEZooItemGoogle.csv")
write.csv(SMOTEZooGoogleItem, file = "C:/Ava/android/Trace/SMOTEZooGoogleItem.csv")

#library(rattle)
#rattle()

##eliminate redundancy
#rules.sorted <- sort(rules, by="lift")
#subset.matrix <- is.subset(rules, rules)
#subset.matrix[lower.tri(subset.matrix, diag=TRUE)] <- NA
#redundant <- colSums(subset.matrix, na.rm=TRUE) >= 1
##which(redundant)
#rules.pruned <- rules[!redundant]
#inspect(rules.pruned)
#rules<-rules.pruned
############