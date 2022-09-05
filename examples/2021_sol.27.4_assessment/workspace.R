# workspace.R - Install packages and setup data
# 2021_sol.27.4_assessment/workspace.R

# Copyright Iago MOSQUEIRA (WMR), 2022
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(icesTAF)

# INITIAL setup

pkgs <- c("data.table", "flextable", "officedown", "doParallel",
  "ggrepel", "patchwork", "icesdown", "icesAdvice", "icesTAF",
  "FLCore", "FLa4a", "ggplotFL", "a4adiags")

# INSTALL from CRAN and r-universe

install.packages(pkgs, repos=c(
    FLR="https://flr-project.org/R",
    ICES="https://ices-tools-prod.r-universe.dev/",
    CRAN="https://cloud.r-project.org"))

draft.software(c("FLCore", "FLa4a", "a4adiags"), file=TRUE)

# BOOT

taf.bootstrap(software = TRUE, data = TRUE)
