# read cli params
args <- commandArgs(trailingOnly = TRUE)
# path to training data set
trainDataPath <- args[1]
if (!file.exists(trainDataPath)) {
        stop("File ", trainDataPath, " does not exist!")
}
# data type
dataType <- args[2]
if (!(dataType %in% c("csv", "matlab", "png"))) {
        stop("Unsupported data type specified: ", dataType)
}
# do we need to normalize the features?
normalize <- as.logical(args[3])
# gradient descent step
alpha <- as.numeric(args[4])
if (alpha<0) {
        stop("Alpha [gradient descent step] must be non-negative float number")
}
# number of gradient descent iterations
iters <- as.integer(args[5])
if (iters<0) {
        stop("Number of iterations must be a positive integer: ", iters)
}
# compute model parameters
scriptPath <- file.path(".", "linearRegression.R")
source(scriptPath)
model <- linearRegression(trainDataPath, dataType, normalize, linRegCostFunc, alpha, iters)
message("Computed model parameters: ", paste(model, sep=", ", collapse=", "))
