#### server.R
#### This script contains reactive code to compute plots, output, etc.
shinyServer(
    function(input, output, session){
        #### Render BLS Plots
        output$bls.sinx <- renderPlot({
            x <- runif(100, 0, 2*pi)
            y <- sin(x) + rnorm(100, 0, 0.1)

            xgrid <- seq(0, 2*pi, length = 500)
            n <- length(xgrid)
            ygrid <- sapply(xgrid, function(i) bls(i, x, y))
            plot(x, y, pch = 16)
            lines(xgrid, ygrid, col=c("red"))
            lines(xgrid, sin(xgrid), col=c("blue"))
        })
        
        output$bls.classify <- renderPlot({
            x <- read.table("dat_2.txt", FALSE)
            y <- x[,3]
            x <- as.matrix(x[,-3])

            xgrid1 <- seq(min(x[,1]), max(x[,1]), length = 100)
            xgrid2 <- seq(min(x[,2]), max(x[,2]),length = 100)
            n <- length(xgrid1)
            zgrid <- matrix(0,n,n)

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
    }
)
