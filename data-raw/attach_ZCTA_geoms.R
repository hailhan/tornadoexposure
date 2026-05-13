library(readr)
library(dplyr)
library(sf)
library(tigris)

load("data/tornado_tracks.rda")

# get Census ZCTA boundary files from Tigris
zctas_2000 <- zctas(year = 2000)
zctas_2010 <- zctas(year = 2010)
zctas_2020 <- zctas(year = 2020)

# split tornado tracks into chunks for each Census file
tornados_2000 <- tornado_tracks %>% filter(yr < 2010)
tornados_2010 <- tornado_tracks %>% filter(yr < 2020)
tornados_2020 <- tornado_tracks %>% filter(yr >= 2020)

# align CRS (tornado_track in ESPG:3857)
zctas_2000 <- st_transform(zctas_2000, 3857)
zctas_2010 <- st_transform(zctas_2010, 3857)
zctas_2020 <- st_transform(zctas_2020, 3857)

zt_2000 <- st_join(tornados_2000, zctas_2000)
