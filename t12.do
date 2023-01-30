clear all
set more off
cd "/Users/nik/Desktop/data"

log using sum, replace text name("process")

use panel_version.dta, clear



gen age_sq = age * age

drop if timing == 0
gen post = 0
replace post = 1 if timing == 2


gen flag = 0 
bys uasid: replace flag = 1 if smoke_now[0] == 0 | smoke_now[1] == 1
br uasid post smoke_now flag


******** covid analysis ******* 

reg smoke_now post



*** the strictness of lockdown policies ***
gen did_policy = post * policy

reg smoke_now post policy did_policy, cluster(statereside)
reg smoke_now age age_sq post policy did_policy, cluster(statereside)
reg smoke_now maritalstatus hhincome life_satisf post policy did_policy, cluster(statereside)

reg number_cig age age_sq post policy did_policy, cluster(statereside)
reg number_cig maritalstatus hhincome life_satisf post policy did_policy, cluster(statereside)

esttab using "reg_policy.rtf", replace title("policy") label nonumbers  drop( _cons) b(%9.3f) se(%9.3f)  starlevels(* 0.1 ** 0.05 *** 0.01) 


*** case rate ***
gen did_case = post * case_rate_high
reg smoke_now post case_rate_high did_case, cluster(statereside)
reg smoke_now post age age_sq case_rate_high did_case, cluster(statereside)
reg smoke_now maritalstatus hhincome life_satisf post case_rate_high did_case, cluster(statereside)

reg number_cig post age age_sq case_rate_high did_case, cluster(statereside)


*** death rate ***
gen did_death = post * death_rate_high
reg smoke_now post death_rate_high did_death, cluster(statereside)
reg smoke_now age age_sq post death_rate_high did_death, cluster(statereside)
reg smoke_now maritalstatus hhincome life_satisf post death_rate_high did_death, cluster(statereside)

reg number_cig age age_sq post death_rate_high did_death, cluster(statereside)


*** case death rate combined ***
gen did_both = post * death_rate_high
reg smoke_now post death_rate_high did_both, cluster(statereside)
reg smoke_now age age_sq post death_rate_high did_both, cluster(statereside)
reg smoke_now maritalstatus hhincome life_satisf post death_rate_high did_both, cluster(statereside)




*************** emotion variables ***************
*** depress_last_week ***
sort uasid timing
gen depress_last_week_stable = depress_last_week
replace depress_last_week_stable = depress_last_week_stable[_n-1] if uasid == uasid[_n-1]

gen did = post * depress_last_week_stable

reg smoke_now post age age_sq depress_last_week_stable did, cluster(uasid)
reg number_cig post age age_sq depress_last_week_stable did, cluster(uasid)

*** depress now ********
gen depress_now_stable = depress_now
replace depress_now_stable = depress_now_stable[_n-1] if uasid == uasid[_n-1]
gen did_depress_now = post * depress_now_stable

reg smoke_now post age age_sq depress_now_stable did_depress_now, cluster(uasid)
reg smoke_now maritalstatus hhincome life_satisf post depress_now_stable did_depress_now, cluster(statereside)


reg number_cig post age age_sq depress_now_stable did_depress_now, cluster(uasid)

reg smoke_now post working age age_sq maritalstatus depress_now_stable did_depress_now, cluster(uasid)

reg smoke_now post working depress_now_stable did_depress_now, cluster(uasid)

reg smoke_now post unemp_layoff depress_now_stable did_depress_now, cluster(uasid)

reg smoke_now post unemp_look depress_now_stable did_depress_now, cluster(uasid)





*** emotional now *** 
gen emotional_now_stable = emotional_now
replace emotional_now_stable = emotional_now_stable[_n-1] if uasid == uasid[_n-1]
gen did_emotional_now = post * emotional_now_stable

reg smoke_now post age age_sq emotional_now_stable did_emotional_now, cluster(uasid)
reg smoke_now hhincome life_satisf post emotional_now_stable did_emotional_now, cluster(statereside)


reg number_cig post age age_sq emotional_now_stable did_emotional_now, cluster(uasid)

reg number_cig post maritalstatus emotional_now_stable did_emotional_now, cluster(uasid)


*** happy last week ***
gen happy_last_week_stable = happy_last_week
replace happy_last_week_stable = happy_last_week_stable[_n-1] if uasid == uasid[_n-1]
gen did_happy_last_week = post * happy_last_week_stable

reg smoke_now post age age_sq happy_last_week_stable did_happy_last_week, cluster(uasid)
reg smoke_now maritalstatus hhincome life_satisf post happy_last_week_stable did_happy_last_week, cluster(statereside)


reg number_cig post age age_sq happy_last_week_stable did_happy_last_week, cluster(uasid)


*** lonely last week ***
gen lonely_last_week_stable = lonely_last_week
replace lonely_last_week_stable = lonely_last_week_stable[_n-1] if uasid == uasid[_n-1]
gen did_lonely_last_week = post * lonely_last_week_stable

reg smoke_now post age age_sq lonely_last_week_stable did_lonely_last_week, cluster(uasid)
reg smoke_now maritalstatus hhincome life_satisf post lonely_last_week_stable did_lonely_last_week, cluster(statereside)


reg number_cig post age age_sq lonely_last_week_stable did_lonely_last_week, cluster(uasid)

*** sad last week ***
gen sad_last_week_stable = sad_last_week
replace sad_last_week_stable = sad_last_week_stable[_n-1] if uasid == uasid[_n-1]
gen did_sad_last_week = post * sad_last_week_stable

reg smoke_now post age age_sq sad_last_week_stable did_sad_last_week, cluster(uasid)
reg smoke_now maritalstatus hhincome life_satisf post sad_last_week_stable did_sad_last_week, cluster(statereside)

reg number_cig post age age_sq sad_last_week_stable did_sad_last_week, cluster(uasid)




*** live with partner ***
gen livewithpartner_stable = livewithpartner
replace livewithpartner_stable = livewithpartner_stable[_n-1] if uasid == uasid[_n-1]
gen did_livewithpartner = post * livewithpartner_stable

reg smoke_now post livewithpartner_stable did_livewithpartner, cluster(uasid)
reg smoke_now post age age_sq livewithpartner_stable did_livewithpartner, cluster(uasid)
reg smoke_now post working livewithpartner_stable did_livewithpartner, cluster(uasid)




reg smoke_now maritalstatus hhincome life_satisf post livewithpartner_stable did_livewithpartner, cluster(statereside)

reg number_cig post age age_sq livewithpartner_stable did_livewithpartner, cluster(uasid)



log close process
