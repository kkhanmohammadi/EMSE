
#library
#to run this file :  source("C:/Ava/android/Trace/myRtrace7030.r")
require(arules)

##############READ DATA
Trace <-read.transactions("C:/Ava/android/Trace/APItracesServices.csv", sep=",")#theZoo2.csv", sep=",") #theZoo2.csv", sep="," , rm.duplicates=TRUE)#APItracesServices.csv", sep=",") #myTrace4.csv", sep=",")# it is malware traces
#TraceGoogle <-read.transactions("C:/Ava/android/Trace/Googletrace.csv", sep=",")
TraceGoogleplay <-read.transactions("C:/Ava/android/Trace/GooglePlayServicesTraces.csv", sep=",")#GooglePlayTracesC1.csv", sep=",")
#TracetheZoo <-read.transactions("C:/Ava/android/Trace/theZoo2.csv", sep=",")
#TraceFDroid <-read.transactions("C:/Ava/android/Trace/FDroidtrace.csv", sep=",")
#TraceGenomeNormal <-read.transactions("C:/Ava/android/Trace/GenomeNormalTraces1.csv", sep=",")
#TraceGenomeNormalp <-read.transactions("C:/Ava/android/Trace/GenomeNormalTracesp.csv", sep=",")
summary(Trace)

#Genome60<-read.transactions("C:/Ava/android/Trace/results/Genome60.csv", sep=",")
#Zoo60<-read.transactions("C:/Ava/android/Trace/results/Zoo60.csv", sep=",")
#Googleplay60<-read.transactions("C:/Ava/android/Trace/results/GooglePlay60.csv", sep=",")

##########################70 percent for training set, 30 for test set
cutoff = round(0.7*nrow(Trace))
trainTrace<-Trace[1:cutoff,]
testTrace<-Trace[-(1:cutoff),]
Trace<-trainTrace

cutoff = round(0.7*nrow(TraceGoogleplay ))
trainTraceGooglePlay<-TraceGoogleplay[1:cutoff,]
testTraceGoogleplay <-TraceGoogleplay[-(1:cutoff),]
TraceGoogleplay<-trainTraceGooglePlay

##############itemsets by eclat

itemsets<-eclat(Trace,parameter=list(sup=0.5, minlen=5,maxlen=5))
itemsetsGooglePlay<- eclat(TraceGoogleplay ,parameter=list(sup=0.5,minlen=5,maxlen=5))

#############setdiff
itemsetsGooglePlay<-setdiff(itemsetsGooglePlay,itemsets)



ISmatrixGenomeInGoogleplay <- is.subset(itemsets,TraceGoogleplay)
ISmatrixGenomeInGoogleplayTest<-is.subset(itemsets,testTraceGoogleplay)
tISmatrixGenomeInGoogleplay<-t(ISmatrixGenomeInGoogleplay)
tISmatrixGenomeInGoogleplayTest<-t(ISmatrixGenomeInGoogleplayTest)

ISmatrixTraceInGoogleplay <- is.subset(itemsetsGooglePlay,TraceGoogleplay)
ISmatrixTraceInGoogleplayTest<-is.subset(itemsetsGooglePlay,testTraceGoogleplay)
tISmatrixTraceInGoogleplay<-t(ISmatrixTraceInGoogleplay)
tISmatrixTraceInGoogleplayTest<-t(ISmatrixTraceInGoogleplayTest)


ISmatrixTraceInGenome <- is.subset(itemsets,Trace)
ISmatrixTraceInGenomeTest <- is.subset(itemsets,testTrace)
tISmatrixTraceInGenome<-t(ISmatrixTraceInGenome)
tISmatrixTraceInGenomeTest<-t(ISmatrixTraceInGenomeTest)


ISmatrixGoogleplayInGenome <- is.subset(itemsetsGooglePlay,Trace)
ISmatrixGoogleplayInGenomeTest <- is.subset(itemsetsGooglePlay,testTrace)
tISmatrixGoogleplayInGenome<-t(ISmatrixGoogleplayInGenome)
tISmatrixGoogleplayInGenomeTest<-t(ISmatrixGoogleplayInGenomeTest)


##Genome and google item
##trace with genome itemset and googleplay itemsets
tempa<-rbind(tISmatrixTraceInGenome,tISmatrixGenomeInGoogleplay)
tempb<-rbind(tISmatrixGoogleplayInGenome,tISmatrixTraceInGoogleplay)
GGrow<-nrow(tISmatrixTraceInGenome)+nrow(tISmatrixGenomeInGoogleplay)
C = matrix( ,nrow=GGrow, ncol=1)
colnames(C) <- c("Result")
for(i in 1:nrow(tISmatrixTraceInGenome))
{
	C[i, ]<-1
}
for(i in nrow(tISmatrixTraceInGenome)+1:nrow(tISmatrixTraceInGoogleplay))
{
	C[i, ]<-0
}
GenomeGoogleItem<-cbind(tempa,tempb)
GenomeGoogleItem<-cbind(GenomeGoogleItem,C)


