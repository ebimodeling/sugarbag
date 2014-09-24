tmp1<-ExperimentSummary[grepl("class", ExperimentSummary$ExpDesign),]
tmp2<-ExperimentSummary[grepl("Class", ExperimentSummary$ExpDesign),]
RatoonExperiments<-rbind(tmp1,tmp2)
save(RatoonExperiments,file="/home/djaiswal/Research/gitprojects/sugarbag/data/RatoonExperiments.rda")
