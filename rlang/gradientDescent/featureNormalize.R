# featureNormalize accepts a features matrix X as an argument and returns a list object
# which contains normalized features matrix X, vector mu of mean values for each feature and
# vector sigma which contains standard deviations of each feature
featureNormalize <- function(X) {
        # calculate mu and sigma vectors for each feature
        mu    = apply(X, 2, mean)
        sigma = apply(X, 2, sd)
        # normalize the features matrix X
        for (i in 1:ncol(X)) {
                X[, i] = sapply(X[, i], function(x){(x - mu[i])/sigma[i]})
        }
        # return vectorus mu, sigma and the normalized matrix
        list("mu" = mu, "sigma" = sigma, "X" = X)
}
