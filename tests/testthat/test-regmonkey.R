test_that("regmonkey function output matches expected results", {
  df <- mtcars
  results <- regmonkey(
    data = df,
    dependent_var = "mpg",
    independent_vars = c("cyl"),
    control_vars = c("am"),
    significance_level = 0.1
  )

  expect_results <- list(
    list(
      dependent_var = "mpg",
      independent_var = "cyl",
      controls = character(0)
    ),
    list(
      dependent_var = "mpg",
      independent_var = "cyl",
      controls = c("am")
    )
  )

  expect_equal(results, expect_results)
})
