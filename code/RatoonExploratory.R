data(RatoonExperiments)
data(HarvestData)
for (i in 1:dim(RatoonExperiments[1])){
  expID<-RatoonExperiments[i,]$ExpID
  df<-GetMeasuredYield(expID, "DWMST")
  df<-Add_RatoonID_from_Plot_ID(df)
  xyplot(DWMST~Date, data=df, group=Treatment,  auto.key=TRUE, grid=TRUE)
}

RatoonExperiments<-Add_RatoonID_from_Plot_ID(RatoonExperiments)
