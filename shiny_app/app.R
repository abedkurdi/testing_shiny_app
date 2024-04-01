library(shiny)
library(shinydashboard)
library(dplyr)
options(shiny.port = 5539)
options(shiny.host = "0.0.0.0")
#options(shiny.maxRequestSize=50*1024^2)
options(shiny.usecairo=T)

# reference: https://rstudio.github.io/shinydashboard/structure.html

ui <- dashboardPage(
  dashboardHeader(title = "Epidemiology"),
  dashboardSidebar(
    selectInput("bacteria", "Select a Bacteria", choices = c("Acinetobacter baumannii", "Escherichia coli", "Klibsiella pneumoniae")),
    selectInput("filter1", "filter1", choices = c("option1", "option2", "option3")),
    selectInput("filter2", "filter2", choices = c("option1", "option2", "option3")),
    selectInput("filter3", "filter3", choices = c("option1", "option2", "option3"))
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
      box(width = 12, plotOutput("plot", click = "plot_click"),
  verbatimTextOutput("info"))
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

    output$plot <- renderPlot({
    plot(mtcars$wt, mtcars$mpg)
  }, res = 96)

  output$info <- renderPrint({
    req(input$plot_click)
    x <- round(input$plot_click$x, 2)
    y <- round(input$plot_click$y, 2)
    cat("[", x, ", ", y, "]", sep = "")
  })
}

shinyApp(ui, server)


#  shinylive::export(appdir = "shiny_app", destdir = "../testing_shiny_app/docs/")
#  httpuv::runStaticServer("../testing_shiny_app/docs", port=5539
# do not forget to push the code to github