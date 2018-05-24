library(httr)
library(jsonlite)
library(dplyr)
library(ggplot2)

base_uri <- "http://api.nobelprize.org/v1"
prize_resource <- "/prize.csv"
prizes <- read.csv(paste0(base_uri, prize_resource))

laureate_resource <- "/laureate.csv"
laureates <- read.csv(paste0(base_uri, laureate_resource))

prizes <- select(prizes, id, category, year)
laureates <- select(laureates, id, gender)

all_data <- left_join(prizes,laureates, by = "id") 

# IGNORE ALL THIS BELOW FOR NOWWW
prize_types <- as.vector(unique(all_data$category))
  
physics_prizes <- all_data %>% 
  filter(category == "physics")

chemistry_prizes <- all_data %>% 
  filter(category == "chemistry")

medicine_prizes <- all_data %>% 
  filter(category == "medicine")

literature_prizes <- all_data %>% 
  filter(category == "literature")

peace_prizes <- all_data %>% 
  filter(category == "peace")

economics_prizes <- all_data %>% 
  filter(category == "economics")

prize_counts <- c(nrow(physics_prizes), 
                   nrow(chemistry_prizes),
                   nrow(medicine_prizes),
                   nrow(literature_prizes),
                   nrow(peace_prizes),
                   nrow(economics_prizes))

#num_prizes <- data.frame(prize_types, prize_counts)

# IGNORE EVERYTHING ABOVE 

#plot <- ggplot(data = all_data , aes(x = category, fill = gender)) +
 # geom_bar()
#plot
  