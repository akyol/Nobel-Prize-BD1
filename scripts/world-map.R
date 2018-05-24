library(httr)
library(jsonlite)
library(dplyr)
library(plotly)

base_uri <- "http://api.nobelprize.org/v1/"
resource <- "laureate.csv"

laureate <- read.csv(paste0(base_uri, resource), stringsAsFactors = FALSE)

build_map <- function(laureate, professor, gender_var, country_var) {
  if (country_var != "na") {
    if (country_var == "yes") {
      laureate <- laureate %>% 
        filter(str_detect(name, "University"))
    } else {
      laureate <- laureate %>% 
        filter(!str_detect(name, "University"))
    }
  }
  if (gender_var != "na") {
    laureate <- laureate %>% 
      filter(gender == gender_var)
  }
  if (country == "na") {
    world_data <- laureate %>% 
      mutate(bornCountryCode = countrycode(bornCountryCode, "iso2c", "iso3c")) %>% 
      filter(bornCountryCode != "NA") %>%
      group_by(bornCountryCode) %>% 
      summarize(bornCountry = first(bornCountry), numb = n())
    
    l <- list(color = toRGB("grey"), width = 0.5)
    g <- list(
      showframe = FALSE,
      showcoastlines = FALSE,
      projection = list(type = 'Mercator')
    )
    p <- plot_geo(world_data) %>%
      add_trace(
        z = ~numb, color = ~numb, colors = 'Blues',
        text = ~bornCountry, locations = ~bornCountryCode, marker = list(line = l)
      ) %>%
      colorbar(title = 'Number of Individuals') %>%
      layout(
        title = "Number of Nobel Prize Laureates",
        geo = g
      )
  } else {
    place <- laureate %>% 
      filter(bornCountryCode == "JP") %>% 
      select(bornCity) %>% 
      mutate(bornCity = gsub(".+\\(now\\s|\\)", "", bornCity, perl=T)) %>% 
      group_by(bornCity) %>% 
      summarize(numb = n())
    city_area <- function(city, country_id) {  
      res <- GNsearch(name = city, country = country_id, geonamesUsername = "PataTekk") %>% 
        select(lng, lat)
      return(res[1, ])  
    }
    lng_lat <- lapply(place$bornCity, city_area, country_id = "JP")
    place <- bind_cols(place, do.call(rbind.data.frame, lng_lat))
    # g <- list(
    #   scope = 'usa',
    #   projection = list(type = 'albers usa'),
    #   showland = TRUE,
    #   landcolor = toRGB("gray85"),
    #   subunitwidth = 1,
    #   countrywidth = 1,
    #   subunitcolor = toRGB("white"),
    #   countrycolor = toRGB("white")
    # )
    g <- list(
      scope = 'japan',
      showland = TRUE,
      landcolor = toRGB("gray95"),
      countrycolor = toRGB("gray80")
    )
    
    p <- plot_geo(place, sizes = c(1, 250)) %>%
      add_markers(
        x = ~lng, y = ~lat, size = ~numb, color = ~numb, hoverinfo = "text",
        text = "hallo"
      ) %>%
      # add_polygons(line = list(width = 0.4)) %>%
      # add_polygons(
      #   fillcolor = 'transparent',
      #   line = list(color = 'black', width = 0.5),
      #   showlegend = FALSE, hoverinfo = 'none'
      # ) %>% 
      layout(title = '2014 US city populations<br>(Click legend to toggle)', geo = g)
  }
}


     