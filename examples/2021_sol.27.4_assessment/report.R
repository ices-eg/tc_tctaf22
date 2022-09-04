# report.R - Extract results of interest, write TAF output tables
# 2021_sol.27.4_assessment/report.R

# Copyright Iago MOSQUEIRA (WMR), 2022
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2


library(icesTAF)

mkdir("report")

# COPY external figures
cp("bootstrap/initial/data/report/*", "report/")

taf.library(FLCore)
taf.library(FLa4a)
taf.library(ggplotFL)

taf.library(data.table)
taf.library(patchwork)
taf.library(ggrepel)

# INPUT

load("data/data.Rdata")
load("output/model.Rdata")

# DIMS

y0 <- dims(stock)$minyear
dy <- dims(stock)$maxyear


# --- official

stats <- fread("bootstrap/data/catch/catches.dat")

# Official landings per country

taf.png("official_landings.png")
ggplot(melt(stats[, .(year, BE, DK, FR, DE, NL, UK, other)], id.vars="year",
  variable.name="country", value.name="data", verbose=FALSE), aes(x=year, y=data)) +
  geom_col(aes(fill=country)) + ylab("Landings (t)") + xlab("") +
  guides(fill=guide_legend(nrow=1, byrow=TRUE)) +
  theme(legend.title = element_blank())
dev.off()

# Catches and TACs

dat <- melt(stats[, .(year, official, ices, tac)], id.vars="year",
  variable.name="category", value.name="data", verbose=FALSE)

taf.png("official_catch.png")
ggplot(dat, aes(x=year, y=data)) +
  geom_line(aes(colour=category), size=1) +
  ylab("Catch (t)") + xlab("") +
  guides(colour=guide_legend(nrow=1, byrow=TRUE)) +
  theme(legend.title = element_blank()) +
  ylim(c(0,NA))
dev.off()


# --- data

# - catches

# Time-series of catches (in tonnes) reported to ICES (InterCatch)

taf.png("data_catches.png")
ggplot(metrics(stock, list(Catch=catch, Landings=landings, Discards=discards)),
  aes(x=date, y=data, group=qname, linetype=qname)) + geom_line() +
  ylab(paste0("Yield (", units(catch(stock)),")")) + xlab("") +
  theme(legend.title=element_blank(), legend.position="bottom")
dev.off()

# Time-series of catch at age

taf.png("data_catchn.png")
ggplot(catch.n(stock), aes(x=year, y=as.factor(age))) +
  geom_point(aes(size=abs(data)), shape=21, na.rm=TRUE) +
  scale_size(range = c(0.1, 12)) +
  ylab(paste0("Catch (", units(catch.n(stock)),")")) + xlab("") +
  theme(legend.title=element_blank(), legend.position="none") +
  guides(size = guide_legend(nrow = 1))
dev.off()

# Time-series of landings at age

taf.png("data_landingsn.png")
ggplot(landings.n(stock) * landings.wt(stock), aes(x=year, y=as.factor(age))) +
  geom_point(aes(size=abs(data)), shape=21, na.rm=TRUE) +
  scale_size(range = c(0.1, 12)) +
  ylab(paste0("Landings (", units(catch(stock)),")")) + xlab("") +
  theme(legend.title=element_blank(), legend.position="bottom") +
  guides(size = guide_legend(nrow = 1))
dev.off()

# Time-series of discards at age

taf.png("data_discardsn.png")
ggplot(window(discards.n(stock), start=2000),
  aes(x=year, y=as.factor(age))) +
  geom_point(aes(size=abs(data)), shape=21, na.rm=TRUE) +
  scale_size(range = c(0.1, 12)) +
  ylab(paste0("Discards (", units(discards.n(stock)),")")) + xlab("") +
  theme(legend.title=element_blank(), legend.position="bottom") +
  guides(size = guide_legend(nrow = 1))
dev.off()

# Time-series of discard proportion at age

