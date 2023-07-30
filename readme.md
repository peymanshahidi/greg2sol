# `greg2sol`: Gregorian to Solar Hijri Calendar Conversion in Stata
#### Developed by Peyman Shahidi
#### Last updated on 30 July 2023 (8 Mordad 1402)

*******************************************************************************
## Description
The `greg2sol` command takes Gregorian date variable(s) as input and generates the corresponding Solar Hijri dates as output(s). `greg2sol` supports multiple variable formats (string, numeric, datetime) in both its inputs and outputs.


*******************************************************************************
## Features
`greg2sol` accommodates three types of Gregorian date input(s):

&nbsp; 1. A single string variable in `"year/month/day"` format (e.g., `"2011/8/23"`) where the command is able to flexibly handle `/`, `-`, `+`, `:`,  `--`, and <code>&nbsp;</code> (white space) as delimiters.

&nbsp; 2.  A single variable in one of Stata datetime formats `%t*` (e.g., `23aug2011` with underlying value 18862).

&nbsp; 3. Three separate variables in year, month, day order. In this case each input variable can be in either string or numeric format.

<br>

`greg2sol` can generate up to three types of Solar Hijri date output(s):

&nbsp; 1. A single variable in `"year/month/day"` string format (e.g., `"1390/06/01"`).

&nbsp; 2. A single variable in Stata datetime format `%td` (e.g., `01sha1390` with underlying value 18862).

&nbsp; 3. Three separate variables, one for each of year, month, day values, all in numeric format.


*******************************************************************************
## Examples
1. Suppose Gregorian date value `2011/8/23` is stored in variable `dateGreg` (either in string or in Stata datetime format) and one wants to obtain the corresponding Solar Hijri calendar date `1390/06/01` under a new variable called `dateSolarHijri` in Stata `%td` format with Solar Hijri labels. The following command does this conversion:
```
greg2sol dateGreg, datetime(dateSolarHijri)
```
2. Suppose Gregorian date value `2011/8/23` is stored in three variables `yearGreg` (2011), `monthGreg` (8), `dayGreg` (23), and the corresponding Solar Hijri date `1390/06/01` is to be returned under a single output called `dateSolar` in string format. The following command does this conversion:
```
greg2sol yearGreg monthGreg dayGreg, string(dateSolar)
```
For further examples and more detailed description of use cases refer to test materials or read the accompanying help file of the command.

*******************************************************************************
## Installation and Test Materials 
In order to install `greg2sol`, run the following command in Stata:
```
net install greg2sol, from(https://raw.githubusercontent.com/peymanshahidi/greg2sol/master)
```

After installation, a comprehensive help file containing detailed description of `greg2sol` features along with further examples is accessible by typing:
```
help greg2sol
```

<br>

Although reading the help file before using `greg2sol` is strongly recommended, a script for testing different use cases of the command is nevertheless provided for user's convenience. The file `greg2sol_test.do` provides three examples of `greg2sol` being used for Gregorian to Solar Hijri conversion. Follow the steps below to run the test examples:

&nbsp; 1. Download `greg2sol_test.do` from present repository.

&nbsp; 2. Install the `greg2sol` command (lines 15 to 17 of the `greg2sol_test.do` script does this for you).

&nbsp; 3. Run the examples in lower half of the script one at a time.

Note that the dataset used in test examples is automatically copied to your working directory during installation of the command. However, if you wish to skip the installation step please make sure that a copy of `IRR_USD_histExRate.dta` dataset, available in current repository, lives in your working direcotry before running the examples.

*******************************************************************************
## Citation
If you use `greg2sol` in your work, please cite it as below:
```
Shahidi, Peyman, 2023, "Gregorian to Solar Hijri Calendar Conversion in Stata," GitHub repository, https://github.com/peymanshahidi/greg2sol.
```

*******************************************************************************
## Acknowledgements
Thanks are due to Hosein Joshaghani, who encouraged me to develop this command, and `d-learn.ir`, whose [historical IRR to USD exchange rate dataset](https://d-learn.ir/p/usd-price/) is used in test materials.


*******************************************************************************
## Contact
For questions, comments, or feedbacks please contact shahidi.peyman96@gmail.com.
