# model.R - Run analysis, write model results
# 2020_sol.27.4_assessment/model.R

# Copyright Iago MOSQUEIRA (WMR), 2021
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(icesTAF)
library(icesAdvice)
taf.library(FLa4a)
taf.library(a4adiags)

mkdir("model")

# LOAD data

load('data/data.Rdata')


# --- a4a

# fmodel

fmod <- ~te(replace(age, age > 8, 8), year, k = c(4, 22)) +
  s(replace(age, age > 8, 8), k=4) + s(year, k=22, by=as.numeric(age==1))

# qmodel (GAM, SNS)

qmod <- list(~s(age, k=3), ~s(age, k=3))

# vmodel (catch, GAM, SNS)

vmod <- list(
  ~s(age, k=3),
  ~s(age, k=3),
  ~s(age, k=3))

# srmodel

srmod <- ~factor(year)

# FIT sca

fit <- sca(stock, indices, srmodel=srmod, fmodel=fmod, qmodel=qmod,
  vmodel=vmod)

# UPDATE stock

run <- stock + fit


# --- RUN retrospective and xval

library(doParallel)

ncores <- detectCores(logical = TRUE)
cl <- makePSOCKcluster(names=seq(ncores - 2))
registerDoParallel(cl)  

# registerDoParallel(ncores)

sxval <- a4ahcxval(stock, indices, nyears=5, srmodel=srmod, fmodel=fmod, 
  qmodel=qmod, vmodel=vmod)

mrho <- lapply(c(F=fbar, Rec=rec, SSB=ssb), function(x)
  mohn(mohnMatrix(stocks=sxval$stocks, x)))


# --- RUN McMC fit: 6 min

system.time(fitmc <- sca(stock, indices,
  srmodel=srmod, fmodel=fmod, qmodel=qmod, vmodel=vmod,
  fit="MCMC", mcmc=SCAMCMC(mcprobe=0.1, mcsave=250, mcmc=(500 + 100) * 250)))

# REMOVE burnin iters
fitmc <- burnin(fitmc, 100)

# MERGE into stock
runmc <- stock + fitmc


# --- SAVE to model/

save(run, fit, refpts, sxval, mrho, runmc, fitmc, file="model/model.Rdata",
  compress="xz")
