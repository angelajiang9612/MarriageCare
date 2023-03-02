
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

use "/Users/bubbles/Desktop/MarriageCare/Dofiles/Output/HRS_combined", clear 

/*
keep if hacohort == `LBB'  //uses the cohorts we are interested in 
*/


//Has a limitation if has a adl or iadl limitation, do not consider financial help at the moment 

gen limited =1 if radl5a == 1 | radl5a == 2 | radl5a == 3 | radl5a == 4 | radl5a == 5 | riadl5a == 1 | riadl5a == 2 | riadl5a == 3 | riadl5a == 4 | riadl5a == 5

//Categorize each helper as an informal helper or formal helper in the way of Katz, Kabeto & Langa 


gen any_care =1 if rhlprtn > 0 & rhlprtn!=. & rhlprtn!=.d & rhlprtn!=.j & rhlprtn!=.m & rhlprtn!=.r 

replace any_care = 0 if limited==1 &  any_care !=1

gen informal_care =1 if (rhp_r <= 19 & rhp_r >= 1) | (rhp_r <= 28 & rhp_r >=26) | (rhp_r <= 28 & rhp_r >=26) | (rhp_r <= 31 & rhp_r >=30) | (rhp_r <= 91 & rhp_r >= 33) //all relatives are considered informal_care, regardless of whether or not paid

gen formal_care=1 if rhp_r <= 25 & rhp_r >= 21 //facilities and organisations and professionals are formal, regardless of pay 

replace informal_care =1 if (rhp_r == 20 | rhp_r == 29 | rhp_r == 32) & rhp_paid == 5 //if in ambiguous category and paid, consider to be formal care 

replace formal_care =1 if (rhp_r == 20 | rhp_r == 29 | rhp_r == 32) & rhp_paid ==1 //if in ambiguous category and unpaid, consider to be informal care. 

replace formal_care =0 if limited ==1 & missing(formal_care) //if disabled and formal_are is not 1, then set formal_care to be 0 

replace informal_care =0 if limited ==1 & missing(informal_care)

gen hp_spouse =1 if rhp_r==2 


by hhidpn(wave), sort: egen spouse_care = max(hp_spouse) //if spouse cared for at all in that wave

replace spouse_care=0 if limited ==1 & spouse_care ==. //if disabled and no spouse care provided 


gen hp_child =1 if rhp_r<= 8 & rhp_r >=3  //son, daughter, son-in-law, daughter-in-law, step son or step daughter. Ignore grandchildren for now even though they provide a pretty substantial amount of care. 

by hhidpn(wave), sort: egen child_care = max(hp_child) //if spouse cared for at all in that wave

replace child_care=0 if limited ==1 & child_care ==. //if disabled and no spouse care provided 



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











































































































































































