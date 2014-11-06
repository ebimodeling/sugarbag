#setwd("C:\\Users\\ruizver1\\Documents\\myprojectEBI\\sugarbag")
library(sugarbag)
setwd("./")
# Step 1:- Get all the experiment IDs  for whic Harvest, Experiment Design and Planting information is available
expID <-GetExpID_for_N_Combined()

# Step 2 :- Define variable name that we are interested in
varname <- c("DWDLF","DWGLF","DWMST","DWSTA","DWTOTA","DWTOTB", "DWTOTT",  
             "LAI",  "NWDLF",	"NWGLF",	"NWMST",	"NWSTA",	"NWTOTA", "SWMST","SWPMST","SWTOTA", "Latitude.x", "Longitude.x")


# Creating initial dataframe that will be used for RBind
id <- expID[1]
Output <- Update_expID(id, varname)
N = length(expID)

# Get N versus Yield data from all the experiments andRBIND them to Output
for (i in 2:N){
  id <- expID[i]
  tmp_output <- Update_expID(id, varname)
  Output <- rbind(Output,tmp_output)
}

#save data in csv format
#setwd("C:\\Users\\ruizver1\\Desktop\\New folder")
#write.csv(Output, file="out.csv", row.names = FALSE)
#output <- read.csv("out.csv")

#how to calculate the plot means and then the maximum values of the variables
OUT <- data.table(Output)
OUT2 <- OUT[,list(DWDLF = mean(DWDLF, na.rm = TRUE), DWGLF = mean(DWGLF, na.rm = TRUE), DWMST=mean(DWMST, na.rm = TRUE),DWSTA=mean(DWSTA, na.rm = TRUE),
                  DWTOTA=mean(DWTOTA, na.rm = TRUE),LAI=mean(LAI, na.rm = TRUE), NWDLF=mean(NWDLF, na.rm = TRUE),NWGLF=mean(NWGLF, na.rm = TRUE), 
                  NWMST=mean(NWMST, na.rm = TRUE),NWSTA=mean(NWSTA, na.rm = TRUE), NWTOTA=mean(NWTOTA, na.rm = TRUE),SWMST=mean(SWMST, na.rm = TRUE),
                  SWPMST=mean(SWPMST, na.rm = TRUE),SWTOTA=mean(SWTOTA, na.rm = TRUE)),
            by = c('ExpID', 'Treatment','Date','Ncombined','Cultivar','Irrigation')]

ndata <- unique(OUT2[,list(DWDLF = max(DWDLF, na.rm = TRUE), DWGLF = max(DWGLF, na.rm = TRUE), DWMST=max(DWMST, na.rm = TRUE),DWSTA=max(DWSTA, na.rm = TRUE),
                           DWTOTA=max(DWTOTA, na.rm = TRUE),LAI=max(LAI, na.rm = TRUE), NWDLF=max(NWDLF, na.rm = TRUE),NWGLF=max(NWGLF, na.rm = TRUE), 
                           NWMST=max(NWMST, na.rm = TRUE),NWSTA=max(NWSTA, na.rm = TRUE), NWTOTA=max(NWTOTA, na.rm = TRUE),SWMST=max(SWMST, na.rm = TRUE),
                           SWPMST=max(SWPMST, na.rm = TRUE),SWTOTA=max(SWTOTA, na.rm = TRUE)),
                     by = c('ExpID', 'Treatment','Ncombined','Cultivar','Irrigation')])

NEWOUT2 <- data.frame(ndata)


#Meta-analysis of N effects on yield, Sugar, and LAI

#plots by David
library(data.table)
library(ggplot2)
NEWOUT2 <- data.table(NEWOUT2)
ggplot(data = NEWOUT2[DWTOTA>0]) + geom_point(aes(Ncombined, DWTOTA, color = as.logical(Irrigation))) + 
  facet_wrap(~Cultivar+Irrigation) + ylim(range(0, max(pretty(ndata$DWTOTA))))
ggplot(data = NEWOUT2[DWTOTA>0]) + geom_point(aes(Ncombined, DWTOTA, color = as.logical(Irrigation))) + 
  facet_wrap(~Cultivar+ExpID) + ylim(range(0, max(pretty(ndata$DWTOTA))))

