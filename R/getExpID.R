GetMeasuredYield<-function(expID, varname)
{
  data(HarvestData)
  df<-HarvestData[HarvestData$ExpID==expID,]
  varcol<-df[which(names(df)==varname)]
  df<-cbind(df[,c(1,2,3,4)],varcol)
  return(df)
}


