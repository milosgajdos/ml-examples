# costFunc returns gradient descent cost for logistic regression
# for given features matrix, measurement and model.
# It accepts 3 parameters as arguments:
# theta - model parameters
# X - features matrix
# y - measurement vector
# Note! theta must be the first parameter so costFunc can be used in optim() function
costFunc <- function(theta, X, y) {
        m <- length(y)
        -(1/m)*(t(log(sigmoid(X %*% theta))) %*% y + t(log(1-sigmoid(X %*% theta))) %*% (1-y))
}

# costRegFunc returns gradient descent cost for regularized logistic regression
# given features matrix, measurement and model.
# It accepts 4 parameters as arguments:
# theta - model parameters
# X - features matrix
# y - measurement vector
# lambda - regularization parameter
# Note! theta must be the first parameter so costRegFunc can be used in optim() function
costRegFunc <- function(theta, X, y, lambda) {
        m <- length(y)
        g <- sigmoid(X %*% theta)
        regularizer <- (lambda/(2*m))*sum((theta[2:length(theta)])^2)
        -(1/m)*((t(log(g))) %*% y + t(log(1-g)) %*% (1-y)) + regularizer
}

# gradFunc computes a gradient value for one step in gradient descent
# It accepts 3 parameters as arguments:
# theta - model parameters
# X - features matrix
# y - measurement vector
gradFunc <- function(theta, X, y) {
        m = length(y)
        (1/m)*(t(X) %*% (sigmoid(X %*% theta) - y))
}

# gradRegFunc computes a gradient value for one step in regularized gradient descent
# It accepts 4 parameters as arguments:
# theta - model parameters
# X - features matrix
# y - measurement vector
# lambda - regularization parameter
gradRegFunc <- function(theta, X, y, lambda) {
        m = length(y)
        grad <- rep(0, length(theta))
        g <- sigmoid(X %*% theta)
        regularizer <- (lambda/m)*(theta[2:length(theta)])
        grad[1] <- (1/m)*(t(X[,1]) %*% (g - y))
        grad[2:length(grad)] <- (1/m)*(t(X[,2:ncol(X)]) %*% (g - y)) + regularizer
        # return computed gradient
        return(grad)
}

# logisticRegression calculates model parameters for a training set available in a path 
# passed in as argument. It calls R's optim() function from optimization library which 
# optimizes required model for a given cost and gradient passed in as parameters
logisticRegression <- function(path, regularize = FALSE, lambda = NULL,
                               mapFeature = FALSE, mapFunc = NULL) {
        envScripts <- c("../trainingSet/trainingSet.R",
                        "../sigmoid/sigmoid.R")
        invisible(sapply(envScripts, source))
        # load model training set
        message("Loading training set: ", path)
        ts = trainingSet(path)
        # initialize empty matrix
        X <- matrix()
        # if we want to map new features we must pass in mapFunc
        if (mapFeature) {
                if (!is.function(mapFunc)) {
                        stop("Features map function could not be found!")
                } else {
                        X <- mapFunc(ts$X)
                }
        } else {
                # add intercept feature to features matrix
                intercept <- matrix(rep(1, nrow(ts$X)))
                X <- cbind(intercept, ts$X)
        }
        y <- ts$y
        # optimize model parameters for given cost function
        init_theta <- rep(0, ncol(X))
        # if we want to regularize we must pass in lambda or default value will be used
        if (regularize) {
                if (is.null(lambda) || is.na(lambda)) {
                        message("lambda not set. Setting to default value: 1")
                        lambda <- 1
                }
                message("Running regularized logistic regression optimization for lambda: ", lambda)
                optimModel <- optim(init_theta, costRegFunc, gradRegFunc, 
                                    X = X, y = y, lambda = lambda, method = "BFGS")
                message("Optimal regression cost: ", optimModel$value)
                # return model parameters
                return(optimModel$par)
        } else {
                message("Running logistic regression optimization")
                optimModel <- optim(init_theta, costFunc, gradFunc, 
                                   X = X, y = y, method = "BFGS")
                # return model parameters
                message("Optimal regression cost: ", optimModel$value)
                return(optimModel$par)
        }
}
