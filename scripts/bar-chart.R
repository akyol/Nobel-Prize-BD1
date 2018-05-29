library(httr)
library(dplyr)
library(plotly)

base_uri <- "http://api.nobelprize.org/v1"
prize_resource <- "/prize.csv"
prizes <- read.csv(paste0(base_uri, prize_resource), stringsAsFactors = FALSE)

laureate_resource <- "/laureate.csv"
laureates <- read.csv(paste0(base_uri, laureate_resource), stringsAsFactors = FALSE)

prizes <- select(prizes, id, category, year)
laureates <- select(laureates, id, gender)

all_data <- left_join(prizes,laureates, by = "id") 


build_bar <- function(gender_input, decade_input){
  
  if(gender_input == "na") {
    data_in_range <- filter(all_data, year <= decade_input)
  } else {
    data_in_range <- filter(all_data, gender == gender_input, year <= decade_input)
  }
  
  prize_count <- group_by(data_in_range, category) %>% 
    summarize(
      num = n()
    )
  
  plot_ly(
    x = prize_count$category,
    y = prize_count$num,
    name = "Number of Prizes",
    type = "bar"
  )
}

#build_bar("male", 1950)

