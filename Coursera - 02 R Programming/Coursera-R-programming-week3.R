# Coursera-R-Programming-week3.R
# 
# where I work through coursera R stuff from week 3
# 
# CS O'Connell, UMN EEB/IonE


#####################################################################
# Lectures: lapply and sapply

# loops over a LIST

# mean with lapply
x <- list(a=1:5, b=rnorm(10))
lapply(x, mean)

# another way to use lapply
x <- 1:4 # coerced to list
#set.seed(1)
lapply(x, runif)
# using passed arguments
lapply(x, runif, min = 0, max = 10)

# use of anonymoous functions
x <- list(a=matrix(1:4,2,2), b=matrix(1:6,3,2))
# extract first column
# there is no function for that; you can write your own (this is an anonymous function)
lapply(x, function(elt) elt[,1])

# sapply tries to return something that is more simple than a list (vector or matrix, or if it can't figure it out it returns a list)
x <- list(a=1:5, b=rnorm(10))
lapply(x, mean)
sapply(x, mean)



#####################################################################
# Lectures: apply

# apply evals a function over the margins of an ARRAY (e.g., a matrix)
# no faster than a loop, but less typing

# apply(x, margin, function) # where margin is the dimension that is preserved

x <- matrix(rnorm(200),20,10)
apply(x,2,mean)
apply(x,1,mean)

# some optimized functions that are super fast and same as apply
# rowSums
# rowMeans
# colSums
# colMeans

# can do other things
x <- matrix(rnorm(200),20,10)
apply(x,1,quantile, probs=c(0.25,0.75))
apply(x,1,quantile) # extra arguments not mandatory

# average matrix in a 3-D array
a <- array(rnorm(2*2*10), c(2,2,10))
apply(a, c(1,2), mean) # note that we preserve two dimensions
# or
rowMeans(a,dims=2)



#####################################################################
# Lectures: mapply

# a MULTIVARIATE apply which applies a function in parrallel over a set of arguments
# what if the elements of one list go into the first argument of a function and the elements of a second list go into the second argument of a function? mapply can take multiple list arguments

# example of using mapply for lazy code
list(rep(1,4), rep(2,3), rep(3,2), rep(4,1))
# vs
mapply(rep, 1:4, 4:1)

# vectorizing a function
noise <- function(n,mean,sd) {
      rnorm(n,mean,sd)
}
noise(5,1,2)
noise(1:5,1:5,2) # doesn't really work right
# we want 3 random normals with mean 3, 4 with mean 4, etc...
mapply(noise, 1:5, 1:5, 2) # this vectorized a function that didn't want vector arguments
# same as
list(noise(1,1,2),noise(2,2,2),noise(3,3,2),noise(4,4,2),noise(5,5,2))


#####################################################################
# Lectures: tapply

# applies a function over the subsets of a vector... there's no good pneumonic, really
# you pass it a second list that has the factor or list of factors for each observation by which to group the function calc

x <- c(rnorm(10), runif(10), rnorm(10,1))
f <- gl(3,10) # factor variable, gl is to generate factor levels
tapply(x,f,mean)
tapply(x,f,mean, simplify=FALSE)
tapply(x,f,range) # more compliated output ok, too (why doesn't this simplify?)

# posted this to the forums for these lectures
# set.seed(7)
# x <- c(rnorm(10), runif(10), rnorm(10,1))
# f <- gl(3,10) # factor variable, gl is to generate factor levels
# tapply(x,f,mean) # this returns a vector
# tapply(x,f,mean, simplify=FALSE) # this returns a list
# tapply(x,f,range, simplify=TRUE) # this returns a list despite simplify=TRUE
# tapply(x,f,range, simplify=FALSE) # also returns a list, as expected
# set.seed(Sys.time())


#####################################################################
# Lectures: split

# split is handy!
# though I think that plyr does this kind of thing well, too, FYI

# takes a vector or other objects and SPLITS it into groups determined by a list of factors
# like tapply but without doing the summary statistic part

x <- c(rnorm(10), runif(10), rnorm(10,1))
f <- gl(3,10)
split(x,f)

# common to use split in conjunction with lapply
lapply(split(x,f),mean)
# though note that in some cases tapply can do the same thing
tapply(x,f,mean)

# but with more complicated objects, split beats tapply
library(datasets)
head(airquality)
s <- split(airquality,airquality$Month) # month can be coerced to a factor
lapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")]))

# or can call sapply here
sapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")]))
# deal with NAs
sapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")],na.rm=TRUE))

# splitting on more than one level
x <- rnorm(10)
f1 <- gl(2,5)
f2 <- gl(5,2)
# interaction(f1,f2) # then use interaction function to combine the levels
str(split(x,list(f1,f2))) # some levels are empty
str(split(x,list(f1,f2), drop=TRUE)) # dorp empty levels



#####################################################################
# Lectures: with

# for giving a dataset context. ex:
library(datasets)
data(mtcars)
with(mtcars, tapply(mpg, cyl, mean))


#####################################################################
# Week 1 Quiz

# Q1
library(datasets)
data(iris)

head(iris)
tapply(iris$Sepal.Length,iris$Species,mean)


# Q2
# compare these
apply(iris[, 1:4], 1, mean)
apply(iris, 2, mean)
apply(iris[, 1:4], 2, mean) # this one
colMeans(iris)


# Q3

library(datasets)
data(mtcars)
?mtcars

head(mtcars)
with(mtcars, tapply(mpg, cyl, mean))


# Q4
tmp <- with(mtcars, tapply(hp, cyl, mean))
tmp[[1]]-tmp[[3]]


# Q5

?ls
debug(ls)
ls

