##################################################################################################
# Purpose:
#  We want to plot yield versus N application rate for all the studies in SUGARBAG database
#  Input:-
#  all files of SUGARBAG Database
#  Output:
#  Data frame which contain two colums of (1) Yield, and (2) N application rate
#  A Graph of Y versus N application rate
#  Slope and Intercept of Yield versus N application rate
###################################################################################################

# Step 1:- Get all the experiment IDs
expID <-GetExpID()

# Step 2 :- Define variable name that we are interested in
varname <- "DWMST"

# Step 3:- Call a function which will return all the plots associated with expID, along with treatment ID, date and value of measurement of variable of interest
result <- Get_Variable_from_ExpID(expID, varname)

#Step 4: - Add Treatment associated with Plot
treatment <- get_plot_and_treatments(expID)

#Step 5 :- Merge Treatment with the data table containing measured variable


# Step 4:- Call a function which will return start date of crop, which corresponds to a measurved value on a given date of a plot in an expID
result <- Add_start_date(expID,Plot,Treatment, varname, Date_Measurement )

result <-data.frame( Yield = numeric(), N_rate=numeric())
names(result)[1] <- varname

# Step 2:-  Get ID of all the experiments wgere N treatments were applied
# Which means all the rows (or ExpID) in ExperimentDesign data frame for which there is non-mising value in either of
# the three columns (1) N RATE (2) N Rates (3) N Rates over 2 years
data(ExperimentDesign)
experimentsubsets <-subset(ExperimentDesign, select  = c("ExpID", "Treatment","N.RATE", "N.Rates", "N.Rates.over.2.years"))
experimentsubsets <- data.frame(lapply(experimentsubsets, as.character), stringsAsFactors=FALSE)
experimentsubsets <- experimentsubsets [!(experimentsubsets$N.RATE == "") | !(experimentsubsets$N.Rates == "") | !(experimentsubsets$N.Rates.over.2.years == ""), ]
experimentsubset <- get_total_N(experimentsubsets)


expID <-as.vector(as.numeric(experimentsubsets$ExpID))
data(HarvestData)
varname= "DWMST"
harvestdata <- subset(HarvestData,select = c("ExpID","Plot", "Date", varname))
for ( i in 1: length(expID))
{
  harvestdata_expID <- harvestdata[(harvestdata$ExpID == expID[i]),]
  treatment <- get_plot_and_treatments(expID[i])
  harvestdata_expID <- merge(harvestdata_expID, treatment, by = "Plot")
  tmp <-experimentsubsets[experimentsubsets$ExpID == expID[i],]
  harvestdata <- merge(harvestdata, tmp, by = "Treatment")
}

harvestdata <- update_total_N (harvestdata)

experimentsubset <- function (experimentsubsets){
  N1 <- experimentsubsets$N.RATE
  N2 <- experimentsubsets$N.Rates
  N3 <- experimentsubsets$N.Rates.over.2.years
  N1_updated <- numeric (length(N1))
  N1_updated <- N_function1 (as.vector(N1))

  
}
 N_function1 <- function (N1){
   for (i in 1: length(N1)){
     if(N1[i] ==""){
       result = NA
     } else{
             if(N1[i] == "56 kg/ha"){
               result <- 56
             }
             if(N1[i] == "107 kg/ha"){
               result <- 107
             }
             if(N1[i] == "268 kg/ha"){
               result <- 268
             }
             if(N1[i] == "35 kg/ha"){
               result <- 35
             }
             if(N1[i] == "257 kg/ha"){
               result <- 257
             }
             if(N1[i] == "407 kg/ha"){
               result <- 407
             }
             if(N1[i] == "0 kg/ha"){
               result <- 0
             }
             if(N1[i] == "50 kg/ha"){
               result <- 50
             }
             if(N1[i] == "high"){
               result <- 400
             }
             if(N1[i] == "230 kg/ha"){
               result <- 230
             }
             if(N1[i] == "350 kg/ha"){
               result <- 350
             }
     }
   }
   return(result)
 }

Numerical_N.RATE <- function (N.RATE){
  
  if(N.RATE == "56 kg/ha"){
    result <- 56
  }
  if(N.RATE == "107 kg/ha"){
    result <- 107
  }
  if(N.RATE == "268 kg/ha"){
    result <- 268
  }
  if(N.RATE == "35 kg/ha"){
    result <- 35
  }
  if(N.RATE == "257 kg/ha"){
    result <- 257
  }
  if(N.RATE == "407 kg/ha"){
    result <- 407
  }
  if(N.RATE == "0 kg/ha"){
    result <- 0
  }
  if(N.RATE == "50 kg/ha"){
    result <- 50
  }
  if(N.RATE == "230 kg/ha"){
    result <- 230
  }
  if(N.RATE == "350 kg/ha"){
    result <- 350
  }
  if(N.RATE == ""){
    result = NA
  }
  return(result)  
}
# Step 3:- Get Number of experiments
N_experiment <- length(expID)

#Step 4:- Write a loop that runs over all the experimentIDs and returns 
#         required data frame of yield and N


for (i in 1:N_experiment){
  
  #Step 5:- Call a function which retursn Yield versus N for a given experimentID
  temporary <- Get_Yield_vs_N_from_ExpID(expID[i],varname)
  
  #step 6:- Combine temporary to results
  result <- rbind(result, temporary)
}

# Step 7 : Plot Yield vers N using result


# Step 8 : Calculate Slope of Yield versus N from result


