# Coursera-getting-data-week2.R
# 
# where I work through coursera getting data stuff from week 2
# 
# CS O'Connell, UMN EEB/IonE



#####################################################################
# Week 2 Lectures

### mySQL

install.packages("RMySQL")
library(RMySQL)

# practice using a USCS genoma database
ucscDb <- dbConnect(MySQL(), user="genome", host="genome-mysql.cse.ucsc.edu")
# "show databases;" isn't an R command, it's a mySQL command we're sending in
# dbDisconnect returns TRUE
result <- dbGetQuery(ucscDb, "show databases;"); dbDisconnect(ucscDb)

# get a specific database
hg19 <- dbConnect(MySQL(), user="genome", db="hg19", host="genome-mysql.cse.ucsc.edu")
# look at the tables in that database
allTables <- dbListTables(hg19)
length(allTables) # we can store a ton of stuff this way
allTables[1:5]

# check out the fields in a particular table
dbListFields(hg19, "affyU133Plus2")

#pass another mySQL comment using dbGetQuery
dbGetQuery(hg19, "select count(*) from affyU133Plus2")

# get a table out
# data is now extracted from that server
affyData <- dbReadTable(hg19, "affyU133Plus2")
head(affyData)

# be careful with tables that are too big
# select a subset of the data
# you can send any query with dbSendQuery (see mySQL documentation)
query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3")
affyMis <- fetch(query); quantile(affyMis$misMatches)
# need to clear the query from the mySQL server using dbClearResult (returns TRUE)
affyMisSmall <- fetch(query, n=10); dbClearResult(query)

# remember to close the connection!!!
dbDisconnect(hg19)

# be very careful with mySQL commands!!! 
# never push anything back into the server (only use the select command)


### HDF5

# used for storing large or structured datasets (HDF = hierarchical data format)

# install through bioconductor
# these packaged are mostly for genomics, but also good for "big data"
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")

# create a file
library(rhdf5)
created = h5createFile("example.h5")
created

# can create groups
created = h5createGroup("example.h5", "foo")
created = h5createGroup("example.h5", "baa")
created = h5createGroup("example.h5", "foo/foobaa")
h5ls("example.h5")

# write to groups
A = matrix(1:10, nr=5, nc=2)
h5write(A, "example.h5", "foo/A")
B = array(seq(0.1,2.0,by=0.1),dim=c(5,2,2))
attr(B,"scale") <- "liter"
h5write(B, "example.h5", "foo/foobaa/B")
h5ls("example.h5")

# write a dataset directly to the top level group
df = data.frame(1L:5L, seq(0,1,length.out=5), c("ab","cde","fghi","a","s"), stringsAsFactors=FALSE)
h5write(df, "example.h5", "df")

# read data to get data out
readA = h5read("example.h5", "foo/A")
readA

# read/write in chunks
h5write(c(12,13,14), "example.h5", "foo/A",index=list(1:3,1)) # write to the first three rows, first column
h5read("example.h5", "foo/A") # stuck 12, 13, 14 into the first slots


### reading data from the web

# webscraping = extract data from HTML code of websites

con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)
htmlCode # comes out unformatted

# instead use XML package
library(XML)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html <- htmlTreeParse(url, useInternalNodes=T)
xpathSApply(html,"//title", xmlValue)
xpathSApply(html,"//td[@class='gsc_a_c']", xmlValue)

# GET from the httr package
install.packages("httr")
library(httr)
url <- "http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en"
html2 <- GET(url)
content2 <- content(html2,as="text")
parsedHtml <- htmlParse(content2,asText=TRUE)
xpathSApply(parsedHtml,"//title", xmlValue)

# using website passwords
pg1 = GET("http://httpbin.org/basic-auth/user/passwd")
pg1
# requires password, so use authenticate
pg2 = GET("http://httpbin.org/basic-auth/user/passwd", authenticate("user","passwd"))
pg2
names(pg2)

# using handles
google <- handle("http://google.com")
# authenticate this handle one time, and you won't need to again
pg1 = GET(handle=google,path="/")
pg2 = GET(handle=google,path="search")

# r bloggers has tons of web scraping examples


### APIs

# often have to first make a developer account

# accessing twitter from R
library(httr)
myapp <- oauth_app("twitter", key="yourconsumerkey", secret="yourconsumersecret")
sig <- sign_oath1.0(myapp, token="yourtoken",tocken_secret="yourtokensecret")
homeTL <- GET("https://api.twitter.com/1.1/statuses/home_timeline.json",sig) # from "resource URL"

json1 <- content(homeTL)
json2 <- jsonlite::fromJSON(toJSON(json1)) #reformat what came back
json2[1,1:4]

# go to the API documentation to figure out how to get info that isn't just from your own timeline


### reading from other sources

# some other useful R packages
# google "data storage type NAME R package" if you're looking for something

# interact directly with files
# url, file, gzfile, bzfile
?connections
# remember to close connections!!!!

# foreign package
# if you need to look at things from other languages (SPSS, State, etc.)

# other database packages are out there if needed
      
# read images
# jpeg, png, readbitmap

# read GIS data
# rdgal, rgeos, raster



#####################################################################
# Week 2 Quiz

# Q1

#install.packages("httpuv")
library(httpuv)

# much of this code is from: https://github.com/hadley/httr/blob/master/demo/oauth2-github.r

library(httr)
# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. Register an application at https://github.com/settings/applications;
#    Use any URL you would like for the homepage URL (http://github.com is fine)
#    and http://localhost:1410 as the callback url
#
#    Insert your client ID and secret below - if secret is omitted, it will
#    look it up in the GITHUB_CONSUMER_SECRET environmental variable.
myapp <- oauth_app("github", "af98707cdca750a54110", secret = "ca1dd4b679d5ae7510cc8a915ac34bd76b7cf083")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp, cache = FALSE)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
raw_result <- content(req)
# stopped using the hadley code here

# need to convert req into getting the stuff we want
tmp <- str(raw_result) # ok, this is json data
# let's use an appropriate JSON package
library(jsonlite)
jsoned <- fromJSON(toJSON(raw_result))

# extract the data of choice
names(jsoned)
# use "created_at"
jsoned$created_at[jsoned$name == "datasharing"]
# "2013-11-07T13:25:07Z"



# Q2

# install.packages("sqldf")
library(sqldf)

getwd()
acs <- read.table("./getdata-data-ss06pid.csv", sep=",", header=TRUE)

tmp <- sqldf("select pwgtp1 from acs where AGEP < 50")
head(tmp)


# Q3

sqldf("select distinct AGEP from acs")
# works


# Q4

con = url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode = readLines(con)
close(con)
htmlCode # this time it has line numbers

nchar(htmlCode[10])
nchar(htmlCode[20])
nchar(htmlCode[30])
nchar(htmlCode[100])

# 45 31 7 25


# Q5

getwd()
tab <- read.fwf("./getdata-wksst8110.for", widths=c(10,-5,4,4,-5,4,4,-5,4,4,-5,4,4), skip = 4)
tmp <- tab$V4
class(tmp)
sum(tmp)
# 32426.7

# example from the message board
# read.fwf("fix.txt", widths=c(2,2,2,2,2))
# read.fwf("fix.txt", widths=c(2,2,2))
# read.fwf("fix.txt", widths=c(5,5))
# read.fwf("fix.txt", widths=c(-3,2,-3,2))
# read.fwf("fix.txt", widths=c(3,4,3))





