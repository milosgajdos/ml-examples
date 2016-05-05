# read cli params
args <- commandArgs(trailingOnly = TRUE)
dataPath <- args[1]
if (!file.exists(dataPath)) {
        stop("File ", dataPath, " does not exist!")
}

dataType <- args[2]
if (!(dataType %in% c("csv", "matlab", "png"))) {
        stop("Unsupported data type specified: ", dataType)
}
# Do we need to normalize the features?
normalize <- as.logical(args[3])

# how many principal components do we want to return
pcRet <- as.numeric(args[4])
if (is.na(pcRet)) {
        message("All principal components will be returned!")
} else if (pcRet<0) {
        stop("Number of principal components must be a positive integer: ", pcRet)
}

# compute principal components
scriptPath <- file.path(getwd(), "pca.R")
source(scriptPath)
pcs <- pca(dataPath, dataType, normalize, pcRet)
message("Computed principal components: ", paste(pcs, sep=", ", collapse=", ") )
