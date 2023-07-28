********************************************************************************
** Description:   	Test script for "greg2sol" command using a dataset of
**					  IRR to USD exchange rate provided by "d-learn.ir"
**					   (available at: https://d-learn.ir/p/usd-price)
** By:							     Peyman Shahidi
** Do-file Name:			       "greg2sol_test.do"    
** Version Date:	  	       29 Tir 1402 - 20 July 2023
********************************************************************************
clear all
set more off
global root "path_to/greg2sol"

// set working direcotry to the "greg2sol" folder path on your machine
cd "${root}"

// set adopath directory to the "greg2sol" folder path on your machine. if you
// have put the "greg2sol.ado" file in your personal adopath directory, you can
// comment out line 19.
adopath + "${root}" 


********************** Gregorian to Solar Hijri conversion *********************
*===============================================================================
** Use case #1: input Gregorian date is a single variable 
** Note: the command can flexibly handle single-variable input in either 
** 		 Stata datetime format (%t*) or string format ("year/month/day"). code 
** 		 below shows the Stata datetime input test case. go to line 76 for an 
** 		 example of single-variable input in string format.
import delimited using "IRR_USD_historicalExRate.csv", clear case(preserve)
cap program drop greg2sol

// convert original Gregorian date variable "dateGregorian" to Stata datetime 
// (%td) format
gen dateGregorian_datetime = date(dateGregorian, "YMD")
format dateGregorian_datetime %td

// convert Gregorian date variable "dateGregorian_datetime" to corresponding 
// Solar Hijri calendar date under variable name "dateSol" using the
// "greg2sol" command
greg2sol dateGregorian_datetime, gen(dateSol)
sort dateSol

// sanity check: does generated Solar Hijri date variable "dateSol" match 
// the original Solar Hijri date variable "dateSolarHijri" in dataset?
gen flag = 1 if dateSolarHijri == dateSol
count if missing(flag)
// no missing values --> all observations are similar --> sanity check passed!


*===============================================================================
** Use case #2: input Gregorian date consists of three variables in string 
**				or numeric formats
import delimited using "IRR_USD_historicalExRate.csv", clear case(preserve)
cap program drop greg2sol

// split Gregorian date variable into three separate year, month, day variables 
split dateGregorian, p("-") destring
rename dateGregorian1 gregorianYear
rename dateGregorian2 gregorianMonth
rename dateGregorian3 gregorianDay

// convert the Gregorian date variables created earlier to corresponding
// Solar Hijri calendar date under variable name "dateSol" using the
// "greg2sol" command
greg2sol gregorianYear gregorianMonth gregorianDay, gen(dateSol)
sort dateSol

// sanity check: does generated Solar Hijri date variables "dateSol" match 
// the original Solar Hijri date variable "dateSolarHijri" in dataset?
gen flag = 1 if dateSolarHijri == dateSol
count if missing(flag)
// no missing values --> all observations are similar --> sanity check passed!


*===============================================================================
** Test case for other capabilities of the "greg2sol" command: input Gregorian 
** date variable is in string format ("year/month/day") and the command produces 
** three separate variables for "solarYear", "solarMonth", and "solarDay" in the
** output
import delimited using "IRR_USD_historicalExRate.csv", clear case(preserve)
cap program drop greg2sol

// input Gregorian date "dateGregorian" is in string format and single output
// is generated under user-specified "dateSol" variable in string format
greg2sol dateGregorian
sort solarYear solarMonth solarDay

// sanity check: does generated Solar Hijri date variables match the original 
// Solar Hijri date variable "dateSolarHijri" in dataset?
split dateSolarHijri, p("/") destring
gen flag = 1 if solarYear 	== dateSolarHijri1 & ///
				solarMonth  == dateSolarHijri2 & ///
				solarDay    == dateSolarHijri3
count if missing(flag)
// no missing values --> all observations are similar --> sanity check passed!
