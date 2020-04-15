#' Converting binary data
#'
#' Converting binary outcome data to the effect size estimates
#' and the within studies standard errors vector
#'
#' @details This function implements methods for logarithmic
#' odds ratio, logarithmic relative risk, and risk difference
#' described in Hartung & Knapp (2001).
#'
#' @name convert_bin
#' @rdname convert_bin
#' @param m1 A vector of the number of successes in experimental group
#' @param n1 A vector of the number of patients in experimental group
#' @param m2 A vector of the number of successes in contorol group
#' @param n2 A vector of the number of patients in contorol group
#' @param type the outcome measure for binary outcome data (default = "logOR").
#' \itemize{
#' \item \code{logOR}: logarithmic odds ratio,
#'                     which is defined by \eqn{=\log \frac{(m1+0.5)(n2-m2+0.5)}{(n1-m1+0.5)(m2+0.5)}}.
#' \item \code{logRR}: logarithmic relative risk,
#'                     which is defined by \eqn{=\log \frac{(m1+0.5)(n2+0.5)}{(n1+0.5)(m2+0.5)}}.
#' \item \code{RD}:    risk difference,
#'                     which is defined by \eqn{=\frac{m1}{n1}-\frac{m2}{n2}}.
#' }
#' @return A \code{data.frame} of study data.
#' \itemize{
#' \item \code{y}: A numeric vector of the effect size estimates.
#' \item \code{se}: A numeric vector of the within studies standard errors.
#' }
#' @references
#' Hartung, J., and Knapp, G. (2001).
#' A refined method for the meta-analysis of controlled clinical trials
#' with binary outcome.
#' \emph{Stat Med.}
#' \strong{20}(24): 3875-3889.
#' \url{https://doi.org/10.1002/sim.1009}
#' @examples
#' require("flexmeta")
#' m1 <- c(15,12,29,42,14,44,14,29,10,17,38,19,21)
#' n1 <- c(16,16,34,56,22,54,17,58,14,26,44,29,38)
#' m2 <- c( 9, 1,18,31, 6,17, 7,23, 3, 6,12,22,19)
#' n2 <- c(16,16,34,56,22,55,15,58,15,27,45,30,38)
#' dat <- convert_bin(m1, n1, m2, n2, type = "logOR")
#' print(dat)
#' @export
convert_bin <- function(m1, n1, m2, n2, type = c("logOR", "logRR", "RD")) {

  # initial check
  lstt <- c("logOR", "logRR", "RD")
  type <- match.arg(type)

  util_check_nonneg(m1)
  util_check_nonneg(n1)
  util_check_nonneg(m2)
  util_check_nonneg(n2)

  if (length(m1) != length(n1) || length(n1) != length(m2) || length(m2) != length(n2)) {
    stop("'m1', 'n1', 'm2', and 'n2' should have the same length.")
  } else if (!is.element(type, lstt)) {
    stop("Unknown 'type' specified.")
  }

  res <- NULL
  if (type == "logOR") {
    res$y <- log((m1 + 0.5)*(n2 - m2 + 0.5)/(n1 - m1 + 0.5)/(m2 + 0.5))
    res$se <- sqrt(1.0/(m1 + 0.5) + 1.0/(n1 - m1 + 0.5) + 1.0/(m2 + 0.5) + 1.0/(n2 - m2 + 0.5))
  } else if (type == "logRR") {
    res$y <- log((m1 + 0.5)*(n2 + 0.5)/(n1 + 0.5)/(m2 + 0.5))
    res$se <- sqrt(1.0/(m1 + 0.5) - 1.0/(n1 + 0.5) + 1.0/(m2 + 0.5) - 1.0/(n2 + 0.5))
  } else if (type == "RD") {
    res$y <- m1/n1 - m2/n2
    res$se <- sqrt(
      ((m1 + 0.0625)/(n1 + 0.125))*((n1 - m1 + 0.0625)/(n1 + 0.125))/n1 +
        ((m2 + 0.0625)/(n2 + 0.125))*((n2 - m2 + 0.0625)/(n2 + 0.125))/n2
    )
  }

  res <- data.frame(res)

  return(res)

}
