library(nomnoml)
library(magrittr)

"
#direction: down
[learnr] -> [custom question type]

[shiny] -> [drag and drop]


[custom question type]-> [?]

[drag and drop] -> [?]


" %>%
  nomnoml()
