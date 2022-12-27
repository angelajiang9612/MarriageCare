
//convert wide form to long form
 
use "/Users/bubbles/Desktop/HRS/randhrs1992_2018v2_STATA/randhrs1992_2018v2.dta", clear

sort h10hhid
quietly by h10hhid:  gen dup = cond(_N==1,0,_n)
drop if dup>1 


drop s* //drop the spouse variables 

keep hhidpn h10hhid hacohort *mstat *mpart *mrct *mstath *mdiv *iwstat *agey_e //keep the variables of interest, so that it doesn't become too slow

reshape long r@mstat r@mpart r@mrct r@mstath r@mdiv r@iwstat r@agey_e, i(hhidpn) j(wave)

xtset hhidpn wave

keep if hacohort ==6 //EBB

by hhidpn (wave), sort: keep if rmstat[10]==1 | rmstat[10]==2 //keep the initially married 


////////////////////////////////////////////////////////////////////
//generate rmr variable, which stands for the end status of marriage 
///////////////////////////////////////////////////////////////////
*rmr=1 if married always, rmr=2 if divorced, rmr=3 if separated is the last thing observed, rmr=4 if widowed, rmr=5 if own death is the last thing observed, rmr=6 if married and attrition is the last thing observed. 



by hhidpn (wave), sort: gen rmr =1 if rmstat[_N] ==1| rmstat[_N] ==2 //if married in the last period then marriage ended in still married 

gen temp = (rmstat==5)

bysort hhidpn: egen divorced = max(temp) 

drop temp 


replace rmr = 2 if divorced 

gen temp = (rmstat==3)

bysort hhid: egen separated = max(temp) 

drop temp 

//this section makes sure people who got back together after separation is not coded as marriage ending with separation 

gen married=(rmstat ==1| rmstat ==2)

gen sep_this_period=(rmstat==4)

gen diff=married - sep_this_period

gen m_change = F.diff - diff

bysort hhidpn: egen m_back= max(m_change)

replace separated =0 if m_back==2


/////

replace rmr = 3 if (separated==1 & divorced==0)


///widowed 
gen temp = (rmstat==7)

bysort hhidpn: egen widowed = max(temp) 

drop temp 

replace rmr = 4 if (widowed==1 & divorced==0 & separated==0) //large amount of survey errors seem to exist, might need to check later, e.g. people with widowed then divorced then widowed....

///dead 

gen temp = (riwstat==5 | riwstat==6)

bysort hhidpn: egen died = max(temp) 

drop temp 

replace rmr = 5 if (died==1 & widowed==0 & divorced==0 & separated==0) 

/////

gen temp = (riwstat==7)

bysort hhidpn: egen dropped = max(temp) 

replace rmr = 6 if (dropped==1 & died==0 & widowed==0 & divorced==0 & separated==0) 


//all remaining cases think of as attrition 



replace rmr = 6 if (rmr!=1 & dropped==0 & died==0 & widowed==0 & divorced==0 & separated==0) 

drop if rmr==6 //conditional on observing full history 



egen tag = tag(hhidpn rmr)

egen distinct = total(tag), by(rmr)

tabdisp rmr, c(distinct)

