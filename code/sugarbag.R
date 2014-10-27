library(sugarbag)
library(udunits2)
library(dplyr)
#setwd(system.file("extdata", package = "sugarbag"))
setwd("/Users/David LeBauer/R-dev/sugarbag/inst/extdata/")
## Reading Fixed Information
Fx.ClimateVar <- fread("Climate.Variables.csv")
Fx.Crop.Variables <- fread("Crop.Variables.csv")
Fx.Experiment.Field <- fread("Experiment.Field.csv")
Fx.Experiment.Site <- fread("Experiment.Site.csv")
Fx.Factors <- fread("Factors.csv")
Fx.Fertilizer <- transform(fread("Fertilizer.csv"), Fertilizer = Fertiliser)
Fx.Method <- fread("Method.csv")
Fx.Notes  <-  fread("Notes.csv")
Fx.Researcher <- fread("Researcher.csv")
Fx.Soil <- fread("Soil.csv")
Fx.Soil.Layers <- fread("Soil.Layers.csv")
Fx.Soil.Variables <- fread("Soil.Variables.csv")
Fx.Weather.Station <- fread("Weather.Station.csv")
Notes <- fread("Notes.csv")  	
Experiment.Summary <- fread("Experiment.Summary.csv")		
ResearcherPerExperiment <- fread("ResearchersPerExperiment.csv")	
Experiment.Design <- data.table(read.csv("Experiment.Design.csv"), key = 'ExpID,Plot')
Weather.Data <- data.table(read.csv("Weather.Data.csv", stringsAsFactors = FALSE))
Weather.Data <- mutate(Weather.Data, Date = dmy(Date))
Fertilization <- fread("Fertilization.csv")
## traits and yields  	
Harvest.Data <- data.table(read.csv("Harvest.Data.csv", stringsAsFactors = FALSE))
Harvest.Data <- mutate(Harvest.Data, Date = mdy(Date), 
              Sample = as.numeric(gsub("[Ss]", "", Harvest.Data$Sample))) 
variables <- fread("all.variables.csv")
save(Experiment.Summary, Fx.ClimateVar, Fx.Crop.Variables, Fx.Experiment.Field, Fx.Experiment.Site, 
     Fx.Factors, Fx.Fertilizer, Fx.Method, Fx.Notes, Fx.Researcher, Fx.Soil, Fx.Soil.Layers, 
     Fx.Soil.Variables, Fx.Weather.Station, Notes, ResearcherPerExperiment, Weather.Data, Harvest.Data,
     Experiment.Design, variables, Fertilization,
     file = "/Users/David LeBauer/R-dev/sugarbag/data/Sugarbag.RData")


#data(Sugarbag)

traits <- data.table(Harvest.Data, key = c("ExpID", "Plot", "Date", "Sample"))
traits <- melt(traits,
               id.var = c("ExpID", "Plot", "Date", "Sample"), 
               variable.name = "variables.name", 
               value.name = "mean", na.rm = TRUE)

## cultivars

cultivars <- Experiment.Design[!is.na(Cultivar),list(ExpID, Plot, Cultivar)]

traits <- merge(traits, cultivars, by = c("ExpID", "Plot"), all.x = TRUE)

## sites

sites <- data.table(Fx.Experiment.Site, key = "SiteID")
experiment.summary <- data.table(Experiment.Summary, key = "ExpID")
experiments_sites <- data.table(experiment.summary)[,list(ExpID, MetStation, planting = BeginDate), by = "SiteID"]
experiments_sites$planting <- mdy(experiments_sites$planting)
sites <- merge(sites, experiments_sites, by = "SiteID")

bety.sites <- sites[,list(sitename = SiteName, 
                          lat = Latitude, 
                          lon = Longitude, 
                          city = City, state = Region), by = "SiteID"]

traits <- merge(traits, sites, by = "ExpID")


## Treatments
experiment.design <- data.table(melt(Experiment.Design, id.var = c('ExpID','Treatment','Rep', 'Plot'), 
                                     variable.name = "managements.type", value.var = "managements.level", 
                                     na.rm = TRUE))[value != ""]

### assign '1' to missing values of Replication
experiment.design <- mutate(experiment.design, Rep = ifelse(is.na(Rep), 1, Rep))

## Currently not clear what data we need from experiment.design:
## Fertilization is in Fertilization.csv
## Irrigation in Irrigation.csv
## traits <- merge(traits, experiment.design, by = c('ExpID','Plot'))

## Variables

if(sum(!unique(traits$variables.name) %in% variables$VariableName)>0){
  stop(paste("missing", unique(traits$variables.name)[which(!unique(traits$variables.name) %in% variables$VariableName)]))  
}

variables <- variables[, list(variables.name = VariableName, 
                              variables.description = VariableDescription,
                              units = Units)]
traits <- merge(traits, variables, by = 'variables.name')