taf.png("data_discardsp.png")
ggplot(window(discards.n(stock) * discards.wt(stock), start=2000) /
  window(catch.n(stock) * catch.wt(stock), start=2000),
  aes(x=year, y=as.factor(age))) +
  geom_point(aes(size=abs(data), fill=data), shape=21, na.rm=TRUE) +
  scale_size_continuous(range = c(0.1, 8), name="p") +
  scale_fill_gradient(low = "white", high = "gray50", name="p",
    guide = "legend") +
  ylab(paste0("Proportion discarded")) + xlab("") +
  theme(legend.title=element_blank(), legend.position="bottom") +
  guides(size = guide_legend(nrow = 1))
dev.off()

# Discards ratio

taf.png("data_discardratio.png")
ggplot(window(discards.n(run) / catch.n(run), start=2000),
  aes(x=year, y=data, colour=factor(age))) + geom_line() +
  geom_label_repel(data=as.data.frame((discards.n(run) /
    catch.n(run))[, ac(dy)]), aes(label=age), colour="black") +
  guides(colour="none") + ylab("Discard ratio (discards/catch)") +
  xlab("") + ylab("")
dev.off()

# Time series of catch by cohort

taf.png("data_catchcoh.png")
ggplot(as.data.frame(FLCohort(catch.n(stock))), aes(x=cohort, y=data,
    group=age)) +
  geom_line(aes(colour=factor(age))) +
  xlab("Cohort") + ylab("Catch (thousands)") +
  theme(legend.position="none")
dev.off()

taf.png("data_catchcoh2.png")
ggplot(as.data.frame(FLCohort(catch.n(stock))), aes(x=cohort, y=data, 
    group=age)) +
  geom_line(aes(colour=factor(age))) +
  facet_grid(age~., scales="free") +
  xlab("") + ylab("Catch (thousands)") +
  theme(legend.position="none")
dev.off()

# Correlation in catch-ata-age data

taf.png("data_corrcatchn.png", width=1200, res=120)
cohcorrplot(FLCohort(catch.n(stock)))
dev.off()

# Time series of mean weight-at-age in the stock

taf.png("data_stockwt.png")
ggplot(stock.wt(stock), aes(x=year, y=data * 1000, group=age, 
  colour=factor(age))) +
  geom_line() + ylab("Weight-at-age (g)") + xlab("") +
  geom_smooth(se=FALSE, size=0.5, alpha=0.2) +
  geom_text_repel(data=as.data.frame(stock.wt(stock)[, ac(y0)]),
    aes(x=year - 1, label=age), colour="black") +
  geom_text_repel(data=as.data.frame(stock.wt(stock)[, ac(dy)]),
    aes(x=year + 1, label=age), colour="black") +
  theme(legend.position="none")
dev.off()

taf.png("data_stockwt_recent.png")
ggplot(stock.wt(stock)[,ac(2000:dy)], aes(x=year, y=data * 1000, group=age,
    colour=factor(age))) +
  geom_line() + ylab("Weight-at-age (g)") + xlab("") +
  geom_text_repel(data=as.data.frame(stock.wt(stock)[, ac(dy)]),
    aes(x=year + 1, label=age), colour="black") +
  theme(legend.position="none")
dev.off()

# Time series of mean weight-at-age by cohort in the stock

taf.png("data_stockwtcoh.png")
ggplot(as.data.frame(FLCohort(stock.wt(stock))[, ac(seq(y0 + 3, dy - 2))]),
  aes(x=cohort + age - 1, y=data * 1000, group=cohort)) +
  geom_line() + ylab("Weight-at-age (g)") + xlab("Cohort") +
  geom_point(size=1, aes(colour=factor(age))) +
  geom_text(aes(label=age), size=0.5, colour="red") +
  guides(colour="none")
dev.off()

# Time series of mean weight-at-age in the landings

taf.png("data_landingswt.png")
ggplot(landings.wt(stock), aes(x=year, y=data*1000, group=age, 
    colour=factor(age))) +
  geom_line() + ylab("Weight-at-age (g)") + xlab("") +
  geom_text_repel(data=as.data.frame(landings.wt(stock)[, c("1957")]),
    aes(x=year-1, label=age), colour="black") +
  geom_text_repel(data=as.data.frame(landings.wt(stock)[, c("2019")]),
    aes(x=year+1, label=age), colour="black") +
  theme(legend.position="none")
