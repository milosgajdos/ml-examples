# gradientDescent returns a list that contains two vectors:
# theta - vector of estimated model parameters
# J - vector of cost function outputs (for graphing)
# It accepts 4 parameters as arguments:
# X - features matrix
# y - measurement vector
# alpha - gradient descent step
# iters - number of gradient descent iterations
gradientDescent <- function(X, y, theta, alpha, iters){
        m = length(y)
        J = rep(0, iters)
        for (iter in 1:iters) {
                theta = theta - (alpha/m)*(t(X) %*% ((X %*% theta) - y))
                J[iter] = computeCost(X, y, theta)
        }
        list("theta" = theta, "J" = J)
}

# computeCost returns gradient descent cost for given features matrix, measurement and model
# It accepts 3 parameters as arguments:
# X - features matrix
# y - measurement vector
# theta - model parameters
computeCost <- function(X, y, theta) {
        m = length(y)
        t((X %*% theta) - y) %*% (((X %*% theta) - y)/(2*m))
}
