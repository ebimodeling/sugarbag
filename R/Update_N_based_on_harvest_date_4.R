Update_N_based_on_harvest_date <- function (harvestdata){

  ###################################################################################
  '
  Purpose:-
  To obtain total N application corresponding to a given harvest date in a plot
  Input:- 
  a data frame containing following columns
  (1) Plot (2) ExpID (3) Harvest_Date   (4) DWMST (5) Treatment
  Output: -
  Input data frame with additional column for Total_N
  '
  #####################################################################################
  # Step 1:-
  #  Declaring Total_N columns
  Total_N = numeric(dim(harvestdata)[1])
  
  for (i in in 1: dim(harvestdata)[1])
  {
  # Step 2:-
  # Find out what is history of Fertilizer application for a given treatment in a given Experiment ID
  fertilizer_history <- get_fertilizer_history(expID, treatment)
  
  # Step 3 :- 
  # Find out what is the beginning date for a given Harvest_date of measurement  on a plot in a given experiment ID
  startdate <- get_start_date(expID, Harvest_date)
  
  # Step 4 :- 
  # Calculate amount of total Fertilizer applied for a given  data frame for fertilizer_history [with date],
  # and start_date and Harvest_date
  tmp <- calculate_total_N_from_start_to_harvest (fertilzer_history,startdate, Harvest_Date[i])
  
  # Step 5 : -
  # Udate ith component of vector containing total_N to 
  Total_N[i] = tmp
  }
  
  # Step 6: -
  # add vector total_N to the input data frame
  harvestdata$Total_N = Total_N
  
  #Step 7 :-
  # return updated dataframe
  return(harvestdata)  
}