dev.off()

# Cohort plot catch

dat <- data.table(as.data.frame(catch.n(stock) * catch.sel(run), cohort=TRUE))
dat[, mean:=mean(data), by=.(cohort)]

taf.png("catch_cohort.png")
ggplot(dat, aes(x=cohort, y=data/mean, group=age)) +
  geom_line(colour='red') +
  geom_point(colour='white', size=5) +
  geom_text(aes(label=age)) +
  xlab("Cohort") + ylab("Catch (thousands)") +
  xlim(c(1989, 2019))
dev.off()

# - indices

# Standardized comparison of BTS and ISIS indices.

# BTS + SNS
taf.png("data_bts-sns.png", height=2000)
plot(indices[c("BTS", "SNS")]) + facet_wrap(~age, ncol=3) +
  scale_colour_brewer(palette = 'Dark2') +
  theme(legend.position = c(0.5, 0.07))
dev.off()

# BTS
taf.png("data_bts.png")
plot(indices[[c("BTS")]]) + facet_wrap(~age, ncol=2, scales="free_y") +
  theme(legend.position = "none") + geom_line(colour="#1B9E77")
dev.off()

# SNS
taf.png("data_sns.png")
plot(indices[["SNS"]]) + facet_wrap(~age, ncol=2, scales="free_y") +
  theme(legend.position = "none") + geom_line(colour="#D95F02")
dev.off()

# Internal consistency plots

taf.png("data_corrbts.png", width=1200, res=120)
cohcorrplot(FLCohort(index(indices[["BTS"]])))
dev.off()

taf.png("data_corrsns.png", width=1200, res=120)
cohcorrplot(FLCohort(index(indices[["SNS"]])))
dev.off()

# Cohort plot BTS

taf.png("data_bts_cohort.png")
ggplot(index(indices[["BTS"]]), aes(x=cohort, y=log(data), group=age)) +
  geom_line(aes(colour=factor(age))) +
  geom_point(colour='white', size=5) +
  geom_text(aes(label=age)) +
  xlab("Cohort") + ylab("log(abundance)") +
  xlim(c(2001, an(dy) - 1)) + ylim(c(0, 10)) +
  theme(legend.position="none")
dev.off()

# Cohort plot SNS

taf.png("data_sns_cohort.png")
ggplot(index(indices[["SNS"]]), aes(x=cohort, y=log(data), group=age)) +
  geom_line(aes(colour=factor(age))) +
  geom_point(colour='white', size=5) +
  geom_text(aes(label=age)) +
  xlab("Cohort") + ylab("log(abundance)") +
  xlim(c(2004, an(dy) - 1)) +
  theme(legend.position="none")
dev.off()

# Mean BTS standardised index by cohort (top) and by year (bottom)

p1 <- ggplot(index(indices[["BTS"]]), aes(x=cohort, y=log(data), group=age)) +
  geom_line(colour='red') +
  geom_point(colour='white', size=5) +
  geom_text(aes(label=age), size=3) +
  xlab("Cohort") + ylab(names(indices["BTS"])) +
  xlim(c(2001, an(dy)))

p2 <- ggplot(index(indices[["BTS"]]), aes(x=year, y=log(data), group=age)) +
  geom_line(colour='blue') +
  geom_point(colour='white', size=5) +
  geom_text(aes(label=age), size=3) +
  xlab("Year") + ylab(names(indices["BTS"])) +
  xlim(c(2001, an(dy)))

taf.png("data_coh_bts.png")
p1 / p2
dev.off()


# BTS GAM retrospective

taf.png("data_btsretro.png", height=600)
ggplot(FLQuants(lapply(retroindices, function(x)
  quantSums(window(index(x$BTS), start=2000, end=2021) *
    window(stock.wt(stock), start=2000)))),
  aes(x=year, y=data, group=qname, colour=qname)) +
  geom_line() + ylab("Index (biomass)") + xlab("") +
  guides(colour='none')
dev.off()

# --- model

# Stock

taf.png("model_run.png")
plot(run)
dev.off()

# fit + stock
taf.png("model_fit.png")
plot(fit, stock)
dev.off()

