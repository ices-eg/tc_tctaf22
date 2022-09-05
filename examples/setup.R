# setup.R - SETUP R package and tools
# TCRSBPITAF-2022/sessions/Day_1/D01S01/setup.R

# Copyright (c) WUR, 2022.
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


# Required packages

pkgs <- c("data.table", "flextable", "officedown", "doParallel",
  "ggrepel", "patchwork", "icesdown", "icesAdvice", "icesTAF",
  "FLCore", "FLFishery", "FLasher", "FLa4a", "ggplotFL", "a4adiags")

# Install from CRAN, FLR and r-universe

install.packages(pkgs, repos=c(
    FLR="https://flr-project.org/R",
    ICES="https://ices-tools-prod.r-universe.dev/",
    CRAN="https://cloud.r-project.org"))

# Record packages being used that could affect results

draft.software(c("FLCore", "FLasher", "FLa4a", "a4adiags"), file=TRUE)

# bootstrap

library(icesTAF)

taf.bootstrap(software = TRUE, data = TRUE)


# --- PROBLEMS?

# CHECK library location, is it writable?

.libPaths()
