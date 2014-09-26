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
  
  # Identify startdate and enddate associated with measured variable and update result
  # by inserting additional columns of startdate and enddate
  get_start_end_date(result)
  
    
  # Calculate Total fertilizer applied for each measurement on each plot between start and end date
  get_total_N_between_start_end(result)
                      
                      result$totalN=0
                      for (i in 1:length(result$Treatment))
                      {
                       fertilizer <- getNforExp_Treatment(expID,as.vector(result$Treatment[i]))
                       result$totalN[i]<-sum(fertilizer$Amount)
                      }  
                      Fertilisation<-Fertilisation[(Fertilisation$ExpID==expID),]
            
  #Step 3:- Calculate Total N application using dataframe of Time, N amount for
  #         a given plot
  #Step 4:- Combine Total N application and a single measured value of variable for 
  #          a plot ID wit given ExpID
  #Step 5:- Use rbind to combine total N for all the plots with  given ExpID
  #Step 6:- Return ExpID with columns for plot ID and Total N for all the plots
  #         of a given ExpID
    
}