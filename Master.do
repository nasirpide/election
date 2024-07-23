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
/*
	ssc install dataex, replace 
	ssc install myaxis, replace
	ssc install catplot, replace
	ssc install scheme-burd, replace
	
	
//Graph setting//
	graph set window fontface "Times New Roman"	
	grstyle init
	grstyle set plain, grid
	grstyle set color d3
	grstyle set legend 2
	grstyle set graphsize 7cm 10cm
	grstyle set size 4pt: heading
	grstyle set size 3pt: subheading axis_title
	grstyle set size 3pt: tick_label key_label
	grstyle set symbolsize 3 4 5, pt
	grstyle set linewidth .4pt: plineplot
	grstyle set linewidth .3pt: legend axisline tick major_grid
	grstyle set linewidth 0: pmark
	grstyle set margin zero	
