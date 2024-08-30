

#' Summarize and Display Regression Results
#'
#' This function processes the results from the `regmonkey` function, creating and displaying regression models for each significant variable combination identified. It utilizes the `modelsummary` package to format and present these results clearly, allowing for an easy evaluation of the significance and impact of various predictors.
#'
#' @importFrom stats lm summary.lm
#' @importFrom modelsummary modelsummary
#' @importFrom utils installed.packages
#' @param significant_results A list of significant variable combinations returned by `regmonkey`. Each element of the list should contain the dependent variable, the independent variable, and the controls under which the significant result was found.
#' @param data The data frame containing all the variables referenced in the regression formulas.
#' @param coef_map_override An optional named vector to override the default mapping of coefficient names in the output. This can be used to provide more readable or specific names for the variables in the regression output. If not provided, the function will automatically extract variable names from the models.
#'
#' @return This function does not return anything; it directly outputs the regression results formatted by the `modelsummary` package to the R console or to an R Markdown document.
#' @export
#'
#' @examples
#' # Assuming `regmonkey` has been run and stored results in `monkey_results`
#' x1 <- rnorm(100, mean = 0, sd = 1)
#' x2 <- rnorm(100, mean = 0, sd = 1)
#' x3 <- rnorm(100, mean = 0, sd = 1)
#' y <- 2 + 1.5 * x1 - 2 * x2 + 0.5 * x3 + rnorm(100, mean = 0, sd = 1)
#' data <- data.frame(y = y, x1 = x1, x2 = x2, x3 = x3)
#' significant_results <- regmonkey(data, "y", c("x1", "x2"), control_vars = c("x3"))
#' summary_reg(significant_results, data)
summary_reg <- function(significant_results, data) {
  models <- list()
  model_names <- list()

  for (i in seq_along(significant_results)) {
    controls <- significant_results[[i]]$controls
    if (length(controls) == 0) {
      # No controls specified
      formula <- as.formula(paste(significant_results[[i]]$dependent_var, "~", significant_results[[i]]$independent_var))

      } else {
      # Controls are specified
      formula <- as.formula(paste(
        significant_results[[i]]$dependent_var,
        "~",
        paste(c(significant_results[[i]]$independent_var, controls), collapse = " + ")
      ))
      }


    model <- lm(formula, data = data)
    models[[i]] <- model
    model_names[[i]] <- paste("Model", i, ":", significant_results[[i]]$independent_var, "with", paste(controls, collapse = ", "))
  }

  # Use modelsummary if installed or just show summaries
  if ("modelsummary" %in% rownames(installed.packages())) {
    modelsummary::modelsummary(models, stars = TRUE)
  } else {
    lapply(models, summary)
  }
}
