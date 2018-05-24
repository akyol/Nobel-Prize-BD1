library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
  output$bar <- renderPlot({
    source("/scripts/bar-chart.R")
    gender <- all_data[[input$gender_bar]]
    
    bar_plot <- ggplot(data = all_data, aes(x = category)) +
      geom_bar()
    
    bar_plot
  })
  
})