## app.R ##
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
  
}