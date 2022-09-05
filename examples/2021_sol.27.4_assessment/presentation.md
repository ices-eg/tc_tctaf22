---
title: "Sole 27.4 - 2021 stock assessment"
subtitle: "ICES WGNSSK. Web, 21-30 April 2021"
author: Iago MOSQUEIRA
institute: Wageningen Marine Research (WMR), IJmuiden, The Netherlands.
fontsize: 10pt
output: beamer_presentation
header-includes:
  - \newcommand{\fig}[2][0.70]{\centering\includegraphics[width=#1\textwidth]{report/#2}}
tags: [sol.27.4 SA]
---

# North sea sole (sol.27.4)

- Update of 2020 benchmark assessment (AAP)

# Data overview

## Catches

- Landings: 1957-2020
- Discards: 2002-2020

## Indices of abundance

- BTS Q3 (NL + BE + DE) Delta-lognormal GAM: 1985-2020, ages 1-10
- SNS: 1970-2020, ages 1-6

## Stock weight

- Landings + discards quarter 2

# Official catches

\fig{official_landings.png}

- Catch 2020 = 10,492 t
- TAC 2020 = 17,545 t

# Catches and quota uptake

\fig{official_catch.png}

# Intercatch

## Coverage

- Main fleets (TBB 70-99) well sampled for landings and discards.
- More fleets with no samples, but low catches.

## Raising

- Main fleets by quarter
- Group by metier/gear
- Separate at 100 mm mesh size
- Discards include BMS landings and logbook-recorded discards

# Intercatch - landings

\fig[1]{intercatch/landingsPercCoutryFleets.png}

# Intercatch - discards

\fig[1]{intercatch/DiscardProvisionCoutryFleets.png}

# Catch, landings and discards

\fig{data_catches.png}

# Catch at age

\fig{data_catchn.png}

# Landings and discards

\fig[0.45]{data_landingsn.png} \fig[0.45]{data_discardsn.png}

# Discard ratio

\fig[0.75]{data_discardratio.png}

# Correlation in catch at age

\fig[0.55]{data_corrcatchn.png}

# Stock weight at age

\fig[0.45]{data_stockwt.png} \fig[0.45]{data_stockwt_recent.png}

- Constructed from catch weight-at-age quarter 2.

# Weigth at age from BTS Q3

\fig[0.45]{datras/datras_wt.png} \fig[0.45]{datras/datras_wtmean.png}

# BTS GAM, NL+BE+DE Q3

- Delta-lognormal GAM
- Ages 1-10+
- Time invariant spatial effect
- Year and gear factors
- Depth covariate
- Fitted using `surveyIndex` (Berg et al, 2014)
- <https://github.com/ices-taf/2021_sol.27.4_survey>

# BTS GAM - residuals

\fig[0.45]{gam/gam_residuals_age.png} \fig[0.45]{gam/gam_residuals_year.png}

# BTS GAM - residuals

\fig[0.45]{gam/gam_residuals_map.png} \fig[0.45]{gam/gam_depth.png}

# BTS GAM - 2020 estimates

\fig{gam/gam_map.png}

# BTS GAM, NL+BE+DE Q3

\fig{data_bts.png}

# Internal consistency

\fig[0.55]{data_corrbts.png}

# BTS consistency

\fig{data_bts_cohort.png}

# SNS

\fig{data_sns.png}

# SNS

\fig[0.55]{data_corrsns.png}

# SNS

\fig{data_sns_cohort.png}

# BTS & SNS

\fig[0.50]{data_bts-sns.png}

# AAP Model setup

| Setting        | Value                                 |
|----------------|---------------------------------------|
| Plus group     | 10                                    |
| First tuning year                               | 1970 |
| Catchability catches constant for age >=        | 8    |
| Catchability surveys constant for ages >=       | 8    |
| Spline for selectivity-at-age survey            | 6    |
| Tensor spline for F-at-age, ages                | 8    |
| Tensor spline for F-at-age, years               | 28   |
|----------------|---------------------------------------|

## Biology

- Natural mortality constant at 0.1 (but 0.9 in 1963)
- Maturity assumed time-invariant and knife-edge at age 3

# AAP 2020 run

\fig[0.85]{model_fit.png}

# TSB and SSB

\fig{model_ssbtsb.png}

# Refpts

\fig[0.45]{model_fbaref.png} \fig[0.45]{model_ssbref.png}

# Residuals

\fig{model_resid_source.png}

# Residuals

\fig{model_resid_ts.png}

# Observed and estimated catches

\fig{model_catchestimates.png}

# Retrospective patterns

\fig{model_retro.png}

- 3-year Mohn's rho: SSB = 0.26, F = -0.28

# Retrospective patterns

\fig{model_retro_recent.png}

# GAM BTS retrospective

\fig{data_btsretro.png}

- No effect in SSB or F Mohn's rho.

# What might be behind retrospective pattern?

- Retrospective by age group
  - Ages 1, 2 = 0.31
  - Ages 3-6 = 0.29
  - Ages 7-10 = 0.12

- Retrospective using 2021 SSB
  - 5 peel = 0.24
  - 3 peel = 0.15

- Run for BTS ages 1:8 only
  - SSB = 0.20
  - F = -0.23

- Run with BTS-NL
  - SSB = 0.16
  - F = -0.14

- Retro using 2021 SSB
  - SSB = 0.23

# Hindcasting cross-validation surveys

\fig{survey_xval.png}

# Indices runs test

\fig{indices_runstest.png}

# Indices runs test

\fig{indices_runstest_ages.png}

# F-at-age

\fig{model_fatage.png}

# Estimated recruitment

\fig{model_recssb.png}

# Proportion SSB at age

\fig{model_propssb.png}

# Issues

- Retrospective pattern needs to be addressed.
  - BTS selectivity.
  - Fishery selectivity in recent years.

- Residuals patterns
  - Recent age 1 landings and discards.
  - Estimated total landings and catches

- Trends in weights at age, effects on maturity or M.

- Maturity knife-edge and not time-varying.
