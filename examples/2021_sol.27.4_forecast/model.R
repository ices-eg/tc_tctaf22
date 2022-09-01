# model.R - Run forecast
# 2020_sol.27.4_forecast/model.R

# Copyright Iago MOSQUEIRA (WMR), 2020
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(icesTAF)
library(FLasher)

mkdir("model")

load('data/data.Rdata')
load('data/model.Rdata')

# --- SETUP

# refpts: Bpa, Fpa, Blim, Flim, BmsyTrig, Fmsy, FmsyLow, FmsyUpp

# TAC & advice current year

advice <- FLQuant(21361, dimnames=list(age='all', year=2021), units="tonnes")
tac <- advice

# MODEL, ADVICE and FORECAST year

dy <- dims(run)$maxyear
ay <- dy + 1
fy <- ay + 1

# GEOMEAN but last year
rec1gm <- exp(mean(log(window(stock.n(run)["1",], end=-1))))


# --- SETUP future

# 3 years, 5 years wts/selex, 3 years discards
fut <- stf(run, nyears=3, wts.nyears = 5, fbar.nyears=5, disc.nyears=3)

# GET F status quo (Fsq)
# Fsq <- expand(yearMeans(fbar(fut)[, ac(seq(dy - 2, dy))]), year=2020)
Fsq <- expand(fbar(fut)[, ac(dy)], year=ay)

# SET geomean SRR
gmsrr <- predictModel(model=rec~a, params=FLPar(c(rec1gm), units="thousands",
  dimnames=list(params="a", year=seq(ay, length=3), iter=1)))

# GENERATE targets from refpts
targets <- expand(as(refpts, 'FLQuant'), year=fy)


# --- PROJECT catch options

# Targets 2021
Fiy <- FLQuants(fbar=Fsq)
Ciy <- FLQuants(catch=tac)

# RUN for Fsq
Fsqrun <- fwd(fut, sr=gmsrr, control=as(Fiy, "fwdControl"))

# TEST if Cay < TACay
if(catch(Fsqrun)[, ac(ay)] <= tac) {
  itarget <- Fiy
} else {
  itarget <- Ciy
  Fsqrun <- fwd(fut, sr=gmsrr, control=as(Ciy, "fwdControl"))
}

# DEFINE catch options
catch_options <- list(

  # FMSY
  Fmsy=FLQuants(fbar=targets["Fmsy",]),

  # lowFMSY
  lFmsy=FLQuants(fbar=targets["lFmsy",]),

  # uppFMSY
  uFmsy=FLQuants(fbar=targets["uFmsy",]),

  # F0
  F0=FLQuants(fbar=FLQuant(1e-8, dimnames=list(age='all', year=fy))),

  # Fpa
  Fpa=FLQuants(fbar=targets["Fpa",]),

  # F05noAR
  F05noAR=FLQuants(fbar=targets["F05noAR",]),

  # Flim
  Flim=FLQuants(fbar=targets["Flim",]),

  # Bpa
  Bpa=FLQuants(ssb_flash=targets["Bpa",]),

  # Blim
  Blim=FLQuants(ssb_flash=targets["Blim",]),

  # MSYBtrigger
  MSYBtrigger=FLQuants(ssb_flash=targets["Btrigger",]),

  # F 2021
  F2021=FLQuants(fbar=expand(fbar(Fsqrun)[, ac(ay)], year=fy)),
                 
  # Fmp 0.20
  Fmp=FLQuants(fbar=FLQuant(0.20, dimnames=list(age='all', year=fy))),

  # TAC 2021
  rotac=FLQuants(catch=expand(tac, year=fy))
)

# F0, 2023
F0 <- FLQuants(fbar=FLQuant(0, dimnames=list(age='all', year=fy + 1)))

# CONVERT to fwdControl

fctls <- lapply(catch_options, function(x)
  as(FLQuants(c(itarget, x, F0)), "fwdControl")
)

# RUN!

runs <- FLStocks(lapply(fctls, function(x) fwd(fut, sr=gmsrr, control=x)))

run <- fwd(fut, sr=gmsrr, control=fctls$Bpa)

Map(compare, runs, fctls)


# --- PROJECT F levels

flevels <- seq(0, 0.50, 0.01)

control <- as(as(c(lapply(itarget, propagate, length(flevels)),
  FLQuants(fbar=FLQuant(flevels,  dimnames=list(year=fy, iter=seq(length(flevels))))),
  lapply(F0, propagate, length(flevels))), "FLQuants"), "fwdControl")

f_runs <- divide(fwd(fut, sr=gmsrr, control=control), names=flevels)

# SAVE

save(runs, f_runs, rec1gm, tac, advice, file="model/runs.Rdata",
  compress="xz")

# McMC

source("model_mcmc.R")
