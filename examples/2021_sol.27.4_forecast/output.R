# output.R - DESC
# /output.R

# Copyright Iago MOSQUEIRA (WMR), 2020
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(icesTAF)
library(icesAdvice)

library(AAP)

library(flextable)
library(data.table)

mkdir("output")

# LOAD assessment and forecast results

load("data/aap.RData")
load("model/runs.RData")
load("model/runsmc.RData")

# MODEL, ADVICE and FORECAST year

dy <- dims(run)$maxyear
ay <- dy + 1
fy <- ay + 1


# --- Advice sheet

# - SAG graphs

source("output_sag.R")

#  - TABLE - Intermediate year assumptions

tab1 <- interimTable(runs$Fmsy)

writexl::write_xlsx(tab1, path="output/intermediate_assumptions.xlsx")

# - TABLE - Annual catch scenarios

tab2 <- catchOptionsTable(runs, advice=advice, tac=tac,
  ages=c(3,6), discards.ages=c(1,3))

writexl::write_xlsx(tab2, path="output/catch_options.xlsx")

# - TABLE - Summary of the assessment

dat <- data.table(fishdata[, c("Year", "Recruitment", "High_Recruitment",
  "Low_Recruitment", "StockSize", "High_StockSize", "Low_StockSize",
  "Landings", "Discards", "Catches", "FishingPressure",
  "High_FishingPressure", "Low_FishingPressure")])

cols <- colnames(dat)[12:14]
dat[ , (cols) := lapply(.SD, icesRound), .SDcols = cols]

cols <- colnames(dat)[-c(1, 12:14)]
dat[ , (cols) := lapply(.SD, round), .SDcols = cols]

writexl::write_xlsx(dat, path="output/assessment_summary.xlsx")

# --- REPORT
















# --- FRUNS

tabfruns <- lapply(f_runs, function(x) metrics(window(x, start=2020, end=2022),
  list(Fbar=fbar, Landings=landings, Discards=discards, Catch=catch, SSB=ssb)))

names(tabfruns) <- paste0("Fmult(2020)=", names(tabfruns))

tabfruns <- lapply(tabfruns, as.data.frame, drop=TRUE)

tab <- rbindlist(tabfruns, idcol="Rationale")
tab <- dcast(tab, Rationale ~ qname + year, value.var = "data")

tab[ ,`:=`(Fbar_2022 = NULL, Landings_2022 = NULL, Discards_2022 = NULL, Catch_2022 = NULL)]

setcolorder(tab, c(1,2,4,6,8,10,3,5,7,9,11,12))

tab[, SSBchange_2022:= (SSB_2022 - SSB_2021) / SSB_2021 * 100]

fwrite(tab, file="output/mutliF_options_sol.27.4_2020.csv")


# SAVE for next year

save(run, runs, fit, refpts, file="output/aap.RData")
