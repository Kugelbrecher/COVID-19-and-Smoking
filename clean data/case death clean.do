clear all
set more off
cd "/Users/nik/Desktop/data/clean data"


import delimited death_rate.csv, delimiters(",") clear varnames(1)

drop median*

egen median_case = median(totalcases)
egen median_death = median(totaldeaths)
egen median_case_rate = median(caserateper100000)
egen median_death_rate = median(deathrateper100000)

gen case = 0
gen death = 0
gen case_rate = 0
gen death_rate = 0

replace case = 1 if totalcases >= median_case
replace death = 1 if totaldeaths >= median_death
replace case_rate = 1 if caserateper100000 >= median_case_rate
replace death_rate = 1 if deathrateper100000 >= median_death_rate

br if case_rate == 1
/*
stateterritory
Alaska
Alabama
Arkansas
Arizona
Georgia
Iowa
Idaho
Illinois
Indiana
Kansas
Louisiana
Minnesota
Missouri
Mississippi
Montana
North Dakota
Nebraska
New Mexico
Nevada
Oklahoma
South Carolina
South Dakota
Tennessee
Utah
Wisconsin
Wyoming
*/

br if death_rate == 1
/*
stateterritory
Alabama 1
Arkansas 5
Arizona 4
Connecticut 9
District of Columbia 11
Florida 12
Georgia 13
Iowa 19
Illinois 17
Indiana 18
Kansas 20
Louisiana 22
Massachusetts 25
Maryland 24
Michigan 26
Minnesota 27
Mississippi 28
North Dakota 38
New Jersey 34
New Mexico 35
Nevada 32
New York 36
Pennsylvania 42
South Carolina 45
South Dakota 46
Tennessee 47
*/

save death_rate.csv, replace



******************************************************
use panel_version.dta, clear
gen case_rate_high = 0
gen death_rate_high = 0

replace case_rate_high = 1 if statereside == 1 | statereside ==2 | statereside ==4 | statereside ==5 | statereside == 13 | statereside == 19 | statereside == 16 | statereside == 17 | statereside == 18 | statereside == 20 | statereside == 22 | statereside == 27 | statereside == 28 | statereside == 29 | statereside == 30 | statereside == 31 | statereside == 32 | statereside == 35 | statereside == 38 | statereside == 40 | statereside == 45 | statereside == 46 | statereside == 47 | statereside == 49 | statereside == 55 | statereside == 56

replace death_rate_high = 1 if statereside == 1 | statereside == 5 | statereside == 4 | statereside == 9 | statereside == 11 | statereside == 12 | statereside == 13 | statereside == 19 | statereside == 17 | statereside == 18 | statereside == 20 | statereside == 22 | statereside == 25 | statereside == 24 | statereside == 26 | statereside == 27 | statereside == 28 | statereside == 38 | statereside == 34 | statereside == 35 | statereside == 32| statereside == 36 | statereside == 42 | statereside == 45 | statereside == 46 | statereside == 47

gen case_death_rate_high = 0
replace case_death_rate_high = 1 if case_rate_high == 1 & death_rate_high == 1

save panel_version.dta, replace

