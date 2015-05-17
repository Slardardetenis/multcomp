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

gl <- df.residual(anovo)

MERes <- deviance(anovo)/gl

bonfee <- HSD.test(durabilidade,tapete,gl,MERes, group=TRUE)

contr <- rbind("1 - 2" = c(1, -1, 0, 0),
               "1 - 3" = c(1, 0, -1, 0), 
               "1 - 4" = c(1, 0, 0, -1),
               "2 - 3" = c(0, 1, -1, 0),
               "2 - 4" = c(0, 1, 0, -1),
               "3 - 4" = c(0, 0, 1, -1))

mcScheffe = glht(anovo,linfct=mcp(tapete=contr))

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
            outline = input$outliers,
            col="skyblue",xlab="tratamentos")
  })
  
  formulaVerb <- reactive({
    paste(input$test)
  })
  
  output$caption1 <- renderText({
    formulaVerb()
  })
  
  output$anoverb <-renderPrint({
    if(formulaVerb()=="Tukey"){
      summary(glht(anovo,linfct=mcp(tapete="Tukey")))
    }
    else if(formulaVerb()=="Scheffe"){
      comparison <- scheffe.test(anovo,"tapete", group=T,console=T)  
      }
    else if(formulaVerb()=="Bonferroni"){
      bonfee
    }
  })
  
  output$plotgg <- renderPlot({
    if(formulaVerb()=="Tukey"){
      plot(confint(mcHSD,level=0.95))      
    }
    else if(formulaVerb()=="Scheffe"){
      bar.group(comparison$groups,horiz=T,xlim=c(0,20),
                xlab="média dos tratamentos",
                ylab="tratamentos",main="Grupos",
                density=25,col="green",border="black")
    }
    else if(formulaVerb()=="Bonferroni"){
      bar.group(bonfee$groups,horiz=T,xlim=c(0,20),
                xlab="média dos tratamentos",
                ylab="tratamentos",main="Grupos",
                density=25,col="blue",border="black")
    }
  })
  
  
}