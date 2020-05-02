library(shiny)
setwd("1-EpiEstim")
# Define UI for app that draws a histogram ----
  ui <- fluidPage(
    
    # App title ----
    titlePanel("Histogram of Flu 2009 Data"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
      
      # Sidebar panel for inputs ----
      sidebarPanel(
        
        fileInput("file", h3("File input")),
        
        # Input: Slider for the number of bins ----
        sliderInput(inputId = "bins",
                    label = h3("Number of bins:"),
                    min = 1,
                    max = 31,
                    value = 15),
        
        dateRangeInput("dates", h3("Date range"), start = '2009-04-27', end = '2009-05-28', min = '2009-04-27', max = '2009-05-28', format = "yyyy-mm-dd")
        
      ),
      
      # Main panel for displaying outputs ----
      mainPanel(
        
        # Output: Histogram ----
        plotOutput(outputId = "distPlot")
        
      )
    )
  )

  # Define server logic required to draw a histogram ----
  server <- function(input, output) {
    
    output$distPlot <- renderPlot({
      
      req(input$file)
      
      df <- read.csv(input$file$datapath,
                     header = FALSE)
      # df$dates <- as.Date(df$dates, format="%Y-%m-%d")
      View(df)
      a <- as.Date(input$dates)
      View(a)
      # Find the row indices within the selected date range
      # selectedInd <- df$dates[a[1]:a[2]]
      # dfnew <- df[selectedInd]
      # View(dfnew)
      
      selectedInd <- which[df$V2==a[1]]:which[df$V2==a[2]]
      View(selectedInd)
      # Use the row indices to filter out the station codes
      x <- as.numeric(df$I[selectedInd])
      bins <- seq(0, length.out = input$bins + 1)
      # as.numeric above is not necessary if the start_station_code column is already in integer format
      hist(x, breaks = bins, col = "#75AADB", border = "white",
           xlab = "Number of people with 2009 flu on given day from start date",
           main = "Histogram of infected individuals with 2009 flu")
    })
    
  }
  
  
  shinyApp(ui = ui, server = server)
  
# citing Shiny demos and https://stackoverflow.com/questions/47080812/shinyapp-how-to-call-a-column-in-a-csv-file-which-matches-user-inputs-and-to-sh
