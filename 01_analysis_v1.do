*name 					Cleaning File: Raw data
*Data Source:			survey data: Politics and social media
*Date created: 			12/12 2023
*Creator:				Sohaib Jalal
********************************************************************************
	*global data "/Users/drnasiriqbal/Library/CloudStorage/Dropbox/Election/data"
	do "C:\Users\Administrator\Documents\GitHub\election\Master.do"
********************************************************************************
**Read Survey Data
	*use "$data/surveydata.dta", clear 
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

/*
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
	
*/
********************************************************************************
****Analysis for brief 2: Social media role in politics
********************************************************************************	
	genl SOCIAL_MEDIA=(K1==1), label(Social Media)
	drop K1
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

rename (K5 K5_1 K5_2 K5_3 K5_4 K5_5) (Facebook_use X_use Instagram_use Whatsapp_use TikTok_use YouTube_use)

	rename 	(K7__1 K7__2 K7__3 K7__4 K7__5 K7__6 K7__7) ///
			(Like Share Read Comment Participate CreateContent OthersWays)   
	replace OthersWays=1 if Participate==1 | CreateContent==1
	drop Participate CreateContent
	
	foreach v of varlist Like Share Read Comment OthersWays{
	label variable `v' "Ways to engage with political information on SM: `v'"
}


********Use of any kind of soical media by age_cat	
	graph bar (mean) SOCIAL_MEDIA,	over(AGE_CAT) ytitle("Percentage")
	
	
	 graph bar Facebook TwitterX Instagram Whatsapp TikTok YouTube Others, by(AGE_CAT) include response(1) sort width(5) title(Use of different social media plateform (multiple)) ylabel(,angle(0))
	
	mrgraph bar Facebook X Instagram Whatsapp TikTok YouTube Others, include response( 1) sort width(16) stat(column) by(AGE_CAT) rtotal title(Criminal experiences (as a victim))
	
**********generating outcome variables(Dummies)
	*political stability
	label define dummy 1 "Yes" 0 "No"
	
	gen PS_2024=1 if s62==1
	replace PS_2024=0 if s62==2 | s62==3 | s62==4

	label variable PS_2024 "2024 elections will bring political stability"
	label values PS_2024 dummy
	*Economic conditions
	gen EC_2024=1 if s63==1
	replace EC_2024=0 if s63==2 | s63==3 | s63==4

	label variable EC_2024 "2024 elections will Improve Economic conditions"
	label values EC_2024 dummy
	
	*Fair & transparent elections
	gen FairElection_2024=1 if s64==1
	replace FairElection_2024=0 if s64==2 | s64==3 | s64==4

	label variable FairElection_2024 "2024 elections will Fair & transparent"
	label values FairElection_2024 dummy
	
	*share post on social media
	gen share_post=0 if T1==1
	replace share_post=1 if T1==2 | T1==3 | T1==4 | T1==5
	
	label variable share_post "share post on social media about politics"
	label values share_post dummy 
	
	*promote political party
	gen Promote_PP=0 if T2==1
	replace Promote_PP=1 if T2==2 | T2==3 | T2==4 | T2==5
	
	label variable Promote_PP "Promote any political party on social media"
	label values Promote_PP dummy
	
	*Promote political candidate 
	gen Promote_PC=0 if T3==1
	replace Promote_PC=1 if T3==2 | T3==3 | T3==4 | T3==5
	
	label variable Promote_PC "Promote any political candidate on social media"
	label values Promote_PC dummy
	
	*attend online political events/jalsas
	
	gen OnlineEvent=0 if T4==1
	replace OnlineEvent=1 if T4==2 | T4==3 | T4==4 | T4==5
	
	label variable OnlineEvent "Attend online political event"
	label values OnlineEvent dummy
	
	*political discussion and debate 
	gen PoliticalDebate=0 if T5==1
	replace PoliticalDebate=1 if T5==2 | T5==3 | T5==4 | T5==5
	
	label variable PoliticalDebate "Engage in political debate on social media"
	label values PoliticalDebate dummy
	
	*social media influence political engagements
	gen Influence_PE=0 if X1==1
	replace Influence_PE=1 if X1==2 | X1==3 | X1==4 | X1==5
	
	label variable Influence_PE "social media influence your political engagements"
	label values Influence_PE dummy
	
	*change support
	gen ChangeSupport=0 if X11==1
	replace ChangeSupport=1 if X11==2 | X11==3 | X11==4 | X11==5
	
	label variable ChangeSupport "changed political support due to social media"
	label values ChangeSupport dummy
	
	*choosing better voting candidate
	gen Better_VC=0 if X2==1
	replace Better_VC=1 if X2==2 | X2==3 | X2==4 | X2==5
	
	label variable Better_VC "social media helps choosing better voting candidate"
	label values Better_VC dummy
	
	*increased political awarness
	gen Awarness=0 if X3==1
	replace Awarness=1 if X3==2 | X3==3 | X3==4 | X3==5
	
	label variable Awarness "social media increased political awarness"
	label values Awarness dummy
	
	*chances of winning elections
	gen ElectionWinners=0 if X5==2 | X5==3
	replace ElectionWinners=1 if X5==1 
	
	label variable ElectionWinners "party who are more active on social media will win elections"
	label values ElectionWinners dummy
	
	*political polarization
	gen Polarization=0 if X6==3 | X6==4 | X6==5
	replace Polarization=1 if X6==1 | X6==2
	
	label variable Polarization "Social media contribute to political polarization"
	label values Polarization dummy
	
	*Reliable source of political information
	tab J3, gen(J3)
	rename A3 REGION

	*****************************
	****explanatory variables
	*****************************
	*Trust vs No Trust
	gen News_trust=0 if J1==1  
	replace News_trust=1 if J1==2 | J1==3 | J1==4 | J1==5
	
	label variable News_trust "Trust on political information come across on Social media"
	label values News_trust dummy

	*Social media vs Traditional media
	gen Reliable_source=0 if J3==1 | J3==2 | J3==4
	replace Reliable_source=1 if J3==3
	
	label variable Reliable_source "Reliable source of Political information"
	label define reliable_source 0 "Traditional Media" 1 "Social Media"
	label values Reliable_source reliable_source
	
	*Active vs Passive social media users
