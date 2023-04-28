clear

use "/Users/bubbles/Downloads/dta (1)/unemp.dta"


//generate variable status2 that combines the two censored information types together, along with the two distinct exit forms. 


ge status2 = 0
replace status2 = 1 if status == 2

replace status2 = 2 if status == 3

lab def status2 0 "censored" 1 "Exit-job" 2 "Exit-other" //Does the labelling affect things? The numbers are still there but not displayed. e.g. check label list status2

lab val status2 status2

expand conmths

bysort newid: ge t = _n

ge logt = ln(t)

ta groupreg, ge(reg) //this generated regional dummies by group reg


//single destination censoring vble
by newid: ge leftui = exit == 1 & _n==_N
lab var leftui "1=Exit UI"

// multiple destination censoring vbles

bysort newid (t): ge cex_job = status == 2 & _n == _N if status ~= . //optional for testing binary only consider exit job 

lab var cex_job "1=Exit UI to job"

bysort newid (t): ge cex_oth = status == 3 & _n == _N if status ~= . //optional or testing binary only consider exit others 

lab var cex_oth "1=Exit UI to other dest."


ge deadmnl = 0
bysort newid (t): replace deadmnl = 1 if status2==1 & _n==_N

bysort newid (t): replace deadmnl = 2 if status2==2 & _n==_N

ta deadmnl status2

cloglog leftui age famresp tyentry reg1-reg4 logt, nolog //binary case 

cloglog cex_job age famresp tyentry reg1-reg4 logt, nolog

cloglog cex_oth age famresp tyentry reg1-reg4 logt, nolog


mlogit deadmnl age famresp tyentry reg1-reg4 logt, nolog baseoutcome(0)




















