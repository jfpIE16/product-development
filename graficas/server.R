#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$grafica_base_r <- renderPlot({
        plot(mtcars$wt, mtcars$mpg,
             xlab = "Peso del vehiculo",
             ylab = "millas por galon")
    })
    
    output$grafica_ggplot <- renderPlot({
        diamonds %>%
            sample_n(10000) %>%
            ggplot(aes(x=carat,
                       y=price,
                       color=color))+
            geom_point()+
            ylab("Precio")+
            xlab("kilates")+
            ggtitle("Precio de diamantes por kilate")
    })
    
    output$plot_click_options <- renderPlot({
        plot(mtcars$wt, mtcars$mpg,
             xlab = "Peso del vehiculo",
             ylab = "millas por galon")
    })
    
    output$click_data <- renderPrint({
        if(!is.null(input$clk$x)){
            clk_msg <- paste0("click coordenada x= ",
                              round(input$clk$x,2),
                              " click coordenada y= ",
                              round(input$clk$y,2))
            print(clk_msg)
        }
        
        if(!is.null(input$dclk$x)){
            dclk_msg <- paste0("doble click coordenada x= ",
                              round(input$dclk$x,2),
                              " doble click coordenada y= ",
                              round(input$dclk$y,2))
            print(dclk_msg)
        }
        
        if(!is.null(input$mhover$x)){
            mhover_msg <- paste0("Hover coordenada x= ",
                               round(input$mhover$x,2),
                               " Hover coordenada y= ",
                               round(input$mhover$y,2))
            print(mhover_msg)
        }
        
        if(!is.null(input$mbrush$xmin)){
            mbrushx <- paste0('(',
                                 input$mbrush$xmin,
                                 ',',
                                 input$mbrush$xmax,
                                 ')')
            mbrushy <- paste0('(',
                              input$mbrush$ymin,
                              ',',
                              input$mbrush$ymax,
                              ')')
            mbrush_msg <- cat('Rango en x: ',
                              mbrushx,
                              '\n',
                              'Rango en y: ',
                              mbrushy,
                              '\n')
            cat(mbrush_msg)
        }
    })
    
    output$mtcars_tbl <- renderTable({
        mtcars_df <- cbind(carname=row.names(mtcars),
                           mtcars)
        df <- brushedPoints(mtcars_df,
                         input$mbrush,
                         xvar = 'wt',
                         yvar = 'mpg')
        if(nrow(df)!=0){
            df
        }else{
            NULL
        }
    })
    
})
