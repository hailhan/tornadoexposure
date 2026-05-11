library(tigris)
library(sf)
library(ggplot2)

# takes a geographic boundary (list of ZCTAs) as input
# uses Tigris to return a basemap of those geographic boundaries for the given year
get_basemap <- function(zcta_list, year){

  # default to closest year in tigris
  valid_years <- c(2000, 2010, 2020)
  year <- max(valid_years[valid_years <= year])

  boundary <- zctas(
    starts_with = as.character(zcta_list),
    year = year,
    cb = TRUE)

  ggplot(data = boundary) +
      geom_sf(fill = NA, color = "black") +
      theme_void()
}

# works with any length of ZCTA provided (eg. 6, 603, 60304)
IL <- get_basemap(zcta_list = c(60304), year = 2005)
IL
