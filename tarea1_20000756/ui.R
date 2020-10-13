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
                 ))
    )
))
