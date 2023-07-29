********************************************************************************
** Title: 	  	   Conversion of Gregorian calendar to Solar Hijri calendar
** By:								   Peyman Shahidi
** ado-file name:					    greg2sol.ado
** Version date:	  	    	8 Mordad 1402 - 30 July 2023
********************************************************************************
program greg2sol
		version 14.0
		syntax varlist(min=1 max=3) [if/] [in/] [, SEParate(namelist min=3 max=3) ///
												STring(name) ///
												Datetime(name) ///
												AESthetic(string)]
		tokenize `varlist'
		
		** return error if none of output options are specified
		if ("`string'" == "" & "`datetime'" == "" & "`separate'" == ""){
			display as error `"at least one type of output must be specified"'
			exit 198
		}
		
quietly{
		** preserve original dataset and variable names
		preserve
		ds
		local original_vars `r(varlist)'

		** mask the in and if conditions
		if "`in'" != "" {
			keep in `in'
		}
		if "`if'" != "" {
			keep if `if'
		}
		
		
		** only keep Gregorian date variables for lower computation load
		keep `varlist'
		tempvar redundant
		duplicates tag `varlist', gen(`redundant') 
		bysort `varlist': keep if _n == _N
		
		
		/* start of handling inputs */
		** check if input Gregorian date variable is:
		** 1) a single variable in Stata datetime (%t*) or string format, or 
		** 2) three variables in form of year, month, day
		
		** if input is a single variable check whether it is
		** in Stata datetime (%t*) format or string format
		if "`varlist'" == "`1'" {
			
			** if single input variable is in datetime (%t*) format 
			** generate three separate variables for year, month, day
			ds `varlist', has(format %t*)
			if "`r(varlist)'" == "`varlist'" {
				gen decomposed_gy = year(`varlist')
				gen decomposed_gm = month(`varlist')
				gen decomposed_gd = day(`varlist')
			}
			
			
			** if single input variable is not in datetime (%t*) format
			ds `varlist', has(format %t*)
			if "`r(varlist)'" != "`varlist'" {
				
				** return error if single input variable is not in string format 
				ds `varlist', has(type string)
				if "`r(varlist)'" != "`varlist'" {
					display as error ///
						`"single input must be in either datetime (%t*) or string ("year/month/day") format"'
					restore
					exit 198
				}
				
				** if single input variable is in string format generate three 
				** separate variables (knowing that the input is provided in the
				** year, month, day order
				ds `varlist', has(type string)
				if "`r(varlist)'" == "`varlist'" {
					split `varlist', p("/" | "-" | "+"| ":" | "--" | " ") destring
				
					** assign local macros to Gregorian date variables
					rename `varlist'1 decomposed_gy
					rename `varlist'2 decomposed_gm
					rename `varlist'3 decomposed_gd
				}
			}
			
			** assign local macros to split Gregorian date variables
			local gy decomposed_gy
			local gm decomposed_gm
			local gd decomposed_gd
		}
		
		
		** if more than one variable is fed into the program 
		** proceed as if date decomposition is already done
		if "`varlist'" != "`1'" {
		
			** assign local macros to input Gregorian date variables
			local gy `1'
			local gm `2'
			local gd `3'
			
			** convert any input date variable in string format to numeric
			ds `varlist', has(type string)
			destring `r(varlist)', replace float					
		}
		
		** if Gregorian year is not a 4-digit number return error
		sum `gy'
		if `r(max)' < 100 {
			display as error "Gregorian year input must be a 4-digit number" 
			restore
			exit 198
		}
		/* end of handling inputs */
		
		
		/* start of Gregorian to Solar Hijri calendar conversion */
		tempvar days gy_prime
		gen `days' = `gm'
		recode `days' (1 = 0) (2 = 31) (3 = 59) (4 = 90)   ///
					  (5 = 120) (6 = 151) (7 = 181) (8 = 212) ///
					  (9 = 243) (10 = 273) (11 = 304) (12 = 334)

		gen `gy_prime' = cond(`gm' > 2, `gy' + 1, `gy')
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
		
		format sy sm sd %02.0f
		/* end of Gregorian to Solar Hijri calendar conversion */
		
		
		/* start of handling output(s) */		
		** single-variable output in string ("year/month/day") format
		if "`string'" != "" {
			tempvar sy_str sm_str sd_str
			tostring sy, gen(`sy_str') usedisplayformat
			tostring sm, gen(`sm_str') usedisplayformat
			tostring sd, gen(`sd_str') usedisplayformat
			
			gen `string' = `sy_str' + "/" + `sm_str' + "/" + `sd_str'
			label variable `string' "Solar Hijri date"
			
			drop `sy_str' `sm_str' `sd_str'
		}
		
		** single-variable output in Stata datetime (%td) format
		if "`datetime'" != "" {
			gen `datetime' = mdy(`gm', `gd', `gy')
			format `datetime' %td
			
			** create Solar Hijri date labels
			tempvar solarMonth_name sd_str sy_str
			if "`aesthetic'" == "long" {
				gen `solarMonth_name' = "Farvarding" if sm == 1
				replace `solarMonth_name' = "Ordibehesht" if sm == 2
				replace `solarMonth_name' = "Khordad" if sm == 3
				replace `solarMonth_name' = "Tir" if sm == 4
				replace `solarMonth_name' = "Mordad" if sm == 5
				replace `solarMonth_name' = "Shahrivar" if sm == 6
				replace `solarMonth_name' = "Mehr" if sm == 7
				replace `solarMonth_name' = "Aban" if sm == 8
				replace `solarMonth_name' = "Azar" if sm == 9
				replace `solarMonth_name' = "Dey" if sm == 10
				replace `solarMonth_name' = "Bahman" if sm == 11
				replace `solarMonth_name' = "Esfand" if sm == 12
				
				tostring sy, gen(`sy_str') usedisplayformat
				format sd %01.0f
				tostring sd, gen(`sd_str') usedisplayformat
				format sd %02.0f
				
				gen solarDate_label = `sd_str' + " " + `solarMonth_name' + " " + `sy_str'
			}
			else {
				gen `solarMonth_name' = "far" if sm == 1
				replace `solarMonth_name' = "ord" if sm == 2
				replace `solarMonth_name' = "kho" if sm == 3
				replace `solarMonth_name' = "tir" if sm == 4
				replace `solarMonth_name' = "mor" if sm == 5
				replace `solarMonth_name' = "sha" if sm == 6
				replace `solarMonth_name' = "meh" if sm == 7
				replace `solarMonth_name' = "aba" if sm == 8
				replace `solarMonth_name' = "aza" if sm == 9
				replace `solarMonth_name' = "dey" if sm == 10
				replace `solarMonth_name' = "bah" if sm == 11
				replace `solarMonth_name' = "esf" if sm == 12
				
				tostring sy, gen(`sy_str') usedisplayformat
				tostring sd, gen(`sd_str') usedisplayformat
				
				gen solarDate_label = `sd_str' + `solarMonth_name' + `sy_str'
			}
			drop `solarMonth_name' `sy_str' `sd_str'
			
			** assign desired label to obsevations in datetime format
			label val `datetime'

			bysort sy sm sd: gen byte group = (_n == 1) 
			replace group = sum(group) 

			gen long aux_var = _n 
			local max = group[_N]  

			forval i = 1 / `max' {  
				su aux_var if group == `i', meanonly 
				local label = solarDate_label[`r(min)'] 
				local value = `datetime'[`r(min)'] 
				label def my_label `value' `"`label'"', modify 	
			} 
			
			label val `datetime' my_label
			label variable `datetime' "Solar Hijri date"
			drop aux_var group solarDate_label
		}		
		
		** multiple-variable output in numeric format
		if "`separate'" != "" {
			label variable sy "Solar Hijri year"
			label variable sm "Solar Hijri month"
			label variable sd "Solar Hijri day"
			rename (sy sm sd) (`separate') // namelist given in (year month day) order
		}
		else {
			drop sy sm sd
		}
		/* end of handling output(s) */
		
		
		** merge Solar Hijri date variable(s) to the original dataset
		tempfile converted
		save `converted', replace
		restore
		merge m:1 `varlist' using `converted'
		drop _merge
		
		
		** remove auxiliary variables generated for calendar conversion
		** in the single-input case
		if "`varlist'" == "`1'" {
			drop `gy' `gm' `gd'
		}
}
end
