# Load the libraries required
library(dplyr)
library(plotly)

# Build a box plot for average age by categories
build_boxplot <- function (data, given_start, given_end) {
  categories <- c("chemistry", "economics", "literature", "medicine", "peace",
                  "physics")
  extract_age <- function(given_category, given_start, given_end) {
    new_data <- filter(data, category == given_category & 
                       born != "0000-00-00" & year >= given_start & 
                       year <= given_end)
    born_year <- new_data$born
    born_year <- as.numeric(substr(born_year, 1, 4))
    prize_year <- as.numeric(new_data$year)
    age <- prize_year - born_year
    return(age)
  }
  
  physics <- extract_age("physics", given_start, given_end)
  chemistry <- extract_age("chemistry", given_start, given_end)
  economics <- extract_age("economics", given_start, given_end)
  literature <- extract_age("literature", given_start, given_end)
  medicine <- extract_age("medicine", given_start, given_end)
  peace <- extract_age("peace", given_start, given_end)
  
  if (length(economics) == 0) {
    boxplot <- plot_ly(type = "box") %>%
      add_boxplot(y = physics, name = "physics") %>%
      add_boxplot(y = chemistry, name = "chemistry") %>%
      add_boxplot(y = literature, name = "literature") %>%
      add_boxplot(y = medicine, name = "medicine") %>%
      add_boxplot(y = peace, name = "peace") %>%
      layout(title = "Age Distribution by Prize Categories")
  } else {
    boxplot <- plot_ly(type = "box") %>%
      add_boxplot(y = physics, name = "physics") %>%
      add_boxplot(y = chemistry, name = "chemistry") %>%
      add_boxplot(y = economics, name = "economics") %>%
      add_boxplot(y = literature, name = "literature") %>%
      add_boxplot(y = medicine, name = "medicine") %>%
      add_boxplot(y = peace, name = "peace") %>%
      layout(title = "Age Distribution by Prize Categories")
  }
  return(boxplot)
}
