GetExpID <- function()
{
#################################################################################################
# Purpose:
# To obtain list of experiment ID
# Input:- HarvestData file of SUGARBAG Database
# Output:-
# # Only includes IDs for which both planting date, experiment Design, and Measurned variable information is available
################################################################################################
  data(ExperimentDesign)
  df1<-unique( as.vector( ExperimentDesign$ExpID ) )

  data(Planting)
  df2 <- unique (as.vector(Planting$ExpID))

  data(HarvestData)
  df3 <- unique (as.vector(HarvestData$ExpID))

  df <-unique (c(df1,df2,df3))
  j=1
  result<-list()
  for (i in 1:length(df)){
    if(( df[i] %in% df1) && (df[i] %in% df2) && (df[i] %in% df3)){
      result[j] = df[i]
      j <- j+1
    }
  }
 result <- as.vector(unlist(result)) 
  return(result)
}
