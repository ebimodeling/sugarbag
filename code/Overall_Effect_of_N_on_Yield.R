# Step 1:- Get all the experiment IDs  for whic Harvest, Experiment Design and Planting information is available
expID <-GetExpID()

# Step 2 :- Define variable name that we are interested in
varname <- "DWMST"

# Creating initial dataframe that will be used for RBIND
id <- expID[1]
Output <- Total_N_for_expID(id, varname)
N = length(expID)

# Get N versus Yield data from all the experiments andRBIND them to Output
for (i in 2:N){
  id <- expID[i]
  tmp_output <- Total_N_for_expID(id, varname)
  Output <- rbind(Output,tmp_output)
}


# Plot Yield versus N for all the Experiments
library(lattice)
png(file = "/home/djaiswal/Desktop/N_summary.png")
Output$ExpID = as.factor(Output$ExpID)
xyplot(DWMST ~ TotalN | ExpID, data= Output)
dev.off()
