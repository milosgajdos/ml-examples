# read cli params
args <- commandArgs(trailingOnly = TRUE)
path <- args[1]
if (!file.exists(path)) {
        stop("File ", path, " does not exist!")
}
alpha <- as.numeric(args[2])
if (alpha<0) {
        stop("Alpha must be non-negative float number")
}
iters <- as.integer(args[3])
if (iters<0) {
        stop("Number of iterations must be a positive integer: ", iters)
}
normalize <- as.logical(args[4])
# compute model parameters
scriptPath <- file.path(getwd(), "linearRegression.R")
source(scriptPath)
model <- linearRegression(path, alpha, iters, normalize)
message("Computed model parameters: ", paste(model, sep=", ", collapse=", "))
