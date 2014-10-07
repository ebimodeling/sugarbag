# Step 1:- Get all the experiment IDs
expID <-GetExpID()

# Step 2 :- Define variable name that we are interested in
varname <- "DWMST"

id <- expID[1]
Output <- Total_N_for_expID(id, varname)
N = length(expID)

for (i in 2:N){
  id <- expID[i]
  tmp_output <- Total_N_for_expID(id, varname)
  Output <- rbind(Output,tmp_output)
}

for (i in 76:N){
  id <- expID[i]
  tmp_output <- Total_N_for_expID(id, varname)
  Output <- rbind(Output,tmp_output)
}

library(lattice)
png(file = "/home/djaiswal/Desktop/N_summary.png")
Output$ExpID = as.factor(Output$ExpID)
xyplot(DWMST ~ TotalN | ExpID, data= Output)
dev.off()
