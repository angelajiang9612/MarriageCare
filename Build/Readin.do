
*Author: Angela Jiang 
*Input Data: Rand HRS file randhrs1992_2018v2.dta
*Output file: 
*Written on a mac 

*This dofiles reads in G_R and G_HP (informal care and helper sections) from the raw da data provided by the HRS, and outputs stata dta files. 
*Nedd to first make changes in dtc files-change the file in path for the da files. 

clear 

version 17.0

cap log close 

set more off 

set seed 0102

*******************2002-2018*************** //earlier years informal care and helper questions exist but very differen 

clear 


foreach i in 02 04 06 08 10 12 14 16 {
	
	infile using "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Raw/h`i'sta/H`i'G_R.dct"

	rename HHID PN, lower //to match with 2018 

	save "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Raw/data/h20`i'g_r.dta", replace

	clear 
	
	infile using "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Raw/h`i'sta/H`i'G_HP.dct"
	
	rename HHID PN, lower 

	save "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Raw/data/h20`i'g_hp.dta", replace 
	
	clear
}

*****************generate some missing variables for years that do not have a particular variable when the information exists for other years***************


**The Anyone Else Help Question For ADLS 

foreach i in 2002 2004 2006 2008 {
	
	use  "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Raw/data/h`i'g_r.dta", clear 
	
	//The ADL Anyone Else Helps Question 
	
	capture drop temp_G035_1 temp_G035_2 temp_G035_3 temp_G035_4 temp_G035_5 temp_G035_6 
	gen temp_G035_1 =. 
	gen temp_G035_2 =.
	gen temp_G035_3 =.
	gen temp_G035_4 =.
	gen temp_G035_5 =. 
	gen temp_G035_6 =.
	
	save  "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Raw/data/h`i'g_r.dta", replace  
	
	clear 
}


**The Anyone Else Help Question For IADLS 

foreach i in 2002 2004 2006 2008 2010 {
	
	use  "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Raw/data/h`i'g_r.dta", clear 
	//The IADL Anyone Else Helps Question 
	
    capture drop temp_G057_1 temp_G057_2 temp_G057_3 temp_G057_4 temp_G057_5
	
	gen temp_G057_1=.
	gen temp_G057_2=.
	gen temp_G057_3=.
	gen temp_G057_4=.
	gen temp_G057_5=.
	
	save  "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Raw/data/h`i'g_r.dta", replace  
	
}





























