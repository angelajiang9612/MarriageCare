
*Author: Angela Jiang 
*Input Data: Rand HRS file randhrs1992_2018v2.dta
*Output file: 
*Written on a mac 

*This dofile prepares the rand file for duration model analysis. 
*This counts the total number of cohabitations by adding the cohabitations in each year. 


clear 

version 17.0

cap log close 

set more off 

set seed 0102

set maxvar 20000

cd "/Users/bubbles/Desktop/MarriageCare/Data/randhrs1992_2018v2_STATA"

log using cohabitations.log, text replace 

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

local Ahead_sec 3 
local HRS_sec 2 
local CODA_sec 5 
local WB_sec 5
local EBB_sec 8 
local MBB_sec 11 
local LBB_sec 14

local last 14 



//


keep if hacohort == `LBB'  //uses the cohorts we are interested in 

keep hhidpn hacohort *hhid *famr *finr *mstat *mpart *mrct *mstath *mdiv *iwstat *agey_e inw* *pickhh *mwid //keep only the variables of interest, so that it doesn't become too slow

reshape long  r@mstat r@mpart r@mrct r@mstath r@mdiv r@iwstat r@agey_e r@famr r@finr r@mwid s@famr s@finr s@mstat s@mpart s@mrct s@mstath s@mdiv s@iwstat s@agey_e s@mwid h@hhid h@pickhh inw@, i(hhidpn) j(wave) //reshape from wide to long 

xtset hhidpn wave //set as panel 

//for the initial wave do this 

keep if hpickhh==1 



gen cohabitate = 1 if wave == `LBB_init' & rmstat == 3

forvalues i = `LBB_sec'/`last' {
     replace cohabitate = 1 if wave == `i' & rmstat == 3 & rmstat[_n-1] != 3  //new cohabitations, last period not cohabitating
}


keep if hpickhh==1 


tab cohabitate




/*

original stuff 


gen cohabitate_`Ahead_init' = 1 if wave == `Ahead_init' & rmstat == 3

//for all other waves need to have last wave not partnered and next wave partnered 



forvalues i = `Ahead_sec'/`last' {
     gen cohabitate_`i' = 1 if wave == `i' & rmstat == 3 & rmstat[_n-1] != 3
}


//drop household duplicates to get the number of cohabitations 

keep if hpickhh==1 

forvalues i = `HRS_init'/`last' {
     tab cohabitate_`i'
}


*\



































