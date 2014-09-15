Add_RatoonID_from_Plot_ID<-function(df)
{
  Treatment=as.character()
  for (i in 1:dim(df)[1])
  {
    tmprow=ExperimentDesign[as.character(ExperimentDesign$ExpID)==as.character(df$ExpID[i]),]
    Treatment[i]=as.character(tmprow$CROP.CLASS[which(as.character(tmprow$Plot)==as.character(df$Plot[i]))])
  }
  
  df<-cbind(df,Treatment)
return(df)
}
