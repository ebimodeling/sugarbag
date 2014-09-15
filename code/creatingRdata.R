' The following code is simply generating .rda file for
  the dependent variables (measured) in SUGARBAG
'
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



'
The following section is simply generating .rda file for variables
available in the Experiment File
'

# Saving Experiment Summary
ExperimentSummary<-read.csv("/home/djaiswal/Research/gitprojects/sugarbag/inst/extdata/Experiment.Summary.csv")
save(ExperimentSummary, file="/home/djaiswal/Research/gitprojects/sugarbag/data/ExperimentSummary.rda")

# Saving Experiment Design
ExperimentDesign<-read.csv("/home/djaiswal/Research/gitprojects/sugarbag/inst/extdata/Experiment.Design.csv")
save(ExperimentDesign, file="/home/djaiswal/Research/gitprojects/sugarbag/data/ExperimentDesign.rda")

#Saving Experiment Field
FixedFields<-read.csv("/home/djaiswal/Research/gitprojects/sugarbag/inst/extdata/Experiment.Field.csv")
FixedFields<-FixedFields[,c(1,3:9,11)]
save(FixedFields, file="/home/djaiswal/Research/gitprojects/sugarbag/data/FixedFields.rda")
