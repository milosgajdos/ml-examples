# somNN implement Self Organizing Maps Neural Network algorithm
# it returns the resulting network parameters in a list
# It accepts the following parameters:
# trainDataPath - path to training data set
# dataType      - type of the data set file(s). Default; csv
# normalize     - do you need to perform feature scaling? Default: FALSE
# somInitType   - how to initialize SOM map. Only random is availalble. Default: random
# mapUnits      - nr of map units. If not specified, it's implied form data. Default: NA
# gridSize      - integer vector. If not specified, it's calculated form mapUnits. Default: NULL
# lattice       - output grid: hexagon/rectangle Default: hexagon
# shape         - SOM grid shape; only sheet is supported for now. Default: sheet
# algorithm     - SOM algorithm. batch/seq Default: seq
# neighbFunc    - neighbourhood function gaussian Default: gaussian
somNN <- function(trainDataPath, dataType = "csv", normalize = FALSE, somInitType = "random",
                  mapUnits = NA, gridSize = NULL, lattice = "hexagon", shape = "sheet",
                  algorithm = "seq", neighbFunc = "gaussian") {
        # load all supporting library scripts into R environment
        libPath <- file.path("..", "libs")
        invisible(sapply(list.files(path=libPath, full.names = TRUE), source))
        # load NN training set
        message("Loading training set: ", trainDataPath)
        ts <- loadTrainingSet(trainDataPath, dataType)
        message("Done!")
        # preprocess features matrix if requested
        X <- prepData(ts$X, normalize)
        dataLen <- nrow(X)
        dataDim <- ncol(X)
        # calculate SOM topology
        message("Calculating SOM topology")
        somTop <- somTopology(X, mapUnits, gridSize, lattice, shape)
        message("Done!")
        message("SOM units: ", somTop$munits)
        message("SOM dims: ", paste(somTop$gridsize, sep=" x ", collapse=" x "))
        # initialize SOM weights
        message("Initializing SOM using ", somInitType, "init type")
        initSom <- somInit(X, somTop$munits, somInitType)
        message("Done!")
        # base training a.k.a. SOM ordering phase
        message("Performing SOM base training")
        baseSom <- somTrain("base", initSom, X, somTop$gridsize, algorithm, neighbFunc)
        message("Done!")
        # retrieve rough training error
        baseErr <- baseSom$qerr
        message("SOM error after base training: ", baseErr[length(baseErr)])
        # SOM fine-tuning
        message("Performing SOM fine tuning")
        # finetuning error vector
        tunedSom <- somTrain("tune", baseSom$model, X, somTop$gridsize, algorithm, neighbFunc)
        message("Done!")
        tuneErr <- tunedSom$qerr
        message("SOM error after fine tuning: ", tuneErr[length(tuneErr)])
        somErr  <- c(baseErr, tuneErr)
        # return learnt parameters and quant. error vector
        return(list("model" = tunedSom$model, "qerr" = somErr))
}

# somTopology create SOM topology based on the specified parameters
# It returns a list that contains network topology parameters
# It accepts following parameters:
# X        - training data set
# mapUnits - nr of SOM units. If not specified, it's implied from data. Default: NA
# gridSize - vector of grid dimensions. If not spec it's implied form mapUnits. Default: NULL
# lattice  - output grid: hexagon/rectangle Default: hexagon
# shape    - SOM grid shape; only sheet is supported Default: sheet
somTopology <- function(X, mapUnits = NA, gridSize = NULL,
                        lattice = "hexagon", shape = "sheet"){
        # if mapUnits is not specified, we will calculate it from data
        if (is.na(mapUnits)){
                if (!is.null(gridSize)) {
                        # if we supplied gridSize mapUnits is the area
                        mapUnits <- prod(gridSize)
                } else {
                        # calculate map grid from data matrix
                        gridSize <- getGridSize(X, lattice = lattice)
                        # mapUnits cover area of gridSize
                        mapUnits <- prod(gridSize)
                }
        } else {
                # mapUnits are determined by the size of X
                # mapUnits override gridSize parameter
                gridSize <- getGridSize(X, mapUnits, lattice)
                # mapUnits are reset to reflect the gridSize
                mapUnits <- prod(gridSize)
        }
        # return SOM topology parameters
        list("munits" = mapUnits, "gridsize" = gridSize, "lattice" = lattice, "shape" = shape)
}

