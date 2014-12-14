# pollutantmean.R
# part 1 of the first coursera assignment
# 
# CS O'Connell, UMN EEB/IonE


#####################################################################
# pollutantmean

pollutantmean <- function(directory, pollutant, id = 1:332) {
      ## 'directory' is a character vector of length 1 indicating
      ## the location of the CSV files
      
      ## 'pollutant' is a character vector of length 1 indicating
      ## the name of the pollutant for which we will calculate the
      ## mean; either "sulfate" or "nitrate".
      
      ## 'id' is an integer vector indicating the monitor ID numbers
      ## to be used
      
      ## Return the mean of the pollutant across all monitors list
      ## in the 'id' vector (ignoring NA values)
      
      
      #### this is where christine is working
      
      # initialize rbind_allIDS
      rbind_allIDS <- c()
      
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
            
            # extract the pollution values for the column given by pollutant
            tmp <- stationinfo[[pollutant]]
            
            # rbind to rbind_allIDS
            rbind_allIDS <- c(rbind_allIDS, tmp)
            
      }
      
      # calc mean without NAs for rbind_allIDS
      mean(rbind_allIDS, na.rm = TRUE)
      
}


#pollutantmean("specdata", "sulfate", 1:10)
#pollutantmean("specdata", "nitrate", 70:72)
#pollutantmean("specdata", "nitrate", 23)



