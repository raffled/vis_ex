#### ui.R
#### This script handles the user interface
#### Note that most functions are analogues of HTML tags.  Page is
#### essentially a list of HTML tags specifying content.
dashboardPage(
    #### Header for title, etc.
    dashboardHeader(title = "KNN vs. BLS"),
    #### Sidebar to control tab structure, lets us view one set of
    #### plots at a time
    dashboardSidebar(
        h3("Shiny Demo"),
        hr(),
        sidebarMenu(id = "menu",
                    menuItem("BLS", tabName = "bls", icon = icon("square")),
                    menuItem("KNN", tabName = "knn", icon = icon("square"))
        ),
        #### If we're in the KNN tab, give a slider to set k
        #### server.R has access through input$k, set by inputId
        conditionalPanel(
            condition = "input.menu == 'knn'",
            sliderInput(inputId = "k",
                        label = "K = ",
                        min = 1,
                        max = 100,
                        value = 5)
            )
    ),
    #### Body controls what's active in the main part of the dash
    dashboardBody(
        #### Set up tab structure (corresponding to menu bar selection)
        tabItems(
            #### Tab for least squares
            tabItem(tabName = "bls",
                    #### Row w/ box for each plot
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
            #### Tab for KNN
            tabItem(tabName = "knn",
                    #### Row w/ box for each plot
                    fluidRow(
                        box(title = "sin(x) Plot",
                            width = 6, ## in columns
                            solidHeader = TRUE,
                            status = "primary",
                            plotOutput("knn.sinx")),
                        box(title = "Classification Plot",
                            width = 6, 
                            solidHeader = TRUE,
                            status = "primary",
                            plotOutput("knn.classify"))
                        )
            )
        )
    )
)
