# Saving Experiment Lists
ExperimentList<-read.csv("/home/djaiswal/Research/gitprojects/sugarbag/inst/extdata/List.Of.Experiments.csv")
ExperimentList<-ExperimentList[,c(1,2)]
save(ExperimentList, file="/home/djaiswal/Research/gitprojects/sugarbag/data/ExperimentList.rda")

# Saving Harvest Data
HarvestData<-read.csv("/home/djaiswal/Research/gitprojects/sugarbag/inst/extdata/Harvest.Data.csv")
save(HarvestData, file="/home/djaiswal/Research/gitprojects/sugarbag/data/HarvestData.rda")

#Saving Weather Data
WeatherData<-read.csv("/home/djaiswal/Research/gitprojects/sugarbag/inst/extdata/Weather.Data.csv")
WeatherData<-WeatherData[,c(1,3,4,5,6,7,8)]
save(WeatherData, file="/home/djaiswal/Research/gitprojects/sugarbag/data/WeatherData.rda")


#Saving Soil Layer Data
SoilLayersData<-read.csv("/home/djaiswal/Research/gitprojects/sugarbag/inst/extdata/Soil.Layer.Data.csv")
save(SoilLayersData, file="/home/djaiswal/Research/gitprojects/sugarbag/data/SoilLayersData.rda")
