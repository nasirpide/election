*name 					Cleaning File: Raw data
*Data Source:			survey data: Politics and social media
*Date created: 			12/12 2023
*Creator:				Sohaib Jalal
********************************************************************************
	*global data "/Users/drnasiriqbal/Library/CloudStorage/Dropbox/Election/data"
	do "C:\Users\Administrator\Documents\GitHub\election\Master.do"
********************************************************************************
**Read Survey Data
	use "$data", clear 
	
**************************
*CLEANING
***************************

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

**VOTING DECISIONS & PRACTICES**

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
	label define reasons 1 "Not Registered" 2 "No Trust on Election" 3 "Personal Reasons"
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
	label define why_vote 1 "Civic Duty" 2 "Bring Positive Change" 3 "Support Party/Candidate" 4 "Democracy" 5 "Others"
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
	label define candidate 1 "Party Affiliation" 2 "Candidate him/herself" 3 "Past performace" 4 "Personal connection/others"
	label values VOTE_CANDIDATE candidate
	
*reason_vote candidate
	tab s61, missing				// No missing value // Leader of the party
	replace s61=. if s61==.a
	gen VOTE_PARTY =1 if s61==1&s61!=.
	replace VOTE_PARTY =2 if s61==2&s61!=.
	replace VOTE_PARTY =3 if s61==3&s61!=.
	replace VOTE_PARTY =4 if s61==4|s61==999&s61!=.
	label variable VOTE_PARTY "Deciding factors while voting a party"
	label define party 1 "Head" 2 "Past Performance" 3 "Vision" 4 "Reform Agenda/Plan"
	label values VOTE_PARTY party	
	
**PERCEPTION ABOUT UPCOMMING ELECTIONS**


*political stability
	tab s62, missing			// missing value issue // Yes 266, No 224, NS 114
	replace s62=. if s62==.a

*economic condition
	tab s63, missing			// missing value issue // Yes 284, No 202, NS 113
	replace s63=. if s63==.a

*election transparency		
	tab s64, missing			// ==		// Yes 102, No 404, NS 95
	replace s64=. if s64==.a

	
*equal opportunity
	tab s65, missing			//no missing value // Yes 171, No 397
	replace s65=. if s65==.a

*************************

********************************************************************************
****Demographic characteristics 
********************************************************************************
	genl GENDER=(D1_1==1), label(Gender of respondent)
	
	gen AGE_CAT=1 if D0<=23
	replace AGE_CAT=2 if D0>23&D0<=30
	replace AGE_CAT=3 if D0>30&D0<=40
	replace AGE_CAT=4 if D0>40&D0!=.
	label variable AGE_CAT "Age catagories"
	label define age_cat 1 "New Entrant Youth" 2 "Youth" 3 "Mid Carear" 4 "Senior"
	label values AGE_CAT age_cat
	
	gen EDU_CAT=1 if D5<=4
	replace EDU_CAT=2 if D5==5|D5==6
	replace EDU_CAT=3 if D5==7
	replace EDU_CAT=4 if D5==8|D5==9
	
	label variable EDU_CAT "Education catagories"
	label define edu_cat 1 "Matic or less" 2 "Secondary" 3 "Bechlor" 4 "Master/PhD"
	label values EDU_CAT edu_cat

	gen EMP_CAT=1 if D2==1|D2==2
	replace EMP_CAT=2 if D2==3
	replace EMP_CAT=3 if D2==5
	replace EMP_CAT=4 if EMP_CAT==.&D2!=.
	label variable EMP_CAT "Employment catagories"
	label define emp_cat 1 "Employeed" 2 "Business" 3 "Students" 4 "Labor/Others"
	label values EMP_CAT emp_cat


********************************************************************************
****Analysis for brief 1: Perception and intention 
********************************************************************************
	*Figure 1: Voted 
	mean VOTED2018 if AGE_CAT!=1, over(AGE_CAT)
	mean VOTE2024, over(AGE_CAT)
	mean VOTED2018 if AGE_CAT!=1
	mean VOTE2024
	
	
	graph bar (mean) VOTE2024, over(AGE_CAT) ytitle("Likelihood to vote")

	tab VOTE_CANDIDATE EDU_CAT, nofre col
	tab VOTE_PARTY EDU_CAT, nofre col
	
	
	
*** No major difference across demographic in intend to vote






	
	 graph bar (mean) tempjuly tempjan, over(region)
                legend( label(1 "July") label(2 "January") )
                ytitle("Degrees Fahrenheit")
                title("Average July and January temperatures")
                subtitle("by regions of the United States")
                note("Source: U.S. Census Bureau, U.S. Dept. of Commerce")

********************************************************************************
****Analysis for brief 2: Social media role in politics
********************************************************************************	

	rename (K3__1 K3__2 K3__3 K3__4 K3__5 K3__6 K3__7 K3__8 K3__9) (Facebook X Instagram Whatsapp TikTok YouTube Snapchat Telegram Linkedin)

