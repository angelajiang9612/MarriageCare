
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

gen limited =1 if radl5a == 1 | radl5a == 2 | radl5a == 3 | radl5a == 4 | radl5a == 5 | riadl5a == 1 | riadl5a == 2 | riadl5a == 3 | riadl5a == 4 | riadl5a == 5

replace limited =0 if missing(limited)


gen s_limited =1 if sadl5a == 1 | sadl5a == 2 | sadl5a == 3 | sadl5a == 4 | sadl5a == 5 | siadl5a == 1 | siadl5a == 2 | siadl5a == 3 | siadl5a == 4 | siadl5a == 5

replace s_limited =0 if missing(s_limited)


///////////////////////

drop if limited ==0 //only keep the ones with limitation 



//Any care at all 

gen any_care =1 if rhlprtn > 0 & rhlprtn!=. & rhlprtn!=.d & rhlprtn!=.j & rhlprtn!=.m & rhlprtn!=.r  

replace any_care = 0 if missing(any_care)



/////////Categorize each helper as an informal helper or formal helper in the way of Katz, Kabeto & Langa////////// 


gen informal_carer =1 if (rhp_r <= 19 & rhp_r >= 1) | (rhp_r <= 28 & rhp_r >=26) | (rhp_r <= 28 & rhp_r >=26) | (rhp_r <= 31 & rhp_r >=30) | (rhp_r <= 91 & rhp_r >= 33) //all relatives are considered informal_care, regardless of whether or not paid

gen formal_carer=1 if rhp_r <= 25 & rhp_r >= 21 //facilities and organisations and professionals are formal, regardless of pay 

replace informal_carer =1 if (rhp_r == 20 | rhp_r == 29 | rhp_r == 32) & rhp_paid == 5 //if in ambiguous category and unpaid, consider to be informal care 

replace formal_carer =1 if (rhp_r == 20 | rhp_r == 29 | rhp_r == 32) & rhp_paid ==1 //if in ambiguous category and paid, consider to be formal care. 



///////Generate Variables for Per Wave have a Carer at all///////

bysort hhidpn wave:  egen any_informal_care = max(informal_carer) // had informal_carer at all

replace any_informal_care=0 if any_informal_care ==. //


bysort hhidpn wave:  egen any_formal_care = max(formal_carer) // had formal_carer at all

replace any_formal_care=0 if any_formal_care ==. // 


///////Generate Hours of Formal and Informal Care//////

replace rhp_hrs = . if rhp_hrs==98 | rhp_hrs==99 | rhp_hrs==-8 //replace out the unknown cases. 
replace rhp_days_inweek = . if rhp_days_inweek==8 | rhp_days_inweek ==9 //
replace rhp_days_inmonth = . if rhp_days_inmonth== 96 | rhp_days_inmonth== 98 | rhp_days_inmonth== 99 | rhp_days_inmonth== -8 
replace rhp_everyday = . if rhp_everyday== 8 | rhp_everyday== 9


//gen some flag that tells which of the three questions to use for the hrsweek

gen flag=1 if rhp_days_inmonth !=. 
replace flag =2 if rhp_days_inweek !=. 
replace flag =3 if rhp_everyday !=. 

//generate hours for each care type. 

gen hp_hrsweek = rhp_days_inmonth*rhp_hrs*0.23013688541 if flag==1  //scale month to week 
replace hp_hrsweek = rhp_days_inweek*rhp_hrs if flag ==2
replace hp_hrsweek = 7*rhp_hrs if flag ==3

bysort hhidpn wave:  egen hours_total = total(hp_hrsweek) // summing over all helpers 

bysort hhidpn wave:  egen informal_hours_total = total(hp_hrsweek) if informal_carer==1 
replace informal_hours_total =0 if missing(informal_hours_total)

bysort hhidpn wave:  egen formal_hours_total = total(hp_hrsweek) if formal_carer==1 

replace formal_hours_total =0 if missing(formal_hours_total)

bysort hhidpn wave:  egen spouse_hours = total(hp_hrsweek) if rhp_r==2



//married, married living alone and unmarried living with others//

//need to add living with others variable 

/////////////////////////////////////////////////////////////


//Spouse and children helping information////

gen spouse =1 if rhp_r==2 //spouse 

