//Replicate paper-In Sickness and in Health? Physical Illness as a Risk Factor for Marital Dissolution in Later Life
//Yang
//Feb 2023
//This do file run discrete-time survival analysis with competing risk using multinomial logistic model


clear 

version 15.0

cap log close 

set more off 

set seed 0102

clear matrix

clear mata

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


///covert to long form first///


////////////keep variables
keep hhidpn hacohort *hhid *iwstat *mstat *cancrs *lungs *hearts *stroks r*cancr r*lung r*heart r*strok s*cancr s*lung s*heart s*strok raeduc s*educ raracem s*racem r*mcurln h*atotn r*higov s*higov r*covr s*covr ///
r*covs s*covs r*hiothp s*hiothp r*hiltc s*hiltc r*lifein s*lifein h*afhous h*itot r*agey_b s*agey_b rahispan s*hispan r*wthh ragender s*gender r*mrct s*mrct r*prpcnt s1prpcnt *cancre  *lunge *hearte *stroke  r*cancrf *agey_e *wthh /// 




//keep only the variables of interest, so that it doesn't become too slow


////////////prepare dataset
//reshape wide to long
reshape long r@iwstat r@mstat  r@cancrs r@lungs r@hearts r@stroks r@cancre r@lunge r@hearte r@cancrf r@stroke s@iwstat s@mstat  s@cancrs s@lungs s@hearts s@stroks s@cancre s@lunge s@hearte s@stroke r@agey_b s@agey_b r@wthh, i(hhidpn) j(wave) 
//drop if wave>=11
xtset hhidpn wave //set as panel 

keep if hacohort==3  //uses the cohorts we are interested in 
keep if (ragey_b[1]>=51 & ragey_b[1]<=61) | (sagey_b[1]>=51 & sagey_b[1]<=61)	//At least one spouse is between 51 to 61


keep if rmstat[1]==1 | rmstat[2]==2  & (smstat[1]==1  | smstat[2]==2 )	//keep if married in the first wave

gen reverhad=1 if rcancre[1]==1 | rlunge[1]==1 | rhearte[1]==1 | rstroke[1]==1	//respondent ever had health prob before the 1st wave
replace reverhad=0 if reverhad==.
gen severhad=1 if scancre[1]==1 | slunge[1]==1 | shearte[1]==1 | sstroke[1]==1	//spouse ever had health prob before the 1st wave
replace severhad=0 if severhad==.
keep if reverhad!=1	& severhad!=1


drop if riwstat[2]==5 | siwstat[2]==5   //drop if dead in wave two
drop if rmstat[2]==4 | rmstat[2]==5| rmstat[2]==6 | rmstat[2]==7 |  smstat[2]==4 | smstat[2]==5| smstat[2]==6 | smstat[2]==7	//drop if separated or widowed in the 2nd wave
//////////////!!!!!!!!!!!!!drop missing values

drop if rwthh[1]==0   //drop if weight=0


sort hhid hhidpn
quietly by hhid :  gen dup = cond(_N==1,0,_n)
drop if dup>1
















