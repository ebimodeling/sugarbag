#setwd("C:\\Users\\ruizver1\\Documents\\myprojectEBI\\sugarbag")
library(sugarbag)
setwd("./")
# Step 1:- Get all the experiment IDs  for whic Harvest, Experiment Design and Planting information is available
expID <-GetExpID_for_N_Combined()

# Step 2 :- Define variable name that we are interested in
varname <- c("DWDLF","DWGLF","DWMST","DWSTA","DWTOTA","DWTOTB", "DWTOTT",  
             "LAI",	"NWDLF",	"NWGLF",	"NWMST",	"NWSTA",	"NWTOTA", "SWMST","SWPMST","SWTOTA")


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

#how to choose the maximum value of a variable
OUT <- data.table(output)
ndata <- unique(OUT[,list(Ncombined, Irrigation, Cultivar,      
              
                    DWDLF = max(DWDLF, na.rm = TRUE), DWGLF = max(DWGLF, na.rm = TRUE), DWMST=max(DWMST, na.rm = TRUE),DWSTA=max(DWSTA, na.rm = TRUE),
                    DWTOTA=max(DWTOTA, na.rm = TRUE),LAI=max(LAI, na.rm = TRUE),NWDLF=max(NWDLF, na.rm = TRUE),NWGLF=max(NWGLF, na.rm = TRUE),
                    NWMST=max(NWMST, na.rm = TRUE),NWSTA=max(NWSTA, na.rm = TRUE),NWTOTA=max(NWTOTA, na.rm = TRUE),SWMST=max(SWMST, na.rm = TRUE),
                    SWPMST=max(SWPMST, na.rm = TRUE),SWTOTA=max(SWTOTA, na.rm = TRUE)),
    by = c('ExpID', 'Plot')])


NEWOUT2 <- data.frame(ndata)

#this is the wat to graph many columns and try to save the graph
# vs Nitrogen content
library(lattice)
p <- par(mfrow=c(2,2))
for (i in 6:19){
  png(file = sprintf("filename_%s.png",i))
  w <- xyplot(NEWOUT2[,i]~Ncombined,NEWOUT2,ylab=names(NEWOUT2[i]))
  print(w)
  dev.off()
}
par(p)

#with cultivar
p <- par(mfrow=c(2,2))
for(i in 6:19){
  png(file = sprintf("cultivar_%s.png",i))
  w <- xyplot(NEWOUT2[,i]~Ncombined | Cultivar,NEWOUT2,ylab=names(NEWOUT2[i]))
  print(w)
      dev.off()
}
par(p)

#with Irrigation
f <- factor(NEWOUT2$Irrigation)
p <- par(mfrow=c(2,2))
for(i in 6:19){
  #png(file = sprintf("Irrigation_%s.png",i))
  w <- xyplot(NEWOUT2[,i]~Ncombined | f,NEWOUT2,ylab=names(NEWOUT2[i]), main=f)
  print(w)
  #    dev.off()
  }
par(p)

#per ExpID
p <- par(mfrow=c(2,2))
for (i in 6:19){
  png(file = sprintf("ExpID_%s.png",i))
  w <- xyplot(NEWOUT2[,i]~Ncombined |ExpID,NEWOUT2,ylab=names(NEWOUT2[i]))
  print(w)
  dev.off()
}
par(p)



# Plots by Deepak
#library(lattice)
#xyplot(colum~ Ncombined | Cultivar, data=Output)
#xyplot(colum~ Ncombined | Irrigation, data=Output)
#Density Plot of DWMST
#plot(density(Output$DWMST, na.rm=TRUE))
#Density Plot of TotalN
#plot(density(Output$TotalN, na.rm=TRUE))

'
Meta-analysis of N effects on yield, Sugar, and LAI
'


#plots by David
library(ggplot2)
ggplot(data = NEWOUT[DWTOTA>0]) + geom_point(aes(Ncombined, DWTOTA, color = as.logical(Irrigation))) + 
  facet_wrap(~Cultivar+Irrigation) #+ ylim(range(0, max(pretty(ndata$DWTOTA))))
ggplot(data = NEWOUT) + geom_point(aes(Ncombined, DWTOTA, color = as.logical(Irrigation))) + 
  facet_wrap(~Cultivar+ExpID) + ylim(c(0, 1300))
ggplot(data = NEWOUT)
OUT[,list(Date[which.max(DWDLF)])]

data(variables)
variables[variables$VariableName %in% colnames(ndata),]



d <- OUT[!is.na(DWTOTA), list(Plot, ExpID, Date, Treatment, Ncombined, Cultivar, Irrigation, DWTOTA, SWTOTA, NWTOTA)]

library(dplyr)
## Find dates of Harvest (where next measurement is much less that current measurement) 

d2 <- d[,`:=` (harvest = as.logical(Date == max(Date))), by = 'ExpID,Ncombined,Treatment']
ggplot() + geom_line(data = d2, aes(mdy(Date), DWTOTA, color = Treatment)) + facet_wrap(~ExpID+Ncombined)
d3 <- subset(d2, as.logical(harvest))
d3 <- d3[!is.na(Ncombined)]
#d3$Ncombined[is.na(d3$Ncombined)] <- 0 ## is this appropriate??? not sure why NA's ended up here ...
ggplot() + geom_point(data = d3, aes(Ncombined, DWTOTA), alpha = 0.4) + facet_wrap(~ExpID)
ggplot() + geom_point(data = d3, aes(Ncombined, SWTOTA), alpha = 0.4) + facet_wrap(~ExpID)
ggplot() + geom_point(data = d3, aes(Ncombined, NWTOTA), alpha = 0.4) + facet_wrap(~ExpID)
##
a <- (lm(DWTOTA ~ Ncombined * as.factor(Irrigation), data = d3))
plot(a)
a <- (lm(log10(DWTOTA) ~ Ncombined * as.factor(Irrigation), data = d3))
plot(a)

## using ExpID as random effect
summary(lme4::lmer(log10(DWTOTA) ~ Ncombined  * as.factor(Irrigation) + (1|ExpID), data = d3))

## Total Aboveground Biomass
summary(nlme::lme(fixed = log10(DWTOTA) ~ Ncombined * as.factor(Irrigation), random = ~1|ExpID, data = d3))
## Total Sugar Content
summary(nlme::lme(fixed = SWTOTA/DWTOTA ~ Ncombined * as.factor(Irrigation), random = ~1|ExpID, data = d3, subset = !is.na(SWTOTA)))
## 
summary(nlme::lme(fixed = NWTOTA/DWTOTA ~ Ncombined * as.factor(Irrigation), random = ~1|ExpID, data = d3, subset = !is.na(NWTOTA)))

ggplot(d3) + geom_point(aes(Ncombined, DWTOTA, color = as.logical(Irrigation)))
ggplot(d3) + geom_point(aes(Ncombined, SWTOTA/DWTOTA, color = as.logical(Irrigation)))
ggplot(d3) + geom_point(aes(Ncombined, NWTOTA/DWTOTA, color = as.logical(Irrigation)))