traits[units == "g/m2"]$mean <- traits[units == "g/m2", ud.convert(mean, "g/m2", "Mg/ha")]
traits[units == "g/m2"]$units <- "Mg/ha"

setnames(traits, c("Plot", "Date", "Cultivar", "SiteName", "City", "Region", "Latitude", "Longitude", "Elevation"), 
         c("entity_id", "date", "cultivars.name", "sites.sitename", "sites.city", "sites.state", "lat", "lon", "masl"))

## Yields: total aboveground dry weight

### DWMST: Dry Weight Millable Stem === Yield
yields <- traits[variables.name == "DWMST",]

stem_yields <- traits[variables.name == "DWTOTA",]

## harvests
harvests <- yields[, list(foo =unique(date)), by = 'ExpID']


yields <- traits[variables.name %in% c("TDWT"),]

cultivars <- Experiment.Design[, list(ExpID, Treatment, Rep, Plot, Cultivar)]
treatments <- cbind(Experiment.Design[,list(ExpID, Treatment, Rep, Plot)], 
                    name = Experiment.Design[
                      , paste0(CROP.CLASS, Crop.Start, Crop.Start.Date, Crop.Start.Time, Drying.Off, Drying.Off.1,
                               FUMIGATION, Fumigation...Irrigation, Harvest, Harvest.Date, Harvest.Time, Initiation.Date, 
                               Irrigation, Lodging.Management, N.RATE, N.Rates, N.Rates.over.2.years, Ratoon.date)])

## managements

Fx.Fertilizer <- transform(Fx.Fertilizer, percentN = `N%`/100)
n.conversions <- Fx.Fertilizer[,list(Fertilizer, percentN)]

Fertilization <- merge(Fertilization, n.conversions, by = "Fertilizer")
fertilization <- Fertilization[percentN > 0 & Amount > 0, 
                               list(ExpID, Treatment, Date = mdy(Date), 
                                    fertilizerN = Amount * percentN)]
fertilization <- mutate(fertilization, year = year(Date))
### fertilization summarized by year:
fertilization <- fertilization[,list(fertilizerN = sum(fertilizerN), Treatment),by='ExpID,year']

#### NEED TO PICK UP HERE for the merge 

# melt so that 
foo <- fertilization[Treatment == "ALL", list(year, fertilizerN), key = ExpID]
t <- treatments[,Treatment, key = ExpID]
merge(foo, t, all = TRUE)
fertilization.all <- [foo]
, 
                           foo)
                           by = 'ExpID')
fertilization.notall <- fertilization[fertilization$Treatment != "ALL", ]
fertilization <- rbind(fertilization.all, fertilization.notall)

fertilizerN.total <- ddply(fertilization, 
                           .(ExpID, Treatment), 
                           summarize, fertilizerN = sum(fertilizerN))
## combine planting, irrigation, fertilization, tillage into managements






## Create BETYdb variables table
varcols <- c("Measurement.Type", "Variable.Name", "Variable.Description", "Units")
SB.variables <- rbind(Fx.Crop.Variables[,varcols], Fx.ClimateVar[,varcols], Fx.Soil.Variables[,varcols])
variables <- with(SB.variables, 
                  data.frame(id = 1:nrow(SB.variables),
                             description = Variable.Description,
                             name = paste(Measurement.Type, Variable.Name),
                             SB.id = Variable.Name))

## sites table
sites <- with(Fx.Experiment.Site,
              data.frame(id = 1:nrow(Fx.Experiment.Site),
                         city = City,
                         state = Region,
                         lat = Latitude,
                         lon = Longitude,
                         masl = Elevation,
                         sitename = Site.Name,
                         SB.id = Site.ID))

## merge yields w/ meta-data

Y <- merge(yields, cultivars, by = c("ExpID", "Plot"), all = TRUE)
Y2 <- merge(Y, treatments, by = c("ExpID", "Plot", "Treatment", "Rep"), all = TRUE)
Y3 <- merge(Y2, fertilizerN.total, by = c("ExpID", "Treatment"), all = TRUE)
ggplot(data = Y3, aes(fertilizerN, mean)) + geom_point()

## transform Harvest Data from wide to long

## transform soil layer data from wide to long

## combine soil data and harvest data into traits table (yields in yields table)

## Reading Data Table for above ground biomass
ABGDB <- Harvest.Data[!(is.na(Harvest.Data$DWTOTA)),c(1,3,4,5,35)]

experiment.design <- as.numeric(levels(experiment.design)[experiment.design])
experiment.design <- data.table(as.numeric(levels(experiment.design)[experiment.design]))

for ( i in 1: length(Nrate))
{
  expID <- ABGDB[i,]$ExpID
  pplot <- ABGDB[i,]$Plot
  ABGDB[i,]$Nrate <- experiment.design[((ExpID==expID)&&(experiment.design$Plot==pplot)),]$NRate
}
