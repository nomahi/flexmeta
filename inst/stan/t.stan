
data{
  int<lower=0> K;
  real y[K];
  real<lower=0> se[K];
}
parameters {
  real xi;
  real<lower=0> omega;
  real<lower=2.5, upper=1000> nu;
  real theta[K];
}
transformed parameters {
  real mu;
  mu = xi;
}
model{
  for(i in 1:K) {
    y[i] ~ normal(theta[i], se[i]);
    theta[i] ~ student_t(nu, xi, omega);
  }
  xi ~ normal(0, 100);
  omega ~ uniform(0, 20);
  nu ~ exponential(0.10);
}
generated quantities{
  vector[K] log_lik;
  real theta_new;
  for (i in 1:K) log_lik[i] = normal_lpdf(y[i] | theta[i], se[i]);
  theta_new = student_t_rng(nu, xi, omega);
}
