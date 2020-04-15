
util_check_num <- function(var, varname = NULL) {

  if (is.null(varname)) {
    varname <- deparse(substitute(var))
  }

  if (is.null(var)) {
    stop(paste0("'", varname, "' is a null value."))
  } else if (any(is.nan(var))) {
    stop(paste0("'", varname, "' has NaN(s)."))
  } else if (any(is.na(var))) {
    stop(paste0("'", varname, "' has missing value(s)."))
  } else if (any(is.infinite(var))) {
    stop(paste0("'", varname, "' has infinite value(s)."))
  } else if (any(is.complex(var))) {
    stop(paste0("'", varname, "' has complex value(s)."))
  } else if (any(is.character(var))) {
    stop(paste0("'", varname, "' has character value(s)."))
  }

}

util_check_nonneg <- function(var) {

  varname <- deparse(substitute(var))
  util_check_num(var, varname)
  if (min(var) < 0.0) {
    stop(paste0("'", varname, "' should be non-negative."))
  }

}

util_check_inrange <- function(var, min, max) {

  varname <- deparse(substitute(var))
  util_check_num(var, varname)
  if (var < 0.0 | var > 1.0) {
    stop(paste0("'", varname, "' should be in the range of [", min, ", ", max, "]."))
  }

}

util_check_gt <- function(var, min) {

  varname <- deparse(substitute(var))
  util_check_num(var, varname)
  if (!(var > min)) {
    stop(paste0("'", varname, "' should be greater than ", min, "."))
  }

}

util_check_ge <- function(var, min) {

  varname <- deparse(substitute(var))
  util_check_num(var, varname)
  if (!(var >= min)) {
    stop(paste0("'", varname, "' should be greater than or equal to ", min, "."))
  }

}
