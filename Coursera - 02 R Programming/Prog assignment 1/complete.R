# complete.R
# part 2 of the first coursera assignment
# 
# CS O'Connell, UMN EEB/IonE


#####################################################################
# complete

#directory <- "specdata"

complete <- function(directory, id = 1:332) {
      ## 'directory' is a character vector of length 1 indicating
      ## the location of the CSV files
      
      ## 'id' is an integer vector indicating the monitor ID numbers
      ## to be used
      
      ## Return a data frame of the form:
      ## id nobs
      ## 1  117
      ## 2  1041
      ## ...
      ## where 'id' is the monitor ID number and 'nobs' is the
      ## number of complete cases
      
      
      
      
      #### this is where christine is working
      
      # initialize nobsreport dataframe
      numrows <- length(id)
      f <- matrix(0,numrows,2)
      colnames(f) <- c("id","nobs")
      nobsreport <- as.data.frame(f)
       
      # get list of all files in the directory
      pathcomp <- "~/Desktop/Coursework and Resources/Coursework - Yr 5/Coursera - 02 R Programming/Prog assignment 1/"
      pathdir <- paste(pathcomp, directory, sep = "")
      files <- list.files(pathdir, pattern = ".csv")
      
      # get list of file names that "go with" the id numbers given by user
      filesthistime <- files[id]
      
      # for loop for each file
      for(i in seq_along(filesthistime)){ # length of this list of file names
            
            # which file to look at in this loop
            filegetdata <- paste(pathdir, "/", filesthistime[i], sep = "")
            
            # load that csv
            stationinfo <- read.csv(filegetdata, stringsAsFactors=FALSE)
            
            # where are both sulfate and nitrate complete?
            
            a <- stationinfo$sulfate
            b <- stationinfo$nitrate
            tmp <- complete.cases(a,b)
                  
            # count those cases and note ID number
            nobstmp <- sum(tmp)
            idtmp <- stationinfo$ID[1]
            
            # new row in nobsreport
            nobsreport$id[i] <- idtmp
            nobsreport$nobs[i] <- nobstmp
            
      }
      
      nobsreport
      
}


complete("specdata", 1)
complete("specdata", c(2, 4, 8, 10, 12))
complete("specdata", 30:25)
complete("specdata", 3)


source("http://d396qusza40orc.cloudfront.net/rprog%2Fscripts%2Fsubmitscript1.R")
submit()


