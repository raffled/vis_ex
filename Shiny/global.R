#### global.R
#### This script takes care of global options that need run once

#### load packages
library(shiny)
library(shinydashboard)
library(parallel)

#### seed for reproducibility
set.seed(100)

#### functions for models
bls <- function(x0,x,y){
    x0 %*% (solve(t(x) %*% x) %*% t(x) %*% y)
}
knn <- function(x0, x, y, k){
    dis <- apply(as.matrix(x), 1, function(r) sum((x0 - r)^2))
    mean(y[head(order(dis), k)])
}

#### KNN classifier implementation is slow.  Speed it up w/ multicore,
#### but leave a core for shiny
n.cores <- detectCores() - 1
#### unlist(mclapply) is ugly, create an mcsapply()
mcsapply <- function(...) unlist(mclapply(..., mc.cores = n.cores))
