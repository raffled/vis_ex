## vis_ex
The repository contains code written to demo `Knitr` and `Shiny` for
Dr. Culp.

The K-NN/Loess code from STAT 745 -- Data Mining Assignment 2 will be used as an
example.

## Subdirectories

### Knitr
The Knitr directory contains an example document written up using R
Markdown.  To run the code, open `assign2.Rmd` in RStudio and hit the
`Knit to HTML` button to render the document, or
`knitr::knit2html("assign2.Rmd")` from the `R` console.

Note that RStudio can also render the document as a PDF by hitting the
small arrow next to `Knit to HTML` and selecting `Knit to PDF`.

You can view a live version her:
[http://stat.wvu.edu/~draffle/vis_ex/Knitr/assign2.html](http://stat.wvu.edu/~draffle/vis_ex/Knitr/assign2.html)

### Shiny
The Shiny directory contains an example shiny app for viewing the
plots. To run the app, run the R command `shiny::runApp()` from inside
the directory.

Note, you will need the `shiny` and `shinydashboard` packages
installed, along with `parallel`.

The app is also live here: [https://raffled.shinyapps.io/Shiny](https://raffled.shinyapps.io/Shiny)
