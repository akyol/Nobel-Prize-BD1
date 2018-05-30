library(httr)
library(dplyr)
library(stringi)

filterout <- function(prize_dat, winner_dat) {
  all_data <- left_join(prize_dat, winner_dat, by = "id")
  all_data <- all_data[order(all_data$id), ]
  deduped_data <- all_data[!duplicated(all_data$id), ]

  filtered_data <- deduped_data %>% select(
    id, year.x, category.x,
    firstname.x, surname.x,
    gender, born, bornCountry,
    bornCity, died,
    diedCountry, name, motivation.x
  )
  new_col_names <- c(
    "ID", "Year", "Category", "First Name", "Surname",
    "Gender", "Born",
    "Born Country", " Born City", "Died", "Died Country",
    "Organization",
    "Motivation"
  )
  colnames(filtered_data) <- new_col_names
  filtered_data[, "Category"] <- stri_trans_totitle(filtered_data[, "Category"])
  filtered_data$Gender <- toupper(substr( (filtered_data$Gender), 0, 1))

  for (i in 1:ncol(filtered_data)) {
    colname <- new_col_names[i]
    filtered_data[, colname] <- sub(
      "^$", "Not Available",
      filtered_data[, colname]
    )
  }
  filtered_data
}

build_table <- function(prize_dat, winner_dat) {
  dat <- filterout(prize_dat, winner_dat)
}
