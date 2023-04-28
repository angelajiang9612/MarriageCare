*Author: Angela Jiang 
*Written on a mac 

*This dofile pick from Rand HRS variables that are useful for the summary statistics on informal and formal care by remarriage/cohabitation/singled. It then reshapes the chosen variables to get the final data in long form instead of short form. 
*Only 2002-2018 years are used. 


*Input Data:  randhrs1992_2018v2_STATA (Rand HRS File), wide form data original provided by RAND
*Output files: temp/RAND.dta. Long form data with chosen useful variables. 



clear 

version 17.0

cap log close 

set more off 

set seed 0102

set maxvar 20000

use "$data_path/randhrs1992_2018v2_STATA/randhrs1992_2018v2.dta", clear




////////////Select and keep only the variables of interest, so that STATA doesn't become too slow//////////////////



//General Variables Constant Over Time 

local genvar_c hhidpn hacohort 

//General Variables that Changes Over time 

local genvar r*famr r*finr h*pickhh r*iwstat 



//Other Covariates (Respondent and household) Constant Over Time 

local rcovariates_c ragender raracem raeduc rarelig 
//Other Covariates (Respondent and household) Changes Over Time 

local rcovariates r*agey_b h*atotb h*itot 

//Other Covariates (Spouse)

local scovariates s*agey_b s*gender s*racem s*educ s*relig 



// Marital Status Variables (Respondent)

local rmarital r*mstat r*mpart r*mstath r*mrct r*mnev r*mdiv  r*mwid r*mend r*mcurln r*mlen r*mlenm 

//Marital Status Variables (Spouse)

local smarital s*mstat s*mpart s*mstath s*mrct s*mnev s*mdiv  s*mwid s*mend s*mcurln s*mlen s*mlenm 


//Health and Care Receiving Variables (Respondent)

local rflag r*sadlf /// ADL skip flag due to not having any limitation with lighter disbilities

local rADLraw r*walkr r*dress r*bath r*eat r*bed r*toilt // Raw record of ADLs, includes severity of limitations

local rADLhelp r*walkrh r*dressh r*bathh r*eath r*bedh r*toilth r*walkre r*bede // Gets help with each ADL, and equipment with walking and bed 

local rADLanylim r*walkra r*dressa r*batha r*eata r*beda r*toilta // Binary Recoded Any limittation, includes don't do category 


local rIADLraw r*phone r*money r*meds r*shop r*meals // Raw record of IADLs

local rIALDhelp r*phoneh r*moneyh r*medsh r*shoph r*mealsh // Gets help with each IADL

local rIADLanylim r*phonea r*moneya r*medsa r*shopa r*mealsa // Binary Recoded Any limittation, includes don't do category but don't do is not categorized as 1


local rsum05  r*adl5a r*adl5h r*iadl5a r*iadl5h //total number of ADL/IADL 0-5, and total number of ADL/IADL received help for 0-5

local rhelpamount r*hlprtn r*inhptn r*inhpe r*hlpdyst r*hlphrst //no helpers & n0. helpers ever helped, institution ever helped, days&hours helped

local rhelppaid r*hlppdtn r*hlppdta //number of helpers paid and total amount paid. 


//Health and Care Receiving Variables (Spouse)

local sflag s*sadlf 

local sawADL s*walkr s*dress s*bath s*eat s*bed s*toilt 

local sADLhelp s*walkrh s*dressh s*bathh s*eath s*bedh s*toilth s*walkre s*bede 

local sADLanylim s*walkra s*dressa s*batha s*eata s*beda s*toilta 


local sIADLraw s*phone s*money s*meds s*shop s*meals // Raw record of IADLs

local sIALDhelp s*phoneh s*moneyh s*medsh s*shoph s*mealsh // Gets help with each IADL

local sIADLanylim s*phonea s*moneya s*medsa s*shopa s*mealsa // Binary Recoded Any limittation, includes don't do category 


local ssum05  s*adl5a s*adl5h s*iadl5a s*iadl5h //total number of ADL/IADL 0-5, and total number of ADL/IADL received help for 0-5

local shelpamount s*hlprtn s*inhptn s*inhpe s*hlpdyst s*hlphrst //no, helpers & n0. helpers ever helped, institution ever helped, days&hours helped

local shelppaid s*hlppdtn s*hlppdta //number of helpers paid and total amount paid. 

//Institutionalised/medical help (respondent)

local rnursinghome r*nhmliv //currently lives in a nursing home 


//Institutionalised/medical help (spouse)

local snursinghome s*nhmliv //currently lives in a nursing home 



///////////////Keep Selected Variables//////////////////////////////////////////


keep `genvar_c' `genvar' `rcovariates_c' `rcovariates' `scovariates' `rmarital' `smarital' `rflag' `rADLraw' `rADLhelp' `rADLanylim' `rIADLraw' `rIADLhelp' `rIADLanylim' `rsum05' `rhelpamount' `rhelppaid' `sflag' `sADLraw' `sADLhelp' `sADLanylim' `sIADLraw' `sIADLhelp' `sIADLanylim' `ssum05' `shelpamount' `shelppaid' `rnursinghome' `snursinghome'

