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

# Step 1:- What are we interest in?
varname <- "DWMST"
result <-data.frame( Yield = numeric(), N_rate=numeric())
names(result)[1] <- varname

# Step 2:-  Get ID of all the experiments
expID <- GetExpID()

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


