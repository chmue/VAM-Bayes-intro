
data {
  int<lower=0> n;
  vector[n] y;
}

parameters {
  real mu;
  real<lower=0> sigma;
}

model {
  # NB: normal() is vectorised!
  y ~ normal(mu, sigma);
}

