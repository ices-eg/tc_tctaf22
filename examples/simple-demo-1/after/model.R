## Run analysis, write model results

## Before:
## After:

library(icesTAF)

mkdir("model")

# load data
trees <- read.taf("data/trees.csv")

# model
fm1 <- lm(log(Volume) ~ log(Girth), data = trees)
fm2 <- update(fm1, ~ . + log(Height), data = trees)
fm3 <- step(fm2)

summary(fm1)
summary(fm2)
summary(fm3)

save(fm1, fm2, fm3, file = "model/fits.Rdata")
