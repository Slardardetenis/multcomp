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
      menuItem("vapo", tabName = "dashboard", icon = icon("bar-chart")),
      menuItem("comparações Multiplas", tabName="comp", icon=icon("area-chart"))
            
      )
      ),
  
  
  dashboardBody(
    tabItems(
      #first tab content
      tabItem(tabName = "dashboard",
      fluidRow(
        box(plotOutput("plot1", height = 300)),
      
        box(
          title = "Controles",
          sliderInput("slider", "Number of observations", 1, 16, 8)
          )  
            )
          ),
      tabItem(tabName = "widgets",
                h2("Anova"),
                verbatimTextOutput("anova"),h2("Vemos que o p-valor é menor do que 5%. Portanto rejeitamos a hipótese nula")
              ),
      tabItem(tabName = "dados", h2("Temos abaixo os dados"),
              dataTableOutput("dados")
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
  
  

