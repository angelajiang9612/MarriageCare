 
use "/Users/bubbles/Desktop/HRS/randhrs1992_2018v2_STATA/randhrs1992_2018v2.dta", clear

//choose one of the below cohorts. 

keep if hacohort==5 // CHANGE THIS, HRS Main,

gen single_init=1 if r7mstat==5 | r7mstat==7 | r7mstat==8 //CHANGE THIS count as singled if divorced, widowed or never married. Don't include separated 

keep if single_init==1 //only look at the initial singled 

gen r1mr=1 if r2mrct-r1mrct==1 //don't need to change this
gen r2mr=1 if r3mrct-r2mrct==1 
gen r3mr=1 if r4mrct-r3mrct==1 
gen r4mr=1 if r5mrct-r4mrct==1 
gen r5mr=1 if r6mrct-r5mrct==1 
gen r6mr=1 if r7mrct-r6mrct==1 
gen r7mr=1 if r8mrct-r7mrct==1 
gen r8mr=1 if r9mrct-r8mrct==1 
gen r9mr=1 if r10mrct-r9mrct==1 
gen r10mr=1 if r11mrct-r10mrct==1 
gen r11mr=1 if r12mrct-r11mrct==1 
gen r12mr=1 if r13mrct-r12mrct==1 
gen r13mr=1 if r14mrct-r13mrct==1 

foreach v of varlist r1mr-r13mr {
   replace `v' = 0 if missing(`v')
  } //replace by not married in that period if no record of married (including missing)
  
  foreach v of varlist r1mr-r13mr {
   tab `v'
  } 

gen rmr_ever2=0 

foreach v of varlist r1mr-r13mr {
   replace rmr_ever2 = rmr_ever2 + `v' //chcked work 
  } 
 
tab rmr_ever2 //keep a running record of total new marriages 
 
  // //ever remarried , around 8.3/% had a remarriage 


//look at gender, income, health etc 
  
gen mar_par_ever =1 if r2mstat==1 | r2mstat==2 | r2mstat==3 //start with the second period


foreach v of varlist r3mstat-r14mstat {
   replace mar_par_ever = 1 if `v'==1 | `v'==2 | `v'==3
  } 

replace mar_par_ever = 0 if missing(mar_par_ever)  //14.64 percent ever went to a partnership again. 

cls


log close

log using "/Users/bubbles/Desktop/HRS/remarriagehrs.smcl", replace


tab rmr_ever2
tab mar_par_ever


tab rmr_ever2 r17mstat, col //CHANGE THIS
tab mar_par_ever r17mstat, col //CHANGE THIS
 
 
translate  "/Users/bubbles/Desktop/HRS/remarriagehrs.smcl"  "/Users/bubbles/Desktop/HRS/remarriage_6.pdf"




//look at the newly singled 
 
use "/Users/bubbles/Desktop/HRS/randhrs1992_2018v2_STATA/randhrs1992_2018v2.dta", clear

//choose one of the below cohorts. 

keep if hacohort==5 // CHANGE THIS, HRS Main,

//look at the number of newly singled in each wave 
//this is easier with panel form can use lag more easily 


gen single_init=1 if r7mstat==5 | r7mstat==7 | r7mstat==8 

gen single_2=1 if (r8mstat==5 | r8mstat==7 | r8mstat==8) & single_init!=1 //CHANGE THIS count as singled if divorced, widowed or never married. Don't include separated 

gen single_2=1 if (r8mstat==5 | r8mstat==7 | r8mstat==8) & single_init!=1 











