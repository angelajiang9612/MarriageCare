*Author: Angela Jiang 
*Input Data: Rand HRS file randhrs1992_2018v2.dta
*Output file: 
*Written on a mac 

*This dofile combines all the build files and run everything. 


cd "/Users/bubbles/Desktop/MarriageCare/Dofiles/Build/"
do 1.Readin.do
do 2.Pick_and_Rename_Raw_HRS.do
do 3.Pick_and_Reshape_Rand.do

cd "/Users/bubbles/Desktop/MarriageCare/Dofiles/Build/" //for some reason the directory changed to home directory after running the last file. 
do 4.Combine_and_Merge.do





