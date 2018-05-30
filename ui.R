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
                      about Nobel Prize winners over the years. Some 
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
                      many are for women? Are the prize winners typically men?
                      </li>
                      <li>What is the age distribution of the prize winners by
                      categories in the given time range?</li><br/>
                      We have extracted relevant data and created interactive 
                      visualizations such as map, 
                      bar graph and boxplot, and tables to answer the above
                      questions.
                      The dataset we use comes from
                      <a href=https://nobelprize.readme.io/>Nobelprize.org</a>
                      We choose to use this API because it provides detailed
                      information about each recipient of these prizes and it
                      is usually updated.")
        )
      )
    )
  ),
  tabPanel(
    "Map",
    titlePanel("Map of Recipients' Birthplaces"),
    fluidRow(
      column(12,
             withBarsUI(plotlyOutput("map"))
             )
    ),
    hr(),
    fluidRow(
      column(4,
             selectInput(
                 "professor",
                 label = "Professor",
                 choices = list(
                   "Yes" = "yes",
                   "No" = "no",
                   "N/A" = "na"
                 ),
                 selected = "na"
               )
             ),
      column(4,
             selectInput(
                 "gender_map",
                 label = "Gender",
                 choices = list(
                   "Male" = "male",
                   "Female" = "female",
                   "N/A" = "na"
                 ),
                 selected = "na"
               )
             ),
      column(4,
             selectInput(
                 "country",
                 label = "Country",
                 choices = filter_country,
                 selected = "na"
               )
             )
      )
    ),
    # sidebarLayout(
    #   sidebarPanel(
    #     selectInput(
    #       "professor",
    #       label = "Professor",
    #       choices = list(
    #         "Yes" = "yes",
    #         "No" = "no",
    #         "N/A" = "na"
    #       ),
    #       selected = "na"
    #     ),
    #     selectInput(
    #       "gender_map",
    #       label = "Gender",
    #       choices = list(
    #         "Male" = "male",
    #         "Female" = "female",
    #         "N/A" = "na"
    #       ),
    #       selected = "na"
    #     ),
    #     selectInput(
    #       "country",
    #       label = "Country",
    #       choices = filter_country,
    #       selected = "na"
    #     )
    #   ),
    #   mainPanel(
    #     withBarsUI(plotlyOutput("map"))
    #   )
    
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
          max = 2017,
          value = 2017,
          step = 10,
          ticks = FALSE
        )
      ),
      mainPanel(
        plotlyOutput("bar"),
        tags$div(
          class = "summary", checked = NA,
          tags$p("These barplots are a display of the Prize Catergory
                  distribution over the decades that the Nobel Prize has
                  has been in existance. The overall data will change when
                  adjusting the decades that the user wants to focus on, and 
                  if they want to change the gender/organization that wins.
                  Earlier in the decades, some of the prizes were not in 
                  existance, so they are not represented by the plot shown.
                  Also, one of the biggest takeaways from this specific graph
                  is the huge difference between number of male and female
                  winners. Overall, males across the board have won at least 100
                  prizes in each catergory, while females are only represented 
                  by a range of 2 to 16 individuals in each of the catergories.
                  Another thing to note is that organizations have only been 
                  been the recipients of the Peace Prize.")
        )
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
                 not changed, throughout the time. For example, the average age
                 of prize winners regardless of prize categories
                 has increased for about 5 years and 
                 the median age of prize winners has increased for about 10 
                 years in each category besides peace/literature. Also, the
                 boxplots allow you to see the outliers easily. The youngest 
                 prize winner is 17 years old, and the oldest prize winner is 
                 90 years old, indicating that it is very unusual to win 
                 Nobel Prize at these ages.")
        )
      )
    )
  )
))
