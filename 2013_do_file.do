clear
clear matrix
clear mata
set maxvar 32760
set more off

////////// in this code stars show type of income like "*", "**" , "***" & "****"
* Includes business income, salary, dividends etc.
** Includes rental income, profit on debt, exports etc.
*** Agricultural income is taxed under relevant provincial income tax laws
**** As declared in return as "Tax Credit for Tax Paid on Share Income from AOP". It does not include share of tax paid by AOP where tax credit was not claimed.

/////Regions /////////
//////"1" Represent "SENATE OF PAKISTAN"
///// "2" Represent "NATIONAL ASSEMBLY OF PAKISTAN" 
///// "3" Represent  "BALOCHISTAN ASSEMBLY"
///// "4" Represent  "PUNJAB ASSEMBLY"
///// "5" Represent  "SINDH ASSEMBLY"
///// "6" Represent  "KP ASSEMBLY"




import excel "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\PTY2013.xlsx", sheet("SENATE OF PAKISTAN") firstrow



save "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\SENATE OF PAKISTAN 2013.dta"

*******************************************
*******************************************

clear
	
import excel "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\PTY2013.xlsx", sheet("NATIONAL ASSEMBLY OF PAKISTAN") firstrow 



save "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\NATIONAL ASSEMBLY OF PAKISTAN 2013.dta"

clear 

import excel "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\PTY2013.xlsx", sheet("BALOCHISTAN ASSEMBLY") firstrow

save "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\BALOCHISTAN ASSEMBLY 2013.dta"

clear

import excel "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\PTY2013.xlsx", sheet("PUNJAB ASSEMBLY") firstrow

save "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\PUNJAB ASSEMBLY 2013.dta"



clear

import excel "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\PTY2013.xlsx", sheet("SINDH ASSEMBLY") firstrow

save "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\SINDH ASSEMBLY 2013.dta"


clear

import excel "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\PTY2013.xlsx", sheet("KP ASSEMBLY") firstrow

save "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\KP ASSEMBLY 2013.dta"


***********************************
*************Appending*************
***********************************
clear



use "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\SENATE OF PAKISTAN 2013.dta" 

append using "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\NATIONAL ASSEMBLY OF PAKISTAN 2013.dta"  



append using "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\BALOCHISTAN ASSEMBLY 2013.dta" 



append using "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\PUNJAB ASSEMBLY 2013.dta"




append using "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\SINDH ASSEMBLY 2013.dta"



append using "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\KP ASSEMBLY 2013.dta" 

save "D:\MacroPolicy Lab PIDE\Tax Directory\Parliamentarians_2013_18\2013\Appended 2013.dta"


