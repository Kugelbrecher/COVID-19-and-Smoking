clear all
set more off
cd "/Users/nik/Desktop/data/clean data"

********************************
*** clean panel_version.dta ***
use panel_version.dta, clear
duplicates report uasid // panel already

sort uasid start_date
order uasid timing gender age cal_age statereside now_resid_state maritalstatus livewithpartner anyhhmember hhmembernumber live_nurse education high_educ hisplatino white black nativeamer asian pacific race working sick_leave unemp_layoff unemp_look retired laborstatus hourswork hhincome life_satisf take_risk health_young respiratory_young depress_young emotional_young health_now lung_disease respiratory_theropy emotional_now depress_now exercise  depress_last_week happy_last_week lonely_last_week sad_last_week parent_smoke smoke_young ever_smoked smoke_now number_cig number_pack number_cig_peak number_pack_peak c031_

drop cal_age now_resid_state high_educ respiratory_theropy

tab gender, m
tab age, m
tab statereside, m 
tab maritalstatus, m 
tab livewithpartner, m 
tab anyhhmember, m
tab hhmembernumber, m
tab live_nurse, m 
tab education, m 


tab hisplatino, m
tab white, m
tab black,m 
tab nativeamer, m
tab asian, m
tab pacific, m
tab race, m 


tab working, m
tab sick_leave, m
tab unemp_layoff, m
tab unemp_look, m
tab retired, m
tab laborstatus, m
tab hourswork, m
replace hourswork = . if hourswork == .e
tab hhincome, m


tab life_satisf, m
replace life_satisf = . if life_satisf == .e
tab take_risk, m
replace take_risk = . if take_risk == .e


tab health_young, m
preserve
keep if timing == 2
tab health_young, m
restore
bys uasid (timing): replace health_young = health_young[2] if health_young[3] == .a

tab respiratory_young, m
preserve
keep if timing == 2
tab respiratory_young, m
restore
bys uasid (timing): replace respiratory_young = respiratory_young[2] if respiratory_young[3] == .a

tab depress_young, m
bys uasid (timing): replace depress_young = depress_young[2] if depress_young[3] == .a

tab emotional_young, m
bys uasid (timing): replace emotional_young = emotional_young[2] if emotional_young[3] == .a

tab health_now, m
br if health_now == .e
replace health_now = . if health_now == .e

tab lung_disease, m
br if lung_disease == .e // 2 missing in timing == 1
br if uasid == "150301236" | uasid == "160300380"
bys uasid (timing): replace lung_disease = lung_disease[0] if lung_disease[2] == .e & lung_disease[1] == lung_disease[3] // why we need an extra condition (the last one)???

tab emotional_now, m
br if emotional_now == .e // 3 missing in timing == 1
br if uasid == "150301236" | uasid == "160300380" | uasid == "160501918"
bys uasid (timing): replace emotional_now = emotional_now[1] if emotional_now[2] == .e & emotional_now[1] == emotional_now[3]
replace emotional_now = . if emotional_now == .e

*** have not clean yet
tab depress_now, m
tab exercise, m
tab depress_last_week, m
tab happy_last_week, m
tab lonely_last_week, m
tab sad_last_week, m


tab parent_smoke timing, m
br if parent_smoke == .a
bysort uasid (timing): replace parent_smoke = parent_smoke[2] if parent_smoke[3] == .a

tab smoke_young, m
br if smoke_young == .a
bysort uasid (timing): replace smoke_young = smoke_young[2] if smoke_young[3] == .a

tab ever_smoked, m
br if ever_smoked == .a
br if ever_smoked == .e
br uasid timing ever_smoked if uasid == "160304802" | uasid == "160400447"
bys uasid (timing): replace ever_smoked = ever_smoked[2] if ever_smoked[3] == .a
replace ever_smoked = . if ever_smoked == .e


tab smoke_now, m
br if smoke_now == .
replace smoke_now = 5 if smoke_now == .
br if smoke_now == .e
br if uasid == "160300380"
replace smoke_now = 1 if smoke_now == .e // not correct
br if smoke_now == .a
replace smoke_now = 5 if ever_smoked == 5 & smoke_now == .a
br if smoke_now == .a
replace smoke_now = . if smoke_now == .a


tab number_cig, m
preserve
keep if number_cig == .
tab timing
restore
br if number_cig == .
replace number_cig = 0 if smoke_now == 5 & number_cig == .
br if number_cig == .a
preserve
keep if number_cig == .a 
tab smoke_now number_cig, m
restore
replace number_cig = 0 if smoke_now == 5 & number_cig == .a
replace number_cig = . if number_cig == .a | number_cig == .e

tab number_pack, m 
replace number_cig = 20 if number_cig == . & number_pack == 1
replace number_cig = 40 if number_cig == . & number_pack == 2
replace number_cig = 60 if number_cig == . & number_pack == 3
drop number_pack

*** have not clean yet:
tab number_cig_peak, m
tab number_pack_peak, m
tab c031_, m

save, replace


********************************************************
use panel_version.dta, clear

replace live_nurse = 0 if live_nurse == 5
replace respiratory_young = 0 if respiratory_young == 5
replace depress_young = 0 if depress_young == 5
replace emotional_young = 0 if emotional_young == 5
replace lung_disease = 0 if lung_disease == 5
replace emotional_now = 0 if emotional_now == 5
replace depress_now = 0 if depress_now == 5
replace depress_last_week = 0 if depress_last_week == 5
replace happy_last_week = 0 if happy_last_week == 5
replace lonely_last_week = 0 if lonely_last_week == 5
replace sad_last_week = 0 if sad_last_week == 5
replace smoke_young = 0 if smoke_young == 5
replace ever_smoked = 0 if ever_smoked == 5
replace smoke_now = 0 if smoke_now == 5
drop number_cig_peak number_pack_peak c031_

save, replace
