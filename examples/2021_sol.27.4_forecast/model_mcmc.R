# model.R - Run forecast
# 2020_sol.27.4_forecast/model.R

# Copyright Iago MOSQUEIRA (WMR), 2020
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


# --- SETUP future

# 3 years, 5 years wts/selex, 3 years discards

futmc <- stf(runmc, nyears=3, wts.nyears = 5, fbar.nyears=5, disc.nyears=3)

# DEVIANCES, resampled from last 10 years

deviances <- FLQuant(sample(c(rec(runmc)[, ac(2012:2021)]), 3000, replace=TRUE),
  dimnames=list(year=2022:2024, age=1, iter=1:500))

# RUN w/McMC!

runsmc <- FLStocks(lapply(fctls, function(x)
  fwd(futmc, sr=predictModel(model=rec~a, params=FLPar(a=1)), control=x,
  deviances=deviances)))

# COMPUTE medians

mrunsmc <- lapply(runsmc, function(x) qapply(x, iterMedians))

# COMPARE

plot(FLStocks(RUN=runs$Fmsy, MC=mrunsmc$Fmsy))

plot(FLStocks(RUN=runs$Fmsy, MC=runsmc$Fmsy))

# SAVE

save(runsmc, file="model/runsmc.Rdata", compress="xz")
