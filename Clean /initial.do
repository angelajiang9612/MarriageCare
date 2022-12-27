 
use "/Users/bubbles/Desktop/HRS/randhrs1992_2018v2_STATA/randhrs1992_2018v2.dta", clear

// this assumes that we don't have remarriages and then divorce //


//choose one of the below cohorts. 

keep if hacohort==1 & (r2mstat==1 | r2mstat==2 | r2mstat==4) //look at only the initially married people, need to change cohort and starting wave. Ahead mainly starts in 1993, which is wave 2. 


keep if hacohort==2 & (r4mstat==1 | r4mstat==2 |r4mstat==4) // CODA

keep if hacohort==3 & (r1mstat==1 | r1mstat==2 | r1mstat==4) // HRS Main

keep if hacohort==4 & (r4mstat==1 | r4mstat==2| r4mstat==4) // WB

keep if hacohort==5 & (r7mstat==1 | r7mstat==2 | r7mstat==4) //EBB

keep if hacohort==6 & (r10mstat==1 | r10mstat==2 | r10mstat==4) //MBB

keep if hacohort==7 & (r13mstat==1 | r13mstat==2) | r13mstat==4) //LBB


//maximum 6% divorce for MBB/EBB/HRS main group, ever divorced. 

//look at divorced and separated 

gen div_sep_1=1 if (r1mstat==1 | r1mstat==2) & (r2mstat==4 | r2mstat ==5) //married in 1 and divorced or separated in 2 


gen div_sep_111=1 if (r1mstat==1 | r1mstat==2) & (r2mstat==4 | r2mstat ==5) 


gen div_sep_2 =1 if (r2mstat==1 | r2mstat==2) & r3mstat ==6 //
gen div_sep_3 =1 if (r3mstat==1 | r3mstat==2) & (r4mstat ==4 | r4mstat ==5) //

gen div_sep_4 =1 if (r4mstat==1 | r4mstat==2) & (r5mstat ==4 | r5mstat ==5) //

gen div_sep_5 =1 if (r5mstat==1 | r5mstat==2) & (r6mstat ==4 | r6mstat ==5) //

gen div_sep_6 =1 if (r6mstat==1 | r6mstat==2) & (r7mstat ==4 | r7mstat ==5) //

gen div_sep_7 =1 if (r7mstat==1 | r7mstat==2) & (r8mstat ==4 | r8mstat ==5 |r8mstat ==6) //

gen div_sep_8 =1 if (r8mstat==1 | r8mstat==2) & (r9mstat ==4 | r9mstat ==5 | r9mstat ==6) //

gen div_sep_9 =1 if (r9mstat==1 | r9mstat==2) & (r10mstat ==4 | r10mstat ==5 |r10mstat ==6) //

gen div_sep_10 =1 if (r10mstat==1 | r10mstat==2) & (r11mstat ==4 | r11mstat ==5) //

gen div_sep_11 =1 if (r11mstat==1 | r11mstat==2) & (r12mstat ==4 | r12mstat ==5) //married in 2 but divorced/separated in 3
gen div_sep_12 =1 if (r12mstat==1 | r12mstat==2) & (r13mstat ==4 | r13mstat ==5) //married in 2 but divorced/separated in 3

gen div_sep_13 =1 if (r13mstat==1 | r13mstat==2) & (r14mstat ==4 | r14mstat ==5) //married in 2 but divorced/separated in 3

gen div_sep_ever = 1 if div_sep_1==1 |  div_sep_2==1 | div_sep_3==1 | div_sep_4==1 | div_sep_5==1 | div_sep_6==1 |  div_sep_7==1 | div_sep_8==1 | div_sep_9==1 | div_sep_10==1 | div_sep_11==1 | div_sep_12==1 | div_sep_13==1          



//look at divorced only, need to include last period separated people


gen div_1=1 if (r1mstat==1 | r1mstat==2 |r1mstat==4) & (r2mstat ==5) //married in 1 and divorced or separated in 2 

gen div_2 =1 if (r2mstat==1 | r2mstat==2 | r2mstat==4) & r3mstat ==6 //In this year separated are also considered divorced
gen div_3 =1 if (r3mstat==1 | r3mstat==2 | r3mstat==4) & (r4mstat ==5) //

gen div_4 =1 if (r4mstat==1 | r4mstat==2 |r4mstat==4) & (r5mstat ==5) //

gen div_5 =1 if (r5mstat==1 | r5mstat==2 |r5mstat==4) & (r6mstat ==5) //

gen div_6 =1 if (r6mstat==1 | r6mstat==2 |r6mstat==4) & (r7mstat ==5) //

gen div_7 =1 if (r7mstat==1 | r7mstat==2 |r7mstat==4) & (r8mstat ==5) //

gen div_8 =1 if (r8mstat==1 | r8mstat==2 |r8mstat==4) & (r9mstat ==5) //

gen div_9 =1 if (r9mstat==1 | r9mstat==2 |r9mstat==4) & (r10mstat ==5) //

gen div_10 =1 if (r10mstat==1 | r10mstat==2 |r10mstat==4) & (r11mstat ==5) //

gen div_11 =1 if (r11mstat==1 | r11mstat==2 |r11mstat==4) & (r12mstat ==5) //married in 2 but divorced/separated in 3
gen div_12 =1 if (r12mstat==1 | r12mstat==2 |r12mstat==4) & (r13mstat ==5) //married in 2 but divorced/separated in 3

gen div_13 =1 if (r13mstat==1 | r13mstat==2|r13mstat==4) & (r14mstat ==5) //married in 2 but divorced/separated in 3

gen div_ever = 1 if div_1==1 |  div_2==1 | div_3==1 | div_4==1 | div_5==1 | div_6==1 |  div_7==1 | div_8==1 | div_9==1 | div_10==1 | div_11==1 | div_12==1 | div_13==1          

tab div_ever, mi



tab div_sep_ever, mi




//do cumulative number of divorces version too 






