Get_Variable_from_ExpID <-function(expID, varname){
  data(HarvestData)
  harvestdata <- subset(HarvestData,select = c("ExpID","Plot", "Date", varname))
  result <- harvestdata[(harvestdata$ExpID == expID),]
  return (result)
}
