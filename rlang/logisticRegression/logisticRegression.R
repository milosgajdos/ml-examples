# logisticRegression calculates model parameters for a training set available in a path 
# passed in as argument. It calls R's optim() function from optimization library which 
# optimizes required model for a given cost and gradient passed in as parameters
# logisticRegression returns a vector containing model parameters
# It accepts several parameters:
# trainDataPath - path to a training data set
# dataType      - type of the training data set file. Default: csv
# normalize     - boolean to request feature normalizing. Default: FALSE
# lambda        - regularization parameter. Default: NA
# costFunc      - gradient descent cost function. Default: NULL
# gradFunc      - gradient descent step function. Default: NULL
# mapFunc       - feature mapping function, Default: NULL
logisticRegression <- function(trainDataPath, dataType = "csv", normalize = FALSE,
                               lambda = NA, costFunc = NULL, gradFunc = NULL, 
                               mapFunc = NULL) {
        # load all supporting library scripts into R environment
        libPath <- file.path("..", "libs")
        invisible(sapply(list.files(path=libPath, full.names = TRUE), source))
        # load model training set
        message("Loading training set: ", trainDataPath)
        ts <- loadTrainingSet(trainDataPath, dataType)
        # preprocess features matrix
        X <- prepData(ts$X, normalize, mapFunc, addBias = TRUE)
        y <- ts$y
        # initialize theta to zero vector
        theta <- rep(0, ncol(X))
        # run logistics regression to compute the model
        message("Running logistic regression")
        model <- optim(theta, costFunc, gradFunc, X = X, y = y,
                       lambda = lambda, method = "BFGS")
        model$par
}

# lrCostFunc returns gradient descent cost for logistic regression
# for given features matrix, measurement and model.
# It accepts 3 parameters as arguments:
# theta - model parameters
# X - features matrix
# y - measurement vector
# Note! theta must be the first parameter so costFunc can be used in optim() function
lrCostFunc <- function(theta, X, y, ...) {
        m <- length(y)
        -(1/m)*(t(log(sigmoid(X %*% theta))) %*% y + t(log(1-sigmoid(X %*% theta))) %*% (1-y))
}

# lrGradFunc computes gradient for one step in non-regularized gradient descent
# It accepts 3 parameters as arguments:
# theta - model parameters
# X - features matrix
# y - measurement vector
lrGradFunc <- function(theta, X, y, ...) {
        m = length(y)
        (1/m)*(t(X) %*% (sigmoid(X %*% theta) - y))
}

# lrCostRegFunc returns gradient descent cost for regularized logistic regression
# given features matrix, measurement and model.
# It accepts 4 parameters as arguments:
# theta - model parameters
# X - features matrix
# y - measurement vector
# lambda - regularization parameter
# Note! theta must be the first parameter so costRegFunc can be used in optim() function
lrCostRegFunc <- function(theta, X, y, lambda) {
        m <- length(y)
        g <- sigmoid(X %*% theta)
        regularizer <- (lambda/(2*m))*sum((theta[2:length(theta)])^2)
        -(1/m)*((t(log(g))) %*% y + t(log(1-g)) %*% (1-y)) + regularizer
}

# lrGradRegFunc computes gradient for one step in regularized gradient descent
# It accepts 4 parameters as arguments:
# theta - model parameters
# X - features matrix
# y - measurement vector
# lambda - regularization parameter
lrGradRegFunc <- function(theta, X, y, lambda) {
        m = length(y)
        grad <- rep(0, length(theta))
        g <- sigmoid(X %*% theta)
        regularizer <- (lambda/m)*(theta[2:length(theta)])
        grad[1] <- (1/m)*(t(X[,1]) %*% (g - y))
        grad[2:length(grad)] <- (1/m)*(t(X[,2:ncol(X)]) %*% (g - y)) + regularizer
        # return computed gradient
        return(grad)
}
