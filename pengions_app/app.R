
library(shiny)
library(sortable)
library(tidyverse)
library(palmerpenguins)
library(shinyjs)

colnames_to_tags <- function(x){
  lapply(
    colnames(x),
    function(co) {
      tag(
        "p",
        list(
          class = class(x[, co, drop = TRUE]),
          tags$span(class = "glyphicon glyphicon-move"),
          tags$strong(co)
        )
      )
    }
  )
}

dataset <- penguins


# tags$div(
#   class = "panel panel-default",
#   tags$div(class = "panel-heading", "Variables"),
#   tags$div(
#     class = "panel-body",
#     id = "sort1",
#     colnames_to_tags(dataset)
#   )
# )

panel <- function(title, id, content = NULL) {
  tags$div(
    class = "panel panel-default",
    tags$div(class = "panel-heading", title),
    tags$div(
      class = "panel-body",
      id = id,
      content
    )
  )

}

limit_to_one_element <- function() {
  htmlwidgets::JS("function (to) { return to.el.children.length < 1; }")
}

ui <- fluidPage(
  useShinyjs(),
  fluidRow(
    div(
      class = "panel-heading",
      h3("Penguins"),
      p("Analysis of data available from https://github.com/allisonhorst/palmerpenguins")
    ),
    fluidRow(
      class = "panel-body",
      column(
        width = 3,
        panel("Variables", id = "sort1", colnames_to_tags(dataset))
      ),
      column(
        width = 3,
        # analyse as x
        panel("Analyze as x", id = "sort2"),
        # analyse as y
        panel("Analyze as y", id = "sort3"),
        # analyse as colour
        panel("Colour", id = "sort4")
      ),
      column(
        width = 6,
        tags$div(
          id = "penguin_image",
          tags$p(tags$small("Artwork by @allison_horst")),
          imageOutput("penguins", width = "300px", height = "179px")
        ),
        plotOutput("plot")


      )
    )
  ),
  sortable_js(
    "sort1",
    options = sortable_options(
      group = list(
        name = "sortGroup1",
        put  = TRUE
      ),
      sort = FALSE,
      onSort = sortable_js_capture_input("sort_vars")
    )
  ),
  sortable_js(
    "sort2",
    options = sortable_options(
      group = list(
        group = "sortGroup1",
        put   = limit_to_one_element(),
        pull  = TRUE
      ),
      onSort = sortable_js_capture_input("sort_x")
    )
  ),
  sortable_js(
    "sort3",
    options = sortable_options(
      group = list(
        group = "sortGroup1",
        put   = limit_to_one_element(),
        pull  = TRUE
      ),
      onSort = sortable_js_capture_input("sort_y")
    )
  ),
  sortable_js(
    "sort4",
    options = sortable_options(
      group = list(
        group = "sortGroup1",
        put   = limit_to_one_element(),
        pull  = TRUE
      ),
      onSort = sortable_js_capture_input("sort_col")
    )
  )

)

server <- function(input, output) {
  output$variables   <- renderPrint(input[["sort_vars"]])
  output$analyse_x   <- renderPrint(input[["sort_x"]])
  output$analyse_y   <- renderPrint(input[["sort_y"]])
  output$analyse_col <- renderPrint(input[["sort_col"]])


  x <- reactive({
    x <- input$sort_x
    if (is.character(x)) x %>% trimws()
  })

  y <- reactive({
    input$sort_y %>% trimws()
  })

  col <- reactive({
    input$sort_col %>% trimws()
  })

  output$penguins <- renderImage({
    list(src = "www/images/lter_penguins_small.png", alt = "LTER penguins")
  },
  deleteFile = FALSE)

  output$plot <-
    renderPlot({
      shinyjs::show("penguin_image")
      validate(
        need(x(), "Drag a variable to x"),
        need(y(), "Drag a variable to y")
      )

      # browser()
      shinyjs::hide("penguin_image")

      p <- if(length(col()) == 0) {
        dataset %>%
          drop_na() %>%
          ggplot(aes_string(x(), y()))

      } else {
        dataset %>%
          drop_na() %>%
          ggplot(aes_string(x(), y(), colour = col()))

      }

      class_x <- dataset %>% pull(x()) %>% class()
      class_y <- dataset %>% pull(y()) %>% class()


        if (class_x == "factor") {
          if (class_y == "factor") {
            p <- p +
              geom_point(stat = "sum")
          } else {
            p <- p +
          geom_violin() +
              geom_point()
        }
        } else {
            p <- p +
        geom_point()
      }


      p +
        theme_bw(16)
    })

}
shinyApp(ui, server)
