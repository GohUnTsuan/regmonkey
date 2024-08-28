
<!-- README.md is generated from README.Rmd. Please edit that file -->

# regmonkey

<!-- badges: start -->
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
#> Using GitHub PAT from the git credential store.
#> Skipping install of 'regmonkey' from a github remote, the SHA1 (df5cdd78) has not changed since last install.
#>   Use `force = TRUE` to force installation
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
