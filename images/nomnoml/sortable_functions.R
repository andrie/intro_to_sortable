library(nomnoml)
library(magrittr)

"
#direction: down
#.pkg: fill=#629fdd

[<pkg>sortable]
[<pkg>shiny]
[<pkg>learnr]

[<hidden>bucket_list()]
[<hidden>question_bucket()]

[sortable] -> [rank_list()]
[rank_list()] -> [question_rank()]
[rank_list()] -> [shiny]
[question_rank()] -> [learnr]

[rank_list()] -> [bucket_list()]
[bucket_list()] -/- [shiny]


[bucket_list()] -/- [question_bucket()]
[question_bucket()] -/- [learnr]

" %>%
  nomnoml()


"
#direction: down
#.pkg: fill=#629fdd

[<pkg>sortable]
[<pkg>shiny]
[<pkg>learnr]

[bucket_list()]
[question_bucket()]

[sortable] -> [rank_list()]
[rank_list()] -> [question_rank()]
[rank_list()] -> [shiny]
[question_rank()] -> [learnr]

[rank_list()] -> [bucket_list()]
[bucket_list()] -> [shiny]


[bucket_list()] -> [question_bucket()]
[question_bucket()] -> [learnr]

" %>%
  nomnoml()
