# Coursera-R-Programming-week4.R
# 
# where I work through coursera R stuff from week 4
# 
# CS O'Connell, UMN EEB/IonE


#####################################################################
# Lectures: str
# most useful function in all of R?

# like summary

# can look at functions
str(ls)

# can look at data
x <- rnorm(100,2,4)
summary(x) # not as compact
str(x)

# look at factors
f <- gl(40,10)
str(f)
summary(f)

# look at datasets
library(datasets)
head(airquality)
str(airquality)
str(airquality$Ozone)

# matrix
m <- matrix(rnorm(100),10,10)
str(m)
m[,1] # str gives first few elements of first col

s <- split(airquality, airquality$Month)
str(s) # gives you info about the split list



#####################################################################
# Lectures: simulation pt 1

# intro to some functions that are useful for simulation

# rnorm
# dnorm
# pnorm
# rpois

# each probability distribution functin (PDF) has functions that begin with d, r, p, q (density, random num generator, cumulative distr, quantile function)

# for instance, working with the normal distribution requires dnorm, pnorm, qnorm, rnorm

# built in: normal, poisson, binomial, exponential, gamma, etc.

x <- rnorm(10)
summary(x)
x <- rnorm(10, 20, 2) # mean 20, std 2
summary(x)

# always set the random number generator seed!
# critical for reproducibility!


#####################################################################
# Lectures: simulation pt 2

# ex
set.seed(20)
x <- rnorm(100)
e <- rnorm(100,0,2)
y <- 0.5 + 2 * x + e
summary(y)
plot(x,y)

# ex 2 - binary variable like gender
set.seed(10)
x <- rbinom(100, 1, 0.5)
e <- rnorm(100,0,2)
y <- 0.5 + 2 * x + e
summary(y)
plot(x,y)

# more complicated generalized linear model
# poisson data
set.seed(1)
x <- rnorm(100)
log.mu <- 0.5 + 0.3*x # this is the log of the var
y <- rpois(100, exp(log.mu)) # give it the exponential for the distribution
summary(y)
plot(x,y)

# the sample() function
# draws randomly from a specified set of numbers/objects, so you can draw from arbitrary distributions
set.seed(1)
sample(1:10, 4) # no replacement
sample(letters, 5)
sample(1:10) # permutation
sample(1:10, replace = TRUE) # with replacement


#####################################################################
# R profiler pt 1

# why is something taking so much time?  profiler can suggest strategies for fixing the slowness problem

# will also talk about other functions to figure out how to optimize software

# profiling tells you how much time is being spent on different parts of your program

# design first, then optimize!

## system.time()
# elapsed time > user time
system.time(readLines("http://www.jhsph.edu"))
# elapsed time < user time
hilbert <- function(n) {
      i <- 1:n
      1 / outer(i - 1, i, "+")
}
x <- hilbert(1000)
system.time(svd(x)) # not for me, but on the lecture, elapsed time < user time.  maybe svd() doesn't work on my mac?

# but what if you don't know where to look?  system.time assumes you know what the slow part is.

## Rprof()
# summaryRprof() makes the Rprof output readable
# do NOT use Rprof() and system.time() together

# normalize "by total" and "by self"
# by.self better since it tells you the time spent in a function, but subtracts out the helper functions it calls (lower level functions) so you see the time that function is actually doing work

# example found on the web
# Evaluate shortFunction() for 100 times
replicate(n = 100, shortFunction())
# now try rprof out
Rprof(tmp <- tempfile()) # Rprof("path_to_hold_output")
example(glm)
Rprof(NULL)
summaryRprof(tmp) # summaryRprof("path_to_hold_output")

# seems to also work like this
replicate(n = 100, shortFunction())
# now try rprof out
Rprof() # Rprof("path_to_hold_output")
example(glm)
Rprof(NULL)
summaryRprof() # summaryRprof("path_to_hold_output")




#####################################################################
# Week 4 Quiz

# Q1

set.seed(1)
rpois(5, 2)

# Q5

set.seed(10)
x <- rbinom(10, 10, 0.5)
e <- rnorm(10, 0, 20)
y <- 0.5 + 2 * x + e
summary(y)
plot(x,y)

# Q8

library(datasets)
Rprof()
fit <- lm(y ~ x1 + x2)
Rprof(NULL)






