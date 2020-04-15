
functions {
  int signnum(real x) {
    return x < 0 ? -1 : x > 0;
  }
  real as_lpdf(real y, real xi, real omega, real nu, real alpha) {
    return log(2) - log(omega) -
      log(2) - (1/nu)*log(nu) - log(tgamma(1 + 1/nu)) -
      (fabs((y - xi)/omega))^nu / nu +
      normal_lcdf(signnum(alpha*(y - xi)/omega)*
      fabs(alpha*(y - xi)/omega)^(nu/2)/sqrt(nu/2) | 0, 1);
  }
}
data{
  int<lower=0> K;
  real y[K];
  real<lower=0> se[K];
}
parameters {
  real xi;
  real<lower=0> omega;
  real alpha;
  real<lower=.5, upper=100> nu;
  real theta[K];
  real theta_new;
}
transformed parameters {
  real mu;
  mu = xi + signnum(alpha)*omega*(nu^(1/nu))*tgamma(2/nu)*
    (2*student_t_cdf(sqrt((fabs(alpha)^nu)*4/nu), 4/nu, 0, 1) - 1);
}
model{
  for(i in 1:K) {
    y[i] ~ normal(theta[i], se[i]);
    theta[i] ~ as(xi, omega, nu, alpha);
  }
  xi ~ normal(0, 100);
  omega ~ uniform(0, 20);
  alpha ~ normal(0, 5);
  nu ~ exponential(0.10);
  theta_new ~ as(xi, omega, nu, alpha);
}
generated quantities{
  vector[K] log_lik;
  for (i in 1:K) log_lik[i] = normal_lpdf(y[i] | theta[i], se[i]);
}
