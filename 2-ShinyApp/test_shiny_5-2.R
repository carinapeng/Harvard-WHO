ui <- fluidPage(
  titlePanel("Plot of a Parametric Model for Transmission Rates"),
  
  sidebarLayout(
    sidebarPanel("This is constructed from a serial interval (SI) distribution using interval-censored serial interval data
                 where each line represents a transmission event"),
    mainPanel("Plot", 
              plotOutput("myPlot", height = 300)
    )
  )
)

# Define server logic ----
server <- function(input, output) {
  output$myPlot <- renderPlot({
    plot(res_parametric_si, legend = FALSE)
})}

# Run the app ----
shinyApp(ui = ui, server = server)