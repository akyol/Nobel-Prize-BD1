library(httr)
library(jsonlite)
library(dplyr)
library(plotly)

base_uri <- "http://api.nobelprize.org/v1/"
resource <- "laureate.csv"

laureate <- read.csv(paste0(base_uri, resource), stringsAsFactors = FALSE)
laureate <- laureate %>% 
  mutate(bornCountryCode = countrycode(bornCountryCode, "iso2c", "iso3c")) %>% 
  filter(bornCountryCode != "NA") %>%
  group_by(bornCountryCode) %>% 
  summarize(bornCountry = first(bornCountry), code = n())

# l <- list(color = toRGB("grey"), width = 0.5)
# 
# # specify map projection/options
# g <- list(
#   showframe = FALSE,
#   showcoastlines = FALSE,
#   projection = list(type = 'Mercator')
# )
# 
# p <- plot_geo(laureate) %>%
#   add_trace(
#     z = ~share, colors = 'Blues',
#     text = ~firstname, locations = ~bornCountryCode,
#     marker = list(line = l)
#   ) %>%
#   # colorbar(title = 'GDP Billions US$', tickprefix = '$') %>%
#   layout(
#     title = "poop",
#     geo = g
#   )

df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv')

# light grey boundaries
l <- list(color = toRGB("grey"), width = 0.5)

# specify map projection/options
g <- list(
  showframe = FALSE,
  showcoastlines = FALSE,
  projection = list(type = 'Mercator')
)

p <- plot_geo(laureate) %>%
  add_trace(
    z = ~code, color = ~code, colors = 'Blues',
    text = ~bornCountry, locations = ~bornCountryCode, marker = list(line = l)
  ) %>%
  colorbar(title = 'Number of Individuals') %>%
  layout(
    title = "Number of Nobel Prize Laureates",
    geo = g
  )

