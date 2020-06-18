
library(shiny)
library(sortable)
library(tidyverse)
library(palmerpenguins)

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


ui <- fluidPage(
  fluidRow(
    class = "panel panel-heading",
    div(
      class = "panel-heading",
      h3("Penguins")
    ),
    fluidRow(
      class = "panel-body",
      column(
        width = 3,
        tags$div(
          class = "panel panel-default",
          tags$div(class = "panel-heading", "Variables"),
          tags$div(
            class = "panel-body",
            id = "sort1",
            colnames_to_tags(dataset)
          )
        )
      ),
      column(
        width = 3,
        # analyse as x
        tags$div(
          class = "panel panel-default",
          tags$div(
            class = "panel-heading",
            tags$span(class = "glyphicon glyphicon-stats"),
            "Analyze as x (drag here)"
          ),
          tags$div(
            class = "panel-body",
            id = "sort2"
          )
        ),
        # analyse as y
        tags$div(
          class = "panel panel-default",
          tags$div(
            class = "panel-heading",
            tags$span(class = "glyphicon glyphicon-stats"),
            "Analyze as y (drag here)"
          ),
          tags$div(
            class = "panel-body",
            id = "sort3"
          )
        )

      ),
      column(
        width = 6,
        plotOutput("plot")

      )
    )
  ),
  sortable_js(
    "sort1",
    options = sortable_options(
      group = list(
        name = "sortGroup1",
        put = TRUE
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
        put = htmlwidgets::JS("function (to) { return to.el.children.length < 1; }"),
        pull = TRUE
      ),
      onSort = sortable_js_capture_input("sort_x")
    )
  ),
  sortable_js(
    "sort3",
    options = sortable_options(
      group = list(
        group = "sortGroup1",
        put = htmlwidgets::JS("function (to) { return to.el.children.length < 1; }"),
        pull = TRUE
      ),
      onSort = sortable_js_capture_input("sort_y")
    )
  )
)

server <- function(input, output) {
  output$variables <- renderPrint(input[["sort_vars"]])
  output$analyse_x <- renderPrint(input[["sort_x"]])
  output$analyse_y <- renderPrint(input[["sort_y"]])


  x <- reactive({
    x <- input$sort_x
    if (is.character(x)) x %>% trimws()
  })

  y <- reactive({
    input$sort_y %>% trimws()
  })

  output$plot <-
    renderPlot({
      validate(
        need(x(), "Drag a variable to x"),
        need(y(), "Drag a variable to y")
      )

      dataset %>%
        ggplot(aes_string(x(), y())) +
        geom_point()
    })

}
shinyApp(ui, server)
