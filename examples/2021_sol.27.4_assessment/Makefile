

all: data model output report

.PHONY: all

data.R:
	R -e "source('data.R')"

data: data.R

model.R:
	R -e "source('model.R')"

data: model.R
