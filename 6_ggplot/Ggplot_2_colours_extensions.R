
## GGplot - part 2
# Extensions and colour palettes

# Deakin Coding Club
# By Alys Young
# March 2023





## Set up ------------------------------------------------------------------------------------------------------------------------------------------

# Load packages
library(ggplot2) # ggplot2 to make ggplots
library(dplyr) # dplyr for data manipulation

# Load the iris dataset
data(iris)
# look at the dataset
head(iris)

# simple linear model
mod1 <- lm(Sepal.Width ~ Sepal.Length + Petal.Length + Petal.Width + Species + Sepal.Length:Species,
           data = iris) # I put this wrong in the original code











## Correlation plots ----------------------------------------------------------------------------------------------------------------------------
# Package: ggcorrplot 

## Load the package
library(ggcorrplot)


# select only the numeric data to test for correlations

# Option 1 in base R
# using an apply function, test each column to see if its numeric, and then select only those
iris_numeric <- iris[sapply(iris, is.numeric)]

# option 2 using dplyr
iris_numeric <- iris %>% dplyr::select_if(is.numeric)

## Correlation
cor_out <- cor(iris_numeric)

## Plot the correlation using ggcorrplot on cor_out
ggcorrplot(cor(iris_numeric))







ggcorrplot(cor_out,  
           method = "circle",
           type = "lower",
           lab = TRUE)


install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)
# function: chart.Correlation()











## Plotting model covariates -------------------------------------------------------------------------------------------------------------------------------------------

## Package: ggeffects 
library(ggeffects)



## One variable 
ggpredict(mod1, terms = "Petal.Width") 

marginalEffect_df <- ggpredict(mod1, terms = "Petal.Length") # save the predictions as a dataframe

# Plot with baseR
plot(marginalEffect_df) # plot the effect of the one variable

# plot with ggplot
ggplot(data = marginalEffect_df, aes(x = x, y = predicted)) + # note the x variable is called x !!
  geom_line() +
  geom_ribbon(aes(ymin =  conf.low, ymax = conf.high), alpha = .1)






## Multiple variables
marginalEffect_df <- ggpredict(mod1, terms = c("Petal.Length", "Species", "Sepal.Length"))

# Plot with baseR
plot(marginalEffect_df)

# plot with ggplot

ggplot(data = marginalEffect_df, aes( x = x, y = predicted, fill = group, colour = group)) +
  geom_line() +
  geom_ribbon(aes(ymin =  conf.low, ymax = conf.high), alpha = .1) +
  facet_wrap(~facet) +
  labs(x = "Petal length", y = "Predicted sepal width", colour = "Species", fill = "Species", title = "Predicted sepal width by petal length, species and sepal length")












# build plots -------------------------------------------------------------------------------------------------------------------------------------------------------------
library(esquisse)








# edit your plot -------------------------------------------------------------------------------------------------------------------------------------------------------------
library(ggedit)

ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point()




# Publication ready plots
library(ggpubr)

ggdensity(iris,
          x = "Petal.Length",
          add = "mean",
          rug = TRUE,
          color = "Species",
          fill = "Species",
          palette = c("#00AFBB", "#E7B800", "grey"))
# try gghistogram instead of ggdensity

ggboxplot(iris,
          x = "Species",
          y = "Petal.Length",
          color = "Species",
          # palette =c("#00AFBB", "#E7B800", "#FC4E07"),
          add = "jitter",
          shape = "Species")




# animated plots------------------------------------------------------------------------------------------------------------------------
library(gganimate)

# good for change through time

# https://gganimate.com









# Interactive plots -------------------------------------------------------------------------------------------------------------------------------------------------------
# package: plotly
library(plotly)

p <- ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point()

ggplotly(p) # use the function ggplotly wrapped around the plot 








# Marginal plos -------------------------------------------------------------------------------------------------------------------------------------------------------------
# package: ggExtra
library(ggExtra)

ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point()

p2 <- ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point()

ggExtra::ggMarginal(
  p = p2,
  type = 'density',
  margins = 'both',
  size = 5,
  colour = 'black',
  fill = '#BFBFBF03'
)








# Themes ------------------------------------------------------------------------------------------------------------------------------------------------------------------
# built in themes from ggplot
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point() +
  theme_bw()


## more theme options -------*
# package: ggthemes
# https://yutannihilation.github.io/allYourFigureAreBelongToUs/ggthemes/
library(ggthemes)
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point() +
  theme_few() # theme_wsj()


# Package: cowplot
library(cowplot)
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) + 
  geom_point() +
  theme_cowplot(12)

# Edit your theme with point and click
# package: ggthemeassist

