# trainNN is a wrapper function that calls particular Neural Net learning function
# based on the parameter passed in nnType. It currently supports backprop NN only
# It accepts the following parameters:
# nnType        - neural network type (backprop). Default: backprop
# trainDataPath - path to training data set
# dataType      - type of the data set file(s). Default; csv
# normalize     - do you need to perform feature scaling? Default: FALSE
# lambda        - regularization parameter. If NA, no regularization is done. Default: NA
trainNN <- function(nnType = "backprop", trainDataPath, dataType = "csv", 
                    normalize = FALSE, lambda = NA) {
        # TODO: hack this away
        nnScriptPath <- file.path(".", "backPropNN.R")
        source(nnScriptPath)
        switch(nnType,
               "backprop" = backPropNN(trainDataPath, dataType, normalize, lambda)
               )
}
