# Neural Networks

This folder will [hopefully] contain some implementations of different Neural Networks. 

Currently it only contains basic implementation of backpropagation algorithm for 3 layers Neural Network classifier for 10 different labels. Current implementation does not allow for differnt NN architectures but it might do in the future.

Backpropagation NN example uses a sample of 5000 images from [MNIST](http://yann.lecun.com/exdb/mnist/) database for training and validation. It performs classification of digits from 0-9.

## Usage

You must have R installed on your computer. Provided scripts were tested on `R version 3.2.2 (2015-08-14) -- "Fire Safety"`.
There is a simple R script (`NNClassify.R`) provided to demonstrate the NN training and validation. The script accepts following cli parameters:
- path to a training set CSV file
- type of the training set
- normalize - TRUE/FALSE - do you need to scale the features in the training set?
- lambda - regularization parameter. If not specified regularization is not performed

# Example usage

```
Rscript nnClassify.R "data/data.csv" "csv" FALSE 1
Loading training set: data/data.csv
Done!
Computing BFGS optimized NN parameters with 50 iterations
initial  value 7.038124
iter  10 value 1.814019
iter  20 value 1.099056
iter  30 value 0.814639
iter  40 value 0.669605
iter  50 value 0.580098
final  value 0.580098
stopped after 50 iterations
Done computing NN parameter!
Neural Network classification accuracy: 93.4
```
