## ui.R ##
library(shiny)
library(shinydashboard)


ui <- dashboardPage( skin = "purple",
  
  dashboardHeader(title="Multiple Comparisons",
                  dropdownMenu(type = "messages",icon = icon("question"),
                               messageItem(
                                 from = "Any questions?",
                                 message = "do not forget to check out my code."
                                 
                                 
                                          )
                             
                              )
                  ),
  
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("dados", tabName = "dados", icon = icon("database")),
      menuItem("Anova", tabName = "widgets", icon = icon("th")),
      menuItem("Box-Plot", tabName="comp", icon=icon("area-chart")),
      menuItem("Comparações Múltiplas", tabName = "dashboard", icon = icon("bar-chart"))
            
      )
      ),
  
  
  dashboardBody(
    tabItems(
      #first tab content
      tabItem(tabName = "dashboard",
      fluidRow(
                selectInput("test",h2("Teste:"),
                              list("Tukey"="Tukey",
                                    "Scheffe"="Scheffe",
                                    "Bonferroni"="Bonferroni"
                                   )
                            ),
                h3(textOutput("caption1")),
                verbatimTextOutput("anoverb"),
                plotOutput("plotgg")
                #verbatimTextOutput("group")
              )
            ),
      tabItem(tabName = "widgets",
                h2("Anova"),
                verbatimTextOutput("anova"),h2("Vemos que o p-valor é menor do que 5%. Portanto rejeitamos a hipótese nula")
              ),
      tabItem(tabName = "dados", h2("Temos abaixo os dados"),
              dataTableOutput("dados")
              ),
      tabItem(tabName = "comp", h2("Box-Plot"),
                selectInput("variable","Variável:",
                              list("Tapete"= "tapete",
                                    "composição" = "composicao"
                                   )
                            ),
                checkboxInput("outliers", "Mostrar Outliers", FALSE),
                h3(textOutput("caption")),
                plotOutput("mpgPlot", width = 1000)
              )
        ),
    fluidRow(
      # A static box
      infoBox(icon = icon("beer"),
              tags$a(href="https://github.com/Slardardetenis", "Made by Giovani (Slardar de tenis)")
              )
      
    )
      )
  
  
    )
  
  

