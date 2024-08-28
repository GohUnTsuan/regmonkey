
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
#> Using GitHub PAT from the git credential store.
#> Downloading GitHub repo GohUnTsuan/regmonkey@HEAD
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>      checking for file ‘/private/var/folders/kt/34p1l1y55c36jvtff_p9ys700000gn/T/Rtmp8NXix2/remotes1656150ec2ae2/GohUnTsuan-regmonkey-9f85b04/DESCRIPTION’ ...  ✔  checking for file ‘/private/var/folders/kt/34p1l1y55c36jvtff_p9ys700000gn/T/Rtmp8NXix2/remotes1656150ec2ae2/GohUnTsuan-regmonkey-9f85b04/DESCRIPTION’
#>   ─  preparing ‘regmonkey’:
#>    checking DESCRIPTION meta-information ...  ✔  checking DESCRIPTION meta-information
#>   ─  checking for LF line-endings in source and make files and shell scripts
#>   ─  checking for empty or unneeded directories
#>   ─  building ‘regmonkey_0.0.0.9001.tar.gz’
#>      
#> 
#> Installing package into '/Users/wuwenquan/Library/Caches/org.R-project.R/R/renv/library/regmonkey-1d25ecea/macos/R-4.4/aarch64-apple-darwin20'
#> (as 'lib' is unspecified)
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
