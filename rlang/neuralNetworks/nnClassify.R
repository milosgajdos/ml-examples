# read cli params
args <- commandArgs(trailingOnly = TRUE)
trainDataPath <- args[1]
if (!file.exists(trainDataPath)) {
        stop("Training set file ", trainDataPath, " does not exist!")
}

# data type
dataType <- args[2]
if (!(dataType %in% c("csv", "matlab", "png"))) {
        stop("Unsupported data type specified: ", dataType)
}

# do we need to normalize the features?
normalize <- as.logical(args[3])

# do we want to regularize the regression?
lambda <- as.numeric(args[4])

# source helper scripts
trainScriptPath <- file.path(".", "trainNN.R")
libPath <- file.path("..", "libs")
invisible(sapply(c(list.files(path=libPath, full.names = TRUE), 
                   trainScriptPath), source))

# train neural network
nNet <- trainNN("backprop", trainDataPath, dataType, normalize, lambda)
# validate accuracy
trainingSet <- loadTrainingSet(trainDataPath, dataType)
X <- trainingSet$X
y <- trainingSet$y
message("Neural Network classification accuracy: ", 
        validateNN(nNet$theta1, nNet$theta2, X, y))
