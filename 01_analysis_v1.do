*name 					Cleaning File: Raw data
*Data Source:			survey data: Politics and social media
*Date created: 			12/12 2023
*Creator:				Sohaib Jalal
********************************************************************************
	global data "/Users/drnasiriqbal/Library/CloudStorage/Dropbox/Election/data"
	global result "/Users/drnasiriqbal/Library/CloudStorage/Dropbox/Election/results"

	*do "C:\Users\Administrator\Documents\GitHub\election\Master.do"
	
	global TAB "/Users/drnasiriqbal/Library/CloudStorage/Dropbox/Apps/Overleaf/Election and Voting/tables"
	global FIG "/Users/drnasiriqbal/Library/CloudStorage/Dropbox/Apps/Overleaf/Election and Voting/figures"
********************************************************************************
**Read Survey Data
	*use "$data/surveydata.dta", clear 
		use "$data/surveydata.dta", clear
**************************
*CLEANING
***************************
quietly{
*Consent
	tab A1,missing     				// 638 interested // 4 Not interested // 1 missing
	drop if A1==2|A1==.a			// 5 obs droped (not Interested), or missing remaining obs: 639
*********************
**DEMOGRAPHICS**
*Region
	tab A3, missing			// Rural 129 // Urban 507 // 2 missing values
	drop if A3==.a			// 2 obs deleted, remaining obs: 636
*City
	tab A4, missing			// Islamabad 359 // Rawalpindi 274 // 3 missing
	drop if A4==.a			// 3 0bs deleted, remaining 633
*Gender
	tab D1_1, missing		// Male 530		// Female 103
*Age
	label var D0 "Age of Respondent"
	tab D0, missing					// 2 unrealistic values < 18 // Range 2-72
	drop if D0<18
*Education
	tab D5, missing 				// No missing values // Multiple categories
*Employement
	tab D2, missing					// No missing values // Multiple Values
********************
	drop interview__key interview__id date_time //drop extra variables
	drop w1 sssys_irnd has__errors interview__status assignment__id //drop extra variables
}
********************************************************************************
****Demographic characteristics 
********************************************************************************
quietly{
	genl GENDER=(D1_1==1), label(Gender of respondent)
	
	gen AGE_CAT=1 if D0<=23
	replace AGE_CAT=2 if D0>23&D0<=30
	replace AGE_CAT=3 if D0>30&D0<=40
	replace AGE_CAT=4 if D0>40&D0!=.
	label variable AGE_CAT "Age catagories"
	label define age_cat 1 "New Entrant Youth" 2 "Youth" 3 "Mid Carear" 4 "Senior", replace
	label values AGE_CAT age_cat
	
	gen EDU_CAT=1 if D5<=4
	replace EDU_CAT=2 if D5==5|D5==6
	replace EDU_CAT=3 if D5==7
	replace EDU_CAT=4 if D5==8|D5==9
	
	label variable EDU_CAT "Education catagories"
	label define edu_cat 1 "Matric or less" 2 "Secondary" 3 "Bechlor" 4 "Master/PhD", replace
	label values EDU_CAT edu_cat

	gen EMP_CAT=1 if D2==1|D2==2
	replace EMP_CAT=2 if D2==3
	replace EMP_CAT=3 if D2==5
	replace EMP_CAT=4 if EMP_CAT==.&D2!=.
	label variable EMP_CAT "Employment catagories"
	label define emp_cat 1 "Employeed" 2 "Business" 3 "Student" 4 "Labor/Others", replace
	label values EMP_CAT emp_cat
	
	genl REGION=(A3==1), label(Region 1: URBAN; 0 Rural)
	drop D0 D1_1 D2 D5 A3 A1 A4 A2 D5_other D2_other A11 a11_other
}
********************************************************************************
********************************************************************************
********************************************************************************

