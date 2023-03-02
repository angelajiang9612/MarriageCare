
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


keep hhidpn hacohort *hhid *famr *finr *mstat *mpart *mrct *mstath *mdiv *iwstat *agey_e inw* *pickhh *mwid r*inhpe //keep only the variables of interest, so that it doesn't become too slow


local var_temp r@inhpe r@mstat


reshape long `var_temp', i(hhidpn) j(wave) //reshape from wide to long 

reshape long  hhidpn r@inhpe r@mstat r@mpart r@mrct r@mstath r@mdiv r@iwstat r@agey_e r@famr r@finr r@mwid s@famr s@finr s@mstat s@mpart s@mrct s@mstath s@mdiv s@iwstat s@agey_e s@mwid h@hhid h@pickhh inw@, i(hhidpn) j(wave) //reshape from wide to long 
