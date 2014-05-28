setwd(system.file("extdata", package = "sugarbag"))
library(udunits2)

## Reading Fixed Information
Fx.ClimateVar <- read.csv("Climate.Variables.csv")
Fx.Crop.Variables <- read.csv("Crop.Variables.csv")
Fx.Experiment.Field <- read.csv("Experiment.Field.csv")
Fx.Experiment.Site <- read.csv("Experiment.Site.csv")
Fx.Factors <- read.csv("Factors.csv")
Fx.Fertilizer <- transform(read.csv("Fertilizer.csv"), Fertilizer = Fertiliser)
Fx.Method <- read.csv("Method.csv")
Fx.Notes  <-  read.csv("Notes.csv")
Fx.Researcher <- read.csv("Researcher.csv")
Fx.Soil <- read.csv("Soil.csv")
Fx.Soil.Layers <- read.csv("Soil.Layers.csv")
Fx.Soil.Variables <- read.csv("Soil.Variables.csv")
Fx.Weather.Station <- read.csv("Weather.Station.csv")
# List.Of.Experiment <- read.csv("List.Of.Experiments.csv") only contains expt name
Notes <- read.csv("Notes.csv")
Experiment.Summary <- read.csv("Experiment.Summary.csv")
ResearcherPerExperiment <- read.csv("ResearchersPerExperiment.csv")
Weather.Data <- read.csv("Weather.Data.csv")

## traits and yields
Harvest.Data <- read.csv("Harvest.Data.csv")


traits <- data.table(Harvest.Data, key = c("ExpID", "Plot", "Date", "Sample"))
traits <- data.table(melt(traits, id.var = c("ExpID", "Plot", "Date", "Sample"), variable.name = "variables.name", value.name = "mean", na.rm = TRUE))
traits$Date <- lubridate::dmy(traits$Date)


## cultivars
Experiment.Design <- data.table(read.csv("Experiment.Design.csv"), key = 'ExpID,Plot')
cultivars <- Experiment.Design[!is.na(Cultivar),list(ExpID, Plot, Cultivar)]

traits <- merge(traits, cultivars, by = c("ExpID", "Plot"))

## sites

sites <- data.table(Fx.Experiment.Site, key = "SiteID")
experiment.summary <- data.table(Experiment.Summary, key = "ExpID")
experiments_sites <- data.table(experiment.summary)[,list(ExpID, MetStation, planting = BeginDate), by = "SiteID"]
experiments_sites$planting <- mdy(experiments_sites$planting)
sites <- merge(sites, experiments_sites)

bety.sites <- sites[,list(sitename = SiteName, lat = Latitude, lon = Longitude, city = City, state = Region), by = "SiteID"]

traits <- merge(traits, sites, by = "ExpID")

## Variables
variables <- data.table(read.csv("all.variables.csv"))
if(sum(!unique(traits$variables.name) %in% variables$VariableName)>0){
  stop(paste("missing", unique(traits$variables.name)[which(!unique(traits$variables.name) %in% variables$VariableName)]))
  
}

variables <- variables[, list(variables.name = VariableName, 
                              variables.description = VariableDescription,
                              units = Units)]
traits <- merge(traits, variables, by = 'variables.name')


traits[units == "g/m2"]$mean <- traits[units == "g/m2", ud.convert(mean, "g/m2", "Mg/ha")]
traits[units == "g/m2"]$units <- "Mg/ha"

setnames(traits, c("Plot", "Date", "Cultivar", "SiteName", "City", "Region", "Latitude", "Longitude", "Elevation"), c("entity_id", "date", "cultivars.name", "sites.sitename", "sites.city", "sites.state", "lat", "lon", "masl"))

### Yields: total aboveground dry weight

yields <- traits[variables.name == "DWTOTA",]
hist(traits[variables.name == "DWTOTA", mean])


experiment.design <- data.table(melt(Experiment.Design, id.var = c('ExpID','Treatment','Rep', 'Plot'), variable.name = "managements.type", value.var = "managements.level"), na.rm = TRUE)

## assign '1' to missing values of Replication  
experiment.design[is.na(Rep)]$Rep <- 1

traits <- merge(traits, experiment.design, by = c('ExpID','Plot'))


yields <- traits[variables.name == "TDWT",]


Experiment.Design <- Experiment.Design[,-which(colnames(Experiment.Design) %in% c("X"))]

cultivars <- Experiment.Design2[, c("ExpID", "Treatment", "Rep", "Plot", "Cultivar")]
treatments <- cbind(Experiment.Design2[,1:4], 
                    name = do.call(paste0, Experiment.Design2[,c(5:8,10:23)]))

## managements
Irrigation <- read.csv("Irrigation.csv")
Planting <-  read.csv("Planting.csv")
Tillage <- read.csv("Tillage.csv")
Fertilization <- read.csv("Fertilization.csv")[, c("ExpID", "Treatment", "Date", "Fertilizer", "Amount")]
Fx.Fertilizer <- transform(Fx.Fertilizer, percentN = N./100)
n.conversions <- Fx.Fertilizer[Fx.Fertilizer$Fertilizer %in% unique(Fertilization$Fertilizer),
                               c("Fertilizer", "percentN")]

Fertilization <- merge(Fertilization, n.conversions, by = "Fertilizer")
fertilization <- with(Fertilization[Fertilization$percentN > 0,],
                      data.frame(ExpID, Treatment, Date, fertilizerN = Amount * percentN))
fertilization.all <- merge(treatments[,c("ExpID", "Treatment")], 
                           fertilization[fertilization$Treatment == "ALL", -2],
                           by = c("ExpID"))
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

experiment.design <- Experiment.Design2
experiment.design <- as.numeric(levels(experiment.design)[experiment.design])
experiment.design <- data.table(as.numeric(levels(experiment.design)[experiment.design]))

for ( i in 1: length(Nrate))
  {
    expID <- ABGDB[i,]$ExpID
    pplot <- ABGDB[i,]$Plot
    ABGDB[i,]$Nrate <- experiment.design[((ExpID==expID)&&(experiment.design$Plot==pplot)),]$NRate
  }
