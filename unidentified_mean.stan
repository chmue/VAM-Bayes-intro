data {
  int<lower=0> n;
  vector[n] y;
}

parameters {
  real mu1;
  real mu2;
  real<lower=0> sigma;
}

transformed parameters {
  real mu = mu1 + mu2 ;
}

model {
  y ~ normal(mu1 + mu2, sigma);
}
