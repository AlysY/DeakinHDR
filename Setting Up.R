###********************###
### R Tipcs and Tricks ###
###********************###
# Project aim:
#
# Author:
#
# Collaborators:
#
# Date:
#
# Script aim:

##************************##
## 1. Write headings here ## -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##************************##

# Write sub-headings like this -------------------------------------------------------------

# Write why to do the code above the code
  # And notes on one tab in
head(iris) # and addtional comments about the single line of code after it

# Use 4 or more hash, hyphen or lines to create headings which show up in the table of contents 
# Hashes #### 
# Hyphen ----
# Equals ====


##***********##
## 1. Set Up ## -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##***********## 


# Packages ----------------------------------------------------------------
library(ggplot2)
library(dplyr)

# for package conflicts, use ::
dplyr::mutate(iris, diff = Sepal.Length-Sepal.Width)




# hard coding -------------------------------------------------------------

# If you use an R project, your working directory is automatically set to it
getwd()

# Show all files in the folder specified

# In the working directory
list.files()
list.files(getwd())

# In the Data_raw folder
list.files("Data_raw")

# In the Data_raw folder
list.files("Data_raw")
file <- list.files("Data_raw", full.names=TRUE)
iris <- read.csv(file)

# Try not to hard code locations as this is hard to share with other people running it on their computer



# Data --------------------------------------------------------------------
# Load the dataset
iris

# Examine the data
head(iris)

# Mean of the sepal length
mean(iris$Sepal.Length, na.rm = TRUE) # removes the NAs

# The arrow and equals have different usees
  # Some people use both so you know when the different use is
  # Others use equals all the time so you don't have to know the difference
  # Equals can be used for everything (most things?) that an arrow can be - e.g. assigning variables

mean(x=iris)
mean(x<-iris) # cannot do this

iris_df = iris
iris_df <- iris




# Name of variables -------------------------------------------------------
# Keep in the same format
iris_df <- iris
iris_shp 
iris_ras


## Source a file
source("Scripts/1_DataCleaning.R")


