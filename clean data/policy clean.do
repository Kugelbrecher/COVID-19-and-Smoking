clear all
set more off
cd "/Users/nik/Desktop/data/raw data"


import delimited policy_track.csv, delimiters(",") clear varnames(1)

tab regionname // 52 states, each with 344 days

drop e* h* m*
drop confirmedcases confirmeddeaths stringencyindex stringencyind~y stringencyleg~x stringencyleg~y containmenthe~x containmenthe~y
drop if regionname == "" // 344 deleted
drop c1_flag c1_notes c2_flag c2_notes c3_flag c3_notes c4_flag c4_notes c5_flag c5_notes c6_flag c6_notes c7_flag c7_notes c8_notes

sort regionname date

gen daily_sum = c1_schoolclosing + c2_workplaceclosing + c3_cancelpublicevents + c4_restrictionsongatherings + c5_closepublictransport + c6_stayathomerequirements + c7_restrictionsoninternalmovemen + c8_internationaltravelcontrols

bys regionname (date): egen total_policy = sum(daily_sum)
bys regionname (date): egen median_poicy = median(daily_sum)
bys regionname (date): egen mean_poicy = mean(daily_sum)

egen total_median = median(median_poicy)
egen total_mean = mean(mean_poicy)

gen flag_mean = 0
replace flag_mean = 1 if total_mean < mean_poicy // 27 strict

gen flag_median = 0
replace flag_median = 1 if total_median < median_poicy // 17 strict

save "/Users/nik/Desktop/data/clean data/policy_strict.csv"

************************************************************************
cd "/Users/nik/Desktop/data/clean data"
use panel_version.dta, clear
gen policy = 0
replace policy = 1 if statereside == 2 | statereside == 6 | statereside == 8 | statereside == 9 | statereside == 10 | statereside == 12 | statereside == 15 | statereside == 23 | statereside == 24 | statereside == 25 | statereside == 27 | statereside == 35 | statereside == 36 | statereside == 39 | statereside == 48 | statereside == 53
save panel_version.dta, replace
