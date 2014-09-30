get_start_date <- function(expID, Plot,Harvest_date){
  ################################################################################################################################
  '
   Purpose:-
   Get Start date (planting date for plant crop or previous harvest date for a ratoon crop) for harvested variable on Harvest_date 
   on a given Plot of an experiment ID.
   Input : -
   Experiment ID   expID
   Plot            Plot number with in Experiment ID
   Harvest_date    date when measurement were made on the Plot
  
   Output: -
   Date of starting of crop on which measured data is provided.  
  '
  data(ExperimentSummary)
  #Step 1:- Get Subset of Experiment Summary for the given expID
  expIDsummary <- ExperimentSummary [ (ExperimentSummary$ ExpID == expID),]
  
  # Step 2: - Get start date
  # If there is a unique planting date in Planting csv file (or data) then It is reasonable to assume this to be start date
  data(Planting)
  expIDplanting <- Planting [(Planting$ExpID == expID),]
  
  Is_Unique_Starting_Date <- !(grepl("crop class" , expIDsummary$Description, fixed = TRUE)) && !(grepl("Growth Analysis" , expIDsummary$Description, fixed = TRUE))
  && !(grepl("Growth Analysis" , expIDsummary$Description, fixed = TRUE)) && !(grepl("Growth Analysis" , expIDsummary$Description, fixed = TRUE))
  
  # Step 3: - If this experiment has a unique starting date then read it
  if(Is_Unique_Starting_Date)
}
