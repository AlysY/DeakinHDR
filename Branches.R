# heres some code

library(tidyverse)

mtcars
head(mtcars)

# dev
mtcars %>%
  filter(cyl >= 4) %>%
  summarize(mean_hp = mean(hp))
