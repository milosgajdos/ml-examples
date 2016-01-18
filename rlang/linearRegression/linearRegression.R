# costFunc returns gradient descent cost for given features matrix, measurement and model
# It accepts 3 parameters as arguments:
# X - features matrix
# y - measurement vector
# theta - model parameters
costFunc <- function(X, y, theta) {
        m = length(y)
        t((X %*% theta) - y) %*% (((X %*% theta) - y)/(2*m))
}

# linearRegression calculates model parameters for a training set available in a path passed in
# as argument for a given gradient descent step and number of iterations
# It returns computed model parameters vector
linearRegression <- function(path, alpha, iters, normalize = FALSE) {
        # load all supporting R scripts into R environment
        envScripts <- c("../trainingSet/trainingSet.R", 
                        "../gradientDescent/featureNormalize.R", 
                        "../gradientDescent/gradientDescent.R")
        invisible(sapply(envScripts, source))
        # load model training set
        message("Loading training set: ", path)
        ts = trainingSet(path)
        # normalize the features matrix X
        if (normalize) {
                message("Normalizing features matrix")
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
        init_theta <- rep(0, ncol(X))
        gdOut <- gradientDescent(X, y, init_theta, alpha, iters, costFunc)
        gdOut$theta
}
