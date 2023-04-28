
*Author: Angela Jiang 
*Input Data: Rand HRS file randhrs1992_2018v2.dta
*Output file: 
*Written on a mac 

*This dofile compares long-term care provision outcomes for men and women of different cohorts, and by marital status (married, partnered, single)
*Can consider people in the community and people in institutions, but for hours and paid amount this would only be available for those who do not live in institutions. 
*Note that the input data is not in person-wave format, it is in person-wave-helper format, so each person-wave pair is not unique, tabulations without considering this fact does not make sense. 


clear 

version 17.0

cap log close 

set more off 

set seed 0102


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

use "/Users/bubbles/Desktop/MarriageCare/Data/HRS_Cleaned/HRS_combined", clear 

/*
keep if hacohort == `LBB'  //uses the cohorts we are interested in 
*/


sort hhidpn wave 



drop if rnhmliv==1 //dropping those who lives in nursing homes. 


//Has a limitation if has a adl or iadl limitation in that wave, do not consider financial help at the moment 


gen limited=1 if (radl5a>0 & radl5a<.) |  (riadl5a>0 & riadl5a<.) 

replace limited =0 if missing(limited)



gen s_limited=1 if (sadl5a>0 & sadl5a<.) | (siadl5a>0 & siadl5a<.) 

replace s_limited =0 if missing(s_limited)

//total limits

gen limit_total = radl5a + riadl5a


///////////////////////

drop if limited ==0 //only keep the ones with limitation 

///////////////


//Any carer at all 

gen any_care = (rhlprtn > 0 & ! missing(rhlprtn))


/////////Categorize each helper as an informal helper or formal helper in the way of Katz, Kabeto & Langa////////// 


gen informal_carer =1 if (rhp_r <= 19 & rhp_r > 1) | (rhp_r <= 28 & rhp_r >=26)| (rhp_r <= 31 & rhp_r >=30) | (rhp_r <= 91 & rhp_r >= 33) //all relatives are considered informal_care, regardless of whether or not paid

gen formal_carer=1 if rhp_r <= 25 & rhp_r >= 21 //facilities and organisations and professionals are formal, regardless of pay 

replace informal_carer =1 if (rhp_r == 20 | rhp_r == 29 | rhp_r == 32) & rhp_paid == 5 //if in ambiguous category and unpaid, consider to be informal care 

replace formal_carer =1 if (rhp_r == 20 | rhp_r == 29 | rhp_r == 32) & rhp_paid ==1 //if in ambiguous category and paid, consider to be formal care. 


replace informal_carer=0 if missing(informal_carer) & formal_carer==1

replace formal_carer=0 if missing(formal_carer) & informal_carer==1


///////Generate variables for per wave for have a carer at all///////

bysort hhidpn wave:  egen any_informal_care = max(informal_carer) // had informal_carer at all

replace any_informal_care=0 if missing(any_informal_care) //


bysort hhidpn wave:  egen any_formal_care = max(formal_carer) // had formal_carer at all

replace any_formal_care=0 if missing(any_formal_care) //


///////Generate Hours of Formal and Informal Care//////

replace rhp_hrs = . if rhp_hrs==98 | rhp_hrs==99 | rhp_hrs==-8 //replace out the unknown cases. 
replace rhp_days_inweek = . if rhp_days_inweek==8 | rhp_days_inweek ==9 //
replace rhp_days_inmonth = . if rhp_days_inmonth== 96 | rhp_days_inmonth== 98 | rhp_days_inmonth== 99 | rhp_days_inmonth== -8 
replace rhp_everyday = . if rhp_everyday== 8 | rhp_everyday== 9


//gen some flag that tells which of the three questions to use for the hrsweek

gen flag=1 if rhp_days_inmonth !=. 
replace flag =2 if rhp_days_inweek !=. 
replace flag =3 if rhp_everyday !=. 

//generate hours per week for each care type. 

gen hp_hrsweek = rhp_days_inmonth*rhp_hrs*0.23013688541 if flag==1  //scale month to week 
replace hp_hrsweek = rhp_days_inweek*rhp_hrs if flag ==2
replace hp_hrsweek = 7*rhp_hrs if flag ==3

bysort hhidpn wave:  egen hrs_week = total(hp_hrsweek) // summing over all helpers 

bysort hhidpn wave:  egen informal_hrs_week = total(hp_hrsweek) if informal_carer==1 
replace informal_hrs_week =0 if missing(informal_hrs_week)

bysort hhidpn wave:  egen formal_hrs_week = total(hp_hrsweek) if formal_carer==1 

replace formal_hrs_week=0 if missing(formal_hrs_week)

bysort hhidpn wave:  egen spouse_hrs_week = total(hp_hrsweek) if rhp_r==2 //the mean tabulated here is spouse_hrs_week conditioning on spouse providing care. 

//replace spouse_hrs_week=0 if missing(spouse_hrs_week) 

//married, married living alone and unmarried living with others//

//need to add living with others variable 

/////////////////////////////////////////////////////////////


//Spouse and children helping information////

gen spouse =1 if rhp_r==2 //spouse 

bysort hhidpn wave: egen spouse_helped = max(spouse) //if spouse helped in that wave 
replace spouse_helped =0 if missing(spouse_helped)

gen hp_child =1 if rhp_r<= 8 & rhp_r >=3  //son, daughter, son-in-law, daughter-in-law, step son or step daughter. Ignore grandchildren for now even though they provide a pretty substantial amount of care. 


bysort hhidpn wave: egen children_helped = max(hp_child)
replace children_helped = 0 if missing(children_helped)


bysort hhidpn wave: egen max_helper = max(rhp_r)

