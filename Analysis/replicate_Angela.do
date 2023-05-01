//Replicate paper-In Sickness and in Health? Physical Illness as a Risk Factor for Marital Dissolution in Later Life
//Yang
//Edited by Angela
//April 2023
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

use "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Raw/data/RAND_msatisfaction.dta", clear


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

//count 9555 people 


//count 4950 marriages 
//for us the number of people is not exactly half the amount of marriages (unlike them), it is more than half. Maybe keep if r is married and has spouse, and delete duplicates. 


gen reverhad=1 if r1cancre==1 | r1lunge==1 | r1hearte==1 | r1stroke==1	//respondent ever had health prob before the 1st wave
replace reverhad=0 if reverhad==.
gen severhad=1 if s1cancre==1 | s1lunge==1 | s1hearte==1 | s1stroke==1	//spouse ever had health prob before the 1st wave
replace severhad=0 if severhad==.
keep if reverhad!=1	& severhad!=1

//count 3373 marriages 

drop if r2iwstat==5 | s2iwstat==5   //drop if dead
drop if r2mstat==4 | r2mstat==5| r2mstat==6 | r2mstat==7 |  s2mstat==4 | s2mstat==5| s2mstat==6 | s2mstat==7	//drop if separated or widowed in the 2nd wave
//////////////!!!!!!!!!!!!!drop missing values

//count 3298

drop if r1wthh==0   //drop if weight=0


//count 3284 


sort hhid hhidpn
quietly by hhid :  gen dup = cond(_N==1,0,_n)
drop if dup>1


//we always have a bit more than in their data. 


////////////keep variables
keep hhidpn hacohort *hhid *iwstat *mstat *cancrs *lungs *hearts *stroks r1cancr r1lung r1heart r1strok s1cancr s1lung s1heart s1strok raeduc s1educ raracem s1racem r1mcurln h1atotn r1higov s1higov r1covr s1covr h1afhous r1msatis s1msatis ///
r1covs s1covs r1hiothp s1hiothp r1hiltc s1hiltc r1lifein s1lifein h1afhous h1itot r1agey_b s1agey_b rahispan s1hispan r1wthh ragender s1gender r1mrct s1mrct r1prpcnt s1prpcnt *cancre  *lunge *hearte *stroke  r*cancrf ///

//keep only the variables of interest, so that it doesn't become too slow


////////////prepare dataset
//reshape wide to long
reshape long r@iwstat r@mstat  r@cancrs r@lungs r@hearts r@stroks r@cancre r@lunge r@hearte r@cancrf r@stroke s@iwstat s@mstat  s@cancrs s@lungs s@hearts s@stroks s@cancre s@lunge s@hearte s@stroke , i(hhidpn) j(wave) 

drop if wave>=11 //our wave years not currently comparible because we have not dropped waves withing missing covariates yet. 

xtset hhidpn wave //set as panel 



//drop if riwstat!=1	//drop people who died

//onset of diseases
bysort hhidpn (wave): replace rcancrs=0 if _n==1 //missing are replaced as zero, why are so many missings in wave 1? 
bysort hhidpn (wave): replace scancrs=0 if _n==1
bysort hhidpn (wave): replace rlungs=0 if _n==1
bysort hhidpn (wave): replace slungs=0 if _n==1
bysort hhidpn (wave): replace rhearts=0 if _n==1
bysort hhidpn (wave): replace shearts=0 if _n==1
bysort hhidpn (wave): replace rstroks=0 if _n==1
bysort hhidpn (wave): replace sstroks=0 if _n==1


//wife illness onset
gen wonset=1 if ((rcancrs==1 |  rlungs==1 |  rhearts==1 |  rstroks==1) & ragender==2) | ((scancrs==1 |  slungs==1 |  shearts==1 |  sstroks==1) & s1gender==2)
replace wonset=0 if wonset==. 
replace wonset=. if ((rcancrs==. |  rlungs==. |  rhearts==. |  rstroks==.) & ragender==2) | ((scancrs==. |  slungs==. |  shearts==. |  sstroks==.) & s1gender==2)
//lag onset
bysort hhidpn (wave): gen wlagonset=wonset[_n-1]
bysort hhidpn (wave): replace wlagonset=0 if _n==1
//husband illness onset

gen honset=1 if ((rcancrs==1 |  rlungs==1 |  rhearts==1 |  rstroks==1) & ragender==1) | ((scancrs==1 |  slungs==1 |  shearts==1 |  sstroks==1) & s1gender==1)
replace honset=0 if honset==.
replace honset=. if ((rcancrs==. |  rlungs==. |  rhearts==. |  rstroks==.) & ragender==1) | ((scancrs==. |  slungs==. |  shearts==. |  sstroks==.) & s1gender==1)
bysort hhidpn (wave): gen hlagonset=honset[_n-1]
bysort hhidpn (wave): replace hlagonset=0 if _n==1


//once onset always onset 

bysort hhidpn (wave): replace hlagonset=1 if hlagonset[_n-1] ==1 
bysort hhidpn (wave): replace wlagonset=1 if wlagonset[_n-1] ==1 



//dependent variable
gen dead=1 if rmstat==4 | rmstat==5 | rmstat==6 //separated
replace dead=2 if rmstat==7	// widowed
replace dead=2 if (remstat==1 | remstat==2) & riwstat==5	//own death 
bysort hhidpn (wave): replace dead=dead[_n-1] if dead[_n-1]!=.
bysort hhidpn (wave): drop if dead[_n-1]!=. & dead[_n]!=. //this drops periods after the thing changes to a number 

