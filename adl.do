set fredkey 98b5492394295fafcc14b5c1c5973e42
import fred GDPC1 GPDI, clear
gen yq = yq(year(daten), quarter(daten))
tsset yq
format yq %tq
gen real_gdp_growth = ln(GDPC1) - ln(L.GDPC1)
var real_gdp_growth GPDI, lags(1/2)
vargranger
gen pt_forecast = .
gen sf_forecast = .
tsappend, add(2)
foreach h of numlist 1/2 {
local l = `h'
local L = `h' + 2
reg real_gdp_growth L(`l'/`L').GPDI L(`l'/`L').real_gdp_growth
predict y`h'
predict sf`h', stdp
replace pt_forecast = y`h' if yq == yq(2024, 2) + `h'
replace sf_forecast = sf`h' if yq == yq(2024, 2) + `h'
}
gen L = pt_forecast + invnormal(0.025) * sf_forecast
gen U = pt_forecast + invnormal(0.975) * sf_forecast
tsline real_gdp_growth L U if yq > yq(2023,1), legend(order(1 "lower" 2 "upper")) lcolor(black black black) lpattern(solid dash dash)
graph save "Graph" "E:\1 UW Madison\Econ 460\Forecast Project\adl.gph"
graph export "E:\1 UW Madison\Econ 460\Forecast Project\adl.png", as(png) name("Graph")
tsline real_gdp_growth L U if yq>yq(2010,1), legend(label(1 "Real GDP Growth Rate") label(2 Point forecast) label(3 "95% Interval ") order(1 2 3)) lcolor(black blue red red) lpattern(solid dash dash_dot dash_dot )
tsline real_gdp_growth L U if yq>yq(2015,1), legend(label(1 "Real GDP Growth Rate") label(2 Point forecast) label(3 "95% Interval ") order(1 2 3)) lcolor(black blue red red) lpattern(solid dash dash_dot dash_dot )
tsline real_gdp_growth L U if yq>yq(2017,1), legend(label(1 "Real GDP Growth Rate") label(2 Point forecast) label(3 "95% Interval ") order(1 2 3)) lcolor(black blue red red) lpattern(solid dash dash_dot dash_dot )
tsline real_gdp_growth L U if yq>yq(2020,1), legend(label(1 "Real GDP Growth Rate") label(2 Point forecast) label(3 "95% Interval ") order(1 2 3)) lcolor(black blue red red) lpattern(solid dash dash_dot dash_dot )
graph export "E:\1 UW Madison\Econ 460\Forecast Project\adl.png", as(png) name("Graph") replace
tsline GPDI
graph export "E:\1 UW Madison\Econ 460\Forecast Project\gpdi.png", as(png) name("Graph")
tsline GDPC1
graph export "E:\1 UW Madison\Econ 460\Forecast Project\gdpc1.png", as(png) name("Graph")
