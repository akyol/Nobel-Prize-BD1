library(shiny)
library(dplyr)
library(plotly)

shinyUI(navbarPage(
  theme = "styles.css",
  "Midwest Population",
  tabPanel(
    "Intro",
    titlePanel("Introduction"),
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
            "Organization" = "org",
            "N/A" = "na"
          ),
          selected = "na"
        ),
        selectInput(
          "country",
          label = "Country",
          choices = list(
            "U.S."
          )
        )
      ),
      mainPanel(

      )
    )
  ),
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
            "Organization" = "org",
            "N/A" = "na"
          ),
          selected = "na"
        ),
        selectInput(
          "country",
          label = "Country",
          choices = list(
            "U.S."
          )
        )
      ),
      mainPanel(
        plotlyOutput("map")
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
