library(httr)
library(jsonlite)
library(dplyr)
library(plotly)
library(countrycode)
library(stringr)

source("data/api-key.R")

base_map_uri <- "https://maps.googleapis.com/maps/api/geocode/json"

# pre-computed data on latitude and longitude of Nobel Prize winners
geolocation <- readRDS("data/geolocation.rds")

# helper function that utilizes Google Geolocation API to
# get the latitude and longitude of the given city name
city_area <- function(city_name) {
  query_params <- list(address = city_name, key = api_key)
  response <- GET(base_map_uri, query = query_params)
  body <- fromJSON(content(response, "text"))
  if (body$status == "ZERO_RESULTS") {
    new_text <- gsub(",\\s[A-Z][A-Z]", "", city_name, perl = T)
    query_params <- list(address = new_text, key = api_key)
    response <- GET(base_map_uri, query = query_params)
    body <- fromJSON(content(response, "text"))
  }
  result <- list(
    lat = as.numeric(body$results$geometry$location[1, 1]),
    lng = as.numeric(body$results$geometry$location[1, 2])
  )
  return(result)
}

# main function that creates a plotly map that can be
# manipulated as a choropleth world map or a bubble country map
build_map <- function(dataset, professor_var, gender_var, country_var) {

  # simplify dataset with appropriate city names
  dataset <- dataset %>%
    mutate(bornCity = gsub(".+\\(now\\s|\\)|,\\s[A-Z][A-Z]",
                           "", bornCity, perl = T)) %>%
    replace(. == "&#346;eteniai", "Śeteniai") %>%
    replace(. == "Jhang Maghi&#257;na", "Jhang Maghiāna")
  filter_data <- dataset

  # filter by whether or not you want to sort by professor
  if (professor_var != "na") {
    if (professor_var == "yes") {
      filter_data <- filter_data %>%
        filter(str_detect(name, "University"))
    } else {
      filter_data <- filter_data %>%
        filter(!str_detect(name, "University"))
    }
  }

  # filter by gender
  if (gender_var != "na") {
    filter_data <- filter_data %>%
      filter(gender == gender_var)
  }

  # creates world choropleth map of Nobel Prize winners or country
  # bubble map depending if the user wants to sort by specific country
  # note: professor and gender is still taken into account
  if (country_var == "na") {
    world_data <- filter_data %>%
      mutate(bornCountryCode = countrycode(
        bornCountryCode, "iso2c", "iso3c")) %>%
      filter(bornCountryCode != "NA") %>%
      group_by(bornCountryCode) %>%
      summarize(numb = n())

    all_country <- readRDS("data/countries.rds")
    all_country <- all_country %>%
      full_join(world_data, by = "bornCountryCode") %>%
      replace(is.na(.), 0)

    l <- list(color = toRGB("black"), width = 0.5)
    g <- list(
      showframe = FALSE,
      showcoastlines = FALSE,
      projection = list(type = "Mercator")
    )
    p <- plot_geo(all_country) %>%
      add_trace(
        z = ~ numb, color = ~ numb, colors = "Reds",
        text = ~ bornCountry, locations = ~ bornCountryCode,
        marker = list(line = l)
      ) %>%
      colorbar(title = "Number of Individuals") %>%
      layout(
        title = "Number of Nobel Prize Laureates",
        geo = g
      )
    return(p)
  } else {
    place <- dataset %>%
      filter(bornCity != "") %>%
      group_by(bornCity) %>%
      summarize(bornCountryCode = first(bornCountryCode), numb = n()) %>%
      mutate(bornCountry = countrycode(
        bornCountryCode, "iso2c",
        "country.name"
      ))

    # if the API is updated over the years, this if statement
    # will bring geolocation up to date and store it for future use
    if (nrow(geolocation) < nrow(place)) {
      temp_data <- place %>%
        filter(!(bornCity %in% geolocation$bornCity))
      get_geo <- lapply(paste0(
        temp_data$bornCity, ", ",
        temp_data$bornCountryCode
      ), city_area)
      temp_data <- bind_cols(temp_data, do.call(rbind.data.frame, get_geo))
      geolocation <- rbind(geolocation, temp_data)
      saveRDS(geolocation, "data/geolocation.rds")
    }
    filter_compare <- filter_data %>%
      filter(bornCity != "") %>%
      filter(bornCountryCode == country_var) %>%
      group_by(bornCity) %>%
      summarize(bornCountryCode = first(bornCountryCode), numb = n()) %>%
      mutate(bornCountry = countrycode(
        bornCountryCode, "iso2c",
        "country.name"
      ))

    city_geo <- geolocation %>%
      filter(bornCity %in% filter_compare$bornCity) %>%
      select(lat, lng)
    city_geo <- bind_cols(filter_compare, city_geo)

    if (nrow(city_geo) == 0) {
      return(plotly_empty() %>% layout(title = "Laureate(s) Does Not Exist"))
    } else {
      min_lng <- min(city_geo$lng)
      max_lng <- max(city_geo$lng)

      min_lat <- min(city_geo$lat)
      max_lat <- max(city_geo$lat)

      g <- list(
        scope = "world",
        showland = TRUE,
        landcolor = toRGB("gray95"),
        countrycolor = toRGB("gray80"),
        lonaxis = list(range = c(min_lng - 10, max_lng + 10)),
        lataxis = list(range = c(min_lat - 10, max_lat + 10))
      )

      p <- plot_geo(city_geo, sizes = c(5, 50)) %>%
        add_markers(
          x = ~ lng, y = ~ lat, size = ~ numb, hoverinfo = "text",
          text = ~ paste0(city_geo$bornCity, ", ", city_geo$numb)
        ) %>%
        layout(title = paste("Map of", city_geo$bornCountry), geo = g)
      return(p)
    }
  }
}
