library(shiny)
library(ggplot2)

base_uri <- "http://api.nobelprize.org/v1/"

resource_country <- "country.csv"
resource_prize <- "prize.csv"
resource_winner <- "laureate.csv"

country <- read.csv(paste0(base_uri, resource_country), stringsAsFactors = FALSE)
prize <- read.csv(paste0(base_uri, resource_prize), stringsAsFactors = FALSE)
winner <- read.csv(paste0(base_uri, resource_winner), stringsAsFactors = FALSE)

source("scripts/world-map.R")
source("scripts/boxplot.R")
source("scripts/search.R")
# source("scripts/bar-chart.R")

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
  # output$bar <- renderPlot({
  #   
  #   gender <- all_data[[input$gender_bar]]
  #   
  #   bar_plot <- ggplot(data = all_data, aes(x = category)) +
  #     geom_bar()
  #   
  #   bar_plot
  # })
  
  
  
})
