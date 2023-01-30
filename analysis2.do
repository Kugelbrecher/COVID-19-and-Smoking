clear all
set more off
cd "/Users/nik/Desktop/data"


*** parallel assumption ***
use panel_version.dta, clear
collapse (mean) number_cig, by(timing policy)
reshape wide number_cig, i(timing) j(policy)
twoway connect number_cig* timing, sort

use panel_version.dta, clear
collapse (mean) number_cig, by(timing case_death_rate_high)
reshape wide number_cig, i(timing) j(case_death_rate_high)
twoway connect number_cig* timing, sort

use panel_version.dta, clear
gen emotional_now_stable = emotional_now
replace emotional_now_stable = emotional_now_stable[_n-1] if uasid == uasid[_n-1]
drop if emotional_now_stable == .
collapse (mean) number_cig, by(timing emotional_now_stable)
reshape wide number_cig, i(timing) j(emotional_now_stable)
twoway connect number_cig* timing, sort

use panel_version.dta, clear
gen depress_now_stable = depress_now
replace depress_now_stable = depress_now_stable[_n-1] if uasid == uasid[_n-1]
drop if depress_now_stable == .
collapse (mean) number_cig, by(timing depress_now_stable)
reshape wide number_cig, i(timing) j(depress_now_stable)
twoway connect number_cig* timing, sort



*** sum table A ***
use panel_version.dta, clear
keep if timing == 0
estpost tabstat smoke_now, by(gender) statistics(mean sd count) columns(statistics)

bys race gender: sum smoke_now

use panel_version.dta, clear
collapse number_cig, by(race gender)

*** putdocx ***
*** putexcel ***

use panel_version.dta, clear
keep if timing == 1


reg number_cig i.hisplatino if policy == 0
reg, coefl
lincom _b[1.hisplatino] + _b[_cons]
reg number_cig i.hisplatino if policy == 1
reg, coefl
lincom _b[1.hisplatino] + _b[_cons]


reg number_cig i.white if policy == 0
reg, coefl
lincom _b[1.white] + _b[_cons]
reg number_cig i.white if policy == 1
reg, coefl
lincom _b[1.white] + _b[_cons]

							  nativeamer
reg number_cig i.black if policy == 0
reg, coefl
lincom _b[1.black] + _b[_cons]
reg number_cig i.black if policy == 1
reg, coefl
lincom _b[1.black] + _b[_cons]

reg number_cig i.nativeamer if policy == 0
reg, coefl
lincom _b[1.nativeamer] + _b[_cons]
reg number_cig i.nativeamer if policy == 1
reg, coefl
lincom _b[1.nativeamer] + _b[_cons]

reg number_cig i.asian if policy == 0
reg, coefl
lincom _b[1.asian] + _b[_cons]
reg number_cig i.asian if policy == 1
reg, coefl
lincom _b[1.asian] + _b[_cons]


reg number_cig i.pacific if policy == 0
reg, coefl
lincom _b[1.pacific] + _b[_cons]
reg number_cig i.pacific if policy == 1
reg, coefl
lincom _b[1.pacific] + _b[_cons]



*** summary of post by race ***
use panel_version.dta, clear
keep if timing == 2

estpost tabstat gender age maritalstatus education working sick_leave unemp_layoff unemp_look retired hourswork hhincome, by(race) statistics(mean sd count) columns(statistics)

esttab using character.rtf, replace cells("mean(fmt(%9.3f)) sd(fmt(%9.3f)) count(fmt(%9.0f))") noobs nonumbers title("Statistics by Smoking behavior") label

use panel_version.dta, clear
keep if timing == 2
keep if working == 1 | unemp_look == 1
estpost tabstat gender age education hourswork hhincome, by(race) statistics(mean sd count) columns(statistics)

esttab using character2.rtf, replace cells("mean(fmt(%9.3f)) sd(fmt(%9.3f)) count(fmt(%9.0f))") noobs nonumbers title("Statistics by Smoking behavior") label


