# COVID-19 Estimator

This is an interface that helps countries estimate the rate of transmission of COVID-19 given data containing the number of incidents reported on specific dates.

This interface dynamically produces the following results:

1.  Epidemic curves (number of incidents) as a function of time $t$
2.  Estimated $R$ (Rate of transmission) as a function of time $t$ with 95% confidence intervals. This is calculated using sliding weekly windows, with a parametric serial interval based on a mean of $\mu_{si} = 4.8$ and standard deviation $\sigma_{si} = 2.3$

The results are available for all countries to facilitate the monitoring of transmission rates and assessment of quarantine policies concerning the COVID-19 epidemic.

### Getting Started

To begin, simply click `Browse...` and upload a CSV file (comma-seperated values) in the sidebar panel on the left. 

Note that the CSV must contain dates in the first column and number of incidents in the second column. Note that dates must be written in the order of `Day/Month/Year`. A sample CSV in a correct format can been downloaded below.