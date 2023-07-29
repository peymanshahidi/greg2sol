# `greg2sol`: Gregorian to Solar Hijri Calendar Conversion in Stata
#### Developed by Peyman Shahidi
#### Last updated on 29 July 2023 (7 Mordad 1402)

*******************************************************************************
## Command Description
The `greg2sol` command takes Gregorian date variable(s) as input and produces corresponding Solar Hijri dates in up to three different types of outputs.

<br>

Types of Gregorian date input(s):

&nbsp; 1. A string variable in `"year/month/day"` format (e.g., `"2011/8/23"`)
&nbsp; 2. A Stata datetime variable in `%t*` format (e.g., `23aug2011` with underlying value 18862)
&nbsp; 3. Three separate variables; one for each of year, month, day values (in this order)

Types of Solar Hijri date output(s):

&nbsp; 1. A string variable in `"year/month/day"` format (e.g., `"1390/06/01"`)
&nbsp; 2. A Stata datetime variable in `%td` format (e.g., `01sha1390` with underlying value 18862)
&nbsp; 3. Three separate variables; one for each of year, month, day values

<br>

### Examples:
1. Suppose Gregorian date value `2011/8/23` is stored in variable `dateGreg` (either in string format or in Stata %t* datetime formats) and one wants to obtain the corresponding Solar Hijri calendar date `1390/6/1` under a new variable called `dateSolarHijri` in Stata %td format with Solar Hijri labels. The following command does this conversion:
```
greg2sol dateGreg, datetime(dateSolarHijri)
```
2. Suppose Gregorian date value `2011/8/23` is stored in three variables `yearGreg` (2011), `monthGreg` (8), `dayGreg` (23), and the corresponding Solar Hijri date `1390/6/1` is to be returned under a single output called `dateSolar` in string format. The following command does this conversion:
```
greg2sol yearGreg monthGreg dayGreg, string(dateSolar)
```
*******************************************************************************
## Notes

### Note 1: 
The `greg2sol` command can manage three types of inputs:

&nbsp; 1. A single string variable in `"year/month/day"` format (e.g., `"2011/8/23"`) where the command is able to flexibly handle `/`, `-`, `+`, `:`,  `--`, and <code>&nbsp;</code> (white space) as delimiters.

&nbsp; 2. A single variable in one of Stata datetime formats `%t*` (e.g., `23aug2011` with underlying value 18862).

&nbsp; 3. Three separate variables in year, month, day order. In this case each input variable can be in either string or numeric format.

<br>

### Note 2:
The `greg2sol` command can produce up to three types of outputs:

&nbsp; 1. A single variable in `"year/month/day"` string format (e.g., `"1390/06/01"`).

&nbsp; 2. A single variable in Stata datetime format `%td` (e.g., `01sha1390` with underlying value 18862).

&nbsp; 3. Three separate variables, one for each of year, month, day values, all in numeric format.

<br>

### Note 3:
The Gregorian `year` value must be a 4-digit number. This is intentional so that the user, rather than the program, makes the distinction between 2-digit abbreviations of 19-- or 20-- Gregorian years (e.g., `05` can correspond to either 1905 or 2005 in conventional use cases). If all inputs are given in a 2-digit format (e.g., `11/8/23` in the single-input use case of the program) the `greg2sol` command returns an error. However, if some observations contain 4-digit year values while others contain 2-digit values (e.g., `11/8/23` as one observation and `2012/8/23` as another) the command DOES NOT return an error. In the latter case, it is assumed that the user has intentionally provided entries in such manner.

*******************************************************************************
## Test Materials 
The `greg2sol_test.do` file contains examples for different use cases of the command. To run the test script follow these steps:

&nbsp;1. Download the `greg2sol` project files.

&nbsp;2. Set global macro `root` in `line 16` of the `greg2sol_test.do` script as the path of `greg2sol` folder on your machine (the path of files downloaded in previous step).

&nbsp;3. Run the script.


*******************************************************************************
## Citation
If you use this command, please cite it as below:
```
Shahidi, Peyman, "Gregorian to Solar Hijri Calendar Conversion in Stata," 2023, GitHub repository, https://github.com/peymanshahidi/greg2sol.
```

*******************************************************************************
## Acknowledgements
Thanks are due to Hosein Joshaghani, who encouraged me to develop this command, and `d-learn.ir`, whose [historical IRR to USD exchange rate dataset](https://d-learn.ir/p/usd-price/) is used for the test materials.


*******************************************************************************
## Contact
For questions, comments, or feedbacks please contact me via shahidi.peyman96@gmail.com
