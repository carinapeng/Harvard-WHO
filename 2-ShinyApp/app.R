library(EpiEstim)
library(ggplot2)
library(incidence)

library(shiny)

# Define UI for data upload app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Uploading Files"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select a file ----
      fileInput("file1", "Choose CSV File",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      
      # Horizontal line ----
      tags$hr(),
      
      # Input: Checkbox if file has header ----
      checkboxInput("header", "Header", TRUE),
      
      # Input: Select separator ----
      radioButtons("sep", "Separator",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = ","),
      
      # Input: Select quotes ----
      radioButtons("quote", "Quote",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = '"'),
      
      # Horizontal line ----
      tags$hr(),
      
      # Input: Select number of rows to display ----
      radioButtons("disp", "Display",
                   choices = c(Head = "head",
                               All = "all"),
                   selected = "head")
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Data file ----
      tableOutput("contents"),
      tableOutput("contents2")
      
    )
    
  )
)

# Define server logic to read selected file ----
server <- function(input, output) {
    csv <- reactive({
        req(input$file1)
           read.csv(input$file1$datapath,
                 header = input$header,
                 sep = input$sep,
                 quote = input$quote)
    })

    df <- reactive({
        req(input$file1)
        x = csv()
        x[,1]<-as.Date(x[,1], "%d/%m/%Y")
        dfR <- estimate_R(x, method = "parametric_si", config = make_config(list(mean_si = 4.8, std_si = 2.3)))
        return(dfR)
    })

  
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
      if (is.null(csv())) {
          return(NULL)
      }
    
    if(input$disp == "head") {
      return(head(csv()))
    }
    else {
      return(csv())
    }
    
  })
  
  output$contents2 <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
      if (is.null(csv()) || is.null(dfR2()) ) {
          return(NULL)
      }

    Rt <- df()$R
    if(input$disp == "head") {
      return(head(Rt))
    }
    else {
      return(Rt)
    }
      # },
      # error = function(e) {
        # return a safeError if a parsing error occurs
        # stop(safeError(e))
          # return
      # }
    # )
    
  })
    output$contents3 <- renderPlot({

    })
}

# Create Shiny app ----
shinyApp(ui, server)


