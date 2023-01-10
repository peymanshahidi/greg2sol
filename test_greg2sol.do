********************************************************************************
** title: 		  test run for greg2sol command using a sample of
**							 IRR to USD exchange rate

** by:							 Peyman Shahidi

** file name:				 	test_greg2sol.do

** version date:	  	    1399/02/29 - 18/05/2020
*******************************************************************************
clear all
set more off

use "greg2sol_test", clear
cap program drop greg2sol
greg2sol year month day
