# trainingSet loads training set from a CSV file in path passed in as parameter
# It returns a list that contains features matrix X and measurement vector y
trainingSet <- function(path) {
        # read the training set data into a data frame
        df <- read.table(path, sep=",", 
                      stringsAsFactors = FALSE)
        # transform training set data frame into matrix
        ts <- as.matrix(df)
        # parse out measurement vector y and features matrix X
        y  <- ts[, ncol(ts)]
        X  <- as.matrix(ts[, 1:ncol(ts)-1])
        # return a list that contains features matrix X and measurment vector y
        list("X" = X, "y" = y)
}
