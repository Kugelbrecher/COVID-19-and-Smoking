/*
uas95.dta is the Health and Retirement Study survey taken by respondents from 2017 to 2019.

Aim of code below: to select appropriate variables, clean data in uas185.dta.
*/

* data convention .e: seen but not answered *
* data convention .c: did not finish the survey, used in end_date *
* data convention .a: never seen *

clear all
set more off
cd "/Users/nik/Desktop/data/raw data"
use uas95.dta, clear

tab end_year, m
drop if end_year == .c

keep uasid start_date start_year start_month end_date end_year end_month gender age statereside maritalstatus livewithpartner education hisplatino white black nativeamer asian pacific race working sick_leave unemp_layoff unemp_look retired laborstatus hourswork hhincome anyhhmember hhmembernumber a167_a028 a169_a076tcurresst_a a014 b000_ b132 c001_ c030_ c031_ c034_ c065_ c271_ c223_ z205 c117_ c118_ c119_ c123_ c124_ d110 d113 d114 d116

// missing variables: b014 b019 b104_ b107_ b116_ b118_ b122_
// missing c116_, instead: z205

rename a167_a028 live_nurse
rename a169_a076tcurresst_a now_resid_state
rename a014 cal_age
rename b000_ life_satisf
rename b132 take_risk
rename c001_ health_now
rename c030_ lung_disease
rename c034_ respiratory_theropy
rename c065 emotional_now
rename c271_ depress_now
rename c223_ exercise
rename z205 ever_smoked
rename c117_ smoke_now
rename c118_ number_cig
rename c119_ number_pack
rename c123_ number_cig_peak
rename c124_ number_pack_peak
rename d110 depress_last_week
rename d113 happy_last_week
rename d114 lonely_last_week
rename d116 sad_last_week


replace age = . if age == .e 
replace statereside = . if statereside == .e 
replace maritalstatus = . if maritalstatus == .e 
replace livewithpartner = . if livewithpartner == .e 
replace livewithpartner = 1 if livewithpartner == .a 
replace educ = . if educ == .e
replace race = . if race == .e 
replace hisplatino = . if hisplatino == .e 
replace white = . if white == .e 
replace black = . if black == .e 
replace nativeamer = . if nativeamer == .e 
replace asian = . if asian == .e 
replace pacific = . if pacific == .e 
replace laborstatus = . if laborstatus == .e 
replace working = . if working == .e 
replace sick_leave = . if sick_leave == .e 
replace unemp_layoff = . if unemp_layoff == .e 
replace unemp_look = . if unemp_look == .e 
replace retired = . if retired == .e 
replace hourswork = 0 if hourswork == .a 
replace hhincome = . if hhincome == .e
replace anyhhmember = . if anyhhmember == .e 
replace hhmembernumber = . if hhmembernumber == .e 

gen timing = 1

save "/Users/nik/Desktop/data/clean data/uas95_clean", replace



