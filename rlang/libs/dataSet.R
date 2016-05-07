# loadTrainingSet loads data set from a file located in path provided as parameter.
# By default loadTrainingSet treats the file in the provided path as CSV file. 
# You can specify "matlab type which will read in .mat Matlab file.
# There is a support of "png" type which allows to read in PNG image.
# loadTrainingSet returns a list which contains features matrix X and 
# measurement vector y, given that particular data sets are formatted 
# appropriately. When PNG file is loaded in, loadTrainingSet returns 3 dimensional
# matrix representing RGB layers.
loadTrainingSet <- function(path, type = "csv") {
        # load the training set from a provided file
        switch(type, 
               "csv"    = loadCSV(path),
               "matlab" = loadMatlab(path),
               "png"    = loadPNG(path)
               )
}

# loadCSV loads data set from the CSV file located in supplied path
loadCSV <- function(path) {
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

# loadMatlab loads data set from the provided .mat Matlab file in supplied path
loadMatlab <- function(path) {
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
