library(tigris)
library(sf)
library(ggplot2)

# takes a geographic boundary (either list of ZCTAs or states) as input
# uses Tigris to return a basemap of those geographic boundaries for the given year
get_basemap <- function(zcta_list, state, year){

  if (missing(zcta_list)) {
    # default to latest year for state boundaries
    if (year > 2010) {
      year = 2010
    } else if (year < 2000) {
      year = 2000
    } else {
      year = year
    }
    boundary <- zctas(state = state, year = year, cb = FALSE)
  }

  if (missing(state)) {
    # default to earliest year in tigris
    if (year < 2000) {
      year = 2000
    }
    boundary <- zctas(starts_with = zcta_list, year = year, cb = TRUE)
  }

  ggplot(data = boundary) +
      geom_sf(fill = NA, color = "black") +
      theme_void()
}

CA <- get_basemap(state = "IL", year = 2005)
CA
