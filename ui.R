library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Predict Inflation"),
  sidebarPanel(
     h3('Parameters'),
     numericInput('id1', '2014 U.S. Dollar Input $', 1, min = 1, max = 100000, step = 1),
     selectInput('id2', 'Choose Forecast Method', c("Mean", "Naive", "Random Walk with Drift")),
     selectInput('id3', 'Select Year', 2017:2100 ),
     submitButton('Run Prediction'),
     h3(''),
     h5('Data Source:'), 
     h6('Consumer Price Index (CPI-U) 1977-2014'),
     h6('U.S.Bureau of Labor Statistics (BLS)'),
     h6('http://www.bls.gov/cpi/'),
     h3(''),
     h5('Code Repository:'),
     h6('https://github.com/Rick2015/Developing-Data-Products')
  ),
  mainPanel(
    h3('Results for Upper Inflation Only!'),
    h4('Forecast Method'), verbatimTextOutput("od2"),
    h4('Using compounding interest, dollar input inflated to'), verbatimTextOutput("od4"),
    h4('Years since 2014'), verbatimTextOutput("od3"),
    plotOutput('newPlot')
  )
))