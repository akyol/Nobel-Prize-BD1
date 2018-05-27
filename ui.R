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
        tags$h5(id = "text", HTML("Our project focuses on analyzing data
                      about Nobel Prize winners over the years. Some of the 
                      target audiences who might look at the visualizations 
                      we create could be current scholars who are curious about
                      the qualities of a winner of a prize, or promoters of
                      political justice worldwide.<br/><br/>
                      Questions that we would like to inform our audience based
                      on this project are:<br/>
                      <li>What are the countries that are represented by the
                      prize winners?</li>
                      <li>What is the number of prizes awarded for each category
                      , and among them, how many are awarded for men and how 
                      many are for women?</li>
                      <li>What is the age distribution of the prize winners by
                      categories and the given time range?</li><br/>
                      We have extracted relevant data and created interactive 
                      visualizations such as map, 
                      bar graph and boxplot, and tables to answer the above
                      questions.
                      The dataset we use comes from
                      <a href=https://nobelprize.readme.io/>Nobelprize.org</a>
                      We choose to use this API because it provides detailed
                      information about each recipient of these prizes.")
        )
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
          max = 2017,
          value = 2017,
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
        plotlyOutput("box"),
        tags$div(
          class = "summary", checked = NA,
          tags$p("The boxplots illustrate the age distribution of Nobel Prize
                 winners in total and by categories. The data being displayed
                 change when the range of year selected changes so that
                 you can see how the age distribution has changed, or has
                 not changed, throughout the time. ")
        )
      )
    )
  )
))