********************************************************************************
**VOTING DECISIONS & PRACTICES**
********************************************************************************
quietly{
*Voting_last elections
	tab s51, missing				// No missing values //Yes 369 //262//PNS 2
	genl VOTED2018 =(s51==1), label (Voted in last general election 2018)
	label define yes_no 1 "Yes" 0 "No"
	label value VOTED2018 yes_no
*Party Voted_Last Elections
	tab s52, missing				// No missing value // PT1 205, PMLN 93 PPP 27
	tab s52 s51
*Reason_not voting
	tab s53, missing				// No missing value // not registered 159, busy 50
	tab s53 s51
	gen NOT_VOTE_2018= 1 if s53==2&VOTED2018==0
	replace NOT_VOTE_2018= 2 if s53==3|s53==4|s53==5|s53==6|s53==7|s53==10&VOTED2018==0
	replace NOT_VOTE_2018= 3 if NOT_VOTE_2018==.&VOTED2018==0
	
	label variable NOT_VOTE_2018  "Reasons Not Voted in Election 2018"
	label define reasons 1 "Not Registered" 2 "No Trust on Election" 3 "Personal Reasons", replace
	label values NOT_VOTE_2018 reasons
	
*vote_next elections
	tab s54, missing				// No missing value // Yes 519, No 85 ND, 29 // .a??
	replace s54=. if s54==.a
	genl VOTE2024 =(s54==1), label (Will vote in election 2024)
	tab VOTE2024
*reason_not vote NE				
	tab s55, missing				// No missing value // Lack of trust in politician 27
	tab s55 s54
	
	gen NOT_VOTE_2024= 1 if s55==1&VOTE2024==0
	replace NOT_VOTE_2024= 2 if s55==3|s55==4|s55==5|s55==6|s55==7|s55==8|s55==9&VOTE2024==0
	replace NOT_VOTE_2024= 3 if NOT_VOTE_2024==.&VOTE2024==0
	label variable NOT_VOTE_2024  "Reasons Not Vote in Election 2024"
	label values NOT_VOTE_2024 reasons

*reason_vote NE
	tab s56, missing				// 518 values < 519 (yes) // citizen responsibality
	replace s56=. if s56==.a
	tab s56 s54	
	*edit if s56==. & s54==1 // id_code 504 has missing value in s56. 
	
	gen WHY_VOTE2024=1 if s56==1&VOTE2024==1
	replace WHY_VOTE2024=2 if s56==2|s56==3|s56==5&VOTE2024==1
	replace WHY_VOTE2024=3 if s56==6|s56==7&VOTE2024==1
	replace WHY_VOTE2024=4 if s56==8&VOTE2024==1
	replace WHY_VOTE2024=5 if WHY_VOTE2024==.&VOTE2024==1
	label variable WHY_VOTE2024 "Why to vote in 2024"
	label define why_vote 1 "Civic Duty" 2 "Bring Positive Change" 3 "Support Party/Candidate" 4 "Democracy" 5 "Others", replace
	label values WHY_VOTE2024 why_vote
	
*party vote_NE
	label var s57 "which party do you intend to vote in the upcomming elections?"
	tab s57, missing				//545 values // PTI 310, pmln 94 ppp 34, 42 undecided voter
	replace s57=. if s57==.a
	genl PARTY_VOTE=s57 if VOTE2024==1, label(IF vote in 2024, which party)
*reason_vote candidate			
	tab s58, missing				// No missing value // party affiliation 274
	replace s58=. if s58==.a
	tab s58 if s57!=.
	gen VOTE_CANDIDATE=1 if s58==1&s58!=.
	replace VOTE_CANDIDATE=2 if s58==2&s58!=.
	replace VOTE_CANDIDATE=3 if s58==4&s58!=.
	replace VOTE_CANDIDATE=4 if s58==3|s58==999&s58!=.
	label variable VOTE_CANDIDATE "Deciding factors while voting a candidate"
	label define candidate 1 "Party Affiliation" 2 "Candidate him/herself" 3 "Past performace" 4 "Personal connection/others", replace
	label values VOTE_CANDIDATE candidate
	
	drop s51-s58 s58_other
	
*reason_vote candidate
	tab s61, missing				// No missing value // Leader of the party
	replace s61=. if s61==.a
	gen VOTE_PARTY =1 if s61==1&s61!=.
	replace VOTE_PARTY =2 if s61==2&s61!=.
	replace VOTE_PARTY =3 if s61==3&s61!=.
	replace VOTE_PARTY =4 if s61==4|s61==999&s61!=.
	label variable VOTE_PARTY "Deciding factors while voting a party"
	label define party 1 "Head" 2 "Past Performance" 3 "Vision" 4 "Reform Agenda/Plan", replace
	label values VOTE_PARTY party	
	
**PERCEPTION ABOUT UPCOMMING ELECTIONS**

*political stability
	tab s62, missing			// missing value issue // Yes 266, No 224, NS 114
	replace s62=. if s62==.a
	genl POL_STABILITY=(s62==1), label(Political Stability Perception (Binary) in 2024: 1 Yes; 0 Otherwise)
*economic condition
	tab s63, missing			// missing value issue // Yes 284, No 202, NS 113
	replace s63=. if s63==.a
	genl ECON_IMPROVEMENT=(s63==1), label(Economic Improvement Perception (Binary) in 2024: 1 Yes; 0 Otherwise)
*election transparency		
	tab s64, missing			// ==		// Yes 102, No 404, NS 95
	replace s64=. if s64==.a
	genl TRUST_ELECTIONS=(s64==1), label(Trust in Fairness of Elections (Binary) in 2024: 1 Yes; 0 Otherwise)
*equal opportunity
	tab s65, missing			//no missing value // Yes 171, No 397
	replace s65=. if s65==.a
	genl EQUAL_OPP=(s65==1), label(Equal Opportunties to all parties (Binary) in 2024: 1 Yes; 0 Otherwise)
	
	drop s61 s61_other s62 s63 s64 s65
}

