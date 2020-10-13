
library(shiny)
library(DT)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output) {
    
    file_upload_1 <- reactive({
        if(is.null(input$upload_file_1)){
            return(NULL)
        }
        
        ext<-strsplit(input$upload_file_1$name, split = "[.]")[[1]][2]
        if(ext == 'csv'){
            file_data <- read.csv(input$upload_file_1$datapath)
            return(file_data)
        }
        if(ext == 'tsv'){
            file_data <- read.tsv(input$upload_file_1$datapath)
            return(file_data)
        }
        return(NULL)
    })
    
    output$content_file_1 <- renderTable(
        file_upload_1()
    )
    
    file_upload_2 <- reactive({
        if(is.null(input$upload_file_2)){
            return(NULL)
        }
        
        ext<-strsplit(input$upload_file_2$name, split = "[.]")[[1]][2]
        if(ext == 'csv'){
            file_data <- read.csv(input$upload_file_2$datapath)
            return(file_data)
        }
        if(ext == 'tsv'){
            file_data <- read.tsv(input$upload_file_2$datapath)
            return(file_data)
        }
        return(NULL)
    })
    
    output$content_file_2 <- renderDataTable({
        file_upload_2() %>%
            datatable(filter = "top")
    })
    
    output$tabla1 <- renderDataTable({
        diamonds %>%
            datatable() %>%
            formatCurrency("price") %>%
            formatString(c("x", "y", "z"), suffix = " mm")
    })
    
    output$tabla2 <- renderDataTable({
        mtcars %>%
            datatable(
                options = list(pageLength = 5,
                               lengthMenu = c(5,10,15)),
                filter = "top")
    })
    
    output$tabla3 <- renderDataTable({
        iris %>%
            datatable(
                extensions = "Buttons",
                options = list(dom="Bfrtip",
                               buttons=c("csv"))
                      )
    })

    })
