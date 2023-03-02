
*Author: Angela Jiang 
*Written on a mac 

*This dofile picks useful care related variables from the raw HRS files section G-R (respondent) and G-HP (helper). It then merge the two sections for each wave and then merge all the waves together to get those extra variables in a longitudinal form. 
*Only 2002-2018 years are used. 


*Input Data: HRS_Raw/data/h`year'g_r.dta, HRS_Raw/data/h`year'g_hp.dta, year range 2002-2018 (from output of the readin.do file),
*Output files: HRS_Raw_All_Waves.dta





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
	
	gen hhidpn=hhid+ pn 
	destring hhidpn, replace
	
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


clear 

foreach i in 2002 2004 2006 2008 2010 2012 2014 2016 2018 {
	set maxvar 10000 // default is 5000
	use "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Raw/data/h`i'g_hp.dta", clear
	
	//keep the variables we are interested 
	keep hhid pn *G069 *G066  *ADLNDX *MNYNDX *G070 *G071 *G072 *G073 *G074 *G076 *G077 *G078 *G079 *G080 *G081 *G082
	
	gen hhidpn=hhid+ pn 
	destring hhidpn, replace 
	
	//rename them to something that has meaning and matches the form of Rand HRS
	
	rename *G069 rhp_r
	rename *G066 rhp_index
	rename *IADLNDX rhp_iadl_ind
	rename *ADLNDX rhp_adl_ind
	rename *MNYNDX rhp_money_ind
	rename *G070 rhp_days_inmonth
	rename *G071 rhp_days_inweek
	rename *G072 rhp_everyday
	rename *G073 rhp_hrs
	rename *G074 rhp_sex
	rename *G076 rhp_paid
	rename *G077 rhp_gov_help
	rename *G078 rhp_private_cost
	rename *G079 rhp_pay_period
	rename *G080 rhp_pay_100
	rename *G081 rhp_payhelp
	rename *G082 rhp_payhelp_r
	
	gen Wave = (`i'-1990)/2
	gen Year = `i'
	save "/Users/bubbles/Desktop/MarriageCare/Data/temp/HRS_g_hp_Wave`i'.dta", replace //save with per wave name 
	clear 
}


//////////////Merge Respondent and Helper Sections For Each Wave//////////////


clear 

foreach i in 2002 2004 2006 2008 2010 2012 2014 2016 2018 {
	set maxvar 10000 // default is 5000
	use "/Users/bubbles/Desktop/MarriageCare/Data/temp/HRS_g_r_Wave`i'.dta"
	
	merge 1:m hhidpn hhid pn using "/Users/bubbles/Desktop/MarriageCare/Data/temp/HRS_g_hp_Wave`i'.dta", force //1:m match because multiple helpers for one person in one wave is possible. Many not matched from master because not everyone has a helper and a helper file, no not matched from using because they have to be in the main dataset to have a helper section. 
	
	drop _merge 
	save "/Users/bubbles/Desktop/MarriageCare/Data/temp/HRS_g_Wave`i'.dta", replace //save with per wave name 
	
	clear 
}



//////////////Append all waves//////////////


use "/Users/bubbles/Desktop/MarriageCare/Data/temp/HRS_g_Wave2002.dta", clear
foreach i in 2004 2006 2008 2010 2012 2014 2016 2018 {
append using "/Users/bubbles/Desktop/MarriageCare/Data/temp/HRS_g_Wave`i'.dta", force
}

save "/Users/bubbles/Desktop/MarriageCare/Data/temp/HRS_Raw_All_Waves.dta", replace




