# getGridSize calculates SOM grid size and returns it as a vector.
# getGridSize determines the grid size from eigenvectors of input data
# The size of grid is driven by the ratio of two highest input eigenvalues
# It accepts following parameters:
# X        - data matrix X
# mapUnits - number of desired mapUnits. Default: NA
# lattice  - SOM map grid hexagon/rectangle
getGridSize <- function(X, mapUnits = NA, lattice = "hexagon"){
        # init gridSize to empty vector
        gridSize <- c()
        # read in X dimensions
        dataLen <- nrow(X)
        dataDim <- ncol(X)
        # init mapUnits
        if (is.na(mapUnits)){
                # this is a simple heuristic
                mapUnits <- ceiling(5 * dataLen^0.5)
        }
        # single dimensional input data - we get 1D SOM map
        if (dataDim == 1) {
                gridSize <- c(1, ceiling(mapUnits))
        } else if (dataLen < 2) {
                # not enough data to calculate eigenvectors
                # we will use some heuristics: nr. of mapUnits = square area of SOM
                xDim <- round(sqrt(mapUnits))
                yDim <- round(mapUnits/xDim)
                gridSize <- c(xDim, yDim)
        } else {
                # initialize xDim/yDim ratio using principal components of the input
                # The ratio is the square root of ratio of two largest eigenvalues
                ratio <- NA
                # mean center input data
                X <- scale(X, scale=FALSE)
                # covariance matrix
                covX <- cov(X)
                # eigenvalues are already ordered from the highest to the lowest
                xEigVals <- eigen(covX)$values
                # if we can't calculate ratio we set it to 1
                if (xEigVals[1] == 0 || xEigVals[2]*mapUnits < xEigVals[1]) {
                        ratio <- 1
                } else {
                        ratio <- sqrt(xEigVals[1]/xEigVals[2])
                }
                # hexagon grid is a bit stretched on sides -> sqrt()
                if (lattice == "hexagon") {
                        gridSize[2] <- min(mapUnits, round(sqrt(mapUnits / ratio * sqrt(0.75))))
                } else {
                        # rectangle grid
                        gridSize[2] <- min(mapUnits, round(sqrt(mapUnits / ratio)))
                }
                gridSize[1] <- round(mapUnits / gridSize[2])
                # if actual dimension of the data is 1, make the map 1-D
                if(min(gridSize) == 1) {
                        gridSize <- c(1, max(gridSize))
                }
        }
        return(gridSize)
}

# somInit initializes SOM based on the passed parameters
# It accepts following parameters:
# X - training data
# mapUnits    - number of SOM map units
# somInitType - init type: random Default: random
somInit <- function(X, mapUnits, somInitType = "random"){
        switch(somInitType,
               "random" = randInit(X, mapUnits)
               )
}

# randInit initializes SOM with random uniformly distributed values in
# range (min, max) where min,max are calculated for each data column
# It returns som weights matrix with following dimensions: mapUnits x dataDim
# It accepts the following parameters
# X - training data
# mapUnits - SOM units
randInit <- function(X, mapUnits){
        # read in data dimension
        dataDim <- ncol(X)
        # find max and min values in each data column [feature]
        ma <- apply(X,2,max)
        mi <- apply(X,2,min)
        # initialize somWeights matrix
        # set.seed for reproducible results
        set.seed(48)
        somWeights <- matrix(runif(mapUnits*dataDim), mapUnits, dataDim)
        for (i in 1:dataDim) {
                somWeights[,i] <- ((ma-mi) * somWeights[,i]) + mi
        }
        return(somWeights)
}

# somTrain trains SOM neural network. It returns a matrix of SOM model units weights.
# It accepts the following parameters:
# trainingType  - base/tune. Default: base
# gridSize - SOM grid size
# X - training data set
# algorithm  - seq/batch. Default: seq
# neighbFunc - neighbourhood function. Default: gaussian
somTrain <- function(trainingType = "base", somWeights, X, gridSize,
                     algorithm = "seq", neighbFunc = "gaussian"){
        # get training parameters
        trainParams  <- getTrainParams(trainingType, X, gridSize)
        neighbFunc   <- getNeighbFunc(neighbFunc)
        switch(algorithm,
               "seq" = seqTrain(somWeights, X, gridSize,
                                trainParams$trainlen, trainParams$alpha,
                                trainParams$radius, neighbFunc))
}

