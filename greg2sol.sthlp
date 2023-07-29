{smcl}
{* *! version 1.0  30jul2023}{...}
{vieweralsosee "sol2greg" "help sol2greg"}{...}
{viewerjumpto "Syntax" "greg2sol##syntax"}{...}
{viewerjumpto "Description" "greg2sol##description"}{...}
{viewerjumpto "Options" "greg2sol##options"}{...}
{viewerjumpto "Installation" "greg2sol##installation"}{...}
{viewerjumpto "Examples" "greg2sol##examples"}{...}
{viewerjumpto "Citation" "greg2sol##citation"}{...}
{viewerjumpto "Contact" "greg2sol##contact"}{...}
{title:Title}

{phang}
{bf:greg2sol} {hline 2} Gregorian to Solar Hijri Calendar Conversion


{marker syntax}{...}
{title:Syntax}

{pstd}
      {cmd:greg2sol} 	{{varname} | {varlist}}
			{ifin}
	       		{cmd:,} {{opth sep:arate(namelist)} | {opth st:ring(name)} | {opth d:atetime(name)}}
			[{opth aes:thetic(str)}]


{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Output}
{p2coldent :* {opth sep:arate(namelist)}}generate three separate variables for year, month, day values{p_end}
{p2coldent :* {opth st:ring(name)}}generate a string variable in "{bf:year/month/day}" format{p_end}
{p2coldent :* {opth d:atetime(name)}}generate a variable in {bf:%td} datetime format with Solar Hijri labels{p_end}

{syntab:Datetime Label Aesthetics}
{p2coldent :{opth aes:thetic(str)}}specify aesthetic format of labels in output of {opth d:atetime(name)} option.{p_end}
{synoptline}
{pstd}* Any number of output options can be specified concurrently but specifying at least one is required.


{marker description}{...}
{title:Description}

{pstd}
{cmd:greg2sol} takes Gregorian dates in {varlist} or {varname} and generates
corresponding Solar Hijri dates under new variable(s). {cmd:greg2sol} accommodates three different types of input:

{phang}1. A string variable in "{bf:year/month/day}" format (e.g., "{it:2011/8/23}") where the command can handle "/", "-", "+", ":",  "--", " " (white space) as delimiters.{p_end}
{phang}2. A Stata datetime variable in {bf:%t*} format (e.g., {it:23aug2011} in {bf:%td} format with underlying value 18862).{p_end}
{phang}3. Three separate variables in year, month, day order. In this case each input variable can be in either string or numeric format.{p_end}

{phang} Note: The Gregorian {it:year} value must be a 4-digit number.
This is intentional so that the user, rather than the program, makes the distinction between 2-digit abbreviations of 19-- or 20-- Gregorian years
(e.g., 05 can correspond to either 1905 or 2005 in conventional use cases). If all inputs are given in a 2-digit format
(e.g., {it:11/8/23} in the single-input use case of the program) {cmd:greg2sol} returns an error.
However, if some observations contain 4-digit year values while others contain 2-digit year values
(e.g., one observation in the form of {it:11/8/23} and another in the form of {it:2012/8/23}) the command {it:does not} return an error.
In the latter case, it is assumed that user has intentionally provided entries in such manner.{p_end}


{marker options}{...}
{title:Options}

{dlgtab:Output}

{phang}
{opth sep:arate(namelist)} creates three separate year, month, day variables associated with Solar Hijri date values. Names of three output variables are provided via {it:namelist} in year, month, day order.

{phang}
{opth st:ring(name)} creates a single string variable associated with Solar Hijri dates in "{it:year/month/day}" format. Name of output variable is provided via {it:name}.

{phang}
{opth d:atetime(name)} creates a single variable in {bf:%td} datetime format with Solar Hijri dates as observation labels. Name of output variable is provided via {it:name}. Aesthetics of Solar Hijri date label can be changed through the {opth aes:thetic(str)} option.

{dlgtab:Datetime Label Aesthetics}

{phang}
{opth aes:thetic(str)} specifies aesthetic format of labels shown in output generated through {opth d:atetime(name)}. Available options are {bf:short} (e.g., {it:01sha1390}) and {bf:long} (e.g., {it:1 Shahrivar 1390}). If not specified, {bf:short} is used as the default option.


{marker installation}{...}
{title:Installation}

{pstd}In order to install {cmd:greg2sol}, run the following command:{p_end}
{phang2}{cmd:. net install greg2sol, from(https://raw.githubusercontent.com/peymanshahidi/greg2sol/master)}{p_end}


{marker examples}{...}
{title:Examples}

{pstd}String input / Multiple outputs (separate, string, and datetime){p_end}
    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse IRR_USD_histExRate, clear}{p_end}

{pstd}Convert Gregorian to Solar Hijri{p_end}
{phang2}{cmd:. greg2sol dateGregorian, separate(yearSolar monthSolar daySolar) string(solarDate_str) datetime(solarDate_datetime) aesthetic(long)}{p_end}

{pstd}Plot timeseries of IRR to USD exchange rate with Solar Hijri labels on x-axis{p_end}
{phang2}{cmd:. graph twoway line IRR_USD solarDate_datetime, xlabel(, grid) graphregion(margin(r+6 t+2)) xlabel(7942 11626 15500 19386 23066, valuelabel)}{p_end}


{pstd}Datetime input / Separate outputs{p_end}
    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse IRR_USD_histExRate, clear}{p_end}

{pstd}Generate a Gregorian variable in datetime format{p_end}
{phang2}{cmd:. gen dateGregorian_datetime = date(dateGregorian, "YMD")}{p_end}
{phang2}{cmd:. format dateGregorian_datetime %td}{p_end}

{pstd}Convert Gregorian to Solar Hijri{p_end}
{phang2}{cmd:. greg2sol dateGregorian_datetime, sep(yearSolar monthSolar daySolar)}{p_end}


{pstd}Separate inputs / String output{p_end}
    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse IRR_USD_histExRate, clear}{p_end}

{pstd}Generate separate Gregorian date variables{p_end}
{phang2}{cmd:. split dateGregorian, p("-") destring}{p_end}
{phang2}{cmd:. rename dateGregorian1 gregorianYear}{p_end}
{phang2}{cmd:. rename dateGregorian2 gregorianMonth}{p_end}
{phang2}{cmd:. rename dateGregorian3 gregorianDay}{p_end}

{pstd}Convert Gregorian to Solar Hijri{p_end}
{phang2}{cmd:. greg2sol gregorianYear gregorianMonth gregorianDay, st(solarDate_str)}{p_end}


{marker citation}{...}
{title:Citation}

{pstd}If you use this command, please cite it as below:{p_end}

{phang}
Shahidi, Peyman, 2023, {browse "https://github.com/peymanshahidi/greg2sol":{it:Gregorian to Solar Hijri Calendar Conversion in Stata},} GitHub repository, https://github.com/peymanshahidi/greg2sol.


{marker acknowledgements}{...}
{title:Acknowledgements}

{pstd}Thanks are due to Hosein Joshaghani, who encouraged me to develop this command,
and {bf:d-learn.ir}, whose {browse "https://d-learn.ir/p/usd-price/":historical IRR to USD exchange rate dataset} is used for the test materials.{p_end}


{marker contact}{...}
{title:Contact}

{pstd}For questions, comments, or feedbacks please contact {browse "mailto:shahidi.peyman96@gmail.com":shahidi.peyman96@gmail.com}.{p_end}

