setwd(system.file("extdata", package = "sugarbag"))

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


Experiment.Summary <- read.csv("Experiment.Summary.csv")

## traits and yields
Harvest.Data <- read.csv("Harvest.Data.csv")
yields <- with(Harvest.Data,
               data.frame(ExpID,
                          Plot,
                          Date = dmy(Date),
                          mean = TDWT))
yields <- yields[!is.na(yields$mean),]
ggplot(yields, aes(Date, mean, group = ExpID, color = Plot)) + geom_point()

traits <- Harvest.Data[,-which(colnames(Harvest.Data) %in% c("X", "TDWT"))]
traits$Date <- dmy(traits$Date)
traits <- melt(traits, id.vars = 1:4, na.rm = TRUE)

List.Of.Experiment <- read.csv("List.Of.Experiments.csv")
Notes <- read.csv("Notes.csv")

ResearcherPerExperiment <- read.csv("ResearchersPerExperiment.csv")
Weather.Data <- read.csv("Weather.Data.csv")


## treatments
Experiment.Design <- read.csv("Experiment.Design.csv")
Experiment.Design2 <- Experiment.Design[,-which(colnames(Experiment.Design) %in% c("X"))]

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


Y <- merge(yields, cultivars, by = c("ExpID", "Plot"))
Y2 <- merge(Y, treatments, by = c("ExpID", "Plot", "Treatment", "Rep"))
Y3 <- merge(Y2, fertilizerN.total, by = c("ExpID", "Treatment"))
ggplot(data = Y3, aes(fertilizerN, mean)) + geom_point()



## transform Harvest Data from wide to long

## transform soil layer data from wide to long

## combine soil data and harvest data into traits table (yields in yields table)

## Reading Data Table for above ground biomass
ABGDB <- Harvest.Data[!(is.na(Harvest.Data$DWTOTA)),c(1,3,4,5,35)]
Nrate <- numeric(dim(ABGDB)[1])
Nrate <- NA
ABGDB <- cbind(ABGDB,Nrate)
experiment.design <- as.numeric(levels(experiment.design)[experiment.design])
experiment.design <- as.numeric(levels(experiment.design)[experiment.design])

for ( i in 1: length(Nrate))
  {
    expID <- ABGDB[i,]$ExpID
    pplot <- ABGDB[i,]$Plot
    ABGDB[i,]$Nrate <- experiment.design[((experiment.design$ExpID==expID)&&(experiment.design$Plot==pplot)),]$NRate
  }
# Table citations

id <- 99999
author <- "Prestwidge and Laredo"
year <- 2003
title <- "SuGARBAG: A Database System for Sugarcane Crop Growth , Climate, Soils and Management Data"
journal <- "CRC Sugar Occasional Publication Brisbane"
vol="NA"
pg="NA"
url="NA"
pdf="NA"
created_at <- 8888
updated_at <- 8888
doi="NA"
citations <- data.frame(id=id,author=author,year=year,title=title,journal=journal,vol=vol,pg=pg,url=url,pdf=pdf,created_at=created_at,updated_at=updated_at,doi=doi)


## Table for citations_sites
sites_id  <- Fx.Experiment.Site$Site.ID
citation_id <- rep(id,length(sites_id))
citations_sites <- data.frame(citation_id=citation_id,sites_id=sites_id,created_at=created_at,updated_at=updated_at)

#Table for citation_treatments
RNCEP_extraction <- data.frame(year=numeric(0),month=numeric(0), date=numeric(0), hr=numeric(0), Temp=numeric(0))
folla <- rep(0,25)
for (mm in 1:12)
{
for (dd in 1:30){
  folla <- NCEP.interp(variable='air',level=850,lat=45,lon=100,dt=paste("2006-",mm,"-",dd," 00:00:00",sep=""))
  write.table(folla, file="/home/djaiswal/rncep.trial.txt", append=TRUE)
   folla <- NCEP.interp(variable='air',level=850,lat=45,lon=100,dt=paste("2006-",mm,"-",dd," 06:00:00",sep=""))
   write.table(folla, file="/home/djaiswal/rncep.trial.txt", append=TRUE)
   folla <- NCEP.interp(variable='air',level=850,lat=45,lon=100,dt=paste("2006-",mm,"-",dd," 12:00:00",sep=""))
   write.table(folla, file="/home/djaiswal/rncep.trial.txt", append=TRUE)
   folla <- NCEP.interp(variable='air',level=850,lat=45,lon=100,dt=paste("2006-",mm,"-",dd,"18:00:00",sep=""))
   write.table(folla, file="/home/djaiswal/rncep.trial.txt", append=TRUE)
 }
}

  
