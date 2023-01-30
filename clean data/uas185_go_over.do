/*
uas185.dta is the Health and Retirement Study survey taken by respondents since 2019.

Aim of code below: to select appropriate variables, clean data in uas185.dta.
*/

* data convention .e: seen but not answered *
* data convention .c: did not finish the survey, used in end_date *
* data convention .a: never seen *

clear all
set more off
cd "/Users/nik/Desktop/data/raw data"
use uas185.dta, clear
br
keep if start_year == 2020 & start_month >= 3 // 3349 deleted



********************************************
*** Background and Demographic Variables ***
des uasid // individual identifier
isid uasid // uasid is a primary key

drop uashhid
des survhhid
count if survhhid == ".n" // 2455
drop survhhid 
drop uasmembers
drop sampletype
drop batch
drop primary_respondent
drop hardware
drop language

tab start_year, m // 0 missing, of course
tab end_year, m // 33 missing, did not finish the survey
drop if end_year == .c
drop start_day 
drop start_hour
drop start_min
drop start_sec
drop end_day
drop end_hour
drop end_min
drop end_sec

tab gender, m // no missing

tab age, m
replace age = . if age == .e // 3 missing

drop dateofbirth_year
drop agerange
drop citizenus
drop bornus
drop stateborn
drop countryborn countryborn_other
drop immigrant_status

tab statereside, m
replace statereside = . if statereside == .e // 1 missing， categorical
tab maritalstatus, m
replace maritalstatus = . if maritalstatus == .e // 2 missing
tab livewithpartner, m
replace livewithpartner = . if livewithpartner == .e // 3 missing
replace livewithpartner = 0 if livewithpartner == .a // convert to binary
tab educ, m
replace educ = . if educ == .e // 2 missing

tab race, m // a collection of following bianry races
replace race = . if race == .e // 28 missing
tab hisplatino, m
replace hisplatino = . if hisplatino == .e // 1 missing
drop hisplatino_group
tab white, m
replace white = . if white == .e // 28 missing
tab black, m
replace black = . if black == .e // 28 missing
tab nativeamer, m
replace nativeamer = . if nativeamer == .e // 28 missing
tab asian, m
replace asian = . if asian == .e // 28 missing
tab pacific, m
replace pacific = . if pacific == .e // 28 missing

tab laborstatus, m //a collection of following working status
replace laborstatus = . if laborstatus == .e // 2 missing
des working // currently working for pay
tab working, m
replace working = . if working == .e // 2 missing
tab sick_leave, m
replace sick_leave = . if sick_leave == .e // 2 missing
tab unemp_layoff, m
replace unemp_layoff = . if unemp_layoff == .e // 2 missing
tab unemp_look, m
replace unemp_look = . if unemp_look == .e // 2 missing
replace retired = . if retired == .e // 2 missing
tab lf_other, m
replace lf_other = . if lf_other == .e // 2 missing
drop disabled lf_other

tab employmenttype, m
drop employmenttype
tab workfullpart, m
drop workfullpart
tab hourswork, m
replace hourswork = 0 if hourswork == .a // 1494 changes

tab hhincome, m
replace hhincome = . if hhincome == .e // 11 missing, categorical, not continuous
tab anyhhmember, m
replace anyhhmember = . if anyhhmember == .e // 2 missing
tab hhmembernumber, m
replace hhmembernumber = . if hhmembernumber == .e  // 129 missing
// these variables might a good substitution for livewithpartner, as they show how many people reside in the same place with the potential smoker.
drop hhmemberage_* // the age of 1st to 11th member in that household
drop hhmembergen_* // the gender of 1st to 11th member in that household
drop hhmemberin_* // indicate whether this person currently in that household
drop hhmemberrel_* // relationship b/w this person with respondent 
drop hhmemberuasid_*

drop lastmyhh_date
drop x024



*****************
*** Section A ***
tab a167_a028, m
replace a167_a028 = . if a167_a028 == .e
rename a167_a028 live_nurse
label variable live_nurse "living in a nursing home or care facility"

tab a169_a076tcurresst_a, m //current residence state
replace a169_a076tcurresst_a = . if a169_a076tcurresst_a == .e // 5 .e missing
// replace .a with previous survey info
rename a169_a076tcurresst_a now_resid_state
label var now_resid_state "current residence state"

tab a014, m
replace a014 = . if a014 == .e // 2 missing
rename a014 cal_age
label var cal_age "calculated age" // see what is the diff b/w cal_age and age 



