# `greg2sol`: Gregorian to Solar Hijri Calendar Conversion in Stata
#### Developed by Peyman Shahidi
#### Last updated on 3 August 2023 (12 Mordad 1402)


*******************************************************************************
## Description
The `greg2sol` command takes Gregorian date variable(s) as input and generates the corresponding Solar Hijri dates as output(s). `greg2sol` supports multiple variable formats (string, numeric, datetime) in both its inputs and outputs.


*******************************************************************************
## Features
`greg2sol` accommodates three types of Gregorian date inputs:

&nbsp; 1. A single string variable in `"year/month/day"` format (e.g., `"2011/08/23"`) where the command is able to flexibly handle `/`, `-`, `+`, `:`,  `--`, and <code>&nbsp;</code> (white space) as delimiters.

&nbsp; 2. A single variable in one of Stata datetime formats `%t*` (e.g., `23aug2011` with underlying value 18862).

&nbsp; 3. Three separate variables in year, month, day order. In this case each input variable can be in either string or numeric format.

<br>

`greg2sol` can generate up to three types of Solar Hijri date outputs:

&nbsp; 1. A single variable in `"year/month/day"` string format (e.g., `"1390/06/01"`).

&nbsp; 2. A single variable in Stata datetime format `%td` (e.g., `01sha1390` with underlying value 18862).

&nbsp; 3. Three separate variables, one for each of year, month, day values, all in numeric format.


*******************************************************************************
## Examples
1. Suppose the Gregorian date value `2011/08/23` is stored in variable `dateGreg` (either in string or in Stata datetime format) and one wants to obtain the corresponding Solar Hijri calendar date `1390/06/01` under a new variable called `dateSolarHijri` in Stata `%td` format with Solar Hijri labels. The following command does this conversion:
```
greg2sol dateGreg, datetime(dateSolarHijri)
```
2. Suppose the Gregorian date value `2011/08/23` is stored in three variables `yearGreg` (2011), `monthGreg` (8), `dayGreg` (23), and the corresponding Solar Hijri date `1390/06/01` is to be returned under a single output called `dateSolar` in string format. The following command does this conversion:
```
greg2sol yearGreg monthGreg dayGreg, string(dateSolar)
```
For further examples and more detailed description of use cases refer to test materials or read the accompanying help file of the command.


*******************************************************************************
## Installation
In order to install `greg2sol`, run the following command in Stata:
```
net install greg2sol, from(https://raw.githubusercontent.com/peymanshahidi/greg2sol/master)
```

After installation, a comprehensive help file containing detailed description of `greg2sol` features along with examples is accessible by typing:
```
help greg2sol
```
Reading the help file before using the command is strongly recommended.


*******************************************************************************
## Test Materials
The file `greg2sol_test.do` in the current repository gives three examples to illustrate different use cases of `greg2sol` in Gregorian to Solar Hijri conversion. To test the command follow these steps:

&nbsp; 1. Download `greg2sol_test.do` from the current repository.

&nbsp; 2. Run the script!

The script comprises two parts. The first installs the latest version of `greg2sol` and copies a test dataset into your current working direcotry. The second contains three test examples.


*******************************************************************************
## Citation
If you use `greg2sol` in your work, please cite it as below:
```
Shahidi, Peyman, 2023, "Gregorian to Solar Hijri Calendar Conversion in Stata," GitHub repository, https://github.com/peymanshahidi/greg2sol.
```
The citation information can be found in the `CITATION.bib` file.


*******************************************************************************
## Acknowledgements
Thanks are due to Hosein Joshaghani, who encouraged me to develop this command, and `d-learn.ir`, whose [historical IRR to USD exchange rate dataset](https://d-learn.ir/p/usd-price/) is used in the test materials.


*******************************************************************************
## Contact
For questions, comments, or feedbacks please contact shahidi.peyman96@gmail.com.

