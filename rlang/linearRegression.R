# linearRegression calculates model parameters for a training set available in a path passed in
# as an argument for a given gradient descent step and number of iterations
# It returns computed model parameters vector
linearRegression <- function(path, alpha, iters, normalize = FALSE) {
        # load all supporting R scripts into R environment
        envScripts <- c("trainingSet.R", "featureNormalize.R", "gradientDescent.R")
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
        # add intercept feature to normalized matrix
        intercept <- matrix(rep(1, nrow(X)))
        X <- cbind(intercept, X)
        y <- ts$y
        # run gradient descent to compute model parameters
        message("Running gradient descent for alpha=", alpha, " iterations=", iters)
        theta <- rep(0, ncol(X))
        gdOut <- gradientDescent(X, y, theta, alpha, iters)
        gdOut$theta
}
