clear all
macro drop _all

//this file merges baseline marriage statisfaction variable with HRS data///


//step 1 is to download the 1992 da and sta files, then change the dct files in the sta files so the using... represents the location of the da file on your local laptop 

cap log close 

set more off 

set seed 0102


infile using "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Raw/h92sta/HEALTH.DCT"

save "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Raw/data/92health.dta", replace

gen hhidpn= HHID+ PN

destring hhidpn, replace

gen spouse_92pn = HHID + APN_SP  //generate spouse hhpnid, this is okay for baselind variable, but pn probably changes over time. 

destring spouse_92pn, replace

rename V2613 r1msatis

keep hhidpn spouse_92pn r1msatis //keep own id and spouse id 
	

save "/Users/bubbles/Desktop/MarriageCare/Data/temp/92temp.dta", replace

//append spouse 

use "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Raw/data/92health.dta", clear

gen hhidpn=HHID+ PN

destring hhidpn, replace

rename hhidpn spouse_92pn 

rename V2613 s1msatis

keep spouse_92pn s1msatis

save "/Users/bubbles/Desktop/MarriageCare/Data/temp/92temp_spouse.dta", replace


///merge own and spouse 

use "/Users/bubbles/Desktop/MarriageCare/Data/temp/92temp.dta", replace

merge 1:1 spouse_92pn using "/Users/bubbles/Desktop/MarriageCare/Data/temp/92temp_spouse.dta", force 

drop if _merge==2 //drop if not matched (no spouse)
drop _merge 

save "/Users/bubbles/Desktop/MarriageCare/Data/temp/92temp_all", replace



//combine with RAND data 

use "/Users/bubbles/Desktop/MarriageCare/Data/randhrs1992_2018v2_STATA/randhrs1992_2018v2.dta", clear 


merge 1:1 hhidpn using "/Users/bubbles/Desktop/MarriageCare/Data/temp/92temp_all.dta", force 

drop if _merge==2
drop _merge


save "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Raw/data/RAND_msatisfaction.dta", replace




























