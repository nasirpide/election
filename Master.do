clear all

*--------------------------------
* Set up
*--------------------------------

* User Number:

* Nasir Iqbal 			(NI)           	1
* Amna Raiz 			(AR)         	2


*Set this value to the user currently using this file
global user  2

* Root folder globals
* ---------------------

if $user == 1 {
	global gitgub		"/Users/drnasiriqbal/Documents/GitHub/npgp/"
	global dropbox		"/Users/drnasiriqbal/Dropbox/NPGP_Project/02_data/"
    }


if $user == 2 {
	global github		"C:\Users\Administrator\Documents\GitHub\election\"
	global dropbox		"C:\Users\Administrator\Dropbox\Election"
}


********************************************************************************
*project folder globals
	global data			 		"$dropbox/data/surveydata.dta" 
	global res 					"$dropbox/results"

	
*******packhages installed 

	ssc install dataex, replace 
	ssc install myaxis, replace
 