library(shinydashboard)

dashboardPage(
    dashboardHeader(
        title = "JFP - Dashboard"
    ),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Data exploration", tabName = "exploration", icon = icon("chart-line")),
            menuItem("Data visualization", tabName = "visualization", icon = icon("dashboard"))
        )
    ),
    dashboardBody(
        tabItems(
            tabItem(
                tabName = "exploration",
                fluidRow(
                    box(
                        DTOutput("table")
                    )
                )
            ),
            tabItem(
                tabName = "visualization",
                h2("Data visualization")
            )
        )
    )
)