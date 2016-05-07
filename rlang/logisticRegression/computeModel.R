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
# load logisticRegression R script
scriptPath <- file.path(".", "logisticRegression.R")
source(scriptPath)
if (is.na(lambda)) {
        costFunc <- lrCostFunc
        gradFunc <- lrGradFunc
} else {
        costFunc <- lrCostRegFunc
        gradFunc <- lrGradRegFunc
}
# compute model parameters
model <- logisticRegression(trainDataPath, dataType, normalize,
                           lambda, costFunc, gradFunc)
message("Computed model parameters: ", paste(model, sep=", ", collapse=", "))
