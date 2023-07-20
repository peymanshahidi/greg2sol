# `greg2sol`: Gregorian to Solar Hijri Calendar Conversion in Stata
#### Developed by Peyman Shahidi
#### Last updated on 29 Tir 1402 (20 July 2023)

*******************************************************************************
## Command Description
The `greg2sol` command takes Gregorian date variable(s) as input and flexibly produces corresponding Solar Hijri calendar dates in one of two formats: 1) a string under a user-specified variable name, or 2) three variables for each of the Solar Hijri year, month, day values in numeric format (default output).

<br>

### Examples:
1. Suppose Gregorian date value `2011/8/23` is stored in variable `dateGreg` (either in a string format or in Stata `%t*` datetime format) and one wants to obtain the corresponding Solar Hijri calendar date `1390/6/1` under a new variable called `dateSolar` in a string format. The following command does this conversion:
```
greg2sol dateGreg, gen(dateSolar)
```
2. If the Gregorian input date value `2011/8/23` is stored in three separate variables `yearGreg` (2011), `monthGreg` (8), `dayGreg` (23), and the output is to be returned in three separate variables in numeric format [under default names `solarYear`, `solarMonth`, and `solarDay`], one can use the following command for conversion:
```
greg2sol yearGreg monthGreg dayGreg
```
*******************************************************************************
## Notes

### Note 1: 
The `greg2sol` command can manage two types of inputs:

&nbsp; 1. A single variable, either in `"year/month/day"` string format (e.g., `"2011/8/23"`) where the command is able to flexibly handle `/`, `-`, `+`, `:`,  `--`, and <code>&nbsp;</code> (white space) as delimiters, or in Stata datetime formats `%t*` (e.g., `23aug2011`).

&nbsp; 2. Three separate variables in `year`, `month`, `day` order. In this case each input variable can be in either string or numeric format.

<br>

### Note 2:
The `greg2sol` command can produce two types of outputs:

&nbsp; 1. Three separate variables under default names `solarYear`, `solarMonth`, and `solarDay`, all in numeric format. (This is the default form of output)

&nbsp; 2. A single string variable in `"year/month/day"` format (e.g., `"1390/06/01"`). This form of output is enabled if the user specifies a name for the output variable through the `gen(.)` option of the program.

<br>

### Note 3:
The Gregorian `year` value must be a 4-digit number. This is intentional so that the user, rather than the program, makes the distinction between 2-digit abbreviations of 19-- or 20-- Gregorian years (e.g., Gregorian abbreviation `05` can correspond to either 1905 or 2005 in conventional use cases). If all inputs are given in a 2-digit format (e.g., `"11/8/23"` in the single string input use case of the program) the `greg2sol` command returns a syntax error. However, if some observations contain 4-digit year values while others contain 2-digit year values (e.g., one observation in the form of `"11/8/23"` and another in the form of `"2012/8/23"`) the command **DOES NOT** return a syntax error. In the latter case, it is assumed that the user has intentionally provided entries in such manner.


*******************************************************************************
## Test Materials 
The `greg2sol_test.do` file contains examples for different use cases of the command (single- or three-variable input as well as single- or three-variable output). To run the `greg2sol_test.do` script take the following steps:

&nbsp;1. Download the `greg2sol` project files.

&nbsp;2. Define global macro `root` in `line 11` of the `greg2sol_test.do` script to be the path of `greg2sol` folder on your machine (the path of files downloaded in previous step).

&nbsp;3. Run the script.

P.S.: The `greg2sol_test.do` script changes the adopath direcotry in your machine to the path of `greg2sol` folder. If you do not wish to have this change made, you can put the `greg2sol.ado` file in your personal adopath directory and comment out `line 19` in the script.


*******************************************************************************
## Acknowledgements
Thanks are due to Hosein Joshaghani, who encouraged me to develop this command, and `d-learn.ir`, whose [historical IRR to USD exchange rate dataset](https://d-learn.ir/p/usd-price/) is used for the test materials.


*******************************************************************************
## Contact
For questions, comments, or feedbacks please contact me via shahidi.peyman96@gmail.com