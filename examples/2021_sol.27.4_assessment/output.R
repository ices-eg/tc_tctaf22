# output.R - Write tables and WGMIXFISH FLStock
# 2020_sol.27.4_assessment/output.R

# Copyright Iago MOSQUEIRA (WMR), 2022
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


taf.library(icesTAF)
taf.library(FLa4a)
taf.library(flextable)

source("utilities.R")

mkdir("output")

# INPUT

load("data/catch.Rdata")
load("data/data.Rdata")
load("model/model.Rdata")

# --- TABLES

tables <- qtables <- list()

# - Time-series landings at age (in thousands) of sole in Subarea 27.4.
qtables$landings.n <- landings.n(stock)
  
# - Time-series discards at age (in thousands) of sole in Subarea 27.4.
qtables$discards.n <- discards.n(stock)[, ac(2002:2019)]

# - Time-series of the mean weights-at-age in the landings of sole in Subarea 27.4.
qtables$landings.wt <- landings.wt(stock)

# - Time-series of the mean weights-at-age in the discards of sole in Subarea 27.4.
qtables$discards.wt <- discards.wt(stock)

# - Time-series of mean stock weights at age of sole in Subarea 27.4.
qtables$stock.wt <- stock.wt(stock)

# - Survey indices used in the assessment of sole in Subarea 27.4.
qtables$bts <- index(indices[["BTS"]])
qtables$sns <- index(indices[["SNS"]])

# - North Sea sole: Numbers-at-age
qtables$stock.n <- stock.n(run)

# - North Sea sole: Fishing mortality-at-age
qtables$harvest <- harvest(run)

# ftables, in flextable format
ftables <- lapply(qtables, as_flextable)

# - SSB and F w/error

tssb <-   as.data.frame(FLQuantPoint(ssb(runmc)),
    drop=TRUE)[, c("year", "mean", "lowq", "uppq")]
colnames(tssb) <- c("Year", "SSB", "SSB lower", "SSB upper")

tfbar <- as.data.frame(FLQuantPoint(fbar(runmc)),
  drop=TRUE)[, c("mean", "lowq", "uppq")]
colnames(tfbar) <- c("F", "F lower", "F upper")

tables$ssbf <- cbind(tssb, tfbar)
ftables$ssbf <- flextable(tables$ssbf)

# - Time-series of the official landings by country
setnames(stats, c("year", "other", "official", "bms", "ices", "tac"),
  c("Year", "Other", "Official", "BMS", "ICES", "TAC"))

tables$catches <- stats
ftables$catches <- flextable(stats)

# MAT & M

matm <- data.table(model.frame(FLQuants(Maturity=mat(stock)[,'2019'],
  M=m(stock)[,'2019']), drop=TRUE))
setnames(matm, "age", "Age")

tables$matm <- matm
ftables$matm <- autofit(flextable(matm))

# SAVE tables
save(tables, ftables, mrho, file="output/tables.Rdata", compress="xz")


# --- FLStock for WGMIXFISH

# UPDATE with model estimates

landings(run) <- computeLandings(run)
discards(run) <- computeDiscards(run)
catch(run) <- computeCatch(run)

save(run, file="output/sol.27.4_FLStock.Rdata", compress="xz")

# COPY

cp("data/data.Rdata", "output/")
cp("model/model.Rdata", "output/")
