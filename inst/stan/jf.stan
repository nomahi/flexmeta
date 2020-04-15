
functions {
  real tbeta(real a, real b) {
    return tgamma(a)*tgamma(b)/tgamma(a+b);
  }
  real jf_lpdf(real y, real xi, real omega, real a, real b) {
    return -log(omega) -(a + b - 1)*log(2) - 0.5*log(a + b) - log(tbeta(a, b)) +
      (a + 0.5)*log(1 + (y - xi)/(omega*sqrt(a + b + (y - xi)*(y - xi)/(omega*omega)))) +
      (b + 0.5)*log(1 - (y - xi)/(omega*sqrt(a + b + (y - xi)*(y - xi)/(omega*omega))));
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
  real<lower=1.5> a;
  real<lower=1.5> b;
  real theta[K];
  real theta_new;
}
transformed parameters {
  real mu;
  mu = xi + omega*0.5*(a-b)*sqrt(a+b)*tgamma(a-.5)*tgamma(b-0.5)/(tgamma(a)*tgamma(b));
}
model{
  for(i in 1:K) {
    y[i] ~ normal(theta[i], se[i]);
    theta[i] ~ jf(xi, omega, a, b);
  }
  xi ~ normal(0, 100);
  omega ~ uniform(0, 20);
  a ~ uniform(0, 200);
  b ~ uniform(0, 200);
  theta_new ~ jf(xi, omega, a, b);
}
generated quantities{
  vector[K] log_lik;
  for (i in 1:K) log_lik[i] = normal_lpdf(y[i] | theta[i], se[i]);
}
