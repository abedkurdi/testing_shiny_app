library(shiny)
library(shinydashboard)
library(dplyr)
options(shiny.port = 5539)
options(shiny.host = "0.0.0.0")
#options(shiny.maxRequestSize=50*1024^2)
options(shiny.usecairo=T)
library(ggiraph)
library(ggplot2)

# reference: https://rstudio.github.io/shinydashboard/structure.html
data <- read.csv("https://raw.githubusercontent.com/abedkurdi/testing_shiny_app/master/docs/sal_analysis.csv", sep='\t', stringsAsFactors=FALSE, header=TRUE)
unique(data$Serovar)
data$Serovar <- gsub("\\s","",data$Serovar)


ui <- dashboardPage(
  dashboardHeader(title = "TEST"),
  dashboardSidebar(
    selectInput("bacteria", "Select a Bacteria", choices = c("Acinetobacter baumannii", "Escherichia coli", "Klebsiella pneumoniae")),
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
      box(width = 6, ggiraphOutput("plot")),
      box(width = 6, ggiraphOutput("plot1"))
    ),
    
    fluidRow(
      # Clicking this will increment the progress amount
      box(width = 6, ggiraphOutput("plot2")),
      box(width = 6, ggiraphOutput("plot3"))
    )
    #fluidRow(
    #  # Clicking this will increment the progress amount
    #  box(width = 12, actionButton("count", "Increment progress"))
    #)
  )
)

server <- function(input, output) {
  output$progressBox <- renderValueBox({
    valueBox(
      paste0(25 + input$count, "%"), "Progress", icon = icon("list"),
      color = "purple"
    )
  })

    output$plot <- renderggiraph({
      p <- ggplot(data, aes(x=ST, fill=Serovar))+geom_bar_interactive(aes(tooltip = Serovar), position=position_dodge2(width=0.5, preserve="single"))+ theme_minimal()+theme(axis.text.x = element_text(angle = 45, hjust=1, size=8.5), legend.position="none")
      #x <- girafe(ggobj = p, width_svg = 10, height_svg = 5) %>% girafe_options(opts_hover(css = "color:cyan;"))
      ggiraph(code = print(p))    
  })

  output$plot1 <- renderggiraph({
    p1 <- ggplot(data, aes(x=Year, fill=Serovar))+geom_bar_interactive(aes(tooltip = Serovar), position=position_dodge2(width=0.5, preserve="single"))+ theme_minimal()+theme(axis.text.x = element_text(angle = 45, hjust=1, size=8.5), legend.position="none")
      #x <- girafe(ggobj = p, width_svg = 10, height_svg = 5) %>% girafe_options(opts_hover(css = "color:cyan;"))
      ggiraph(code = print(p1))
  })

  output$plot2 <- renderggiraph({
    p1 <- ggplot(data, aes(x=Meropenem..R..19., fill=Serovar))+geom_bar_interactive(aes(tooltip = Serovar), position=position_dodge2(width=0.5, preserve="single"))+ theme_minimal()+theme(axis.text.x = element_text(angle = 45, hjust=1, size=8.5), legend.position="none")
      #x <- girafe(ggobj = p, width_svg = 10, height_svg = 5) %>% girafe_options(opts_hover(css = "color:cyan;"))
      ggiraph(code = print(p1))
  })

  output$plot3 <- renderggiraph({
    p1 <- ggplot(data, aes(x=Gentamicin..R..12., fill=Serovar))+geom_bar_interactive(aes(tooltip = Serovar), position=position_dodge2(width=0.5, preserve="single"))+ theme_minimal()+theme(axis.text.x = element_text(angle = 45, hjust=1, size=8.5), legend.position="none")
      #x <- girafe(ggobj = p, width_svg = 10, height_svg = 5) %>% girafe_options(opts_hover(css = "color:cyan;"))
      ggiraph(code = print(p1))
  })

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