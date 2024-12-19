set fredkey 98b5492394295fafcc14b5c1c5973e42
import fred GDPC1, clear
gen yq = yq(year(daten), quarter(daten))
tsset yq
format yq %tq
gen real_gdp_growth = ln(GDPC1) - ln(L.GDPC1)
tsline real_gdp_growth
graph export "E:\1 UW Madison\Econ 460\Forecast Project\gdpgrowth.png", as(png) name("Graph")
dfuller real_gdp_growth
reg D.real_gdp_growth L.real_gdp_growth L(1/12).D.real_gdp_growth, r
test L.real_gdp_growth
reg real_gdp_growth L1.real_gdp_growth
estimates store AR1
reg real_gdp_growth L(1/2).real_gdp_growth
estimates store AR2
reg real_gdp_growth L(1/3).real_gdp_growth
estimates store AR3
reg real_gdp_growth L(1/4).real_gdp_growth
estimates store AR4
estimates stats AR1 AR2 AR3 AR4
reg real_gdp_growth L1.real_gdp_growth if _n > 5
estimates store AR1
reg real_gdp_growth L(1/2).real_gdp_growth if _n > 5
estimates store AR2
reg real_gdp_growth L(1/3).real_gdp_growth if _n > 5
estimates store AR3
reg real_gdp_growth L(1/4).real_gdp_growth if _n > 5
estimates store AR4
estimates stats AR1 AR2 AR3 AR4
ac real_gdp_growth
graph export "E:\1 UW Madison\Econ 460\Forecast Project\acf.png", as(png) name("Graph") replace
pac real_gdp_growth
graph export "E:\1 UW Madison\Econ 460\Forecast Project\pacf.png", as(png) name("Graph")
predict residuals if e(sample)
ac residuals
graph export "E:\1 UW Madison\Econ 460\Forecast Project\residuals.png", as(png) name("Graph")
arima real_gdp_growth, arima(2,0,0)
