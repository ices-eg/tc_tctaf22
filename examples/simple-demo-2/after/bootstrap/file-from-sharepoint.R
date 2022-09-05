
library(icesSharePoint)

spdir(site = "/TrainingCourses/TCTAF22/")
spdir("Exercises", site = "/TrainingCourses/TCTAF22/")

spgetfile(
  "Exercises/test.csv",
  "/TrainingCourses/TCTAF22/",
  "https://community.ices.dk",
  "."
)
