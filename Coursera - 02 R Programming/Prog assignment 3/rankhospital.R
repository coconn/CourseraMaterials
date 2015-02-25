# rankhospital.R
# part 2 of the third coursera assignment
# 
# CS O'Connell, UMN EEB/IonE


#####################################################################
# rankhospital

# to test
#outcome <- "heart failure"
#state <- "TX"
#num <- 5

rankhospital <- function(state, outcome, num = "best") {
      
      ## Read outcome data
      setwd("~/Documents/GITHUB/CourseraMaterials/Coursera - 02 R Programming/Prog assignment 3/")
      df <- read.csv("rprog-data-ProgAssignment3-data/outcome-of-care-measures.csv", na.strings = "Not Available", colClasses = "character")
      df[, 11] <- as.numeric(df[, 11])
      df[, 17] <- as.numeric(df[, 17])
      df[, 23] <- as.numeric(df[, 23])
      
      
      ## Check that state, outcome and num are valid
      okstates <- unique(df$State)
      okoutcome <- c("heart attack","heart failure","pneumonia")
      oknum <- c("best","worst")
      
      # state valid?
      statename <- ifelse(state %in% okstates == TRUE, state, stop("invalid state"))
      
      # outcome valid?
      outcomename <- ifelse(outcome %in% okoutcome == TRUE, outcome, stop("invalid outcome"))
      
      # number valid?
      num <- ifelse(is.numeric(num)==FALSE && num %in% oknum==FALSE, stop("invalid number"), num)
      
      
      ## Return hospital name in that state with the given rank 30-day death rate
      
      # cut down df to only hospitals in that state
      df <- subset(df, State == statename)
      
      # which outcome do we care about here?
      if(outcomename=="heart attack"){
            tmp <- c(11)
      } else {
            if(outcomename=="heart failure"){
                  tmp <- c(17)
            } else { # "pneumonia"
                  tmp <- c(23)
            }
      }
      
      # put that outcome column into a new dataframe with hosp name
      comp <- data.frame(df$Hospital.Name, (df)[[tmp]])
      
      # remove rows that have no info available
      comp <- subset(comp, comp[[2]] != "NA")
      # is.numeric(comp[[2]])
      
      # rank based on who has the lowest 30-day mortality rate for the outcome of interest
      # rank in alph order if there are ties
      comp <- comp[order(comp[[1]]),] # alph order FIRST
      comp <- comp[order(comp[[2]]),] # THEN outcome order
      
      # which performer to report?
      obs <- dim(comp)
      obs <- obs[1]
      
      if(num=="best"){
            num <- c(1)
      } else {
            if(num=="worst"){
                  num <- obs
            } else {
                  if(num>obs){
                        num <- c("NA")
                  }
            }
      }
      
      
      # report top performer
      rank <- as.character(comp[[1]])
      rank[num]
      
}





## how to turn in this assignment/get it tested
#source("http://d396qusza40orc.cloudfront.net/rprog%2Fscripts%2Fsubmitscript3.R")
#submit()


# test practice 

# > source("rankhospital.R")
# > rankhospital("TX", "heart failure", 4)
# [1] "DETAR HOSPITAL NAVARRO"
# > rankhospital("MD", "heart attack", "worst")
# [1] "HARFORD MEMORIAL HOSPITAL"
# > rankhospital("MN", "heart attack", 5000)
# [1] NA


