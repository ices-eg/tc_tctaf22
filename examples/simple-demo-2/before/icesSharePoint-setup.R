# install.packages('icesSharePoint', repos = 'https://ices-tools-prod.r-universe.dev')
library(icesSharePoint)

# set ices username - note it will not be 'colin' for you ;)
options(icesSharePoint.username = "colin")
options("icesSharePoint.username")

# first call to anything will ask for a password,
# there after it will be stored in a secrets store that only you
# have access to.  however be carefull because if someone gains
# access to your computer your password will be accessible via:
keyring::key_get("icesSharePoint", "colin") # beware!! this will print your password to the screen

# you need to be logged into your machine as you to read this, but
# if someone somehow wrote a dodgy script, they could programatically
# access your password.... I am going to try and solve this, but I need
# to think about it more.
# You can clear the password at the end of the session with this:
icesSharePoint:::SP_clearpassword() # which just calls
keyring::key_delete("icesSharePoint", "colin")
# this would seems to be the safest approach for now, and I will try
# hard code the clearing of the password fromt he secret store

# OK back to the work :)


# find the directory we want to access
spdir(site = "/TrainingCourses/TCTAF22/")
spdir("Exercises", site = "/TrainingCourses/TCTAF22/")

spgetfile(
  "Exercises/test.csv",
  "/TrainingCourses/TCTAF22/",
  "https://community.ices.dk",
  "."
)

unlink("test.csv")