# Estimated and observed catches

taf.png("model_catchestimates.png", height=600)
ggplot(model.frame(FLQuants(EST=catch(run), OBS=catch(stock))), aes(x=year)) +
  geom_line(aes(y=EST)) + geom_point(aes(y=OBS)) +
  ylab("Catch (t)") + xlab("") +
  ggtitle("Catch")
dev.off()

# TSB and SSB

taf.png("model_ssbtsb.png")
ggplot(metrics(run, list(TSB=tsb, SSB=ssb)), aes(x=year, y=data, colour=qname)) +
  geom_line(size=1) + xlab("") + ylab("Biomass (t)") +
  theme(legend.title=element_blank())
dev.off()

# Rec ~ SSB

dat <- data.table(model.frame(FLQuants(Recruitment=rec(as.FLSR(run)),
  SSB=ssb(as.FLSR(run)))))
dat[year %in% c(1958, seq(1960, dy, by=5)), label:=year]

taf.png("model_recssb.png")
ggplot(dat, aes(x=SSB, y=Recruitment, label=label)) + geom_path(alpha=0.3) +
  geom_point() +
  geom_label_repel(data=dat,
    fill=c("#bfcf9f", rep("white", dim(dat)[1] - 2), "#c03839"),
    colour=c(rep(1, dim(dat)[1] - 1), "white"), alpha=0.8) +
  xlab("SSB (t)") + ylab("Recruitment (thousands)")
dev.off()

# proportion SSB at age

fill <- c("#21313E","#214C57","#1F6969","#2A8674","#4AA377","#78BF73",
  "#AFD96C","#EFEE69")
msb <- (stock.n(run) * stock.wt(run) * mat(run))[-c(1,2),]

taf.png("model_propssb.png")
ggplot(msb %/% quantSums(msb), aes(x=year, y=data, fill=as.factor(age))) +
  geom_bar(stat="identity", width=1) + scale_fill_manual(values=fill) +
  xlab("") + ylab("Proportion of SSB") +
  scale_y_continuous(labels = scales::percent) +
  theme(legend.title=element_blank(), legend.position="right") +
  guides(fill = guide_legend(nrow = 8))
dev.off()

# F vs. reference points

taf.png("model_fbaref.png")
plot(fbar(run)) +
  geom_hline(yintercept=c(refpts$Flim), color="red", size=0.25)+
    geom_text(x=dy+1, y=c(refpts$Flim + 0.02), label=expression(F[lim])) +
  geom_hline(yintercept=c(refpts$F05), linetype=3) +
    geom_text(x=dy+1, y=c(refpts$F05 + 0.02), label=expression(F[PA])) +
  geom_hline(yintercept=c(refpts$Fmsy), linetype=2) +
    geom_text(x=dy+1, y=c(refpts$Fmsy + 0.02), label=expression(F[MSY])) +
  ylim(c(0,NA)) + ylab("F (ages 2-6)")
dev.off()

# SSB vs. reference points

taf.png("model_ssbref.png")
plot(ssb(run)) +
  geom_hline(yintercept=c(refpts$Bpa), color="red", size=0.25) +
    geom_text(x=1957, y=c(refpts$Bpa - 2500), label=expression(B[PA]), hjust="inward") +
  geom_hline(yintercept=c(refpts$Btrigger), linetype=3) +
    geom_text(x=1957, y=c(refpts$Btrigger + 2000), label=expression(MSYB[trigger]),
      hjust="inward") +
  geom_hline(yintercept=c(refpts$Blim), linetype=2) +
    geom_text(x=1957, y=c(refpts$Blim + 2000), label=expression(B[lim]), hjust="inward") +
  ylim(c(0,NA)) + ylab("SSB (tonnes)")
dev.off()

# Retro with error & Mohn's rho in F, SSB, Rec

taf.png("model_retro.png")
plot(run, sxval$stocks, mrho=mrho)
dev.off()

taf.png("model_retro_recent.png")
plot(sxval$stocks, metrics=list(SSB=ssb, F=fbar)) +
  xlim(c(2000, dy)) + guides(colour="none")
dev.off()

# Retro selectivity