********************************************************************************
****Use of Social media  in politics
********************************************************************************
quietly{
	genl SOCIAL_MEDIA=(K1==1), label(Social Media used 1 YES, 0 NO)
	rename K2 Reason_Not_Using_Social_Media
	replace Reason_Not_Using_Social_Media=5 if Reason_Not_Using_Social_Media==999 //Other repalced 999 with 5

	
	foreach var in 1 2 3 4 5 6 7 8 9 999{
	replace K3__`var'=0 if K3__`var'==.a | K3__`var'==. & SOCIAL_MEDIA==1 //cross check and replace . & .a as no response 
}
	rename 	(K3__1 K3__2 K3__3 K3__4 K3__5 K3__6 K3__7 K3__8 K3__9 K3__999) ///
			(Facebook TwitterX Instagram Whatsapp TikTok YouTube Snapchat Telegram Linkedin OthersSM)
	replace OthersSM=1 if Snapchat==1|Telegram==1|Linkedin==1 //Combine small catgories in others [(30 real changes made)]
	drop Snapchat Telegram Linkedin
	
	foreach v of varlist Facebook TwitterX Instagram Whatsapp TikTok YouTube OthersSM{
	label variable `v' "Social Media Platform: `v'"
}

	rename (K6__1 K6__2 K6__3 K6__4 K6__5 K6__6 K6__7 K6__8 K6__9) ///
			(Text Podcasts Infographics Video Audio Articles LiveStreaming UserGenerated OthersMeans)
	replace OthersMeans=1 if Infographics==1|Audio==1|UserGenerated==1
	drop Infographics Audio UserGenerated
			
	foreach v of varlist Text Podcasts Video Articles LiveStreaming OthersMeans{
	label variable `v' "Source to obtain political information/news: `v'"
}

	rename (K5 K5_1 K5_2 K5_3 K5_4 K5_5) (Facebook_use TwitterX_use Instagram_use Whatsapp_use TikTok_use YouTube_use)
	foreach v of varlist Facebook_use TwitterX_use Instagram_use Whatsapp_use TikTok_use YouTube_use{
	label variable `v' "How often `v' for political information/news"
}
	
	rename 	(K7__1 K7__2 K7__3 K7__4 K7__5 K7__6 K7__7) ///
			(Like Share Read Comment Participate CreateContent OthersWays)   
	replace OthersWays=1 if Participate==1 | CreateContent==1
	drop Participate CreateContent
	
	foreach v of varlist Like Share Read Comment OthersWays{
	label variable `v' "Ways to engage with political information on SM: `v'"
}
	rename K4 Preferred_Social_Media
	drop K2_other K1 K5_6 K5_7 K5_8
}


********************************************************************************
****Political Engagement and Advocacy on social media
********************************************************************************
quietly{
*share post on social media
	genl Sharing_POST =(T1!=1) if SOCIAL_MEDIA==1, label(Sharing/Posting Information 1 Yes; 0 Otherwise)
*promote political party
	genl Promote_PARTY=(T2!=1) if SOCIAL_MEDIA==1, label(Promote any political party; 1 Yes; 0 Otherwise)
*Promote political candidate 
	genl Promote_CANDIDATE=(T3!=1) if SOCIAL_MEDIA==1, label(Promote any political candidate; 1 Yes; 0 Otherwise)
*attend online political events/jalsas
	genl Online_EVENT=(T4!=1) if SOCIAL_MEDIA==1, label(Attend online political event; 1 Yes; 0 Otherwise)
*political discussion and debate 
	genl Political_DEBATE=(T5!=1) if SOCIAL_MEDIA==1, label(Engage in political debate; 1 Yes; 0 Otherwise)
	
	drop T1-T5
}

********************************************************************************
****Political Influence of social media
********************************************************************************
quietly{
*social media influence political engagements
	genl Influence_PE=(X1!=1) if SOCIAL_MEDIA==1, label(social media influence your political engagements; 1 Yes; 0 Otherwise)
*change support
	genl ChangeSupport=(X11!=1) if SOCIAL_MEDIA==1, label(changed political support due to social media; 1 Yes; 0 Otherwise)
*choosing better voting candidate
	genl Better_VC=(X2!=1) if SOCIAL_MEDIA==1, label(social media helps choosing better voting candidate; 1 Yes; 0 Otherwise)
*increased political awarness
	genl Awarness=(X3!=1) if SOCIAL_MEDIA==1, label(social media increased political awarness; 1 Yes; 0 Otherwise)
*In your opinion, how has social media influenced overall political activity in Pakistan?
	genl POL_ACTIVITES_INFLUENCE=(X4==4|X4==5) if SOCIAL_MEDIA==1, label(social media influenced overall political activity; 1 Positive; 0 Otherwise)
* Do you think Political parties who are more active on social media have higher chances of winning the upcoming general elections in Pakistan?	
	genl Election_WIN=(X5==1) if SOCIAL_MEDIA==1, label(party who are more active on social media will win elections 1 Yes; 0 Otherwise)
*Do you believe that social media contributes to political polarization in Pakistan?
	genl POL_Polarization=(X6==1|X6==2) if SOCIAL_MEDIA==1, label(Social media contribute to political polarization; 1 Positive; 0 Otherwise)
	
	drop X1 X11 X2 X3 X4 X5 X6
}

