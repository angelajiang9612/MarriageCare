*Author: Angela Jiang 
*Input Data: Rand HRS file randhrs1992_2018v2.dta
*Output file:  HRS_combined
*Written on a mac 
clear all
macro drop _all

*This dofile combines all the build files and run everything. 
global folder_path "/Users/bubbles/Desktop/MarriageCare" // <--- Input local path to the folder here. 
////////////////////////////////////////////////////////////////////////////////

global do_path "$folder_path/Dofiles/Build"
cd "$do_path"

do 1.Readin.do
do 2.Pick_and_Rename_Raw_HRS.do
do 3.Pick_and_Reshape_Rand.do
do 4.Combine_and_Merge.do





