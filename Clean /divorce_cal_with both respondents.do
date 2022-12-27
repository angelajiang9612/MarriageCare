
//convert wide form to long form
//this is just an example 
 
clear 

use "/Users/bubbles/Desktop/HRS/randhrs1992_2018v2_STATA/randhrs1992_2018v2.dta", clear


keep hhidpn *hhid hacohort *mstat *mpart *mrct *mstath *mdiv *iwstat *agey_e //keep the variables of interest, so that it doesn't become too slow


reshape long  r@mstat r@mpart r@mrct r@mstath r@mdiv r@iwstat r@agey_e s@mstat s@mpart s@mrct s@mstath s@mdiv s@iwstat s@agey_e h@hhid, i(hhidpn) j(wave)

xtset hhidpn wave

keep if hacohort ==5 //CHANGE THIS to cohort


by hhidpn (wave), sort: keep if rmstat[7]==1 | rmstat[7]==2 //CHANGE THIS for initial cohort starting point. Keep initially married. cohort 3 with wave 1, cohort 5 with wave 7, cohort 6 with wave 10.

drop if wave <7 //no need to have those earlier waves people were not surveyed yet 



////////////////////////////////////////////////////////////////////
//generate rmr variable, which stands for the end status of marriage 
///////////////////////////////////////////////////////////////////
*rmr=1 if married always, rmr=2 if divorced, rmr=3 if separated is the last thing observed, rmr=4 if widowed, rmr=5 if own death is the last thing observed, rmr=6 if married and attrition is the last thing observed. 
*slightly underestimates divorce/separated because wave 3 not used. 


by hhidpn (wave), sort: gen rmr =1 if rmstat[_N] ==1| rmstat[_N] ==2 //if married in the last period then marriage ended in still married, but this can be replaced later 


//divorced//

gen temp = (rmstat==5)

bysort hhidpn: egen divorced = max(temp) 

drop temp 


replace rmr = 2 if divorced //if ever divorced, then considered to be divorced. This overrides the still married in the last wave and takes into consideration remarriage . 



//separated//

gen temp = (rmstat==4) //separated 

bysort hhid: egen separated = max(temp) //this is ever separated 

drop temp 

//this section makes sure people who got back together after separation is not coded as marriage ending with separation, a bit rough (doesn't have separated, together then seprated again unless last period is separated but should generally work')

gen married=(rmstat ==1| rmstat ==2)

gen sep_this_period=(rmstat==4)

gen diff=married - sep_this_period //

gen m_change = F.diff - diff

bysort hhidpn: egen m_back= max(m_change) //a move back 

replace separated =0 if m_back==2 


/////

replace rmr = 3 if (separated==1 & divorced==0) //if ever separated but didn't get back together or divorce then categorize as separated 

by hhidpn (wave), sort: replace rmr =3 if rmstat[_N] ==4  //if end with separation then separated. 


///widowed 
gen temp = (rmstat==7)

bysort hhidpn: egen widowed = max(temp) 

drop temp 

replace rmr = 4 if (widowed==1 & divorced==0 & separated==0) //replace by widowed if didn't end in divorced or separated. large amount of survey errors seem to exist, might need to check later, e.g. people with widowed then divorced then widowed....

///dead 

gen temp = (riwstat==5 | riwstat==6) //dead already in that particular wave (can be current period or in the past)

bysort hhidpn: egen died = max(temp) 

drop temp 

replace rmr = 5 if (died==1 & widowed==0 & divorced==0 & separated==0) //if ever died without having experienced any of these other things then marriage ended in death 

/////

gen temp = (riwstat==7)

bysort hhidpn: egen dropped = max(temp) 

replace rmr = 6 if (dropped==1 & died==0 & widowed==0 & divorced==0 & separated==0) //if person is dropped before they have an occurence of other ways of ending marriage then they are considered to have marriage ended in attrition



//all remaining cases when rmrm is unknow by known think of as attrition 

replace rmr = 6 if (rmr!=1 & dropped==0 & died==0 & widowed==0 & divorced==0 & separated==0) 


egen tag = tag(hhidpn rmr)

egen distinct = total(tag), by(rmr)

tabdisp rmr, c(distinct)

drop tag 
drop distinct

//this one is taken into account attrition 

drop if rmr==6


//label 


label define rmr_label 1 "married" 2 "divorced" 3 "separated" 4 "widowed" 5 "died"

label values rmr rmr_label 



////////display distinct id/////

//dropping the ones with attrition

tabulate rmr //the proportions are the same unique or not because all 14 waves are included. 

egen tag = tag(hhidpn rmr)

egen distinct = total(tag), by(rmr)

tabdisp rmr, c(distinct)



//check why widowed less than dead. 














































