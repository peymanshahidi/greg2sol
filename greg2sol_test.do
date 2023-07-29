********************************************************************************
** Description:   	Test script for "greg2sol" command using a dataset of
**					 historical IRR to USD exchange rate by "d-learn.ir"
**					   (available at: https://d-learn.ir/p/usd-price)
** By:							     Peyman Shahidi
** Do-file Name:			       "greg2sol_test.do"    
** Version Date:	  	      8 Mordad 1402 - 30 July 2023
********************************************************************************
clear all
graph drop _all
set more off
set scheme s1color
cap program drop greg2sol

** set working direcotry to the "greg2sol" folder path on your machine
global root "path_to/greg2sol"
cd "${root}"

** define data path
global df_path "https://raw.githubusercontent.com/peymanshahidi/greg2sol/master"


********************** Gregorian to Solar Hijri conversion *********************
** The "greg2sol" command accommodates three different types of Gregorian date
** inputs and generates up to three different types of Solar Hijri date outputs.
**
** Types of Gregorian date input(s):
** 1. a string variable in "year/month/day" format (e.g., "2011/8/23")
** 2. a Stata datetime variable in %t* format (e.g., 23aug2011 with value 18862)
** 3. three separate variables; one for each of year, month, day (in this order)
**
** Types of Solar Hijri date output(s):
** 1. a string variable in "year/month/day" format (e.g., "1390/06/01")
** 2. a Stata datetime variable in %td format (e.g., 01sha1390 with value 18862)
** 3. three separate variables; one for each of year, month, day
**
** Below three examples are given, each using one of three possible  input types

*===============================================================================
** 1. Gregorian input is a single variable in string format ("year/month/day")
import delimited "${df_path}/IRR_USD_histExRate.csv", clear case(preserve)
greg2sol dateGregorian, separate(yearSolar monthSolar daySolar) ///
						string(solarDate_str) ///
						datetime(solarDate_datetime) aesthetic(long)
sort solarDate_datetime
// all three types of output are concurrently generated through a single command


** Solar Hijri labels in datetime-format outputs (e.g., the "solarDate_datetime"
** variable generated above) are preserved while plotting graphs
graph twoway line IRR_USD solarDate_datetime, ///
								xlabel(, grid) graphregion(margin(r+6 t+2)) ///
								xlabel(7942 11626 15500 19386 23066, valuelabel)


*===============================================================================
** 2. Gregorian input is single variable in Stata datetime (%t*) format
import delimited "${df_path}/IRR_USD_histExRate.csv", clear case(preserve)
gen dateGregorian_datetime = date(dateGregorian, "YMD")
format dateGregorian_datetime %td
greg2sol dateGregorian_datetime, sep(yearSolar monthSolar daySolar)
sort yearSolar monthSolar daySolar


*===============================================================================
** 3. Gregorian inputs are three variables in provided in year, month, day order
import delimited "${df_path}/IRR_USD_histExRate.csv", clear case(preserve)
split dateGregorian, p("-") destring
rename dateGregorian1 gregorianYear
rename dateGregorian2 gregorianMonth
rename dateGregorian3 gregorianDay
greg2sol gregorianYear gregorianMonth gregorianDay, st(solarDate_str)
sort solarDate_str

