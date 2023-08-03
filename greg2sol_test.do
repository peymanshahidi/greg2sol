********************************************************************************
** Description:   	Test script for "greg2sol" command using a dataset of
**					 historical IRR to USD exchange rate by "d-learn.ir"
**					   (available at: https://d-learn.ir/p/usd-price)
** By:							     Peyman Shahidi
** Do-file Name:			       "greg2sol_test.do"    
** Version Date:	  	     12 Mordad 1402 - 3 August 2023
********************************************************************************
clear all
graph drop _all
set more off
set scheme s1color


************************ Part 1: Get Required Materials ************************
** install "greg2sol" and copy the test dataset into current working directory
global my_url "https://raw.githubusercontent.com/peymanshahidi/greg2sol/master/"
cap net install greg2sol, from($my_url)
cap net get greg2sol, from($my_url)


****************** Part 2: Gregorian to Solar Hijri Conversion *****************
** Below three examples are given, each displaying use case of one input type

*===============================================================================
** Example 1:
** Gregorian input is a single variable in string format ("year/month/day")
** all three types of output are concurrently generated through a single command
sysuse IRR_USD_histExRate, clear
greg2sol dateGregorian, separate(yearSolar monthSolar daySolar) ///
						string(solarDate_str) ///
						datetime(solarDate_datetime) aesthetic(long)
sort solarDate_datetime

** Solar Hijri labels in datetime-format outputs (e.g., the labels for 
** "solarDate_datetime" generated above) are preserved while plotting graphs
graph twoway line IRR_USD solarDate_datetime, ///
								xlabel(, grid) graphregion(margin(r+6 t+2)) ///
								xlabel(7942 11626 15500 19386 23066, valuelabel)

*===============================================================================
** Example 2:
** Gregorian input is single variable in Stata datetime (%t*) format
** Solar Hijri output is returned in three separate year, month, day variables
sysuse IRR_USD_histExRate, clear
gen dateGregorian_datetime = date(dateGregorian, "YMD")
format dateGregorian_datetime %td
greg2sol dateGregorian_datetime, sep(yearSolar monthSolar daySolar)
sort yearSolar monthSolar daySolar

*===============================================================================
** Example 3:
** Gregorian inputs are three variables provided in year, month, day order
** Solar Hijri output is to be returned under a single string variable
sysuse IRR_USD_histExRate, clear
split dateGregorian, p("-") destring
rename dateGregorian1 gregorianYear
rename dateGregorian2 gregorianMonth
rename dateGregorian3 gregorianDay
greg2sol gregorianYear gregorianMonth gregorianDay, st(solarDate_str)
sort solarDate_str