********************************************************************************
****Trust in social media
********************************************************************************
quietly{
* To what extent do you trust the political information and news you come across on social media platforms?
	genl TRUST_SM_INF=(J1==3|J1==4|J1==5) if SOCIAL_MEDIA==1, label(trust the political information on SM 1 Yes, 0 otherwise)
*  Do you verify political news and information on social media before sharing with others?
	genl SM_INF_VARIFY=(J2==4|J2==5) if SOCIAL_MEDIA==1, label(Varify politcal information/new on SM 1 Yes, 0 otherwise)
* Which one do you believe is a more reliable source of political information?
	rename J3 RELIABLE_MEDIA_SOURCE
	
	drop J1 J2
}


********************************************************************************
****Scenario 1: Exposure to Political Advertisements on Social Media
/*
Imagine you come across a sponsored political advertisement on your social media feed. 
The ad promotes a candidate for an upcoming election. 
The content of the ad highlights the candidate's achievements and policy promises. 
After seeing this advertisement:
*/
********************************************************************************
quietly{
* To what extent do you find yourself more inclined to support the promoted candidate?
	recode J4 (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1), generate(Engagement_Likelihood)	
	label variable Engagement_Likelihood "Engagement Likelihood"
	label define engagement_labels 	1 "Much less inclined" ///
									2 "Somewhat less inclined" ///
									3 "Neutral" ///
									4 "Somewhat more inclined" ///
									5 "Much more inclined", replace
	label values Engagement_Likelihood engagement_labels

* Would you be more likely to share or engage with the content of this political advertisement on social media?
	recode J5 (1 = 4) (2 = 3) (3 = 2) (4 = 1), generate(Sharing_Likelihood)	
	label variable Sharing_Likelihood "Sharing Likelihood"
	label define sharing_labels 	1 "No, definitely not" ///
									2 "No, probably not" ///
									3 "Yes, to some extent" ///
									4 "Yes, definitely", replace
	label values Sharing_Likelihood sharing_labels

********************************************************************************
/*Scenario 2: Exposure to Differing Political Opinions in Social Media Feed
Suppose you encounter a social media post shared by a friend expressing support for a political party or candidate that you don't usually align with. 
The post presents well-reasoned arguments and facts supporting their perspective. After seeing this post:
*/
********************************************************************************
* To what extent does the content of the post influence your opinion on the political party or candidate being supported?
	recode J6 (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1), generate(Influence_Extent)	
	label variable Influence_Extent "Influence Extent"
	label define influence_labels 	1 "Does not influence at all" ///
									2 "Minimally influences" ///
									3 "Neutral" ///
									4 "Moderately influences" ///
									5 "Significantly influences", replace
	label values Influence_Extent influence_labels

* How likely are you to engage in a respectful discussion or share counter-arguments in response to this post?
	recode J7 (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1), generate(Engagement_Respectful)	
	label variable Engagement_Respectful "Engagement Respectful"
	label define engage_labels 	1 "Not likely at all" ///
								2 "Not very likely" ///
								3 "Neutral" ///
								4 "Somewhat likely" ///
								5 "Very likely", replace

	label values Engagement_Respectful engage_labels
	
	drop J4 J5 J6 J7
}
	


*********************************************************************************
*********************************************************************************
******Empirical Analyis for Paper
*********************************************************************************
*********************************************************************************
eststo clear
	global COVS "i.AGE_CAT i.EDU_CAT i.EMP_CAT"
	global FE "REGION"
	global PATH "VOTED2018"
*Table 1: Impact of social media use for politcal informion on intend to vote
	qui eststo: logistic VOTE2024 SOCIAL_MEDIA $PATH, vce(robust)
		local CHI = e(chi2)
		qui estadd scalar CHI `CHI'
		local OBS = e(N)
		qui estadd scalar OBS `OBS'
	qui eststo: logistic VOTE2024 SOCIAL_MEDIA $COVS $PATH, vce(robust)
		local CHI = e(chi2)
		qui estadd scalar CHI `CHI'
		local OBS = e(N)
		qui estadd scalar OBS `OBS'		
	qui eststo: logistic VOTE2024 SOCIAL_MEDIA $FE $PATH, vce(robust)
		local CHI = e(chi2)
		qui estadd scalar CHI `CHI'
		local OBS = e(N)
		qui estadd scalar OBS `OBS'			
	qui eststo: logistic VOTE2024 SOCIAL_MEDIA $COVS $FE $PATH, vce(robust)
		local CHI = e(chi2)
		qui estadd scalar CHI `CHI'
		local OBS = e(N)
		qui estadd scalar OBS `OBS'			
		
	esttab  using "$TAB/TABLE1.tex", replace style(tex) keep(SOCIAL_MEDIA)  substitute(\_ _) ///
			ml( ,none) collabels(, none) cells(b(star fmt(%9.3f)) se(par)) eform stats(CHI OBS, fmt(%9.2fc %9.0fc) ///
			labels("\addlinespace Wald chi2" "\addlinespace Observations" )) ///
			order(SOCIAL_MEDIA) starlevels(* 0.10 ** 0.05 *** 0.01) ///
			label varlabels(_cons "Constant" SOCIAL_MEDIA "SM")
	eststo clear		

	