// Initialize Users variable
	gen Users=1 if Facebook_use==1 | Facebook_use==2 | X_use==1 | X_use==2 | Instagram_use==1 | Instagram_use==2 | Whatsapp_use==1 | Whatsapp_use==2 | TikTok_use==1 | TikTok_use==2 |   YouTube_use==1 |   YouTube_use==2
	
	replace Users=0  if Facebook_use==3 | Facebook_use==4 | Facebook_use==5 | Facebook_use==6 | X_use==3 | X_use==4 | X_use==5 | X_use==6 | Instagram_use==3 | Instagram_use==4 | Instagram_use==5 | Instagram_use==6 | Whatsapp_use==3 | Whatsapp_use==4 | Whatsapp_use==5 | Whatsapp_use==6 | TikTok_use==3 | TikTok_use==4 | TikTok_use==5 | TikTok_use==6 | YouTube_use==3 | YouTube_use==4 | YouTube_use==5 | YouTube_use==6
	
label variable Users "Social Media Users for political information"
label define user_l 0 "Passive Users" 1 "Active Users"
label values Users user_l
	
*********************************	
**** Changing voting Behaviour
	tab VOTED2018
	tab VOTE2024
	tab s52
	tab PARTY_VOTE 
	
	gen Voting_B = 1 if (VOTED2018==1 & VOTE2024==1) // yes , yes
	replace Voting_B = 2 if (VOTED2018==0 & VOTE2024==1) // no , yes
	replace Voting_B = 3 if (VOTED2018==1 & VOTE2024==0) // yes , no
	replace Voting_B = 4 if (VOTED2018==0 & VOTE2024==0) // no, n0
	
	gen Change_party=(s52==PARTY_VOTE) // 0 "changed party" 1 "No change"
	
	
	

**************************************************
*******Logistic Analyis
**************************************************

***Regression Models

	global COVS "AGE_CAT EDU_CAT EMP_CAT REGION"	

*******************
	***Vote2024
*******************
		logistic VOTE2024 SOCIAL_MEDIA
		logistic VOTE2024 SOCIAL_MEDIA REGION
		logistic VOTE2024 SOCIAL_MEDIA i.AGE_CAT i.EDU_CAT i.EMP_CAT
		logistic VOTE2024 SOCIAL_MEDIA i.AGE_CAT i.EDU_CAT i.EMP_CAT REGION

*Age
		logistic VOTE2024 SOCIAL_MEDIA if AGE_CAT==1
		logistic VOTE2024 SOCIAL_MEDIA if AGE_CAT==2
		logistic VOTE2024 SOCIAL_MEDIA if AGE_CAT==3
		logistic VOTE2024 SOCIAL_MEDIA if AGE_CAT==4
*Education		
		logistic VOTE2024 SOCIAL_MEDIA if EDU_CAT==1
		logistic VOTE2024 SOCIAL_MEDIA if EDU_CAT==2
		logistic VOTE2024 SOCIAL_MEDIA if EDU_CAT==3
		logistic VOTE2024 SOCIAL_MEDIA if EDU_CAT==4
