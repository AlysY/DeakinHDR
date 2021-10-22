
## loops

# the data
df_name <- c("A", "B", "C")
df_A <- data.frame(c1 = 1:3, c2 = 5:7)
df_B <- data.frame(c1 = c(4,7,9), c2 = c(1,1,4))
df_C <- data.frame(c1 = rep(1,3), c2 = seq(6,12,3))

# Set up some blank dataframes to save the values into
df_overall <- data.frame()
df_greater1 <- data.frame(data = df_name,
                          nrow = rep(0,3))

# for each element in df_name, do all these processes
for (i in 1:length(df_name)){
  # Get data into your loop
  df <- get(paste0("df_", df_name[i]))
  
  # do your function
    # e.g. divide the dataframe by 2
  df_changed <- df/2
  
  # find some summary statistics
    #e.g. number of rows greater than 1
    # save this to the second column of the df_greater1 dataframe
  df_greater1[i,2] <- sum(df_changed >1)
  
  # save out the modified dataframe, combined with others
    # e.g. using rbind
    # other options are merge() for dataframes, or stack() or brick() for rasters
  df_overall <- rbind(df_overall, df_changed)
  
  # save it out on its own object in the environment
  # use a dynamic name - must include i (or your iterator) in the pasted name
  assign(paste0("DF_", df_name[i], "_halved"), value = df_changed)
  
}


# to test the loop, write i = one of the values that it can take,  and then run each line inside the loop one by one
# e.g. i = 1
i = 1
df <- get(paste0("df_", df_name[i]))
df_changed <- df/2
df_greater1[i,2] <- sum(df_changed >1)
df_overall <- rbind(df_overall, df_changed)
assign(paste0("DF_", df_name[i], "_halved"), value = df_changed)
