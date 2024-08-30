

#' Summarize and Display Regression Results
#'
#' This function processes the results from the `regmonkey` function, creating and displaying regression models for each significant variable combination identified. It utilizes the `modelsummary` package to format and present these results clearly, allowing for an easy evaluation of the significance and impact of various predictors.
#'
#' @importFrom stats lm summary.lm
#' @importFrom modelsummary modelsummary
#'
#' @param significant_results A list of significant variable combinations returned by `regmonkey`. Each element of the list should contain the dependent variable, the independent variable, and the controls under which the significant result was found.
#' @param data The data frame containing all the variables referenced in the regression formulas.
#' @param coef_map_override An optional named vector to override the default mapping of coefficient names in the output. This can be used to provide more readable or specific names for the variables in the regression output. If not provided, the function will automatically extract variable names from the models.
#'
#' @return This function does not return anything; it directly outputs the regression results formatted by the `modelsummary` package to the R console or to an R Markdown document.
#' @export
#'
#' @examples
#' # Assuming `regmonkey` has been run and stored results in `monkey_results`
#' data <- data.frame(y = rnorm(100), x1 = rnorm(100), x2 = rnorm(100), x3 = rnorm(100))
#' significant_results <- regmonkey(data, "y", c("x1", "x2"), control_vars = c("x3"))
#' summary_reg(significant_results, data)

summary_reg <- function(significant_results, data, coef_map_override = NULL) {
  models <- list()
  model_names <- list()

  # Iterate through significant results, create and store a regression model for each significant variable combination
  for (i in seq_along(significant_results)) {
    formula_str <- paste(
      significant_results[[i]]$dependent_var,
      "~",
      paste(c(significant_results[[i]]$independent_var, significant_results[[i]]$controls), collapse = " + ")
    )
    formula <- as.formula(formula_str)
    model <- lm(formula, data = data)
    models[[i]] <- model
    model_names[[i]] <- paste("Model", i, ":", significant_results[[i]]$independent_var, "with", paste(significant_results[[i]]$controls, collapse = ", "))
  }

  # If coef_map_override is provided, use it to replace the default coef_map
  if (!is.null(coef_map_override)) {
    coef_map <- coef_map_override
  } else {
    # Extract all variable names from the models as the default coef_map
    coef_map <- unique(unlist(lapply(models, function(x) rownames(coef(summary(x)$coefficients)))))
  }

  # Use modelsummary to display the results of all models
  modelsummary(models,
               estimate = "{estimate}{stars}",
               gof_omit = "Observations|Residual Std. Error|Adjusted R2|F Statistic",
               coef_map = coef_map,
               model_names = model_names)
}