# install.packages("ggthemeassist")

# this appears in the "add ins" drop down menu in the tool bar

ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point()










# view multiple plots together ------------------------------------------------------------------------------------------------------------------------------------------------------------
# other package options: patchwork

library(gridExtra)

p1 <- ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point()
p2 <- ggplot(data = iris, aes(x = Sepal.Length)) +
  geom_histogram(fill = "white", colour = "black")

grid.arrange(p1, p2, ncol = 2) # use the function grid.arrange to put p1 and p2 into one plot with ncol = 2 


## Other options
# package: ggpubr - https://rpkgs.datanovia.com/ggpubr/
# function: ggpubr::ggarrange()
ggarrange(p1, p2)

# package: cowplot
plot_grid(p1, p2, labels = c('A', 'B'), label_size = 12)


## Text labels with ggrepel------------------------
library(ggrepel)

p_text <- ggplot(data = head(iris, n = 20), aes(x = Sepal.Length, y = Sepal.Width, label = Species)) +
  geom_point(colour = "red") +
  geom_text()

p_repelled <- ggplot(data = head(iris, n = 20), aes(x = Sepal.Length, y = Sepal.Width, label = Species)) +
  geom_point(colour = "red") +
  geom_text_repel()

grid.arrange(p_text, p_repelled, ncol = 2) # use the function grid.arrange to put p1 and p2 into one plot with ncol = 2 



# Save plots out ----------------------------------------------------------

# Package: ggplot2
# function: ggsave

# Package: ggpubr
# function: ggexport




######################
## Part 2 - colours ##
######################


# Colour not related to dataset -------------------------------------------
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point()

# Colour by a name and shape
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point(color  = "hotpink")

# Colour by a HEX and size
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point(color = "#4842f5", alpha = 0.5, size = 3.5, shape = 17)







# Colour related to your dataset ------------------------------------------


# 2 types of variables that you might want to colour by:
# discrete (categorical, factor)
# continuous (numeric)

# Colour by species - discrete
p_col_discrete <- ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, colour = Species)) +
  geom_point()

# Colour by petal width - continuous
p_col_cont <- ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, colour = Petal.Width)) +
  geom_point()



# Ways to implement your own colours
# specifying your own colours - individually, or creating your own palette
# using pre-made palettes - e.g. viridis, rcolourbrewer



# Colour blind friendly
# - https://cran.r-project.org/web/packages/colorBlindness/vignettes/colorBlindness.html
# - packages such as: minsell, viridis, RColorBrewer, dichromat, colourblindr, shades, ggsci



## How to choose good colours?
# https://www.learnui.design/tools/data-color-picker.html


###############################
## Part 2.1 - manual colours ##
###############################



# Categorical variables ---------------------------------------------------

# Default colour for species
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point()









# Colour by name or HEX
# NOTE: Because our variable is mapped to colour, we use scale_color_manual function

ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  scale_color_manual(values = c("darkgreen", "purple", "#4842f5"))


# Specifiy your colours by name or HEX for the specific categorical level
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  scale_color_manual(values = c('versicolor' = "darkgreen",
                                'virginica' = "purple",
                                'setosa' = "#4842f5"))
# but if you want to colour by species in multiple plots, its annoying to copy and paste.
# so....



# Specify your colours using an external vector
# which can be reused
my_pal <- c('versicolor' = "darkgreen", 'virginica' = "purple", 'setosa' = "#4842f5")

# set your vector of colours as the values
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  scale_color_manual(values = my_pal) # make sure you use "values" here









# If you have multiple palettes, you could imagine this would get messy quick
# so save them all to one list each with their own name

# Here is an empty list
project_palettes <- list()

# add the colour pallete for species
project_palettes$species <- c('versicolor' = "darkgreen", 'virginica' = "purple", 'setosa' = "#4842f5")

# use the colour palette from the list as the input for the values argument
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  scale_color_manual(values = project_palettes$species)





# Fill vs colour ----------------------------------------------------------
# scale_color_manual vs scale_fill_manual

# keep in mind when you change plot types, that fill and colour mean different things
# and based on if you use fill or colour, your scale function for the colour also needs to use the same word



# Change to a box plot - colour affects the outside perimeter
ggplot(data = iris, aes(x = Species, y = Sepal.Width, colour = Species)) + # used colour by mistake
  geom_boxplot() +
  scale_fill_manual(values = c("darkgreen", "purple", "#4842f5"))



# For the box plot, now colour by the species
ggplot(data = iris, aes(x = Species, y = Sepal.Width, fill = Species)) + # changed colour to fill - does nothing
  geom_boxplot() +
  scale_color_manual(values = c("darkgreen", "purple", "#4842f5"))
