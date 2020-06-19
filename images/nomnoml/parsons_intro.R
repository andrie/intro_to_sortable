library(nomnoml)
library(magrittr)

"
#direction: down
#.pkg: fill=#629fdd

[<pkg>sortable|
R package]


[sortable_js|
javascript library]

[sortable_js] --> [sortable]


[sortable] --> extends [parsons|R package;(parsons problems)]

" %>% nomnoml()
