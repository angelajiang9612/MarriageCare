//https://medium.com/the-stata-guide/the-stata-to-latex-guide-6e7ed5622856


////////////

//e(stats) : "Sum Mean SD Min Max count" 
//Summarize and tabstat produce Sum vs sum...and the things in cells() are case sensitive so need to use the right case. e.g. SD not sd or Sd..
///////////

clear 

//use summarize rather than tabstat, tabstat is for some reason not walking with estabb

sysuse census, clear
foreach x of varlist pop-popurban death-divorce {
 replace `x' = `x' / 1000
}


summarize pop pop65p medage death marriage divorce

estpost summarize pop pop65p medage death marriage divorce


esttab, cells("sum mean sd min max count")
**The important ones are cells which picks up the names from the e-class variables, so they need to matcg the names in e()


// some options added
esttab, cells("sum mean sd min max count") nonumber nomtitle nonote noobs label
// formatted

esttab, cells("sum(fmt(%6.0fc)) mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count") nonumber ///
   nomtitle nonote noobs label collabels("Sum" "Mean" "SD" "Min" "Max" "N")

cd "/Users/bubbles/Desktop/MarriageCare/Dofiles/Output"
   
esttab using table1.tex, replace ////
cells("sum(fmt(%6.0fc)) mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count") nonumber ///
nomtitle nonote noobs label booktabs ///
collabels("Sum" "Mean" "SD" "Min" "Max" "N")

esttab using table1_title.tex, replace ////
 cells("sum(fmt(%6.0fc)) mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max count")   nonumber ///
  nomtitle nonote noobs label booktabs ///
  collabels("Sum" "Mean" "SD" "Min" "Max" "N")  ///
  title("Table 1 with title generated in Stata \label{table1stata}")
  
  
estpost by region: summarize op pop65p medage death marriage divorce
  
est clear
estpost summarize pop pop65p medage death marriage divorce, by(region) c(stat) stat(mean sd) nototal
  
  
  
  

est clear
estpost tabstat pop pop65p medage death marriage divorce, by(region) c(stat) stat(mean sd) nototal


esttab, main(mean %8.2fc) aux(sd  %8.2fc) nostar nonumber unstack ///
   nonote noobs label ///
   collabels(none) ///
   eqlabels("North East" "North Central" "South" "West") /// 
   nomtitles
  
  
  
  
  
////////////////////
 
 
 

 
clear 
 
sysuse auto


estpost tabstat price mpg rep78, listwise statistics(mean sd) columns(statistics)

esttab, cells("count mean sd min max") noobs

 
 
clear 

sysuse auto

by foreign: eststo: quietly estpost summarize price mpg rep78, listwise

esttab, cells("count mean sd min max") noobs


 
 
clear 

sysuse census, clear
foreach x of varlist pop-popurban death-divorce {
 replace `x' = `x' / 1000
}

tabstat pop pop65p medage death marriage divorce, c(stat) stat(sum mean sd min max n)


est clear 
estpost tabstat pop pop65p medage death marriage divorce, c(stat) stat(sum mean sd min max n)
  
ereturn list 

esttab, cells("Sum Mean SD Min Max count")
  
  
  
  

clear
sysuse auto


estpost tabstat price mpg rep78, listwise statistics(mean sd)

esttab, cells("sum mean sd min max count")
  

  

  
  
  