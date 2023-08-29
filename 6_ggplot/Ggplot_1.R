## GGplot - part 1
# introduction

# Deakin Coding Club
# By Alys Young
# March 2023


# Resources ---------------------------------------------------------------
# https://ggplot2.tidyverse.org/reference/index.html  
# https://posit.co/resources/cheatsheets/?type=posit-cheatsheets&_page=2/   
# https://ggplot2-book.org  
# http://www.sthda.com/english/wiki/ggplot2-essentials  



# Set up ------------------------------------------------------------------

# install.packages("ggplot2")
library(ggplot2)

# In ggplot, the method to build the plot needs to specify 3 components:
#   the data, the aesthetics and the geom (or plot type).
# 
# You need to:
# 1. Start by calling a ggplot using `ggplot()`.  
# 2. Specify the data using the "data" argument `ggplot(data =  )`.  
# 3. Specify the x and y variables using the aesthetics argument `ggplot(data = , aes(x= , y = ) )`.  
# 3. Specify  what sort of plot you make ggplot to make using a second line joining to the `ggplot()` with a `+`.  



# Data --------------------------------------------------------------------
# load the data
data(iris) 

# Take a look at the data
head(iris)


## Basic types of plots ------------------------------------------------------------------

## Categorical data -------------------------------------*
# Box Plot 
ggplot(data = iris, aes(x = Species, y = Sepal.Width)) +
  geom_boxplot()

# Voilin plot
ggplot(data = iris, aes(x = Species, y = Sepal.Width)) +
  geom_violin()

  
## Continuous data -------------------------------------*
## scatter plot
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point()


## adding a basic regression line
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point() +
  geom_smooth()




# Facetting ---------------------------------------------------------------

# Separate the plot into 3 panes, one for each of the 3 species
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point() +
  facet_wrap(~Species)

# Separate the plot into 3 panes, one for each of the 3 species. Force the panes to be in 2 columns and change the names of the panes.
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point() +
  geom_smooth() +
  facet_wrap(~Species, ncol = 2,
             labeller = labeller(Species = c("setosa" = "Iris setosa",
                                             "versicolor" = "Iris versicolor",
                                             "virginica" = "Iris virginica")))




# Colours -----------------------------------------------------------------

## Coloured by species
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, colour = Species)) +
  geom_point() +
  geom_smooth()


## Colour by petal length
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, colour = Petal.Length)) +
  geom_point()


## Fill vs colour ------------------------*
# It is important to keep in mind that
# the aesthetics `colour` and `fill` vary in their effect depending on the geom used.

# Box Plot with colour
ggplot(data = iris, aes(x = Species, y = Sepal.Width, colour = Species)) +
  geom_boxplot()

# Box Plot with fill
ggplot(data = iris, aes(x = Species, y = Sepal.Width, fill = Species)) +
  geom_boxplot()




# Other aesthetics --------------------------------------------------------

# Colour and shape is by species
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species, shape = Species)) +
  geom_point()


## Static aesthetics - not related to the data
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Petal.Length)) +
  geom_point(alpha = 0.5, size  = 2, pch = 17)




# Labels and titles ------------------------------------------------------------------

ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point() +
  labs(title = "Sepal length by width", x = "Sepal length (cm)", y = "Sepal width (cm)")


# Legend ------------------------------------------------------------------
## Move legend
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  theme(legend.position = "bottom") # try "top"


## Hide legend
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point(show.legend = FALSE)



# Themes ------------------------------------------------------------------
## Add premade theme
ggplot(data = iris, aes(x = Species, y = Sepal.Width)) +
  geom_boxplot() +
  theme_dark() # try theme_light, theme_dark, theme_classic,



# Tick marks --------------------------------------------------------------
## Alter the axis scale
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point() +
  scale_x_continuous(limits = c(2, 8),
                     breaks = seq(2, 8, 1), # sequence from 0 to 8 by 1. Equivalent to 2:8
                     minor_breaks = seq(1, 8, 0.2)
                     )
  
  



# Annotations -------------------------------------------------------------

## Annotate with text
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  annotate("text", x = 4.5, y = 4, label = "Group 1", size = 7) +
  annotate("text", x = 6.5, y = 3.6, label = "Group 2", color = "blue") + 
  annotate("text", x = 5.5, y = 2, label = "Group 3") 
  
