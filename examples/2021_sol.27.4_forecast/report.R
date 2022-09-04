# report.R - DESC
# /report.R

# Copyright Iago MOSQUEIRA (WMR), 2021
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2

library(icesTAF)

taf.library(FLa4a)
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

taf.png("model_ssbmc.png")
plot(ssb(runsmc$Fmsy), probs=c(0.05, 0.10, 0.25, 0.50, 0.75, 0.90, 0.95)) +
  geom_flpar(data=refpts[c(1, 3)], x=1961, colour=c("black", "red"),
    linetype=c(3,1)) + vline
dev.off()

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
