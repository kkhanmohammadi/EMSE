
#library
#to run this file :  source("C:/Ava/android/Trace/myRtrace.r")
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


##############itemsets by eclat

itemsets<-eclat(Trace,parameter=list(sup=0.3, minlen=2,maxlen=2))
itemsetsGooglePlay<- eclat(TraceGoogleplay ,parameter=list(sup=0.3,minlen=2,maxlen=2))

#############setdiff
itemsetsGooglePlay<-setdiff(itemsetsGooglePlay,itemsets)


#itemsets<-eclat(Trace,parameter=list(sup=0.2, minlen=2,maxlen=2))
#itemsetsGooglePlay<- eclat(TraceGoogleplay ,parameter=list(sup=0.2,minlen=2,maxlen=2))
#itemsetstheZoo<-eclat(TracetheZoo ,parameter=list(sup=0.2,minlen=2,maxlen=2))

##Create rules from the itemsets
#rules<-ruleInduction(itemsets,Adult, confidence=0.9)

##to see some transactions eg. 2 to 6
#inspect(Trace[2:6]) 
##frequency of first item; items will be sorted in Trace in arules
#par(mar=c(5.1, 8.1, 4.1, 2.1))## margin setting
#itemFrequency(Trace[,1])
#frequency of first 6 items;
#itemFrequency(Trace[ ,1:6])
#itemFrequencyPlot(Trace, support=0.2)
#itemFrequencyPlot(Trace, topN=10)
##rules is rulegc
#rules <- apriori(Trace, parameter=list(support=0.007, confidence=0.25, minlen=2))
#inspect(rules[1:1])
#summary(rules)
#inspect(rules[1:2])# show rule from one to two
#inspect(sort(rules, by="lift")[1:4])
#rules <- apriori(Trace, parameter=list(support=0.1, confidence=0.8, minlen=3))
#rules <- apriori(Trace, parameter=list(support=0.2, confidence=1, minlen=3, maxlen=3))

##itemsets by apriori
#itemsets <- unique(generatingItemsets(rules))
#itemsets.df <- as(itemsets, "data.frame")
#frequentItemsets <- itemsets.df[with(itemsets.df, order(-support,items)),]
#names(frequentItemsets)[1] <- "itemset"
#write.table(frequentItemsets, file = "", sep = ",", row.names = FALSE)

#require(arulesViz)
#plot(rules, measure=c("support","lift"), shading="confidence")
#plot(rules, shading="order", control=list(main ="Two-key plot"))
###################
#subrules = rules[quality(rules)$confidence > 0.8]
#plot(subrules, method="matrix", measure="lift");

#as(rules, "data.frame") ##may be useful

#write(rules, file = "data.csv", sep = ",")
#unlink("data.csv") # tidy up

#rules<-sort(rules, by="confidence", decreasing=TRUE)

##eliminate redundancy
#rules.sorted <- sort(rules, by="lift")
#subset.matrix <- is.subset(rules, rules)
#subset.matrix[lower.tri(subset.matrix, diag=TRUE)] <- NA
#redundant <- colSums(subset.matrix, na.rm=TRUE) >= 1
##which(redundant)
#rules.pruned <- rules[!redundant]
#inspect(rules.pruned)
#rules<-rules.pruned
############s

##matrix of transaction-rules is.subset(transaction,rules)
#TRmatrix<- is.subset(Trace,rules)

#TRmatrix<-is.subset(Trace, items %in% lhs(rules) & !items %in% rhs(rules) )
#ncol(TRmatrix) nrow(TRmatrix)

#TRmatrix1<- is.subset(rules.pruned,Trace)
#TRmatrixG<- is.subset(rules.pruned,TraceGoogle)
#TRmatrixG1<- is.subset(TraceGoogle,rules.pruned)
#TRmatrixFD<-is.subset(rules.pruned,TraceFDroid)
#TRmatrixGN<-is.subset(rules.pruned,TraceGenomeNormal)
#TRmatrixGNp<-is.subset(rules.pruned,TraceGenomeNormalp)

#ISmatrix<- is.subset(itemsets,Trace)
#write.csv(ISmatrix, file = "C:/Ava/android/Trace/ISmatrixGenome.csv")

#ISmatrixGenomeNormal<- is.subset(itemsets,TraceGenomeNormal)
#write.csv(ISmatrixGenomeNormal, file = "C:/Ava/android/Trace/ISmatrixGenomeNormal.csv")

#ISmatrixTraceGoogle <- is.subset(itemsets,TraceGoogle)
#write.csv(ISmatrixTraceGoogle , file = "C:/Ava/android/Trace/ISmatrixTraceGoogle.csv")

#ISmatrixFDroid<- is.subset(itemsets,TraceFDroid)
#write.csv(ISmatrixFDroid, file = "C:/Ava/android/Trace/ISmatrixFDroid.csv")

ISmatrixGenomeInGoogleplay <- is.subset(itemsets,TraceGoogleplay)
tISmatrixGenomeInGoogleplay<-t(ISmatrixGenomeInGoogleplay)

ISmatrixTraceInGoogleplay <- is.subset(itemsetsGooglePlay,TraceGoogleplay)
tISmatrixTraceInGoogleplay<-t(ISmatrixTraceInGoogleplay)

ISmatrixTraceInGenome <- is.subset(itemsets,Trace)
tISmatrixTraceInGenome<-t(ISmatrixTraceInGenome)

