/*
uas20.dta is the Health and Retirement Study survey taken by respondents from 2015 to 2019.

Aim of code below: Using uas20.dta as an example to learn how the survey is transformed into dataset and select the potentially useful variables.
*/

* data convention .e: seen but not answered *
* data convention .c: did not finish the survey, used in end_date *
* data convention .a: never seen *

clear all
set more off
cd "/Users/nik/Desktop/data/raw data"
use uas20.dta, clear


********************************************
*** Background and Demographic Variables ***
des uasid // individual identifier
isid uasid // uasid is a primary key

drop uashhid
drop survhhid 
drop uasmembers
drop sampletype
drop batch
drop primary_respondent
drop hardware
drop language

tab start_year, m // 2015-2019
tab end_year, m 
drop if end_year == .c // 84 respondents did not finish the survey
drop if end_year == 2020 // 1 respondent finished too late
drop start_day
drop start_hour
drop start_min
drop start_sec
drop end_day
drop end_hour
drop end_min
drop end_sec

tab gender, m
replace gender = . if gender == .e // 4 missing
tab age, m
replace age = . if age == .e // 7 missing
drop dateofbirth_year // 7 missing, cannot be used to calculate the 7 missing values for variable age
drop agerange
drop citizenus
drop bornus
drop stateborn
drop countryborn countryborn_other
drop immigrant_status

tab statereside, m
replace statereside = . if statereside == .e // 10 missing， categorical
tab maritalstatus, m
replace maritalstatus = . if maritalstatus == .e // 7 missing
tab livewithpartner, m
replace livewithpartner = . if livewithpartner == .e // 8 missing
replace livewithpartner = 1 if livewithpartner == .a // 4435 as they are married
tab educ, m
replace educ = . if educ == .e // 5 missing

tab race, m // a collection of following bianry races
replace race = . if race == .e // 43 missing
tab hisplatino, m
replace hisplatino = . if hisplatino == .e // 4 missing
drop hisplatino_group
tab white, m
replace white = . if white == .e // 44 missing
tab black, m
replace black = . if black == .e // 44 missing
tab nativeamer, m
replace nativeamer = . if nativeamer == .e // 44 missing
tab asian, m
replace asian = . if asian == .e // 44 missing
tab pacific, m
replace pacific = . if pacific == .e // 44 missing

tab laborstatus, m //a collection of following working status
replace laborstatus = . if laborstatus == .e // 10 missing
des working // currently working for pay
tab working, m
replace working = . if working == .e // 10 missing
tab sick_leave, m
replace sick_leave = . if sick_leave == .e // 10 missing
tab unemp_layoff, m
replace unemp_layoff = . if unemp_layoff == .e // 10 missing
tab unemp_look, m
replace unemp_look = . if unemp_look == .e // 10 missing
replace retired = . if retired == .e // 10 missing
tab lf_other, m
replace lf_other = . if lf_other == .e // 10 missing
drop disabled lf_other

tab employmenttype, m
drop employmenttype
tab workfullpart, m
drop workfullpart
tab hourswork, m
replace hourswork = 0 if hourswork == .a // 2995 changes

tab hhincome, m
replace hhincome = . if hhincome == .e // 27 missing, categorical, not continuous
tab anyhhmember, m
replace anyhhmember = . if anyhhmember == .e // 10 missing
tab hhmembernumber, m
replace hhmembernumber = . if hhmembernumber == .e  // 448 missing
// these variables might a good substitution for livewithpartner, as they show how many people reside in the same place with the potential smoker.
drop hhmemberage_* // the age of 1st to 11th member in that household
drop hhmembergen_* // the gender of 1st to 11th member in that household
drop hhmemberin_* // indicate whether this person currently in that household
drop hhmemberrel_* // relationship b/w this person with respondent 
drop hhmemberuasid_*

drop lastmyhh_date



*****************
*** Section A ***
drop a166_a020tsamespp_a

tab a167_a028, m
replace a167_a028 = . if a167_a028 == .a | a167_a028 == .e
rename a167_a028 live_nurse
label variable live_nurse "living in a nursing home or care facility"

drop a209_livtogethr
drop x* // dropped 181 varaibles
drop a017_rage65 a033_spinnhome
drop r2x067ayrborn
drop a042_spage65 
drop a050_nwcohortfinr
drop r2x060asex
drop a065_ a066_ a168_a068_stnhome a069sstnhome_s a070_nhownrent

tab a169_a076tcurresst_a, m //current residence state
replace a169_a076tcurresst_a = . if a169_a076tcurresst_a == .a | a169_a076tcurresst_a == .e // 12 .a missing 22 .e missing
rename a169_a076tcurresst_a now_resid_state
label var now_resid_state "current residence state" 
// vs. the variable statereside, there are a few differences.

