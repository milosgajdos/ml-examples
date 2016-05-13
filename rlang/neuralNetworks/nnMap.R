# read cli params
args <- commandArgs(trailingOnly = TRUE)
trainDataPath <- args[1]
if (!file.exists(trainDataPath)) {
        stop("Training set file ", trainDataPath, " does not exist!")
}

# data type
dataType <- args[2]
if (!(dataType %in% c("csv", "matlab"))) {
        stop("Unsupported data type specified: ", dataType)
}

# do we need to normalize the features?
normalize <- as.logical(args[3])

# source helper scripts
trainScriptPath <- file.path(".", "somNN.R")
libPath <- file.path("..", "libs")
invisible(sapply(c(list.files(path=libPath, full.names = TRUE),
                   trainScriptPath), source))
# train NN SOM
#som <- somNN(trainDataPath, dataType, normalize, mapUnits = 100)
som <- somNN(trainDataPath, dataType, normalize, mapInit = "random")
som