*Employment
		logistic VOTE2024 SOCIAL_MEDIA if EMP_CAT==1
		logistic VOTE2024 SOCIAL_MEDIA if EMP_CAT==2
		logistic VOTE2024 SOCIAL_MEDIA if EMP_CAT==3
		logistic VOTE2024 SOCIAL_MEDIA if EMP_CAT==4
*Region
		logistic VOTE2024 SOCIAL_MEDIA if REGION==1
		logistic VOTE2024 SOCIAL_MEDIA if REGION==2
		
*Social media platforms		
		logistic VOTE2024 Facebook 
		logistic VOTE2024 TwitterX  
		logistic VOTE2024 Instagram 
		logistic VOTE2024 Whatsapp 
		logistic VOTE2024 TikTok 
		logistic VOTE2024 YouTube

		logistic VOTE2024 News_trust
		logistic VOTE2024 REGION News_trust
		logistic VOTE2024 i.AGE_CAT i.EDU_CAT i.EMP_CAT News_trust
		logistic VOTE2024 i.AGE_CAT i.EDU_CAT i.EMP_CAT REGION News_trust
		
		logistic VOTE2024 Reliable_source
		logistic VOTE2024 REGION Reliable_source
		logistic VOTE2024 i.AGE_CAT i.EDU_CAT i.EMP_CAT Reliable_source
		logistic VOTE2024 i.AGE_CAT i.EDU_CAT i.EMP_CAT REGION Reliable_source
		
		logistic VOTE2024 Users
		logistic VOTE2024 REGION Users
		logistic VOTE2024 i.AGE_CAT i.EDU_CAT i.EMP_CAT Users
		logistic VOTE2024 i.AGE_CAT i.EDU_CAT i.EMP_CAT REGION Users

*******************************
	** Change voting behaviour
*******************************
	
		logistic Change_party SOCIAL_MEDIA
		logistic Change_party SOCIAL_MEDIA REGION
		logistic Change_party SOCIAL_MEDIA i.AGE_CAT i.EDU_CAT i.EMP_CAT
		logistic Change_party SOCIAL_MEDIA i.AGE_CAT i.EDU_CAT i.EMP_CAT REGION

*Age
		logistic Change_party SOCIAL_MEDIA if AGE_CAT==1
		logistic Change_party SOCIAL_MEDIA if AGE_CAT==2
		logistic Change_party SOCIAL_MEDIA if AGE_CAT==3
		logistic Change_party SOCIAL_MEDIA if AGE_CAT==4
*Education		
		logistic Change_party SOCIAL_MEDIA if EDU_CAT==1
		logistic Change_party SOCIAL_MEDIA if EDU_CAT==2
		logistic Change_party SOCIAL_MEDIA if EDU_CAT==3
		logistic Change_party SOCIAL_MEDIA if EDU_CAT==4
*Employment
		logistic Change_party SOCIAL_MEDIA if EMP_CAT==1
		logistic Change_party SOCIAL_MEDIA if EMP_CAT==2
		logistic Change_party SOCIAL_MEDIA if EMP_CAT==3
		logistic Change_party SOCIAL_MEDIA if EMP_CAT==4
*Region
		logistic VOTE2024 SOCIAL_MEDIA if REGION==1
		logistic VOTE2024 SOCIAL_MEDIA if REGION==2
		
*Social media platforms		
		logistic Change_party Facebook 
		logistic Change_party TwitterX  
		logistic Change_party Instagram 
		logistic Change_party Whatsapp 
		logistic Change_party TikTok 
		logistic Change_party YouTube

		logistic Change_party News_trust
		logistic Change_party REGION News_trust
		logistic Change_party i.AGE_CAT i.EDU_CAT i.EMP_CAT News_trust
		logistic Change_party i.AGE_CAT i.EDU_CAT i.EMP_CAT REGION News_trust
		
		logistic Change_party Reliable_source
		logistic Change_party REGION Reliable_source
		logistic Change_party i.AGE_CAT i.EDU_CAT i.EMP_CAT Reliable_source
		logistic Change_party i.AGE_CAT i.EDU_CAT i.EMP_CAT REGION Reliable_source
		
		logistic Change_party Users
		logistic Change_party REGION Users
		logistic Change_party i.AGE_CAT i.EDU_CAT i.EMP_CAT Users
		logistic Change_party i.AGE_CAT i.EDU_CAT i.EMP_CAT REGION Users
	
	
	

/*

Facebook_use X_use Instagram_use Whatsapp_use TikTok_u	tab T1
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
*/

	
	
	
	
	
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








	
	 graph bar (mean) tempjuly tempjan, over(region)
                legend( label(1 "July") label(2 "January") )
                ytitle("Degrees Fahrenheit")
                title("Average July and January temperatures")
                subtitle("by regions of the United States")
                note("Source: U.S. Census Bureau, U.S. Dept. of Commerce")
		*/
