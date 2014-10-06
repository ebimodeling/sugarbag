Calculate_N_from_Start_to_End <- function(N_application_on_expID, startdate, enddate){
  startdate <- dmy(startdate)
  enddate <-dmy(enddate)
  N_application_on_expID$Date <- dmy(N_application_on_expID$Date)
  N_applied <- N_application_on_expID[(N_application_on_expID$Date >= startdate) & (N_application_on_expID$Date < enddate),]
  if(dim(N_applied)[1]>0){
    result <-sum(N_applied$TotalN)
  } else {
    result <- 0
  }
  return(result)
}
