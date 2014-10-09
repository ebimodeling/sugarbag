get_start_date <- function(expID){
data(Planting)
result <- Planting [Planting$ExpID == expID,]
date <-result$PlantingDate[1]
 if(date =="") { date <- result$PlantingDate[2]}
return(date)
}
