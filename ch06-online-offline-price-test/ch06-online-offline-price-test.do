***************************************************************
* Billion Prices project
* 
* Checking price distribution
* Hypothesis testing on online-offline price difference
*********************************************************************


*********************************************************************
*cd "" /*set your dir*/
*cd "C:/Users/GB/Dropbox (MTA KRTK)/bekes_kezdi_textbook"
cd "C:/Users/kezdi/Dropbox/bekes_kezdi_textbook"
 
 * YOU WILL NEED TWO SUBDIRECTORIES
 * textbook_work --- all the codes
 * cases_studies_public --- for the data

*location folders
global data_in   	"da_data_repo/billion-prices/clean"
global data_out  	"da_case_studies/ch06-online-offline-price-test"
global output 		"da_case_studies/ch06-online-offline-price-test/output"



clear

use "$data_in/online_offline_ALL_clean.dta",replace

* filter dataset
tab country
keep if country == "USA"
keep if PRICETYPE == "Regular Price"
drop if sale_online == 1
drop if price==.
drop if price_online==.

sum price*,d
drop if price>1000 /* 3 observations with obvious error */
sum price*

* PRICE

gen pd = price_online - price
 lab var pd "Online - offline price difference (USD)"

tabstat pd, s(mean sd min median max n)
count
count if pd==0
count if pd>0
count if pd<0
count if pd>=-1 & pd<=1

*TODO MAKE IN NICER
* Figure 6.1 (a)
hist pd, percent width(5) ///
ylab(0 5 10(10)70, grid) xlab(-400(100)400) lwidth(vthin) fcolor(blue) fintensity(80)
graph export  "$data_out/output/F06_1.png",replace



* Figure 6.1 (b)
hist pd if pd>-5 & pd<5 , width(0.5) percent lcolor(black) lwidth(vthin) fcolor(blue) fintensity(80)
graph export  "$data_out/output/F06_2.png",replace


** HYPOTHESIS
ttest pd = 0 	

** MULTIPLE HYPOTHESES
sort retailer
by retailer: ttest pd = 0 



