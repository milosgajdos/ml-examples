# ML

This directory will contain a collection of examples of basic Machine Learning algorithms implementations in [R](https://www.r-project.org/).

Currently it only provides a simple [Linear Regression](https://en.wikipedia.org/wiki/Linear_regression) implementation, but hopefully if the time allows I'll be adding more algorithms o/ 

# Linear Regression

Linear regression is implemented in `linearRegression.R` R script. The script automatically normalizes training set supplied as a parameter to speed up the [Gradient Descent](https://en.wikipedia.org/wiki/Gradient_descent). There is a few other helper R scripts provided which are loaded by `linearRegression.R` when it runs and which can be used separately.

## Usage

You must have R installed on your computer. Provided scripts were tested on `R version 3.2.2 (2015-08-14) -- "Fire Safety"`. Parameters passed to `run.R` script are as follows:
- gradient descent step alpha (non-negative float)
- number of gradient descent iterations (positive integer)
- normalize the training data set (boolean: TRUE or FALSE)

```
$ Rscript run.R "data/training_set_multi_data.csv" 0.3 400 TRUE
Loading training set: data/training_set_multi_data.csv
Normalizing features matrix
Running gradient descent for alpha=0.3 iterations=400
Computed model parameters: 340412.659574468, 110631.050278846, -6649.4742708198
$ Rscript run.R "data/training_set_uni_data.csv" 0.01 1500 FALSE
Loading training set: data/training_set_uni_data.csv
Running gradient descent for alpha=0.01 iterations=1500
Computed model parameters: -3.63029143940436, 1.16636235033558
```
