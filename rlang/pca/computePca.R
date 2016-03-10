# read cli params
args <- commandArgs(trailingOnly = TRUE)
path <- args[1]
if (!file.exists(path)) {
        stop("File ", path, " does not exist!")
}

# compute principal components
scriptPath <- file.path(getwd(), "pca.R")
source(scriptPath)
pcComp <- pca(path)
# print matrix X for now
pcComp