# but the colours dont work!
# because you are filling for the species so you need to have the scale function for fill
# e.g. scale_fill_manual


# fill by species and use scale_fill_manual
ggplot(data = iris, aes(x = Species, y = Sepal.Width, fill = Species)) +
  geom_boxplot() +
  scale_fill_manual(values = c("darkgreen", "purple", "#4842f5"))
# this works







# Continuous variable -----------------------------------------------------

# Colour by petal width - continuous
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Petal.Length)) +
  geom_point()





# Colour by name or HEX - function scale_color_gradient
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Petal.Length)) +
  geom_point() +
  scale_color_gradient(low = "blue", high = "red")






# Use the function colorRampPalette on your colours
my_pal_reds <- colorRampPalette(c("yellow", "red", "darkred"))
my_pal_reds(4)




# Or remember we set up a list of colour palettes earlier
# project_palettes <- list()
# project_palettes$species <- c('versicolor' = "darkgreen", 'virginica' = "purple", 'setosa' = "#4842f5")
project_palettes
project_palettes$reds <- c("yellow", "red", "darkred")
project_palettes$greens <- c("yellow", "green", "darkgreen")


my_pal_reds <- colorRampPalette(project_palettes$reds)




ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Petal.Length)) +
  geom_point() +
  scale_color_gradientn(colors = my_pal_reds(10))







######################
## Part 2.2 - premade palettes ##
######################
# colorBlindness - test if the colours used in a plot are suitable


https://github.com/G-Thomson/Manu


# Base r ------------------------------------------------------------------
?heat.colors
?topo.colors
topo.colors(10)

## Continuous
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Petal.Length)) +
  geom_point() +
  scale_color_gradientn(colors = heat.colors(10))# add rev to reverse the colours

## Discrete
ggplot(data = iris, aes(x = Species, y = Sepal.Width, fill = Species)) +
  geom_boxplot() +
  scale_fill_manual(values = topo.colors(3)) # make sure the number is more than your categories.







# RColorBrewer ------------------------------------------------------------

library(RColorBrewer)
# Not colour-blind safe by default

# To see the color palettes from RColorBrewer, use display.brewer.all()
display.brewer.all(colorblindFriendly = TRUE)




# For colour use scale_color_*
# For fill use scale_fill_*

# For discrete variables, use scale_*_brewer
# For continuous variables, use scale_*_distiller
# For binned continuous variables, use scale_*_fermenter




# Inside the function use palette to set the palette to use

# Colour on a categorical variable
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  scale_color_brewer(palette = "Set2")

# Fill on a categorical variable
ggplot(data = iris, aes(x = Species, y = Sepal.Width, fill = Species)) +
  geom_boxplot() +
  scale_fill_brewer(palette = "Accent")


ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Petal.Length)) +
  geom_point() +
  scale_color_distiller(palette = "Greens")








# Viridis -----------------------------------------------------------------
library(viridisLite)
library(viridis)
# All are colour-blind friendly

# For colour use scale_color_viridis_*
# For fill use scale_fill_viridis_*

# For a discrete variable, use scale_*_viridis_d
# For a continuous variable, use scale_*_viridis_c
# For a binned continuous variable, use scale_*_viridis_b

# discrete
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  scale_color_viridis_d() # d for discrete

# continuous, plasma palette
ggplot(data = iris, aes(x = Sepal.Length, y = Sepal.Width, color = Petal.Length)) +
  geom_point() +
  scale_color_viridis_c(option = "plasma") # d for discrete

## If using Base R to plot,
# use the functions viridis(n), magma(n), inferno(n) and plasma(n) where n is the number of colours you want. Returns a vector of colours selected from the palette


#imgpalr and paletteR




# Fun colour palettes! -----------------------------------------------------------------------------------------

## ggsci for specific journals
library(ggsci)

## Pirates
library(yarrr)
yarrr::piratepal(palette = "all")

## Studio ghibli
library(ghibli)

## Wes andersen
library(wesanderson)

## Ochre - Australian landscapes
# really nice, earth colours
devtools::install_github("ropenscilabs/ochRe")
library(ochRe)
pal_names <- names(ochre_palettes)

## New Zealand birds
devtools::install_github("G-Thomson/Manu")
library(manu)

## Australian birds
devtools::install_github(repo = "shandiya/feathers", ref = "main")
library(feathers)
names(feathers_palettes)

## Dutch masters - paintings
devtools::install_github("EdwinTh/dutchmasters")
library(dutchmasters)
pal_names <- names(dutchmasters)

## scico - designed for scientific publications
library(scico)

## paletteer - common interface for many palettes
library(paletteer)