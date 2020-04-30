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

    dfR2 <- reactive({
        req(input$file1)
        # csv()
        # csv1 <- read.csv(input$file1$datapath,
        #          header = input$header,
        #          sep = input$sep,
        #          quote = input$quote)
        x = csv()
        x[,1]<-as.Date(x[,1], "%d/%m/%Y")
        dfR <- estimate_R(x, method = "parametric_si", config = make_config(list(mean_si = 4.8, std_si = 2.3)))
        return(dfR)
    })

    # if(!file.exists("input$file1$datapath")) {
    #     df = ""
    # }
            # else{    
            #     data=mt[mt$cyl==input$var,] 
            #     write.csv(data,file="c:\\input$var.csv")
            # }

    # tryCatch(
    #   {
    # df <- reactive({
    #     read.csv(input$file1$datapath,
    #              header = input$header,
    #              sep = input$sep,
    #              quote = input$quote)
    # })
    #   error = function(e) {
    #     # return a safeError if a parsing error occurs
    #     stop(safeError(e))
    #   })
  
  output$contents <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    # req(input$file1)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    # tryCatch(
    #   {
    #     df <- read.csv(input$file1$datapath,
    #                    header = input$header,
    #                    sep = input$sep,
    #                    quote = input$quote)
    #   },
    #   error = function(e) {
    #     # return a safeError if a parsing error occurs
    #     stop(safeError(e))
    #   }
    # )
      if (is.null(csv())) {
          return(NULL)
      }
    
      df = csv()
    if(input$disp == "head") {
      return(head(df))
    }
    else {
      return(df)
    }
    
  })
  
  output$contents2 <- renderTable({
    
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    # tryCatch(
    #   {

      if (is.null(csv()) || is.null(dfR2()) ) {
          return(NULL)
      }
        # dfR <- csv()
      # print(dfR)

        
       dfR <- dfR2() 
      print(class(dfR))
        dfR3 <- dfR$R
    if(input$disp == "head") {
      return(head(dfR3))
    }
    else {
      return(dfR3)
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


# load data
# data(Flu2009)

# # explore data and write to file
# head(Flu2009$incidence)
# head(Flu2009$si_data)
# write.csv(Flu2009, "Flu2009.csv")

# ## 1. serial interval (SI) distribution:
# ## interval-ceonsored serial interval data:
# ## each line represents a transmission event, 
# ## EL/ER show the lower/upper bound of the symptoms onset date in the infector
# ## SL/SR show the same for the secondary case
# ## type has entries 0 corresponding to doubly interval-censored data
# ## (see Reich et al. Statist. Med. 2009).

# png("incidents.png")
# plot(as.incidence(Flu2009$incidence$I, dates = Flu2009$incidence$dates))
# dev.off()

# res_parametric_si <- estimate_R(Flu2009$incidence, 
#                                 method="parametric_si",
#                                 config = make_config(list(
#                                   mean_si = 2.6, 
#                                   std_si = 1.5))
# )

# # Explore model
# head(res_parametric_si)
# head(res_parametric_si$R)

# # Write the rate of transmission values
# Rt <- data.frame(res_parametric_si$R)
# write.csv(Rt, "Rt.csv")

# mean(Flu2009$incidence$I)
# sd(Flu2009$incidence$I)

# # Plot
# png("res_parametric_si.png")
# plot(res_parametric_si, legend = FALSE)
# dev.off()

# # use `type = "R"`, `type = "incid"` or `type = "SI"` 
# # to generate only one of the 3 plots

# ## 2. Non-parametric Method
# ## si_distr gives the probability mass function of the serial interval for 
# ## time intervals 0, 1, 2, etc.
# res_non_parametric_si <- estimate_R(Flu2009$incidence, 
#                                     method="non_parametric_si",
#                                     config = make_config(list(
#                                       si_distr = Flu2009$si_distr))
# )
# png("res_nonparametric_si.png")
# plot(res_non_parametric_si, "R")
# dev.off()

# # full distribution of the serial interval using discr_si function (this is how Flu2009$si_distr was obtained, with additional rounding): 
# discr_si(0:20, mu = 2.6, sigma = 1.5)

# mean(Flu2009$incidence$I)
# sd(Flu2009$incidence$I)
# Flu2009$incidence

# ## 3. Sampled distributions for all non-parametric models
# ## we choose to draw:
# ## - the mean of the SI in a Normal(2.6, 1), truncated at 1 and 4.2
# ## - the sd of the SI in a Normal(1.5, 0.5), truncated at 0.5 and 2.5
# config <- make_config(list(mean_si = 2.6, std_mean_si = 1,
#                            min_mean_si = 1, max_mean_si = 4.2,
#                            std_si = 1.5, std_std_si = 0.5,
#                            min_std_si = 0.5, max_std_si = 2.5))
# res_uncertain_si <- estimate_R(Flu2009$incidence,
#                                method = "uncertain_si",
#                                config = config)

# ## plot Model
# ## the third plot now shows all the SI distributions considered
# png("res_nonparametric_si.png")
# plot(res_uncertain_si, legend = FALSE) 
# dev.off()

# # More models
# # See https://rdrr.io/cran/EpiEstim/f/vignettes/demo.Rmd
