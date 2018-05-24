library(httr)
library(jsonlite)
library(dplyr)

base_uri <- "http://api.nobelprize.org/v1"
prize_resource <- "/prize.csv"
prizes <- read.csv(paste0(base_uri, prize_resource))

laureate_resource <- "/laureate.csv"
laureates <- read.csv(paste0(base_uri, laureate_resource))

prizes <- select(prizes, id, category)
laureates <- select(laureates, id, gender)

all_data <- left_join(prizes,laureates, by = "id") 