# seqTrain - implements sequential SOM training
# seqTrain returns somWeights and a vector of vector quant error - error per iteration
seqTrain <- function(somWeights, X, gridSize, trainLen, alphaInit, radiusInit, neighbFunc) {
        # calculate map unit distances
        # first we need to calculate map units coordinates on map grid
        mapUnitCoord <- getUnitCoords(gridSize)
        mapUnitDists <- getUnitDistances(mapUnitCoord)
        dataLen <- nrow(X)
        message("Kicking off ", trainLen, " training iterations")
        # initialize quant Error
        qErr <- c()
        # perform the actual SOM training
        for (i in 1:trainLen){
                # pick a sample vector from input data
                xIn <- X[sample(dataLen,1),]
                # replicate xIn so we can use it in Matrix operations
                tmpX <- matrix(rep(xIn), nrow=nrow(somWeights),
                               ncol=ncol(somWeights), byrow=TRUE)
                # calculate distances from all weights - vectors are in rows
                deltaX <- tmpX - somWeights
                distX  <- rowSums(deltaX^2)
                # find the BMU - the one with minimum distance
                # we will pick random BMU in case more BMUs are found
                bmus <- which.min(distX)
                bmu  <- bmus[sample(length(bmus), 1)]
                # calculate learning rate, radius and neighbourhood
                a <- alpha(alphaInit = alphaInit, trainLen, i)
                r <- radius(radiusInit = radiusInit, trainLen, i)
                # calculate neighborhood update
                n <- neighbFunc(mapUnitDists, bmu, r)
                # replicate the neighbourhood to matrix rows for matrix operation
                tmpN <- matrix(rep(n), nrow=nrow(somWeights),
                               ncol=ncol(somWeights), byrow=FALSE)
                # update the SOM weights
                somWeights <- somWeights + a*tmpN*deltaX
                # calculate the cost - error metric is Euclidean distance from BMU
                qErrs <- apply(X, 1, function(x){
                        errs <- rowSums((sweep(somWeights, 2, x, "-"))^2)
                        bmus <- which.min(errs)
                        bmu  <- bmus[sample(length(bmus), 1)]
                        errs[bmu]})
                qErr[i] <- mean(qErrs)
        }
        list("model" = somWeights, "qerr" = qErr)
}

# getNeighbFunc - returns neighbourhood function based on passed parameter
getNeighbFunc <- function(funcType){
        switch(funcType,
               "gaussian" = gaussFunc)
}

# gaussFunc - implements gausian function for SOM learning
gaussFunc <- function(distMap, bmu, radius){
        # distMap is symmetrical so distMap[,bmu] and distMap[bmu,] selects the same vector
        exp(-(distMap[,bmu]^2)/(2*radius*radius))
}

# getTrainParms - calculates training parameters for the type of training
# It returns the parameters in a list. It accepts the following parameters
# trainingType  - base/tune
# X - training data set
# gridSize - size of SOM grid
getTrainParams <- function(trainingType, X, gridSize){
        switch(trainingType,
               "base" = baseParams(X, gridSize),
               "tune" = tuneParams(X, gridSize)
               )
}

# baseParams implements initial SOM training
baseParams <- function(X, gridSize){
        # set the trainLen - short for base training
        mapUnits <- prod(gridSize)
        unitsPerData <- ceiling(mapUnits/nrow(X))
        # must be at least 1 training
        trainLen <- max(1, 200*unitsPerData)
        # set the initial learning rate
        alphaInit <- 0.5
        # set neighbourhood radius - depends on size of grid
        # radius normally goes from radiusInit -> 1
        # pick the highest dimension
        ms <- max(gridSize)
        radiusInit <- max(1,ceiling(ms/4))
        list("trainlen" = trainLen, "alpha" = alphaInit, "radius" = radiusInit)
}

# tuneParams implements SOM fine tuning
tuneParams <- function(X, gridSize){
        # set the trainLen - longer for fine-tune training
        mapUnits <- prod(gridSize)
        unitsPerData <- ceiling(mapUnits/nrow(X))
        # must be at least 1 training
        trainLen <- max(1, 400*unitsPerData)
        # set the initial learning rate - 10x smaller than initial training
        alphaInit <- 0.05
        # set neighbourhood radius - depends on size of grid
        # radius normally goes from radiusInit -> 1; note smaller initial radius than in base train
        # pick the highest dimension
        ms <- max(gridSize)
        radiusInit <- max(1,ceiling(ms/8))
        list("trainlen" = trainLen, "alpha" = alphaInit, "radius" = radiusInit)
}

# alpha implements SOM learning rate. alpha "decays" with every iteration
# The decay starts at alphaInit = 1 and decreases based on chosen alphaType.
# alphaType can be either inverse or lin.
# It accepts following parameters:
# alphaInit - initial value of learning rate. Default: 0.5
# trainLen  - training length
# iter      - iteration number
# alphaType - inv/lin Default: inv
alpha <- function(alphaInit = 0.5, trainLen, iter, alphaType = "inv") {
        if (alphaType == "inv") {
                # Inverse: alphaInit -> alphaInit/100
                alphaInit / (1 + 99*(iter-1)/(trainLen-1))
        } else if (alphaType == "lin") {
                # Linear: alphaInit -> 0
                alphaInit*(1-iter/trainLen)
        } else {
                stop("Learning rate function not supported: ", alphaType)
        }
}