taf.png("retro_selex.png")
ggplot(lapply(sxval$stocks, function(x) window(catch.sel(x), start=2010)),
  aes(x=age, y=data, group=qname, colour=qname)) + geom_line() +
    facet_wrap(.~year) + xlab("Age") +
  guides(colour = guide_legend(nrow = 2)) +
  theme(legend.position="bottom") +
  labs(colour="Retrospective peel") +
  scale_x_continuous(breaks = integer_breaks()) +
  ylab("Selectivity")
dev.off()

# XVAL
taf.png("survey_xval.png")
plotXval(sxval$indices)
dev.off()

# Runs test

resid <- residuals(fit, stock, indices=indices)

taf.png("indices_runstest.png")
plotRunstest(window(resid[c("BTS", "SNS")], start=1970), combine=TRUE)
dev.off()

taf.png("indices_runstest_ages.png")
plotRunstest(window(resid[c("BTS", "SNS")], start=1970), combine=FALSE)
dev.off()

# Residuals age~year by data source

taf.png("model_resid_source.png")
ggplot(resid, aes(x=year, y=as.factor(age))) +
  geom_point(aes(size=abs(data), fill=factor(sign(data), labels=c("<0", ">0"))),
    shape=21, alpha=0.4, na.rm=TRUE) +
  facet_wrap(~qname) +
  scale_size(range = c(0.1, 6)) +
  theme(legend.position="bottom", legend.title=element_blank()) +
  xlab("") +
  ylab(expression(paste("Standardized log residuals, (", y-hat(y),")/", sigma))) +
  # scale_fill_brewer(breaks=c(-1, 1), type="qual", palette=7, na.translate = F) +
  scale_fill_manual(values = c("red", "seagreen3", "white"), na.translate = F) +
  guides(size = guide_legend(nrow = 1), fill=guide_legend())
dev.off()

# Residuals in time

taf.png("model_resid_ts.png")
ggplot(resid, aes(x=year, y=data)) +
  geom_point(alpha=0.2) + facet_grid(qname~age) +
  geom_hline(yintercept=0, alpha=0.5, size=0.5) +
  geom_smooth(se=FALSE) +
  scale_x_continuous(breaks=c(1960, 1990, 2019)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("") +
  ylab(expression(paste("Standardized log residuals, (", y-hat(y),")/", sigma)))
dev.off()

# selectivities

taf.png("model_selex.png")
ggplot(catch.sel(run)[, ac(floor(c(seq(1959, 2015, length=15), 2016:dy)))],
  aes(x=age, y=data)) + geom_line() + facet_wrap(~year) +
  scale_x_continuous(breaks = integer_breaks()) +
  xlab("") + ylab("Selectivity")
dev.off()

# Fs

taf.png("model_fatage.png")
ggplot(harvest(fit), aes(x=year, y=data, colour=factor(age))) +
  geom_line() + facet_wrap(~age) + xlab("") + ylab("F") +
  theme(legend.position="none")
dev.off()

# Productivity

taf.png("recperspawn.png")
plot(log(rec(run)[,-1] / quantSums(stock.n(run) * mat(run))[,-dims(run)$year])) +
  geom_point(size=3, colour='white') +
  geom_point(size=2, shape=1) +
  ylab("log(recruits / spawner)")
dev.off()

taf.png("spawnperrec.png")
plot(log(quantSums(stock.n(run) * mat(run)) / rec(run))) +
  geom_point(size=4, colour='white') +
  geom_point(size=2, shape=1) +
  ylab("log(spawners / recruits)")
dev.off()

# VB

taf.png("vulbiom.png")
ggplot(metrics(run, SSB=ssb, VB=vb),
  aes(x=year, y=data, group=qname, colour=qname)) +
  geom_line() + xlab("") + ylab("Biomass (t)") +
  theme(legend.title=element_blank())
dev.off()

# --- presentation

render('presentation.md',
  output_file = 'report/sol.27.4_assessment-WGNSSK2021.pdf')

# --- report

render("report.Rmd", output_dir="report", clean=TRUE,
  output_file="report/WGNSSK 2021_Section-17_Sole_in_Subarea_4.docx")

