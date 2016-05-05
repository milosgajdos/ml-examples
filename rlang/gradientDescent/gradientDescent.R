# gradientDescent returns a list that contains two vectors:
# theta - vector of estimated model parameters
# J - vector of cost function outputs (for graphing)
# It accepts 5 parameters as arguments:
# X - features matrix
# y - measurement vector
# alpha - gradient descent step
# iters - number of gradient descent iterations
# costFunc - returns gradient descent cost for given features matrix, measurement and model (theta)
gradientDescent <- function(X, y, theta, alpha, iters, costFunc = NULL){
        m = length(y)
        J = rep(0, iters)
        for (iter in 1:iters) {
                theta = theta - (alpha/m)*(t(X) %*% ((X %*% theta) - y))
                if (is.function(costFunc)) {
                        J[iter] = costFunc(X, y, theta)
                }
        }
        list("theta" = theta, "J" = J)
}
