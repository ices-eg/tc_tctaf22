# lets set up the TAF project now:
library(icesTAF)

taf.skeleton(".")

# bring in a local file from elsewhere (institute network, shared drive, dropbox)
# -------

# copy file from elsewhere to bootstral initial data folder
cp(
  "D:/projects/work/ices-training/TCTAF22/tc_tctaf22/examples/simple-demo-1/after/bootstrap/data/trees.csv",
  "bootstrap/initial/data/"
)

# document
draft.data(
  data.files = "trees.csv",
  data.scripts = NULL,
  originator = "Ryan, T. A., Joiner, B. L. and Ryan, B. F. (1976) The Minitab Student Handbook. Duxbury Press.",
  title = "Diameter, Height and Volume for Black Cherry Trees",
  file = TRUE,
  append = FALSE # create a new DATA.bib
)

# check bootstrap works as we expect: i.e. copy data from:
# bootstrap initial data -> bootstrap data
taf.bootstrap()


# use a folder of initial data
# ------

# create a data collection (i.e. a folder of related files which will have BIB entry)
mkdir("bootstrap/initial/data/collection/")
cp(
  "D:/projects/work/ices-training/TCTAF22/tc_tctaf22/examples/simple-demo-1/after/bootstrap/initial/data/*",
  "bootstrap/initial/data/collection/"
)

draft.data(
  data.files = "collection",
  data.scripts = NULL,
  originator = "R datasets package",
  title = "Collection of R data",
  source = "folder",
  file = TRUE,
  append = TRUE # use existing DATA.bib
)

taf.bootstrap(software = FALSE)

# bring in an online file: hadley sea surface temperature
# -------

draft.data(
  data.files = "HadSST.4.0.1.0_median.nc",
  data.scripts = NULL,
  originator = "UK MET office",
  title = "Met Office Hadley Centre observations datasets",
  year = 2022,
  source = "https://www.metoffice.gov.uk/hadobs/hadsst4/data/netcdf/HadSST.4.0.1.0_median.nc",
  file = TRUE,
  append = TRUE
)

taf.bootstrap(software = FALSE)

# use an R script to get data
# ----

# for reproducibility purposes - the following code creates the
# file "bootstrap/ices-areas.R" and puts code in it. This is just
# to save you creating a new file and copying and pasting into it.
# However, normally you would create an R script yourself, or copy one
# from another TAF analysis - I am always copying the ices-areas or
# ices-stat square to ices areas lookup shape file script I have.
cat('library(icesTAF)
library(sf)

download(
  "http://gis.ices.dk/shapefiles/ICES_areas.zip"
)

unzip("ICES_areas.zip")
unlink("ICES_areas.zip")

areas <- st_read("ICES_Areas_20160601_cut_dense_3857.shp")

# write as csv
st_write(
  areas, "ices-areas.csv",
  layer_options = "GEOMETRY=AS_WKT"
)

unlink(dir(pattern = "ICES_Areas_20160601_cut_dense_3857"))
',
  file = "bootstrap/ices-areas.R"
)


draft.data(
  data.files = NULL,
  data.scripts = "ices-areas.R",
  originator = "ICES",
  title = "ICES areas",
  file = TRUE,
  append = TRUE
)

taf.bootstrap()

# create the script: bootstrap/file-from-sharepoint.R

# find the directory we want to access
# spdir(site = "/TrainingCourses/TCTAF22/")
# spdir("Exercises", site = "/TrainingCourses/TCTAF22/")

# spgetfile(
#  "Exercises/test.csv",
#  "/TrainingCourses/TCTAF22/",
#  "https://community.ices.dk",
#  "."
# )


# create the entry in DATA.bib
draft.data(
  data.files = NULL,
  data.scripts = "file-from-sharepoint.R",
  originator = "ICES",
  title = "ICES areas",
  access = "Restricted",
  file = TRUE,
  append = TRUE
)

taf.bootstrap()
taf.bootstrap()
taf.bootstrap(taf = TRUE)
