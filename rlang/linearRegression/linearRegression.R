# linearRegression calculates model parameters for a training set available in a path passed in
# as argument for a given gradient descent step and number of iterations
# It returns computed model parameters vector
linearRegression <- function(path, dataType = "csv", normalize = FALSE, 
                             alpha, iters) {
        # paths to supporting scripts
        traininSetPath  <- file.path(getwd(), "..", "dataSet", "dataSet.R")
        featureNormPath <- file.path(getwd(), "..", "helpers", "featureNormalize.R")
        gradDescentPath <- file.path(getwd(), "..", "gradientDescent", "gradientDescent.R")
        scriptPaths <- c(traininSetPath, featureNormPath, gradDescentPath)
        # load all supporting R scripts into R environment
        invisible(sapply(scriptPaths, source))
        # load model training set
        message("Loading training set: ", path)
        ts = loadDataSet(path, dataType)
        # normalize the features matrix X
        if (normalize) {
                message("Normalizing features matrix")
                # we could also use scal(0 function here
                normOut <- featureNormalize(ts$X)
                X <- normOut$X
        } else {
                X <- ts$X
        }
        # add intercept feature to features matrix
        intercept <- matrix(rep(1, nrow(X)))
        X <- cbind(intercept, X)
        y <- ts$y
        # run gradient descent to compute model parameters
        message("Running gradient descent for alpha=", alpha, " iterations=", iters)
        initTheta <- rep(0, ncol(X))
        gdOut <- gradientDescent(X, y, initTheta, alpha, iters, costFunc)
        gdOut$theta
}

# costFunc returns gradient descent cost for given features matrix, measurement and model
# It accepts 3 parameters as arguments:
# X - features matrix
# y - measurement vector
# theta - model parameters
costFunc <- function(X, y, theta) {
        m = length(y)
        t((X %*% theta) - y) %*% (((X %*% theta) - y)/(2*m))
}
