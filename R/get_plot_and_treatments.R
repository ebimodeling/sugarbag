get_plot_and_treatments<-function(expID)
{
  ################################################################################################
  ' 
  Purpose:
   for a given experiment ID, we want to find plot number and associated Treatment number
  Input:
   experimentID
  Output:
  dataframe containing plotID and TreatmentID
  '
  ################################################################################################
  data(ExperimentDesign) # This contain information for relating plotID to Treatment
  ExpDesign<-subset(ExperimentDesign, select=c("ExpID","Plot","Treatment"))
  # subset of ExpDesign for the given ExpID
  result<-ExpDesign[(ExpDesign$ExpID==expID),]
  result<-result[,c(-1)]
  return(result)
}