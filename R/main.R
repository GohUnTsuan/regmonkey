generate_combinations <- function(control_vars, mandatory_vars = NULL) {
  if (!is.null(mandatory_vars)) {
    control_vars <- setdiff(control_vars, mandatory_vars)
  }
  unlist(lapply(0:length(control_vars), function(i) {
    combn(control_vars, i, simplify = FALSE)
  }), recursive = FALSE)
}

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
