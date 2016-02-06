# loadTrainingSet loads training set from a file located in path passed in as parameter.
# By default loadTrainingSet treats the file in the provided path as CSV file. 
# You can also specify "matlab" which will read in .mat Matlab file.
# It returns a list that contains features matrix X and measurement vector y.
loadTrainingSet <- function(path, type = "csv") {
        # load the training set from a provided file
        switch(type, 
               "csv" = loadCSVTraingSet(path),
               "matlab" = loadMatlabTraingSet(path)
               )
}

# loads training set from the provided CSV file
loadCSVTraingSet <- function(path) {
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

# loads training set from the provided .mat Matlab file
loadMatlabTraingSet <- function(path) {
        # load R Matlab package
        library(R.matlab)
        # load .mat file from provided file
        data <- readMat(path)
        # return a list that contains features matrix X and measurment vector y
        list("X" = data$X, "y" = data$y)
}
