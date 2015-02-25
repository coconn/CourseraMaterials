# rankall.R
# part 3 of the third coursera assignment
# 
# CS O'Connell, UMN EEB/IonE


#####################################################################
# Ranking hospitals in all states
# rankhospital

# to test
#outcome <- "heart failure"
#num <- c("best")

rankall <- function(outcome, num = "best") {
      
      ## Read outcome data
      setwd("~/Documents/GITHUB/CourseraMaterials/Coursera - 02 R Programming/Prog assignment 3/")
      df <- read.csv("rprog-data-ProgAssignment3-data/outcome-of-care-measures.csv", na.strings = "Not Available", colClasses = "character")
      df[, 11] <- as.numeric(df[, 11])
      df[, 17] <- as.numeric(df[, 17])
      df[, 23] <- as.numeric(df[, 23])
      
      
      ## Check that state and num are valid
      okoutcome <- c("heart attack","heart failure","pneumonia")
      oknum <- c("best","worst")
      
      # outcome valid?
      outcomename <- ifelse(outcome %in% okoutcome == TRUE, outcome, stop("invalid outcome"))
      
      # number valid?
      num <- ifelse(is.numeric(num)==FALSE && num %in% oknum==FALSE, stop("invalid number"), num)
      
      
      ## For each state, find the hospital of the given rank
      okstates <- unique(df$State)
      
      # data frame for report
      report = data.frame(hospital = character(length(okstates)), state = character(length(okstates)), stringsAsFactors = FALSE)
      
      for(i in 1:length(okstates)) {
            
            ## this is where rank hospital stuff goes
            
            # what state for this loop?
            statename <- okstates[i]
            
            # cut down df to only hospitals in that state
            dfloop <- subset(df, State == statename)
            
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
            comp <- data.frame(dfloop$Hospital.Name, (dfloop)[[tmp]])
            
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
                  numtmp <- c(1)
            } else {
                  if(num=="worst"){
                        numtmp <- obs
                  } else {
                        if(num>obs){
                              numtmp <- c("NA")
                        } else {
                              numtmp <- num
                        }
                  }
            }
            
            # report performer requested and put into dataframe
            # get rank list
            rank <- as.character(comp[[1]])
            # name
            report$hospital[i] <- rank[numtmp]
            # state
            report$state[i] <- statename
            
            # make sure I'm going along ok
            #print(i)
            #print(statename)
            
            # remove vars
            #remove()
            
      }
      
      ## Return a data frame with the hospital names and the (abbreviated) state name
      # alph order
      report <- report[order(report$state),]
      # only two cols
      
      # then return the report
      report
      
}


# to submit
#source("http://d396qusza40orc.cloudfront.net/rprog%2Fscripts%2Fsubmitscript3.R")
#submit()



# 
# head(rankall("heart attack", 20), 10)
# # hospital state
# # <NA>    AK
# # D W MCMILLAN MEMORIAL HOSPITAL    AL
# # ARKANSAS METHODIST MEDICAL CENTER    AR
# # AZ JOHN C LINCOLN DEER VALLEY HOSPITAL    AZ
# # AK AL AR
# # CA
# # CO
# # CT
# # DC
# # DE
# # FL
# # SHERMAN OAKS HOSPITAL    CA
# # SKY RIDGE MEDICAL CENTER    CO
# # MIDSTATE MEDICAL CENTER    CT
# # <NA>    DC
# # <NA>    DE
# # SOUTH FLORIDA BAPTIST HOSPITAL    FL
# > tail(rankall("pneumonia", "worst"), 3)
# # hospital state
# # WI MAYO CLINIC HEALTH SYSTEM - NORTHLAND, INC    WI
# # WV                     PLATEAU MEDICAL CENTER    WV
# # WY           NORTH BIG HORN HOSPITAL DISTRICT    WY
# > tail(rankall("heart failure"), 10)
# # hospital state
# # TN                         WELLMONT HAWKINS COUNTY MEMORIAL HOSPITAL    TN
# # TX                                        FORT DUNCAN MEDICAL CENTER    TX
# # UT VA SALT LAKE CITY HEALTHCARE - GEORGE E. WAHLEN VA MEDICAL CENTER    UT
# # VA
# # VI
# # VT
# # WA
# # WI
# # WV
# # WY
# # SENTARA POTOMAC HOSPITAL    VA
# # GOV JUAN F LUIS HOSPITAL & MEDICAL CTR    VI
# # SPRINGFIELD HOSPITAL    VT
# # HARBORVIEW MEDICAL CENTER    WA
# # AURORA ST LUKES MEDICAL CENTER    WI
# # FAIRMONT GENERAL HOSPITAL    WV
# # CHEYENNE VA MEDICAL CENTER    WY
# # 
# 
# 