*Table 2: Social media platform and intend to vote
	eststo clear
foreach var in Facebook TwitterX Instagram Whatsapp TikTok YouTube{
		gen SM=`var'
		replace SM=. if SM==0&SOCIAL_MEDIA==1
		replace SM=0 if SM==.&SOCIAL_MEDIA==0
		qui eststo: logistic VOTE2024 SM $COVS $FE $PATH, vce(robust)
		local CHI = e(chi2)
		qui estadd scalar CHI `CHI'
		local OBS = e(N)
		qui estadd scalar OBS `OBS'
		drop SM
}

		
	esttab  using "$TAB/TABLE2.tex", replace style(tex) keep(SM)  substitute(\_ _) ///
			ml( ,none) collabels(, none) cells(b(star fmt(%9.3f)) se(par)) eform stats(CHI OBS, fmt(%9.2fc %9.0fc) ///
			labels("\addlinespace Wald chi2" "\addlinespace Observations" )) ///
			order(SM) starlevels(* 0.10 ** 0.05 *** 0.01) ///
			label varlabels(_cons "Constant" SM "SM")
eststo clear	


* Table 3: Types of Social Media Users and Intend to Vote

*Active vs Passive social media users
	gen ACTIVE_SM_USER=(Facebook_use==1| TwitterX_use==1| Instagram_use==1| Whatsapp_use==1| TikTok_use==1| YouTube_use==1) if SOCIAL_MEDIA==1
	gen ACTIVE=1 if ACTIVE_SM_USER==1|SOCIAL_MEDIA==0
	gen PASSIVE=1 if ACTIVE_SM_USER==0|SOCIAL_MEDIA==0
*Trust vs No Trust
	gen TRUST=1 if TRUST_SM_INF==1|SOCIAL_MEDIA==0
	gen NOTRUST=1 if TRUST_SM_INF==0|SOCIAL_MEDIA==0
*Social media is reliable then other media outlets
	 gen RELIABLE_SM=(RELIABLE_MEDIA_SOURCE==3|RELIABLE_MEDIA_SOURCE==4) if SOCIAL_MEDIA==1
	 gen RELIABLE=1 if RELIABLE_SM==1|SOCIAL_MEDIA==0
	 gen NORELIABLE=1 if RELIABLE_SM==0|SOCIAL_MEDIA==0
		

	eststo clear
foreach var in ACTIVE PASSIVE TRUST NOTRUST RELIABLE NORELIABLE{
		qui eststo: logistic VOTE2024 SOCIAL_MEDIA $COVS $FE $PATH if `var'==1, vce(robust)
		local CHI = e(chi2)
		qui estadd scalar CHI `CHI'
		local OBS = e(N)
		qui estadd scalar OBS `OBS'
}
	esttab  using "$TAB/TABLE3.tex", replace style(tex) keep(SOCIAL_MEDIA)  substitute(\_ _) ///
			ml( ,none) collabels(, none) cells(b(star fmt(%9.3f)) se(par)) eform stats(CHI OBS, fmt(%9.2fc %9.0fc) ///
			labels("\addlinespace Wald chi2" "\addlinespace Observations" )) ///
			order(SOCIAL_MEDIA) starlevels(* 0.10 ** 0.05 *** 0.01) ///
			label varlabels(_cons "Constant" SOCIAL_MEDIA "SM")
eststo clear	
	drop ACTIVE_SM_USER ACTIVE PASSIVE NOTRUST RELIABLE_SM RELIABLE NORELIABLE TRUST
		
/*		
* Table 4: Sources to obtain information/news on SM and Intend to Vote
	eststo clear
foreach var in Text Podcasts Video Articles LiveStreaming OthersMeans{
		gen SM=`var'
		 eststo: logistic VOTE2024 SM $COVS $FE, vce(robust)
		local CHI = e(chi2)
		qui estadd scalar CHI `CHI'
		local OBS = e(N)
		qui estadd scalar OBS `OBS'
		drop SM
}
	esttab  using "$TAB/TABLE4.tex", replace style(tex) keep(SM)  substitute(\_ _) ///
			ml( ,none) collabels(, none) cells(b(star fmt(%9.3f)) se(par)) eform stats(CHI OBS, fmt(%9.2fc %9.0fc) ///
			labels("\addlinespace Wald chi2" "\addlinespace Observations" )) ///
			order(SM) starlevels(* 0.10 ** 0.05 *** 0.01) ///
			label varlabels(_cons "Constant" SM "Source")
eststo clear

*/

	eststo clear
