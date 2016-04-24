# read cli params
args <- commandArgs(trailingOnly = TRUE)
path <- args[1]
if (!file.exists(path)) {
        stop("Training set file ", path, " does not exist!")
}
# data type
dataType <- args[2]
if (!(dataType %in% c("csv", "matlab", "png"))) {
        stop("Unsupported data type specified: ", dataType)
}
# do we need feature normalizing?
normalize <- as.logical(args[3])
# do we want to regularize the regression?
regularize <- as.logical(args[4])
lambda <- 1
if (regularize) {
        lambda <- as.numeric(args[5])
}
scriptPath <- file.path(getwd(), "logisticRegression.R")
source(scriptPath)
model <- logisticRegression(path, dataType, normalize, regularize, lambda)
message("Computed model parameters: ", paste(model, sep=", ", collapse=", "))
