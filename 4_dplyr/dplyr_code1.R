# Dplyr run through

library(tidyverse)
library(stringr)

setwd("put_the_file_path_here")

# opening data as tibble
ds <- read.csv("example_data.csv")
data_set <- as_tibble(ds)

summary(data_set)

# examples of sentence structure to select columns. order based on order you want table in 
data_set %>% select(scientificName,preparations)
# OR
data_set %>% select(-images)
# select and rename
data_set %>% select(Species = scientificName)

# using stringr
data_set <- data_set %>% mutate(scientificName = word(scientificName , 1  , 2))


# examples of filtering rows
data_set %>% filter(scientificName == "Accipiter fasciatus")
# drop a type of row (unsure if thisis correct)
data_set %>% filter(scientificName !="Accipiter fasciatus")
# multiple levels
data_set %>% filter(scientificName %in% c("Accipiter fasciatus","Accipiter novaehollandiae"))

# arrange for shifting order
data_set %>% arrange(scientificName,institutionCode)
data_set %>% arrange(year)
data_set %>% arrange(desc(year))

# mutate for making new column
data_set <- data_set %>% mutate(year10 = year*10)

# add in summary statistic (?)
data_set %>% select(scientificName,year) %>%
  group_by(scientificName) %>%
  summarise(mean_year = mean(year))
# ddply as option? lorenzo

# using stringr2
data_set %>% 
  filter(str_detect(scientificName,"Erythrotriorchis"))


