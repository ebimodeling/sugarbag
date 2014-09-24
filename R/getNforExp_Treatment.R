getNforExp_Treatment<-function(expID=1,treatment=1)
{
  ############################################################################################
  '
  Purpose:
   Get a list of dates and associated N fertilizer application for a given Treatment in an ExpID
  Input:
    expID
    treatment (must be associated with expID)
  Output:
    A list containing Date, Fertilizer type, and amount applied.
  '
  ##############################################################################################
  
  data(Fertilisation)
  Fertilisation<-Fertilisation[Fertilisation$ExpID==expID,]
  Fertilisation<-Fertilisation[(Fertilisation$Treatment=="ALL")||(Fertilisation$Treatment==treatment),]
  result=list(date=as.vector(Fertilisation$Date), Fertilizer=as.vector(Fertilisation$Fertilizer), 
              Amount=as.vector(Fertilisation$Amount))
  return(result)  
}