# read cli params
args <- commandArgs(trailingOnly = TRUE)
path <- args[1]
if (!file.exists(path)) {
                stop("File ", path, " does not exist!")
}
