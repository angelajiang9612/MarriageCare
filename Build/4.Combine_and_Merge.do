*Author: Angela Jiang 
*Written on a mac 

*This dofile merges Rand long form data with selected variables with the HRS Raw data G section selected variables into one longitudinal file. 
*Only 2002-2018 years are used. 


*Input Data:  temp/RAND.dta. /HRS_Raw_All_Waves.dta
*Output files: HRS_combined. A file that allows for analysis. 



clear 

version 17.0

cap log close 

set more off 

set seed 0102


use  "/Users/bubbles/Desktop/MarriageCare/Data/temp/RAND.dta", clear
merge 1:m hhidpn Wave using "/Users/bubbles/Desktop/MarriageCare/Data/temp/HRS_Raw_All_Waves.dta", force //1:m because the HRS raw has multiples of hhidpn and wave because of helpers 

rename Wave wave 


order hhidpn wave rmstat radl5a riadl5a radl5h riadl5h rhlprtn rhp_index rhp_iadl_ind rhp_adl_ind rhp_days_inmonth rhp_days_inweek rhp_everyday rhp_hrs rhp_sex rhp_paid rhp_gov_help rhp_private_cost rhp_pay_period radl* rhp_r* riadl* rihp_r*

save "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Cleaned/HRS_combined", replace

/*

//Look at all care and helper variables across original RAND, Respondent and Helper Sections 
br hhidpn wave radl5a radl5h riadl5a riadl5h  rhlprtn radl* rhp_r* riadl* rihp_r* rhp_index rhp_iadl_ind rhp_adl_ind rhp_freq rhp_days rhp_everyday rhp_hrs rhp_sex rhp_paid rhp_gov_help rhp_private_cost rhp_pay_period

\*




