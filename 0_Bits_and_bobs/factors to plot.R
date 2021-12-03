## Random bits and bobs

data(iris)
iris$Species ## the categorical variable
levels(iris$Species)

# ggplot ------------------------------------------------------------------
library(ggplot2)

ggplot(data = iris, aes(x = Species, y = Sepal.Width)) +
  geom_boxplot()

## change the order
is.factor(iris$Species)
levels(iris$Species) # the order the categories are plotted in

# need to make a new vector in the order you want it plotted
l <- c("virginica", "versicolor", "setosa" ) # write them out yourself
l <- rev(levels(iris$Species)) 

# or by some order from the data
# e.g. here, ordered by the mean
library(dplyr)
iris %>%
  select(Sepal.Width, Species) %>%
  group_by(Species) %>%
  summarise(mean(Sepal.Width))
# here the order of the species is right

# use the function 'pull'
l <- iris %>%
  select(Sepal.Width, Species) %>%
  group_by(Species) %>%
  summarise(m = mean(Sepal.Width)) %>%
  arrange(m) %>%
  select(Species) %>%
  pull() %>%
  as.vector() # needs to be a vector. if you skip in this example it will be wrong



# then set the levels in your initial data
iris$Species <- factor(iris$Species, levels = l)
