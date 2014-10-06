GetExpID <- function()
{
#################################################################################################
# Purpose:
# To obtain list of experiment ID
# Input:- HarvestData file of SUGARBAG Database
# Output:-
# List of numbers which contains information about experimentID as defined in SUGARBAG databas
################################################################################################
  data(ExperimentDesign)
  df<-unique( as.vector( ExperimentDesign$ExpID ) )
  return(df)
}


