# Step 1:- Get all the experiment IDs
expID <-GetExpID()

# Step 2 :- Define variable name that we are interested in
varname <- "DWMST"

id <- expID[1]
Output <- Total_N_for_expID(id, varname)


for (i in 2:11){
  id <- expID[i]
  tmp_output <- Total_N_for_expID(id, varname)
  Output <- rbind(Output,tmp_output)
}

for (i in 13:19){
  id <- expID[i]
  tmp_output <- Total_N_for_expID(id, varname)
  Output <- rbind(Output,tmp_output)
}

for (i in 23:24){
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
png(file = "/home/djaiswal/Desktop/N_summary.png")
xyplot(DWMST ~ TotalN | ExpID , data= Output, auto.key=TRUE)
dev.off()