# radius implements unit neighbourhood radius function
# radius is a monotonically decreasing function that depends on training length
# radiusInit - initial value of neighb. radius.
# trainLen   - training length
# iter       - iteration number
radius <- function(radiusInit, trainLen, iter){
        # might become a configurable in the future
        radiusFin <- 1
        # first returned value = radiusInit as iter=1 -> radiusInit + 0
        # last  returned value = radiusFin  as iter = trainLen -> radiusInit-radiusInit+radiusFin
        radiusInit + (radiusFin-radiusInit)*(iter-1)/(trainLen-1)
}

# getUnitCoords - calculates SOM unit coordinates on SOM grid
# these coordinates are then used to calculate distances between units on a map
# It accepts following parameters
# mapGrid - SOM grid used to create the lattice coordinate system where units are placed
# lattice - type of SOM grid; hexagon/rectangle. Default: hexagon
# shape   - shape of the grid. Only sheet is currently supported. Default: sheet
getUnitCoords <- function(gridSize, lattice = "hexagon", shape = "sheet"){
        if (shape != "sheet"){
                stop("Unsupported shape ", shape)
        }
        if(!(lattice %in% c("hexagon", "rectangle"))) {
            stop("Unsupported lattice or shape ", lattice, " ", shape)
        }
        if (length(gridSize) == 1){
                 gridSize <- c(gridSize, 1)
        }
        # initialize coordinates matrix to zeros
        mapUnits <- prod(gridSize)
        mapDim   <- length(gridSize)
        # coordinates map should look like this for gridSize 3x2
   	#   0   0
   	#   0   1
   	#   0   2
   	#   1   0
   	#   1   1
   	#   1   2
        coordMap <- matrix(rep(0, mapUnits*mapDim), mapUnits, mapDim)
        # first dimension contains continuous repeated sequence: 0,1,2, 0,1,2. etc.
        coordMap[,1] <- rep(seq(0, gridSize[1]-1), mapUnits/gridSize[1])
        # all other dimensions contain repeated sequence groups: 0,0,0 ... 1,1,1 ...
        for (i in 2:mapDim){
                # how long should the repetition groups be
                reps <- mapUnits/gridSize[i]
                coordMap[,i] <- rep(0:(gridSize[i]-1), each = reps)
        }
        # TODO: why?
        # swap first two dimensions i.e. columns
        coordMap[ ,c(1,2)] <- coordMap[, c(2,1)]
        # if lattice is set to hexagon we need to offset x-coordinates of every other row
        # y-coordinates are multiplied by sqrt(0.75). This will make distances of a unit
        # to all its six neighbors equal
        if (lattice == "hexagon") {
                if (mapDim >2) {
                        stop("Using hexagon in more than 2 dimensions not allowed!")
                }
                # sequence of every other index: 2, 4, 6, per each row
                # ie. if we have 2 rows with 10 mapUnits, we need the following seqs:
                # 0,2,4 and 7,9.
                nrSeqs <- mapUnits/gridSize[1]
                for (i in 1:nrSeqs){
                        # in case of 5x2 grid this will generate the following sequences:
                        # 2,4 and 6,8 - we need one sequence per each "model units y-dim row"
                        xOffsetInd <- seq(from = 2+(i-1)*gridSize[1], to = i*gridSize[1], by = 2)
                        xOffsetInd <- subset(xOffsetInd, xOffsetInd <= (i*(mapUnits/gridSize[2])))
                        # move x coordinates by 0.5
                        coordMap[xOffsetInd, 1] = coordMap[xOffsetInd, 1] + 0.5
                }
        }
        if (shape == "sheet") {
                if (lattice == "hexagon") {
                        # multiply all y-coords by sqrt(0.75)
                        coordMap[, 2] <- coordMap[, 2]*sqrt(0.75)
                }
        }
        return(coordMap)
}

# getUnitDistances - calculates a matrix of SOM units distances on SOM grid
# It returns a matrix of distances between each of the SOM units
# It accpts the following parameters:
# coordMap - map of SOM groid units coordinates
# shape - SOM grid shape. Currently only shet is supported. Default: sheet
getUnitDistances <- function(coordMap, shape = "sheet"){
        if (shape != "sheet") {
                stop("Unsupported SOM shape ", shape)
        }
        # number of SOM model units
        mapUnits <- nrow(coordMap)
        # euclidean distance between each unit in coordinates Matrix
        as.matrix(dist(coordMap, diag = TRUE, upper = TRUE))
}