*****************
*** Section B ***
tab b000_, m 
replace b000_ = . if b000_ == .e // 1 missing
rename b000_ life_satisf

tab b132, m
replace b132 = . if b132 == .e // 5 missing
rename b132 take_risk
label var take_risk "how much risk willing to take from 1-10"

tab b014, m
replace b014 = . if b014 == .e // 4 .e missing 
// deal with .a
rename b014 educ // highest level of education

tab b019, m
replace b019 = . if b019 == .e // 1 missing
// deal with .a
rename b019 health_young

* smoke related *
tab b104_, m 
replace b104_ = . if b104_ == .e // 2 missing
// deal with .a
rename b104_ parent_smoke

tab b107_, m
replace b107_ = . if b107_ == .e // 1 missing 
// deal with .a
rename b107_ respiratory_young
replace respiratory_young = 0 if respiratory_young == 5

tab b116_, m
replace b116_ = . if b116_ == .e // 1 missing 
// deal with .a
rename b116_ depress_young
replace depress_young = 0 if depress_young == 5

tab b118_, m
replace b118_ = . if b118_ == .e // 1 missing 
// deal with .a
rename b118_ emotional_young
replace emotional_young = 0 if emotional_young == 5

tab b122_, m
replace b122_ = . if b122_ == .e // 1 missing 
// deal with .a
rename b122_ smoke_young
replace smoke_young = 0 if smoke_young == 5



**********************************
*** Section C  Physical Health ***
tab c001_, m 
replace c001_ = . if c001_ == .e // 1 missing 
rename c001_ health_now

* lung disease and treatment *
tab c030_, m
replace c030_ = . if c030_ == .e // 2 missing
replace c030_ = 0 if c030_ == 4 | c030_ == 5 | c030_ == 6
rename c030_ lung_disease

tab c034_, m
replace c034_ = . if c034_ == .e // 7359 missing
rename c034_ respiratory_theropy
replace respiratory_theropy = 0 if respiratory_theropy == 5 | respiratory_theropy == .a

tab c065_, m
replace c065_ = . if c065 == .e // 4 missing 
rename c065 emotional_now
replace emotional_now = 0 if emotional_now == 5

tab c271_, m
replace c271_ = . if c271_ == .e // 3 missing 
rename c271_ depress_now
replace depress_now = 0 if depress_now == 5

tab c223_, m 
replace c223_ = . if c223_ == .e // 3 missing 
rename c223_ exercise


* smoke related *
rename c116_ ever_smoked
rename c117_ smoke_now
rename c118_ number_cig
rename c119_ number_pack
rename c123_ number_cig_peak
rename c124_ number_pack_peak
replace ever_smoked = . if ever_smoked == .a | ever_smoked == .e
replace smoke_now = . if smoke_now == .a | smoke_now == .e
replace number_cig = . if number_cig == .a | number_cig == .e 
replace number_pack = . if number_pack == .a | number_pack == .e 
replace number_cig_peak = . if number_cig_peak == .a | number_cig_peak == .e 
replace number_pack_peak = . if number_pack_peak == .a | number_pack_peak == .e 
replace ever_smoked = 0 if ever_smoked == 5
replace smoke_now = 0 if smoke_now == 5



***************************
*** Section D Cognition ***
rename d110 depress_last_week
rename d113 happy_last_week
rename d114 lonely_last_week
rename d116 sad_last_week

replace depress_last_week = . if depress_last_week == .a | depress_last_week == .e
replace happy_last_week = . if happy_last_week == .a | happy_last_week == .e
replace lonely_last_week = . if lonely_last_week == .a | lonely_last_week == .e
replace sad_last_week = . if sad_last_week == .a | sad_last_week == .e

replace depress_last_week = 0 if depress_last_week == 5
replace happy_last_week = 0 if happy_last_week == 5
replace lonely_last_week = 0 if lonely_last_week == 5
replace sad_last_week = 0 if sad_last_week == 5

drop preload*
drop updat*
drop x*
drop z*
drop a0* a1* a2*
drop b0* b1*
drop c0* c1* c2* c3*
drop d1*
drop child*
drop hhmemberx*
drop previwmonth d290 r2x067ayrborn r2x060asex askliving cs_001 multiplewaves hrscawi previous_endtime previous_wave hhmembercounter e140_resnonkid f205_malivinghhm f206_palivinghhm e180_siblings e181_siblings e054 penewhhms uas089 randomizer_words
drop age_myhh

