library(readr)
library(dplyr)
library(sf)
library(tigris)

load("data/tornado_tracks.rda")
# sanity confirmation of CRS
tornado_tracks <- st_set_crs(tornado_tracks, 4326)
tornado_tracks <- st_transform(tornado_tracks, 3857)

# get Census ZCTA boundary files from Tigris
zctas_2000 <- zctas(year = 2000)
zctas_2010 <- zctas(year = 2010)
zctas_2020 <- zctas(year = 2020)

# split tornado tracks into chunks for each Census file
tornados_2000 <- tornado_tracks %>% filter(yr < 2010)
tornados_2010 <- tornado_tracks %>% filter(yr >= 2010 & yr < 2020)
tornados_2020 <- tornado_tracks %>% filter(yr >= 2020)

# align CRS (tornado_track in ESPG:3857)
zctas_2000 <- st_transform(zctas_2000, 3857)
zctas_2010 <- st_transform(zctas_2010, 3857)
zctas_2020 <- st_transform(zctas_2020, 3857)

# combine each chunked dataset with its associated Census ZCTA boundaries
zt_2000 <- st_join(tornados_2000, zctas_2000)
zt_2010 <- st_join(tornados_2010, zctas_2010)
zt_2020 <- st_join(tornados_2020, zctas_2020)

# attach ZCTA geometry (instead of tornado track)
#zt_2000 <- zt_2000 %>%
#  st_drop_geometry() %>%
#  left_join(
#    zctas_2000 %>% select(ZCTA5CE00, geometry),
#    by = "ZCTA5CE00"
#  ) %>%
#  st_as_sf()
#zt_2010 <- zt_2010 %>%
#  st_drop_geometry() %>%
#  left_join(
#    zctas_2010 %>% select(ZCTA5CE10, geometry),
#    by = "ZCTA5CE10"
#  ) %>%
#  st_as_sf()
#zt_2020 <- zt_2020 %>%
#  st_drop_geometry() %>%
#  left_join(
#    zctas_2020 %>% select(ZCTA5CE20, geometry),
#    by = "ZCTA5CE20"
#  ) %>%
#  st_as_sf()

# bind into a single dataframe
zt <- bind_rows(zt_2000, zt_2010, zt_2020)
zt <- zt %>%
  mutate(
    ZCTA = coalesce(ZCTA5CE00, ZCTA5CE10, ZCTA5CE20)
  )
keep_cols <- c("tornado_id", "date", "yr", "mo", "dy", "mag", "inj", "fat",
               "ZCTA") #, "geometry")
zt <- zt %>%
  select(all_of(keep_cols))

# write to clean data folder
usethis::use_data(zt, overwrite = TRUE)
