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
  ExpDesign<-subset(ExperimentDesign, select=c("ExpID","Plot","Treatment", 'Ncombined', 'Cultivar'))
  # subset of ExpDesign for the given ExpID
  result<-ExpDesign[(ExpDesign$ExpID==expID),]
  result<-result[,c(-1)]
  # Adding Irrigation
  data(Irrigation)
  IrrigatedExp <- unique(as.vector(Irrigation$ExpID))
  Irrigation <- Irrigation[(Irrigation$ExpID == expID),]
  IrrigatedTreatment <- unique(Irrigation$Treatment)
  
  result$Irrigation = 0
  if(expID %in% IrrigatedExp){
     
        if(IrrigatedTreatment[1] == "ALL") 
           {
               result$Irrigation = 1
        } else {
          result[(result$Treatment %in% IrrigatedTreatment),]$Irrigation = 1
        }
        
     } else {
    result$Irrigation = 0
  }
  return(result)
}