data(variables)
variables[variables$VariableName %in% colnames(ndata),]

# done by Ursula
d <- NEWOUT2[!is.na(DWTOTA), list(ExpID, Treatment, Ncombined, Cultivar, Irrigation, DWTOTA, SWTOTA, NWTOTA, DWMST, SWMST)]
library(dplyr)
##this is to do the analysis with the max values of the variables
d3 <- d[!is.na(Ncombined) & is.finite(DWTOTA)]
ggplot(data = d3, aes(Ncombined, DWTOTA)) + geom_point(aes(Ncombined, DWTOTA, color = Cultivar), alpha = 0.4) + facet_wrap(~Irrigation) + ylim(0,10000) + stat_smooth(method=lm, level=0.9) + xlab("amount of N (Kg/ha)") + ylab("Dry Weight of Above-ground Biomass (g/m2)") 
ggplot(data = d3[SWTOTA>0], aes(Ncombined, SWTOTA)) + geom_point(aes(Ncombined, SWTOTA, color = Cultivar), alpha = 0.4) + facet_wrap(~Irrigation)+ ylim(0,4000)+ stat_smooth(method=lm, level=0.9)+ xlab("amount of N (Kg/ha)") + ylab("Sucrose in Above-ground Biomass (g/m2)")
ggplot(data = d3[NWTOTA>0], aes(Ncombined, NWTOTA)) + geom_point(aes(Ncombined, NWTOTA, color = Cultivar), alpha = 0.4) + facet_wrap(~Irrigation)+ ylim(0,45)+ stat_smooth(method=lm, level=0.9) + xlab("amount of N (Kg/ha)") + ylab("Nitrogen in Above-ground Biomass (g/m2)")
ggplot(data = d3[SWTOTA/DWTOTA>0], aes(Ncombined, SWTOTA/DWTOTA)) + geom_point(aes(Ncombined, SWTOTA/DWTOTA, color = Cultivar), alpha = 0.4) + facet_wrap(~Irrigation) + ylim(0,0.5) + stat_smooth(method=lm, level=0.9) + xlab("amount of N (Kg/ha)") + ylab("Sucrose/Dry Weight, of the Above-ground Biomass")
ggplot(data = d3[NWTOTA/DWTOTA>0], aes(Ncombined, NWTOTA/DWTOTA)) + geom_point(aes(Ncombined, NWTOTA/DWTOTA, color = Cultivar), alpha = 0.4) + facet_wrap(~Irrigation) + ylim(0,0.007) + stat_smooth(method=lm, level=0.9) + xlab("amount of N (Kg/ha)") + ylab("Nitrogen/Dry Weight, of the Above-ground Biomass")
ggplot(data = d3[SWMST/DWMST>0.01], aes(Ncombined, SWMST/DWMST)) + geom_point(aes(Ncombined, SWMST/DWMST, color = Cultivar), alpha = 0.4) + facet_wrap(~Irrigation) + ylim(0,0.6) + stat_smooth(method=lm, level=0.9) + xlab("amount of N (Kg/ha)") + ylab("Sucrose/Dry Weight, of the Cane (millable stem)")
####

a <- (lm(DWTOTA ~ Ncombined * as.factor(Irrigation), data = d3))
plot(a)
a <- (lm(log10(DWTOTA) ~ Ncombined * as.factor(Irrigation), data = d3))
plot(a)


## Total Aboveground Biomass
summary(nlme::lme(fixed = log(DWTOTA) ~ Ncombined * as.factor(Irrigation), random = ~1|ExpID, data = d3))
## Total Sugar Content
summary(nlme::lme(fixed = SWTOTA/DWTOTA ~ Ncombined * as.factor(Irrigation), random = ~1|ExpID, data = d4, subset = is.finite(SWTOTA)))
## 
summary(nlme::lme(fixed = NWTOTA/DWTOTA ~ Ncombined * as.factor(Irrigation), random = ~1|ExpID, data = d3, subset = is.finite(NWTOTA)))
##
summary(nlme::lme(fixed = SWMST/DWMST ~ Ncombined * as.factor(Irrigation), random = ~1|ExpID, data = d3, subset = is.finite(SWMST/DWMST)))


