
*Author: Angela Jiang 
*Input Data: Rand HRS file randhrs1992_2018v2.dta
*Output file: 
*Written on a mac 

*This document produces summary statistics for those who where initially singled. The summary statistics interested in are similar to Brown's cohabitation paper 
*Divide into three groups, always singled, partnered at some point but never remarried, remarried.


clear 

version 17.0

cap log close 

set more off 

set seed 0102



cd "/Users/bubbles/Desktop/MarriageCare/Data/randhrs1992_2018v2_STATA"

log using singled_sum.log, text replace 

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


/* 
R1AGEY_B  // Age
RAGENDER //Gender 
RARACEM //Race 
R1MNEV //Never Married 
R1MDIV //Number of times divorced
R1MWID // Number of times widowed


RAEDUC // Education
RARELIG //Religion 
RwSHLT // Self Reported Health 
RwSTROKE //Ever had a stroke 
R1DRINK //Alcohol Consumption 
R1ADLW //Any diff sum of ADLs 0-5   // RwADL5A in later years
H1ARLES // Net value of real estate (not primary residence)
H1ATOTH // Net value of primary residence 
H1ATOTN // Total Non-Housing Assets--Cross-wave 
H1ATOTB // Total Wealth 
H1ITOT // Total household income (Respondent & spouse) 
RASSRECV // Receives social security 
R1PRPCNT //Number of Private Insurance Plans
R1HILTC //R has Long Term Care Ins
R1LIFEIN //R  has Life Insurance
H1CHILD // Number of living children R/P
R1SAYRET // R considers self retired
R1LIV75 // R Probability to live 75+
R1BEQLRG // R Prob leave sizable bequest // from wave 2 onwards R2BEQ10K R2BEQ10K:W2 R Prob leave bequest 10K+
R1WORK65 // R Prob working FT after 65
R1WORKLM // Prob health limiting work in next 10 years, only asked in the first 6 waves 
R1INLBRF // R is in the labor force
*/ 


keep if hacohort == `HRS'  //uses the cohorts we are interested in 

keep hhidpn hacohort *hhid *famr *finr *mstat *mpart *mrct *mstath *iwstat  inw* *pickhh *agey_e *gender *racem *mnev *mwid *mdiv *aeduc *relig *shlt *stroke *drink *adlw *arles *atoth *atotn *atotb *itot *ssrecv *prpcnt *hiltc *lifein *child *sayret *liv75 *beqlrg *work65 *worklm *nlbrf


reshape long  r@mstat r@mpart r@mrct r@mstath r@mdiv r@iwstat r@agey_e r@famr r@finr r@mwid r@mnev r@shlt r@stroke r@drink r@adlw h@arles h@atoth h@atotn h@atotb h@itot r@prpcnt r@hiltc r@lifein h@child r@sayret r@liv75 r@beqlrg r@work65 r@worklm r@inlbrf s@famr s@finr s@mstat s@mpart s@mrct s@mstath s@mdiv s@iwstat s@agey_e s@mwid h@hhid h@pickhh inw@, i(hhidpn) j(wave) //reshape from wide to long 

xtset hhidpn wave //set as panel 

by hhidpn (wave), sort: keep if rmstat[`HRS_init']==5 | rmstat[`HRS_init']==7 |  rmstat[`HRS_init']==8  //singled if divorced, widowed or never married


//Look at proportion of initially single people who experienced a remarriage 

by hhidpn (wave), sort: gen c_marriage = F.rmrct - rmrct

bysort hhidpn: egen remar=max(c_marriage) 

replace remar = 0 if missing(remar)

gen remarried=(remar>0)


//Look at ever partnered 

gen temp =1 if rmstat==1 | rmstat==1 | rmstat==3

bysort hhidpn: egen repartnered=max(temp) 

//

gen status =1 if remarried ==1
replace status =2 if repartnered==1 & remarried !=1

replace status =3 if missing(status)

//need to think about whether they are missing status because of attrition--we just never see them getting married or forming new partership 

keep if wave == `HRS_init'


//forming the summary statistics 

est clear
estpost tabstat ragey_e ragender, by(status) c(stat) stat(mean sd) nototal
































The following 





















// Variables 



keep if hacohort == `LBB'  //uses the cohorts we are interested in 


keep hhidpn hacohort *hhid *famr *finr *mstat *mpart *mrct *mstath *mdiv *iwstat *agey_e inw* *pickhh *mwid




































