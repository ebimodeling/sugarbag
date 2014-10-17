# Step 1:- Get all the experiment IDs  for whic Harvest, Experiment Design and Planting information is available
expID <-GetExpID_for_N_Combined()

# Step 2 :- Define variable name that we are interested in
varname <- "DWMST"

# Creating initial dataframe that will be used for RBIND
id <- expID[1]
Output <- Update_expID(id, varname)
N = length(expID)

# Get N versus Yield data from all the experiments andRBIND them to Output
for (i in 2:N){
  id <- expID[i]
  tmp_output <- Update_expID(id, varname)
  Output <- rbind(Output,tmp_output)
}


# Plot Yield versus N for all the Experiments
library(lattice)
png(file = "/home/djaiswal/Desktop/N_summary.png")
Output$Irrigation = as.factor(Output$Irrigation)
xyplot(DWMST ~ Ncombined | Irrigation, data= Output, type = "p", cex = 0.3, xlim = c(0,1000))
dev.off()

xyplot(DWMST~Ncombined, data=Output)

#Density Plot of DWMST
plot(density(Output$DWMST, na.rm=TRUE))

#Density Plot of TotalN
plot(density(Output$TotalN, na.rm=TRUE))
