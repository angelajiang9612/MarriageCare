
*Author: Angela Jiang 
*Input Data: Rand HRS file randhrs1992_2018v2.dta
*Output file: 
*Written on a mac 

*This dofile prepares the rand file for duration model analysis. 


clear 

version 17.0

cap log close 

set more off 

set seed 0102



cd "/Users/bubbles/Desktop/MarriageCare/Data/randhrs1992_2018v2_STATA"

log using remarriage.log, text replace 

use randhrs1992_2018v2.dta, clear



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




keep if hacohort == `WB'  //uses the cohorts we are interested in 


keep if h`WB_init'pickhh ==1  // keep only one of the household members in the initial wave interviewed. This is more optimal than just randomly picking a spouse, but does not resolve the issue with them dropping out of the sample while their partner stays in the sample. Defined this way it is not possible for smstat to be available when rmstat is not available. 


keep hhidpn hacohort *hhid *famr *finr *mstat *mpart *mrct *mstath *mdiv *iwstat *agey_e inw* *pickhh *mwid //keep only the variables of interest, so that it doesn't become too slow

reshape long  r@mstat r@mpart r@mrct r@mstath r@mdiv r@iwstat r@agey_e r@famr r@finr r@mwid s@famr s@finr s@mstat s@mpart s@mrct s@mstath s@mdiv s@iwstat s@agey_e s@mwid h@hhid h@pickhh inw@, i(hhidpn) j(wave) //reshape from wide to long 

xtset hhidpn wave //set as panel 

//start with the initially singled people. 

by hhidpn (wave), sort: keep if rmstat[`WB_init']==5 | rmstat[`WB_init']==7 |  rmstat[`WB_init']==8  //singled if divorced, widowed or never married

drop if wave < `WB_init' //no need to have those earlier waves people were not surveyed yet 


//Look at proportion of initially single people who experienced a remarriage 

by hhidpn (wave), sort: gen c_marriage = F.rmrct - rmrct

bysort hhidpn: egen remar=max(c_marriage) 

replace remar = 0 if missing(remar)

gen remarried=(remar>0)


//Look at proportion of people overall that reported having a partner again at some point 



gen partner =1 if rmstat==1 | rmstat==2 | rmstat==3 //this way of doing this underestimates repartnerships because people who have partnerships in between those waves are not recorded. Shorter partnerships are not recorded. 

bysort hhidpn: egen repart=max(partner) 

replace repart = 0 if missing(repart)

gen repartnered=(repart>0)


//ever experienced a cohabitation 

gen cohabitate =1 if rmpart ==1

bysort hhidpn: egen cohab=max(cohabitate) 

replace cohab = 0 if missing(cohab)

gen cohabitated = (cohab>0)


//repartnered but not remarried 

gen part_only =1 if remarried ==0 & repartnered==1
replace part_only =0 if missing(part_only)


///////////Reporting Results///////////////

tab repartnered if wave == `WB_init'
tab remarried if wave == `WB_init'
tab part_only if wave == `WB_init'






































































































































































