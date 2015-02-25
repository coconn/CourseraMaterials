# Coursera-getting-data-week1.R
# 
# where I work through coursera getting data stuff from week 1
# 
# CS O'Connell, UMN EEB/IonE



#####################################################################
# Week 1 Lectures

### downloading files from the internet

# may want to make a new directory before downloading
getwd()
setwd()
file.exists("directoryName")
dir.create("directoryName")

# can use in combo:
if (!file.exists("data")) {
      dir.create("data")
}

# getting data from the internet
download.file() # this way automates the download, instead of clicking on the file, so better reproducibility

# example
fileUrl <- "https://data.baltimorecity.gov/api/whatever.csv"
download.file(fileUrl, destfile = "./data/cameras.csv", method = "curl") # relative path

# keep track of date you downloaded the data
dateDownloaded <- date()

# general downloading rules
# http = should be ok
# https should be ok, but have to set the method to curl on a mac
# this might take a long time, so maybe don't do this step every time


### loading local files

# you downloaded the table, now need to load it
# read.table() is the best, robust and flexible
# also: read.csv(), read.csv2()

cameraData <- read.table("./data/cameras.csv", sep=",", header=TRUE)


### reading excel files

# package: xlsx
# install.packages("xlsx")
library("xlsx")
?read.xlsx
?read.xlsx2 # faster, but maybe unstable when reading subsets of rows
?write.xlsx
# if you're doing serious excel file processing, XLConnect has more options for reading/manipulating excel files


### reading xml

# widely used in internet applications
# extracting xml is the basis of most web scraping
# components = markup (like tags, elements, attributes) and content

# read the file in
# install.packages("XML")
library(XML)
fileUrl <- "http://thingy.com/simple.xml"
doc <- xmlTreeParse(fileUrl, useInternal=TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names (rootNode) # show the elements

# directly access parts of the xml document
rootNode[[1]]
rootNode[[1]][[1]]

# programmatically extract parts of the file
xmlSApply(rootNode, xmlValue) # will go get every tagged value in the domument

# get more specific with another language, the XPath language


### reading json
# javascript object notation
# lightweight data storage, common for APIs (application program interfaces)

### data.table package
# faster and more memory efficient than data frames
# all functions that accept data.frame accept data.table
# much, much faster at subsetting, group, updating

library(data.table)

# comparison DF and DT

DF = data.frame(x=rnorm(9), y=rep(c("a","b","c"),each=3), z=rnorm(9))
head(DF, 3)

DT = data.table(x=rnorm(9), y=rep(c("a","b","c"),each=3), z=rnorm(9))
head(DT, 3)

# what data.tables do you have currently?
tables()

# subsetting
DT[2,]
# or
DT[DT$y=="a",]

# column subsetting in data.table
# this part is different...
DT[c(2,3)]
# this diverges from data.frame if you want to subset cols:
DT[,c(2,3)]

# calc values for vars with expressions
DT[,list(mean(x),sum(z))]
DT[,table(y)]

# add new cols quickly/mem efficiently
DT[,w:=z^2] # see the := part

#### BE CAREFUL!!!!!
# note that if you want to make a copy if the data table, you have to use a "copy" function, or changing the first data table with change the second one

# multiple operations
DT[,m:={tmp <- (x+z); log2(tmp+5)}]

# plyr like operations
DT[,a:=x>0]
# then
DT[,b:=mean(x+w),by=a] # aggregated mean based on "a" binary variable

# special vars
# .N # count
# does this fast
DT <- data.table(x=sample(letters[1:3], 1E5, TRUE))
DT[,.N, by=x]

# keys is unique to DTs
# subsetting is more rapid
DT <- data.table(x=rep(c("a","b","c"),each=1000), y=rnorm(300))
setkey(DT,x)
DT['a']

# keys can facilitate joins
DT1 <- data.table(x=c("a","a","b","dt1"), y=1:4)
DT2 <- data.table(x=c("a","b","dt2"), z=5:7)
setkey(DT1,x)
setkey(DT2,x)
merge(DT1,DT2) # faster than merging with a data.frame

# fast reading from the disk
big_df <- data.frame(x=rnorm(1E6),y=rnorm(1E6))
file <- tempfile()
write.table(big_df, file=file, row.names=FALSE, col.names = TRUE, sep="\t", quote=FALSE)
# fread is fast, can be used to read in data tables
system.time(fread(file))
# vs. read.table, this is >10x slower
system.time(read.table(file, header=TRUE, sep="\t"))

# data.table package is updating a lot
# website with list of the data.table and data.frame differences: https://stackoverflow.com/questions/13618488/what-you-can-do-with-data-frame-that-you-cant-in-data-table
# CSO saved this stack overflow page as a PDF in the folder for this coursera course: "r - what you can do with....table - Stack Overflow.pdf"


#####################################################################
# Week 1 Quiz

# Q1
getwd() # ok
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./quiz1data.csv", method = "curl") # relative path
dateDownloaded <- date()

quiz1data <- read.table("./quiz1data.csv", sep=",", header=TRUE)

# how many worth more than $1,000,000?
# use VAL variable, category 24 is $1000000+
tmp <- subset(quiz1data, VAL==24)
dim(tmp)[1]
# 53


# Q2
# involved looking at the code book

# Q3
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl, destfile = "./quiz1data_b.xlsx", method = "curl") # relative path
dateDownloaded_b <- date()

library("xlsx")
dat <- read.xlsx("./quiz1data_b.xlsx", sheetIndex=1, rowIndex=18:23, colIndex=7:15)
sum(dat$Zip*dat$Ext,na.rm=T) 

# Q4
library(XML)
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml" # removed s from https
doc <- xmlTreeParse(fileUrl, useInternal=TRUE)
rootNode <- xmlRoot(doc)
rootNode[[1]][[1]][[2]] # gets me a zipcode
# programmatically extract parts of the file (//something with double slash is node at any level)
tmp <- xpathSApply(rootNode, "//zipcode", xmlValue) # will go get every tagged value in the domument
sum(tmp==21231)
# 127

# Q5
getwd() # ok
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = "./quiz1data_c.csv", method = "curl") # relative path
dateDownloaded_c <- date()

# use fread
library(data.table)
DT <- fread("./quiz1data_c.csv")

# check relative speeds
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
system.time({
      mean(DT[DT$SEX==1,]$pwgtp15)
            mean(DT[DT$SEX==2,]$pwgtp15)
      })
system.time(DT[,mean(pwgtp15),by=SEX])
system.time(mean(DT$pwgtp15,by=DT$SEX)) # fast
system.time({rowMeans(DT)[DT$SEX==1]
             rowMeans(DT)[DT$SEX==2]})


# fast reading from the disk
big_df <- data.frame(x=rnorm(1E6),y=rnorm(1E6))
file <- tempfile()
write.table(big_df, file=file, row.names=FALSE, col.names = TRUE, sep="\t", quote=FALSE)
# fread is fast, can be used to read in data tables
system.time(fread(file))
# vs. read.table, this is >10x slower
system.time(read.table(file, header=TRUE, sep="\t"))


quiz1data_c <- read.table("./quiz1data_c.csv", sep=",", header=TRUE)




subset(airquality, Temp > 80, select = c(Ozone, Temp))

if (!file.exists("data")) {
      dir.create("data")
}




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







