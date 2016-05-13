# somNN implement Self Organizing Maps Neural Network algorithm
# it returns the resulting network parameters in a list
# It accepts the following parameters:
# trainDataPath - path to training data set
# dataType      - type of the data set file(s). Default; csv
# normalize     - do you need to perform feature scaling? Default: FALSE
# mapInit       - how to initialize SOM random Default: random
# mapUnits      - nr of map units. If not specified, it's implied form data. Default: NA
# gridSize       - integer vector. If not specified, it's calculated form mapUnits. Default: NULL
# lattice       - output grid: hexagon/rectangle Default: hexagon
# shape         - SOM grid shape; only sheet is supported for now. Default: sheet
# algorithm     - SOM algorithm. batch/seq Default: batch
# neighbFunc    - neighbourhood function gaussian Default: gaussian
somNN <- function(trainDataPath, dataType = "csv", normalize = FALSE, mapInit = "random",
                  mapUnits = NA, gridSize = NULL, lattice = "hexagon", shape = "sheet",
                  algorithm = "batch", neighbFunc = "gaussian") {
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
        somTop <- somTopology(X, mapUnits, gridSize, lattice, shape)
        # init map weights
        somWeights <- somInit(X, somTop$munits, mapInit)
        # initial training a.k.a. SOM ordering
        somWeights <- somTrain("base", somWeights, X, mapUnits, algorithm, neighbFunc)
        ## SOM fine-tuning
        #somWeights <- somTrain("tune", somWeights, X, mapUnits, algorithm, neighbFunc)
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
                        gridSize <- getGridSize(X)
                        # mapUnits cover area of gridSize
                        mapUnits <- prod(gridSize)
                }
        } else {
                # mapUnits are determined by the size of X
                # mapUnits override gridSize parameter
                gridSize <- getGridSize(X, mapUnits)
                # mapUnits are reset to reflect the gridSize
                # TODO: can we avoid doing this? Check getGridSize()
                mapUnits <- prod(gridSize)
        }
        # return SOM topology parameters
        list("munits" = mapUnits, "gridsize" = gridSize, "lattice" = lattice, "shape" = shape)
}

# getGridSize calculates SOM grid size and returns it as a vector.
# getGridSize determines the grid size from eigenvectors of input data
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
                xDim <- round(sqrt(mapUnits))
                yDim <- round(mapUnits / xDim)
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
# it accepts following parameters:
# X - training data
# mapInit - init type: random Default: random
# map - actual map matrix to be initialized
somInit <- function(X, mapUnits, mapInit = "random"){
        switch(mapInit,
               "random" = randInit(X, mapUnits)
               )
}

# randInit initializes SOM with random uniformly distributed values in
# range [min(xi), max(xi)] where min,max are calculated for each data feature
# It returns som weights matrix with following dimensions: mapUnits x dataDim
# It accepts the following parameters
# X - training data
# mapUnits - SOM units
randInit <- function(X, mapUnits){
        # read in data dimension
        dataDim <- ncol(X)
        # find max and min in eeach data column/feature
        ma <- apply(X,2,max)
        mi <- apply(X,2,min)
        # initialize somWeights matrix
        somWeights <- matrix(runif(mapUnits*dataDim), mapUnits, dataDim)
        for (i in dataDim) {
                somWeights[,i] <- ((ma-mi) * somWeights[,i]) + mi
        }
        somWeights
}

# somTrain trains SOM neural network. It returns a matrix of SOM model units weights.
# It accepts the following parameters:
# X - training data set
# trainingType  - base/tune. Default: base
# somWeights - model units weights
# algorithm  - seq/batch. Default: seq
# neighbFunc - neighbourhood function. Default: gaussian
somTrain <- function(trainingType = "base", somWeights, X, mapUnits,
                     algorithm = "batch", neighbFunc = "gaussian"){
        switch(trainingType,
               "base" = baseTraining(somWeights, X, mapUnits, algorithm, neighbFunc),
               "tune" = tuneTraining(somWeights, X, mapUnits, algorithm, neighbFunc)
               )
}

# baseTraining implements initial SOM training
baseTraining <- function(somWeights, X, mapUnits, algorithm, neighbFunc){
        # set the trainLen - short for base training
        unitsPerData <- mapUnits/nrow(X)
        # must be at least 1 training
        trainLen <- max(1, 40*unitsPerData)
        # set the initial learning rate
        alphaInit <- 0.5
        # set neighbourhood radius - depends on size of grid
        # normally goes from radiusInit -> 1
        ms <- max(mapGrid)
        radiusInit <- max(1,ceil(ms/4))
        radiusFin  <- 1
}

# tuneTraining implements SOM fine tuning
tuneTraining <- function(somWeights, X, mapUnits, algorithm, neighbFunc){
        # set the trainLen - longer for fine-tune training
        unitsPerData <- mapUnits/nrow(X)
        # must be at least 1 training
        trainLen <- max(1, 100*unitsPerData)
        # set the initial learning rate - 10x smaller than initial training
        alphaInit <- 0.05
        # set neighbourhood radius - depends on size of grid
        # normally goes from radiusInit -> 1; smaller initial radius than base training
        ms <- max(mapGrid)
        radiusInit <- max(1,ceil(ms/8))
        radiusFin  <- 1
}

# alpha implements SOM learning rate. alpha decays with iteration i.e. monotonically decreases
# It accepts following parameters:
# alphaType - inv/lin Default: inv
# alphaInit - initial value of learning rate. Default: 0.5
# trainLen  - training length
# iter      - iteration number
alpha <- function(alphaType = "inv", alphaInit = 0.5, trainLen, iter) {
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
# radiusFin  - final value of radius
# trainLen   - training length
# iter       - iteration number
radius <- function(radiusInit, radiusFin, trainLen, iter){
        # first returned value = radiusInit as iter=1 -> radiusInit + 0
        # last  returned value = radiusFin  as iter = trainLen -> radiusInit-radiusInit+radiusFin
        radiusInit + (radiusFin-radiusInit)*(iter-1)/(trainLen-1)
}

# neighbFunc - implements neighbourhood function based on type
# it accepts following parameters
# funcType  - gaussian Default: gaussian
# unitDists - matrix of distances between units in the SOM grid
# radius    - radius distance from the BMU
neighbFunc <- function(){
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
                # how long should the groups be
                reps <- mapUnits/gridSize[i]
                coordMap[,i] <- rep(0:(gridSize[i]-1), each = reps)
        }
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
                        # in case of 5x2 grid this will generate the following (per row) sequences:
                        # 2,4 and 6,8 - remember we need one sequence per each "model units y-dim row"
                        xOffsetInd <- seq(2+(i-1)*gridSize[1], by = 2, len = mapUnits/gridSize[1])
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
        as.matrix(dist(getUnitCoords(getGridSize(X)), diag = TRUE, upper = TRUE))
}
