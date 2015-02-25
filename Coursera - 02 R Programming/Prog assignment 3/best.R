# best.R
# part 1 of the third coursera assignment
# 
# CS O'Connell, UMN EEB/IonE

# working dir / path
#setwd("~/Documents/GITHUB/CourseraMaterials/Coursera - 02 R Programming/Prog assignment 3/")

#pathcomp <- "~/Desktop/Coursework and Resources/Coursework - Yr 5/Coursera - 02 R Programming/Prog assignment 3/"


#####################################################################
# Plot the 30-day mortality rates for heart attack

# nothing to submit for this part, so commented out
# can uncomment with cmd + shift + C
# 
# outcome <- read.csv("rprog-data-ProgAssignment3-data/outcome-of-care-measures.csv", colClasses = "character")
# head(outcome)
# ncol(outcome)
# names(outcome)
# 
# # hist of the 30-day death rates from heart attack (column 11 in the outcome dataset)
# outcome[, 11] <- as.numeric(outcome[, 11])
# # You may get a warning about NAs being introduced; that is okay
# hist(outcome[, 11])


#####################################################################
# best

# to test
# outcome <- "heart failure"
# state <- "TX"

best <- function(state, outcome) {

      ## Read outcome data
      setwd("~/Documents/GITHUB/CourseraMaterials/Coursera - 02 R Programming/Prog assignment 3/")
      df <- read.csv("rprog-data-ProgAssignment3-data/outcome-of-care-measures.csv", na.strings = "Not Available", colClasses = "character")
      df[, 11] <- as.numeric(df[, 11])
      df[, 17] <- as.numeric(df[, 17])
      df[, 23] <- as.numeric(df[, 23])
      
      ## Check that state and outcome are valid
      
      okstates <- unique(df$State)
      okoutcome <- c("heart attack","heart failure","pneumonia")
      # outcome valid?
      outcomename <- ifelse(outcome %in% okoutcome == TRUE, outcome, stop("invalid outcome"))
      # state valid?
      statename <- ifelse(state %in% okstates == TRUE, state, stop("invalid state"))
      
      ## Return hospital name in that state with lowest 30-day death
      ## rate
      
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
      
      # report top performer
      rank <- as.character(comp[[1]])
      rank[1]
      
}



## how to turn in this assignment/get it tested
#source("http://d396qusza40orc.cloudfront.net/rprog%2Fscripts%2Fsubmitscript3.R")
#submit()



# 
# 
# > best("TX", "heart failure")
# [1] "FORT DUNCAN MEDICAL CENTER"
# # ok
# 
# > best("MD", "pneumonia")
# [1] "GREATER BALTIMORE MEDICAL CENTER"
# # ok
# 
# 
# # trials from assignment worksheet
# > best("TX", "heart attack")
# [1] "CYPRESS FAIRBANKS MEDICAL CENTER"
# # OK
# 
# > best("MD", "heart attack")
# [1] "JOHNS HOPKINS HOSPITAL, THE"
# # OK
# 
# > best("BB", "heart attack")
# Error in best("BB", "heart attack") : invalid state
# # ok
# 
# > best("NY", "hert attack")
# Error in best("NY", "hert attack") : invalid outcome
# # ok
# 
# 
# 




# 
# 
# # relevant outcome column
# if(outcomename=="heart attack"){
#       comp$outcome <- as.numeric(dfsubset[, 11])
# } else {
#       if(outcomename=="heart failure"){
#             comp$outcome <- as.numeric(dfsubset[, 17])
#             print("heart failure")
#       } else { # "pneumonia"
#             comp$outcome <- as.numeric(dfsubset[, 23])
#       }
# }
# 
# 
# 
# 
# 
# # hospitals in that state
# dfsubset <- subset(df, State == statename)
# obs <- dim(dfsubset)
# obs <- obs[1]
# 
# # start df
# comp$name <- dfsubset[, 2]
# 
# 
# 
# ## Return hospital name in that state with lowest 30-day death
# ## rate
# 
# # hospitals in that state
# dfsubset <- subset(df, State == statename)
# obs <- dim(dfsubset)
# obs <- obs[1]
# 
# # relevant outcome column
# if(outcomename=="heart attack"){
#       comp$outcome <- as.numeric(dfsubset[, 11])
# } else {
#       if(outcomename=="heart failure"){
#             comp$outcome <- as.numeric(dfsubset[, 17])
#             print("heart failure")
#       } else { # "pneumonia"
#             comp$outcome <- as.numeric(dfsubset[, 23])
#       }
# }
# 
# # remove rows that have no info available
# comp <- subset(comp, comp[,2] != "NA")
# 
# 
# 
# # start comparison matrix
# comp <- matrix(0, nrow = obs, ncol = 3)
# 
# # fill in comparison matrix
# # hospital names
# comp[,1] <- dfsubset[, 2]
# # relevant outcome column
# if(outcomename=="heart attack"){
#       comp[,2] <- as.numeric(dfsubset[, 11])
# } else {
#       if(outcomename=="heart failure"){
#             comp[,2] <- as.numeric(dfsubset[, 17])
#             print("heart failure")
#       } else { # "pneumonia"
#             comp[,2] <- as.numeric(dfsubset[, 23])
#       }
# }
# # remove rows that have no info available
# comp <- subset(comp, comp[,2] != "NA")
# # make sure numeric is ok
# 
# # rank based on who has the lowest 30-day mortality rate for the outcome of interest
# # rank in alph order if there are ties
# comp <- comp[order(comp[,1]),] # alph order FIRST
# comp[, 3] <- as.numeric(comp[, 2])
# comp <- comp[order(comp[,3]),] # THEN outcome order
# 
# # report top performer
# comp[1,1]
# 
# 
# 
