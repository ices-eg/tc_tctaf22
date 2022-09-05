## Extract results of interest, write TAF output tables

## Before:
## After:

library(icesTAF)

mkdir("output")

# load data
trees <- read.taf("data/trees.csv")

# load model fits
load("model/fits.Rdata")

# make and save a prediction
tree_fits <- cbind(trees, predict(fm3, se.fit = TRUE)[c("fit", "se.fit")])

write.taf(tree_fits, dir = "output")
