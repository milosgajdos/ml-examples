# loadDataSet loads data set from a file located in path provided as parameter.
# By default loadDataSet treats the file in the provided path as CSV file. 
# You can also specify "matlab" type which will read in .mat Matlab file.
# loadDataSet returns a list which contains features matrix X and 
# measurement vector y.
loadDataSet <- function(path, type = "csv") {
        # load the training set from a provided file
        switch(type, 
               "csv"    = loadCSVDataSet(path),
               "matlab" = loadMatlabDataSet(path)
               )
}

# loadCSVDataSet loads data set from the provided CSV file
loadCSVDataSet <- function(path) {
        # load CSV file from the filesystem into data frame
        df <- read.table(path, sep=",", stringsAsFactors = FALSE)
        # transform training set data frame into matrix
        ts <- as.matrix(df)
        # parse out measurement vector y and features matrix X
        y  <- ts[, ncol(ts)]
        X  <- as.matrix(ts[, 1:ncol(ts)-1])
        # return a list that contains features matrix X and measurment vector y
        list("X" = X, "y" = y)
}

# loadMatlabDataSet loads data set from the provided .mat Matlab file
loadMatlabDataSet <- function(path) {
        # load R Matlab package
        if (suppressMessages(!require(R.matlab))) { 
          # install R.matlab package if it can't be loaded
          install.packages("R.matlab") 
          # load the package library
          suppressMessages(library(R.matlab))
        }
        # load .mat file from provided file
        data <- readMat(path)
        # return a list that contains features matrix X and measurment vector y
        list("X" = data$X, "y" = data$y)
}
