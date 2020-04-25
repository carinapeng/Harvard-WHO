library(EpiEstim)
library(ggplot2)
pais_incid<-read.csv(file="pais_timeseries.csv")

pais_incid$dates<-as.Date(pais_incid$dates, "%d/%m/%Y")

res_pais <-estimate_R(pais_incid, method = "parametric_si", config = make_config(list(mean_si = 4.8, std_si = 2.3)))
plot(res_pais)

pais_r<-data.frame(res_pais$R)
plot(pais_r)
