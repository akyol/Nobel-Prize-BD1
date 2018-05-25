library(shiny)
library(dplyr)
library(plotly)


shinyUI(navbarPage(
  theme = "styles.css",
  "Nobel Prize",
  tabPanel(
    "Introduction",
    fluidRow(
      column(12,
             tags$img(id = "responsive-img", src = "background.jpg")
      ),
      fluidRow(
        tags$h3("")
      ),

      fluidRow(
        tags$h3(id = "into", "Introduction")
      ),
      br(),
      fluidRow(
        tags$h5(id = "text", "Our project will be focused on analyzing data about Nobel Prize winners over the years. Some of the target audiences who might look at the visualizations we create could be current scholars who are curious about the qualities of a winner of a prize, or promoters of political justice worldwide.
                      Questions that we would like to inform our audience based on this project are:
                      The countries that are represented by the winners
                      Which professors from US universities won Nobel prizes
                      The number of prizes awarded for each category
                      The percentage breakdown of how the awards are split
                      People who passed away before being able to receive their prize
                      We plan to create interactive map visualizations, tables, and charts in order to summarize the relevant data to answer these questions.
                      The dataset we will be utilizing will be the NobelPrize API, because it details a lot of specific information about each recipient of these prizes. This API was created by Nobelprize.org, the Official Website of the Nobel Prize.")
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
            "N/A" = "na"
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
          value = 2010,
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
