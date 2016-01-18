# read cli params
args <- commandArgs(trailingOnly = TRUE)
path <- args[1]
if (!file.exists(path)) {
        stop("Training set file ", path, " does not exist!")
}
regularize <- as.logical(args[2])
lambda <- 1
if (regularize) {
        lambda <- as.numeric(args[3])
}
scriptPath <- file.path(getwd(), "logisticRegression.R")
source(scriptPath)
model <- logisticRegression(path, regularize, lambda)
message("Computed model parameters: ", paste(model, sep=", ", collapse=", "))