*** smoker vs nonsmoker ***
use panel_version.dta, clear
gen college = 0
replace college = 1 if education >= 11
keep if timing == 2
estpost tabstat gender age college working unemp_layoff unemp_look, by(smoke_now) statistics(mean) columns(statistics)
esttab using vs2.rtf, replace cells("mean(fmt(%9.3f))") noobs nonumbers title("Statistics by Smoking behavior") label

use panel_version.dta, clear
gen college = 0
replace college = 1 if education >= 11
keep if timing == 1
estpost tabstat gender age college working unemp_layoff unemp_look, by(smoke_now) statistics(mean) columns(statistics)
esttab using vs1.rtf, replace cells("mean(fmt(%9.3f))") noobs nonumbers title("Statistics by Smoking behavior") label


use panel_version.dta, clear
gen college = 0
replace college = 1 if education >= 11
keep if timing == 0
estpost tabstat gender age college working unemp_layoff unemp_look, by(smoke_now) statistics(mean) columns(statistics)
esttab using vs0.rtf, replace cells("mean(fmt(%9.3f))") noobs nonumbers title("Statistics by Smoking behavior") label


*** policy by race ***
use panel_version.dta, clear
keep if timing == 2
keep if smoke_now == 1
estpost tabstat number_cig, by(race) statistics(mean sd count) columns(statistics)
esttab using po2.rtf, replace cells("mean(fmt(%9.3f)) sd(fmt(%9.3f)) count(fmt(%9.0f))") noobs nonumbers title("Statistics by Smoking behavior") label

use panel_version.dta, clear
keep if timing == 1
estpost tabstat number_cig, by(race) statistics(mean sd) columns(statistics)
esttab using po1.rtf, replace cells("mean(fmt(%9.3f))") noobs nonumbers title("Statistics by Smoking behavior") label


use panel_version.dta, clear
keep if timing == 0
estpost tabstat number_cig, by(race) statistics(mean sd) columns(statistics)
esttab using po0.rtf, replace cells("mean(fmt(%9.3f))") noobs nonumbers title("Statistics by Smoking behavior") label

*** tab regressions ***
use panel_version.dta, clear
gen age_sq = age * age
drop if timing == 0
gen post = 0
replace post = 1 if timing == 2

gen did_policy = post * policy
reg smoke_now age age_sq post policy did_policy, cluster(statereside)
esttab using "1.rtf", replace title("policy") label nonumbers  drop( _cons) b(%9.3f) se(%9.3f)  starlevels(* 0.1 ** 0.05 *** 0.01) 
reg number_cig age age_sq post policy did_policy, cluster(statereside)
esttab using "2.rtf", replace title("policy") label nonumbers  drop( _cons) b(%9.3f) se(%9.3f)  starlevels(* 0.1 ** 0.05 *** 0.01) 

gen did_case = post * case_rate_high
reg smoke_now age age_sq post case_rate_high did_case, cluster(statereside)
esttab using "3.rtf", replace title("policy") label nonumbers  drop( _cons) b(%9.3f) se(%9.3f)  starlevels(* 0.1 ** 0.05 *** 0.01)
gen did_death = post * death_rate_high
reg smoke_now age age_sq post death_rate_high did_death, cluster(statereside)
esttab using "4.rtf", replace title("policy") label nonumbers  drop( _cons) b(%9.3f) se(%9.3f)  starlevels(* 0.1 ** 0.05 *** 0.01)


replace depress_now = 1 if depress_now == 3 | depress_now == 4 | depress_now == 6
gen depress_now_stable = depress_now
replace depress_now_stable = depress_now_stable[_n-1] if uasid == uasid[_n-1]
gen did_depress_now = post * depress_now_stable
reg smoke_now post age age_sq depress_now_stable did_depress_now, cluster(uasid)
esttab using "5.rtf", replace title("policy") label nonumbers  drop( _cons) b(%9.3f) se(%9.3f)  starlevels(* 0.1 ** 0.05 *** 0.01)
reg number_cig post age age_sq depress_now_stable did_depress_now, cluster(uasid)
esttab using "7.rtf", replace title("policy") label nonumbers  drop( _cons) b(%9.3f) se(%9.3f)  starlevels(* 0.1 ** 0.05 *** 0.01)

