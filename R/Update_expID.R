Update_expID <- function (expID, varname){
# Step 1:- Call a function which will return all the plots associated with expID, along with treatment ID, date and value of measurement of variable of interest
result <- Get_Variable_from_ExpID(expID, varname)

#Step 2: - Add Treatment and N Combined associated with Plot
treatment <- get_plot_and_treatments(expID)

#Step 3 :- Merge Treatment and N Combined with the data table containing measured variable
result <- merge(result, treatment, by ="Plot")
return(result)
}