drop a077scurresst_s
drop a078_yrscurres 
drop a079_ 
drop a170_a081tothresst_a
drop a082sothresst_s 
drop a083 a085_whichmainres

tab a014, m
replace a014 = . if a014 == .a | a014 == .e
rename a014 cal_age
label var cal_age "calculated age" // see what is the diff b/w cal_age and age 

drop child* // dropped 163 varaibles
drop a026_rmarried a027_rpartnerd a019_rage a212_ a213_ askliving
drop hhmemberx0* // dropped 82 varaibles



*****************
*** Section B ***

// for large number of missing values:
misstable sum, all
drop b083m b006_ b007_ b008_ b085_ b086_ b087_ b015_ b017m
drop b127*
drop b129*
drop b079 b081 
drop b029ms*
drop b036_ b037_ b038_ b096_ b097_ b040_ b048s
drop b066__* b067__* b068__* b070__* b128__*

tab b000_, m 
replace b000_ = . if b000_ == .a // 4 missing
rename b000_ life_satisf

tab b132, m
replace b132 = . if b132 == .e | b132 == .a // 64 missing
rename b132 take_risk
label var take_risk "how much risk willing to take from 1-10"

drop b002_ b005s b005s_other

tab b014, m
replace b014 = . if b014 == .a | b014 == .e // 13 missing 
rename b014 educ // highest level of education

drop b016

tab b019, m
replace b019 = . if b019 == .a // 4 missing
rename b019 health_young

drop b099_ b100_ b101_ b102_ b103_ b105_ b106_ b108_ b109_

* smoke related *
tab b104_, m 
replace b104_ = . if b104_ == .a | b104_ == .e // 5 missing
rename b104_ parent_smoke

tab b107_, m
replace b107_ = . if b107_ == .a | b107_ == .e // 255 missing 
rename b107_ respiratory_young

drop b110_ b111_ b112_ b113_ b114_ b115_ b117_ b119_ b120_

tab b116_, m
replace b116_ = . if b116_ == .a | b116_ == .e // 192 missing 
rename b116_ depress_young

tab b118_, m
replace b118_ = . if b118_ == .a | b118_ == .e // 195 missing 
rename b118_ emotional_young

tab b122_, m
replace b122_ = . if b122_ == .a | b122_ == .e // 7 missing 
replace b122_ = . if b122_ == 58 // 1 error
rename b122_ smoke_young

drop b123_ b124_ b003_ b020_ b021_ b022_ b023_ b025_ b078_ b080_ b026_ b027_ b088_ b028_
drop b029m b089m*
drop b033_ b091_ b034_ b035_ b039_ b049_ b050_ b082_ b054_ b061_ b065_ b076_



**********************************
*** Section C  Physical Health ***
tab c001_, m 
replace c001_ = . if c001_ == .a | c001_ == .e // 7 missing 
rename c001_ health_now

drop c005_ c006_ c010_ c214_ c011_ c012_ c236_ c018_ c019_ c020_
drop c021m*
drop c028_ c029_

* lung disease and treatment *
tab c030_, m
replace c030_ = . if c030_ == .a | c030_ == .e // 10 missing
rename c030_ lung_disease

tab c034_, m
replace c034_ = . if c034_ == .a | c034_ == .e // 7359 missing
rename c034_ respiratory_theropy

drop c032_ c033_

drop c036_ c037_ c038_ c257_ c260_ c258_ c259_ c274_ c275_ c276_ c277_ c040_ c041_ c042_ c043_ c044_ c261_ c045_ c046_ c263_ c264_ c048_ c049_ c050_ c266_ c267_ c282_ c269_ c053_ c054_ c055_ c060_ c061_

tab c065_, m
replace c065_ = . if c065_ == .a | c065 == .e // 10 missing 
rename c065 emotional_now

tab c271_, m
replace c271_ = . if c271_ == .a | c271_ == .e // 8 missing 
rename c271_ depress_now

drop c272_ c067_ c273_ c070_ c210_ c076_ c218_
drop c077m*
drop c219_ c220_ c221_ c222_ c240_ c246_ c283_ c280_ c281_ c079_ c082_ c080_ c081_ c095_ c088_ c087_ c089_ c090_ c096_ c097_ c098_ c099_ c100_ c101_ c237_ c102_ c103_ c083_ c084_ c085_ c086_ c232_ c233_ c104_ c105_ c106_ c107_ c278_ c109_ c110_ c112_ c113_ c249_ c250_ c252_ c114_ c253_ c251_ c279_

tab c223_, m 
replace c223_ = . if c223_ == .a // 6 missing 
rename c223_ exercise
drop c224_ c225_

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

drop c0* c1* c2*



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

drop d1* b0* a0* a1* a2* 
drop hhmembercounter e140_resnonkid f205_malivinghhm f206_palivinghhm e180_siblings e181_siblings
drop randomizer_words cs_001 uas089 serialseven

