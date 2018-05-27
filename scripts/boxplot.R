# Load the libraries required
library(dplyr)
library(plotly)

# Build a box plot for average age by categories
build_boxplot <- function (data, given_range) {
  categories <- c("chemistry", "economics", "literature", "medicine", "peace",
                  "physics")
  data_in_range <- filter(data, born != "0000-00-00" & year >= given_range[1] & 
                            year <= given_range[2])
  total_born_year <- data_in_range$born
  total_born_year <- as.numeric(substr(total_born_year, 1, 4))
  avg_age <- as.numeric(data_in_range$year) - total_born_year
  extract_age <- function(given_category) {
    new_data <- filter(data_in_range, category == given_category)
    born_year <- new_data$born
    born_year <- as.numeric(substr(born_year, 1, 4))
    prize_year <- as.numeric(new_data$year)
    age <- prize_year - born_year
    return(age)
  }
  
  physics <- extract_age("physics")
  chemistry <- extract_age("chemistry")
  economics <- extract_age("economics")
  literature <- extract_age("literature")
  medicine <- extract_age("medicine")
  peace <- extract_age("peace")
  
  if (length(economics) == 0) {
    boxplot <- plot_ly(type = "box") %>%
      add_boxplot(y = avg_age, name = "total") %>%
      add_boxplot(y = physics, name = "physics") %>%
      add_boxplot(y = chemistry, name = "chemistry") %>%
      add_boxplot(y = literature, name = "literature") %>%
      add_boxplot(y = medicine, name = "medicine") %>%
      add_boxplot(y = peace, name = "peace") %>%
      layout(title = "Age Distribution by Prize Categories",
             margin = list(b = 80),
             xaxis = list(
               title = "Category"
             ),
             yaxis = list(
               autotick = TRUE,
               title = "Age"
             )
      )
  } else {
    boxplot <- plot_ly(type = "box") %>%
      add_boxplot(y = avg_age, name = "total") %>%
      add_boxplot(y = physics, name = "physics") %>%
      add_boxplot(y = chemistry, name = "chemistry") %>%
      add_boxplot(y = literature, name = "literature") %>%
      add_boxplot(y = medicine, name = "medicine") %>%
      add_boxplot(y = peace, name = "peace") %>%
      add_boxplot(y = economics, name = "economics") %>%
      layout(title = "Age Distribution by Prize Categories",
             margin = list(b = 80),
             xaxis = list(
               title = "Category"
             ),
             yaxis = list(
               autotick = TRUE,
               title = "Age"
             )
      )
  }
  return(boxplot)
}

# Test the function out
 data <- 
  read.csv("/Users/YixinXu/Desktop/INFO201/Nobel-Prize-BD1/data/laureate.csv")
 build_boxplot(data, c(1901, 1980))
