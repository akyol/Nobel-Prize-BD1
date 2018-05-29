library(shiny)
library(dplyr)
library(plotly)
library(plotlyBars)
library(countrycode)

base_uri <- "http://api.nobelprize.org/v1/"
resource_winner <- "laureate.csv"
winner <- read.csv(paste0(base_uri, resource_winner), stringsAsFactors = FALSE)

filter_country <- winner %>% 
  distinct(bornCountryCode) %>% 
  mutate(bornCountry = countrycode(bornCountryCode, "iso2c", "country.name")) %>% 
  filter(bornCountry != "NA")
filter_country <- setNames(as.list(as.character(filter_country$bornCountryCode)), filter_country$bornCountry)
filter_country$"N/A" <- "na"

shinyUI(navbarPage(
  theme = "styles.css",
  "Midwest Population",
  tabPanel(
    "Map",
    titlePanel("Map of Recipients' Birthplaces"),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          "professor",
          label = "Professor",
          choices = list(
            "Yes" = "yes",
            "No" = "no",
            "N/A" = "na"
          ),
          selected = "na"
        ),
        selectInput(
          "gender_map",
          label = "Gender",
          choices = list(
            "Male" = "male",
            "Female" = "female",
            "N/A" = "na"
          ),
          selected = "na"
        ),
        selectInput(
          "country",
          label = "Country",
          choices = filter_country,
          selected = "na"
        )
      ),
      mainPanel(
        withBarsUI(plotlyOutput("map"))
      )
    )
  ),
  tabPanel(
    "Search",
    titlePanel("Search"),
    fluidRow(
      column(12,
             dataTableOutput("search")
      )
    )
  ),
  tabPanel(
    "Bar",
    titlePanel("Number of Prizes Per Each Category"),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          "gender_bar",
          label = "Gender",
          choices = list(
            "Male" = "male",
            "Female" = "female",
            "Organization" = "org",
            "N/A" = "na"
          ),
          selected = "na"
        ),
        sliderInput(
          "decade",
          label = "Decade",
          min = 1900,
          max = 2010,
          value = 1900,
          step = 10,
          ticks = FALSE
        )
      ),
      mainPanel(
        plotlyOutput("bar")
      )
    )
  ),
  tabPanel(
    "Box",
    titlePanel("Average Age of Recipients"),
    sidebarLayout(
      sidebarPanel(
        sliderInput(
          "time_range", 
          label = "Time Range",
          min = 1901,
          max = 2018,
          value = c(1901, 2018),
          ticks = FALSE
        )
      ),
      mainPanel(
        plotlyOutput("box")
      )
    )
  )
))
