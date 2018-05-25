library(shiny)
library(ggplot2)

dataset <- read.csv("data/laureate.csv")
#source("scripts/world-map.R")
source("scripts/boxplot.R")
source("scripts/search.R")

base_uri <- "http://api.nobelprize.org/v1/"
resource_prize <- "prize.csv"
resource_winner <- "laureate.csv"
prize <- read.csv(paste0(base_uri, resource_prize))
winner <- read.csv(paste0(base_uri, resource_winner))
# source("scripts/bar-chart.R")

shinyServer(function(input, output) {
  output$search <- renderDataTable({
    return(build_table(prize, winner))
  })
  
  output$box <- renderPlotly({
    return(build_boxplot(dataset, input$time_range))
  })
  
  output$box <- renderPlotly({
    return(build_boxplot(dataset, input$time_range))
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
