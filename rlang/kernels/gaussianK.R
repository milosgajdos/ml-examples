# gaussianK implements gaussian kernel function between x1 and x2
gaussianK <- function(x1, x2, sigma) {
        exp(-sum((x1-x2)^2)/(2*sigma^2))
}