gen flag=1 if (riwstat!=1 | siwstat!=1) & dead==.  //if either of spouses dead or not responsive and dropped from sample create flag from that wave onwards. However some of these should be treated as censored rather than dropped. This should be alright if only the missing waves are dropped, so that dead is still 0 and the waves without missing info remains 
bysort hhidpn (wave): replace flag=flag[_n-1] if flag[_n-1]==1
drop if flag==1 //drop waves dead or non-responsive    ///this drop is big 8300, probably indicates attrition. 
replace dead=0 if dead==. //the rest should have marriage intact




//respondent status
gen respondent=1 if riwstat==1 & siwstat==1 //why do we need this
replace respondent=0 if respondent==.
//bysort hhidpn (wave): drop if respondent[_n]==0 & rmstat<=3

//choose the functional form for the baseline hazard function
gen wave2=wave^2

///////////gen covariates

//baseline covariates


//husband and wife's age 

gen h1age=r1agey if ragender==1
replace h1age=s1agey if s1gender==1 
gen w1age=r1agey if ragender==2
replace w1age=s1agey if s1gender==2 


gen rcollege=1 if raeduc==4 | raeduc==5
replace rcollege=0 if rcollege==.  //potential issue with missing variables
gen scollege=1 if s1educ==4 | s1educ==5 
replace scollege=0 if scollege==.	//education


//convert to husband and wife education
gen hcollege =1 if (rcollege==1 & ragender==1) | (scollege==1 & s1gender==1)
replace hcollege =0 if hcollege==.
gen wcollege =1 if (rcollege==1 & ragender==2) | (scollege==1 & s1gender==2)
replace wcollege =0 if wcollege==.


gen rrace=0 if rahispan==0 & raracem==1
replace rrace=1 if rrace==. //probably should control for missing 
gen srace=0 if s1hispan==0 & s1racem==1
replace srace=1 if srace==.	

//convert to husband race 
gen hrace =rrace if ragender==1
replace hrace=srace if ragender==2


gen mduration=1 if r1mcurln<10
replace mduration=0 if r1mcurln>=10	//marital duration

gen age_difft=r1agey_b-s1agey_b	if ragender==1 //age difference:hus-wife
replace age_difft=s1agey_b-r1agey_b	if ragender==2
gen age_diff=1 if age_difft<=-11
replace age_diff=2 if age_difft<=-5 & age_difft>=-10
replace age_diff=3 if age_difft<=-3 & age_difft>=-4
replace age_diff=4 if age_difft<=2 & age_difft>=-2	//base
replace age_diff=5 if age_difft>=3 & age_difft<=4
replace age_diff=6 if age_difft<=10 & age_difft>=5
replace age_diff=7 if age_difft>=11



gen remar=1 if r1mrct>1 | s1mrct>1
replace remar=0 if remar==.  //remarriage

xtile incomec = h1itot, nq(5)	
replace incomec=incomec-1	//quintile of income 

gen assetc=0 if h1atotn<0
replace assetc=1 if h1atotn>=0 & h1atotn<=50000	//base
replace assetc=2 if h1atotn>50000 & h1atotn<100000	
replace assetc=3 if h1atotn>=100000 & h1atotn<250000
replace assetc=4 if h1atotn>=250000 	//non-housing asset

//whether covered by insurance
gen r1pinsure=1 if r1prpcnt>0 //private insurance 
replace r1pinsure=0 if r1prpcnt==0
gen s1pinsure=1 if s1prpcnt>0
replace s1pinsure=0 if s1prpcnt==0
gen rinsure_ind=1 if r1higov==1 | r1pinsure==1 | r1covr==1 | r1covs==1 | r1hiothp==1 | r1hiltc==1 | r1lifein==1 //couldn't find in the article types of insuranc
replace rinsure=0 if rinsure==. //could have some issues, implies if missing then no insurance, could just be missing insurance section. 
gen sinsure_ind=1 if s1higov==1 | s1pinsure==1 | s1covr==1 | s1covs==1 | s1hiothp==1 | s1hiltc==1 | s1lifein==1
replace sinsure=0 if sinsure==.
//gen insure=1 if rinsure==1 & sinsure==1 
//replace insure=0 if insure==.	//both covered by health insurance


//changed to husband and wife 

gen hinsure =1 if (rinsure==1 & ragender==1) | (sinsure==1 & s1gender==1)
replace hinsure =0 if hinsure==. 
gen winsure =1 if (rinsure==1 & ragender==2) | (sinsure==1 & s1gender==2)
replace winsure =0 if winsure==. 


//Home Ownership 

gen hownhome=0 if h1afhous==6 //assuming no asset means not home owners 
replace hownhome=1 if missing(hownhome)


//Marital satisfaction 

gen wmsatis = r1msatis if ragender==2 
replace wmsatis=s1msatis if ragender==1
drop if missing(wmsatis) //drop if wife's satisfaction is missing. 
drop if wmsatis==6 //a few observations claim they are not married. 



mlogit dead wave wave2 hlagonset wlagonset h1age w1age hcollege hrace ib1.wmsatis remar mduration hinsure winsure ib0.incomec ib1.assetc hownhome ib4.age_diff [pweight=r1wthh], nolog baseoutcome(0)



//results seem worse??/////





