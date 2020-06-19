library(nomnoml)
library(magrittr)

"
#direction: down
[learnr] -> [custom question type]

[shiny] -> [drag and drop]


[custom question type]-> [sortable]

[drag and drop] -> [sortable|R package]


" %>%
  nomnoml()
