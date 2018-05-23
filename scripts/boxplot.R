# Load the libraries required
library(dplyr)
library(plotly)

data <- read.csv("/Users/YixinXu/Desktop/INFO201/Nobel-Prize-BD1/data/laureate.csv",
                 stringsAsFactors = FALSE)

# Build a box plot for average age by categories
categories <- c("chemistry", "economics", "literature", "medicine", "peace",
                "physics")
extract_age <- function(given_category) {
  new_data <- filter(data, category == given_category & 
                     born != "0000-00-00")
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

boxplot <- plot_ly(type = "box") %>%
  add_boxplot(y = physics, name = "physics") %>%
  add_boxplot(y = chemistry, name = "chemistry") %>%
  add_boxplot(y = economics, name = "economics") %>%
  add_boxplot(y = literature, name = "literature") %>%
  add_boxplot(y = medicine, name = "medicine") %>%
  add_boxplot(y = peace, name = "peace") %>%
  layout(title = "Age Distribution by Prize Categories")
boxplot
