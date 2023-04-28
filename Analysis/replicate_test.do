//Replicate paper-In Sickness and in Health? Physical Illness as a Risk Factor for Marital Dissolution in Later Life
//Yang
//Feb 2023
//This do file run discrete-time survival analysis with competing risk using multinomial logistic model


clear 

version 15.0

cap log close 

set more off 

set seed 0102




cd "/Users/bubbles/Desktop/MarriageCare/Data/randhrs1992_2018v2_STATA"


use randhrs1992_2018v2.dta, clear





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



////////////sample selection
keep if hacohort == `HRS'  //uses the cohorts we are interested in 

keep if r1mstat==1  | r1mstat==2	//keep if married in the first wave

drop if r2mstat==6 | r2mstat==7	//drop if separated or widowed in the 2nd wave

gen reverhad=1 if r1cancre==1 | r1lunge==1 | r1hearte==1 | r1stroke==1	//respondent ever had health prob before the 1st wave
replace reverhad=0 if reverhad!=1
gen severhad=1 if r1cancre==1 | r1lunge==1 | r1hearte==1 | r1stroke==1	//spouse ever had health prob before the 1st wave  *This should saw r 
replace severhad=0 if severhad!=1
keep if reverhad!=1	& severhad!=1



////////////keep variables
keep hhidpn hacohort *hhid *iwstat *mstat *cancr *lung *heart *strok raeduc s1educ raracem s1racem r1mcurln h1atotn r1higov s1higov r1covr s1covr ///
r1covs s1covs r1hiothp s1hiothp r1hiltc s1hiltc r1lifein s1lifein h1afhous h1itot r1agey_e s1agey_e rahispan s1hispan //keep only the variables of interest, so that it doesn't become too slow

////////////prepare dataset
//reshape wide to long
reshape long r@iwstat r@mstat r@cancr r@lung r@heart r@strok s@iwstat s@mstat s@mpart s@cancr s@lung s@heart s@strok, i(hhidpn) j(wave) 
drop if wave>=11
xtset hhidpn wave //set as panel 


//respondent status
gen respondent=0 if riwstat==1 & siwstat==1 
replace respondent=1 if respondent==.
gen redflag=1 if respondent==1
bysort hhidpn (wave): replace redflag=1 if redflag[_n-1]==1 //in future periods also drop 
replace redflag=0 if redflag==.

drop if redflag==1
drop redflag


//This way of doing things dropped all the people who might be widowed or dead, there is no competing risks anymore. 


//dependent variable
gen dead=1 if rmstat==6 //no divorce yet? need to consider how the different outcomes work. 
replace dead=2 if rmstat==7	//this doesn't even exist  
gen redflag=1 if dead!=.  //*should this be ==? 

bysort hhidpn (wave): replace redflag=1 if redflag[_n-1]==1
replace redflag=0 if redflag==.
replace redflag=0 if dead==1 | dead==2
drop if redflag==1
drop redflag
replace dead=0 if dead==.
//choose the functional form for the baseline hazard function
gen wave2=wave^2

///////////gen covariates
//onset of diseases
gen onset=1 if rcancr==1 | scancr==1 | rlung==1 | slung==1 | rheart==1 | sheart==1 | rstrok==1 | sstrok==1
replace onset=0 if onset==.
//baseline covariates
gen rcollege=1 if raeduc>=4
replace rcollege=0 if rcollege==.
gen scollege=1 if s1educ>=4
replace scollege=0 if scollege==.	//education
gen rrace=0 if rahispan==0 & raracem==1
replace rrace=1 if rrace==.
gen srace=0 if s1hispan==0 & s1racem==1
replace srace=1 if srace==.		//race
gen age_diff=r1agey_e-s1agey_e	//age difference
xtile incomec = h1itot, nq(5)	
replace incomec=incomec-1	//quintile of income 
gen assetc=0 if h1atotn<0
replace assetc=1 if h1atotn>=0 & h1atotn<=50000
replace assetc=2 if h1atotn>50000 & h1atotn<100000
replace assetc=3 if h1atotn>=100000 & h1atotn<250000
replace assetc=4 if h1atotn>=250000 	//non-housing asset
gen rinsure_ind=1 if r1higov==1 | r1covr==1 | r1covs==1 | r1hiothp==1 | r1hiltc==1 | r1lifein==1
replace rinsure=0 if rinsure==.
gen sinsure_ind=1 if s1higov==1 | s1covr==1 | s1covs==1 | s1hiothp==1 | s1hiltc==1 | s1lifein==1
replace sinsure=0 if sinsure==.
gen insure=1 if rinsure==1 & sinsure==1 
replace insure=0 if insure==.	//both covered by health insurance


///////////logit model
mlogit dead onset rcollege rrace age_diff incomec assetc insure wave wave2, nolog baseoutcome(0)

