#' Generate posterior distribution of \eqn{mu}
#'
#' @name mu_f
#' @rdname mu_f
#' @param fit An object of S4 class \code{stanfit} representing
#'   the fitted results.
#' @param plot logical; if \code{TRUE}, then this function plots
#'   posterior distribution of \eqn{mu}.
#' @seealso \code{\link[rstan]{sampling}}, \code{\link[rstan]{stanmodel-class}},
#'   \code{\link[rstan]{stanfit-class}}, \code{\link[rstan]{stan}}.
#' @importFrom stats quantile sd density
#' @importFrom e1071 skewness kurtosis
#' @importFrom rstan extract
#' @importFrom graphics hist lines
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
#' mu_f(fit)
#' }
#' @export
mu_f <- function(fit, plot = TRUE){

  e1 <- extract(fit)
  mu <- e1$mu

  X1 <- mean(mu)
  X2 <- sd(mu)
  X3 <- quantile(mu, c(.025,.975))
  X4 <- mean(mu < 0)
  X5 <- quantile(mu, c(.25,.50,.75))
  X6 <- skewness(mu)
  X7 <- kurtosis(mu)

  if(plot == TRUE){
    hist(mu, xlab = "mu", freq = FALSE, br = 100,
         main = "Posterior Distribution of mu")
    ds <- density(mu)
    lines(ds$x, ds$y, col = 4, lwd = 2)
  }

  return(list(mean = X1, sd = X2, "95%CrI" = X3, "Pr(mu<0)" = X4,
              quartiles = X5, skewness = X6, kurtosis = X7))

}
