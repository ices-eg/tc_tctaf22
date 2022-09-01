# report.R - DESC
# /report.R

# Copyright Iago MOSQUEIRA (WMR), 2021
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2

library(icesTAF)

library(FLa4a)
library(ggplotFL)
library(patchwork)

load("model/runs.Rdata")
load("model/runsmc.Rdata")
load("data/model.Rdata")

dimnames(refpts)$params[1] <- "Btrigger / Bpa"

# MODEL, ADVICE and FORECAST year

dy <- dims(run)$maxyear
ay <- dy + 1
fy <- ay + 1

# GRAPHICAL elements

box <- annotate("rect", xmin = ay - 0.5, xmax = fy + 1, ymin=-Inf, ymax=Inf,
  fill="lightgrey", alpha = .3)

vline <- geom_vline(xintercept=dy + 0.5, linetype=1, colour="#464A54")


# --- McMC runs

# ssb(mcmc) vs. ssb(fit)

mc <- as.data.frame(FLQuantPoint(mean=ssb(run), median=quantile(ssb(runmc), c(0.50)),
  lowq=quantile(ssb(runmc), c(0.05)), uppq=quantile(ssb(runmc), c(0.95))))
ap <- as.data.frame(ssb(run))

dat <- rbindlist(list(McMC=mc, AAP=ap), idcol="method")

ggplot(dat, aes(x=year, colour=method)) + geom_line(aes(y=mean)) +
  geom_line(aes(y=lowq), linetype=2) + geom_line(aes(y=uppq), linetype=2)

ggplot(dat, aes(x=year, colour=method)) + geom_line(aes(y=mean)) +
  geom_line(aes(y=median), linetype=2)


taf.png("model_ssbmc.png")
plot(ssb(runsmc$Fmsy), probs=c(0.05, 0.10, 0.25, 0.50, 0.75, 0.90, 0.95)) +
  geom_flpar(data=refpts[c(1, 3)], x=1961, colour=c("black", "red"),
    linetype=c(3,1)) + vline
dev.off()

# 90, 80, 70
probs <- c(0.05, 0.10, 0.2, 0.50, 0.8, 0.90, 0.95)

# 95, 80, 50
probs <- c(0.025, 0.10, 0.25, 0.50, 0.75, 0.90, 0.975)

taf.png("model_fwdmc.png")
(plot(ssb(runsmc$Fmsy), probs=probs) +
  geom_flpar(data=refpts[c(1, 3)], x=1961, colour=c("black", "red"),
    linetype=c(3,1)) + vline + ylab("SSB (t)")) /
(plot(rec(runsmc$Fmsy), probs=probs) + vline +
  ylab("Recruits (thousands)"))
dev.off()

taf.png("model_fwd.png")
(plot(ssb(runs$Fmsy), probs=probs) +
  geom_flpar(data=refpts[c(1, 3)], x=1961, colour=c("black", "red"),
    linetype=c(3,1)) + vline + ylab("SSB (t)") + ylim(c(0, NA))) /
(plot(window(fbar(runs$Fmsy), end=2022), probs=probs) + vline +
  geom_flpar(data=refpts[c(2, 5, 6)], x=1961, colour=c("black", "red", "black"),
    linetype=c(1,1, 3)) + vline + ylab("SSB (t)") + ylim(c(0, NA)))
dev.off()



(plot(FLQuantPoint(mean=ssb(run), lowq=quantile(ssb(runmc), c(0.05)),
  uppq=quantile(ssb(runmc), c(0.95))))) +
plot(ssb(fit))

sqrt(iterVars(ssb(runsmc$Fmsy)))

sqrt(iterVars(ssb(runsmc$Fmsy))) / iterMeans(ssb(runsmc$Fmsy))

sqrt(iterVars(ssb(runsmcdev$Fmsy))) / iterMeans(ssb(runsmcdev$Fmsy))



plot(window(FLStocks(RESAMP=runsmcdev1$Fmsy, GM=runsmcdev0$Fmsy), start=2015),
  metrics=list(Rec=rec, SSB=ssb), probs=c(0.05, 0.25, 0.50, 0.75, 0.95))
plot(rec(runsmc$Fmsy), probs=c(0.05, 0.25, 0.50, 0.75, 0.95)) + vline

library(patchwork)

(plot(FLQuantPoint(mean=ssb(run), lowq=quantile(ssb(runmc), c(0.05)),
  uppq=quantile(ssb(runmc), c(0.95))))) +
plot(ssb(fit))

sqrt(iterVars(ssb(runsmc$Fmsy)))

sqrt(iterVars(ssb(runsmc$Fmsy))) / iterMeans(ssb(runsmc$Fmsy))

sqrt(iterVars(ssb(runsmcdev$Fmsy))) / iterMeans(ssb(runsmcdev$Fmsy))



plot(window(FLStocks(RESAMP=runsmcdev1$Fmsy, GM=runsmcdev0$Fmsy), start=2015),
  metrics=list(Rec=rec, SSB=ssb), probs=c(0.05, 0.25, 0.50, 0.75, 0.95))

x <- window(FLStocks(RESAMP=runsmcdev1$Fmsy,
  `GM + LN(0,0.78)`=runsmcdev0$Fmsy), start=2021)

ggplot(lapply(x, ssb), aes(x=factor(year), y=data, fill=factor(year))) +
  geom_boxplot() +
  facet_wrap(~qname)

ggplot(lapply(x, rec), aes(x=factor(year), y=data, fill=factor(year))) +
  geom_boxplot() +
  facet_wrap(~qname)


