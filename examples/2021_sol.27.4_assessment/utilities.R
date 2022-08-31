# utilities.R - DESC
# /utilities.R

# Copyright Iago MOSQUEIRA (WMR), 2020
# Author: Iago MOSQUEIRA (WMR) <iago.mosqueira@wur.nl>
#
# Distributed under the terms of the EUPL-1.2

library(flextable)

setMethod("as_flextable", signature(x="FLQuant"),
  function(x) {
    
    # CONVERT to year~age data.frame
    df <- as.data.frame(t(x[drop=TRUE]), row.names=FALSE)

    # ADD year column
    ft <- cbind(year=dimnames(x)$year, df)

    # CREATE flextable
    autofit(flextable(ft))

})
