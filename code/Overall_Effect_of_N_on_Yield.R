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

for (i in 26:30){
  id <- expID[i]
  tmp_output <- Total_N_for_expID(id, varname)
  Output <- rbind(Output,tmp_output)
}


for (i in 32:33){
  id <- expID[i]
  tmp_output <- Total_N_for_expID(id, varname)
  Output <- rbind(Output,tmp_output)
}

for (i in 37:40){
  id <- expID[i]
  tmp_output <- Total_N_for_expID(id, varname)
  Output <- rbind(Output,tmp_output)
}

for (i in 37:length(expID)){
  id <- expID[i]
  tmp_output <- Total_N_for_expID(id, varname)
  Output <- rbind(Output,tmp_output)
}

library(lattice)
png(file = "/home/djaiswal/Desktop/N_summary.png")
xyplot(DWMST ~ TotalN | ExpID , data= Output, auto.key=TRUE)
dev.off()
