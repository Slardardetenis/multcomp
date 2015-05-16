## app.R ##
library(shiny)
library(datasets)
dataset <- read.csv("/home/giovani/Área de Trabalho/carpet.csv",h=T,
                    col.names = c("durabilidade","tapete","composicao"))
attach(dataset)
dataset$tapete <- as.factor(dataset$tapete)
dataset$composicao <- as.factor(dataset$composicao)

anovi <- aov(durabilidade~composicao, data=dataset)

anovo <- aov(durabilidade~tapete, data=dataset)

servrer <- function(input,output){
  #set.seed(122)
  histdata <- dataset$durabilidade
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  
  output$dados <- renderDataTable({dataset})
  
  output$anova <- renderPrint({
    summary(anovo)
  })
  
  formulaText <- reactive({
    paste("durabilidade~",input$variable)
  })
  
  # Return the formula text for printing as a caption
  output$caption <- renderText({
    formulaText()
  })
  
  # Generate a plot of the requested variable against durabilidade and only
  # include outliers if requested
  
  output$mpgPlot <- renderPlot({
    boxplot(as.formula(formulaText()),
          data = dataset,
          outline = input$outliers)
  })
}