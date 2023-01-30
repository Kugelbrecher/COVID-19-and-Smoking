clear all
set more off
cd "/Users/nik/Desktop/data/clean data"



********************************
*** combine uas20 and uas185 ***
use uas20_clean.dta, clear
sort uasid
merge 1:1 uasid using uas185_clean.dta
keep if _merge == 3
drop _merge
save "/Users/nik/Desktop/data/clean data/uas20_wave13", replace

use uas185_clean.dta, clear
sort uasid
merge 1:1 uasid using uas20_clean.dta
keep if _merge == 3
drop _merge
save "/Users/nik/Desktop/data/clean data/uas185_wave13", replace

use uas20_wave13.dta, clear
append using uas185_wave13.dta
save "/Users/nik/Desktop/data/clean data/panel_13", replace
// 59 variables

********************************
*** combine uas20, uas95 and uas185 ***
use panel_13, clear
sort uasid timing
save, replace

use uas95_clean, clear
sort uasid timing
replace timing = 0
merge 1:1 uasid timing using panel_13.dta
keep if _merge == 3
drop _merge
replace timing = 1
save "/Users/nik/Desktop/data/clean data/uas95_123", replace

use uas185_clean.dta, clear
merge 1:1 uasid using uas95_123.dta
keep if _merge == 3
drop _merge
save uas185_123.dta, replace

use uas20_clean.dta, clear
merge 1:1 uasid using uas95_123.dta
keep if _merge == 3
drop _merge
save uas20_123.dta, replace

use uas20_123.dta, clear
append using uas95_123.dta
append using uas185_123.dta
sort uasid timing
save panel_version.dta, replace



