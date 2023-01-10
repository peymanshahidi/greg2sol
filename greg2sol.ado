*******************************************************************************
** title: 	  	Conversion of Gregorian calendar to Solar Hijri calendar
** by:								Peyman Shahidi
** ado-file name:					 greg2sol.ado
** version date:	  	    	1399/03/21 - 10/06/2020
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
		syntax varlist(min=3 max=3 numeric) [if/]
		
quietly{
		// preserving the dataset in memory
		preserve
		
		// rename provided Gregorian dates' variables
		local gy `1'
		local gm `2'
		local gd `3'

		// data cleaning -- masking if condition and keeping calendar dates
		if "`if'" != "" {
						 keep if `if'
		}
		keep `gy' `gm' `gd'
		
		// droping duplicate dates in Gregorian calendar
		tempvar redundant
		duplicates tag `gy' `gm' `gd', gen(`redundant') 
		bysort `gy' `gm' `gd': keep if _n == _N

		
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
								
		gen jy = -1595 + 33 * floor(`days' / 12053)
		replace `days' = mod(`days', 12053)

		replace jy = jy + 4 * floor(`days' / 1461)
		replace `days' = mod(`days', 1461)

		replace jy = cond(`days' > 365, jy + floor((`days' - 1) / 365), jy)
		replace `days' = cond(`days' > 365, mod(`days' - 1, 365), `days')

		gen jm = cond(`days' < 186, 1+floor(`days'/31), 7+floor((`days'-186)/30))
		gen jd = cond(`days' < 186, 1+mod(`days', 31), 1 + mod((`days'-186),30))
		** end of Gregorian to Solar Hijri conversion
		
		// saving the calculations into temporary file "converted"
		tempfile converted
		save `converted', replace
		restore
		
		// merge the results into the preserved dataset
		merge m:1 `gy' `gm' `gd' using `converted'
		drop _merge
}
		// sort output by year --> month --> day
		order jy jm jd
		sort jy jm jd
		rename jy j_year
		rename jm j_month
		rename jd j_day
end