## Annotate bar plot with * for significance
ggplot(data = iris, aes(x = Species, y = Sepal.Length)) +
  geom_bar(stat = "identity") +
    annotate("text", x = 1, y = 270, label = "*", size = 20) 

## Annotate with text and a line
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  annotate("text", x = 4.5, y = 4.2, label = "Important segment") +
  annotate("segment", x = 4.1, xend = 5, y = 4, yend = 4,
           arrow = arrow(ends = "both", angle = 90, length = unit(.2,"cm")))

## Annotate with an arrow
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  annotate("text", x = 7, y = 4.5, label = "Outliers", size = 7) + # try size = 3
  annotate("segment", x = 7.4, xend = 7.8, y = 4.5, yend = 3.9, # try chaning these values
           size = 1.5, # try 0.5 or 2
           color = "darkblue", # try "green" or "purple"
           arrow = arrow())
  
  



## Save your plot ----------------------------------------------------------------------
# Use the function `ggsave` .

# # Save the most recent plot by using ggsave directly afterwards
# ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
#  geom_point()
#
# ggsave("your/folder/directory/here/plot.png")

# # Save a specific plot by assigning it a name
# # Save the most recent plot by using ggsave directly afterwards
# p <- ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
#  geom_point()
#
# ggsave(p, "your/folder/directory/here/plot.png")








## Visualising basic regression model

m1 <- lm(Sepal.Width ~ Petal.Length, data = iris)
summary(m1)

## Visualise what this might look like using a scatter plot
ggplot(data = iris, aes(x = Petal.Length, y = Sepal.Width)) +
  geom_point()

## Save the predictions from the model together with the petal length
m_prediction <- data.frame( Petal.Length = iris$Petal.Length,
                            Sepal.Width_pred = fitted(m1))

## Add the regresion line to the plot
ggplot(data = iris, aes(x = Petal.Length, y = Sepal.Width)) +
  geom_point() +
  geom_line(data = m_prediction, aes(x = Petal.Length, y = Sepal.Width_pred ))


## option 1 - manually
m_out <- summary(m1)
m_eval <- m_out$coefficients
class(m_eval)
m_eval_df <- as.data.frame(m_eval)
m_eval_df$vars <- rownames(m_eval_df)
m_eval_df <- rename(m_eval_df, st_error = `Std. Error`)
m_eval_df

## Options 2 - using tidy r
library(broom)
tidy(m1)



# Plot model coefficient --------------------------------------------------

## Plot coefficient estimates
ggplot(data = m_eval_df, aes(y = vars, x = Estimate)) +
  geom_point() + 
  geom_pointrange(aes(xmin = Estimate - st_error, xmax = Estimate + st_error)) +
  labs(y = "", x = "Coefficient estimate")

# make vars a factor with the levels in the order you want
# Option 1 using base R
order <- m_eval_df[order(m_eval_df$Estimate),'vars']

# Option 2 using dplyr and pipes
order <- m_eval_df %>%  arrange(Estimate) %>% select(vars) %>% pull

# Set the levels in the correct oder
m_eval_df$vars <- factor(m_eval_df$vars, levels = order)

## Plot with the new order of variables
ggplot(data = m_eval_df, aes(y = vars, x = Estimate)) +
  geom_point() + 
  geom_pointrange(aes(xmin = Estimate - st_error, xmax = Estimate + st_error)) +
  labs(y = "", x = "Coefficient estimate", title = "In order")





# Plot model outputs ------------------------------------------------------


library(effects)
plot(allEffects(m2))

## Extract the effect
eff_PW <- effect("Petal.Width", m2)
eff_PW_df <- as.data.frame(eff_PW)
eff_PW_df

## Plot the effect with ggplot
ggplot(data = eff_PW_df, aes(x = Petal.Width, y = fit)) +
  geom_line()

  


## Model with the interaction of sepal length and species
m3 <- lm(Sepal.Width ~ Sepal.Length*Species, data = data_model)
summary(m3) # interaction is significant

## Extract the effect of the interaction
eff_int <- effect("Sepal.Length*Species", m3)
eff_int_df <- as.data.frame(eff_int)

## Plot the interaction
ggplot(data = eff_int_df, aes(x = Sepal.Length, y = fit, colour = Species)) +
  geom_line()












