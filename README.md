
# TCRSBPITAF-2022

Reproducible Science, Best Practices and the ICES Transparent Assessment Framework

- [ICES Training Programme](https://www.ices.dk/events/Training/Pages/TAF.aspx)
- Instructors:
  - Iago Mosqueira, Wageningen Marine Research, Netherlands.
  - Colin Millar, ICES Secretariat.

## Course goals

- Be able to create and populate a TAF repository for any analysis.
- Create all required outputs for a stock assessment and advice forecast.
- Use git for version control, development and collaboration.
- Report on the work carried out using markdown.

## Requirements

- R >= 4.2.0.
- Ability to install packages from various repositories (CRAN, FLR).
- Demonstrations will be run in [RStudio Desktop 2022.07.1+554](
https://www.rstudio.com/products/rstudio/download/#download). If you use Rtudio make sure it is recent version, or reinstall the very latest.
- Your own account in [github](https://github.com).
- Optional: Rtools, to be able to reinstall packages that migt be updated.

## INSTALLATION

- Please try installing the necessary packages in advance, by running:

```r
pkgs <- c("data.table", "flextable", "officedown", "doParallel",
  "ggrepel", "patchwork", "icesdown", "icesAdvice", "icesTAF",
  "FLCore", "FLFishery", "FLasher", "FLa4a", "ggplotFL", "a4adiags")

install.packages(pkgs, repos=c(
    FLR="https://flr-project.org/R",
    ICES="https://ices-tools-prod.r-universe.dev/",
    CRAN="https://cloud.r-project.org"))
```

- Report any problems using the [repository issue system](https://github.com/ices-eg/tc_tctaf22/issues), or by email.

- Please clone the course material repository at <https://github.com/ices-eg/tc_tctaf22>.

## Bring

- Your own data and code for a stock assessment and forecast.

