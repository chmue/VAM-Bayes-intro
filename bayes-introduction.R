# Very Applied Methods
# Introduction to Bayesian Statistics

# install.packages(c("MCMCpack", "coda", "rstan"))

library("MCMCpack")
library("rstan")
library("coda")


# Standard models with MCMCpack --------------------------------------





# Output checks and analysis with coda -------------------------------





# Bespoke models with stan -------------------------------------------

# Sampling is slow (and even slower with stan) so use as much computing
# power as you have available.
options(mc.cores = 8L)

