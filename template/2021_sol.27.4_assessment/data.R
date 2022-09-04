# data.R - Preprocess data, write TAF data tables
# 2021_sol.27.4_assessment/data.R

# Copyright Iago MOSQUEIRA (WMR), 2022
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


taf.library(icesTAF)
taf.library(data.table)
taf.library(FLCore)
taf.library(FLa4a)

mkdir("data")

dy <- 2021

# LOAD 2021 data and 2022 indices

load("bootstrap/data/data.Rdata")
load("bootstrap/data/indices.Rdata")

# EXTEND to dy

stock <- window(stock, end=dy)

# GET new data: landings.n/wt, discards.n/wt
newfqs <- lapply(setNames(do.call(mapply, c(list(file.path),
  as.list(expand.grid("bootstrap/data/", c("landings", "discards"),
  c("canum.txt", "weca.txt"))))),
  c("landings.n", "discards.n", "landings.wt", "discards.wt")),
  readVPAIntercatch)

# SET discards age 10 as 0
newfqs$discards.n <- expand(newfqs$discards.n, age=0:10)
newfqs$discards.n['10',] <- 0

newfqs$discards.wt <- expand(newfqs$discards.wt, age=0:10)
newfqs$discards.wt['10',] <- newfqs$discards.wt['9',]

# stock.wt: average weights from the 2nd quarter landings and discards
newfqs$stock.wt <- readVPAIntercatch("bootstrap/data/stock/weca.txt")

# REMOVE age 0
newfqs <- lapply(newfqs, "[", as.character(seq(1:10)))

# ASSIGN LN, DN, LW, DW
stock <- update(stock, newfqs)

# EXTEND M, MAT, *.SPWN
m(stock)[, ac(dy)] <- m(stock)[, ac(dy-1)]
mat(stock)[, ac(dy)] <- mat(stock)[, ac(dy-1)]
m.spwn(stock)[, ac(dy)] <- m.spwn(stock)[, ac(dy-1)]
harvest.spwn(stock)[, ac(dy)] <- harvest.spwn(stock)[, ac(dy-1)]

# ADD discards.wt[10,]
discards.wt(stock)[10, ac(1957:2001)] <- discards.wt(stock)[9, ac(1957:2001)]

# COMPLETE slots
discards(stock) <- computeDiscards(stock)
landings(stock) <- computeLandings(stock)
catch(stock) <- computeCatch(stock, "all")

# SET zero catches and indices to 1e-16
stock <- replaceZeros(stock)
indices <- replaceZeros(indices)

# VERIFY stock
verify(stock)

# CHECK SOP
sop(stock, slot="landings")


# --- SAVE

save(stock, indices, retroindices, refpts, file="data/data.Rdata", 
  compress="xz")


# --- CATCH reporting data

# StockOverview.txtx (intercatch)

stov <- fread("bootstrap/data/catch/StockOverview.txt")

setnames(stov,
  c("Catch. kg", "Catch Cat.", "Report cat.", "Discards Imported Or Raised"),
  c("catch", "category", "reporting", "discards"))

# Catch statistics by country

stats <- fread("bootstrap/data/catch/catches.dat")

# Preliminary official catches - <https://data.ices.dk/rec12/login.aspx>

prelim <- fread("bootstrap/data/catch/preliminary.dat")

# SUBSET 27.4
prelim <- prelim[grepl("27_4", Area),]

newstats <- as.data.frame(c(
  # official, bms TOTALS
  as.list(prelim[, .(official=sum(`AMS Catch(TLW)`, na.rm=TRUE),
    bms=sum(`BMS Catch(TLW)`, na.rm=TRUE))]),
  # countries
  as.list(dcast(prelim[Country %in% c('BE', 'DK', 'FR', 'DE', 'NL', 'GB'),
    .(official=sum(`AMS Catch(TLW)`)), by=Country], .~Country,
  value.var="official"))[-1],
  #other
  as.list(prelim[!Country %in% c('BE', 'DK', 'FR', 'DE', 'NL', 'GB'),
    .(other=sum(`AMS Catch(TLW)`))]),
  # ices, tac
  list(ices=c(catch(stock)[, ac(dy)]), tac=15330, year=dy)
))

setnames(newstats, "GB", "UK")

stats <- rbind(stats, round(newstats))

save(stats, stov, file="data/catch.Rdata", compress="xz")


# --- EXPORT csv tables

stocktables <- lapply(metrics(stock, catage=catch.n, latage=landings.n,
  datage=discards.n, wlandings=landings.wt, wdiscards=discards.wt,
  wstock=stock.wt, natmort=m, maturity=mat), function(x) plus(flr2taf(x)))

indextables <- lapply(FLQuants(survey.bts=index(indices[["BTS"]]),
  survey.sns=index(indices[["SNS"]])), function(x) plus(flr2taf(x)))

write.taf(c(stocktables, indextables), dir="data")
