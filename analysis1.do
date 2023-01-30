clear all
set more off
cd "/Users/nik/Desktop/Econ196A/data/clean data"

use panel_version.dta, clear

preserve
keep if timing == 0
tab age smoke_now if age >= 70
sum age smoke_now if age >= 70
sum age smoke_now if  age >= 60 & age < 70
sum age smoke_now if age >= 50 & age < 60
sum age smoke_now if age >= 40 & age < 50
sum age smoke_now if age >= 30 & age < 40
sum age smoke_now if age >= 18 & age < 30
tab smoke_now
restore

reg smoke_now timing
test timing
// rvfplot
reg smoke_now timing, robust // no difference in standard error


reg smoke_now timing, cluster(uasid)
// try to figure out the reduction in smoke comes from covid or something else
reg smoke_now age timing, cluster(uasid)
gen age_sq = age * age
reg smoke_now age age_sq timing, cluster(uasid)
test age age_sq timing
// rvfplot

areg smoke_now timing, absorb(uasid) cluster(uasid)
areg smoke_now age age_sq timing, absorb(uasid) cluster(uasid)

gen did = timing * policy
reg smoke_now timing policy did
reg smoke_now timing policy did, cluster(uasid)

reg number_cig timing policy did
reg number_cig timing policy did, cluster(uasid)
