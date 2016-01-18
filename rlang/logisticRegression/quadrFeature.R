# quadrFeature implements feature mapping function to a complex polynomial features.
# The function maps the two input features passed in as arguments to quadratic features.
# It returns a new feature matrix with more complex feature mapping comprising of:
#   X1, X2, X1.^2, X2.^2, X1*X2, X1*X2.^2 etc.
# Note! Inputs X1, X2 must be the same size
quadrFeature <- function(X) {
        degree <- 6
        X1 <- X[,1]
        X2 <- X[,2]
        # add intercept vector into first column of Xnew
        Xnew <- matrix(rep(1, length(X1)), byrow = FALSE)
        for (i in 1:degree) {
                for (j in 0:i) {
                        Xnew <- cbind(Xnew, ((X1^(i-j))*(X2^j)))
                }
        }
        # return matrix with newly mapped features
        Xnew
}
