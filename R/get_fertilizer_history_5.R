get_fertilizer_history <- function (expID, treatment) {
  
###############################################################################################################################
'
Purpose:-
Obtain a data frame representing all the history of fertilizer application for a given treatment in a given experiment ID
Input :-
         expID, treatment
Output :-
         data frame with five columns
          (1) Date_of_application (2) Fertilzer (3) Amount (5) Depth_of_application (6) Method_of_application
'
data(Fertilisation)

# Step 1:-
# Subset fertilisation data frame based on expID
result <- Fertilisation[ (Fertilisation$ExpID == expID),]

# Step 2 :-
# SUbset based on if fertilizer is applied on treatment of intereste (or on "ALL" treatment)
result <- result [(result$Treatment == treatment) || (result$Treatment == "ALL"),]

# Step 3 :-
# Subset based on output columns of interest
result <- subset(result, select = c("Date", "Fertilizer", "Amount" , "Depth", "Method"))

# Step 4
# Rename column name appropriately
names(result)[1] ="Date_of_application"
names(result)[4] ="Depth_of_application"
names(result)[5] = "Method_of_application"

# Step 5
# return result from the current function
return(result)
}
