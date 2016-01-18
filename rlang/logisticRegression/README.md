# Logistic Regression

[Logistic regression](https://en.wikipedia.org/wiki/Logistic_regression) is implemented in `logisticRegression.R` R script. The script calculates optimized model parameters by calling R's `optim()` function.Currently, the script uses `BFGS` optimization method. There is also a few other R scripts provided which are loaded by `logisticRegression.R` automatically when it runs. These scripts can also be used separately.

## Usage

You must have R installed on your computer. Provided scripts were tested on `R version 3.2.2 (2015-08-14) -- "Fire Safety"`. 
There is a simple R script (`computeModel.R`) provided to demonstrate basic implementation features. The script accepts following cli parameters:
- path to a training set CSV file
- regularization - TRUE/FALSE
    - if regularization is set to TRUE, lambda parameter is required

Example usage:

With BGFS optimization (default):
```
Loading training set: data/data1.csv
Running logistic regression optimization
Optimal regression cost: 0.210038055121323
Computed model parameters: -19.4945779724232, 0.164422831499694, 0.1535173797787
```

With Nelder and Mead optimization (this ignores gradient function):
```
$ Rscript computeModel.R "data/data1.csv" FALSE
Loading training set: data/data1.csv
Running logistic regression optimization
Computed model parameters: -25.1647048465922, 0.206252402073044, 0.201504607481281
```

### Regularization and feature mapping
Apart from basic implementation of logistic regression, project also provides a possibility to compute regularized logistic regression. Project directory contains `quadrFeature.R` script which implements a simple function that can be used to add new features into the original features matrix X. The function can be passed in as a parameter to `logisticRegression` function to compute parameters of complex models. In general, any feature mapping function can be passed to `logisticRegression` function implemented in `logisticRegression.R` script, but you must also set `mapfeature` argument to `TRUE`, otherwise the feature mapping function will be ignored!

Example usage (R environment is loaded in below example):

```
> list.files()
> [1] "computeModel.R"       "data"                 "logisticRegression.R"
> [4] "quadrFeature.R"       "README.md"
> source("logisticRegression.R")
> source("quadrFeature.R")
> logisticRegression("data/data2.csv", regularize=TRUE, lambda=1, mapFeature=TRUE, mapFunc=quadrFeature)
Loading training set: data/data2.csv
Running regularized logistic regression optimization for lambda: 1
Optimal regression cost: 0.529002742805693
 [1]  1.27268411  0.62557736  1.18093516 -2.01918710 -0.91757433 -1.43191681
 [7]  0.12376226 -0.36515382 -0.35705430 -0.17482016 -1.45846626 -0.05131440
[13] -0.61606367 -0.27463584 -1.19281751 -0.24270985 -0.20571552 -0.04502007
[19] -0.27782958 -0.29526981 -0.45611228 -1.04381248  0.02761362 -0.29267083
[25]  0.01542143 -0.32760216 -0.14389495 -0.92460384
```

