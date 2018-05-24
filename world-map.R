library(httr)
library(jsonlite)
library(dplyr)
library(plotly)

base_uri <- "http://api.nobelprize.org/v1/"
resource <- "laureate.csv"

laureate <- read.csv(paste0(base_uri, resource), stringsAsFactors = FALSE)

l <- list(color = toRGB("grey"), width = 0.5)

# specify map projection/options
g <- list(
  showframe = FALSE,
  showcoastlines = FALSE,
  projection = list(type = 'Mercator')
)

p <- plot_geo(laureate) %>%
  add_trace(
    colors = 'Blues',
    text = ~firstname, locations = ~bornCountryCode
  ) %>%
  # colorbar(title = 'GDP Billions US$', tickprefix = '$') %>%
  layout(
    title = "poop",
    geo = g
  )
