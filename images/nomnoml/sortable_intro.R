library(nomnoml)
library(magrittr)

"
#direction: down
#.pkg: fill=#629fdd

[<pkg>sortable R package]


[sortable_js javascript library]

[sortable_js javascript library] --> inside [sortable R package]

[sortable R package] -> provides [htmlwidget with drag-and-drop]

[htmlwidget with drag-and-drop] to -> [shiny apps]
[htmlwidget with drag-and-drop] -> [learnr tutorials]

" %>% nomnoml()
