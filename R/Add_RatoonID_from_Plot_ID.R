Add_RatoonID_from_Plot_ID<-function(df)
{
  Treatment=as.character()
  for (i in 1:dim(df)[1])
  {
    tmprow=ExperimentDesign[as.character(ExperimentDesign$Plot)==as.character(df$Plot[i]),]
    tmprow=tmprow[tmprow$ExpID==df$ExpID[1],]
    Treatment[i]=as.character(tmprow$CROP.CLASS)
  }
return(df)
}
