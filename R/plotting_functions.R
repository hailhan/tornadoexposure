library(tigris)
library(sf)
library(ggplot2)

# takes a geographic boundary (either list of ZCTAs or states) as input
# uses Tigris to return a basemap of those geographic boundaries for the given year
get_basemap <- function(zcta_list, state, year){
  # default to earliest year in tigris
  if (year < 2000) {
    year = 2000
  }

  if (missing(zcta_list)) {
    # default to latest year for state boundaries
    if (year > 2010){
      year = 2010
    }
    boundary <- zctas(state = state, year = year, cb = TRUE)
  }
  if (missing(state)) {
    boundary <- zctas(starts_with = zcta_list, year = year, cb = TRUE)
  }
  return
    ggplot(data = boundary) +
      geom_sf() +
      theme_void()

}

CA <- get_basemap(state="IL", year = 2020)
CA
