library(icesTAF)

taf.skeleton(".")

write.taf(trees, dir = taf.boot.path("initial", "data"))

?taf.boot.path

draft.data()

draft.data(data.files = "cars.csv")

draft.data(
  data.files = "trees.csv",
  data.scripts = NULL,
  originator = "Ryan, T. A., Joiner, B. L. and Ryan, B. F. (1976) The Minitab Student Handbook. Duxbury Press.",
  title = "Diameter, Height and Volume for Black Cherry Trees",
  file = TRUE,
  append = FALSE
)

taf.bootstrap()


# an example (very simple) analysis
# excercise is to move this into a TAF structure

# load data
trees <- read.taf(taf.data.path("trees.csv"))

# some plotting
pairs(trees, panel = panel.smooth, main = "trees data")
plot(Volume ~ Girth, data = trees, log = "xy")
coplot(log(Volume) ~ log(Girth) | Height,
  data = trees,
  panel = panel.smooth
)

# modeling and summarising

# model
fm1 <- lm(log(Volume) ~ log(Girth), data = trees)
fm2 <- update(fm1, ~ . + log(Height), data = trees)
step(fm2)

summary(fm1)
summary(fm2)
