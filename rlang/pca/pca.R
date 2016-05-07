# pca computes principal components for the data loaded from the file
# located in a path passed in as a parameter. By default the data
# is considered to be "matlab" formatted. You can override this.
# pca returns a specified number of PCA vectors and accepts following parameters
# dataPath  - path to the analysed data
# dataType  - type of the data set file (matlab,csv,png)
# normalize - boolean to request feature normalizing
# pcRet     - non negative integer that specify the number of PCA components to be returned
pca <- function(dataPath, dataType = "matlab", normalize = FALSE, pcRet = NA) {
        # load all supporting library scripts into R environment
        libPath <- file.path("..", "libs")
        invisible(sapply(list.files(path=libPath, full.names = TRUE), source))
        # load data set
        message("Loading data set: ", dataPath)
        dataSet <- loadTrainingSet(dataPath, dataType)
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

# plotRunnerData plots raw, regressed and mean centered runner's data
# data - matrix of raw data
plotRunnerData <- function(data) {
        # parse out x and y values
        x <- data[,1]
        y <- data[,2]
        # mean center raw data
        mcData <- scale(data, scale=FALSE)
        # we will draw two plots on one frame
        par(mfrow=c(1,3))
        # raw runnner data
        plot(x, y, main = "Runner's Data", xlab="x", ylab="y", 
             xlim = c(0,7), ylim = c(0,8), pch=16, col="blue")
        # raw runner data with trajectory regression
        plot(x, y, main = "Runner's Trajectory", xlab="x", ylab="y", 
             xlim = c(0,7), ylim = c(0,8), pch=16, col="blue")
        abline(lm(y~x), lwd = 3)
        # plot mean centered data
        plot(mcData[,1], mcData[,2], main = "Mean Centered Data", xlab="x", ylab="y",
             xlim = c(-3,7), ylim = c(-3,8), pch=16, col="blue")
        abline(v=0,h=0)
}

# draws the eigenvector regression lines over mean centered data
# data        - matrix of raw data
# eigenMatrix - matrix that contains covariance matrix eigenvectors in its columns
plotRunnerEig <- function(data, eigenVectors, eigenValues) {
        # mean center raw data
        mcData <- scale(data, scale=FALSE)
        # extract eigenvectors
        vec1 <- c(eigenVectors[, 1])
        vec2 <- c(eigenVectors[, 2])
        # extract eigenvalues
        val1 <- eigenValues[1]
        val2 <- eigenValues[2]
        # plot mean centered data
        par(mfrow=c(1,1))
        plot(mcData[,1], mcData[,2], main = "Eigenvector regressions over mean centered data", 
             xlab="x", ylab="y", pch=16, col="blue", asp = 1)
        # overlay the eigenvector regression lines
        abline(b=(vec1[2]/vec1[1]), a=0, lty=3, lwd = 3, col="red")
        abline(b=(vec2[2]/vec2[1]), a=0, lty=2, lwd = 3, col="red")
        # overaly eigenvectors
        arrows(0,0, val1*v1[1], val1*v1[2], col="red", lwd=4)
        arrows(0,0, val2*v2[1], val2*v2[2], col="red", lwd=4)
        # plot legend
        legend("topleft", c("[-0.7690815, -0.6391507]", "[0.6391507, -0.7690815]"), 
               lty=c(3,2), col="red")
}

# draw original and transformed (rotated) data
# data         - matrix of raw data
# eigenVectors - eigenvectors of covariance matrix
plotRunnerTransform <- function(data, eigenVectors){
        # mean center raw data
        mcData <- scale(data, scale=FALSE)
        # trasnform/rotate data
        trData <- (mcData %*% eigenVectors)
        # plot original mean centered data
        par(mfrow=c(1,2))
        plot(mcData[,1], mcData[,2], main = "Original mean centered data", xlab="x", ylab="y", 
             xlim = c(-3,3), ylim = c(-3,3), pch=16, col="blue", asp = 1)
        abline(v=0, h=0)
        # plot the rotated data
        plot(trData[,1], trData[,2], main = "Transformed data", xlab="x", ylab="y", 
             xlim = c(-3,3), ylim = c(-3,3), pch=16, col="blue", asp = 1)
        abline(v=0, h=0)
}

# draw original and reconstructed data
# data         - matrix of raw data
# eigenVectors - eigenvectors of covariance matrix
plotRunnerReconstr <- function(data, eigenVectors){
        # mean center raw data
        mcData <- scale(data, scale=FALSE)
        # trasnform/rotate data
        trData <- (mcData %*% eigenVectors)
        # reconstruct the data using only TOP most principal component
        reconData <- trData[,1] %*% t(eigenVectors[,1])
        # plot the data
        par(mfrow=c(1,2))
        plot(mcData[,1], mcData[,2], main = "Mean Centered Data", xlab="x", ylab="y", 
             xlim = c(-3,3), ylim = c(-3,3), pch=16, col="blue", asp = 1)
        abline(h=0,v=0)
        # plot the reduced reconstructed data
        plot(reconData[,1], reconData[,2], main = "Reconstructed from reduced data", xlab="x", 
             ylab="y", xlim = c(-3,3), ylim = c(-3,3), pch=16, col="blue", asp = 1)
        abline(h=0,v=0)
}

readFaceImg <- function(imagePath) {
        if (suppressMessages(!require(png))) {
                # install png package if you can't load it
                install.packages("png")
                # load png library
                suppressMessages(library(png))
        }
        # read the image in
        img <- readPNG(imagePath)
        # we will only use R layer from RGB
        face <- t(img[,,1])[,nrow(img):1]
        face
}

# plot face image from file
# imagePath - path to PNG image file
plotFaceImage <- function(imagePath) {
        face <- readFaceImg(imagePath)
        # display image
        image(face)
}

# plot information retention per principal component
# imagePath - path to PNG image
plotVarianceRetained <- function(imagePath) {
        face <- readFaceImg(imagePath)
        # scale image pixels
        faceScale <- scale(face, scale=FALSE)
        # calculate covariance matrix
        faceCov <- cov(faceScale)
        # calculate SVD
        faceSVD <- svd(faceCov)
        # plot information retention per principal component
        plot(faceSVD$d^2/sum(faceSVD$d^2), main = "Proportion of retained information per principal component", 
             xlab = "Principal Components", ylab = "Variance retained", pch = 19)
}

# plot compressed images reconstructed from various number of principal components
# imagePath - path to PNG image file
plotFaceCompressed <- function(imagePath) {
        face <- readFaceImg(imagePath)
        # scale image pixels
        faceScale <- scale(face, scale=FALSE)
        # calculate covariance matrix
        faceCov <- cov(faceScale)
        # eigenvectors
        faceEig <- eigen(faceCov)
        # transformed/rotated image
        faceTrans <- faceScale %*% faceEig$vectors
        # chosen compression dimensions
        comprDims <- c(1, 7, 100)
        # we will be plotting 4 images
        par(mfrow=c(1,4))
        for (i in comprDims) {
                comprImg <- faceTrans[,1:i] %*% t(faceEig$vectors[,1:i])
                image(comprImg, main = paste(i, "principal components"))
        }
        # draw the original image
        image(face, main = "Original image")
}
