library(readr)
library(dplyr)
library(sf)

# manually update csv link for each annual update (version 0.1.1 initialized with 2025 update)
tornados <- read_csv("https://www.spc.noaa.gov/wcm/data/1950-2025_all_tornadoes.csv")

# make tornado id
tornados <- tornados %>%
  mutate(tornado_id = paste(yr, om, sep = "_"))

# drop all storms < EF3
# keeps dataset in safe range for GitHub, retains only storms with health effects
tornados <- tornados %>%
  filter(mag > 2)

# create wkt column from start/end coordinate pairs
tornados <- tornados %>%
  mutate(geometry = sprintf("LINESTRING(%f %f, %f %f)",
                       slon, slat,
                       elon, elat))

# create tornado track linestring geometries from wkt column
tornado_tracks <- st_as_sf(tornados, wkt = "geometry", crs = 3857)

# limit to relevant columns
keep_cols <- c("tornado_id", "date", "yr", "mo", "dy", "mag", "inj", "fat", "geometry")
tornado_tracks <- tornado_tracks %>%
  select(all_of(keep_cols))

# write to clean data folder
usethis::use_data(tornado_tracks, overwrite = TRUE)
