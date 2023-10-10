
# String manipulation 
# Find, change and extract patterns

# Orginally by David Wilkinson UoM
# Rewritten by Alys Young

# Oct 2023


########## -
# Set up # ---------------------------------------------------------------------
########## -

require(stringr)
require(stringi)

library(dplyr)


################ - 
# Find Matches # ---------------------------------------------------------------
################ -

## The dataset --------------------------- -
# Look at the data
starwars

# take a sample for today
starwars_samp <- head(starwars)

# We will be using the name column
starwars_samp$name



## Examples --------------------------- -

grep(pattern = "Skywalker",
     x = starwars_samp$name,
     ignore.case = FALSE,
     value = FALSE,
     invert = FALSE)

grepl(pattern = "Skywalker",
      x = starwars_samp$name,
      ignore.case = FALSE)

stringi::stri_detect_fixed(starwars_samp$name,
                           pattern = "L")

stringr::str_detect(starwars_samp$name,
                    pattern = "Vader",
                    negate = TRUE)

stringr::str_detect(starwars_samp$name,
                    pattern = "3PO|D2",
                    negate = FALSE)

starwars_samp$name[stringr::str_detect(starwars_samp$name,
                                       pattern = "3PO|D2",
                                       negate = FALSE)]

## Task  --------------------------- -

# Task 1
# Filter the dataset to only include rows where the name has a hyphen in it

# Task 2
# Using a different method, filter the data to only include rows
# which include Luke and Leia's names

# Note:
# There is a process called fuzzy matching where
# the similarity between strings is measured so you can find similar but not identical matches



####################### -
# Pattern Replacement # ------------------------------------------------------ 
####################### -

## The dataset --------------------------- -
starwars_dirty <- head(starwars, n = 3) %>% 
  select(name) %>% pull

starwars_dirty <- c(starwars_dirty, "luke skywalker", "l. skywalker", "L skywalker ", "Luke Skywalking", "C_3P0", "C_3_P0", "C-3po", "C-3PO", "r2 d2", "R2 D3") %>% sort




## Examples --------------------------- -

tolower(starwars_dirty)

toupper(starwars_dirty)

tools::toTitleCase(starwars_dirty)

stringr::str_to_upper(starwars_dirty)
stringr::str_to_lower(starwars_dirty)
stringr::str_to_title(starwars_dirty) # good for people's names
stringr::str_to_sentence(starwars_dirty) # good for species's names and plotting


gsub(pattern = "Skywalking",
     replacement = "Skywalker",
     x = starwars_dirty)

gsub("\\.",
     "",
     starwars_dirty)

sub("_",
    "-",
    starwars_dirty)

stringr::str_replace(starwars_dirty,
                     pattern = "luke",
                     replacement = "Luke")

# Note: In regex, . is a special character meaning "any character"
# to match a pattern on a full stop you must specific you mean the character a full stop and not the regex version of a .
# try the below code removing the backslashes and see what happens

## Task  --------------------------- -

# Task 1 -
# use str_replace to change all versions of the Luke Skywalker's name to the correct spelling
# try making this a pipe using %>% 

# Task 2 - 
# use grep to find all the strings in the starwars_dirty which have a number in them
# make these capital letters

# hint: to find digits, use the pattern "\\d

# Task 3 -
# use sub and gsub to correct the hyphens

# Task 4 -
# why are there still issues with the spelling?
# fix them
unique(starwars_dirty)



##########################
### Pattern Extraction ###
##########################

## The dataset --------------------------- -
cat_df <- data.frame(species_year = c("cat_2020",
                                               "cat_2021",
                                               "cat_2022",
                                               "cat_23"))
                     


## Examples --------------------------- -

stringi::stri_extract(cat_df$species_year,
                      regex = "\\d",
                      mode = "first")

stringi::stri_extract(cat_df$species_year,
                      regex = "\\d",
                      mode = "last")

stringi::stri_extract(cat_df$species_year,
                      regex = "\\d",
                      mode = "all")

stringr::str_extract(cat_df$species_year,
                     pattern = "\\d")

stringr::str_extract_all(cat_df$species_year,
                         pattern = "\\d")

stringr::str_extract_all(cat_df$species_year,
                         pattern = "\\d",
                         simplify = TRUE)

stringi::stri_count_regex(cat_df$species_year,
                          pattern = "\\d")



## Task  --------------------------- -

# Task
# Change the pattern to "\\d{2,} to extract 2 or more digits in a row
# write these into a new column in the dataframe

# Task
# Change the pattern to look for 3 or more digits in a row to find the row with where the year is written as two digits

# Task
# use species_df to find the row where the year is recorded only with 2 digit rather than 4

####################
# String Splitting #
####################

species_df <- data.frame(species_site_year = c("cat_A_2020",
                                               "cat_A_2021",
                                               "dog_A_2020",
                                               "cat_B_2020",
                                               "cat_B_2021",
                                               "dog_B_2020"))


## The dataset --------------------------- -


strsplit(species_df$species_site_year,
         split = "_")

stringr::str_split(species_df$species_site_year,
                   pattern = "_")

stringr::str_split(species_df$species_site_year,
                   pattern = "_",
                   simplify = TRUE)

stringr::str_split_fixed(species_df$species_site_year,
                         pattern = "_",
                         n = 1) 

stringr::str_split_fixed(species_df$species_site_year,
                         pattern = "_",
                         n = 2)

## Task  --------------------------- -

# Task
# split the dataframe based on the underscores
# Save each of the properties (species, sites and year
# into their own columns in the original dataframe











