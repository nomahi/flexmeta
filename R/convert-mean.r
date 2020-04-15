#' Converting means and standard deviations
#'
#' Converting estimated means and standard deviations in
#' experimental and contorol groups to the effect size
#' estimates and the within studies standard errors vector
#'
#' @name convert_mean
#' @rdname convert_mean
#' @param n1 A vector of number of observations in experimental group
#' @param m1 A vector of estimated mean in experimental group
#' @param s1 A vector of standard deviation in experimental group
#' @param n2 A vector of number of observations in experimental group
#' @param m2 A vector of estimated mean in experimental group
#' @param s2 A vector of standard deviation in experimental group
#' @param pooled logical; if \code{TRUE}, a pooled variance is used.
#'   The default is \code{FALSE}.
#' @return A \code{data.frame} of study data.
#' \itemize{
#' \item \code{y}: A numeric vector of the effect size estimates.
#' \item \code{se}: A numeric vector of the within studies standard error estimates.
#' }
#' @examples
#' require("flexmeta")
#' data("clbp")
#' dat <- convert_mean(clbp$n1, clbp$m1, clbp$s1, clbp$n2, clbp$m2, clbp$s2)
#' print(dat)
#' @export
convert_mean <- function(n1, m1, s1, n2, m2, s2, pooled = FALSE, type=c("MD","SMD")) {

  # initial check
  lstt <- c("MD", "SMD")
  type <- match.arg(type)
  
  # initial check
  util_check_nonneg(n1)
  util_check_nonneg(m1)
  util_check_nonneg(s1)
  util_check_nonneg(n2)
  util_check_nonneg(m2)
  util_check_nonneg(s2)
  util_check_num(pooled)

  if (length(n1) != length(m1) || length(m1) != length(s1) || length(s1) != length(n2) ||
      length(n2) != length(m2) || length(m2) != length(s2)) {
    stop("'n1', 'm1', 's1', 'n2', 'm2', and 's2' should have the same length.")
  }else if (!is.element(type, lstt)) {
    stop("Unknown 'type' specified.")
  }

  if(type=="MD"){
   res <- NULL
   res$y <- m1 - m2
   if (pooled) {
     res$v <- ((n1 - 1)*s2^2 + (n2 - 1)*s2^2)/(n1 + n2 - 2)*(1/n1 + 1/n2)
   } else {
     res$v <- s1^2/n1 + s2^2/n2
   }
  }
  
  if(type=="SMD"){
   res <- NULL
   s0 <- sqrt(((n1 - 1)*s1^2 + (n2 - 1)*s2^2)/(n1 + n2 - 2))
   res$y <- (m1 - m2)/s0
   res$v <- 1/n1 + 1/n2
  }

  res <- data.frame(res)

  return(res)

}
