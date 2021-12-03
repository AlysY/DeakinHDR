# the values in the condition
i <- c(1,3,7)
l <- rep(NA, times = 3)
df <- as.data.frame(cbind(i,l))

# ifelse statement in a loop
for( d in 1:nrow(df)){ # the loop
  
  # condition 1 - if the value of i is equal to 2
  if(df$i[d] == 2) {
    
    # result - make l say "it is 2"
    df$l[d] <- "it is 2" 
  } 
  
  # condition 2 - if the value of i is equal to 3
  else if ( df$i[d] == 3) {
    
    # result - make l say "it is 3"
    df$l[d] <- "it is 3"
  } 
  
  # condition 3 - if the value of i is another value
  else {
    # result - make l say "none"
    df$l[d] <- "none"
  }
}

## other options
# doesnt work string
if( i == 1) print("it is 1")

# does work
ifelse(i == 1, "its 1", "not 1")

# ifelse statment - doesnt work on a string
if(i == 2) { # condition
  print("it is 2") # outcome
} else if ( i == 3) {
  print("it is 3")
} else {
  print("none")
}
