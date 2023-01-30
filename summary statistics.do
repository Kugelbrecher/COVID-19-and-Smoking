clear all
set more off
cd "/Users/nik/Desktop/data"

*** background stat ***
use panel_version.dta, clear
keep if timing == 2


estpost tabstat gender hisplatino white black nativeamer asian pacific, by(smoke_now) statistics(mean sd count) columns(statistics)

esttab using t2invarsmoke.rtf, replace cells("mean(fmt(%9.3f)) sd(fmt(%9.3f)) count(fmt(%9.0f))") noobs nonumbers title("Statistics by Smoking behavior") label

estpost tabstat age livewithpartner unemp_layoff unemp_look retired working hourswork hhincome, by(smoke_now) statistics(mean sd count) columns(statistics)
esttab using t2varsmoke.rtf, replace cells("mean(fmt(%9.3f)) sd(fmt(%9.3f)) count(fmt(%9.0f))") noobs nonumbers title("Statistics by Smoking behavior") label


use panel_version.dta, clear
keep if timing == 1
estpost tabstat gender hisplatino white black nativeamer asian pacific, by(smoke_now) statistics(mean sd count) columns(statistics)

esttab using t1invarsmoke.rtf, replace cells("mean(fmt(%9.3f)) sd(fmt(%9.3f)) count(fmt(%9.0f))") noobs nonumbers title("Statistics by Smoking behavior") label

estpost tabstat age livewithpartner unemp_layoff unemp_look retired working hourswork hhincome, by(smoke_now) statistics(mean sd count) columns(statistics)
esttab using t1varsmoke.rtf, replace cells("mean(fmt(%9.3f)) sd(fmt(%9.3f)) count(fmt(%9.0f))") noobs nonumbers title("Statistics by Smoking behavior") label

use panel_version.dta, clear
keep if timing == 0
estpost tabstat gender hisplatino white black nativeamer asian pacific, by(smoke_now) statistics(mean sd count) columns(statistics)

esttab using t0invarsmoke.rtf, replace cells("mean(fmt(%9.3f)) sd(fmt(%9.3f)) count(fmt(%9.0f))") noobs nonumbers title("Statistics by Smoking behavior") label

estpost tabstat age livewithpartner unemp_layoff unemp_look retired working hourswork hhincome, by(smoke_now) statistics(mean sd count) columns(statistics)
esttab using t0varsmoke.rtf, replace cells("mean(fmt(%9.3f)) sd(fmt(%9.3f)) count(fmt(%9.0f))") noobs nonumbers title("Statistics by Smoking behavior") label


*** smoking stata ***
use panel_version.dta, clear
keep if timing == 2
estpost tabstat smoke_now, by(gender) statistics(mean sd count) columns(statistics)
esttab using t2gender.rtf, replace cells("mean(fmt(%9.3f)) sd(fmt(%9.3f)) count(fmt(%9.0f))") noobs nonumbers title("Statistics by Smoking behavior") label
estpost tabstat smoke_now, by(race) statistics(mean sd count) columns(statistics)
esttab using t2race.rtf, replace cells("mean(fmt(%9.3f)) sd(fmt(%9.3f)) count(fmt(%9.0f))") noobs nonumbers title("Statistics by Smoking behavior") label
estpost tabstat smoke_now, by(race) statistics(mean sd count) columns(statistics)
esttab using t2race.rtf, replace cells("mean(fmt(%9.3f)) sd(fmt(%9.3f)) count(fmt(%9.0f))") noobs nonumbers title("Statistics by Smoking behavior") label


use panel_version.dta, clear
keep if timing == 1
estpost tabstat smoke_now, by(gender) statistics(mean sd count) columns(statistics)
esttab using t1gender.rtf, replace cells("mean(fmt(%9.3f)) sd(fmt(%9.3f)) count(fmt(%9.0f))") noobs nonumbers title("Statistics by Smoking behavior") label
estpost tabstat smoke_now, by(race) statistics(mean sd count) columns(statistics)
esttab using t1race.rtf, replace cells("mean(fmt(%9.3f)) sd(fmt(%9.3f)) count(fmt(%9.0f))") noobs nonumbers title("Statistics by Smoking behavior") label


use panel_version.dta, clear
keep if timing == 0
estpost tabstat smoke_now, by(gender) statistics(mean sd count) columns(statistics)
esttab using t0gender.rtf, replace cells("mean(fmt(%9.3f)) sd(fmt(%9.3f)) count(fmt(%9.0f))") noobs nonumbers title("Statistics by Smoking behavior") label
estpost tabstat smoke_now, by(race) statistics(mean sd count) columns(statistics)
esttab using t0race.rtf, replace cells("mean(fmt(%9.3f)) sd(fmt(%9.3f)) count(fmt(%9.0f))") noobs nonumbers title("Statistics by Smoking behavior") label


