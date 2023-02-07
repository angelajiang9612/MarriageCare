
*Author: Angela Jiang 
*Input Data: Rand HRS file randhrs1992_2018v2.dta
*Output file: 
*Written on a mac 

*This dofile prepares the rand file for duration model analysis. 
*This counts the total number of remarriages. Display the number of people surveyed, the initial attrition, and the total number of remarriages over the survey years, how many people got remarried. 


clear 

version 17.0

cap log close 

set more off 

set seed 0102



cd "/Users/bubbles/Desktop/MarriageCare/Data/randhrs1992_2018v2_STATA"

log using remarriage.log, text replace 

use randhrs1992_2018v2.dta, clear



//define the cohorts and initial waves 

local HRS 3 
local CODA 2
local WB 4
local EBB 5
local MBB 6 
local LBB 7 

local HRS_init 1 
local CODA_init 4 
local WB_init 4
local EBB_init 7 
local MBB_init 10 
local LBB_init 13


keep if hacohort == `HRS'  //uses the cohorts we are interested in 


//keep if h`HRS_init'pickhh ==1  // keep only one of the household members in the initial wave interviewed. This is more optimal than just randomly picking a spouse, but does not resolve the issue with them dropping out of the sample while their partner stays in the sample. Defined this way it is not possible for smstat to be available when rmstat is not available. 


keep hhidpn hacohort *hhid *famr *finr *mstat *mpart *mrct *mstath *mdiv *iwstat *agey_e inw* *pickhh *mwid //keep only the variables of interest, so that it doesn't become too slow

reshape long  r@mstat r@mpart r@mrct r@mstath r@mdiv r@iwstat r@agey_e r@famr r@finr r@mwid s@famr s@finr s@mstat s@mpart s@mrct s@mstath s@mdiv s@iwstat s@agey_e s@mwid h@hhid h@pickhh inw@, i(hhidpn) j(wave) //reshape from wide to long 

xtset hhidpn wave //set as panel 

//c_marriage adds up all the change in marriage 

by hhidpn (wave), sort: gen c_marriage = F.rmrct - rmrct

bysort hhidpn: egen remar=max(c_marriage) 

replace remar = 0 if missing(remar)

gen remarried=(remar>0)


//Look at proportion of people overall that experienced a remarriage. 


tab remarried if wave==`HRS_init' //This gives the proportion of the initial cohort that experienced an increase in marriage count (this includes cohabitators that got married in later waves)

tab c_marriage, mi 


//Counting the total number of remarriages. Can't just look at anyone that experienced an increase in marriage because we have cohabitation and things. 


keep if hpickhh==1 //keep only 1 person in each household to avoid duplicates in remarriage number count. 

tab c_marriage, mi  //this records the number total number of remarriages I see 

















































