replace emotional_now = 1 if emotional_now == 4 | emotional_now == 6
gen emotional_now_stable = emotional_now
replace emotional_now_stable = emotional_now_stable[_n-1] if uasid == uasid[_n-1]
gen did_emotional_now = post * emotional_now_stable
reg smoke_now age age_sq post emotional_now_stable did_emotional_now, cluster(uasid)
esttab using "6.rtf", replace title("policy") label nonumbers  drop( _cons) b(%9.3f) se(%9.3f)  starlevels(* 0.1 ** 0.05 *** 0.01)
reg number_cig age age_sq post emotional_now_stable did_emotional_now, cluster(uasid)
esttab using "8.rtf", replace title("policy") label nonumbers  drop( _cons) b(%9.3f) se(%9.3f)  starlevels(* 0.1 ** 0.05 *** 0.01)


*** t0***
use panel_version.dta, clear
gen age_sq = age * age
drop if timing == 2
gen post = 0
replace post = 1 if timing == 1

gen did_policy = post * policy
reg smoke_now age age_sq post policy did_policy, cluster(statereside)
esttab using "1.1.rtf", replace title("policy") label nonumbers  drop( _cons) b(%9.3f) se(%9.3f)  starlevels(* 0.1 ** 0.05 *** 0.01) 
reg number_cig age age_sq post policy did_policy, cluster(statereside)
esttab using "2.2.rtf", replace title("policy") label nonumbers  drop( _cons) b(%9.3f) se(%9.3f)  starlevels(* 0.1 ** 0.05 *** 0.01) 

gen did_case = post * case_rate_high
reg smoke_now age age_sq post case_rate_high did_case, cluster(statereside)
esttab using "3.3.rtf", replace title("policy") label nonumbers  drop( _cons) b(%9.3f) se(%9.3f)  starlevels(* 0.1 ** 0.05 *** 0.01)
gen did_death = post * death_rate_high
reg smoke_now age age_sq post death_rate_high did_death, cluster(statereside)
esttab using "4.4.rtf", replace title("policy") label nonumbers  drop( _cons) b(%9.3f) se(%9.3f)  starlevels(* 0.1 ** 0.05 *** 0.01)


replace depress_now = 1 if depress_now == 3 | depress_now == 4 | depress_now == 6
gen depress_now_stable = depress_now
replace depress_now_stable = depress_now_stable[_n-1] if uasid == uasid[_n-1]
gen did_depress_now = post * depress_now_stable
reg smoke_now age age_sq post depress_now_stable did_depress_now, cluster(uasid)
esttab using "5.5.rtf", replace title("policy") label nonumbers  drop( _cons) b(%9.3f) se(%9.3f)  starlevels(* 0.1 ** 0.05 *** 0.01)
reg number_cig age age_sq post depress_now_stable did_depress_now, cluster(uasid)
esttab using "7.7.rtf", replace title("policy") label nonumbers  drop( _cons) b(%9.3f) se(%9.3f)  starlevels(* 0.1 ** 0.05 *** 0.01)

replace emotional_now = 1 if emotional_now == 4 | emotional_now == 6
gen emotional_now_stable = emotional_now
replace emotional_now_stable = emotional_now_stable[_n-1] if uasid == uasid[_n-1]
gen did_emotional_now = post * emotional_now_stable
reg smoke_now age age_sq post emotional_now_stable did_emotional_now, cluster(uasid)
esttab using "6.6.rtf", replace title("policy") label nonumbers  drop( _cons) b(%9.3f) se(%9.3f)  starlevels(* 0.1 ** 0.05 *** 0.01)
reg number_cig age age_sq post emotional_now_stable did_emotional_now, cluster(uasid)
esttab using "8.8.rtf", replace title("policy") label nonumbers  drop( _cons) b(%9.3f) se(%9.3f)  starlevels(* 0.1 ** 0.05 *** 0.01)
