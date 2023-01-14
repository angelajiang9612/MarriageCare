 
use "/Users/bubbles/Desktop/HRS/randhrs1992_2018v2_STATA/randhrs1992_2018v2.dta", clear

// this assumes that we don't have remarriages and then divorce //
//this scripts only looks the core hrs group 

//choose one of the below cohorts. 


keep if hacohort==3 // HRS Main, keep those in main HRS cohort 

//look at only one person in each marriage to avoid double counting 

sort h1hhid
quietly by h1hhid:  gen dup = cond(_N==1,0,_n)
drop if dup>1 


keep if (r1mstat==1 | r1mstat==2) //only keep the initially married group of people


/////////////////////////
//look at divorced only//
/////////;/p/;/p////////////////


gen r2mr=1 if (r2mstat==1 | r2mstat==2) //continued to be married 
replace r2mr=2 if r2mstat == 5 //divorced 
replace r2mr=3 if r2mstat == 4 //separated 
replace r2mr=4 if r2mstat == 7 //widowed 
replace r2mr=5 if r2iwstat == 5 //died in current wave 
replace r2mr=6 if (r2iwstat == 4 | r2iwstat == 7) //nr alive or nr dropped from sample 

gen r3mr=1 if (r2mstat==1 | r2mstat==2) //married 
replace  r3mr=2 if r2mstat == 6 //this is the year that doesn't separate divorce with separated, for now assumed all divorced, can clean later 
replace r3mr=4 if r3mstat == 7 //widowed 
replace r3mr=5 if r3iwstat == 5 //died in current wave 
replace r3mr=6 if (r3iwstat == 4 | r3iwstat == 7) //nr alive or nr dropped from sample 
replace r3mr=r2mr if (r2mr==2 | r2mr==4 | r2mr==5) //divorced, widowed, own death are absorbing states for the marriage, override everything else. 

gen r4mr=1 if (r4mstat==1 | r4mstat==2) //continued to be married 
replace r4mr=2 if r4mstat == 5 //divorced 
replace r4mr=3 if r4mstat == 4 //separated 
replace r4mr=4 if r4mstat == 7 //widowed 
replace r4mr=5 if r4iwstat == 5 //died in current wave 
replace r4mr=6 if (r4iwstat == 4 | r4iwstat == 7) //nr alive or nr dropped from sample 
replace r4mr=r3mr if (r3mr==2 | r3mr==4 | r3mr==5) //divorced, widowed, own death are absorbing states for the marriage, override everything else. 
replace r4mr=4 if (r3mr==4 & (r4iwstat == 5| r4mstat==7)) //if there is a death followed by separation the end of marriage should be separate.


gen r5mr=1 if (r5mstat==1 | r5mstat==2) //continued to be married 
replace r5mr=2 if r5mstat == 5 //divorced 
replace r5mr=3 if r5mstat == 4 //separated 
replace r5mr=4 if r5mstat == 7 //widowed 
replace r5mr=5 if r5iwstat == 5 //died in current wave 
replace r5mr=6 if (r5iwstat == 4 | r5iwstat == 7) //nr alive or nr dropped from sample 
replace r5mr=r4mr if (r4mr==2 | r4mr==4 | r4mr==5) //divorced, widowed, own death are absorbing states for the marriage, override everything else. 


gen r6mr=1 if (r6mstat==1 | r6mstat==2) //continued to be married 
replace r6mr=2 if r6mstat == 5 //divorced 
replace r6mr=3 if r6mstat == 4 //separated 
replace r6mr=4 if r6mstat == 7 //widowed 
replace r6mr=5 if r6iwstat == 5 //died in current wave 
replace r6mr=6 if (r6iwstat == 4 | r5iwstat == 7) //nr alive or nr dropped from sample 
replace r6mr=r5mr if (r5mr==2 | r5mr==4 | r5mr==5) //divorced, widowed, own death are absorbing states for the marriage, override everything else. 


gen r7mr=1 if (r7mstat==1 | r7mstat==2) //continued to be married 
replace r7mr=2 if r7mstat == 5 //divorced 
replace r7mr=3 if r7mstat == 4 //separated 
replace r7mr=4 if r7mstat == 7 //widowed 
replace r7mr=5 if r7iwstat == 5 //died in current wave 
replace r7mr=6 if (r7iwstat == 4 | r7iwstat == 7) //nr alive or nr dropped from sample 
replace r7mr=r6mr if (r6mr==2 | r6mr==4 | r6mr==5) //divorced, widowed, own death are absorbing states for the marriage, override everything else. 



