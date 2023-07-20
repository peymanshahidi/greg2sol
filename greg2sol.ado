*******************************************************************************
** Title: 	  	Conversion of Gregorian calendar to Solar Hijri calendar
** By:								Peyman Shahidi
** ado-file name:					 greg2sol.ado
** Version date:	  	    	29 Tir 1402 - 20 July 2023
*******************************************************************************
*******************************************************************************
** The "greg2sol" command takes Gregorian date variable(s) as input and flexibly
** produces corresponding Solar Hijri calendar dates in one of two formats: 
** 1) a string under a user-specified variable name, or 2) three variables for 
** each of the Solar Hijri year, month, day values in numeric format.
**
** Examples:
**
** 1. Suppose Gregorian date value "2013/8/23" is stored in variable "dateGreg" 
** (either in a string format or in Stata datetime %t* format) and one wants to 
** obtain the corresponding Solar Hijri calendar date "1390/6/1" under a new 
** variable called "dateSolar" in a string format. The following command does 
** this conversion:
**
**
** greg2sol dateGreg, gen(dateSolar)
**
**
** 2. If the Gregorian input date value "2013/8/23" is stored in three separate
** variables "yearGreg" (2013), "monthGreg" (8), "dayGreg" (23), and the output 
** is to be returned under a variable called "dateSolar" in string format, one 
** can use the following command for conversion:
**
**
** greg2sol yearGreg monthGreg dayGreg, gen(dateSolar)
**
**
*******************************************************************************
*******************************************************************************
** Note 1: 
** The "greg2sol" command can manage two types of inputs:
** 1. A single variable, either in "year/month/day" string format (e.g., 
**    "2013/8/23") where the command is able to flexibly handle "/", "-", "+", 
**    ":",  "--", " " (white space) as delimiters, or in Stata datetime formats 
**    %t* (e.g., "23aug2013").
** 2. Three separate variables in the (year, month, day) order. In this case 
**    each input variable can be in either string or numeric format.
**
**
** Note 2: 
** The "greg2sol" command can produce two types of outputs:
** 1. Three separate variables under default names "solarYear", "solarMonth", 
**    "solarDay", all in numeric format (this is the default form of output).
** 2. A single string variable in "year/month/day" format (e.g., "1390/6/1").
**    This form of output enabled if the user specifies a name for the output 
**    variable through the gen(.) option.
**
**
** Note 3:
** The Gregorian "year" must be a 4-digit number. This is intentional so that
** the user, rather than the program, makes the distinction between 2-digit 
** values corresponding to abbreviation of either 19-- or 20-- Gregorian years
** (e.g., Gregorian year value "05" can correspond to either 1905 or 2005 in 
** conventional use cases). If all inputs are given in a 2-digit format (e.g., 
** "13/8/23" in the single-input use case of the program) the "greg2sol" command
** returns a syntax error. However, if some observations contain 4-digit year
** values while others contain 2-digit year values (e.g., one observation in the
** form of "13/8/23" and another in the form of "2014/8/23") the command  
** DOES NOT return a syntax error. In the latter case, it is assumed that the 
** user has intentionally provided entries in such manner.
*******************************************************************************

program greg2sol
		version 14.1
		syntax varlist(min=1 max=3) [if/] [, gen(name)]
		tokenize `varlist'
		
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
		keep `varlist'
		tempvar redundant
		duplicates tag `varlist', gen(`redundant') 
		bysort `varlist': keep if _n == _N
		
		
		
		** check if input Gregorian date variable is
		** a single variable in Stata date format (%t*) or string format, or 
		** three variables in form of year, month, day
		
		// if only 1 variable is fed into the program check if it is in
		// Stata datetime (%t*) format or string format and proceed accordingly
		if "`varlist'" == "`1'" {
			
			// if single input variable is in datetime (%t*) format create three
			// separate variables for year, month, day
			ds `varlist', has(format %t*)
			if "`r(varlist)'" == "`varlist'" {
				gen decomposed_gy = year(`varlist')
				gen decomposed_gm = month(`varlist')
				gen decomposed_gd = day(`varlist')
			}
			
			// if single input variable is not in datetime (%t*) format
			ds `varlist', has(format %t*)
			if "`r(varlist)'" != "`varlist'" {
				
				// if single input variable is not in string format either 
				// return syntax error
				ds `varlist', has(type string)
				if "`r(varlist)'" != "`varlist'" {
					display as error ///
						`"single Gregorian date input must be in either datetime (%t*) or string ("year/month/day") format"'
					restore
					exit 198
				}
				
				// if single input variable is in string ("year/month/day") 
				// format create three separate variables for year, month, day
				ds `varlist', has(type string)
				if "`r(varlist)'" == "`varlist'" {
					split `varlist', p("/" | "-" | "+"| ":" | "--" | " ") destring
				
					// assign local macros to Gregorian date variables
					rename `varlist'1 decomposed_gy
					rename `varlist'2 decomposed_gm
					rename `varlist'3 decomposed_gd
				}
			}
							
			
			// assign local macros to split Gregorian date variables
			local gy decomposed_gy
			local gm decomposed_gm
			local gd decomposed_gd
		}
		
		
		// if more than 1 variable is fed into the program 
		// proceed as if date decomposition is done already
		if "`varlist'" != "`1'" {
		
			// assign local macros to input Gregorian date variables
			local gy `1'
			local gm `2'
			local gd `3'
			
			// convert any date variable in string format to numeric 
			ds `varlist', has(type string)
			destring `r(varlist)', replace float					
		}
		** end of input variable check		
		
		
		
		// display error if Gregorian year is not given in 4 digits
		sum `gy'
		if `r(max)' < 100 {
			display as error "Gregorian year must be a 4-digit number" 
			restore
			exit 198
		}
		
		
		
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
		merge m:1 `varlist' using `converted'
		drop _merge
		if "`varlist'" == "`1'" {
			drop `gy' `gm' `gd' // drop auxiliary variables
		}
}
		// rename output variables and add variable labels
		rename sy solarYear
		rename sm solarMonth
		rename sd solarDay
		label variable solarYear "Solar Hijri year"
		label variable solarMonth "Solar Hijri month"
		label variable solarDay "Solar Hijri day"
		
		// if user has specified a name for single output in string format
		if "`gen'" != "" {
			tostring solarYear solarMonth solarDay, replace
			
			// add leading zeros to month and day variables
			replace solarMonth = string(real(solarMonth), "%02.0f") 
			replace solarDay = string(real(solarDay), "%02.0f") 
			
			gen `gen' = solarYear + "/" + solarMonth + "/" + solarDay
			label variable `gen' "Solar Hijri date"
			
			drop solarYear solarMonth solarDay
		}
end
