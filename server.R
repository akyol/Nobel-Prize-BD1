library(shiny)
library(ggplot2)

source("scripts/world-map.R")
source("scripts/boxplot.R")
source("scripts/search.R")
source("scripts/bar-chart.R")

base_uri <- "http://api.nobelprize.org/v1/"

resource_country <- "country.csv"
resource_prize <- "prize.csv"
resource_winner <- "laureate.csv"

country <- read.csv(paste0(base_uri, resource_country),
  stringsAsFactors = FALSE
)
prize <- read.csv(paste0(base_uri, resource_prize), stringsAsFactors = FALSE)
winner <- read.csv(paste0(base_uri, resource_winner), stringsAsFactors = FALSE)

shinyServer(function(input, output) {
  withBars(output$map <- renderPlotly({
    return(build_map(winner, input$professor, input$gender_map, input$country))
  }))

  output$search <- renderDataTable({
    return(build_table(prize, winner))
  })

  output$box <- renderPlotly({
    return(build_boxplot(winner, input$time_range))
  })


  output$bar <- renderPlotly({
    return(build_bar(input$gender_bar, input$decade))
  })
})