bysort hhidpn wave: gen spouse_only=1 if max_helper==2
replace spouse_only =0 if missing(spouse_only)  //spouse is carer and the only carer. 


//need to find out why KK paper table 3 three categories add to total using any informalcare at all, since it is possible the informal care is provided by someone else. 


////

duplicates drop hhidpn wave, force //get to the one record each wave format again. 
/////


///Export Summary Statistics////



cd "/Users/bubbles/Desktop/MarriageCare/Dofiles/Output"


///Overall Summary///

est clear

estpost tabstat any_care any_informal_care any_formal_care spouse_helped children_helped spouse_only informal_hrs_week formal_hrs_week spouse_hrs_week, by(ragender) c(stat) stat(mean sd) nototal 



esttab, main(Mean %8.2fc) nostar nonumber unstack ///
   nonote noobs label ///
   collabels(none) ///
   eqlabels("Male" "Female") /// 
   nomtitles
   
   
 
///Conditioning on Married/cohabitating and Spouse Healthy

est clear

estpost tabstat any_care any_informal_care any_formal_care spouse_helped children_helped spouse_only informal_hrs_week formal_hrs_week spouse_hrs_week if (rmstat==1 |rmstat==3) & s_limit ==0, by(ragender) c(stat) stat(mean sd) nototal 

esttab, main(Mean %8.2fc) nostar nonumber unstack ///
   nonote noobs label ///
   collabels(none) ///
   eqlabels("Male" "Female") /// 
   nomtitles
   



/////////////////////
//using new cohorts, post core HRS
////////////////////////



est clear

estpost tabstat any_care any_informal_care any_formal_care spouse_helped children_helped spouse_only informal_hrs_week formal_hrs_week spouse_hrs_week if hacohort>3, by(ragender) c(stat) stat(mean sd) nototal 


esttab, main(Mean %8.2fc) nostar nonumber unstack ///
   nonote noobs label ///
   collabels(none) ///
   eqlabels("Male" "Female") /// 
   nomtitles
   
   
///Conditioning on Married/cohabitating and Spouse Healthy

est clear

estpost tabstat any_care any_informal_care any_formal_care spouse_helped children_helped spouse_only informal_hrs_week formal_hrs_week spouse_hrs_week if (rmstat==1 |rmstat==3) & s_limit ==0 & hacohort >3, by(ragender) c(stat) stat(mean sd) nototal 

esttab, main(Mean %8.2fc) nostar nonumber unstack ///
   nonote noobs label ///
   collabels(none) ///
   eqlabels("Male" "Female") /// 
   nomtitles
   

//Severity of Limitation///


//1-2 

est clear

estpost tabstat any_care any_informal_care any_formal_care spouse_helped children_helped spouse_only informal_hrs_week formal_hrs_week spouse_hrs_week if limit_total <=2, by(ragender) c(stat) stat(mean sd) nototal 



esttab, main(Mean %8.2fc) nostar nonumber unstack ///
   nonote noobs label ///
   collabels(none) ///
   eqlabels("Male" "Female") /// 
   nomtitles
   
   
 
///Conditioning on Married/cohabitating and Spouse Healthy

est clear

estpost tabstat any_care any_informal_care any_formal_care spouse_helped children_helped spouse_only informal_hrs_week formal_hrs_week spouse_hrs_week if (rmstat==1 |rmstat==3) & s_limit ==0 & limit_total <=2, by(ragender) c(stat) stat(mean sd) nototal 

esttab, main(Mean %8.2fc) nostar nonumber unstack ///
   nonote noobs label ///
   collabels(none) ///
   eqlabels("Male" "Female") /// 
   nomtitles
   



//3-5


est clear

estpost tabstat any_care any_informal_care any_formal_care spouse_helped children_helped spouse_only informal_hrs_week formal_hrs_week spouse_hrs_week if limit_total<=5 & limit_total >=3, by(ragender) c(stat) stat(mean sd) nototal 



esttab, main(Mean %8.2fc) nostar nonumber unstack ///
   nonote noobs label ///
   collabels(none) ///
   eqlabels("Male" "Female") /// 
   nomtitles
   
   
 
///Conditioning on Married/cohabitating and Spouse Healthy

est clear

estpost tabstat any_care any_informal_care any_formal_care spouse_helped children_helped spouse_only informal_hrs_week formal_hrs_week spouse_hrs_week if (rmstat==1 |rmstat==3) & s_limit ==0 & limit_total<=5 & limit_total >=3, by(ragender) c(stat) stat(mean sd) nototal 

esttab, main(Mean %8.2fc) nostar nonumber unstack ///
   nonote noobs label ///
   collabels(none) ///
   eqlabels("Male" "Female") /// 
   nomtitles
   

  

//6-10



est clear

estpost tabstat any_care any_informal_care any_formal_care spouse_helped children_helped spouse_only informal_hrs_week formal_hrs_week spouse_hrs_week if limit_total>=6, by(ragender) c(stat) stat(mean sd) nototal 



esttab, main(Mean %8.2fc) nostar nonumber unstack ///
   nonote noobs label ///
   collabels(none) ///
   eqlabels("Male" "Female") /// 
   nomtitles
   
   
 
///Conditioning on Married/cohabitating and Spouse Healthy

est clear

estpost tabstat any_care any_informal_care any_formal_care spouse_helped children_helped spouse_only informal_hrs_week formal_hrs_week spouse_hrs_week if (rmstat==1 |rmstat==3) & s_limit ==0 & limit_total>=6, by(ragender) c(stat) stat(mean sd) nototal 

esttab, main(Mean %8.2fc) nostar nonumber unstack ///
   nonote noobs label ///
   collabels(none) ///
   eqlabels("Male" "Female") /// 
   nomtitles
   

  














































































































