rename (K5 K5_1 K5_2 K5_3 K5_4 K5_5) (Facebook_use X_use Instagram_use Whatsapp_use TikTok_use YouTube_use)

	tab T1
	replace T1=4 if T1==3 | T1==5     // we have options (Never, rarely, occasionally, frequently, always) replacing occasionally & always with "Frequently" now options are (Never , rarely , frequently)
	replace T2=4 if T2==3 | T2==5 
	replace T3=4 if T3==3 | T3==5
	replace T4=4 if T4==3 | T4==5
	replace T5=4 if T5==3 | T5==5

	replace X11= 3 if X11==2    // we have options (No change, slight change, moderate change, significant change, complete change ) replacing slight change with "moderate change" & significant change with "complete change"
	replace X11= 5 if X11==4

replace X1 =3 if X1==2    // replacing to a small extent with "to a modrate extent" & to a large extent with "Extremely"
replace X1=5 if X1==4


replace X2= 3 if X2==2  // replacing slightly/somewhat with "moderately" & very/significant with Extremely . using same otions for X2 and X3
replace X2= 5 if X2==4  // X2 has 362 obs, 1 obs has .a

replace X3= 3 if X3==2 
replace X3= 5 if X3==4 

replace X4= 3 if X4==2
replace X4=5 if X4==4


	
	
	
	
	
/*

**SOCIAL MEDIA AND POLITICS**

*usage_Political news
tab K1, missing				//no missing value // 57% usage, 42% no

*reason_no usage
tab K2, missing				//missing value	// multiple reasons

*social media plateform
genl Facebook=(K3__1==1), label(social media: Facebook)
genl X=(K3__2==1), label(social media: Twitter)
genl Instagram=(K3__3==1), label(social media: Instagram)
genl Whatsapp=(K3__4==1), label(social media: Whatsapp)
genl TikTok=(K3__5==1), label(social media: TikTok)
genl Youtube=(K3__6==1), label(social media: Youtube)
genl Snapchat=(K3__7==1), label(social media: Snapchat)
genl Telegram=(K3__8==1), label(social media: Telegram)
genl Linkedin=(K3__9==1), label(social media: Linkedin)
genl SocialMedia_others=(K3__999==1), label(social media: Others)

*preferred social media plateform
tab K4, missing			// no missing value
  
**Types of Political Information
genl Textbased=(K6__1==1), label (type of information: Textbased)
genl Podcasts=(K6__2==1), label (type of information: Podcasts)
genl infographics=(K6__3==1), label (type of information: infographics)
genl videoclips=(K6__4==1), label (type of information: Videoclips)
genl audioclips=(K6__5==1), label (type of information: audiooclips)
genl newsarticles=(K6__6==1), label (type of information: newsarticles)
genl live_streaming=(K6__7==1), label (type of information: live streaming)
genl user_generatedcontnt=(K6__8==1), label (type of information: user generatedcontnt)
genl commentsdiscns=(K6__9==1),label (type of information: comments&discns)

**engagement with Political information
genl like_react=(K7__1==1), label (type of engagement: like_react) 
genl share_post=(K7__2==1), label (type of engagement: share_post) 
genl read_only=(K7__3==1), label (type of engagement: read only) 
genl comment_discussion=(K7__4==1), label (type of engagement: comment_discussion) 
genl participate_poll_survey=(K7__5==1), label (type of engagement: participate poll_survey) 
genl create_content=(K7__6==1), label (type of engagement: create content) 
genl ignore=(K7__7==1), label (type of engagement: ignore) 

*************************************************************************************
//Analysis
**Age categories
gen Age_bracket=1 if D0 >= 18 & D0 <= 29
replace Age_bracket=2 if D0 >=30 & D0<=50
replace Age_bracket=3 if D0 >=51
label define Age_bracket_lbl 1"Youth" 2"Middle Age" 3"Old Age"
label values Age_bracket Age_bracket_lbl

**age graph
graph pie, over(Age_bracket) plabel(_all percent)

**Education: merged: primary&lessthan primary, seconrdy&matric, PHD&Masters
replace D5=3 if D5==2
replace D5=5 if D5==4
replace D5=8 if D5==9

*graph education
 graph pie, over(D5) plabel(_all percent, size(vsmall) orientation(rvertical) format(%4.0g)) legend(cols(4) size(vsmall))
 
*Employment : merged: retired and housewife with unemployed
replace D2=7 if D2==6 | D2==9

*graph employment
graph pie, over(D2) plabel(_all percent, size(vsmall) orientation(vertical) format(%4.0g)) legend(cols(4) size(vsmall))

graph pie, over(A3) plabel(_all percent)

graph pie, over(A4) plabel(_all percent)
graph pie, over(s58) plabel(_all percent, size(vsmall) orientation(vertical) format(%4.0g)) legend(cols(3) size(vsmall))
