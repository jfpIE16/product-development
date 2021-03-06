# Curso: Product Development
# Tarea No.1
# Jose Fernando Perez Perez
# Universidad Galileo

library(shiny)
library(lubridate)

shinyUI(fluidPage(
    titlePanel("Inputs en Shiny"),
    tabsetPanel(tabPanel("Inputs Examples",
                         sidebarLayout(
                             sidebarPanel(
                                 sliderInput("slider1",
                                             "Slider sencillo",
                                             value=50,
                                             min=0,
                                             max=100,
                                             step=5,
                                             post="%", animate = TRUE),
                                 sliderInput("slider2",
                                             "Slider range",
                                             min=0,
                                             max=100,
                                             value = c(70, 85),
                                             step=5,
                                             post="%", animate = TRUE
                                             ),
                                 selectInput("select1",
                                             "Seleccione un auto:",
                                             choices = rownames(mtcars),
                                             selected = "Ferrari Dino",
                                             multiple = FALSE),
                                 selectizeInput("select2",
                                                "Seleccione autos:",
                                                choices = rownames(mtcars),
                                                selected = "Ferrari Dino",
                                                multiple = TRUE),
                                 dateInput("date1",
                                           "Seleccione la fecha:",
                                           value = today(),
                                           min = today() - 60,
                                           max = today() + 30,
                                           language = "es",
                                           weekstart = 1),
                                 dateRangeInput("date2",
                                                "Seleccione rango de fechas",
                                                start = today() - 7,
                                                end = today(),
                                                separator = 'a',
                                                language = "es",
                                                weekstart = 1),
                                 numericInput("numeric",
                                              "Ingrese un numero:",
                                              value = 9,
                                              min = 0,
                                              max = 100,
                                              step = 1),
                                 checkboxInput("checkbox",
                                               "Seleccione si verdadero:",
                                               value = FALSE),
                                 checkboxGroupInput("group_box",
                                                    "Seleccione las opciones:",
                                                    choices = LETTERS[1:5]),
                                 radioButtons("radiobtn",
                                              "Seleccione genero:",
                                              choices = c("masculino", "femenino")
                                              ),
                                 textInput("text",
                                           "Ingrese texto"),
                                 textAreaInput("textarea",
                                               "Ingrese parrafo"),
                                 passwordInput("password",
                                               "Ingrese password"),
                                 actionButton("action_button",
                                              "Ok"),
                                 actionLink("action_link",
                                            "Siguiente"),
                                 #submitButton("Reprocesar")
                             ),
                             mainPanel(
                               h3("Slider Input Sencillo"),
                               verbatimTextOutput("slider1_output"),
                               h3("Slider Input Rango"),
                               verbatimTextOutput("slider2_output"),
                               h3("Select Input"),
                               verbatimTextOutput("select1_output"),
                               h3("Select Input Multiple"),
                               verbatimTextOutput("select2_output"),
                               h3("Fecha"),
                               verbatimTextOutput("date1_output"),
                               h3("Rango de fechas"),
                               verbatimTextOutput("date2_output"),
                               h3("Numeric Input"),
                               verbatimTextOutput("numeric_output"),
                               h3("Single checkbox"),
                               verbatimTextOutput("checkbox_output"),
                               h3("Grouped checkbox"),
                               verbatimTextOutput("groupbox_output"),
                               h3("Radio Buttons"),
                               verbatimTextOutput("radio_output"),
                               h3("Texto"),
                               verbatimTextOutput("text_output"),
                               h3("Parrafo"),
                               verbatimTextOutput("textarea_output"),
                               h3("Password"),
                               verbatimTextOutput("password_output"),
                               h3("Action Button"),
                               verbatimTextOutput("actionbtn_output"),
                               h3("Action Link"),
                               verbatimTextOutput("actionlink_output")
                             )
                         )))
))