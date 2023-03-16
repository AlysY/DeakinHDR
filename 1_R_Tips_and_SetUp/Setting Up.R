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
head(iris) # and additional comments about the single line of code after it

# Use 4 or more hash, hyphen or lines to create headings which show up in the table of contents 
# Hashes #### 
# Hyphen ----
# Equals ====

# Subheading that don't show up in the table of reference by adding a * on the end -------------------------------------*

##***********##
## 1. Set Up ## -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##***********## 

# Clean up ----------------------------------------------------------------


# Clean up your environment to start
rm(list = ls()) # this removes everything in your environment. Not don't uninstall packages


# Packages ----------------------------------------------------------------
# Install them if they are required
if (!require(ggplot2)) install.packages('ggplot2')

# load them
library("ggplot2")

# you dont have to load a package to use it
# you can use :: instead
# also great for package conflicts
dplyr::mutate(iris, diff = Sepal.Length - Sepal.Width)
  # Here i dont have the package dplyr loaded, but I can use its functions by writing dplyr:: and then the function name




# hard coding -------------------------------------------------------------

# If you use an R project, your working directory is automatically set to the folder location
getwd()

# Show all files in the folder specified

# In the working directory
list.files()
list.files(getwd())

# In ta specific folder
  # e.g. the Data_raw folder
list.files("Data_raw")

# In the Data_raw folder
list.files("Data_raw")
file <- list.files("Data_raw", full.names = TRUE)
iris <- read.csv(file)

# Try not to hard code locations as this is hard to share with other people running it on their computer




## Directors -------------------------------------------
dir <- list()

dir$wd <- file.path(getwd(), "1_R_Tips_and_SetUp")
dir$data_raw <- file.path(dir$wd, "Data_raw")
dir$out <- file.path(dir$wd, "Outputs", Sys.Date())

if (file.exists(dir$out) == FALSE){dir.create(dir$out)}



ggsave(file.path(dir$out, "my_plot.png"))




##*********##
## 2. Data ## -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##*********## 
# Iris data --------------------------------------------------------------------
# Load the dataset
data(iris)

# Examine the data
head(iris)

# Mean of the sepal length
mean(iris$Sepal.Length, na.rm = TRUE) # removes the NAs

# The arrow and equals have different usees
  # Some people use both so you know when the different use is
  # Others use equals all the time so you don't have to know the difference
  # Equals can be used for everything (most things?) that an arrow can be - e.g. assigning variables

mean(x = iris)
mean(x <- iris) # cannot do this

iris_df = iris
iris_df <- iris




# Name of variables -------------------------------------------------------
# Keep in the same format
iris_df <- iris
iris_shp 
iris_ras


## Source a file
# Write code in another file which makes things in an environment
# use the function source to add those objects to your environment

source("1_DataCleaning.R")



# R Markdown --------------------------------------------------------------
# I have started using this for data exploration
# also can use it for writing reports, great way to share with supervisors or collaborators

# in the github folder, you shoud be able to see DataExploration.Rmd for an example


##****************##
## 1. Other Notes ## -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
##****************##
# keep your R, R studio and packages up to date
  # R has to be redownloaded from online
  # Windows users can download R studio from R studio i think
  # Mac you have to download from online
  # Packages are updated inside Rstudio

# R studio layout ---------------------------------------------------------------------
# Find the pane layout that works for you
  # I have the scripts tab and the consol tab the biggest because I use them the most, and the environment the smallest

# R Projects--------------------------------------------------------------------
  # Use them
  # File > New Project ...
# Benefits:
  # The environments of different projects dont mix
  # You can run multiple things at once
  # Your working directory is already set

# Folder set up--------------------------------------------------------------------
  # Do it in a way that makes sense to you
  # e.g.
    # Data_raw - where all the raw data goes
    # Data_process - where all the data you are processing and cleaning goes
    # Data_clean - final data used in your next steps
    # Outputs
    # Scripts
    # Archive_scripts
    # Archive_outputs


# Scipt set up ------------------------------------------------------------

# Personal preference if you like to have fewer bigger scripts
# or many smaller scripts

# A master script where its one script will all your essential analysis.
# Good when publishing code

# Seperate scripts for each function that you write


# Global Options ----------------------------------------------------------
# Accessed in the Tools tab on your tool bar
# last option should be global options

# Global Options > General
# Unclick the load .RData atuomatically
# If you use RData and have things saved there, then load it yourself rather than automatically
# stops errors of your scripts not lining up with whats in your environment

# Global Options > Code > Editing
# Rainbow parentheses
  # helps with finding your brackets

# Global Options > Code > Diagnostics
# Turn on the diagnostics to help you clean and debug your code

# Global Options > Appearance
# Editor theme:
# Choose a colour palette you like and works for your needs

# Editor font:
# there are other options of fonts to download online
# I like Firacode because it changes your symbols which normally take multiple characters like not equals ( ! = ) or arrows ( < - ) or greater than ( < = )
  # to a single symbol (like the advance symbols in a word doc)

# Global Options > Pane layout
# To change how your R studio is displayed



# Snippets ----------------------------------------------------------------
# Premade chunks of code

# To access
# Tools > Global Options > Code > 
# Enable code snippets

# Key board shortcuts -----------------------------------------------------
# https://support.rstudio.com/hc/en-us/articles/200711853-Keyboard-Shortcuts

# A new heading
  # Windows: ctrl + shift + r
  # Mac: cmnd + shift + r

# Dplyr pipe
  # Windows: ctrl + shift + m
  # Mac: cmnd + shift + m

# To jump to the end of your line of code
  # Windows: crt + arrow key
  # Mac: cmd + arrow

