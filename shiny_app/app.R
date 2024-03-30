library(shiny)
library(shinydashboard)
library(dplyr)
options(shiny.port = 5539)
options(shiny.host = "0.0.0.0")
options(shiny.maxRequestSize=50*1024^2)
options(shiny.usecairo=T)

# reference: https://rstudio.github.io/shinydashboard/structure.html

ui <- dashboardPage(
  dashboardHeader(title = "Epidemiology"),
  dashboardSidebar(
    selectInput("bacteria", "Select a Bacteria", choices = c("Acinetobacter baumannii", "Escherichia coli", "Klibsiella pneumoniae"))
  ),
  dashboardBody(
    fluidRow(
        box(width=12,
        # A static valueBox
      valueBox(100, "genomes", width=6, color="aqua"),
      valueBox(100, "genotypes", width=6, color="aqua"),

      # Dynamic valueBoxes
      #valueBoxOutput("progressBox", width=6),
      )
      
    ),
    fluidRow(
      # Clicking this will increment the progress amount
      #box(width = 12, img(src='52552714836_437109e83c_o.jpg', width=1570, height=800))
      
    ),

    fluidRow(
      # Clicking this will increment the progress amount
      box(width = 12, actionButton("count", "Increment progress"))
    )
  )
)

server <- function(input, output) {
  output$progressBox <- renderValueBox({
    valueBox(
      paste0(25 + input$count, "%"), "Progress", icon = icon("list"),
      color = "purple"
    )
  })
}

shinyApp(ui, server)
