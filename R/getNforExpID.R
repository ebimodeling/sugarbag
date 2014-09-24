getNinfo<-function(expID)
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
  ##############################################################################
  #step 1:- Identify all the plots associated with this ExpID and define result data frame
  data(HarvestData)
  varname="DWMST"
  HarvestData <- subset(HarvestData,select=c("ExpID","Plot", "Date", varname))
  result <- HarvestData[(HarvestData$ExpID==expID),]
  #Step 2:- Call a function which returns a dataframe of(Time, N Amount)
  #         given ExpID and plotID and call this function in loop to calculate total N application
  
           # Step 2a:- We are using Fertilization worksheet [in SUGARBAG Experiment]
           #          Which contains information about Treatment and N application
           #          Therefore we need to relate PlotID with treatment to use this information
           #          Except when N application is same for "all the treatment"
                      treatment <- get_plot_and_treatments(expID)
                      #Function call to get harvest data and start and end date, which will be used
                      #to calculate associated N application
                      get_harvestdata_start_end_date(result)
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