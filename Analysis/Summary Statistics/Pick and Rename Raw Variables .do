
clear 

version 17.0

cap log close 

set more off 

set seed 0102


*******************G-Respondent section************************************

*******************2002-2018****************

clear 

foreach i in 2002 2004 2006 2008 2010 2012 2014 2016 2018 {
	set maxvar 10000 // default is 5000
	use "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Raw/data/h`i'g_r.dta", clear
	
	//keep the variables we are interested 
	keep hhid pn *G032_1 *G033_1 *G035_1 *G032_2 *G033_2 *G035_2 *G032_3 *G033_3 *G035_3 *G032_4 *G033_4 *G035_4  *G032_5  *G033_5 *G035_5  *G032_6 *G033_6 *G035_6 *G032_7 *G033_7 *G054_1  *G055_1  *G057_1 *G054_2 *G055_2 *G057_2 *G054_3 *G055_3 *G057_3 *G054_4 *G055_4 *G057_4 *G054_5 *G055_5  *G057_5 *G054_6 *G055_6 *G062_1 *G063_1 *G097 *G098M1 *G098M2 *G098M3 *G098M4 
	
	//rename them to something that has meaning and matches the form of Rand HRS
	
	//ADLs
	rename *G032_1 radl_1 
	rename *G033_1 rhp_r1
	rename *G035_1 radl_else1 
	rename *G032_2 radl_2
	rename *G033_2 rhp_r2
	rename *G035_2 radl_else2
	rename *G032_3 radl_3
	rename *G033_3 rhp_r3
	rename *G035_3 radl_else3
	rename *G032_4 radl_4
	rename *G033_4 rhp_r4
	rename *G035_4 radl_else4
	rename *G032_5 radl_5
	rename *G033_5 rhp_r5
	rename *G035_5 radl_else5
	rename *G032_6 radl_6
	rename *G033_6 rhp_r6
	rename *G035_6 radl_else6
	rename *G032_7 radl_7
	rename *G033_7 rhp_r7
	
	//IADLS
	rename *G054_1 riadl_1 
	rename *G055_1 rihp_r1
	rename *G057_1 riadl_else1 
	rename *G054_2 riadl_2
	rename *G055_2 rihp_r2
	rename *G057_2 riadl_else2
	rename *G054_3 riadl_3
	rename *G055_3 rihp_r3
	rename *G057_3 riadl_else3
	rename *G054_4 riadl_4
	rename *G055_4 rihp_r4
	rename *G057_4 riadl_else4
	rename *G054_5 riadl_5
	rename *G055_5 rihp_r5
	rename *G057_5 riadl_else5
	rename *G054_6 riadl_6
	rename *G055_6 rihp_r6
	
	//Financial Help 
	
	rename *G062_1 rmoney_help_who
	rename *G063_1 rmoney_help_r
	
	//Future needs 
	rename *G097 rexphelp
	rename *G098M1 rexphelp_r1
	rename *G098M2 rexphelp_r2
	rename *G098M3 rexphelp_r3
	rename *G098M4 rexphelp_r4	
	
	gen Wave = (`i'-1990)/2
	gen Year = `i'
	save "/Users/bubbles/Desktop/MarriageCare/Data/temp/HRS_g_r_Wave`i'.dta", replace //save with per wave name 
	clear 
}

*******************G-GH (Helper) section************************************




























































