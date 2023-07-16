********************************************************************************
** Title: 		  test run for greg2sol command using a sample of
**							 IRR to USD exchange rate

** By:							 Peyman Shahidi

** File name:				 	test_greg2sol.do

** Version date:	  	    1399/02/29 - 18/05/2020
*******************************************************************************
clear all
set more off


** use case #1: input consists of three variables in either string or numeric format
use "greg2sol_test", clear
cap program drop greg2sol

greg2sol year month day


** use case #2: input is single variable in Stata time format (%t*)
use "greg2sol_test", clear
cap program drop greg2sol

gen dateGreg = mdy(month, day, year)
format dateGreg %td
label variable dateGreg "Gregorian date"
drop month day year

greg2sol dateGreg
