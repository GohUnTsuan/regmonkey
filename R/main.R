#' @importFrom utils combn
generate_combinations <- function(control_vars, mandatory_vars = NULL) {
  if (!is.null(mandatory_vars)) {
    control_vars <- setdiff(control_vars, mandatory_vars)
  }
  unlist(lapply(0:length(control_vars), function(i) {
    combn(control_vars, i, simplify = FALSE)
  }), recursive = FALSE)
}
#' @importFrom stats as.formula lm
create_formula <- function(dependent_var, independent_var, controls) {
  as.formula(paste(dependent_var, "~", paste(c(independent_var, controls), collapse = " + ")))
}

perform_regression <- function(data, formula, independent_var, significance_level = 0.05, direction = "both") {
  model <- lm(formula, data = data)
  summary_model <- summary(model)
  coef_data <- summary_model$coefficients
  coef_names <- rownames(coef_data)

  # select coefficient and P value of the independent variable
  coef_index <- grepl(independent_var, coef_names)
  coef_significant <- coef_data[coef_index, "Pr(>|t|)"] < significance_level
  coef_estimate <- coef_data[coef_index, "Estimate"]

  # set according to the direction parameter.
  if (direction == "both") {
    return(any(coef_significant))
  } else if (direction == "positive") {
    return(any(coef_significant & coef_estimate > 0))
  } else if (direction == "negative") {
    return(any(coef_significant & coef_estimate < 0))
  } else {
    stop("Invalid direction specified. Use 'both', 'positive', or 'negative'.")
  }
}
#' RegMonkey: Automated Regression Analysis
#'
#' This function performs automated regression analysis by iterating over possible
#' combinations of control variables, with or without mandatory variables. It assesses
#' the significance of independent variables' effects on a dependent variable.
#'
#' @param data A data frame containing the variables referenced in the formula.
#' @param dependent_var A string specifying the name of the dependent variable.
#' @param independent_vars A character vector specifying the names of independent variables
#'                         to be tested in the model.
#' @param control_vars An optional character vector of control variables that may be included
#'                     in the model. Default is NULL.
#' @param mandatory_vars An optional character vector of variables that must always be included
#'                       as controls in every model tested. Default is NULL.
#' @param significance_level A numeric value specifying the significance level for the
#'                           hypothesis test of the coefficients. Default is 0.05.
#' @param direction A string indicating the direction of the effect to test: 'both' for both
#'                  positive and negative, 'positive' only for positive, and 'negative' only
#'                  for negative effects. Default is 'both'.
#'
#' @return A list of significant combinations. Each element of the list is itself a list
#'         containing the independent variable and the controls under which it was found
#'         significant.
#'
#' @examples
#' data <- data.frame(y = rnorm(100), x1 = rnorm(100), x2 = rnorm(100), x3 = rnorm(100))
#' significant_results <- regmonkey(data, "y", c("x1", "x2"), control_vars = c("x3"))
#'
#' @export
#'
regmonkey <- function(data, dependent_var, independent_vars, control_vars = NULL, mandatory_vars = NULL, significance_level = 0.05, direction = "both") {
  control_combinations <- generate_combinations(control_vars, mandatory_vars)
  significant_combinations <- list()
  total_combinations <- length(control_combinations)

  for (independent_var in independent_vars) {
    cat("\nProcessing independent variable:", independent_var, "\n")
    for (i in seq_along(control_combinations)) {
      controls <- c(mandatory_vars, control_combinations[[i]])
      cat("Processing combination", i, "of", total_combinations, ":", paste(controls, collapse = ", "), "\n")

      formula <- create_formula(dependent_var, independent_var, controls)
      significant <- perform_regression(data, formula, independent_var, significance_level, direction)

      if (significant) {
        significant_combinations[[length(significant_combinations) + 1]] <- list(independent_var = independent_var, controls = controls)
      }
    }
  }

  return(significant_combinations)
}
