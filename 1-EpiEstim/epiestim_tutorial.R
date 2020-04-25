library(EpiEstim)
library(ggplot2)
library(incidence)
library(cluster.datasets)

# load data
data(Flu2009)

# explore data and write to file
head(Flu2009$incidence)
head(Flu2009$si_data)
write.csv(Flu2009, "Flu2009.csv")

## 1. serial interval (SI) distribution:
## interval-ceonsored serial interval data:
## each line represents a transmission event, 
## EL/ER show the lower/upper bound of the symptoms onset date in the infector
## SL/SR show the same for the secondary case
## type has entries 0 corresponding to doubly interval-censored data
## (see Reich et al. Statist. Med. 2009).

png("incidents.png")
plot(as.incidence(Flu2009$incidence$I, dates = Flu2009$incidence$dates))
dev.off()

res_parametric_si <- estimate_R(Flu2009$incidence, 
                                method="parametric_si",
                                config = make_config(list(
                                  mean_si = 2.6, 
                                  std_si = 1.5))
)

# Explore model
head(res_parametric_si)
head(res_parametric_si$R)

# Write the rate of transmission values
Rt <- data.frame(res_parametric_si$R)
write.csv(Rt, "Rt.csv")

mean(Flu2009$incidence$I)
sd(Flu2009$incidence$I)

# Plot
png("res_parametric_si.png")
plot(res_parametric_si, legend = FALSE)
dev.off()

# use `type = "R"`, `type = "incid"` or `type = "SI"` 
# to generate only one of the 3 plots

## 2. Non-parametric Method
## si_distr gives the probability mass function of the serial interval for 
## time intervals 0, 1, 2, etc.
res_non_parametric_si <- estimate_R(Flu2009$incidence, 
                                    method="non_parametric_si",
                                    config = make_config(list(
                                      si_distr = Flu2009$si_distr))
)
png("res_nonparametric_si.png")
plot(res_non_parametric_si, "R")
dev.off()

# full distribution of the serial interval using discr_si function (this is how Flu2009$si_distr was obtained, with additional rounding): 
discr_si(0:20, mu = 2.6, sigma = 1.5)

mean(Flu2009$incidence$I)
sd(Flu2009$incidence$I)
Flu2009$incidence

## 3. Sampled distributions for all non-parametric models
## we choose to draw:
## - the mean of the SI in a Normal(2.6, 1), truncated at 1 and 4.2
## - the sd of the SI in a Normal(1.5, 0.5), truncated at 0.5 and 2.5
config <- make_config(list(mean_si = 2.6, std_mean_si = 1,
                           min_mean_si = 1, max_mean_si = 4.2,
                           std_si = 1.5, std_std_si = 0.5,
                           min_std_si = 0.5, max_std_si = 2.5))
res_uncertain_si <- estimate_R(Flu2009$incidence,
                               method = "uncertain_si",
                               config = config)

## plot Model
## the third plot now shows all the SI distributions considered
png("res_nonparametric_si.png")
plot(res_uncertain_si, legend = FALSE) 
dev.off()

# More models
# See https://rdrr.io/cran/EpiEstim/f/vignettes/demo.Rmd
