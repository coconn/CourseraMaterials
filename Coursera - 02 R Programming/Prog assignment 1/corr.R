# corr.R
# part 3 of the first coursera assignment
# 
# CS O'Connell, UMN EEB/IonE


#####################################################################
# corr

#directory <- "specdata"

corr <- function(directory, threshold = 0) {
      ## 'directory' is a character vector of length 1 indicating
      ## the location of the CSV files
      
      ## 'threshold' is a numeric vector of length 1 indicating the
      ## number of completely observed observations (on all
      ## variables) required to compute the correlation between
      ## nitrate and sulfate; the default is 0
      
      ## Return a numeric vector of correlations
      
      
      # get list of all files in the directory
      pathcomp <- "~/Desktop/Coursework and Resources/Coursework - Yr 5/Coursera - 02 R Programming/Prog assignment 1/"
      pathdir <- paste(pathcomp, directory, sep = "")
      files <- list.files(pathdir, pattern = ".csv")
      
      # initialize vector
      corrs <- c()
      
      # for loop for each file
      for(i in seq_along(files)){ # length of this list of file names
            
            # which file to look at in this loop
            filegetdata <- paste(pathdir, "/", files[i], sep = "")
            
            # load that csv
            stationinfo <- read.csv(filegetdata, stringsAsFactors=FALSE)
            
            # find complete cases
            a <- stationinfo$sulfate
            b <- stationinfo$nitrate
            tmp <- complete.cases(a,b)
            nobstmp <- sum(tmp)
            
            # if complete cases are above the threshold, calc corr
            
            if(nobstmp >= threshold){
                  
                  # calc corr for complete cases
                  tmp <- cor(stationinfo$sulfate, stationinfo$nitrate, use = "na.or.complete")
                  # put into vector
                  corrs <- c(corrs,tmp)
            }
            
            
            
      }
      
      corrs
      
}


# cr <- corr("specdata", 150)
# head(cr)
# summary(cr)
# 
# cr <- corr("specdata", 400)
# head(cr)
# summary(cr)
# 
# cr <- corr("specdata", 5000)
# summary(cr)
# length(cr)
# 
# cr <- corr("specdata")
# summary(cr)
# length(cr)


#source("http://d396qusza40orc.cloudfront.net/rprog%2Fscripts%2Fsubmitscript1.R")
#submit()


