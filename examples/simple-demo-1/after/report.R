## Prepare plots and tables for report

## Before:
## After:

library(icesTAF)

mkdir("report")


# load data
trees <- read.taf("data/trees.csv")

# some plotting
taf.png("pairs_plot")
pairs(trees, panel = panel.smooth, main = "trees data")
dev.off()

taf.png("scatter_plot")
plot(Volume ~ Girth, data = trees, log = "xy")
dev.off()

taf.png("coplot")
coplot(log(Volume) ~ log(Girth) | Height,
  data = trees,
  panel = panel.smooth
)
dev.off()

# write out a rounded table of fits
taf_fits <- read.taf("output/tree_fits.csv")

taf_fits_rnd <- rnd(taf_fits, 4:5, c(2, 3))

write.taf(taf_fits_rnd, dir = "report")
