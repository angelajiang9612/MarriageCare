
*Author: Angela Jiang 
*Written on a mac 

*This dofile reads in G_R and G_HP (informal care and helper sections) from the raw da data provided by the HRS, and outputs stata dta files. 
*Before running this dofile, need to first make changes in dtc files provided by HRS, in particualar change the file in path for the da files. 
*The main file combines 2002-2018, this file also generate variables that are missing for some of the years 2002-2018 so that we do not have error for merger. 
*Make adjustements to 2018 variables so they match the others (make some variables upper case)


*Input Data: Rand HRS file randhrs1992_2018v2.dta
*Output files: HRS_Raw/data/h`year'g_r.dta, HRS_Raw/data/h`year'g_hp.dta, year range 2002-2018



clear 

version 17.0

cap log close 

set more off 

set seed 0102

global data_path "$folder_path/Data"
*******************2002-2018*************** //earlier years informal care and helper questions exist but very differen 




foreach i in 02 04 06 08 10 12 14 16 {
	
	infile using "$data_path/HRS_Raw/h`i'sta/H`i'G_R.dct"

	rename HHID PN, lower //to match with 2018 

	save "$data_path/HRS_Raw/data/h20`i'g_r.dta", replace

	clear 
	
	infile using "$data_path/HRS_Raw/h`i'sta/H`i'G_HP.dct"
	
	rename HHID PN, lower 

	save "$data_path/HRS_Raw/data/h20`i'g_hp.dta", replace 
	
	clear
}

*****************generate some missing variables for years that do not have a particular variable when the information exists for other years***************


**The Anyone Else Help Question For ADLS 

foreach i in 2002 2004 2006 2008 {
	
	use  "$data_path/HRS_Raw/data/h`i'g_r.dta", clear 
	
	//The ADL Anyone Else Helps Question 
	
	capture drop temp_G035_1 temp_G035_2 temp_G035_3 temp_G035_4 temp_G035_5 temp_G035_6 
	gen temp_G035_1 =. 
	gen temp_G035_2 =.
	gen temp_G035_3 =.
	gen temp_G035_4 =.
	gen temp_G035_5 =. 
	gen temp_G035_6 =.
	
	save  "$data_path/HRS_Raw/data/h`i'g_r.dta", replace  
	
	clear 
}


**The Anyone Else Help Question For IADLS 

foreach i in 2002 2004 2006 2008 2010 {
	
	use  "$data_path/HRS_Raw/data/h`i'g_r.dta", clear 
	//The IADL Anyone Else Helps Question 
	
    capture drop temp_G057_1 temp_G057_2 temp_G057_3 temp_G057_4 temp_G057_5
	
	gen temp_G057_1=.
	gen temp_G057_2=.
	gen temp_G057_3=.
	gen temp_G057_4=.
	gen temp_G057_5=.
	
	save  "$data_path/HRS_Raw/data/h`i'g_r.dta", replace  
	
}


//Rename the 2018 files already provided in dta format by HRS/////
//Save as new versions of raw for analysis so do not override original data

//The 2018 variables are all lower case, which usually doesn't matter, but the link id variables need to be converted to upper first /////

use  "$data_path/HRS_Raw/h18sta/h18g_hp.dta", clear //use original file 

rename *ndx, upper

save  "$data_path/HRS_Raw/data/h2018g_hp.dta", replace //generate new file


























