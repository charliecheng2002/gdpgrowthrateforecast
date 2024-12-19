set fredkey 98b5492394295fafcc14b5c1c5973e42
import fred GDPC1 GPDI, clear
gen yq = yq(year(daten), quarter(daten))
tsset yq
format yq %tq
gen real_gdp_growth = ln(GDPC1) - ln(L.GDPC1)
var real_gdp_growth GPDI, lags(1/2)
vargranger
