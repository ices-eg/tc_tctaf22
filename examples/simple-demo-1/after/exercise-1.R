# an example (very simple) analysis
# excercise is to move this into a TAF structure

# load data
data(trees)

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
