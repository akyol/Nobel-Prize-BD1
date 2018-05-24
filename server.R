library(shiny)
library(ggplot2)

data <- read.csv("/data/laureate.csv")
source("/scripts/boxplot.R")

shinyServer(function(input, output) {
  output$box <- renderPlotly({
    return(build_boxplot(data, input$time_range))
  })
  
  output$bar <- renderPlot({
    source("/scripts/bar-chart.R")
    gender <- all_data[[input$gender_bar]]
    
    bar_plot <- ggplot(data = all_data, aes(x = category)) +
      geom_bar()
    
    bar_plot
  })
  
  
  
})