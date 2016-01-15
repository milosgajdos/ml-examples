# ML

This directory will contain a collection of examples of basic Machine Learning algorithms implementations in [Elixir](http://elixir-lang.org/).

Currently it only provides a simple [and maybe a bit naiive] [Linear Regression](https://en.wikipedia.org/wiki/Linear_regression) implementation, but hopefully if time allows I'll be adding other algorithms o/ 

# Linear Regression

Linear regression is implemented in LinearRegression module. The OTP application also provides TrainingSet module that can load a training set from a specially formate CSV file. The biggest issue with TrainingSet is that it loads the whole data set into memory, so if you are trying to load big training data sets this will have a noticeable effect on your memory usage.

## Usage

```erlang
$ iex -S mix
Erlang/OTP 18 [erts-7.2.1] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Compiled lib/linear_regression.ex
Interactive Elixir (1.2.0) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> ts = LinearRegression.load_training_set("test/training_set_multi_data.csv")
iex(2)> {_, cols} = ExMatrix.size(ts.x)
ex(3)> initial_theta = ExMatrix.new_matrix(cols, 1)
[[0], [0], [0]]
iex(4)> LinearRegression.get_model(ts.x, ts.y, theta, 0.03, 55)
[[4.530453469245898e281], [1.0463682210191555e285], [1.5113026536676427e282]]
```
