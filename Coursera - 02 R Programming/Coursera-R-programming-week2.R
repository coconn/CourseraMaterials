# Coursera-R-Programming-week2.R
# 
# where I work through coursera R stuff from week 2
# 
# CS O'Connell, UMN EEB/IonE


#####################################################################
# Lectures: control structures

# control structures
# if else, for, while, repeat, break, next, return

for(i in 1:10) {
      print(i)
}

# these for loops are the same
x <- c("a","b","c","d")

for(i in 1:4) {
      print(x[i])
}

for(i in seq_along(x)) {
      print(x[i])
}

for(i in x) {
      print(i)
} # i doesn't have to be an integer; can take elements from whatever vector

for(i in 1:4) print(x[i])

# rows and cols
x <- matrix(1:6,2,3)
for(i in seq_len(nrow(x))){
      for(j in seq_len(ncol(x))) {
            print(x[i,j])
      }
}
# warns that nesting too many is hard to red and building a function is better

# be careful with while loops that your loop will actually end and not go infinitely

z <- 5
while(z >= 3 && z <= 10) {
      print(z)
      coin <- rbinom(1,1,0.5)
      if(coin==1){ # random walk
            z <- z+1
      } else{
            z <- z-1
      }
}

# repeat only ends if you call a break
# not that common, but maybe in optimization algorithms as you're converging on the min or max of the objective function
# for loop with a hard limit on iterations is probably better in case there's a problem with the alg and isn't converging
x0 <- 1
tol <- 1e-8
repeat{
      x1 <- computeEstimate()
      if(abs(x1-x0)<tol) {
            break
      } else{
            x0 <- x1
      }
}

# next skips an iteration
for (i in 1:100) {
      if (i <= 30) {
            # Skip the first 30 iterations.
            next
      }
      print(i)
}
# return, like next or break, interrupts the flow of a program, but we use it in functions


#####################################################################
# Lectures: functions

# functions are going in their own text files, so see functions-week1.R

# the '...' argument

# when binding a value to a symbol, R searches through environments (lists of symbols and values).  first searches through the global enviro (workspace things you've defined/loaded).  if no match there, searches the namespaces of currently loaded packages (see search()).

# functions and objects can have the same name
lm <- 5
lm
lm(airquality)


#####################################################################
# Lectures: scoping

# lexical scoping in R (scoping rules determine how a value gets bound to a symbol/free variable); how R uses the search list is related to this.  

# free variables' values are searched for in the environment where the function was defined.

y <- 10
f <- function(x){
      y<-2
      y^2 + g(x)
}

g<-function(x){
      x*y
}
f(3) # ans = 34, because g(3)=30 where y=10, but y^2 within f = 4 because y=2, 30+4=34


# scoping rules and optimizing functions
# constructor function that constructs the objective function
# carries everything with it like baggage aside from the parameter
make.NegLogLik <- function(data, fixed = c(FALSE, FALSE)) {
      params <- fixed
      function( p ) {
            params[!fixed] <- p
            mu <- params[1]
            sigma <- params[2]
            a <- -0.5 * length(data) * log(2 * pi * sigma^2)
            b <- -0.5 * sum((data-mu)^2) / (sigma^2)
            -(a + b)
      }
}

set.seed(1); normals <- rnorm(100, 1, 2)
nLL <- make.NegLogLik(normals)
nLL # shows defining environment at the bottom of the description (address of where it lives in the memory)
ls(environment(nLL)) # what's in that environment

# try this out
optim(c(mu = 0, sigma = 1), nLL)$par

# fix sigma
nLL <- make.NegLogLik(normals, c(FALSE, 2))
optimize(nLL, c(-1, 3))$minimum

# fix mu
nLL <- make.NegLogLik(normals, c(1, FALSE))
optimize(nLL, c(1e-6, 10))$minimum

# Objective functions can be "built" that contain all of the necessary data for evaluating the function
# No need to carry around long argument lists—useful for interactive and exploratory work
# Code can be simplified and cleaned up


#####################################################################
# Lectures: dates






#####################################################################
# Week 1 Lectures and Quiz

## history
# John Chambers at Bell Labs in the late 70s - S language
# R is a version of the S language

## random commands/things I didn't know

# complete.cases
?complete.cases
x <- c(1,2,NA,4)
y <- c("a","b","c",NA)
good <- complete.cases(x,y)
x[good]

# [] vs [[]]: [[]] extracts the actual thing in the list (like, the vector or the string), and [] ALWAYS returns the exact same type of data as the thing it's drawing from, so [1] of a list returns a list of one item, that might be a vector, etc.

# speed up reading in your data
# colClasses makes things a lot faster
initial <- read.table("datatable.txt", nrows=100)
classes <- sapply(initial, class)
tabALL <- read.table("datatable.txt", colClasses = classes)
# nrows is also really helpful, not for speed but helps R figure out how to parse its memory


## quiz stuff

quizdata <- read.csv("~/Desktop/Coursework and Resources/Coursework - Yr 5/Coursera - 02 R Programming/hw1_data.csv", stringsAsFactors=FALSE)

head(quizdata, n=2)
tail(quizdata, n=2)
quizdata$Ozone[47]

sum(is.na(quizdata$Ozone))
mean(na.omit(quizdata$Ozone))

subsetforquiz1 <- subset(quizdata, quizdata$Ozone > 31 & Temp >90)
mean(na.omit(subsetforquiz1$Solar.R))

subsetforquiz2 <- subset(quizdata, quizdata$Month == 6)
mean(na.omit(subsetforquiz2$Temp))

subsetforquiz3 <- subset(quizdata, quizdata$Month == 5)
max(na.omit(subsetforquiz3$Ozone))



#####################################################################
# Week 1 Quiz

# Q1
cube <- function(x, n) {
      x^3
}

cube(3)


# Q2
x <- 1:10
if(x > 5) {
      x <- 0
}

# Q3

f <- function(x) {
      g <- function(y) {
            y + z
      }
      z <- 4
      x + g(x)
}

z <- 10
f(3)


# Q4

x <- 5
y <- if(x < 3) {
      NA
} else {
      10
}


# illustration of scoping

#
#  Scoping
#
# from http://wiki.math.yorku.ca/index.php/R:_Scoping_of_free_variable_names

a <- "Global"
f <- function() {
      
      g <- function(x) cat( x,a,"\n")
      g("g called in f before assn of a: a =")
      a <- "in f"
      g("g called in f after assn of a: a =")
      h <- function(x){
            a <- "defined in h"
            g(x)
      }
      h( "h calling g from in f: a =")
      a <- "redefined in f"
      h("h calling g in f after redefining a: a =")
      rm(a)
      h("h calling g after removing a: a =")
}

f()






