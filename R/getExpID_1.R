GetExpID_for_N_Combined <- function()
{
#################################################################################################
# Purpose:
# To obtain list of experiment ID
# Input:- HarvestData file of SUGARBAG Database
# Output:-
# # Only includes IDs for which both planting date, experiment Design, and Measurned variable information is available
################################################################################################
  data(ExperimentDesign)
 ExpID_with_N_combined <- ExperimentDesign[ !(is.na(ExperimentDesign$Ncombined)),]
  result<-unique( as.vector( ExpID_with_N_combined$ExpID ) )
  return(result)
}
