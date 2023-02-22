
*Author: Angela Jiang 
*Input Data: Rand HRS file randhrs1992_2018v2.dta
*Output file: 
*Written on a mac 

*This dofile compares long-term care provision outcomes for different types of partnerships, the types of interest are cohabitation, new marriages created after the respondent is 50+, and marriages from earlier periods/first marriages. 


clear 

version 17.0

cap log close 

set more off 

set seed 0102


cd "/Users/bubbles/Desktop/MarriageCare/Data/randhrs1992_2018v2_STATA"

log using clean.log, text replace 

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





























