# Principal Component Analysis

You can read more about the PCA algorithm [here](http://mlexplore.org/blog/categories/pca/). This directory contains the source code of PCA implementation.

# Usage

You must have R installed on your computer. Provided scripts were tested on `R version 3.2.2 (2015-08-14) -- "Fire Safety"`. Parameters passed to `computePCA.R` scriptre as follows:

- path to a data file
- data type: csv, matlab, png
- normalize data features
- number of components required to be returned

Example running the script:

```
Rscript computePCA.R "data/runner.mat" "matlab" FALSE
All principal components will be returned!
Loading data set: data/runner.mat
Computed principal components: c(-0.76908153413682, -0.639150681646946), c(0.639150681646946, -0.76908153413682)
```

Request only the top principal component:

```
Rscript computePCA.R "data/runner.mat" "matlab" FALSE 1
Loading data set: data/runner.mat
Computed principal components: c(-0.76908153413682, -0.639150681646946)
```
