# Linear Regression

Linear regression is implemented in `linearRegression.R` R script. The script allows to normalize training set supplied as a parameter to speed up the [Gradient Descent](https://en.wikipedia.org/wiki/Gradient_descent). 

## Example Usage

You must have R installed on your computer. This project's R scripts were tested on `R version 3.2.2 (2015-08-14)-- "Fire Safety"`. 

You can pass the following parameters `computeModel.R` script:

- path to a training set file
- data type: csv, matlab, png
- normalize (scale the features) the training data set (boolean: TRUE or FALSE)
- gradient descent step alpha (non-negative float)
- number of gradient descent iterations (positive integer)

Linear regression with feature normalization:
```
$ Rscript computeModel.R "data/training_set_multi_data.csv" "csv" TRUE 0.3 400
Loading training set: data/training_set_multi_data.csv
Normalizing features matrix
Running gradient descent for alpha=0.3 iterations=400
Computed model parameters: 340412.659574468, 110631.050278846, -6649.4742708198
```

Linear regression without feature normalization:
```
$ Rscript computeModel.R "data/training_set_uni_data.csv" "csv" FALSE 0.01 1500
Loading training set: data/training_set_uni_data.csv
Running gradient descent for alpha=0.01 iterations=1500
Computed model parameters: -3.63029143940436, 1.16636235033558
```
