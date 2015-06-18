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
        classify.xgrid2 <- reactive(seq(min(classify.x()[,2]), max(classify.x()[,2]), length = 100))
        classify.n <- reactive(length(classify.xgrid2()))

        ################################ Render Plots ################################
        #### Each plot is a function of the input state (sliders, tab we're in, etc)
        #### Everything gets saved to an "output" object to be read by
        #### UI.R

        ################################ get predictions ################################
        bls.ygrid <- reactive({
            sapply(sinx.xgrid(), function(i) bls(i, sinx.x(), sinx.y()))
        })
        knn.ygrid <- reactive({
            sapply(sinx.xgrid(), function(i) knn(i, sinx.x(), sinx.y(), input$k))
        })
        bls.zgrid <- reactive({
            t(sapply(1:classify.n(), function(i){
                         sapply(1:classify.n(), function(j){
                                    bls(c(classify.xgrid1()[i],
                                          classify.xgrid2()[j]),
                                        classify.x(),
                                        classify.y())
                         })
            }))
        })
        knn.zgrid <- reactive({
            k <- input$k ## needs to be outside so fxn is reactive
                         ## shiny can't go down two levels of applies, apparently.
            matrix(mcsapply(1:classify.n(), function(i){
                                  sapply(1:classify.n(), function(j){
                                             knn(c(classify.xgrid1()[i],
                                                   classify.xgrid2()[j]),
                                                 classify.x(),
                                                 classify.y(),
                                                 k)
                                  })
            }), classify.n(), classify.n(), byrow = TRUE)
        })
            
        #### Render Regression Plots
        output$bls.sinx <- renderPlot({
            plot(sinx.x(), sinx.y(), pch = 16)
            lines(sinx.xgrid(), bls.ygrid(), col=c("red"))
            lines(sinx.xgrid(), sin(sinx.xgrid()), col=c("blue"))
        })
        output$knn.sinx <- renderPlot({
            plot(sinx.x(), sinx.y(), pch = 16)
            lines(sinx.xgrid(), knn.ygrid(), col=c("red"))
            lines(sinx.xgrid(), sin(sinx.xgrid()), col=c("blue"))
        })

        #### Render Classification Plots  
        output$bls.classify <- renderPlot({
            plot(classify.x(), col=c("orange","blue")[classify.y()+1], pch=16, xlab="x1", ylab="x2")
            sapply(1:classify.n(), function(i){
                       val <- as.numeric(bls.zgrid()[,i] >= 0.5) + 1
                       points(classify.xgrid1(), rep(classify.xgrid2()[i], classify.n()),
                              pch = ".", col = c("orange", "blue")[val])
            })
            contour(x = classify.xgrid1(), y = classify.xgrid2(), z = bls.zgrid(),
                    levels = 0.5, add = TRUE, drawlabels = FALSE)
        })
        
        output$knn.classify <- renderPlot({
            plot(classify.x(), col=c("orange","blue")[classify.y()+1], pch=16, xlab="x1", ylab="x2")
            sapply(1:classify.n(), function(i){
                       val <- as.numeric(knn.zgrid()[,i] >= 0.5) + 1
                       points(classify.xgrid1(), rep(classify.xgrid2()[i], classify.n()),
                              pch = ".", col = c("orange", "blue")[val])
            })
            contour(x = classify.xgrid1(), y = classify.xgrid2(), z = knn.zgrid(),
                    levels = 0.5, add = TRUE, drawlabels = FALSE)
        })
    }
)
