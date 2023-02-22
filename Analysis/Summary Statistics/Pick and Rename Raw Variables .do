
clear 

version 17.0

cap log close 

set more off 

set seed 0102

cd " "

log using pick.log, text replace 


*******************Divide into helper and respondent sections*****************8

*******************2012-2006(no 2008)****************
foreach i in 2002 2004 2006 2008 2010 2012 2014 2016 2018 {
	set maxvar 10000 // default is 5000
	use "", clear
	keep hhidpn hhid pn 
	
	
	rename *pn_sp pn_sp
	rename *j479 r_IRecFutureSS
	rename *j480 r_AgeFutureSS
	rename *j481 r_AmountFutureSS
	rename *j485 r_Per
	
	rename *j487 r_62SS
	rename *j491 r_62Per
	rename *j493 r_NormSS
	rename *j497 r_NormPer
	
	rename *lb006 r_Closeness
	rename *j015 r_DisabledY
	
	gen Wave = (`i'-1990)/2
	gen Year = `i'
	save "RAND HRS longitudinal/Temp/Wave`i'.dta", replace
	clear
}
