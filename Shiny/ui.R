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
        sidebarMenu(
            menuItem("Regression", tabName = "sinx",
                     icon = icon("square")),
            menuItem("Classification", tabName = "class",
                     icon = icon("square"))
        ),
        hr(),
        sliderInput(inputId = "k",
                    label = "K = ",
                    min = 1,
                    max = 100,
                    value = 5)
    ),
    #### Body controls what's active in the main part of the dash
    dashboardBody(
        #### Set up tab structure (corresponding to menu bar selection)
        tabItems(
            #### Tab for least squares
            tabItem(tabName = "sinx",
                    fluidRow(
                        #### Column for BLS
                        column(width = 5,
                               box(title = "BLS",
                                   solidHeader = TRUE,
                                   width = NULL,
                                   status = "info",
                                   plotOutput("bls.sinx")),
                               valueBoxOutput("bls.rsq", width = NULL)
                        ),
                        column(width = 5,
                               box(title = "KNN",
                                   width = NULL,
                                   solidHeader = TRUE,
                                   status = "success",
                                   plotOutput("knn.sinx")),
                               valueBoxOutput("knn.rsq", width = NULL)
                        )
                    )
            ), ## close Regression tab
            #### Tab for KNN
            tabItem(tabName = "class",
                    fluidRow(
                        #### Column for BLS
                        column(width = 5,
                               box(title = "BLS",
                                   solidHeader = TRUE,
                                   width = NULL,
                                   status = "info",
                                   plotOutput("bls.classify"))
                         ),
                        column(width = 5,
                               box(title = "KNN",
                                   width = NULL,
                                   solidHeader = TRUE,
                                   status = "success",
                                   plotOutput("knn.classify"))
                        )
                    )
            ) ## Close CLassification tab
        ) ## close tabItems
    ) ## close body
) ## close UI
