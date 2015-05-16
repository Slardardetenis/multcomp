## app.R ##
library(shiny)
library(datasets)
library(agricolae)
library(multcomp)

dataset <- read.csv("/home/giovani/Área de Trabalho/carpet.csv",h=T,
                    col.names = c("durabilidade","tapete","composicao"))
attach(dataset)
dataset$tapete <- as.factor(dataset$tapete)
dataset$composicao <- as.factor(dataset$composicao)

anovi <- aov(durabilidade~composicao, data=dataset)

anovo <- aov(durabilidade~tapete, data=dataset)

mcHSD <- glht(anovo,linfct=mcp(tapete="Tukey"))


servrer <- function(input,output){
  
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
  
  formulaVerb <- reactive({
    paste(input$test)
  })
  
  output$caption1 <- renderText({
    formulaVerb()
  })
  
  output$anoverb <-renderPrint({
    summary(glht(anovo,linfct=mcp(tapete=formulaVerb())))
  })
   
  output$plotgg <- renderPlot({
    plot(confint(glht(anovo,linfct=mcp(tapete=formulaVerb())),level=0.95))
  })
  
#   output$group <- renderPrint({
#     summary()
#   })
}