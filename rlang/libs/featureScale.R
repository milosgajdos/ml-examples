# featureScale accepts a features matrix X as an argument and returns a list object
# which contains normalized features matrix X, vector mu of mean values of each feature and
# vector sigma of standard deviations of each feature in features matrix X
featureScale <- function(X) {
        # calculate mu and sigma vectors for each feature
        # same as colMeans(x)
        mu    = apply(X, 2, mean)
        sigma = apply(X, 2, sd)
        # featureScale the features matrix X
        # same as scale(X) resp. scale(X, center = TRUE, scale = TRUE)
        for (i in 1:ncol(X)) {
                X[, i] = sapply(X[, i], function(x){(x - mu[i])/sigma[i]})
        }
        # return vectors mu, sigma and featureScaled features matrix X
        list("mu" = mu, "sigma" = sigma, "X" = X)
}
