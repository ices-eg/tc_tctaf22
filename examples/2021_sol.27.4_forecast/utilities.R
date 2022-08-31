# utilities.R - DESC
# /utilities.R

# Copyright Iago MOSQUEIRA (WMR), 2021
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2

# interimTable {{{

interimTable <- function(run, fy=dims(run)$maxyear) {

  ay <- ac(fy - 2)
  iy <- ac(fy - 1)

  tabs <- FLQuants(
  `F[ages 2-6] (ay)`=fbar(run)[, ay],
  `SSB (iy)`=ssb(run)[, iy],
  `R[age 1] (ay, iy)`=rec(run)[, ay],
  `Total catch (ay)`=catch(run)[, ay],
  `Projected landings (ay)`=landings(run)[, ay],
  `Projected discards (ay)`=discards(run)[, ay])

  names(tabs) <- gsub("iy", iy, names(tabs))
  names(tabs) <- gsub("ay", ay, names(tabs))

  tab <- lapply(tabs, c)
  tab <- data.frame(Variable=names(tab), Value=unlist(tab), row.names=NULL)

  # icesRound 1st row
  tab[1, "Value"] <- icesRound(as.numeric(tab[1, "Value"]))

  # ROUND others
  tab[2:6, "Value"] <- round(as.numeric(tab[2:6, "Value"]))

  return(tab)

} # }}}

# catchOptionsTable {{{

catchOptionsTable <- function(runs, advice, tac=advice, ages, discards.ages) {

  sy <- dims(runs[[1]])$maxyear
  fy <- ac(sy - 1)
  iy <- ac(sy - 2)
  sy <- ac(sy)

  rows <- c(
    Fmsy = "MSY approach: F[MSY]",
    Fmsy = "F[MSY]",
    lFmsy = "F = F[MSY lower]",
    uFmsy = "F = F[MSY upper]",
    F0 = "F = 0",
    Fpa = "F[pa]",
    F05noAR = "F[p.05] without AR",
    Flim = "F[lim]",
    Bpa = paste0("SSB (", sy, ") = B[pa]"),
    Blim = paste0("SSB(", sy, ")=B[lim]"),
    MSYBtrigger = paste0("SSB(", sy, ") = MSY B[trigger]"),
    F2021 = paste0("F[", iy, "]"),
    rotac = "Roll-over TAC")

  tabs <- lapply(runs[names(rows)], function(x) {
    model.frame(FLQuants(
      # 
      c(metrics(window(x, start=fy, end=fy),
        list(catch=catch, wanted=landings, unwanted=discards, F=fbar,
        Fwanted=function(z) Fwanted(z, ages),
        Funwanted=function(z) Funwanted(z, discards.ages))),
      metrics(window(x, start=sy, end=sy),
        list(SSB=ssb)))), drop=TRUE)
    }
  )

  # COMBINE as single table

  tab <- rbindlist(tabs, idcol="basis")

  # ADD SSB change, 100 - (old / new) * 100
  ssbfy <- c(ssb(runs[[1]])[, ac(fy)])
  tab[, ssbchange:=(SSB - ssbfy) / ssbfy * 100]

  # ADD TAC change
  tab[, tacchange:=(catch - c(tac)) / c(tac) * 100]

  # ADD advice change
  tab[, advicechange:=(catch - c(advice)) / c(advice) * 100]

  # FIX zeroes
  tab[, (2:11) := lapply(.SD, function(x)
    ifelse(abs(x) < 0.0001, 0, x)), .SDcols=2:11]

  tab$basis <- rows

  # CALL round and icesRound
  tab[, c(2,3,4,8) := lapply(.SD, round, digits=0), .SDcols = c(2,3,4,8)]
  tab[, c(5,6,7) := lapply(.SD, round, digits=3), .SDcols = c(5,6,7)]
  tab[, c(9,10,11) := lapply(.SD, icesRound), .SDcols = c(9,10,11)]

  cnms <- c("Basis", "Total catch (FY)", "Projected landings (FY)",
    "Projected discards (FY)", "F[total] (ages AGES) (FY)",
    "F[projected landings] (ages AGES) (FY)",
    "F[projected discards] (ages DISC) (FY)", "SSB (SY)", "% SSB change",
    "% TAC change", "% advice change")

    cnms <- gsub("FY", fy, cnms)
    cnms <- gsub("SY", sy, cnms)
    cnms <- gsub("AGES", paste0(ages[1], "-", ages[2]), cnms)
    cnms <- gsub("DISC", paste0(discards.ages[1], "-", discards.ages[2]), cnms)

  setnames(tab, cnms)

  return(tab)
}


# summaryAssessmentTable

