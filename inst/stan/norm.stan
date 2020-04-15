
data{
  int<lower=0> K;
  real y[K];
  real<lower=0> se[K];
}
parameters {
  real xi;
  real<lower=0> omega;
  real theta[K];
}
transformed parameters {
  real mu;
  mu = xi;
}
model{
  for(i in 1:K) {
    y[i] ~ normal(theta[i], se[i]);
    theta[i] ~ normal(xi, omega);
  }
  xi ~ normal(0, 100);
  omega ~ uniform(0, 20);
}
generated quantities{
  vector[K] log_lik;
  real theta_new;
  for (i in 1:K) log_lik[i] = normal_lpdf(y[i] | theta[i], se[i]);
  theta_new = normal_rng(xi, omega);
}
