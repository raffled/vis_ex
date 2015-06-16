#### server.R
#### This script contains reactive code to compute plots, output, etc.
shinyServer(
    function(input, output, session){
        ################################ Reactive Objects ################################
        #### Shiny is smart enough to not update unless necessary,
        #### making for a snappier app
        ## for sin(x)
        sinx.x <- reactive(runif(100, 0, 2*pi))
        sinx.y <- reactive(sin(sinx.x()) + rnorm(100, 0, .1))
        sinx.xgrid <- reactive(seq(0, 2*pi, length = 500))
        sinx.n <- reactive(length(sinx.xgrid()))

        ## for classification
        classify.dat <- reactive(read.table("dat_2.txt", FALSE))
        classify.y <- reactive(classify.dat()[,3])
        classify.x <- reactive(as.matrix(classify.dat()[,-3]))
        classify.xgrid1 <- reactive(seq(min(classify.x()[,1]), max(classify.x()[,1]), length = 100))
        classify.xgrid2 <- reactive(seq(min(classify.x()[,2]), max(classify.x()[,2]),length = 100))
        classify.n <- reactive(length(classify.xgrid1()))

        ################################ Render Plots ################################
        #### Each plot is a function of the input state (sliders, tab we're in, etc)
        #### Everything gets saved to an "output" object to be read by UI.R

        #### Render BLS Plots
        output$bls.sinx <- renderPlot({
            x <- sinx.x()
            y <- sinx.y()
            xgrid <- sinx.xgrid()
            n <- sinx.n()
            ygrid <- sapply(xgrid, function(i) bls(i, x, y))
            plot(x, y, pch = 16)
            lines(xgrid, ygrid, col=c("red"))
            lines(xgrid, sin(xgrid), col=c("blue"))
        })
        output$bls.classify <- renderPlot({
            y <- classify.y()
            x <- classify.x()
            xgrid1 <- classify.xgrid1()
            xgrid2 <- classify.xgrid2()
            n <- classify.n()

            zgrid <- t(sapply(1:n, function(i){
                                  sapply(1:n, function(j){
                                             bls(c(xgrid1[i], xgrid2[j]), x, y)
                                  })
                     }))
            plot(x, col=c("orange","blue")[y+1], pch=16, xlab="x1", ylab="x2")
            sapply(1:n, function(i){
                       val <- as.numeric(zgrid[,i] >= 0.5) + 1
                       points(xgrid1,rep(xgrid2[i],n), pch = ".", col = c("orange", "blue")[val])
            })
            contour(x = xgrid1, y = xgrid2, z = zgrid, levels = 0.5, add = TRUE, 
                    drawlabels = FALSE)
        })

        #### KNN Plots
        output$knn.sinx <- renderPlot({
            x <- sinx.x()
            y <- sinx.y()
            xgrid <- sinx.xgrid()
            n <- sinx.n()
            ygrid <- sapply(xgrid, function(i) knn(i, x, y, input$k))
            plot(x, y, pch = 16)
            lines(xgrid, ygrid, col=c("red"))
            lines(xgrid, sin(xgrid), col=c("blue"))
        })
        output$knn.classify <- renderPlot({
            y <- classify.y()
            x <- classify.x()
            xgrid1 <- classify.xgrid1()
            xgrid2 <- classify.xgrid2()
            n <- classify.n()
            k <- input$k
            zgrid <- t(matrix(mcsapply(1:n, function(i){
                                  sapply(1:n, function(j){
                                             knn(c(xgrid1[i], xgrid2[j]), x, y, k)
                                  })
                     }), n, n))
            plot(x, col=c("orange","blue")[y+1], pch=16, xlab="x1", ylab="x2")
            sapply(1:n, function(i){
                       val <- as.numeric(zgrid[,i] >= 0.5) + 1
                       points(xgrid1,rep(xgrid2[i],n), pch = ".", col = c("orange", "blue")[val])
            })
            contour(x = xgrid1, y = xgrid2, z = zgrid, levels = 0.5, add = TRUE, 
                    drawlabels = FALSE)
        })
    }
)
