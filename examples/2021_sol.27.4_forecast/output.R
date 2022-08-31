# output.R - DESC
# /output.R

# Copyright Iago MOSQUEIRA (WMR), 2020
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(icesTAF)
library(icesAdvice)

library(FLa4a)

library(officer)
library(flextable)
library(data.table)

mkdir("output")

# LOAD assessment and forecast results

load("data/model.Rdata")
load("model/runs.Rdata")
load("model/runsmc.Rdata")

# MODEL, ADVICE and FORECAST year

dy <- dims(run)$maxyear
ay <- dy + 1
fy <- ay + 1


# --- Advice sheet

# - SAG graphs

source("output_sag.R")

#  - TABLE - Intermediate year assumptions

tab1 <- interimTable(runs$Fmsy)

save_as_docx(flextable(tab1), path = "output/intermediate_assumptions.docx")

# - TABLE - Annual catch scenarios

tab2 <- catchOptionsTable(runs, advice=advice, tac=tac,
  ages=c(3,6), discards.ages=c(1,3))

save_as_docx(flextable(tab2), path = "output/catch_options.docx")

# - TABLE - Summary of the assessment

tab3 <- data.table(fishdata[, c("Year", "Recruitment", "High_Recruitment",
  "Low_Recruitment", "StockSize", "High_StockSize", "Low_StockSize",
  "Landings", "Discards", "Catches", "FishingPressure",
  "High_FishingPressure", "Low_FishingPressure")])

cols <- colnames(tab3)[11:13]
tab3[ , (cols) := lapply(.SD, icesRound), .SDcols = cols]

cols <- colnames(tab3)[-c(1, 11:13)]
tab3[ , (cols) := lapply(.SD, round), .SDcols = cols]

ftab3 <- flextable(tab3)
ftab3 <- set_table_properties(ftab3, width = .5, layout = "autofit")

save_as_docx(fit_to_width(autofit(ftab3), 10), path = "output/assessment_summary.docx")


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


# --- SAVE for next year

save(run, runs, fit, refpts, file="output/model.Rdata")
