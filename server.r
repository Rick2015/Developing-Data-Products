library(shiny)
library(xlsx)
library(forecast)

cpiU <- read.xlsx("../SeriesReport-20160224001724_bf095b.xlsx", sheetName = "BLS Data Series", startRow = 11, header = TRUE, endRow = 51)
cpiU <- cpiU[-1,] #Remove 1977 row to align with 1978 
cpiUts <- ts(cpiU$Annual, start = c(1978), end = c(2014), frequency = 1) #Time series obj of yearly average
cpiUper <- cpiUts/lag(cpiUts,-1) - 1    #Annual inflation based on CPI-U


shinyServer(
  function(input, output) {
    
    output$sources <- renderPrint({"Data Sources"})
    
    cpiUperm <- meanf(cpiUper, h=86, level = c(80,99), fan = FALSE, lambda = NULL) #86 yr Forecast from mean
    cpiUpern <- naive(cpiUper, h=86, level = c(80,99), fan = FALSE, lambda = NULL) #86 yr Forecast Naive method
    cpiUperd <- rwf(cpiUper, h=86, drift = TRUE, level = c(80,99), fan = FALSE, lambda = NULL)#86 yr Forecast from Random Walk with drift
    
    output$od2 <- renderPrint({input$id2})
    output$od3 <- renderPrint({ 
      as.numeric(input$id3) - 2014 
      })
    output$od4 <- renderPrint({
        p<-input$id1 #Principal
        y<-as.numeric(input$id3) - 2014 #Years
        
      if (input$id2 == "Mean")
        for(i in 1:y) {  p <- as.numeric(p*cpiUperm$upper[i,2]) + p } #Mean Upper 99% compound interest
      if (input$id2 == "Naive")
         for(i in 1:y) {  p <- as.numeric(p*cpiUpern$upper[i,2]) + p } #Naive Upper 99% compound interest
      if (input$id2 == "Random Walk with Drift")
         for(i in 1:y) {  p <- as.numeric(p*cpiUperd$upper[i,2]) + p } #Random Upper 99% compound interest
         
      paste0("$", round(p, digits=2))
      })
    
    output$newPlot <- renderPlot({
        Y<-as.numeric(input$id3) - 2014 #Years
        cpiUm <- meanf(cpiUper, h=Y, level = c(80,99), fan = FALSE, lambda = NULL)
        cpiUn <- naive(cpiUper, h=Y, level = c(80,99), fan = FALSE, lambda = NULL)
        cpiUd <- rwf(cpiUper, h=Y, drift = TRUE, level = c(80,99), fan = FALSE, lambda = NULL)
      
      if (input$id2 == "Mean")
         plot(cpiUm, xlab="Years", ylab="Delta", main = "Inflation Rate Forecast with Mean")
         legend("bottomleft",c("80 confidence level","99 confidence level","mean"),lwd=c(3,3,3), col=c("gray","gray60","blue"))
      
      if (input$id2 == "Naive")
         plot(cpiUn, xlab="Years", ylab="Delta", main = "Inflation Rate Forecast with Naive")
         legend("bottomleft",c("80 confidence level","99 confidence level","mean"),lwd=c(3,3,3), col=c("gray","gray60","blue"))
         
      if (input$id2 == "Random Walk with Drift")
         plot(cpiUd, xlab="Years", ylab="Delta", main = "Inflation Rate Forecast with RWF Drift")
         legend("bottomleft",c("80 confidence level","99 confidence level","mean"),lwd=c(3,3,3), col=c("gray","gray60","blue"))
    })
  } ) 