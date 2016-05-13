# loadTrainingSet loads training data set from a file located in path provided as parameter.
# By default loadTrainingSet treats the file in the provided path as CSV file.
# You can specify "matlab type which will read in .mat Matlab file.
# There is also support of "png" type which allows to read in PNG image.
# loadTrainingSet returns list that contains training set in matrix X and
# if supervised parameter is set to TRUE, it also returns labels in vector y
# loadTrainingSet accepts the following parameters:
# path - path to training set data
# type - type of training set data (csv, matlab, png)
# supervised - boolean TRUE/FALSE instructs whether training labels are supplied in data set
loadTrainingSet <- function(path, type = "csv", supervised = FALSE) {
        # load the training set from a provided file
        switch(type,
               "csv"    = loadCSV(path, supervised),
               "matlab" = loadMatlab(path, supervised),
               "png"    = loadPNG(path)
               )
}

# loadCSV loads data set from the CSV file located in supplied path
loadCSV <- function(path, supervised) {
        # load CSV file from the filesystem into data frame
        df <- read.table(path, sep=",", stringsAsFactors = FALSE)
        # transform training set data frame into matrix
        ts <- as.matrix(df)
        trainData <- NULL
        # supervised data contains labels vector
        if (supervised) {
                # parse out measurement vector y and features matrix X
                y  <- ts[, ncol(ts)]
                X  <- as.matrix(ts[, 1:ncol(ts)-1])
                # return a list that contains features matrix X and measurment vector y
                trainData <- list("X" = X, "y" = y)
        } else {
                # only measurement data are available
                X <- as.matrix(ts)
                # return a list that contains features matrix X
                trainData <- list("X" = X)
        }
        trainData
}

# loadMatlab loads data set from the provided .mat Matlab file in supplied path
loadMatlab <- function(path, supervised) {
        # load R Matlab package
        if (suppressMessages(!require(R.matlab))) {
          # install R.matlab package if it can't be loaded
          install.packages("R.matlab")
          # load the package library
          suppressMessages(library(R.matlab))
        }
        # load .mat file from provided file
        data <- readMat(path)
        trainSet <- NULL
        if (supervised) {
                # return a list that contains features matrix X and measurment vector y
                trainSet <- list("X" = data$X, "y" = data$y)
        } else {
                trainSet <- list("X" = data$X)
        }
        trainSet
}

# loadPNG reads PNG image from the provided path
loadPNG <- function(path) {
        # load ong package
        if (suppressMessages(!require(png))) {
                # install PNG package if it can't be loaded
                install.packages("png")
                # load the package library
                suppressMessages(library(png))
        }
        # load the PNG file
        img <- readPNG(path)
        # return a list that contains the image file in 3-dimensonal "matrix" X
        list("X" = img, "y"= NULL)
}

# prepData pre-processes training set. It can perform normalization
# or feature mapping if feature mapping function is supplied as parameter
# It can also add a bias unit to your data matrix if requested
prepData <- function(X, normalize = FALSE, mapFunc = NULL, addBias = FALSE){
        # if mapFunc is supplied we will perform feature mapping
        if (!is.null(mapFunc) && is.function(mapFunc)) {
                X <- mapFunc(X)
        }
        # normalize the features matrix X
        if (normalize) {
                X <- scale(X, center = TRUE, scale = TRUE)
        }
        # add bias if requested
        if (addBias) {
                bias <- matrix(rep(1, nrow(X)))
                X <- cbind(bias, X)
        }
        # return features matrix
        return(X)
}
