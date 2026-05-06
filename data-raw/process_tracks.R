library(readr)
library(dplyr)

# manually update csv link for each annual update (version 0.1.1 initialized with 2025 update)
tornados <- read_csv("https://www.spc.noaa.gov/wcm/data/1950-2025_all_tornadoes.csv")

# make tornado id
tornados <- tornados %>%
  mutate(tornado_id = paste(yr, om, sep = "_"))
