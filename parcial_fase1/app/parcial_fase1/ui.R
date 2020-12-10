library(shiny)

shinyUI(
    fluidPage(
        
        titlePanel("Parcial Fase 1 -- 20000756"),
        tabsetPanel(
            tabPanel("Raw Data",
                     numericInput("maxrows", "Filas a mostrar", 5),
                     fluidRow(
                         column(
                             width=12,
                             h2("Descripción Videos"),
                             verbatimTextOutput("rawtable1")
                         )
                     ),
                     fluidRow(
                         column(
                             width = 12,
                             h2("Estadísticas"),
                             verbatimTextOutput("rawtable2")
                         )
                     )),
            tabPanel("Manipulación de Datos",
                     sidebarLayout(
                         sidebarPanel(
                             h3("Filtrado de datos"),
                             selectInput("select",
                                         "Seleccione filtro a aplicar",
                                         choices = c("viewCount", "likeCount",
                                                     "dislikeCount", "favoriteCount", 
                                                     "commentCount"),
                                         selected = "viewCount",
                                         multiple = FALSE),
                             sliderInput("slider",
                                         "Intervalo:",
                                         min = 0,
                                         max = 500000,
                                         value = c(80, 150),
                                         step = 50)
                         ),
                         mainPanel(
                             "Resultado",
                             dataTableOutput("table1")
                     ))
        )
    )
))