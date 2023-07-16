*******************************************************************************
** Title: 	  	Conversion of Gregorian calendar to Solar Hijri calendar
** By:								Peyman Shahidi
** ado-file name:					 greg2sol.ado
** Version date:	  	    	19 Tir 1402 - Jul 10, 2023
*******************************************************************************
*******************************************************************************
** This command takes as input "year, month, day" in Gregorian calendar and 
** returns the corresponding dates in Solar Hijri calendar.
*******************************************************************************
*******************************************************************************
** Note 1: 
** Gregorian calendar inputs must be provided in this order: year month day
**
** Note 2:
** All three input 'date' variables must be provided in 'numeric' format.
*******************************************************************************

program greg2sol
		version 14.1
		syntax varlist(min=1 max=3) [if/]
		
quietly{
		// preserve dataset fed into the command in memory
		// and get a list of original variables to restore later
		preserve
		ds
		local original_vars `r(varlist)'
		
		
		
		// mask the if condition
		if "`if'" != "" {
						 keep if `if'
		}
		
		// keep only the Gregorian calendar date variables
		// for lower load of computation and drop duplicates
		keep `*'
		tempvar redundant
		duplicates tag `*', gen(`redundant') 
		bysort `*': keep if _n == _N
		
		
		
		** check if input Gregorian date variable is
		** a single variable in Stata date format (%t*), or 
		** three variables in form of year, month, day
		
		// if only 1 variable is fed into the program check if it is
		// in Stata time (%t*) format
		if "`*'" == "`1'" {
							ds `*', has(format %t*)
							
							// display error if single input is not in %t* format
							if "`r(varlist)'" != "`*'" {
													display as error ///
								"single Gregorian date variable must be in Stata time format"
													restore
													exit 198
			}
							
							// if format of single input is %td decompose variable 
							// into three separate variables for year, month, day
							
							gen decomposed_gy = year(`1')
							gen decomposed_gm = month(`1')
							gen decomposed_gd = day(`1')
							
							// assign local macros to Gregorian date variables
							local gy decomposed_gy
							local gm decomposed_gm
							local gd decomposed_gd
		}
		
		// if more than 1 variable is fed into the program 
		// proceed as if date decomposition is done already
		if "`*'" != "`1'" {
							// assign local macros to input Gregorian date variables
							local gy `1'
							local gm `2'
							local gd `3'
							
							// convert any date variable in string format to numeric 
							ds `*', has(type string)
							destring `r(varlist)', replace float					
		}
		** end of input variable check		
		
		
		
		** start of Gregorian to Solar Hijri conversion
		tempvar days gy_prime
		
		gen `days' = `gm'
		recode `days' (1 = 0) (2 = 31) (3 = 59) (4 = 90)   ///
					  (5 = 120) (6 = 151) (7 = 181) (8 = 212) ///
					  (9 = 243) (10 = 273) (11 = 304) (12 = 334)

		gen `gy_prime' = cond(`gm' > 2, `gy' + 1, `gy')
		display "`type'"
		replace `days' = 355666 + (365 * `gy') + floor((`gy_prime'+3) / 4) ///
						 - floor((`gy_prime'+99)/100) + floor((`gy_prime'+399)/400) ///
						 + `gd' + `days'
								
		gen sy = -1595 + 33 * floor(`days' / 12053)
		replace `days' = mod(`days', 12053)

		replace sy = sy + 4 * floor(`days' / 1461)
		replace `days' = mod(`days', 1461)

		replace sy = cond(`days' > 365, sy + floor((`days' - 1) / 365), sy)
		replace `days' = cond(`days' > 365, mod(`days' - 1, 365), `days')

		gen sm = cond(`days' < 186, 1+floor(`days'/31), 7+floor((`days'-186)/30))
		gen sd = cond(`days' < 186, 1+mod(`days', 31), 1 + mod((`days'-186),30))
		
		// save output of conversion in a temporary file named "converted"
		tempfile converted
		save `converted', replace
		restore
		** end of Gregorian to Solar Hijri conversion
		
		
		
		// merge Solar Hijri date variables to the main dataset fed into the command
		merge m:1 `*' using `converted'
		drop _merge
		if "`*'" == "`1'" {
							drop `gy' `gm' `gd' // drop auxiliary variables
		}
}
		// rename output variables and add variable labels
		rename sy solar_year
		rename sm solar_month
		rename sd solar_day
		label variable solar_year "Solar Hijri year"
		label variable solar_month "Solar Hijri month"
		label variable solar_day "Solar Hijri day"
end
