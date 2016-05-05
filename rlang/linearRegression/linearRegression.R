# linearRegression calculates model parameters for a training set available in a path passed in
# as argument for a given gradient descent step and number of iterations
# linearRegression returns a vector containing model parameters
# it accepts several parameters:
# trainDataPath - path to a training data set
# dataType      - type of the training data set file
# normalize     - boolean to request feature normalizing
# costFunc      - linear regression cost function
# alpha         - gradient descent step
# iters         = number of gradient descent iterations
linearRegression <- function(trainDataPath, dataType = "csv", normalize = FALSE, 
                             costFunc = NULL, alpha, iters) {
        # load all supporting library scripts into R environment
        libPath <- file.path(getwd(), "..", "libs")
        invisible(sapply(list.files(path=libPath, full.names = TRUE), source))
        # load model training set
        message("Loading training set: ", trainDataPath)
        ts <- loadDataSet(trainDataPath, dataType)
        # preprocess features matrix
        X <- prepData(ts$X, normalize)
        y <- ts$y
        # load gradient descent library script
        gradDescentPath <- file.path(getwd(), "..", "gradientDescent", "gradientDescent.R")
        invisible(source(gradDescentPath))
        # run gradient descent to compute model parameters
        message("Running gradient descent for alpha=", alpha, " iterations=", iters)
        # initialize theta to zero vector
        theta <- rep(0, ncol(X))
        # run gradient descent
        gdOut <- gradientDescent(X, y, theta, alpha, iters, costFunc)
        gdOut$theta
}

# linRegCostFunc returns gradient descent cost for given features matrix, measurement and model
# It accepts 3 parameters as arguments:
# X - features matrix
# y - measurement vector
# theta - model parameters
linRegCostFunc <- function(X, y, theta) {
        m = length(y)
        t((X %*% theta) - y) %*% (((X %*% theta) - y)/(2*m))
}
