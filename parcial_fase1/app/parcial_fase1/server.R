#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(RMariaDB)
library(dplyr)
library(DT)


shinyServer(function(input, output, session) {
    mydb <- dbConnect(RMariaDB::MariaDB(),
                      user="test",
                      password="test123",
                      dbname="parcial1",
                      host="172.28.1.1")
    
    output$rawtable1 <- renderPrint({
        orig <- options(width = 500)
        print(tail(dbReadTable(mydb, 
                          "videos"),
                   input$maxrows),
              row.names = TRUE)
        options(orig)
    })
    
    output$rawtable2 <- renderPrint({
        orig <- options(width = 500)
        print(tail(dbReadTable(mydb,
                               "videos_stats"),
                   input$maxrows),
              row.names = TRUE)
        options(orig)
    })
    
    
    output$table1 <- DT::renderDataTable({
        dbGetQuery(mydb,
                   paste("select * from videos_stats where ",
                         toString(input$select)," between ",
                         toString(input$slider[1]), " and ",
                         toString(input$slider[2]), ";"))
    },selection = "single")
    

    
    observe({
        val <- input$select;
        minV <- dbGetQuery(mydb, 
                           paste("select MIN(", 
                                 toString(val),
                                 ") FROM videos_stats;"))[[1]][1]
        maxV <- dbGetQuery(mydb, 
                           paste("select MAX(", 
                                 toString(val),") 
                                 FROM videos_stats;"))[[1]][1]
        
        updateSliderInput(session, "slider",
                          min = minV,
                          max = maxV,
                          step = floor(maxV/10),
                          value = c(minV, maxV))
    })
    
})
