
functions {
  real besselK(real v, real z);
  real sinh_arcsin_lpdf(real y, real xi, real omega, real epsilon, real delta) {
    return normal_lpdf(sinh(delta*asinh((y - xi)/omega) - epsilon) | 0, 1) +
      log(delta) - 0.5*log(1 + pow(y - xi, 2)/pow(omega, 2)) - log(omega) +
      log(cosh(delta*asinh((y - xi)/omega) - epsilon));
  }
  real sinh_arcsin_rng(real xi, real omega, real epsilon, real delta) {
    return xi + omega*sinh((asinh(normal_rng(0, 1)) + epsilon)/delta);
  }
  real pq(real q) {
    return exp(0.25)/sqrt(8.0*pi())*
      (besselK((q + 1.0)*0.5, 0.25) + besselK((q - 1.0)*0.5, 0.25));
  }
}
data {
  int<lower=0> K;
  real y[K];
  real<lower=0> se[K];
}
parameters {
  real xi;
  real<lower=0> omega;
	real epsilon;
  real<lower=0> delta;
  real theta[K];
}
model {
  for(i in 1:K) {
    y[i] ~ normal(theta[i], se[i]);
    theta[i] ~ sinh_arcsin(xi, omega, epsilon, delta);
  }
  xi ~ normal(0, 100);
  omega ~ uniform(0, 20);
  epsilon ~ normal(0, 100);
  delta ~ uniform(0, 100);
}
generated quantities {
  real sx_m1;
  real mu;
  real theta_new;
  vector[K] log_lik;
  sx_m1 = sinh(epsilon/delta)*pq(1.0/delta);
  mu = omega*sx_m1 + xi;
  for (i in 1:K) log_lik[i] = normal_lpdf(y[i] | theta[i], se[i]);
  theta_new = sinh_arcsin_rng(xi, omega, epsilon, delta);
}
