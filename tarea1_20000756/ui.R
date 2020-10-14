library(shiny)

shinyUI(fluidPage(

    titlePanel("Carga de archivos y dataframes"),
    tabsetPanel(
        tabPanel("Cargar Archivo",
                 sidebarLayout(
                     sidebarPanel(
                         h2("Subir Archivo"),
                         fileInput("upload_file_1", 
                                   buttonLabel = "Cargar",
                                   label = "Cargar archivo",
                                   accept = c(".csv", ".tsv"))
                     ),
                     mainPanel(
                         tableOutput("content_file_1")
                     )
                 )),
        tabPanel("Cargar Archivo DT",
                 sidebarLayout(
                     sidebarPanel(
                         h2("Subir Archivo"),
                         fileInput("upload_file_2", 
                                   buttonLabel = "Cargar",
                                   label = "Cargar archivo",
                                   accept = c(".csv", ".tsv"))
                     ),
                     mainPanel(
                         dataTableOutput("content_file_2")
                     )
                )),
        tabPanel("DT Option",
                 h2("Formato columna"),
                 hr(),
                 fluidRow(
                     column(
                         width = 12,
                         dataTableOutput("tabla1")
                     )
                 ),
                 h2("Opciones"),
                 hr(),
                 fluidRow(
                   column(
                       width = 12,
                       dataTableOutput("tabla2")
                   )  
                 ),
                 h2("Extensiones"),
                 hr(),
                 fluidRow(
                     column(
                         width = 12,
                         dataTableOutput("tabla3")
                     )
                 )),
        tabPanel("Clicks en tabla",
                 fluidRow(
                     column(
                         width = 12,
                         h2("Click en una fila"),
                         dataTableOutput("tabla4"),
                         verbatimTextOutput("tabla4_single_click")
                     )
                 ),
                 fluidRow(
                     column(
                         width = 12,
                         h2("Click en multiples filas"),
                         dataTableOutput("tabla5"),
                         verbatimTextOutput("tabla5_multi_click")
                     )
                 ),
                 fluidRow(
                     column(
                         width = 12,
                         h2("Click en una columna"),
                         dataTableOutput("tabla6"),
                         verbatimTextOutput("tabla6_single_click")
                     )
                 ),
                 fluidRow(
                     column(
                         width = 12,
                         h2("Click en multiples columnas"),
                         dataTableOutput("tabla7"),
                         verbatimTextOutput("tabla7_multi_click")
                     )
                 ),
                 fluidRow(
                     column(
                         width = 12,
                         h2("Click en una celda"),
                         dataTableOutput("tabla8"),
                         verbatimTextOutput("tabla8_single_click")
                     )
                 ),
                 fluidRow(
                     column(
                         width = 12,
                         h2("Click en multiples celdas"),
                         dataTableOutput("tabla9"),
                         verbatimTextOutput("tabla9_multi_click")
                     )
                 ))
    )
))
