# Curso: Product Development
# Tarea No.1
# Jose Fernando Perez Perez
# Universidad Galileo

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$slider1_output <- renderText({
        paste0( c("Output slider input: ", input$slider1),
                collapse = '')
    })
    
    output$slider2_output <- renderText({
        input$slider2
    })
    
    output$select1_output <- renderText({
        input$select1
    })
    
    output$select2_output <- renderText({
        paste0( c("Selecciones del UI: ", input$select2,
                  collapset = ''))
    })
    
    output$date1_output <- renderText({
        as.character(input$date1)
    })
    
    output$date2_output <- renderText({
        as.character(input$date2)
    })
    
    output$numeric_output <- renderText({
        input$numeric
    })
    
    output$checkbox_output <- renderText({
        input$checkbox
    })
    
    output$groupbox_output <- renderText({
        input$group_box
    })
    
    output$radio_output <- renderText({
        input$radiobtn
    })
    
    output$text_output <- renderText({
        input$text
    })
    
    output$textarea_output <- renderText({
        input$textarea
    })
    
    output$password_output <- renderText({
        input$password
    })
    
    output$actionbtn_output <- renderText({
        input$action_button
    })
    
    output$actionlink_output <- renderText({
        input$action_link
    })
})
