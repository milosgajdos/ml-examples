# backPropNN implements backpropagation Neural Network algorithm
# it returns the resulting network parameters in a list. It accepts following parameters:
# trainDataPath - path to training data set
# dataType      - type of the data set file(s). Default; csv
# normalize     - do you need to perform feature scaling? Default: FALSE
# lambda        - regularization parameter. If NA, no regularization is done. Default: NA
backPropNN <- function(trainDataPath, dataType = "csv", normalize = FALSE, lambda = NA){
        # load all supporting library scripts into R environment
        libPath <- file.path("..", "libs")
        invisible(sapply(list.files(path=libPath, full.names = TRUE), source))
        # load NN training set
        message("Loading training set: ", trainDataPath)
        ts <- loadTrainingSet(trainDataPath, dataType, supervised = TRUE)
        message("Done!")
        # preprocess features matrix if requested
        X <- prepData(ts$X, normalize)
        y <- ts$y
        # Neural Network parameters:
        #       2 layers 400 inputs, 10 outputs/labels
        inputLayerSize  <- 400
        hiddenLayerSize <- 25
        nrLabels        <- 10
        nrIters         <- 50
        # initialize NNet transformation matrices
        theta1 <- initNNLayer(inputLayerSize, hiddenLayerSize)
        theta2 <- initNNLayer(hiddenLayerSize, nrLabels)
        theta  <- c(theta1,  theta2)
        # calculat Neural Net parameters
        message("Computing BFGS optimized NN parameters with ", nrIters, " iterations")
        model <- optim(theta, costFunc, gradFunc, X=X, y=y, lambda=lambda, method="BFGS",
                       inputLayerSize=inputLayerSize, hiddenLayerSize=hiddenLayerSize,
                       nrLabels=nrLabels, control = list(maxit = nrIters, trace = 1))
        message("Done computing NN parameter!")
        nnParams <- model$par
        # roll in the computed parameters to NNet matrices
        theta1 <- matrix(nnParams[1:(hiddenLayerSize*(inputLayerSize+1))], nrow=hiddenLayerSize)
        theta2 <- matrix(nnParams[(hiddenLayerSize*(inputLayerSize+1)+1):length(nnParams)],
                         nrow=nrLabels)
        list("theta1" = theta1, "theta2" = theta2)
}

# costFunc calculates Neural Network cost for classifier with nrLabels outputs
# It accepts several parameters
# nnParams - vector of Neural Network parameters (both layer matrices rolled into one vector)
# inputLayerSize  - number of input layer units
# hiddenLayerSize - number of hidden layer units
# nrLabels        - number of classifer labels
# X - training set data
# y - training set outputs
# lambda - regularization parameter
costFunc <- function(nnParams, inputLayerSize, hiddenLayerSize, nrLabels, X, y, lambda){
        #message("Calculating NN cost")
        theta1 <- matrix(nnParams[1:(hiddenLayerSize*(inputLayerSize+1))], nrow=hiddenLayerSize)
        theta2 <- matrix(nnParams[(hiddenLayerSize*(inputLayerSize+1)+1):length(nnParams)],
                         nrow=nrLabels)
        # Add bias to X
        X <- cbind(matrix(rep(1, nrow(X))), X)
        # Feed forward
        z2 <- X %*% t(theta1)
        a2 <- sigmoid(z2)
        a2 <- cbind(matrix(rep(1, nrow(a2))), a2)
        z3 <- a2 %*% t(theta2)
        a3 <- sigmoid(z3)
        # create y labels
        tmp <- diag(nrLabels)
        yk <- as.matrix(tmp[y,], nrow=5000)
        m <- length(y)
        J <- -(sum(sum((yk * log(a3) + (1 - yk) * log(1 - a3)), 2)))/m;
        if (!is.na(lambda)) {
                reg <- (lambda/(2*m))*(sum(sum(theta1[,2:ncol(theta1)]^2)) +
                                       sum(sum(theta2[,2:ncol(theta2)]^2)))
                J <- J + reg
        }
        #message("Done computing NN cost!")
        return(J)
}

# gradFunc calculates Neural Network gradient descent step for classifier with nrLabels
# It accepts the exact same parameters and costFunc
gradFunc <- function(nnParams, inputLayerSize, hiddenLayerSize, nrLabels, X, y, lambda){
        #message("Calculating NN gradient")
        # unroll NN layer matrices
        theta1 <- matrix(nnParams[1:(hiddenLayerSize*(inputLayerSize+1))], nrow=hiddenLayerSize)
        theta2 <- matrix(nnParams[(hiddenLayerSize*(inputLayerSize+1)+1):length(nnParams)],
                         nrow=nrLabels)
        # Add bias to X
        X <- cbind(matrix(rep(1, nrow(X))), X)
        # create matrix of labels Y
        tmp <- diag(nrLabels)
        Y <- as.matrix(tmp[y,], nrLabels)
        # number of training samples
        m <- length(y)
        # BackPropagation algorithm
        Delta1 <- matrix(0, nrow(theta1), ncol(theta1))
        Delta2 <- matrix(0, nrow(theta2), ncol(theta2))
        for (i in 1:nrow(X)){
                xT <- X[i,]
                yT <- Y[i,]
                # Forward propagation for (xT, yT)
                z2T <- xT %*% t(theta1)
                a2T <- sigmoid(z2T)
                # add bias to a2T
                a2T <- c(1, a2T)
                z3T <- a2T %*% t(theta2)
                a3T <- sigmoid(z3T)
                # 3rd layer error
                delta3 <- (a3T - yT)
                # hidden layer error
                tmp    <- t(theta2) %*% t(delta3)
                delta2 <- tmp[2:nrow(tmp),] * sigmoidGrad(z2T)
                Delta1 <- Delta1 + t(delta2) %*% xT
                Delta2 <- Delta2 + t(delta3) %*% a2T
        }
        # NN gradient
        theta1Grad <- (1/m)*Delta1
        theta2Grad <- (1/m)*Delta2
        if (!is.na(lambda)) {
                # NN gradient regularizer
                theta1Reg <- (lambda/m)*cbind(matrix(rep(0, nrow(theta1))), theta1[,2:ncol(theta1)])
                theta2Reg <- (lambda/m)*cbind(matrix(rep(0, nrow(theta2))), theta2[,2:ncol(theta2)])
                theta1Grad <- theta1Grad + theta1Reg
                theta2Grad <- theta2Grad + theta2Reg
        }
        thetaGrad <- c(theta1Grad, theta2Grad)
        #message("Done computing gradient!")
        return(thetaGrad)
}
