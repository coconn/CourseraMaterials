add2 <- function(x,y) {
  x + y
}

# don't need anything special to return the value
# last expression gets returned

above10 <- function(x){
  use <- x>10
  x[use]
}

above <- function(x, n){
  use <- x>n
  x[use]
}

above_default <- function(x, n = 10){ # if no user specified n, 10 becomes default
  use <- x>n
  x[use]
}

columnmean <- function(y, removeNA = TRUE) { # defaults to true to remove NAs
  nc <- ncol(y)
  means <- numeric(nc) # initialize
  for(i in 1:nc) {
    means[i] <- mean(y[,i], na.rm = removeNA)
  }
  means
}








