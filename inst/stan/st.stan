
functions {
  real skew_t_lpdf(real y, real xi, real omega, real nu, real alpha) {
    return log(2) - log(omega) +
      student_t_lpdf((y - xi)/omega | nu, 0, 1) +
      student_t_lcdf(alpha*(y - xi)*sqrt((nu + 1)/
        (nu + (y - xi)*(y - xi)/(omega*omega)))/omega | (nu + 1), 0, 1);
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
  real<lower=2.5, upper=1000> nu;
  real theta[K];
  real theta_new;
}
transformed parameters {
  real mu;
  mu = xi + omega*sqrt(nu)*tgamma(0.5*(nu - 1))*alpha/
    (sqrt(pi())*tgamma(0.5*nu)*sqrt(1 + alpha^2));
}
model{
  for(i in 1:K) {
    y[i] ~ normal(theta[i], se[i]);
    theta[i] ~ skew_t(xi, omega, nu, alpha);
  }
  xi ~ normal(0, 100);
  omega ~ uniform(0, 20);
  alpha ~ normal(0, 5);
  nu ~ exponential(0.10);
  theta_new ~ skew_t(xi, omega, nu, alpha);
}
generated quantities{
  vector[K] log_lik;
  for (i in 1:K) log_lik[i] = normal_lpdf(y[i] | theta[i], se[i]);
}
