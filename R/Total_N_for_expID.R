Total_N_for_expID <- function (expID, varname){

# Step 1:- Call a function which will return all the plots associated with expID, along with treatment ID, date and value of measurement of variable of interest
result <- Get_Variable_from_ExpID(expID, varname)

#Step 2: - Add Treatment associated with Plot
treatment <- get_plot_and_treatments(expID)

#Step 3 :- Merge Treatment with the data table containing measured variable
result <- merge(result, treatment, by ="Plot")

# Step 4:- Call a function which will return start date of crop, which corresponds to a measurved value on a given date of a plot in an expID
startdate <- get_start_date (expID) # I am using a single value for each expID. This needs to be modified??

#Step 5 : -  Merge Start date column in the result data frame
result$Start_Date = startdate

for ( i in 1: dim(result)[1]){
#Step 6 :- Get a Data frame showing all the N application for given expID and treatment
treatment <-result$Treatment[i]
N_application_on_expID <- Get_N_application(expID, treatment)


#Step 7 :- Calculate total N application based on N application dataframe, date of application, start date and date of harvest (or date of measurement)
startdate <- result$Start_Date[i]
enddate <- result$Date[i]
TotalN <- Calculate_N_from_Start_to_End (N_application_on_expID, startdate, enddate)

# Step 8 :- Update total N for the Plot of expID
result$TotalN[i] <- TotalN
}
return(result)
}