ISmatrixGoogleplayInGenome <- is.subset(itemsetsGooglePlay,Trace)
tISmatrixGoogleplayInGenome<-t(ISmatrixGoogleplayInGenome)

# Androzoo
#ISmatrixZooInGoogleplay <- is.subset(itemsetstheZoo,TraceGoogleplay)
#tISmatrixZooInGoogleplay <-t(ISmatrixZooInGoogleplay)

#ISmatrixZooInZoo <- is.subset(itemsetstheZoo,TracetheZoo)
#tISmatrixZooInZoo <-t(ISmatrixZooInZoo)

#ISmatrixGoogleplayInZoo <- is.subset(itemsetsGooglePlay,TracetheZoo)
#tISmatrixGoogleplayInZoo <-t(ISmatrixGoogleplayInZoo )

#ISmatrixGenomeInZoo <- is.subset(itemsets,TracetheZoo)
#tISmatrixGenomeInZoo  <-t(ISmatrixGenomeInZoo)
#ISmatrixGooglePlayInZoo <- is.subset(itemsetsGooglePlay,TracetheZoo)
#tISmatrixGooglePlayInZoo <-t(ISmatrixGooglePlayInZoo )


#GGrow<-nrow(tISmatrixGooglePlayInZoo )
#C = matrix( ,nrow=GGrow, ncol=1)
#colnames(C) <- c("Result")
#for(i in 1:nrow(tISmatrixGooglePlayInZoo ))
#{
#	C[i, ]<-1
#}
#tempa<-cbind(tISmatrixGenomeInZoo  ,tISmatrixGooglePlayInZoo )
#GenomeGoogleplayZoo<-cbind(tempa ,C)



#GGrow<-nrow(tISmatrixGenomeInZoo)
#C = matrix( ,nrow=GGrow, ncol=1)
#colnames(C) <- c("Result")
#for(i in 1:nrow(tISmatrixGenomeInZoo))
#{
#	C[i, ]<-1
#}
#GenomeZoo<-cbind(tISmatrixGenomeInZoo ,C)

###############Add result column
#Androzoo and google itemsets
if(FALSE){
tempa<-rbind(tISmatrixZooInZoo ,tISmatrixZooInGoogleplay)
GGrow<-nrow(tISmatrixZooInZoo)+nrow(tISmatrixZooInGoogleplay)
C = matrix( ,nrow=GGrow, ncol=1)
colnames(C) <- c("Result")
for(i in 1:nrow(tISmatrixZooInZoo))
{
	C[i, ]<-1
}
for(i in nrow(tISmatrixZooInZoo)+1:nrow(tISmatrixZooInGoogleplay))
{
	C[i, ]<-0
}
ZooItemGoogle<-cbind(tempa,C)

# Androzoo and Google itemsets
tempa<-rbind(tISmatrixZooInZoo ,tISmatrixZooInGoogleplay )
tempb<-rbind(tISmatrixGoogleplayInZoo ,tISmatrixTraceInGoogleplay)
GGrow<-nrow(tISmatrixZooInZoo)+nrow(tISmatrixZooInGoogleplay)
C = matrix( ,nrow=GGrow, ncol=1)
colnames(C) <- c("Result")
for(i in 1:nrow(tISmatrixZooInZoo))
{
	C[i, ]<-1
}
for(i in nrow(tISmatrixZooInZoo)+1:nrow(tISmatrixZooInGoogleplay ))
{
	C[i, ]<-0
}
ZooGoogleItem<-cbind(tempa,tempb)
ZooGoogleItem<-cbind(ZooGoogleItem,C)

}

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
write.csv(SMOTEGenomeItemGoogle, file = "C:/Ava/android/Trace/SMOTEGenomeItemGoogleC.csv")
write.csv(SMOTEGenomeGoogleItem, file = "C:/Ava/android/Trace/SMOTEGenomeGoogleCItem.csv")

#write.csv(ZooItemGoogle, file = "C:/Ava/android/Trace/ZooItemGoogle.csv")
#write.csv(ZooGoogleItem, file = "C:/Ava/android/Trace/ZooGoogleItem.csv")

#write.csv(GenomeZoo, file = "C:/Ava/android/Trace/GenomeZoo.csv")
#write.csv(GenomeGoogleplayZoo, file = "C:/Ava/android/Trace/GenomeGoogleplayZoo.csv")


#write.csv(TRmatrix1, file = "C:/Ava/android/Trace/TRmatrixServices.csv")
#write.csv(TRmatrixG, file = "C:/Ava/android/Trace/TRmatrixMG.csv")
#write.csv(TRmatrixG1, file = "C:/Ava/android/Trace/TRmatrixMG1.csv")
#write.csv(TRmatrixFD, file = "C:/Ava/android/Trace/TRmatrixFD.csv")

#write.csv(TRmatrixGN, file = "C:/Ava/android/Trace/TRmatrixGN.csv")
#write.csv(TRmatrixGNp, file = "C:/Ava/android/Trace/TRmatrixGNp.csv")

#itemf<-itemFrequency(Trace)
#write.csv(itemf, file = "C:/Ava/android/Trace/itemfrequencyTrace.csv")


#write(TRmatrix1, file = "C:/Ava/android/Trace/TRmatrix.csv", sep = ",")
#unlink("C:/Ava/android/Trace/TRmatrix5.csv") # tidy up
