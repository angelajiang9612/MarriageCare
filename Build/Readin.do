
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

	rename HHID PN, lower 

	save "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Raw/data/h20`i'g_r.dta", replace

	clear 
	
	infile using "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Raw/h`i'sta/H`i'G_HP.dct"
	
	rename HHID PN, lower 

	save "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Raw/data/h20`i'g_hp.dta", replace 
	
	clear
}




