drop s*feduc s*meduc 


/////////////////////////////////////////////////////////////////////////////////////
//Replace local variables in  way that allows them to be reshaped easily////////////
//Basically just copy the above instructions to a different note and do find all * and replace with @////////
//////////////////////////////////////////////////////////////////////////////////////



//General Variables Constant Over Time 

local genvar_c hhidpn hacohort 

//General Variables that Changes Over time 

local genvar r@famr r@finr h@pickhh r@iwstat 


//Other Covariates (Respondent and household) Constant Over Time 

local rcovariates_c ragender raracem raeduc rarelig 

//Other Covariates (Respondent and household) Changes Over Time 

local rcovariates r@agey_b h@atotb h@itot 

//Other Covariates (Spouse)

local scovariates s@agey_b s@gender s@racem s@educ s@relig 



// Marital Status Variables (Respondent)

local rmarital r@mstat r@mpart r@mstath r@mrct r@mnev r@mdiv  r@mwid r@mend r@mcurln r@mlen r@mlenm 

//Marital Status Variables (Spouse)

local smarital s@mstat s@mpart s@mstath s@mrct s@mnev s@mdiv  s@mwid s@mend s@mcurln s@mlen s@mlenm 


//Health and Care Receiving Variables (Respondent)

local rflag r@sadlf /// ADL skip flag due to not having any limitation with lighter disbilities

local rADLraw r@walkr r@dress r@bath r@eat r@bed r@toilt // Raw record of ADLs, includes severity of limitations

local rADLhelp r@walkrh r@dressh r@bathh r@eath r@bedh r@toilth r@walkre r@bede // Gets help with each ADL, and equipment with walking and bed 

local rADLanylim r@walkra r@dressa r@batha r@eata r@beda r@toilta // Binary Recoded Any limittation, includes don't do category 


local rIADLraw r@phone r@money r@meds r@shop r@meals // Raw record of IADLs

local rIALDhelp r@phoneh r@moneyh r@medsh r@shoph r@mealsh // Gets help with each IADL

local rIADLanylim r@phonea r@moneya r@medsa r@shopa r@mealsa // Binary Recoded Any limittation, includes don't do category 


local rsum05  r@adl5a r@adl5h r@iadl5a r@iadl5h //total number of ADL/IADL 0-5, and total number of ADL/IADL received help for 0-5

local rhelpamount r@hlprtn r@inhptn r@inhpe r@hlpdyst r@hlphrst //no, helpers & n0. helpers ever helped, institution ever helped, days&hours helped

local rhelppaid r@hlppdtn r@hlppdta //number of helpers paid and total amount paid. 


//Health and Care Receiving Variables (Spouse)

local sflag s@sadlf 

local sawADL s@walkr s@dress s@bath s@eat s@bed s@toilt 

local sADLhelp s@walkrh s@dressh s@bathh s@eath s@bedh s@toilth s@walkre s@bede 

local sADLanylim s@walkra s@dressa s@batha s@eata s@beda s@toilta 


local sIADLraw s@phone s@money s@meds s@shop s@meals // Raw record of IADLs

local sIALDhelp s@phoneh s@moneyh s@medsh s@shoph s@mealsh // Gets help with each IADL

local sIADLanylim s@phonea s@moneya s@medsa s@shopa s@mealsa // Binary Recoded Any limittation, includes don't do category 


local ssum05  s@adl5a s@adl5h s@iadl5a s@iadl5h //total number of ADL/IADL 0-5, and total number of ADL/IADL received help for 0-5

local shelpamount s@hlprtn s@inhptn s@inhpe s@hlpdyst s@hlphrst //no, helpers & n0. helpers ever helped, institution ever helped, days&hours helped

local shelppaid s@hlppdtn s@hlppdta //number of helpers paid and total amount paid. 

//Institutionalised/medical help (respondent)

local rnursinghome r@nhmliv //currently lives in a nursing home 


//Institutionalised/medical help (spouse)

local snursinghome s@nhmliv //currently lives in a nursing home



///////////////////////////////////
//need to exclude the ones that do not change with time the `genvar_c' and `rcovariates_c'
/////////////////////////////////// 


reshape long `genvar' `rcovariates' `scovariates' `rmarital' `smarital' `rflag' `rADLraw' `rADLhelp' `rADLanylim' `rIADLraw' `rIADLhelp' `rIADLanylim' `rsum05' `rhelpamount' `rhelppaid' `sflag' `sADLraw' `sADLhelp' `sADLanylim' `sIADLraw' `sIADLhelp' `sIADLanylim' `ssum05' `shelpamount' `shelppaid' `rnursinghome' `snursinghome', i(hhidpn) j(Wave) //reshape from wide to long 



save "$data_path/temp/RAND.dta", replace 









