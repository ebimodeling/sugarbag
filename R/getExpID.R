GetExpID<-function()
{
  data(HarvestData)
  df<-unique(as.vector(HarvestData$ExpID))
  rm(list=("HarvestData"))
  return(df)
}


