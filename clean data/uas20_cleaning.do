/*
uas20.dta is the Health and Retirement Study survey taken by respondents from 2015 to 2019.

Aim of code below: to select appropriate variables, clean data in uas20.dta.
*/

* data convention .e: seen but not answered *
* data convention .c: did not finish the survey, used in end_date *
* data convention .a: never seen *

clear all
set more off
cd "/Users/nik/Desktop/data/raw data"
use uas20.dta, clear


keep uasid start_date start_year start_month end_date end_year end_month gender age statereside maritalstatus livewithpartner education hisplatino white black nativeamer asian pacific race working sick_leave unemp_layoff unemp_look retired laborstatus hourswork hhincome anyhhmember hhmembernumber a167_a028 a169_a076tcurresst_a a014 b000_ b132 b014 b019 b104_ b107_ b116_ b118_ b122_ c001_ c030_ c034_ c065_ c271_ c223_ c116_ c117_ c118_ c119_ c123_ c124_ d110 d113 d114 d116


tab start_year, m // 2015-2019
tab end_year, m 
drop if end_year == .c // 84 respondents did not finish the survey
drop if end_year == 2020 // 1 respondent finished too late


replace gender = . if gender == .e // 4 missing
replace age = . if age == .e // 7 missing
replace statereside = . if statereside == .e // 10 missing， categorical
replace maritalstatus = . if maritalstatus == .e // 7 missing
replace livewithpartner = . if livewithpartner == .e // 8 missing
replace livewithpartner = 1 if livewithpartner == .a // 4435 as they are married
replace educ = . if educ == .e // 5 missing
replace race = . if race == .e // 43 missing
replace hisplatino = . if hisplatino == .e // 4 missing
replace white = . if white == .e // 44 missing
replace black = . if black == .e // 44 missing
replace nativeamer = . if nativeamer == .e // 44 missing
replace asian = . if asian == .e // 44 missing
replace pacific = . if pacific == .e // 44 missing
replace laborstatus = . if laborstatus == .e // 10 missing
replace working = . if working == .e // 10 missing
replace sick_leave = . if sick_leave == .e // 10 missing
replace unemp_layoff = . if unemp_layoff == .e // 10 missing
replace unemp_look = . if unemp_look == .e // 10 missing
replace retired = . if retired == .e // 10 missing
replace hourswork = 0 if hourswork == .a // 2995 changes
replace hhincome = . if hhincome == .e // 27 missing, categorical, not continuous
replace anyhhmember = . if anyhhmember == .e // 10 missing
replace hhmembernumber = . if hhmembernumber == .e  // 448 missing
// these variables might a good substitution for livewithpartner, as they show how many people reside in the same place with the potential smoker.



rename a167_a028 live_nurse
rename a169_a076tcurresst_a now_resid_state
rename a014 cal_age
rename b000_ life_satisf
rename b132 take_risk
rename b014 high_educ // highest level of education
rename b019 health_young
rename b104_ parent_smoke
rename b107_ respiratory_young
rename b116_ depress_young
rename b118_ emotional_young
rename b122_ smoke_young
rename c001_ health_now
rename c030_ lung_disease
rename c034_ respiratory_theropy
rename c065 emotional_now
rename c271_ depress_now
rename c223_ exercise
rename c116_ ever_smoked
rename c117_ smoke_now
rename c118_ number_cig
rename c119_ number_pack
rename c123_ number_cig_peak
rename c124_ number_pack_peak
rename d110 depress_last_week
rename d113 happy_last_week
rename d114 lonely_last_week
rename d116 sad_last_week


label variable live_nurse "living in a nursing home or care facility"
label var now_resid_state "current residence state" // vs. the variable statereside, there are a few differences.
label var cal_age "calculated age" // see what is the diff b/w cal_age and age 
label var take_risk "how much risk willing to take from 1-10"


replace live_nurse = . if live_nurse == .a | live_nurse == .e
replace now_resid_state = . if now_resid_state == .a | now_resid_state == .e // 12 .a missing 22 .e missing
replace cal_age = . if cal_age == .a | cal_age == .e
replace life_satisf = . if life_satisf == .a // 4 missing
replace take_risk = . if take_risk == .e | take_risk == .a // 64 missing
replace high_educ = . if high_educ == .a | high_educ == .e // 13 missing 
replace health_young = . if health_young == .a // 4 missing
replace parent_smoke = . if parent_smoke == .a | parent_smoke == .e // 5 missing
replace respiratory_young = . if respiratory_young == .a | respiratory_young == .e // 255 missing 
replace depress_young = . if depress_young == .a | depress_young == .e // 192 missing 
replace emotional_young = . if emotional_young == .a | emotional_young == .e // 195 missing 
replace smoke_young = . if smoke_young == .a | smoke_young == .e // 7 missing 
replace smoke_young = . if smoke_young == 58 // 1 error
replace health_now = . if health_now == .a | health_now == .e // 7 missing 
replace lung_disease = . if lung_disease == .a | lung_disease == .e // 10 missing
replace respiratory_theropy = . if respiratory_theropy == .a | respiratory_theropy == .e // 7359 missing
replace emotional_now = . if emotional_now == .a | emotional_now == .e // 10 missing 
replace depress_now = . if depress_now == .a | depress_now == .e // 8 missing 
replace exercise = . if exercise == .a // 6 missing 
replace ever_smoked = . if ever_smoked == .a | ever_smoked == .e
replace smoke_now = . if smoke_now == .a | smoke_now == .e
replace number_cig = . if number_cig == .a | number_cig == .e 
replace number_pack = . if number_pack == .a | number_pack == .e 
replace number_cig_peak = . if number_cig_peak == .a | number_cig_peak == .e 
replace number_pack_peak = . if number_pack_peak == .a | number_pack_peak == .e 
replace depress_last_week = . if depress_last_week == .a | depress_last_week == .e
replace happy_last_week = . if happy_last_week == .a | happy_last_week == .e
replace lonely_last_week = . if lonely_last_week == .a | lonely_last_week == .e
replace sad_last_week = . if sad_last_week == .a | sad_last_week == .e

gen timing = 0




save "/Users/nik/Desktop/data/clean data/uas20_clean", replace
