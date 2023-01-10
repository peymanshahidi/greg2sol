********************************************************************************
* Title:		main.do
* Description:	Initiate test run for "greg2sol" command.
* By:  			Peyman Shahidi
* Date:			Oct 10, 2020

********************************************************************************

* greg2sol folder path
global root "/Users/peymansh/Dropbox/Personal/StataPackages/greg2sol"
//global root "path to/greg2sol"
global data "${root}"

cd "${root}"
adopath + "${root}" 

*===============================================================================
do test_greg2sol
