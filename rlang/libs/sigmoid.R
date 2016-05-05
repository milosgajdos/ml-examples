# sigmoid provides an implementation of sigmoid function defined as below:
# https://en.wikipedia.org/wiki/Logistic_function
# where L = 1 in our case which implements binary decision maker
# It returns a single value (R vector) that contains a result of sigmoid(z)
sigmoid <- function(z) {
        1/(1+exp(-z))
}
