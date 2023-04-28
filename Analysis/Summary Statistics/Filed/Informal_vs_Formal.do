
*Author: Angela Jiang 
*Input Data: Rand HRS file randhrs1992_2018v2.dta
*Output file: 
*Written on a mac 

*This dofile compares long-term care provision outcomes for men and women of different cohorts, and by marital status (married, partnered, single)
*Can consider people in the community and people in institutions, but for hours and paid amount this would only be available for those who do not live in institutions. 


clear 

version 17.0

cap log close 

set more off 

set seed 0102


//define the cohorts and initial waves 

local Ahead 1
local HRS 3 
local CODA 2
local WB 4
local EBB 5
local MBB 6 
local LBB 7 

local HRS_init 1 
local Ahead_init 2 
local CODA_init 4 
local WB_init 4
local EBB_init 7 
local MBB_init 10 
local LBB_init 13

use "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Cleaned/HRS_combined", clear 

/*
keep if hacohort == `LBB'  //uses the cohorts we are interested in 
*/


sort hhidpn wave 


//Has a limitation if has a adl or iadl limitation, do not consider financial help at the moment 

gen limited =1 if radl5a == 1 | radl5a == 2 | radl5a == 3 | radl5a == 4 | radl5a == 5 | riadl5a == 1 | riadl5a == 2 | riadl5a == 3 | riadl5a == 4 | riadl5a == 5

replace limited =0 if missing(limited)



gen s_limited =1 if sadl5a == 1 | sadl5a == 2 | sadl5a == 3 | sadl5a == 4 | sadl5a == 5 | siadl5a == 1 | siadl5a == 2 | siadl5a == 3 | siadl5a == 4 | siadl5a == 5

replace s_limited =0 if missing(s_limited)


//Any care at all

gen any_care =1 if rhlprtn > 0 & rhlprtn!=. & rhlprtn!=.d & rhlprtn!=.j & rhlprtn!=.m & rhlprtn!=.r  

replace any_care = 0 if missing(any_care)



/////////Categorize each helper as an informal helper or formal helper in the way of Katz, Kabeto & Langa////////// 


gen informal_carer =1 if (rhp_r <= 19 & rhp_r >= 1) | (rhp_r <= 28 & rhp_r >=26) | (rhp_r <= 28 & rhp_r >=26) | (rhp_r <= 31 & rhp_r >=30) | (rhp_r <= 91 & rhp_r >= 33) //all relatives are considered informal_care, regardless of whether or not paid

gen formal_carer=1 if rhp_r <= 25 & rhp_r >= 21 //facilities and organisations and professionals are formal, regardless of pay 

replace informal_carer =1 if (rhp_r == 20 | rhp_r == 29 | rhp_r == 32) & rhp_paid == 5 //if in ambiguous category and paid, consider to be formal care 

replace formal_carer =1 if (rhp_r == 20 | rhp_r == 29 | rhp_r == 32) & rhp_paid ==1 //if in ambiguous category and unpaid, consider to be informal care. 

replace formal_carer =0 if limited ==1 & missing(formal_care) //if disabled and formal_are is not 1, then set formal_care to be 0 

replace informal_carer =0 if limited ==1 & missing(informal_care)

gen hp_spouse =1 if rhp_r==2 

replace hp_spouse =0 if limited ==1 & missing(hp_spouse)

gen hp_child =1 if rhp_r<= 8 & rhp_r >=3  //son, daughter, son-in-law, daughter-in-law, step son or step daughter. Ignore grandchildren for now even though they provide a pretty substantial amount of care. 

replace hp_child=0 if limited ==1 & missing(hp_child)




///////Generate Variables for Per Wave have a Carer at all///////

bysort hhidpn wave:  egen any_informal_care = max(informal_carer) // had informal_carer at all

replace any_informal_care=0 if any_informal_care ==. //


bysort hhidpn wave:  egen any_formal_care = max(formal_carer) // had informal_carer at all

replace any_formal_care=0 if any_informal_care ==. // 


bysort hhidpn wave:  egen spouse_care = max(hp_spouse) // had informal_carer at all

replace spouse_care=0 if spouse_care ==. // 


bysort hhidpn wave:  egen child_care = max(hp_child) // had informal_carer at all

replace child_care=0 if child_care ==. //if disabled and no spouse care provided 







///Display Summary Statistics////


duplicates drop hhidpn wave, force //get to the one record each wave format again. 

tab any_care  if limited==1

tab any_informal_care  if limited==1

tab any_formal_care if limited==1

tab spouse_care if limited==1

tab child_care if limited==1


tab any_care ragender  if limited==1, col

tab any_informal_care ragender if limited==1, col

tab any_formal_care ragender if limited==1, col 

tab spouse_care ragender if limited==1, col 

tab child_care ragender if limited==1, col 


tab spouse_care ragender if limited==1 & s_limited==0, col //conditioning on having a healthy spouse 

tab child_care ragender if limited==1 & s_limited==0, col 


tab spouse_care ragender if limited==1 & s_limited==0 & (hacohort==5 | hacohort==6 | hacohort==7) , col 

tab spouse_care ragender if limited==1 & s_limited==0 & (hacohort!=5 & hacohort!=6 & hacohort!=7) , col 




tab any_care rmstat  if limited==1, col

tab any_informal_care rmstat if limited==1, col

tab any_formal_care rmstat if limited==1, col 

tab spouse_care rmstat if limited==1, col 

tab spouse_care rmstat if limited==1 & s_limited==0, col //conditioning on having a healthy spouse 

tab child_care rmstat if limited==1 & s_limited==0, col 












/* don't use this, tabdisp cannot do proportions and many other things 
egen tag = tag(hhidpn wave)

egen distinct = total(tag), by(limited)

tabdisp limited, c(distinct)

*/










/////////////////Now look at hours per week for those not residing in facilities//////////////////////

*Summary Statistics for this section should only be for people who are not residing in nursing homes, because hours per week data is not asked of employees of facility. Checked that those who are not living in nursing homes do never really have care from a facility member. 


drop if rnhmliv==1 //dropping those who lives in nursing homes. 

gen hours_in_week = rhp_days_inweek*rhp_hrs

by hhidpn(wave), sort: gen total_hours = total(hours_in_week)

by hhidpn(wave), sort: gen informal_hours = total(hours_in_week) if informal_care==1

by hhidpn(wave), sort: gen formal_hours = total(hours_in_week) if formal_care==1


//look at spouse only 

gen hp_not_spouse ==1 if any_care ==1 & rhp_r!=2 //if had a helper but the helper is not spouse then the helper is someone else. 

by hhidpn(wave), sort: gen spouse_only = max(hp_not_spouse)

by hhidpn(wave), sort: replace spouse_only = 0 if missing(spouse_only) & limited==1 //need to check this











































































































































































