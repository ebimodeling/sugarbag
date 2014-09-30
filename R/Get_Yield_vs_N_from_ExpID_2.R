Get_Yield_vs_N_from_ExpID <- function(expID, varname)
{  
  ###############################################################################
  '
  Purpose:
  #       Get data Frame of Plot ID and Total N for a given ExpID
  #Input:
  #       ExpID
  #Output:
         dataframe containing Total N application from multiple plots of a ExpID  
  '
  ###############################################################################
  # Step 1:-
  #        Since Harvest data contains all the measured variables (including yield)
  #        we will start working with HarvestData. Our first step is to get all the
  #        measured data of varname from ExpID
           data(HarvestData)
  
  # Step 2:- Subset Harvestdata so that we only have variable that we are interested (varname)
  #          and plot information to find N rate and date of measurement to calculate N rate for
  #          a the measurement
  harvestdata <- subset(HarvestData,select = c("ExpID","Plot", "Date", varname))
  
  # Step 3:- Change name of Date column to harvestdate
  names(harvestdata)[3]="Harvest_Date"
  
  #Step 4 :- Get data only for experimentID we are currently interested in
  harvestdata <- harvestdata[(harvestdata$ExpID == expID),]
  

  # Step 5 :- identiy treatment for each plot in each expID
  treatment <- get_plot_and_treatments(expID)
  
    
  #Step 6: - Add Treatment in harvestdata 
  harvestdata <- merge(harvestdata, treatment, by = "Plot")
  
  # Step 7:- Add total N application based on  corresponding date of measurement on each plot
  harvestdata <- Add_total_N_from_ExpDesign(harvestdata)    
  
  # Step 8: -
  # Return updated data frame harvestdata 
  return(harvestdata)
}
