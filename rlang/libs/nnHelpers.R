# initNNLayer initializes Neural Network layer to random values
# It accepts two parameters:
# layerIn  - number of input units
# layerOut - number of output units
initNNLayer <- function(layerIn, layerOut) {
        # epsilon constant value
        epsilon <- sqrt(6)/sqrt(layerIn+layerOut)
        # return uniformly distributed matrix (layerOut x layerIn+1)
        matrix(runif(layerOut*(layerIn+1)), layerOut, layerIn+1) * (2*epsilon) - epsilon
}

# validateNN allows to validate Neural Network parameters
# It accepts following parameters:
# theta1, theta2 - trained NN matrices for two layers
# X - data validation matrix
# y - expected oututs
validateNN <- function(theta1, theta2, X, y){
        nrSamples <- nrow(X)
        # add bias to each layer and compute outputs
        h1 <- sigmoid( cbind(matrix(rep(1, nrow(X))), X) %*% t(theta1))
        h2 <- sigmoid(cbind(matrix(rep(1, nrow(h1))), h1) %*% t(theta2))
        # pick indexes of max values in each row - each row contains FeedForward results
        p <- max.col(h2)
        # calculate %-age of successful classifications
        mean(p == y) * 100
}
