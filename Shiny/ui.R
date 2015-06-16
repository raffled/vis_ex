#### ui.R
#### This script handles the user interface
#### Note that most functions are analogues of HTML tags
dashboardPage(
    dashboardHeader(title = "KNN vs. BLS"),
    dashboardSidebar(
        h3("Shiny Demo"),
        hr(),
        sidebarMenu(id = "menu",
                    menuItem("BLS", tabName = "bls", icon = icon("square")),
                    menuItem("KNN", tabName = "knn", icon = icon("square"))
        ),
        conditionalPanel(
            condition = "input.menu == 'knn'",
            sliderInput(inputId = "k",
                        label = "K = ",
                        min = 1,
                        max = 20,
                        value = 5)
        )
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "bls",
                    fluidRow(
                        box(title = "sin(x) Plot",
                            width = 6, ## in columns
                            solidHeader = TRUE,
                            status = "primary",
                            plotOutput("bls.sinx")),
                        box(title = "Classification Plot",
                            width = 6, 
                            solidHeader = TRUE,
                            plotOutput("bls.classify"),
                            status = "primary")
                        )
            ),
            tabItem(tabName = "knn",
                    fluidRow(
                        box(title = "sin(x) Plot",
                            width = 6, ## in columns
                            solidHeader = TRUE,
                            status = "primary",
                            "bar"),
                        box(title = "Classification Plot",
                            width = 6, 
                            solidHeader = TRUE,
                            status = "primary")
                        )
            )
        )
    )
)
