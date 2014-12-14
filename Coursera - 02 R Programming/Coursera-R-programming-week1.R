# Coursera-R-Programming-week1.R
# 
# where I work through coursera R stuff from week 1
# 
# CS O'Connell, UMN EEB/IonE


#####################################################################
# Background Material

### things included in the lectures for this week

# what is your current working directory?
getwd()

# what files are in that WD?
dir()

# recommended that we have one directory for this class
# I made a folder for the course: 
# ~/Desktop/Coursework and Resources/Coursework - Yr 5/Coursera - 02 R Programming

# if you put a function in your working directory, you can type source("myfunction.R") and it will bring those functions into R
?source

# a reminder to use the newest version of R (3.1.1)
sessionInfo()
R.version.string # either works


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
# Week 1 Optional Assignment: Swirl assignment

install.packages("swirl")
library(swirl)
swirl()
# bye() or ESC to exit swirl

# did the first two lessons in swirl, 2014-12-07