foreach var in Like Share Read Comment OthersWays{
		gen SM=`var'
		eststo: logistic VOTE2024 SM $COVS $FE $PATH, vce(robust)
		local CHI = e(chi2)
		qui estadd scalar CHI `CHI'
		local OBS = e(N)
		qui estadd scalar OBS `OBS'
		drop SM
}
	esttab  using "$TAB/TABLE5.tex", replace style(tex) keep(SM)  substitute(\_ _) ///
			ml( ,none) collabels(, none) cells(b(star fmt(%9.3f)) se(par)) eform stats(CHI OBS, fmt(%9.2fc %9.0fc) ///
			labels("\addlinespace Wald chi2" "\addlinespace Observations" )) ///
			order(SM) starlevels(* 0.10 ** 0.05 *** 0.01) ///
			label varlabels(_cons "Constant" SM "Means")
eststo clear


* Table 6: Role of social media in choosing candidate and party
	tab VOTE_CANDIDATE, gen(CANDIDATE)
	tab VOTE_PARTY, gen(PARTY)
eststo clear
	foreach var in 1 2 3 4{
		eststo: logistic CANDIDATE`var' SOCIAL_MEDIA $COVS $FE $PATH, vce(robust)
		local CHI = e(chi2)
		qui estadd scalar CHI `CHI'
		local OBS = e(N)
		qui estadd scalar OBS `OBS'
	}

esttab  using "$TAB/TABLE6A.tex", replace style(tex) keep(SOCIAL_MEDIA)  substitute(\_ _) ///
			ml( ,none) collabels(, none) cells(b(star fmt(%9.3f)) se(par)) eform stats(CHI OBS, fmt(%9.2fc %9.0fc) ///
			labels("\addlinespace Wald chi2" "\addlinespace Observations" )) ///
			order(SOCIAL_MEDIA) starlevels(* 0.10 ** 0.05 *** 0.01) ///
			label varlabels(_cons "Constant" SOCIAL_MEDIA "SM")
eststo clear

eststo clear
	foreach var in 1 2 3 4{
		eststo: logistic PARTY`var' SOCIAL_MEDIA $COVS $FE $PATH, vce(robust)
		local CHI = e(chi2)
		qui estadd scalar CHI `CHI'
		local OBS = e(N)
		qui estadd scalar OBS `OBS'
	}

esttab  using "$TAB/TABLE6B.tex", replace style(tex) keep(SOCIAL_MEDIA)  substitute(\_ _) ///
			ml( ,none) collabels(, none) cells(b(star fmt(%9.3f)) se(par)) eform stats(CHI OBS, fmt(%9.2fc %9.0fc) ///
			labels("\addlinespace Wald chi2" "\addlinespace Observations" )) ///
			order(SOCIAL_MEDIA) starlevels(* 0.10 ** 0.05 *** 0.01) ///
			label varlabels(_cons "Constant" SOCIAL_MEDIA "SM")
eststo clear
	
	drop CANDIDATE1 CANDIDATE2 CANDIDATE3 CANDIDATE4 PARTY1 PARTY2 PARTY3 PARTY4

eststo clear
foreach var in POL_STABILITY ECON_IMPROVEMENT TRUST_ELECTIONS EQUAL_OPP{
		eststo: logistic `var' SOCIAL_MEDIA $COVS $FE $PATH, vce(robust)
		local CHI = e(chi2)
		qui estadd scalar CHI `CHI'
		local OBS = e(N)
		qui estadd scalar OBS `OBS'
}
	esttab  using "$TAB/TABLE7.tex", replace style(tex) keep(SOCIAL_MEDIA)  substitute(\_ _) ///
			ml( ,none) collabels(, none) cells(b(star fmt(%9.3f)) se(par)) eform stats(CHI OBS, fmt(%9.2fc %9.0fc) ///
			labels("\addlinespace Wald chi2" "\addlinespace Observations" )) ///
			order(SOCIAL_MEDIA) starlevels(* 0.10 ** 0.05 *** 0.01) ///
			label varlabels(_cons "Constant" SOCIAL_MEDIA "SM")
eststo clear


	eststo clear
foreach var in Sharing_POST Promote_PARTY Promote_CANDIDATE Online_EVENT Political_DEBATE{
		gen SM=`var'
		eststo: logistic VOTE2024 SM $COVS $FE $PATH, vce(robust)
		local CHI = e(chi2)
		qui estadd scalar CHI `CHI'
		local OBS = e(N)
		qui estadd scalar OBS `OBS'
		drop SM
}
	esttab  using "$TAB/TABLE8.tex", replace style(tex) keep(SM)  substitute(\_ _) ///
			ml( ,none) collabels(, none) cells(b(star fmt(%9.3f)) se(par)) eform stats(CHI OBS, fmt(%9.2fc %9.0fc) ///
			labels("\addlinespace Wald chi2" "\addlinespace Observations" )) ///
			order(SM) starlevels(* 0.10 ** 0.05 *** 0.01) ///
			label varlabels(_cons "Constant" SM "Nature")
eststo clear

***factors that infleunce particiaption linked with media

	eststo clear
foreach var in Influence_PE ChangeSupport Better_VC Awarness{
		gen SM=`var'
		eststo: logistic VOTE2024 SM $COVS $FE $PATH, vce(robust)
		local CHI = e(chi2)
		qui estadd scalar CHI `CHI'
		local OBS = e(N)
		qui estadd scalar OBS `OBS'
		drop SM
}
	esttab  using "$TAB/TABLE9.tex", replace style(tex) keep(SM)  substitute(\_ _) ///
			ml( ,none) collabels(, none) cells(b(star fmt(%9.3f)) se(par)) eform stats(CHI OBS, fmt(%9.2fc %9.0fc) ///
			labels("\addlinespace Wald chi2" "\addlinespace Observations" )) ///
			order(SM) starlevels(* 0.10 ** 0.05 *** 0.01) ///
			label varlabels(_cons "Constant" SM "Nature")
