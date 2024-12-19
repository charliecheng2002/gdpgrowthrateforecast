set fredkey 98b5492394295fafcc14b5c1c5973e42
import fred GDPC1, clear
gen yq = yq(year(daten), quarter(daten))
tsset yq
format yq %tq
gen real_gdp_growth = ln(GDPC1) - ln(L.GDPC1)
arima real_gdp_growth, arima(2,0,0)
reg real_gdp_growth L(1/2).real_gdp_growth
estimates store ar2
tsappend, add(2)
forecast create iterforecast, replace
forecast estimates ar2
forecast solve, simulate(errors betas, statistic(stddev, prefix(sd_)) reps(1000))
gen L_it = f_real_gdp_growth + invnormal(0.05)*sd_real_gdp_growth
gen U_it = f_real_gdp_growth + invnormal(0.95)*sd_real_gdp_growth
tsline f_real_gdp_growth real_gdp_growth L_it U_it if yq >= yq(2021,2), legend(label(1 "Forecast") label(2 "Actual") label(3 "90% Interval") order(1 2 3)) ytitle("Real GDP Growth Rate") xtitle("Time") title("Forecast") lcolor(black black red red) lpattern(dash solid dash dash)
graph export "E:\1 UW Madison\Econ 460\Forecast Project\arima200.png", as(png) name("Graph")
gen point = .
gen sf = .
browse
browse
forval k = 1/2 {
loc low = `k'
loc high = 3+`k'
reg real_gdp_growth L(`low'/`high').real_gdp_growth if yq < tq(2024,3) + `k'
predict y`k'
predict sf`k', stdf
replace point = y`k' if yq == tq(2024,2) + `k'
replace sf = sf`k' if yq == tq(2024,2) + `k'
}
gen L_dir = point + invnorm(0.05) * sf
gen U_dir = point + invnorm(0.95) * sf
tsline real_gdp_growth point L_dir U_dir if yq >= yq(2021,2), legend(label(1 "Actual") label(2 "Forecast") label(3 "90% Interval") order(1 2 3)) ytitle("Real GDP Growth") xtitle("Time") lcolor(black black red red) lpattern(solid dash dash dash)
graph save "Graph" "E:\1 UW Madison\Econ 460\Forecast Project\arima200_2025q1.gph"
graph export "E:\1 UW Madison\Econ 460\Forecast Project\arima200_2025q1.pdf", as(pdf) name("Graph")
