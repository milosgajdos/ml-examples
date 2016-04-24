# pca computes principal components for the data loaded from the file
# located in a path passed in as a parameter. By default the data
# is considered "matlab" type. You can override it
pca <- function(path, dataType = "matlab", normalize = FALSE, pcRet = NA) {
        # paths to supporting scripts
        dataSetPath <- file.path(getwd(), "..", "dataSet", "dataSet.R")
        featureNormPath <- file.path(getwd(), "..", "helpers", "featureNormalize.R")
        envScripts <- c(dataSetPath, featureNormPath)
        # load all supporting R scripts into R environment
        # suppress all the output from script sourcing
        invisible(sapply(envScripts, source))
        # load data set
        message("Loading data set: ", path)
        dataSet <- loadDataSet(path, dataType)
        X <- as.matrix(dataSet$X)
        # mean center and normalize
        X <- scale(X, scale=normalize)
        # calculate covariance matrix
        covX <- cov(X)
        # calculate eigenvectors and eigenvalues
        # eigen() orders them from largest to smallest
        eigX <- eigen(covX)
        # split PCA vector matrix by columns to list
        pcs <- split(eigX$vectors, rep(1:ncol(eigX$vectors), each = nrow(eigX$vectors)))
        if (!is.na(pcRet)) {
                return(pcs[1:pcRet])
        }
        return(pcs)
}

# draws the eigenvector regression lines over mean centered data
#eigenPlot <- function(data, eigenMatrix) {
#        # extract eigenvectors
#        v1 <- c(eigenMatrix[, 1])
#        v2 <- c(eigenMatrix[, 2])
#        # plot mean centered data
#        plot(data[,1], data[,2], main = "Eigenvector regressions over mean centered data", 
#             xlab="x", ylab="y", pch=16, col="blue", asp = 1)
#        # overlay the eigenvector regression lines
#        abline(b=(v1[2]/v1[1]), a=0, lty=3, lwd = 3, col="red")
#        abline(b=(v2[2]/v2[1]), a=0, lty=2, lwd = 3, col="red")
#        # plot legend
#        legend("topleft", c("[-0.7690815, -0.6391507]", "[0.6391507, -0.7690815]"), 
#               lty=c(3,2), col="red")
#}

# reconstruct the data
#reconstruct <- function(){
#}