eststo clear

****Experiment based questions tables

		*Active vs Passive social media users
	gen ACTIVE_SM_USER=(Facebook_use==1| TwitterX_use==1| Instagram_use==1| Whatsapp_use==1| TikTok_use==1| YouTube_use==1) if SOCIAL_MEDIA==1
	gen RELIABLE_SM=(RELIABLE_MEDIA_SOURCE==3|RELIABLE_MEDIA_SOURCE==4) if SOCIAL_MEDIA==1
	
foreach var in Engagement_Likelihood Sharing_Likelihood Influence_Extent Engagement_Respectful{
	recode `var' (1/2=1 "less") (3=2 "neutral") (4/5=3 "high")  , gen (`var'_N)
}
	tab AGE_CAT, gen(AGE)
	tab EDU_CAT, gen(EDU)
	tab EMP_CAT, gen(EMP)
			
eststo clear
foreach var in Engagement_Likelihood_N Sharing_Likelihood_N Influence_Extent_N Engagement_Respectful_N{
		eststo: ologit `var' ACTIVE_SM_USER TRUST_SM_INF RELIABLE_SM AGE1 AGE2 AGE3 EDU2 EDU3 EDU4 EMP1 EMP2 EMP3 $PATH, vce(robust)
		local CHI = e(chi2)
		qui estadd scalar CHI `CHI'
		local OBS = e(N)
		qui estadd scalar OBS `OBS'
	foreach o in 1 2 3 {
		quietly margins, dydx(*) predict(outcome(`o')) post
		eststo, title(Outcome `o')
		estimates restore est1
}	
	esttab  using "$TAB/`var'.tex", replace style(tex) substitute(\_ _) ///
			ml( ,none) collabels(, none) cells(b(star fmt(%9.3f)) se(par)) noobs stats(CHI OBS, fmt(%9.2fc %9.0fc) ///
			labels("\addlinespace Wald chi2" "\addlinespace Observations" )) ///
			 starlevels(* 0.10 ** 0.05 *** 0.01) ///
			label varlabels(_cons "Constant" ACTIVE_SM_USER "Active User")
eststo clear
}
	drop AGE1 AGE2 AGE3 AGE4 EDU1 EDU2 EDU3 EDU4 EMP1 EMP2 EMP3 EMP4

********************************************************************************
****Appendix Tables 
********************************************************************************
********************************************************************************

*Appnedix Table 1, 2 3: Impat of SM on Intend to Vote 
	tab AGE_CAT, gen(AGE)
	tab EDU_CAT, gen(EDU)
	tab EMP_CAT, gen(EMP)
eststo clear
foreach CAT in AGE EDU EMP{
	foreach var in 1 2 3 4{
		eststo: logistic VOTE2024 SOCIAL_MEDIA $FE $PATH if `CAT'`var'==1, vce(robust)
		local CHI = e(chi2)
		qui estadd scalar CHI `CHI'
		local OBS = e(N)
		qui estadd scalar OBS `OBS'
	}	
esttab  using "$TAB/`CAT'.tex", replace style(tex) keep(SOCIAL_MEDIA)  substitute(\_ _) ///
			ml( ,none) collabels(, none) cells(b(star fmt(%9.3f)) se(par)) eform stats(CHI OBS, fmt(%9.2fc %9.0fc) ///
			labels("\addlinespace Wald chi2" "\addlinespace Observations" )) ///
			order(SOCIAL_MEDIA) starlevels(* 0.10 ** 0.05 *** 0.01) ///
			label varlabels(_cons "Constant" SOCIAL_MEDIA "SM")
eststo clear
}



*********************************************************************************
*********************************************************************************
******Descriptive analysis
*********************************************************************************
*********************************************************************************
	*Use of social media for poltical information across age group 
	preserve
	set scheme s2color
	replace SOCIAL_MEDIA=SOCIAL_MEDIA*100
	label define media 0 "No Social Media" 1 "Social Media", replace
	label values SOCIAL_MEDIA media
	label define gender 1 "Male" 0 "Female", replace
	label values GENDER gender
	label define vote_labels 0 "Not Intending to Vote" 1 "Intending to Vote", replace
	label values VOTE2024 vote_labels

		graph bar (mean) VOTE2024 VOTED2018 , over(AGE_CAT)

*Voter Intentions Surge: A Comparative Analysis (2018 vs. 2024)
	replace VOTE2024=VOTE2024*100
	replace VOTED2018=VOTED2018*100
	
	graph hbar (mean) VOTED2018 VOTE2024, over(AGE_CAT, label(labsize(small))) ///
			ytitle("Intending to Vote (%)", size(small)) ///
			blabel(total, position(outside) color(blue) format(%9.1f)) ///
			ylabel(, angle(horizontal) labsize(small)) ///
			legend(rows(1) stack size(small) order(1 "Voted in 2018" 2 "Intending to Vote in 2024"))
	graph export "$FIG/SMTYPE_VOTE.pdf", as(pdf) replace

	graph pie, over(VOTE_CANDIDATE) plabel(_all percent, size(small) format(%4.0g)) legend(on span  size(small)) plegend(off)
	graph export "$FIG/VOTE_CANDIDATE.pdf", as(pdf) replace
	
	graph pie, over(VOTE_PARTY) plabel(_all percent, size(small) format(%4.0g)) legend(on span  size(small)) plegend(off)
	graph export "$FIG/VOTE_PARTY.pdf", as(pdf) replace	
	
	graph hbar (mean) SOCIAL_MEDIA , over(GENDER, label(labsize(small))) ///
		ytitle("Social Media Usage Percentage (%)", size(small)) ///
		blabel(total, position(inside) color(bg) format(%9.1f)) ///
		ylabel(, angle(horizontal) labsize(small))
	graph export "$FIG/SM_GENDER.pdf", as(pdf) replace		

	mrgraph bar Facebook TwitterX Instagram Whatsapp TikTok YouTube, by(GENDER,label(labsize(small))) ///
			include response( 100) width(10) stat(column) ytitle("Social Media Usage Percentage (%)", size(small)) ylabel(, labsize(small))  ///
			blabel(total, position(inside) color(bg) format(%9.1f) size(small))
	graph export "$FIG/SMTYPE_GENDER.pdf", as(pdf) replace		
	
* Intention to Vote by Social Media Use and Age Group
	graph bar (mean) SOCIAL_MEDIA , over(AGE_CAT, label(labsize(small))) ///
			ytitle("Social Media Usage Percentage (%)", size(small)) ///
			over(VOTE2024 , label(labsize(small))) ///
			blabel(total, position(inside) color(bg) format(%9.1f)) ///
			ylabel(, angle(horizontal) labsize(small))
	graph export "$FIG/SM_AGE_VOTE.pdf", as(pdf) replace

			
	graph bar (mean) SOCIAL_MEDIA , over(EDU_CAT, label(labsize(small))) ///
			ytitle("Social Media Usage Percentage (%)", size(small)) ///
			over(VOTE2024 , label(labsize(small))) ///
			blabel(total, position(inside) color(bg) format(%9.1f)) ///
			ylabel(, angle(horizontal) labsize(small))
	graph export "$FIG/SM_EDU_VOTE.pdf", as(pdf) replace

  foreach v of varlist Facebook TwitterX Instagram Whatsapp TikTok YouTube OthersSM{
	label variable `v' "`v'"
	replace `v'=`v'*100
}
	graph bar (mean) Facebook TwitterX Instagram Whatsapp TikTok YouTube, over(VOTE2024, label(labsize(small))) ///
			ytitle("Social Media Usage Percentage (%)", size(small)) ///
			blabel(total, position(inside) color(bg) format(%9.1f)) ///
			ylabel(, angle(horizontal) labsize(small)) ///	
			legend(rows(1) stack size(small) order(1 "Facebook" 2 "TwitterX" 3 "Instagram" 4 "Whatsapp" 5 "TikTok" 6 "YouTube"))
	graph export "$FIG/SMTYPE_VOTE.pdf", as(pdf) replace
			
	restore


	

/*
	
*! Do-file from 13Nov2020, Jan Helmdag

sysuse auto

reg weight mpg trunk length turn

	estimates store reg1

	local plus if(@ll>0) mcolor(sky) ciopts(color(sky))
	local zero if(@ll<=0 & @ul>=0) ciopts(color(gray))
	local minus if(@ul<0) mcolor(red) ciopts(color(red))
	local options drop (_cons)

coefplot ///
	(reg1, `plus' `options' ) ///
	(reg1, `zero' `options') ///
	(reg1, `minus' `options') ///
	, xline(0) mlabel(string(@b,"%4.3f") + cond(@pval<.001,"***",cond(@pval<.01,"**",cond(@pval<.05,"*",cond(@pval<.1,"+",""))))) ///
	mcolor(black) msymbol(D) mfcolor(white) msize(vsmall) mlabcolor(black) ciopts(lcolor(black)) mlabposition(12) mlabgap(.5)  ///
	sort(, descending by(b)) legend(off) nooffsets levels(95)
*/
	

