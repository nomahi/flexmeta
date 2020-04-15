#' Generate DIC
#'
#' @name dic
#' @rdname func_dic
#' @param fit An object of S4 class \code{stanfit} representing
#'   the fitted results.
#' @param dat A list of the study data.
#' \itemize{
#' \item \code{y}: A vector of the effect size estimates.
#' \item \code{se}: A vector of the within studies standard error
#'   estimates.
#' }
#' @return
#' A numeric value of \eqn{DIC}.
#' @seealso \code{\link[rstan]{sampling}}, \code{\link[rstan]{stanmodel-class}},
#'   \code{\link[rstan]{stanfit-class}}, \code{\link[rstan]{stan}}.
#' @importFrom stats dnorm
#' @importFrom rstan extract
#' @examples
#' \donttest{
#' require("flexmeta")
#' require("rstan")
#' options(mc.cores = parallel::detectCores())
#'
#' data("clbp")
#' dat <- convert_mean(clbp$n1, clbp$m1, clbp$s1, clbp$n2, clbp$m2, clbp$s2)
#' dat <- list(K = length(dat$y), y = dat$y, se = dat$se)
#'
#' fit <- sampling(sm_sn, data = dat,
#'   chains = 1, warmup = 5000, iter = 30000, seed = 2645751)
#'
#' dic(fit, dat)
#' }
#' @export
dic <- function(fit, dat){

  y <- dat$y
  se <- dat$se

  K <- length(y)

  ef <- extract(fit)
  theta.ef <- extract(fit)$theta

  D1 <- D2 <- 0

  for(i in 1:K){
    D1 <- D1 - 2*mean(log(dnorm(y[i], theta.ef[, i], se[i])))
    D2 <- D2 - 2*log(dnorm(y[i], mean(theta.ef[, i]), se[i]))
  }

  pD <- D1 - D2
  DIC <- pD + D1

  return(DIC)

}
