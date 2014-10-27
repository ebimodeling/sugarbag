' The following code is simply generating .rda file for
  the dependent variables (measured) in SUGARBAG
'
setwd("/home/djaiswal/Research/gitprojects/sugarbag")
#setwd("/Users/David LeBauer/R-dev/sugarbag")
# Saving Experiment Lists
ExperimentList<-read.csv("inst/extdata/List.Of.Experiments.csv", stringsAsFactors=FALSE)
ExperimentList<-ExperimentList[,c(1,2)]
save(ExperimentList, file="data/ExperimentList.rda")

# Saving Harvest Data
HarvestData<-read.csv("inst/extdata/Harvest.Data.csv", stringsAsFactors=FALSE)
save(HarvestData, file="data/HarvestData.rda")


#Saving Weather Data
WeatherData<-read.csv("inst/extdata/Weather.Data.csv", stringsAsFactors=FALSE)
WeatherData<-WeatherData[,c(1,3,4,5,6,7,8)]
save(WeatherData, file="data/WeatherData.rda")


#Saving Soil Layer Data
SoilLayersData<-read.csv("inst/extdata/Soil.Layer.Data.csv", stringsAsFactors=FALSE)
save(SoilLayersData, file="data/SoilLayersData.rda")



'
The following section is simply generating .rda file for variables
available in the Experiment File
'

# Saving Experiment Summary
ExperimentSummary<-read.csv("inst/extdata/Experiment.Summary.csv", stringsAsFactors=FALSE)
save(ExperimentSummary, file="data/ExperimentSummary.rda")

# Saving Experiment Design
<<<<<<< HEAD
ExperimentDesign<-read.csv("inst/extdata/Experiment.Design.csv", stringsAsFactors=FALSE)
save(ExperimentDesign, file="data/ExperimentDesign.rda")
=======
ExperimentDesign<-read.csv("/home/djaiswal/Research/gitprojects/sugarbag/inst/extdata/Experiment.Design.csv", stringsAsFactors=FALSE)
ExperimentDesign<-read.csv("C:/Users/djaiswal/Documents/R-dev/sugarbag/inst/extdata/Experiment.Design.csv", stringsAsFactors=FALSE)
save(ExperimentDesign, file="/home/djaiswal/Research/gitprojects/sugarbag/data/ExperimentDesign.rda")
save(ExperimentDesign, file="C:/Users/djaiswal/Documents/R-dev/sugarbag//data/ExperimentDesign.rda")

# Saving Irrigation
Irrigation<-read.csv("C:/Users/djaiswal/Documents/R-dev/sugarbag/inst/extdata/Irrigation.csv", stringsAsFactors=FALSE)
save(Irrigation,file="C:/Users/djaiswal/Documents/R-dev/sugarbag//data/Irrigation.rda")
>>>>>>> 067bd69f7273a0069dbf9eabbbc3e375ce039f59

#Saving Experiment Field
FixedFields<-read.csv("inst/extdata/Experiment.Field.csv", stringsAsFactors=FALSE)
FixedFields<-FixedFields[,c(1,3:9,11)]
save(FixedFields, file="data/FixedFields.rda")

# Saving Fertilisation
Fertilisation<-read.csv("inst/extdata/Fertilization.csv", stringsAsFactors=FALSE)
save(Fertilisation, file="data/Fertilisation.rda")

# Saving Planting Information
Planting<-read.csv("inst/extdata/Planting.csv", stringsAsFactors=FALSE)
save(Planting, file="data/Planting.rda")


# Saving Experiment Sites
<<<<<<< HEAD
Experiment.Site<-read.csv("inst/extdata/Experiment.Site.csv", stringsAsFactors=FALSE)
save(Experiment.Site, file="data/Experiment.Site.rda")
=======
Experiment.Site<-read.csv("/home/djaiswal/Research/gitprojects/sugarbag/inst/extdata/Experiment.Site.csv", stringsAsFactors=FALSE)
save(Experiment.Site, file="/home/djaiswal/Research/gitprojects/sugarbag/data/Experiment.Site.rda")

# Ursula's file
Experiment.Site<-read.csv("C:/Users/ruizver1/Documents/myprojectEBI/sugarbag/inst/extdata/Experiment.Site.csv", stringsAsFactors=FALSE)
save(Experiment.Site, file="C:/Users/ruizver1/Documents/myprojectEBI/sugarbag/data/Experiment.Site.rda")
>>>>>>> 067bd69f7273a0069dbf9eabbbc3e375ce039f59
