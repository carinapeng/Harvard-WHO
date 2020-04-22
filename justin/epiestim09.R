library(EpiEstim)
library(ggplot2)
library(cluster.datasets)
data(Flu2009)
## load data
data(Flu2009)
## incidence:
head(Flu2009$incidence)
write.csv(Flu2009, "Flu2009.csv")
## serial interval (SI) distribution:
Flu2009$si_distr
## interval-ceonsored serial interval data:
## each line represents a transmission event, 
## EL/ER show the lower/upper bound of the symptoms onset date in the infector
## SL/SR show the same for the secondary case
## type has entries 0 corresponding to doubly interval-censored data
## (see Reich et al. Statist. Med. 2009).
head(Flu2009$si_data)
library(incidence)
png("incidents.png")
plot(as.incidence(Flu2009$incidence$I, dates = Flu2009$incidence$dates))
dev.off()
res_parametric_si <- estimate_R(Flu2009$incidence, 
                                method="parametric_si",
                                config = make_config(list(
                                  mean_si = 2.6, 
                                  std_si = 1.5))
)

head(res_parametric_si$R)
png("res_parametric_si.png")
plot(res_parametric_si, legend = FALSE)
dev.off()

# use `type = "R"`, `type = "incid"` or `type = "SI"` 
# to generate only one of the 3 plots

# Non-parametric
res_non_parametric_si <- estimate_R(Flu2009$incidence, 
                                    method="non_parametric_si",
                                    config = make_config(list(
                                      si_distr = Flu2009$si_distr))
)
# si_distr gives the probability mass function of the serial interval for 
# time intervals 0, 1, 2, etc.
png("res_nonparametric_si.png")
plot(res_non_parametric_si, "R")
dev.off()
