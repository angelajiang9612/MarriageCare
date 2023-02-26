
*Author: Angela Jiang 
*Input Data: Rand HRS file randhrs1992_2018v2.dta
*Output file: 
*Written on a mac 

*This dofile calculates the number of divorces in the HRS for different cohorts 
*Need to change macros for different cohorts. 


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

//The Ahead, CODA and LBB groups generally not used for this analysis. 

keep if hacohort == `LBB'  //uses the cohorts we are interested in 


keep if h`LBB_init'pickhh ==1  // keep only one of the household members in the initial wave interviewed. This is more optimal than just randomly picking a spouse, but does not resolve the issue with them dropping out of the sample while their partner stays in the sample. Defined this way it is not possible for smstat to be available when rmstat is not available. 


keep hhidpn hacohort *hhid *famr *finr *mstat *mpart *mrct *mstath *mdiv *iwstat *agey_e inw* *pickhh *mwid //keep only the variables of interest, so that it doesn't become too slow

reshape long  r@mstat r@mpart r@mrct r@mstath r@mdiv r@iwstat r@agey_e r@famr r@finr r@mwid s@famr s@finr s@mstat s@mpart s@mrct s@mstath s@mdiv s@iwstat s@agey_e s@mwid h@hhid h@pickhh inw@, i(hhidpn) j(wave) //reshape from wide to long 

xtset hhidpn wave //set as panel 


by hhidpn (wave), sort: keep if rmstat[`LBB_init']==1 | rmstat[`LBB_init']==2 //CHANGE THIS for initial cohort starting point. Keep initially married.

drop if wave < `LBB_init' //no need to have those earlier waves people were not surveyed yet 


////////////////////////////////////////////////////////////////////
//generate rmr variable, which stands for the end status of marriage 
///////////////////////////////////////////////////////////////////
*rmr=1 if married always, rmr=2 if divorced, rmr=3 if separated is the last thing observed, rmr=4 if widowed, rmr=5 if own death is the last thing observed, rmr=6 if married and attrition is the last thing observed. 
*slightly underestimates divorce/separated because wave 3 not used. 


by hhidpn (wave), sort: gen rmr =1 if rmstat[_N] ==1| rmstat[_N] ==2 //if married in the last period then marriage ended in still married, but this can be replaced later 


//divorced//



//Use increase in the number of divorces for the person or their spouse. 


by hhidpn (wave), sort: gen change_in_div = F.rmdiv - rmdiv

bysort hhidpn: egen div_in_sample= max(change_in_div) //a move back 

replace div_in_sample = 0 if missing(div_in_sample)

gen divorced =1 if div_in_sample>0 //max() ignores missing values. Only when all arguments supplied are missing does it show its own limited version of despair and return a missing value. Therefore this method doesn't work (if a person is observed only once they will considered divorce because change_in_div is always missing)


//If your spouse experienced a divorce you also experienced an divorce (but can it be that s_div increased just because you now have a difference spouse? but in that case it means your spouse changed so you got a divorce anyway)

by hhidpn (wave), sort: gen s_change_in_div = F.smdiv - smdiv

bysort hhidpn: egen s_div_in_sample= max(s_change_in_div) //a move back 

replace s_div_in_sample = 0 if missing(s_div_in_sample)

replace divorced =1 if s_div_in_sample>0 


//In some rare cases person reported a divorce but their own and their spouse's divorce count did not increase. 

gen temp = (rmstat==5)

bysort hhidpn: egen divorced_reported = max(temp) 

drop temp 

replace divorced = 1 if divorced_reported  //if ever divorced, then considered to be divorced. This overrides the still married in the last wave and takes into consideration remarriage . 

replace rmr = 2 if divorced ==1



//separated//

gen temp = (rmstat==4) //separated 

bysort hhid: egen separated = max(temp) //this is ever separated 

drop temp 

//this section makes sure people who got back together after separation is not coded as marriage ending with separation, a bit rough (doesn't have separated, together then seprated again unless last period is separated but should generally work'). But they could be married again but to a different person. This would be taken care of by divorce count in the previous period. 

gen married=(rmstat ==1| rmstat ==2)

gen sep_this_period=(rmstat==4)

gen diff=married - sep_this_period //

by hhidpn (wave), sort: gen m_change = F.diff - diff

bysort hhidpn: egen m_back= max(m_change) //a move back 

replace separated =0 if m_back==2 




/////

replace rmr = 3 if (separated==1 & divorced!=1) //if ever separated but didn't get back together or divorce then categorize as separated 

by hhidpn (wave), sort: replace rmr =3 if rmstat[_N] ==4 & divorced!=1 //if end with separation then separated. Not sure how to do last observable period. 



///widowed 


by hhidpn (wave), sort: gen change_in_wid = F.rmwid - rmwid

bysort hhidpn: egen wid_in_sample= max(change_in_wid)

gen widowed=1 if wid_in_sample > 0 & !missing(wid_in_sample)



gen temp = (rmstat==7)

bysort hhidpn: egen widowed_reported = max(temp) 

drop temp 

replace widowed = 1 if widowed_reported ==1


replace rmr = 4 if (widowed==1 & divorced!=1 & separated!=1) //replace by widowed if didn't end in divorced or separated. large amount of survey errors seem to exist, might need to check later, e.g. people with widowed then divorced then widowed....if separated and widowed then the marriage ended in separation. 



///dead 

gen temp = (riwstat==5 | riwstat==6) //dead already in that particular wave (can be current period or in the past)

bysort hhidpn: egen died = max(temp) 

drop temp 

replace rmr = 5 if (died==1 & widowed!=1 & divorced!=1 & separated!=1) //if ever died without having experienced any of these other things then marriage ended in death 



//Don't do the spouse thing, technically spouse widowed number can increase when someone change spouse without them dying. 



gen temp = (riwstat==7)

bysort hhidpn: egen dropped = max(temp) 

replace rmr = 6 if (dropped==1 & died!=1 & widowed!=1 & divorced!=1 & separated!=1) //if person is dropped before they have an occurence of other ways of ending marriage then they are considered to have marriage ended in attrition



//all remaining cases when rmrm is unknow by known think of as attrition 

replace rmr = 6 if missing(rmr) //rmr==6 just means we do not know the status of this marriage in 2018 (we could still know it in 2016)


label values rmr rmr_label 
label define rmr_label 1 "married" 2 "divorced" 3 "separated" 4 "widowed" 5 "died"  6 "unknown"



egen tag = tag(hhidpn rmr)

egen distinct = total(tag), by(rmr)

tabdisp rmr, c(distinct)




//exporting out 

est clear 
cd "/Users/bubbles/Desktop/MarriageCare/Dofiles/Output"

   
estpost tab rmr if wave== `LBB_init' 

esttab, cell("b pct(fmt(a))")  collab("Freq." "Percent") noobs nonumb nomtitle


esttab using MBB_Init_Divorce.tex, replace ///
cell("b pct(fmt(a))")  collab("Freq." "Percent") noobs nonumb nomtitle ///
title(HRS Cohort Marriage Outcomes -2018)  /// 
addnote(The HRS cohort was born 1948-53) //
label booktabs ///









//with attrition taken out 


drop if rmr==6
tabdisp rmr, c(distinct)


//display as table and then ouput 
 
 
drop tag 
drop distinct































