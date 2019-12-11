# Very Applied Methods
# Introduction to Bayesian Statistics

# install.packages(c("MCMCpack", "rstan"))

library("MCMCpack")
library("coda")

# Bayesian regression with MCMCpack ----------------------------------

data("nlschools")

score_model <- MCMCregress(lang ~ IQ + GS + SES, data = nlschools, verbose = 1000)

summary(score_model)

# Compare against OLS estimates
summary(lm(lang ~ IQ + GS + SES, data = nlschools))


# Output checks and analysis with coda -------------------------------

# Visual

traceplot(score_model)

# Tests

geweke.diag(score_model)
heidel.diag(score_model)

# gelman.diag(score_model)


# Prior distributions ------------------------------------------------

summary <- function(x, ...) base::summary(x, quantiles = c(0.025, 0.975))

# Prior variance
summary(MCMCregress(lang ~ IQ + GS + SES, data = nlschools, b0 = 0, B0 = .5))
summary(MCMCregress(lang ~ IQ + GS + SES, data = nlschools, b0 = 0, B0 = 1))
summary(MCMCregress(lang ~ IQ + GS + SES, data = nlschools, b0 = 0, B0 = 10))

# Prior mean
summary(MCMCregress(lang ~ IQ + GS + SES, data = nlschools, b0 = 5, B0 = 1))
summary(MCMCregress(lang ~ IQ + GS + SES, data = nlschools, b0 = 10, B0 = 10))

# Prior mean and less data
summary(MCMCregress(lang ~ IQ + GS + SES, data = nlschools[sample.int(nrow(nlschools), 10), ], b0 = 5, B0 = 1))

rm(summary)

# Estimating fundamentally unidentified parameters with stan ---------

library("rstan")

stan_mean_uid <- stan(
  file = "mean_unidentified.stan",
  data = list(y = rnorm(10^4, 5.4, 2.1), n = 10^4),
  chains = 1L,
  control = list(max_treedepth = 12),
  verbose = FALSE
)

out


# Latent scaling of MPs (IRT) ----------------------------------------

vote_matrix <- readRDS("vote_matrix.rds")

# 1 chain
irt_scale <- MCMCirt1d(
  vote_matrix,
  theta.constraints = list("c1541527844" = "+", "c988615553" = "-"),
  mcmc = 1e4,
  verbose = 1e3
)

geweke.diag(irt_scale)
heidel.diag(irt_scale)


# 4 chains with overdispersed starting values
irt_4chain <- as.mcmc.list(
  replicate(
    n = 4,
    MCMCirt1d(
      vote_matrix,
      theta.constraints = list("c1541527844" = "+", "c988615553" = "-"),
      alpha.start = rnorm(ncol(vote_matrix), 0, 2),
      beta.start = rnorm(ncol(vote_matrix), 0, 2),
      # theta.start = rnorm(nrow(vote_matrix), 0, 2),
      mcmc = 1e4,
      verbose = 1e3
    ),
    simplify = FALSE
  )
)


# Convergence check
gelman.diag(irt_4chain)

traceplot(irt_4chain)

summary(irt_4chain)

