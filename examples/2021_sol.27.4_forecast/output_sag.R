# output_sag.R - DESC
# /output_sag.R

# Copyright Iago MOSQUEIRA (WMR), 2021
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(icesSAG)

# https://standardgraphs.ices.dk/manage/ViewGraphsAndTables.aspx?key=14120

# --- SAG

options(icesSAG.use_token = TRUE)

# INFO
info <- stockInfo(StockCode="sol.27.4", AssessmentYear=ay,
  Purpose = "Advice", StockCategory=1, ContactPerson="iago.mosqueira@wur.nl",
  
  # A: Age based (like VPA, SCA, SAM) 
  ModelType="A", ModelName="AartsPoos",
  
  # rec
  RecruitmentDescription="Recruitment", RecruitmentAge=1,
  # NE3: Number of individuals in thousands (x1000) (fisheries) 
  RecruitmentUnits="NE3",
  
  # ssb
  StockSizeDescription="Spawning Stock Biomass", StockSizeUnits="t",
  
  # catch
  CatchesLandingsUnits="t",
  # F
  FishingPressureDescription="F", FishingPressureUnits="y",
  # CIs
  ConfidenceIntervalDefinition="2*sd",

  # REFPTS

  FMSY=c(refpts$Fmsy),
  MSYBtrigger=c(refpts$Btrigger),
  
  Blim=c(refpts$Blim),
  Flim=c(refpts$Flim),
  
  Bpa=c(refpts$Bpa),
  Fpa=c(refpts$Fpa),
  
  # MAP
  FMGT=c(refpts$Fmsy),
  FMGT_lower=c(refpts$lFmsy),
  FMGT_upper=c(refpts$uFmsy),
  BMGT=c(refpts$Btrigger)
)

# DEBUG
info$StockCategory <- 1

# DATA
fishdata <- stockFishdata(seq(1957, ay))

# LAST year
n <- length(fishdata$Year)
# YEARS 1:n
i <- seq(n - 1)

# Recruitment
fishdata$Recruitment[i] <- c(mean(rec(run)))
fishdata$Recruitment[n] <- c(rec(runs$Blim)[,'2021'])
fishdata$Low_Recruitment[i] <- c(quantile(rec(runmc), 0.05))
fishdata$High_Recruitment[i] <- c(quantile(rec(runmc), 0.95))

# TBiomass
fishdata$TBiomass[i] <- c(stock(run))

# StockSize: ssb(fit)
fishdata$StockSize[i] <- c(ssb(run))
fishdata$StockSize[n] <- c(ssb(runs$Blim)[,'2021'])
fishdata$Low_StockSize[i] <- c(quantile(ssb(runmc), 0.05))
fishdata$High_StockSize[i] <- c(quantile(ssb(runmc), 0.95))

# Landings
fishdata$Landings[i] <- c(landings(run))
fishdata$Discards[seq(1, 45)] <- 0

# Discards
fishdata$Discards[i] <- c(discards(run))

# Catches
fishdata$Catches[i] <- c(catch(run))

# FishingPressure
fishdata$FishingPressure[i] <- c(mean(fbar(run)))
fishdata$Low_FishingPressure[i] <- c(quantile(fbar(runmc), 0.05))
fishdata$High_FishingPressure[i] <- c(quantile(fbar(runmc), 0.95))
fishdata$FishingPressure_Landings[i] <- c(Fwanted(run))
fishdata$FishingPressure_Discards[i] <- c(Funwanted(run))

# XML: 
xmlfile <- createSAGxml(info, fishdata)

capture.output(print(xmlfile, quote=FALSE), file="output/sol_27_4.xml")

# UPLOAD 
# key <- icesSAG::uploadStock(info, fishdata)

# CHECK

key <- findAssessmentKey('sol.27.4', 2021, full = FALSE)

sumtab <- data.table(icesSAG::getSummaryTable(key)[[1]])

