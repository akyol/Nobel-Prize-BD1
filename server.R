library(shiny)
library(ggplot2)

dataset <- read.csv("data/laureate.csv")
#source("scripts/world-map.R")
source("scripts/boxplot.R")
source("scripts/search.R")
source("scripts/bar-chart.R")

base_uri <- "http://api.nobelprize.org/v1/"
resource_prize <- "prize.csv"
resource_winner <- "laureate.csv"
prize <- read.csv(paste0(base_uri, resource_prize))
winner <- read.csv(paste0(base_uri, resource_winner))

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
  
    
  output$bar <- renderPlotly({
    return(build_bar(input$gender_bar, input$decade))
  })
  
  
})
