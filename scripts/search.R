library(httr)
library(jsonlite)
library(dplyr)

base_uri <- "http://api.nobelprize.org/v1/"
resource_prize <- "prize.csv"
resource_winner <- "laureate.csv"
prize_dat <- read.csv(paste0(base_uri, resource_prize))
winner_dat <- read.csv(paste0(base_uri, resource_winner))

all_data <- left_join(prize_dat, winner_dat, by = "id")
all_data <- all_data[order(all_data$id),]
deduped_data <- all_data[!duplicated(all_data$id),]

filtered_data <-  deduped_data %>% select(id, year.x, category.x, firstname.x, surname.x,
                                          gender, motivation.x, share.x, born, bornCountry, 
                                          bornCity, died, diedCountry, name, city, country)
new_col_names <- 
col_names <- colnames(filtered_data)

for (i in 1:ncol(filtered_data)) {
  colname <- col_names[i]
  filtered_data[, colname] <- sub("^$", "Not Available", filtered_data[, colname])
}

build_table <- function(dat, input) {
  filtered <- data.frame(which(dat == input, arr.ind=TRUE))
  location <- filtered[!duplicated(filtered$row),]
  result <- dat[location$row, ]
  
}

location <- build_table(filtered_data, "France")
