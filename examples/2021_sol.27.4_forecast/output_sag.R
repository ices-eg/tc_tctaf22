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
fishdata$Recruitment[i] <- c(mean(rec(fit)))
fishdata$Recruitment[n] <- c(rec(runs$Blim)[,'2021'])
fishdata$Low_Recruitment[i] <- c(lowq(rec(fit)))
fishdata$High_Recruitment[i] <- c(uppq(rec(fit)))

# TBiomass
fishdata$TBiomass[i] <- c(stock(run))

# StockSize: ssb(fit)
fishdata$StockSize[i] <- c(mean(ssb(fit)))
fishdata$StockSize[n] <- c(ssb(runs$Fmsy)[,'2021'])
fishdata$Low_StockSize[i] <- c(lowq(ssb(fit)))
fishdata$High_StockSize[i] <- c(uppq(ssb(fit)))

# Landings
fishdata$Landings[i] <- c(landings(run))

# Discards
fishdata$Discards[i] <- c(discards(run))
fishdata$Discards[seq(1, 45)] <- c(discards(fit)[, seq(1, 45)])

# Catches
fishdata$Catches[i] <- c(catch(run))

# FishingPressure
fishdata$FishingPressure[i] <- c(mean(fbar(fit)))
fishdata$Low_FishingPressure[i] <- c(lowq(fbar(fit)))
fishdata$High_FishingPressure[i] <- c(uppq(fbar(fit)))
fishdata$FishingPressure_Landings[i] <- c(Fwanted(fit))
fishdata$FishingPressure_Discards[i] <- c(Funwanted(fit))

# XML: 
xmlfile <- createSAGxml(info, fishdata)

capture.output(print(xmlfile, quote=FALSE), file="output/sol_27_4.xml")

# UPLOAD 
# key <- icesSAG::uploadStock(info, fishdata)

# CHECK

key <- findAssessmentKey('sol.27.4', 2021, full = FALSE)

sumtab <- data.table(icesSAG::getSummaryTable(key)[[1]])