# print in consul message("Current working dir: ", wd)
###Genome item
C = matrix( ,nrow=nrow(tISmatrixTraceInGenome), ncol=1)
colnames(C) <- c("Result")
for(i in 1:nrow(tISmatrixTraceInGenome))
{
	C[i, ]<-1
}

tISmatrixTraceInGenome<-cbind(tISmatrixTraceInGenome, C)
C = matrix( ,nrow=nrow(tISmatrixGenomeInGoogleplay), ncol=1)
colnames(C) <- c("Result")
for(i in 1:nrow(tISmatrixGenomeInGoogleplay))
{
	C[i, ]<-0
}

tISmatrixGenomeInGoogleplay<-cbind(tISmatrixGenomeInGoogleplay, C)

###############bind two data, malware and Normal
#trace with only Genome itemsets
GenomeItemGoogle<-rbind(tISmatrixTraceInGenome,tISmatrixGenomeInGoogleplay)

#####################################################
##############################Test
##Genome and google item
##trace with genome itemset and googleplay itemsets
tempa<-rbind(tISmatrixTraceInGenomeTest,tISmatrixGenomeInGoogleplayTest)
tempb<-rbind(tISmatrixGoogleplayInGenomeTest,tISmatrixTraceInGoogleplayTest)
GGrow<-nrow(tISmatrixTraceInGenomeTest)+nrow(tISmatrixGenomeInGoogleplayTest)
C = matrix( ,nrow=GGrow, ncol=1)
colnames(C) <- c("Result")
for(i in 1:nrow(tISmatrixTraceInGenomeTest))
{
	C[i, ]<-1
}
for(i in nrow(tISmatrixTraceInGenomeTest)+1:nrow(tISmatrixTraceInGoogleplayTest))
{
	C[i, ]<-0
}
GenomeGoogleItemTest<-cbind(tempa,tempb)
GenomeGoogleItemTest<-cbind(GenomeGoogleItemTest,C)


# print in consul message("Current working dir: ", wd)
###Genome item
C = matrix( ,nrow=nrow(tISmatrixTraceInGenomeTest), ncol=1)
colnames(C) <- c("Result")
for(i in 1:nrow(tISmatrixTraceInGenomeTest))
{
	C[i, ]<-1
}

tISmatrixTraceInGenomeTest<-cbind(tISmatrixTraceInGenomeTest, C)
C = matrix( ,nrow=nrow(tISmatrixGenomeInGoogleplayTest), ncol=1)
colnames(C) <- c("Result")
for(i in 1:nrow(tISmatrixGenomeInGoogleplayTest))
{
	C[i, ]<-0
}

tISmatrixGenomeInGoogleplayTest<-cbind(tISmatrixGenomeInGoogleplayTest, C)

#trace with only Genome itemsets
GenomeItemGoogleTest<-rbind(tISmatrixTraceInGenomeTest,tISmatrixGenomeInGoogleplayTest)


############### Use SMOTE to repeat 
library(DMwR)
GenomeItemGoogle <- as.data.frame( GenomeItemGoogle)
GenomeItemGoogle$Result <- as.factor(GenomeItemGoogle$Result)
SMOTEGenomeItemGoogle <- SMOTE(Result ~ ., data=GenomeItemGoogle, perc.over = 2000, perc.under=100)
prop.table(table(SMOTEGenomeItemGoogle$Result))


GenomeGoogleItem<- as.data.frame( GenomeGoogleItem)
GenomeGoogleItem$Result <- as.factor(GenomeGoogleItem$Result)
SMOTEGenomeGoogleItem <- SMOTE(Result ~ ., data=GenomeGoogleItem, perc.over = 2000, perc.under=100)
prop.table(table(SMOTEGenomeGoogleItem$Result))

###############Save data
write.csv(SMOTEGenomeItemGoogle, file = "C:/Ava/android/Trace/7030/GenomeItemGoogleCtrain.csv")
write.csv(SMOTEGenomeGoogleItem, file = "C:/Ava/android/Trace/7030/GenomeGoogleCItemtrain.csv")

write.csv(GenomeItemGoogleTest, file = "C:/Ava/android/Trace/7030/GenomeItemGoogleCtest.csv")
write.csv(GenomeGoogleItemTest, file = "C:/Ava/android/Trace/7030/GenomeGoogleCItemtest.csv")