bysort hhidpn wave: egen spouse_helped = max(spouse) //if spouse helped in that wave 
replace spouse_helped ==0 if missing(spouse_helped)

gen hp_child =1 if rhp_r<= 8 & rhp_r >=3  //son, daughter, son-in-law, daughter-in-law, step son or step daughter. Ignore grandchildren for now even though they provide a pretty substantial amount of care. 


bysort hhidpn wave: egen children_helped = max(hp_child)
replace children_helped = 0 if missing(children_helped)


bysort hhidpn wave: egen max_helper = max(rhp_r)

bysort hhidpn wave: gen spouse_only if max_helper==2
bysort hhidpn wave: gen child_only if max_helper<= 8 & max_helper>=3



//need to find out why KK paper table 3 three categories add to total using any informalcare at all, since it is possible the informal care is provided by someone else. 


////

duplicates drop hhidpn wave, force //get to the one record each wave format again. 
/////


///Export Summary Statistics////



cd "/Users/bubbles/Desktop/MarriageCare/Dofiles/Output"


est clear

estpost tabstat any_care any_informal_care any_formal_care spouse_helped children_helped hours_total informal_hours_total formal_hours_total, by(ragender) c(stat) stat(mean sd) nototal


esttab, main(Mean %8.2fc) nostar nonumber unstack ///
   nonote noobs label ///
   collabels(none) ///
   eqlabels("Male" "Female") /// 
   nomtitles
   
 
 esttab using "comparison_1.tex", replace ///
  main(Mean %8.2fc) nostar nonumber unstack ///
   nonote noobs label ///
   collabels(none) ///
   eqlabels("Male" "Female") /// 
   nomtitles
   



//spouse_care hours 


by ragender, sort: summarize any_care any_informal_care any_formal_care spouse_helped children_helped  hours_total informal_hours_total formal_hours_total






//Table 1 Gender. 





tab any_care ragender, col

tab any_informal_care ragender, col

tab any_formal_care ragender, col //double check, formal care usage percentage seems too small 


bysort ragender: summarize informal_hours_total if informal_hours_total>0
bysort ragender: summarize formal_hours_total if formal_hours_total >0 

tab spouse_alone ragender, col

tab children_alone ragender, col

tab spouse_children ragender, col



bysort ragender: summarize informal_hours_total if informal_hours_total>0
bysort ragender: summarize formal_hours_total if formal_hours_total >0 



//Table 2 total hours of spousal care//




//Conditioning on married and spouse healthy//























////


sort hhidpn wave

br hhidpn wave limited rhlprtn rhp_r informal_carer formal_carer hp_spouse hp_child any_informal_care any_formal_care spouse_care child_care rhp_hrs rhp_days_inweek hp_hrsweek hours_total informal_hours_total formal_hours_total 

///


















///Display Summary Statistics////


duplicates drop hhidpn wave, force //get to the one record each wave format again. 

tab any_care  if limited==1

tab any_informal_care  if limited==1

tab any_formal_care if limited==1

tab spouse_care if limited==1

tab child_care if limited==1


tab any_care ragender  if limited==1, col

tab any_informal_care ragender if limited==1, col

tab any_formal_care ragender if limited==1, col 

tab spouse_care ragender if limited==1, col 

tab child_care ragender if limited==1, col 


tab spouse_care ragender if limited==1 & s_limited==0, col //conditioning on having a healthy spouse 

tab child_care ragender if limited==1 & s_limited==0, col 


tab spouse_care ragender if limited==1 & s_limited==0 & (hacohort==5 | hacohort==6 | hacohort==7) , col 

tab spouse_care ragender if limited==1 & s_limited==0 & (hacohort!=5 & hacohort!=6 & hacohort!=7) , col 




tab any_care rmstat  if limited==1, col

tab any_informal_care rmstat if limited==1, col

tab any_formal_care rmstat if limited==1, col 

tab spouse_care rmstat if limited==1, col 

tab spouse_care rmstat if limited==1 & s_limited==0, col //conditioning on having a healthy spouse 

tab child_care rmstat if limited==1 & s_limited==0, col 















br hhidpn wave rhlprtn rhp_r hp_hrsweek hours_total informal_hours_total formal_hours_total formal_carer informal_carer limited




br rhp_days_inmonth rhp_days_inweek rhp_everyday 






















































































































































