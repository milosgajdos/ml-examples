# pca computes principal components for the data loaded from the file
# located in a path passed in as a parameter
pca <- function(path) {
        # paths to supporting scripts
        dataSetPath <- file.path(getwd(), "..", "dataSet", "dataSet.R")
        scriptPaths <- c(dataSetPath)
        # load all supporting R scripts into R environment
        # suppress all the output from script sourcing
        invisible(sapply(scriptPaths, source))
        # load data set
        message("Loading data set: ", path)
        ds <- loadDataSet(path, type="matlab")
        as.matrix(ds$X)
}
