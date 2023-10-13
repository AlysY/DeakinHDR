#####################################
# String manipulation               #
# Find, change and extract patterns #
#                                   #
# Orginally by David Wilkinson UoM  #
# Rewritten by Alys Young           #
#                                   #
# Oct 2023                          #
#####################################

########## -
# Set up # ---------------------------------------------------------------------
########## -

library(stringr)
library(stringi)
library(dplyr)


################ - 
# Find Matches # ---------------------------------------------------------------
################ -

## The dataset --------------------------- -
# Look at the data
dplyr::starwars

# take a sample for today
starwars_samp <- head(dplyr::starwars)

# We will be using the name column
starwars_samp$name



## Examples --------------------------- -
grep(pattern = "Skywalker",
     x = starwars_samp$name,
     ignore.case = FALSE,
     value = TRUE,
     invert = TRUE)

g <- grepl(pattern = "Skywalker",
      x = starwars_samp$name,
      ignore.case = FALSE)
starwars_samp$name[g]

stringi::stri_detect_fixed(starwars_samp$name,
                           pattern = "L")

stringr::str_detect(starwars_samp$name,
                    pattern = "Vader",
                    negate = FALSE)

stringr::str_detect(starwars_samp$name,
                    pattern = "3PO|D2",
                    negate = FALSE)

starwars_samp$name[stringr::str_detect(starwars_samp$name,
                                       pattern = "3PO|D2",
                                       negate = FALSE)]

## Task  --------------------------- -

# Task 1
# Filter the dataset to only include rows where the name has a hyphen in it

starwars_samp[stringr::str_detect(starwars_samp$name,
                                       pattern = "-")]

filter(starwars_samp, stringr::str_detect(starwars_samp$name,
                                          pattern = "-"))

g<-stringi::stri_detect_fixed(starwars_samp$name,
                              pattern = "-")
filtered_dataset <- starwars_samp[g, ]

# Task 2
# Using a different method, filter the data to only include rows
# which include Luke or Leia's names


# Note:
# There is a process called fuzzy matching where
# the similarity between strings is measured so you can find similar but not identical matches



####################### -
# Pattern Replacement # ------------------------------------------------------ 
####################### -

## The dataset --------------------------- -
starwars_dirty <- head(starwars, n = 3) %>% 
  select(name) %>% pull

starwars_dirty <- c(starwars_dirty, " luke   skywalker ", "l. skywalker", "L skywalker ", "Luke Skywalking", "C_3P0", "C_3_P0", "C-3po", "C-3PO", "r2 d2", "R2 D3") %>% sort




## Examples --------------------------- -

tolower(starwars_dirty)
toupper(starwars_dirty)
tools::toTitleCase(starwars_dirty)

# using stringr
stringr::str_to_upper(starwars_dirty)
stringr::str_to_lower(starwars_dirty)
stringr::str_to_title(starwars_dirty) # good for people's names
stringr::str_to_sentence(starwars_dirty) # good for species's names and plotting

# using snakecase
library(snakecase)
to_snake_case(starwars_dirty)
to_mixed_case(starwars_dirty, sep_out = " ")
to_upper_camel_case(starwars_dirty)


gsub(pattern = "Skywalking",
     replacement = "Skywalker",
     x = starwars_dirty)

gsub("\\.",
     "",
     starwars_dirty)

sub("_",
    "-",
    starwars_dirty)

# Note: This changes only the first underscore - so watch out if there are multiple
# if you have multiple underscores, you can clean it twice
cleaned_once <- sub("_",
    "-",
    starwars_dirty)

cleaned_twice <- sub("_",
                    "-",
                    cleaned_once)


stringr::str_replace(starwars_dirty,
                     pattern = "luke",
                     replacement = "Luke")

stringr::str_replace(starwars_dirty,
                     pattern = c("L |l "),
                     replacement = "Luke ")

# Dealing with white spaces
trimws(starwars_dirty)

stringr::str_trim(starwars_dirty) 

stringr::str_squish(starwars_dirty)

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
# Change the pattern to "\\d{2,}" to extract 2 or more digits in a row
# write these into a new column in the dataframe

stringr::str_extract(cat_df$species_year,
                     pattern = "\\d{4,}")
# Task
# Change the pattern to look for 3 or more digits in a row to find the row with where the year is written as two digits
stringr::str_extract(cat_df$species_year,
                     pattern = "\\d{3,}")

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

my_split_mat <- stringr::str_split(species_df$species_site_year,
                                  pattern = "_",
                                  simplify = TRUE)
my_split_df <- as.data.frame(my_split_mat)
names(my_split_df) <- c("species", "site", "year")