gen r8mr=1 if (r8mstat==1 | r8mstat==2) //continued to be married 
replace r8mr=2 if r8mstat == 5 //divorced 
replace r8mr=3 if r8mstat == 4 //separated 
replace r8mr=4 if r8mstat == 7 //widowed 
replace r8mr=5 if r8iwstat == 5 //died in current wave 
replace r8mr=6 if (r8iwstat == 4 | r8iwstat == 7) //nr alive or nr dropped from sample 
replace r8mr=r7mr if (r7mr==2 | r7mr==4 | r7mr==5) //divorced, widowed, own death are absorbing states for the marriage, override everything else. 



gen r9mr=1 if (r9mstat==1 | r9mstat==2) //continued to be married 
replace r9mr=2 if r9mstat == 5 //divorced 
replace r9mr=3 if r9mstat == 4 //separated 
replace r9mr=4 if r9mstat == 7 //widowed 
replace r9mr=5 if r9iwstat == 5 //died in current wave 
replace r9mr=6 if (r9iwstat == 4 | r9iwstat == 7) //nr alive or nr dropped from sample 
replace r9mr=r8mr if (r8mr==2 | r7mr==4 | r7mr==5) //divorced, widowed, own death are absorbing states for the marriage, override everything else. 


gen r10mr=1 if (r10mstat==1 | r10mstat==2) //continued to be married 
replace r10mr=2 if r10mstat == 5 //divorced 
replace r10mr=3 if r10mstat == 4 //separated 
replace r10mr=4 if r10mstat == 7 //widowed 
replace r10mr=5 if r10iwstat == 5 //died in current wave 
replace r10mr=6 if (r10iwstat == 4 | r10iwstat == 7) //nr alive or nr dropped from sample 
replace r10mr=r9mr if (r9mr==2 | r9mr==4 | r9mr==5) //divorced, widowed, own death are absorbing states for the marriage, override everything else. 


gen r11mr=1 if (r11mstat==1 | r11mstat==2) //continued to be married 
replace r11mr=2 if r11mstat == 5 //divorced 
replace r11mr=3 if r11mstat == 4 //separated 
replace r11mr=4 if r11mstat == 7 //widowed 
replace r11mr=5 if r11iwstat == 5 //died in current wave 
replace r11mr=6 if (r11iwstat == 4 | r11iwstat == 7) //nr alive or nr dropped from sample 
replace r11mr=r10mr if (r10mr==2 | r10mr==4 | r10mr==5) //divorced, widowed, own death are absorbing states for the marriage, override everything else. 


gen r12mr=1 if (r12mstat==1 | r12mstat==2) //continued to be married 
replace r12mr=2 if r12mstat == 5 //divorced 
replace r12mr=3 if r12mstat == 4 //separated 
replace r12mr=4 if r12mstat == 7 //widowed 
replace r12mr=5 if r12iwstat == 5 //died in current wave 
replace r12mr=6 if (r12iwstat == 4 | r10iwstat == 7) //nr alive or nr dropped from sample 
replace r12mr=r11mr if (r11mr==2 | r11mr==4 | r11mr==5) //divorced, widowed, own death are absorbing states for the marriage, override everything else. 


gen r13mr=1 if (r13mstat==1 | r13mstat==2) //continued to be married 
replace r13mr=2 if r13mstat == 5 //divorced 
replace r13mr=3 if r13mstat == 4 //separated 
replace r13mr=4 if r13mstat == 7 //widowed 
replace r13mr=5 if r13iwstat == 5 //died in current wave 
replace r13mr=6 if (r13iwstat == 4 | r13iwstat == 7) //nr alive or nr dropped from sample 
replace r13mr=r12mr if (r12mr==2 | r12mr==4 | r12mr==5) //divorced, widowed, own death are absorbing states for the marriage, override everything else. 



gen r14mr=1 if (r14mstat==1 | r14mstat==2) //continued to be married 
replace r14mr=2 if r14mstat == 5 //divorced 
replace r14mr=3 if r14mstat == 4 //separated 
replace r14mr=4 if r14mstat == 7 //widowed 
replace r14mr=5 if r14iwstat == 5 //died in current wave 
replace r14mr=6 if (r14iwstat == 4 | r14iwstat == 7) //nr alive or nr dropped from sample 
replace r14mr=r13mr if (r13mr==2 | r13mr==4 | r13mr==5) //divorced, widowed, own death are absorbing states for the marriage, override everything else. 




//ask about loop 
//for i = 1-14, gen 
//


replace r3mr=


4 if r2mr==4 
replace r3mr=5 if r3mr==4 








-r1mdiv==1




//take out people whose married number increased (don't want the divorce to be for a remarriage, just want to look at the initial intact marriages and see what happens to them 


















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




tab div_sep_ever, mi




//do cumulative number of divorces version too 
