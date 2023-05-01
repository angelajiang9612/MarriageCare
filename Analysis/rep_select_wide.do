//Replicate paper-In Sickness and in Health? Physical Illness as a Risk Factor for Marital Dissolution in Later Life
//Yang
//Feb 2023
//This do file run discrete-time survival analysis with competing risk using multinomial logistic model


clear 

version 15.0

cap log close 

set more off 

set seed 0102

set maxvar 30000

//cd "/Users/zhiyangfeng/Desktop/Ph.D./2023spring/long-term care/RAND hrs/randhrs1992_2018v2_STATA"

log using remarriage.log, text replace 

use "/Users/bubbles/Desktop/MarriageCare/Data/randhrs1992_2018v2_STATA/randhrs1992_2018v2.dta", clear


/////////define the cohorts and initial waves 


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


//////////sample selection

keep if hacohort==3  //uses the cohorts we are interested in 
keep if (r1agey_b>=51 & r1agey_b<=61) | (s1agey_b>=51 & s1agey_b<=61)	//At least one spouse is between 51 to 61
keep if r1mstat==1 | r1mstat==2  & (s1mstat==1  | s1mstat==2 )	//keep if married in the first wave

gen reverhad=1 if r1cancre==1 | r1lunge==1 | r1hearte==1 | r1stroke==1	//respondent ever had health prob before the 1st wave
replace reverhad=0 if reverhad==.
gen severhad=1 if s1cancre==1 | s1lunge==1 | s1hearte==1 | s1stroke==1	//spouse ever had health prob before the 1st wave
replace severhad=0 if severhad==.
keep if reverhad!=1	& severhad!=1


drop if r2iwstat==5 | s2iwstat==5   //drop if dead
drop if r2mstat==4 | r2mstat==5| r2mstat==6 | r2mstat==7 |  s2mstat==4 | s2mstat==5| s2mstat==6 | s2mstat==7	//drop if separated or widowed in the 2nd wave
//////////////!!!!!!!!!!!!!drop missing values

drop if r1wthh==0   //drop if weight=0
sort hhid hhidpn
quietly by hhid :  gen dup = cond(_N==1,0,_n)
drop if dup>1


