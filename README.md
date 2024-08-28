
<!-- README.md is generated from README.Rmd. Please edit that file -->

# regmonkey

<!-- badges: start -->

[![R-CMD-check](https://github.com/GohUnTsuan/regmonkey/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/GohUnTsuan/regmonkey/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/GohUnTsuan/regmonkey/graph/badge.svg)](https://app.codecov.io/gh/GohUnTsuan/regmonkey)
<!-- badges: end -->

The goal of `regmonkey` is to quickly performing batch regression on
different variable combinations and different regression models,
specifying necessary variables, significance levels, and directions. And
output significant models after regression.

## Installation

You can install the development version of `regmonkey` from
[GitHub](https://github.com/) with:

``` r
library(remotes)
install_github('GohUnTsuan/regmonkey')
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
#library(regmonkey)
df <- mtcars
results <- regmonkey(
  data = df, 
  dependent_var = "mpg",  
  independent_vars = c("cyl"), 
  control_vars = c("am"),
  significance_level = 0.1
)
print(results)
```
