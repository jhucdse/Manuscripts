
*******************************************************************************;
* Program name      :	xx_primary_analysis_hazard_ratios
* Author            :	Jamie Heyward
* Date created      :	July 18 2023
* Study             : 	
* Purpose           :	Calculate hazard ratios for irAE and all-cause mortality comparing treatment arms
* Inputs            :	
* Program completed : 	
* Updated by        :   Xinyi Sun
*********************************************************************************;

LIBNAME seer 'S:\Pharmacoepi0216\Thesis';
LIBNAME thesis 'S:\Pharmacoepi0216\Thesis_new';
proc format; 
		value HistCatCoarse 1 = "squamous cell carcinoma" 2 = "adenocarcinoma" 3 = "other carcinoma" 4 = "other"; 
		value $RaceNH_H '1'="Non-Hispanic White" 
					'2' ="Non-Hispanic Black" 
					'3' ="Non-Hispanic Asian/Pacific Islander (API)" 
					'4' ="Non-Hispanic American Indian/Alaska Native (AI/AN)" 
					'5' ="Hispanic" 
					'9' ="Unknown";
		value $Sex 	'1' ="Male"
					'2' ="Female"
					'9' ="Not stated (unknown)";
		value $Payer '01'= "Not insured"
					'02'= "Not insured, self-pay"
					'10'= "Insurance, NOS"
					'20'= "Private Insurance: Managed care, HMO, or PPO"
					'21'= "Private Insurance: Fee-for-Service"
					'31'= "Medicaid"
					'35'= "Medicaid  Administered through a Managed Care plan"
					'60'= "Medicare/Medicare, NOS"
					'61'= "Medicare with supplement, NOS"
					'62'= "Medicare  Administered through a Managed Care plan"
					'63'= "Medicare with private supplement"
					'64'= "Medicare with Medicaid eligibility"
					'65'= "TRICARE"
					'66'= "Military"
					'67'= "Veterans Affairs"
					'68'= "Indian/Public Health Service"
					'99'= "Insurance status unknown";
			value $MaritalStatus '1' ="Single (never married)"
								'2'= "Married (including common law)"
								'3'= "Separated"
								'4'= "Divorced"
								'5'= "Widowed"
								'6'= "Unmarried or domestic partner (same sex or opposite sex or unregistered)"
								'9'= "Unknown"
								'14'= "Blank";
			value ExposureArm 1 ="ICI" 2 ="ICI + ICI" 3 ="ICI + Chemo";
			value $Stage '0' = "In situ" 
						'1' = "Localized"
						'2' = "Regional by direct extension only" 
						'3' = "Regional, regional lymph nodes only"
						'4' = "Regional, direct extension and regional lymph nodes"
						'7' = "Distant" 
						'8' = "Benign, borderline"
						'9' = "Unknown"; 
			value $SequenceNo '00' ="One primary only in the patients lifetime"
							'01' = "First of two or more primaries"
							'02' = "Second of two or more primaries"
							'03' = "Third of three or more primaries"
							'99' ="Unspecified or unknown sequence number of Federally required in situ or malignant tumors.";
			value $PrimarySite 	"C340" = "Main bronchus"
								"C341" = "Upper lobe, lung"
								"C342" = "Middle lobe, lung (right lung only)"
								"C343" = "Lower lobe, lung"
								"C348" = "Overlapping lesion of lung"
								"C349" = "Lung, NOS"
								"C339" = "Trachea, NOS";
			value $Laterality '0'= "Not a paired site"
							'1'= "Right: origin of primary"
							'2'= "Left: origin of primary"
							'3'= "Only one side involved, right or left origin unspecified"
							'4'= "Bilateral involvement, lateral origin unknown; stated to be single primary"
							'5'= "Paired site: midline tumor"
							'9'= "Paired site, but no information concerning laterality; midline tumor";
			value $Behavior '0'= "Benign"
							'1'= "Borderline malignancy"
							'2'= "In situ"
							'3'= "Malignant"
							'4'= "Only malignant in ICD-O-3"
							'5'= "No longer reportable in ICD-O-3"
							'6'= "Only malignant 2010+";
			value $RxSummSurg '00'="None; no surgical procedure of primary site; diagnosed at autopsy only"
							'10'-'125'= "Site-specific codes. Tumor destruction; no pathologic specimen or unknown whether there is a pathologic specimen"
							'127'-'19'= "Site-specific codes. Tumor destruction; no pathologic specimen or unknown whether there is a pathologic specimen"
							'20'-'80'= "Site-specific codes. Resection; pathologic specimen"
							'90'= "Surgery, NOS. A surgical procedure to the primary site was done, but no information on the type of surgical procedure is provided."
							'98'= "Special codes for hematopoietic, reticuloendothelial, immunoproliferative, myeloproliferative diseases; ill-defined sites; and unknown primaries"
							'99'= "Unknown if surgery performed; death certificate only"
							'126'= "Blank";
			value $Radiation '0'= "None/Unknown; diagnosed at autopsy"
							'1'= "Beam radiation"
							'2'= "Radioactive implants"
							'3'= "Radioisotopes"
							'4'= "Combination of 1 with 2 or 3"
							'5'= "Radiation, NOSmethod or source not specified"
							'6'= "Other radiation (1973-1987 cases only)"
							'7'= "Patient or patient's guardian refused radiation therapy"
							'8'= "Radiation recommended, unknown if administered";
						value HistologyType 1 = "squamous cell carcinoma" 2 = "small cell carcinoma" 3 = "adenocarcinoma" 4 = "large cell carcinoma"
								5 = "other specified carcinoma" 6 = "unspecified malignant neoplasms" 7 = "non-small cell carcinoma" 
								8 = "malignant neoplasm NOS" 9 = "non-carcinoma or appeared to be metastasis" 
								10 = "unknown"; 
					run; 

proc format;
    value $Race
        '1' = "Non-Hispanic White"
        '2' = "Non-Hispanic Black"
        '5' = "Hispanic"
        '4' = "Other";
run;

/***************** Primary outcome: Time to cancer-specific death ********************/
 /* First need to remove medicare_death_date after 2019-12-31 */
data thesis.cohort_psweighted_trimmed;
    set thesis.cohort_psweighted_trimmed;
    if medicare_death_dt > '31DEC2019'd then medicare_death_dt = .;
run;
proc means data = thesis.cohort_psweighted_trimmed;
var medicare_death_dt;
run;

proc summary data=thesis.cohort_psweighted_trimmed nway;
    var medicare_death_dt;
    output out=summary_results (drop=_:) min=MinDate max=MaxDate;
run; * 14AUG2015, 28DEC2019;

/* Primary outcome: cancer death--exclude 4 states */
data thesis.cohort_psweighted_trimmed_fg;
    set thesis.cohort_psweighted_trimmed;
     where cancer_death ne '.';

	/* Use medicare_death_dt */
    if cancer_death = "1" or noncancer_death = "1" then cause_death_dt = medicare_death_dt;
    else cause_death_dt = .;
	format cause_death_dt date9.;
run;
data thesis.cohort_psweighted_trimmed_fg;
    set thesis.cohort_psweighted_trimmed_fg;
    /************************************
     * Follow-up end date
     ************************************/
    fu_end_date = min(mcare_disenroll_dt, admin_censor_dt, cause_death_dt);
    format fu_end_date date9.;
    years_to_end_fu = (fu_end_date - ici_index_dt) / 365.25; /* Use 365.25 for leap year adjustment */
    months_to_end_fu = (fu_end_date - ici_index_dt) / 30.5;
    /************************************
     * Censor flag and outcomes
     ************************************/
    /* Censor flag for competing risks model */
    if fu_end_date = cause_death_dt and cancer_death = '1' then censor_flag1 = 1; /* Event: cancer death */
    else if fu_end_date = cause_death_dt and noncancer_death = '1' then censor_flag1 = 2; /* Event: non-cancer death */
    else censor_flag1 = 0; /* Censored */

    /* Censor flag for Cox model */
    if fu_end_date = cause_death_dt then censor_flag2 = 1; /* Event: all-cause death */
    else censor_flag2 = 0; /* Censored */
run;

/*Summary of number of cases*/
proc freq data=thesis.cohort_psweighted_trimmed_fg;
	tables Met_1px*(censor_flag1 censor_flag2);
run;
 /* 978 = 729+249 rows */

proc freq data=thesis.cohort_psweighted_trimmed_fg;
    where cancer_death ne '.';
	tables Met_1px*(censor_flag1 censor_flag2);
run; 
 /* Crude outcome comparison without accounting for confounding */
proc means data = thesis.cohort_psweighted_trimmed_fg mean sum min max nothreads;
class Met_1px;
var sipew_t; 
run; 

/* Mean/ median duration of follow-up by Met_1px */ 
data fu_duration; 
set thesis.cohort_psweighted_trimmed_fg;
days_followup = years_to_end_fu*365.25; 
run; 

proc means data = fu_duration n mean p25 p50 p75 min max; 
var days_followup years_to_end_fu; 
class Met_1px;
var sipew_t;
run; 

proc univariate data = thesis.cohort_psweighted_trimmed_fg; 
var years_to_end_fu;
run; 

proc print data = thesis.cohort_psweighted_trimmed_fg; 
where years_to_end_fu <0; 
run;  /*After use medicare death date, no < 0 */



/*** Unadjusted Hazard ratio, cumulative incidence curves, 
and cumulative incidence at 0.5, 1, 1.5, 2 yrs, 
for cancer death */

/* For Prediction */
Data Arms;
	chemo_count = 9.9112710; 
	days_dx_to_tx = -357.3419052; 
	exposure_arm=1; output;
	exposure_arm=2; output;
	exposure_arm=3; output;
	format exposure_arm ExposureArm.;
run;

proc print data = Arms; run;

* Cancer death; 
proc phreg data=thesis.cohort_psweighted_trimmed_fg;
	class Met_1px / param=glm order=internal ref=first;
	model years_to_end_fu*censor_flag1(0) = Met_1px / eventcode=1;
	hazardratio 'Subdistribution Hazards' Met_1px / diff=pairwise;
run;

ods graphics on;
proc lifetest data=thesis.cohort_psweighted_trimmed_fg plots =cif(test) timelist= 0.5 1 1.5 2; *Cumulative incidence curve for death;
   time years_to_end_fu*censor_flag1(0) / eventcode = 1;
   strata Met_1px / order=internal;
run;
proc sql;
    create table cancerdeath_ir as
    select 
        Met_1px, 
        sum(years_to_end_fu) as total_person_years, 
        sum(censor_flag1=1) as num_events,  /* Count events where eventcode=1 */
        calculated num_events / calculated total_person_years as incidence_rate format=8.4
    from thesis.cohort_psweighted_trimmed_fg
    group by Met_1px;
quit;

proc print data=cancerdeath_ir; 
    title "Cancer death Incidence Rate per Person-Year by Exposure Group";
run;

 /* unadjusted cancer death HR = 0.98 */


/* Not needed: Cox PH model: Unadjusted hazard ratios, 
survival curves and cumulative incidence at 0.5, 1, 1.5, 2yrs 
for death (all-cause) */ 

		proc phreg data=thesis.cohort_psweighted_trimmed_fg;
		    title 'All cause death Cox Model';
			class Met_1px / order=internal ref=first param=glm;
			model years_to_end_fu*censor_flag2(0) = Met_1px;
			output out = schoen ressch = Met_1px_s;
		run;
         *Survival curve for all-cause mortality;
		ods graphics on;
		proc lifetest data=thesis.cohort_psweighted_trimmed_fg plots =survival(nocensor) timelist= 0.5 1 1.5 2; 
		   time years_to_end_fu*censor_flag2(0);
		   strata Met_1px / order=internal;
		run; 
		
        * Cloglog plot, x-axis is long time, can't be parallel;
        proc lifetest data = thesis.cohort_psweighted_trimmed_fg plots = (s, lls);
            strata Met_1px;
            time years_to_end_fu*censor_flag2(0);
        run; 
        * Customized cloglog plot;
		/* Step 1: Extract survival estimates */
ods output survivalplot=surv_data;
proc lifetest data=thesis.cohort_psweighted_trimmed_fg plots=s;
    strata Met_1px;
    time years_to_end_fu*censor_flag2(0);
run;
ods output close;

data surv_data;
    set surv_data;
    if Survival > 0 then log_neg_log_Survival = log(-log(Survival));
    else log_neg_log_Survival = .; /* Handle edge cases where Survival is 0 */
run;
/* Step 2: Create cloglog plot with linear time on the x-axis */
proc sgplot data=surv_data;
    scatter x=Time y=log_neg_log_Survival / group=Stratum markerattrs=(symbol=circlefilled);
    xaxis label="Time (Years)" type=linear; 
    yaxis label="log(-log(Survival Probability))";
    title "Cloglog Plot";
run;
 /* Actually overlap, but parallel */

        * Schoenfeld residual plot;
        proc gplot data = schoen;
		   symbol1 v = dot c = red width = 1 i = sm80s;
            plot Met_1px_s*years_to_end_fu / haxis = axis1 vaxis = axis2;
            axis1 label = ('Time');
            axis2 label = (a = 90 'Schoenfeld Residual for MET Exposure');
        run;

         /* Undjusted all cause HR = 0.96
		   Survival curves cross, NPH, can we include time interaction term in Cox model?
		*/



  /* NPH Cox model with time*exposure interaction term
	https://www.lexjansen.com/phuse/2013/sp/SP07.pdf*/   
proc phreg data=thesis.cohort_psweighted_trimmed;
		    title 'All cause death Cox Model with time-varying HR';
			class Met_1px / order=internal ref=first param=glm;
			model years_to_end_fu*censor_flag2(0) = Met_1px Met_1px_t;
            Met_1px_t = Met_1px*years_to_end_fu;
			test: test Met_1px_t;
			*output out = schoen ressch = Met_1px_s;
		run;
		/* Interaction term p = 0.9, NS */


/* Adjusted IPEW hazard ratio, cumulative incidence curves and cumulative incidence at 0.5, 1, 1.5, 2 years 
https://support.sas.com/resources/papers/proceedings15/SAS1855-2015.pdf */

* Cancer death; 
/* To get HR */ 
ods graphics on; 
proc phreg data=thesis.cohort_psweighted_trimmed_fg plots(overlay=bystratum)=cif;
	class Met_1px / param=ref order=internal ref=first; 
	model years_to_end_fu*censor_flag1(0) = Met_1px / eventcode=1;
	weight sipew_t / normalize; 
	hazardratio'Sub Hazard Ratio of cancer death' Met_1px / diff = ref cl = wald; 
	output out = out_residuals ressch = _ALL_; 
	*baseline covariates=Arms out=out1 cif = r timelist = (1) / rowid=exposure_arm;
run;

	ods graphics /antialiasmax = 19600; 
	proc sgplot data = out_residuals;
	scatter x = years_to_end_fu y = RESSCH_MET_1px1; 
	xaxis min = 0 max =1; 
	refline 0 / axis=y lineattrs=(thickness=1 color=darkred pattern=dash);
	title "Schoenfeld residuals for MET exposure after IPW- Fine and Gray";
	run; 
	proc gplot data = out_residuals;
	 symbol v = dot c = red width = 1 i = sm80s;
	 plot RESSCH_MET_1px1*years_to_end_fu /haxis = axis1 vaxis = axis2;
	 axis1 label = ('Time');
	 axis2 lable = (a = 90 'Schoenfeld residuals for MET exposure after IPW-Fine and Gray');
	run;

		/* Using robust sandwich estimator to account for uncertainty in weights: NOTE: APPARENTLY THIS IS THE DEFAULT FOR FINE AND GRAY
			HOWEVER, IT ACCOUNTS FOR MODEL MISSPECIFICATION DUE TO UNCONVENTIONAL ASSUMPTIONS OF SUBDISTRIBUTION HAZARDS- MAYBE NOT UNCERTAINTY OF 
			WEIGHTS- MAY NEED TO FURTHER DIG */ 
	    title;
		proc phreg data=thesis.cohort_psweighted_trimmed_fg covsandwich;
	         class Met_1px / param=ref order=internal ref=first; 
	         model years_to_end_fu*censor_flag1(0) = Met_1px / eventcode=1;
	         weight sipew_t / normalize; 
	         hazardratio'Sub Hazard Ratio of cancer death' Met_1px / diff = ref cl = wald; 
	         *output out = out_residuals ressch = _ALL_; 
	         *baseline covariates=Arms out=out1 cif = r timelist = (1) / rowid=exposure_arm;
        run;
         /* IPW sub HR = 1.074 (0.874-1.320), NS */


/* Cumulative incidence curves (from K Lesko) */  

proc phreg data=thesis.cohort_psweighted_trimmed_fg noprint;  
	strata Met_1px; 
	model months_to_end_fu*censor_flag1(0) = Met_1px/ eventcode=1;
	weight sipew_t / normalize; 
	baseline out=out_list cif = r; *  stdcif = stdcif;
run;

data out_list; 
set out_list; 
*lcl = r - 1.96*stdcif; 
*ucl = r + 1.96*stdcif; 
t = months_to_end_fu;
a = Met_1px; 
run;

goptions reset=all device=zgif ftext="Times New Roman" htext=12pt 
         gsfname=grafout gsfmode=replace xmax=4 ymax=4 
         xpixels=4000 ypixels=4000; *1000dpi;
axis1 label=(angle=90 "Cumulative incidence of cancer-specific mortality") order=(0 to 1.0 by 0.1) w=8 major=(w=8 h=18) minor=none offset=(0,0) origin=(17,17) pct;
axis2 label=("Months") order=(0 to 36 by 6) value=(angle=0 rotate=0) w=8 major=(w=8 h=7) minor=none offset=(0,0) origin=(17,17) pct; 
symbol1 c=lightblue v=none i=stepjs w=16 l=1;
*symbol2 c=gray  v=none i=stepjs w=16 l=22; /* suppressing arm 2 */ 
symbol2 c=red 	v=none i=stepjs w=16 l=11;
legend1 noframe across=1 shape=symbol(90,20) origin=(600,100) position=(inside) mode=protect 
value=(justify=left "Sulfonylurea/DPP-4" "Metformin") label=none;
filename grafout "S:\Pharmacoepi0216\Thesis SEER Medicare concurrent MET and ICI\Cancer_CIF_curves.png";

ods graphics on;
proc gplot data=out_list; 
plot r*t=a / vaxis=axis1 haxis=axis2 legend=legend1 noframe; 
run; 
quit;

/* problematic: To get number at risk: problematic, bc LTFU censor flags are 0 */ 

			/* total */ 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=thesis.cohort_psweighted_trimmed_fg plots =cif timelist= 0 6 12 18 24 30 36; *CIF ;
			   time months_to_end_fu*censor_flag1(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t; /* Not available for competing risks data */
			run;
			/* Time 6 (censor everyone without event at 6) */ 
			data atrisk_cancerdeath_m6; 
			set thesis.cohort_psweighted_trimmed_fg; 
			if months_to_end_fu gt 6 then censor_flag1 = 0; 
			run; 

			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_cancerdeath_m6 plots =cif timelist= 0 6 12 18 24 30 36; *CIF ;
			   time months_to_end_fu*censor_flag1(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 12 (censor everyone without event at 12) */ 

			data atrisk_cancerdeath_m12; 
			set thesis.cohort_psweighted_trimmed_fg;  
			if months_to_end_fu gt 12 then censor_flag1 = 0; 
			run; 

			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_cancerdeath_m12 plots =cif timelist= 0 6 12 18 24 30 36; *CIF ;
			   time months_to_end_fu*censor_flag1(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;

			/* Time 18 (censor everyone without event at 18) */ 

			data atrisk_cancerdeath_m18; 
			set thesis.cohort_psweighted_trimmed_fg;  
			if months_to_end_fu gt 18 then censor_flag1 = 0; 
			run;

			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_cancerdeath_m18 plots =cif timelist= 0 6 12 18 24 30 36; *CIF ;
			   time months_to_end_fu*censor_flag1(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;

			/* Time 24 (censor everyone without event at 24) */ 
			data atrisk_cancerdeath_m24; 
			set thesis.cohort_psweighted_trimmed_fg;  
			if months_to_end_fu gt 24 then censor_flag1 = 0; 
			run;

			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_cancerdeath_m24 plots =cif timelist= 0 6 12 18 24 30 36; *CIF ;
			   time months_to_end_fu*censor_flag1(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 30 (censor everyone without event at 30) */ 
			data atrisk_cancerdeath_m30; 
			set thesis.cohort_psweighted_trimmed_fg;  
			if months_to_end_fu gt 30 then censor_flag1 = 0; 
			run;

			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_cancerdeath_m30 plots =cif timelist= 0 6 12 18 24 30 36; *CIF ;
			   time months_to_end_fu*censor_flag1(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 36 (censor everyone without event at 36) */ 
			data atrisk_cancerdeath_m36; 
			set thesis.cohort_psweighted_trimmed_fg;  
			if months_to_end_fu gt 36 then censor_flag1 = 0; 
			run;

			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_cancerdeath_m36 plots =cif timelist= 0 6 12 18 24 30 36; *CIF ;
			   time months_to_end_fu*censor_flag1(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;

/************* Secondary outcome: All cause death use medicare death *******************************************/ 

* IPEW weighted cohort: All-cause death;

data thesis.cohort_psweighted_trimmed;
    set thesis.cohort_psweighted_trimmed;
    /************************************
     * Follow-up end date
     ************************************/
    fu_end_date = min(mcare_disenroll_dt, admin_censor_dt, medicare_death_dt);
    format fu_end_date date9.;
    years_to_end_fu = (fu_end_date - ici_index_dt) / 365.25; /* Use 365.25 for leap year adjustment */
    months_to_end_fu = (fu_end_date - ici_index_dt) / 30.5;
    /************************************
     * Censor flag and outcomes
     ************************************/
    /* Censor flag for Cox model */
    if fu_end_date = medicare_death_dt then censor_flag2 = 1; /* Event: all-cause death */
    else censor_flag2 = 0; /* Censored */
run;
proc freq data=thesis.cohort_psweighted_trimmed;
	tables Met_1px*(censor_flag2);
run;


/* Met_1px = 0, 209/362 = 57.73%
   Met_1px = 1, 662/1123 = 58.95% */

/* Mean/ median duration of follow-up by Met_1px */ 

data fu_duration2; 
set thesis.cohort_psweighted_trimmed;
days_followup2 = years_to_end_fu2*365.25; 
run; 

proc means data = fu_duration2 n mean p25 p50 p75 min max; 
var days_followup2 years_to_end_fu2; 
class Met_1px;
weight sipew_t;
run; 

proc univariate data = thesis.cohort_psweighted_trimmed; 
var years_to_end_fu2;
run; 

proc print data = thesis.cohort_psweighted_trimmed; 
where years_to_end_fu2 <0; 
run; 


/*** Unadjusted Hazard ratio, cumulative incidence curves, 
and cumulative incidence for all cause death */
 /*Cox PH model*/

 proc phreg data=thesis.cohort_psweighted_trimmed covsandwich;
		    title 'All cause medicare death Cox Model';
			class Met_1px / order=internal ref=first param=glm;
			model months_to_end_fu*censor_flag2(0) = Met_1px;
            hazardratio 'Hazard Ratio for Met_1px' Met_1px / cl=both; /* Add CI for HR */
			output out = schoen ressch = Met_1px_s;
		run;
         *Survival curve for all-cause mortality;
		ods graphics on;
		proc lifetest data=thesis.cohort_psweighted_trimmed plots =survival(nocensor) timelist= 0.5 1 1.5 2; 
		   time months_to_end_fu*censor_flag2(0);
		   strata Met_1px / order=internal;
		run;
 * Cloglog plot, x-axis is long time, can't be parallel;
        proc lifetest data = thesis.cohort_psweighted_trimmed plots = (s, lls);
            strata Met_1px;
            time months_to_end_fu*censor_flag2(0);
        run; 

		        * Customized cloglog plot;
		/* Step 1: Extract survival estimates */
ods output SurvivalPlot=surv_data;  /* Correct case-sensitive name for the output */
proc lifetest data=thesis.cohort_psweighted_trimmed plots=survival;  /* Use 'plots=survival' */
    strata Met_1px;
    time months_to_end_fu*censor_flag2(0);
run;
ods output close;

data surv_data;
    set surv_data;
    if Survival > 0 then log_neg_log_Survival = log(-log(Survival));
    else log_neg_log_Survival = .; /* Handle edge cases where Survival is 0 */
run;
/* Step 2: Create cloglog plot with linear time on the x-axis */
proc sgplot data=surv_data;
    scatter x=Time y=log_neg_log_Survival / group=Stratum markerattrs=(symbol=circlefilled);
    xaxis label="Time (Years)" type=linear; 
    yaxis label="log(-log(Survival Probability))";
    title "Cloglog Plot";
run;
 /* Actually overlap, but parallel */

  * Schoenfeld residual plot;
        proc gplot data = schoen;
		   symbol1 v = dot c = red width = 1 i = sm80s;
            plot Met_1px_s*months_to_end_fu / haxis = axis1 vaxis = axis2;
            axis1 label = ('Time');
            axis2 label = (a = 90 'Schoenfeld Residual for MET Exposure');
        run;
 /* Undjusted all cause HR = 1.022 (0.875-1.194)
		  PH assumption seemed to be hold*/

  /*Incidence rate of all-cause death*/
proc sql;
    create table alldeath_ir as
    select 
        Met_1px, 
        sum(years_to_end_fu) as total_person_years, 
        sum(censor_flag2=1) as num_events,  /* Count events where eventcode=1 */
        calculated num_events / calculated total_person_years as incidence_rate format=8.4
    from thesis.cohort_psweighted_trimmed
    group by Met_1px;
quit;

proc print data=alldeath_ir; 
    title "All cause death Incidence Rate per Person-Year by Exposure Group";
run;



/* Adjusted (IPTW) hazard ratio, cumulative incidence curves and cumulative incidence at 0.5, 1, 1.5, 2 years 
https://support.sas.com/resources/papers/proceedings15/SAS1855-2015.pdf */

		 title;
		proc phreg data=thesis.cohort_psweighted_trimmed covsandwich;
	         class Met_1px / param=ref order=internal ref=first; 
	         model months_to_end_fu*censor_flag2(0) = Met_1px ;
	         weight sipew_t / normalize; 
	         hazardratio'Hazard Ratio of all cause death' Met_1px / diff = ref cl = wald; 
	         output out = out_residuals ressch = _ALL_; 
	         
        run;

		    /* IPW HR = 1.069 (0.904-1.264), NS */

/* Cumulative incidence curves */  
proc phreg data=thesis.cohort_psweighted_trimmed noprint;  
	strata Met_1px; 
	model months_to_end_fu*censor_flag2(0) = Met_1px/eventcode=1 ;
	weight sipew_t / normalize; 
	baseline out=out_list cif = r; *  stdcif = stdcif;
run;

data out_list; 
set out_list; 
*lcl = r - 1.96*stdcif; 
*ucl = r + 1.96*stdcif; 
t = months_to_end_fu;
a = Met_1px; 
run;

goptions reset=all device=zgif ftext="Times New Roman" htext=12pt 
         gsfname=grafout gsfmode=replace xmax=4 ymax=4 
         xpixels=4000 ypixels=4000; *1000dpi;
axis1 label=(angle=90 "Cumulative incidence of all-cause death") order=(0 to 1.0 by 0.1) w=8 major=(w=8 h=18) minor=none offset=(0,0) origin=(17,17) pct;
axis2 label=("Months") order=(0 to 36 by 6) value=(angle=0 rotate=0) w=8 major=(w=8 h=7) minor=none offset=(0,0) origin=(17,17) pct; 
symbol1 c=lightblue v=none i=stepjs w=16 l=1;
*symbol2 c=gray  v=none i=stepjs w=16 l=22; /* suppressing arm 2 */ 
symbol2 c=red 	v=none i=stepjs w=16 l=11;
legend1 noframe across=1 shape=symbol(90,20) origin=(600,100) position=(inside) mode=protect 
value=(justify=left "NMET" "MET") label=none;
filename grafout "S:\Pharmacoepi0216\Thesis SEER Medicare concurrent MET and ICI\Allcause_CIF_curves.png";

ods graphics on;
proc gplot data=out_list; 
plot r*t=a / vaxis=axis1 haxis=axis2 legend=legend1 noframe; 
run; 
quit;
           /* total */ 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=thesis.cohort_psweighted_trimmed plots =cif timelist= 0 6 12 18 24 30 36; *CIF ;
			   time months_to_end_fu*censor_flag2(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t; /* Not available for competing risks data */
			run;
           /* Time 6 (censor everyone without event at 6) */ 
			data atrisk_alldeath_m6; 
			set thesis.cohort_psweighted_trimmed; 
			if months_to_end_fu gt 6 then censor_flag2 = 0; 
			run; 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_alldeath_m6 plots =cif timelist= 0 6 12 18 24 30 36; *CIF ;
			   time months_to_end_fu*censor_flag2(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 12 (censor everyone without event at 12) */ 
			data atrisk_alldeath_m12; 
			set thesis.cohort_psweighted_trimmed; 
			if months_to_end_fu gt 12 then censor_flag2 = 0; 
			run; 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_alldeath_m12 plots =cif timelist= 0 6 12 18 24 30 36; *CIF ;
			   time months_to_end_fu*censor_flag2(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 18 (censor everyone without event at 18) */ 
			data atrisk_alldeath_m18; 
			set thesis.cohort_psweighted_trimmed; 
			if months_to_end_fu gt 18 then censor_flag2 = 0; 
			run; 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_alldeath_m18 plots =cif timelist= 0 6 12 18 24 30 36; *CIF ;
			   time months_to_end_fu*censor_flag2(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 24 (censor everyone without event at 24) */ 
			data atrisk_alldeath_m24; 
			set thesis.cohort_psweighted_trimmed; 
			if months_to_end_fu gt 24 then censor_flag2 = 0; 
			run; 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_alldeath_m24 plots =cif timelist= 0 6 12 18 24 30 36; *CIF ;
			   time months_to_end_fu*censor_flag2(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 30 (censor everyone without event at 30) */ 
			data atrisk_alldeath_m30; 
			set thesis.cohort_psweighted_trimmed; 
			if months_to_end_fu gt 30 then censor_flag2 = 0; 
			run; 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_alldeath_m30 plots =cif timelist= 0 6 12 18 24 30 36; *CIF ;
			   time months_to_end_fu*censor_flag2(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 36 (censor everyone without event at 36) */ 
			data atrisk_alldeath_m36; 
			set thesis.cohort_psweighted_trimmed; 
			if months_to_end_fu gt 36 then censor_flag2 = 0; 
			run; 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_alldeath_m36 plots =cif timelist= 0 6 12 18 24 30 36; *CIF ;
			   time months_to_end_fu*censor_flag2(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;

/* Not needed: Adjusted HR by Cox Model */
		 proc phreg data=thesis.cohort_psweighted_trimmed covsandwich;
		    title 'All cause death Cox Model';
			class Met_1px / order=internal ref=first param=glm;
			model months_to_end_fu*censor_flag2(0) = Met_1px sex_binary Race_NHB Race_Hisp Race_Other /* Same list of categorical variables from 'class' statement */ 
                 yr_dx_2014 yr_dx_2015 yr_dx_2016 yr_dx_2017 yr_dx_2018 yr_dx_2019
				 urbanrural_binary 
                 stage_reg stage_unk stage_dis
                 chemo;
		    hazardratio'Hazard Ratio of all cause death' Met_1px / diff = ref cl = wald; 
		run;

/********************** March 20 update: 978 subset iptw cohort***********************/
/***************** Primary outcome: Time to cancer-specific death ********************/
data thesis.cohort_psweighted_fg_trimmed;
    set thesis.cohort_psweighted_fg_trimmed;
    if medicare_death_dt > '31DEC2019'd then medicare_death_dt = .;
run;
proc means data = thesis.cohort_psweighted_fg_trimmed;
var medicare_death_dt;
run;

proc summary data=thesis.cohort_psweighted_fg_trimmed nway;
    var medicare_death_dt;
    output out=summary_results (drop=_:) min=MinDate max=MaxDate;
run; 
/* Primary outcome: cancer death */
data thesis.cohort_psweighted_fg_trimmed;
    set thesis.cohort_psweighted_fg_trimmed;

	/* Use medicare_death_dt */
    if cancer_death = "1" or noncancer_death = "1" then cause_death_dt = medicare_death_dt;
    else cause_death_dt = .;
	format cause_death_dt date9.;
run;
data thesis.cohort_psweighted_fg_trimmed;
    set thesis.cohort_psweighted_fg_trimmed;
    /************************************
     * Follow-up end date
     ************************************/
    fu_end_date = min(mcare_disenroll_dt, admin_censor_dt, cause_death_dt);
    format fu_end_date date9.;
    years_to_end_fu = (fu_end_date - ici_index_dt) / 365.25; /* Use 365.25 for leap year adjustment */
    months_to_end_fu = (fu_end_date - ici_index_dt) / 30.5;
    /************************************
     * Censor flag and outcomes
     ************************************/
    /* Censor flag for competing risks model */
    if fu_end_date = cause_death_dt and cancer_death = '1' then censor_flag1 = 1; /* Event: cancer death */
    else if fu_end_date = cause_death_dt and noncancer_death = '1' then censor_flag1 = 2; /* Event: non-cancer death */
    else censor_flag1 = 0; /* Censored */

    /* Censor flag for Cox model */
    if fu_end_date = cause_death_dt then censor_flag2 = 1; /* Event: all-cause death */
    else censor_flag2 = 0; /* Censored */
run;

/*Summary of number of cases*/
proc freq data=thesis.cohort_psweighted_fg_trimmed;
	tables Met_1px*(censor_flag1 censor_flag2);
run;
 /* 978 = 729+249 rows */
 /* Crude outcome comparison without accounting for confounding */
proc means data = thesis.cohort_psweighted_fg_trimmed mean sum min max nothreads;
class Met_1px;
var sipew_t; 
run; 

/* Mean/ median duration of follow-up by Met_1px */ 
data fu_duration; 
set thesis.cohort_psweighted_fg_trimmed;
days_followup = years_to_end_fu*365.25; 
run; 

 /* Median follow-up time by Met_1px */
proc means data = fu_duration n mean p25 p50 p75 min max; 
var years_to_end_fu months_to_end_fu; 
class Met_1px;
*var sipew_t;
run; 

proc univariate data = thesis.cohort_psweighted_fg_trimmed; 
var years_to_end_fu months_to_end_fu;
by Met_1px;
run; 

proc print data = thesis.cohort_psweighted_fg_trimmed; 
where years_to_end_fu <0; 
run;  /*After use medicare death date, no < 0 */

/*** Unadjusted Hazard ratio, cumulative incidence curves, 
and cumulative incidence at 0.5, 1, 1.5, 2 yrs, 
for cancer death */

* Cancer death; 
proc phreg data=thesis.cohort_psweighted_fg_trimmed; 
	class Met_1px / param=glm order=internal ref=first;
	model years_to_end_fu*censor_flag1(0) = Met_1px / eventcode=1;
	hazardratio 'Subdistribution Hazards' Met_1px / diff=pairwise;
run;

ods graphics on;
proc lifetest data=thesis.cohort_psweighted_fg_trimmed plots =cif(test) timelist= 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5; *Cumulative incidence curve for death;
   time years_to_end_fu*censor_flag1(0) / eventcode = 1;
   strata Met_1px / order=internal;
run;
/* Incidence rates */
proc sql;
    create table cancerdeath_ir as
    select 
        Met_1px, 
        sum(years_to_end_fu) as total_person_years, 
        sum(censor_flag1=1) as num_events,  /* Count events where eventcode=1 */
        calculated num_events / calculated total_person_years as incidence_rate format=8.4
    from thesis.cohort_psweighted_fg_trimmed
    group by Met_1px;
quit;
proc print data=cancerdeath_ir; 
    title "Cancer death Incidence Rate per Person-Year by Exposure Group";
run;

 /* unadjusted cancer death HR = 0.98, crude incidence rates without 95% CI */


/* Adjusted IPEW hazard ratio, cumulative incidence curves and cumulative incidence at 0.5, 1, 1.5, 2,2.5, 3, 3.5, 4, 4.5, 5 years 
https://support.sas.com/resources/papers/proceedings15/SAS1855-2015.pdf */

* Cancer death; 
/* To get aHR */ 
ods graphics on; 
proc phreg data=thesis.cohort_psweighted_fg_trimmed plots(overlay=bystratum)=cif;
	class Met_1px / param=ref order=internal ref=first; 
	model years_to_end_fu*censor_flag1(0) = Met_1px / eventcode=1;
	weight sipew_t / normalize; 
	hazardratio'Sub Hazard Ratio of cancer death' Met_1px / diff = ref cl = wald; 
	output out = out_residuals ressch = _ALL_; 
	*baseline covariates=Arms out=out1 cif = r timelist = (1) / rowid=exposure_arm;
run;

	ods graphics /antialiasmax = 19600; 
	proc sgplot data = out_residuals;
	scatter x = years_to_end_fu y = RESSCH_MET_1px1; 
	xaxis min = 0 max =1; 
	refline 0 / axis=y lineattrs=(thickness=1 color=darkred pattern=dash);
	title "Schoenfeld residuals for MET exposure after IPW- Fine and Gray";
	run; 
	proc gplot data = out_residuals;
	 symbol v = dot c = red width = 1 i = sm80s;
	 plot RESSCH_MET_1px1*years_to_end_fu /haxis = axis1 vaxis = axis2;
	 axis1 label = ('Time');
	 axis2 lable = (a = 90 'Schoenfeld residuals for MET exposure after IPW-Fine and Gray');
	run;

		/* Using robust sandwich estimator to account for uncertainty in weights: NOTE: APPARENTLY THIS IS THE DEFAULT FOR FINE AND GRAY
			HOWEVER, IT ACCOUNTS FOR MODEL MISSPECIFICATION DUE TO UNCONVENTIONAL ASSUMPTIONS OF SUBDISTRIBUTION HAZARDS- MAYBE NOT UNCERTAINTY OF 
			WEIGHTS- MAY NEED TO FURTHER DIG */ 
	    title;
		proc phreg data=thesis.cohort_psweighted_fg_trimmed covsandwich;
	         class Met_1px / param=ref order=internal ref=first; 
	         model years_to_end_fu*censor_flag1(0) = Met_1px / eventcode=1;
	         weight sipew_t / normalize; 
	         hazardratio'Sub Hazard Ratio of cancer death' Met_1px / diff = ref cl = wald; 
	         *output out = out_residuals ressch = _ALL_; 
	         *baseline covariates=Arms out=out1 cif = r timelist = (1) / rowid=exposure_arm;
        run;
         /* IPW sub HR = 1.082 (0.879-1.333), NS */

/* Cumulative incidence curves (from K Lesko) */  

proc phreg data=thesis.cohort_psweighted_fg_trimmed noprint;  
	strata Met_1px; 
	model months_to_end_fu*censor_flag1(0) = Met_1px/ eventcode=1;
	weight sipew_t / normalize; 
	baseline out=out_list cif = r; *  stdcif = stdcif;
run;

data out_list; 
set out_list; 
*lcl = r - 1.96*stdcif; 
*ucl = r + 1.96*stdcif; 
t = months_to_end_fu;
a = Met_1px; 
run;
/* 54 months, longest follow-up,
but choose to show until 48 months since afer that no cases occurred */
goptions reset=all device=zgif ftext="Times New Roman" htext=12pt 
         gsfname=grafout gsfmode=replace xmax=4 ymax=4 
         xpixels=4000 ypixels=4000; *1000dpi;
axis1 label=(angle=90 "Cumulative incidence of cancer-specific mortality") order=(0 to 1.0 by 0.1) w=8 major=(w=8 h=18) minor=none offset=(0,0) origin=(17,17) pct;
axis2 label=("Months") order=(0 to 48 by 12) value=(angle=0 rotate=0) w=8 major=(w=8 h=7) minor=none offset=(0,0) origin=(17,17) pct; 
symbol1 c=lightblue v=none i=stepjs w=16 l=1;
*symbol2 c=gray  v=none i=stepjs w=16 l=22; /* suppressing arm 2 */ 
symbol2 c=red 	v=none i=stepjs w=16 l=11;
legend1 noframe across=1 shape=symbol(90,20) origin=(600,100) position=(inside) mode=protect 
value=(justify=left "Sulfonylurea/DPP-4" "Metformin") label=none;
filename grafout "S:\Pharmacoepi0216\Thesis SEER Medicare concurrent MET and ICI\Cancer_CIF_curves.png";

ods graphics on;
proc gplot data=out_list; 
plot r*t=a / vaxis=axis1 haxis=axis2 legend=legend1 noframe; 
run; 
quit;

			/* total */ 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=thesis.cohort_psweighted_fg_trimmed plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag1(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t; /* Not available for competing risks data */
			run;
			/* Time 6 (censor everyone without event at 6) */ 
			data atrisk_cancerdeath_m6; 
			set thesis.cohort_psweighted_fg_trimmed; 
			if months_to_end_fu gt 6 then censor_flag1 = 0; 
			run; 

			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_cancerdeath_m6 plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag1(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 12 (censor everyone without event at 12) */ 
			data atrisk_cancerdeath_m12; 
			set thesis.cohort_psweighted_fg_trimmed;  
			if months_to_end_fu gt 12 then censor_flag1 = 0; 
			run; 

			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_cancerdeath_m12 plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag1(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 18 (censor everyone without event at 18) */ 
			data atrisk_cancerdeath_m18; 
			set thesis.cohort_psweighted_fg_trimmed;  
			if months_to_end_fu gt 18 then censor_flag1 = 0; 
			run;

			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_cancerdeath_m18 plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag1(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 24 (censor everyone without event at 24) */ 
			data atrisk_cancerdeath_m24; 
			set thesis.cohort_psweighted_fg_trimmed;  
			if months_to_end_fu gt 24 then censor_flag1 = 0; 
			run;

			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_cancerdeath_m24 plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag1(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 30 (censor everyone without event at 30) */ 
			data atrisk_cancerdeath_m30; 
			set thesis.cohort_psweighted_fg_trimmed;  
			if months_to_end_fu gt 30 then censor_flag1 = 0; 
			run;

			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_cancerdeath_m30 plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag1(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 36 (censor everyone without event at 36) */ 
			data atrisk_cancerdeath_m36; 
			set thesis.cohort_psweighted_fg_trimmed;  
			if months_to_end_fu gt 36 then censor_flag1 = 0; 
			run;

			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_cancerdeath_m36 plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag1(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 42 (censor everyone without event at 42) */ 
			data atrisk_cancerdeath_m42; 
			set thesis.cohort_psweighted_fg_trimmed;  
			if months_to_end_fu gt 42 then censor_flag1 = 0; 
			run;

			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_cancerdeath_m42 plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag1(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 48 (censor everyone without event at 48) */ 
			data atrisk_cancerdeath_m48; 
			set thesis.cohort_psweighted_fg_trimmed;  
			if months_to_end_fu gt 48 then censor_flag1 = 0; 
			run;

			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_cancerdeath_m48 plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag1(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 54 (censor everyone without event at 48) */ 
			data atrisk_cancerdeath_m54; 
			set thesis.cohort_psweighted_fg_trimmed;  
			if months_to_end_fu gt 54 then censor_flag1 = 0; 
			run;

			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_cancerdeath_m54 plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag1(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;

/************* Secondary outcome: All cause death use medicare death *******************************************/ 

* IPEW weighted cohort: All-cause death;

data thesis.cohort_psweighted_trimmed;
    set thesis.cohort_psweighted_trimmed;
    /************************************
     * Follow-up end date
     ************************************/
    fu_end_date = min(mcare_disenroll_dt, admin_censor_dt, medicare_death_dt);
    format fu_end_date date9.;
    years_to_end_fu = (fu_end_date - ici_index_dt) / 365.25; /* Use 365.25 for leap year adjustment */
    months_to_end_fu = (fu_end_date - ici_index_dt) / 30.5;
    /************************************
     * Censor flag and outcomes
     ************************************/
    /* Censor flag for Cox model */
    if fu_end_date = medicare_death_dt then censor_flag2 = 1; /* Event: all-cause death */
    else censor_flag2 = 0; /* Censored */
run;
proc freq data=thesis.cohort_psweighted_trimmed;
	tables Met_1px*(censor_flag2);
run;


/* Met_1px = 0, 209/362 = 57.73%
   Met_1px = 1, 662/1123 = 58.95% */

/* Mean/ median duration of follow-up by Met_1px */ 

data fu_duration2; 
set thesis.cohort_psweighted_trimmed;
days_followup = years_to_end_fu*365.25; 
run; 

proc means data = fu_duration2 n mean p25 p50 p75 min max; 
var days_followup years_to_end_fu; 
class Met_1px;
*weight sipew_t;
run; 

proc univariate data = thesis.cohort_psweighted_trimmed; 
var years_to_end_fu;
run; 

proc print data = thesis.cohort_psweighted_trimmed; 
where years_to_end_fu <0; 
run; 


/*** Unadjusted Hazard ratio, cumulative incidence curves, 
and cumulative incidence for all cause death */
 /*Cox PH model*/

 proc phreg data=thesis.cohort_psweighted_trimmed covsandwich;
		    title 'All cause medicare death Cox Model';
			class Met_1px / order=internal ref=first param=glm;
			model months_to_end_fu*censor_flag2(0) = Met_1px;
            hazardratio 'Hazard Ratio for Met_1px' Met_1px / cl=both; /* Add CI for HR */
			output out = schoen ressch = Met_1px_s;
		run;
         *Survival curve for all-cause mortality;
		ods graphics on;
		proc lifetest data=thesis.cohort_psweighted_trimmed plots =survival(nocensor) timelist= 0.5 1 1.5 2; 
		   time months_to_end_fu*censor_flag2(0);
		   strata Met_1px / order=internal;
		run;
 * Cloglog plot, x-axis is long time, can't be parallel;
        proc lifetest data = thesis.cohort_psweighted_trimmed plots = (s, lls);
            strata Met_1px;
            time months_to_end_fu*censor_flag2(0);
        run; 

		        * Customized cloglog plot;
		/* Step 1: Extract survival estimates */
ods output SurvivalPlot=surv_data;  /* Correct case-sensitive name for the output */
proc lifetest data=thesis.cohort_psweighted_trimmed plots=survival;  /* Use 'plots=survival' */
    strata Met_1px;
    time months_to_end_fu*censor_flag2(0);
run;
ods output close;

data surv_data;
    set surv_data;
    if Survival > 0 then log_neg_log_Survival = log(-log(Survival));
    else log_neg_log_Survival = .; /* Handle edge cases where Survival is 0 */
run;
/* Step 2: Create cloglog plot with linear time on the x-axis */
proc sgplot data=surv_data;
    scatter x=Time y=log_neg_log_Survival / group=Stratum markerattrs=(symbol=circlefilled);
    xaxis label="Time (Years)" type=linear; 
    yaxis label="log(-log(Survival Probability))";
    title "Cloglog Plot";
run;
 /* Actually overlap, but parallel */

  * Schoenfeld residual plot;
        proc gplot data = schoen;
		   symbol1 v = dot c = red width = 1 i = sm80s;
            plot Met_1px_s*months_to_end_fu / haxis = axis1 vaxis = axis2;
            axis1 label = ('Time');
            axis2 label = (a = 90 'Schoenfeld Residual for MET Exposure');
        run;
 /* Undjusted all cause HR = 1.022 (0.875-1.194)
		  PH assumption seemed to be hold*/

  /*Incidence rate of all-cause death*/
proc sql;
    create table alldeath_ir as
    select 
        Met_1px, 
        sum(years_to_end_fu) as total_person_years, 
        sum(censor_flag2=1) as num_events,  /* Count events where eventcode=1 */
        calculated num_events / calculated total_person_years as incidence_rate format=8.4
    from thesis.cohort_psweighted_trimmed
    group by Met_1px;
quit;

proc print data=alldeath_ir; 
    title "All cause death Incidence Rate per Person-Year by Exposure Group";
run;



/* Adjusted (IPTW) hazard ratio, cumulative incidence curves and cumulative incidence at 0.5, 1, 1.5, 2 years 
https://support.sas.com/resources/papers/proceedings15/SAS1855-2015.pdf */

		 title;
		proc phreg data=thesis.cohort_psweighted_trimmed covsandwich;
	         class Met_1px / param=ref order=internal ref=first; 
	         model months_to_end_fu*censor_flag2(0) = Met_1px ;
	         weight sipew_t / normalize; 
	         hazardratio'Hazard Ratio of all cause death' Met_1px / diff = ref cl = wald; 
	         output out = out_residuals ressch = _ALL_; 
	         
        run;

		    /* IPW HR = 1.069 (0.904-1.264), NS */

/* Cumulative incidence curves */  
proc phreg data=thesis.cohort_psweighted_trimmed noprint;  
	strata Met_1px; 
	model months_to_end_fu*censor_flag2(0) = Met_1px/eventcode=1 ;
	weight sipew_t / normalize; 
	baseline out=out_list cif = r; *  stdcif = stdcif;
run;

data out_list; 
set out_list; 
*lcl = r - 1.96*stdcif; 
*ucl = r + 1.96*stdcif; 
t = months_to_end_fu;
a = Met_1px; 
run;

goptions reset=all device=zgif ftext="Times New Roman" htext=12pt 
         gsfname=grafout gsfmode=replace xmax=4 ymax=4 
         xpixels=4000 ypixels=4000; *1000dpi;
axis1 label=(angle=90 "Cumulative incidence of all-cause mortality") order=(0 to 1.0 by 0.1) w=8 major=(w=8 h=18) minor=none offset=(0,0) origin=(17,17) pct;
axis2 label=("Months") order=(0 to 48 by 12) value=(angle=0 rotate=0) w=8 major=(w=8 h=7) minor=none offset=(0,0) origin=(17,17) pct; 
symbol1 c=lightblue v=none i=stepjs w=16 l=1;
*symbol2 c=gray  v=none i=stepjs w=16 l=22; /* suppressing arm 2 */ 
symbol2 c=red 	v=none i=stepjs w=16 l=11;
legend1 noframe across=1 shape=symbol(90,20) origin=(600,100) position=(inside) mode=protect 
value=(justify=left "Sulfonylurea/DPP-4" "Metformin") label=none;
filename grafout "S:\Pharmacoepi0216\Thesis SEER Medicare concurrent MET and ICI\Allcause_CIF_curves.png";

ods graphics on;
proc gplot data=out_list; 
plot r*t=a / vaxis=axis1 haxis=axis2 legend=legend1 noframe; 
run; 
quit;
           /* total */ 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=thesis.cohort_psweighted_trimmed plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag2(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t; /* Not available for competing risks data */
			run;
           /* Time 6 (censor everyone without event at 6) */ 
			data atrisk_alldeath_m6; 
			set thesis.cohort_psweighted_trimmed; 
			if months_to_end_fu gt 6 then censor_flag2 = 0; 
			run; 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_alldeath_m6 plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag2(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 12 (censor everyone without event at 12) */ 
			data atrisk_alldeath_m12; 
			set thesis.cohort_psweighted_trimmed; 
			if months_to_end_fu gt 12 then censor_flag2 = 0; 
			run; 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_alldeath_m12 plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag2(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 18 (censor everyone without event at 18) */ 
			data atrisk_alldeath_m18; 
			set thesis.cohort_psweighted_trimmed; 
			if months_to_end_fu gt 18 then censor_flag2 = 0; 
			run; 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_alldeath_m18 plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag2(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 24 (censor everyone without event at 24) */ 
			data atrisk_alldeath_m24; 
			set thesis.cohort_psweighted_trimmed; 
			if months_to_end_fu gt 24 then censor_flag2 = 0; 
			run; 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_alldeath_m24 plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag2(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 30 (censor everyone without event at 30) */ 
			data atrisk_alldeath_m30; 
			set thesis.cohort_psweighted_trimmed; 
			if months_to_end_fu gt 30 then censor_flag2 = 0; 
			run; 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_alldeath_m30 plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag2(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 36 (censor everyone without event at 36) */ 
			data atrisk_alldeath_m36; 
			set thesis.cohort_psweighted_trimmed; 
			if months_to_end_fu gt 36 then censor_flag2 = 0; 
			run; 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_alldeath_m36 plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag2(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 42 (censor everyone without event at 42) */ 
			data atrisk_alldeath_m42; 
			set thesis.cohort_psweighted_trimmed; 
			if months_to_end_fu gt 42 then censor_flag2 = 0; 
			run; 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_alldeath_m42 plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag2(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 48 (censor everyone without event at 48) */ 
			data atrisk_alldeath_m48; 
			set thesis.cohort_psweighted_trimmed; 
			if months_to_end_fu gt 48 then censor_flag2 = 0; 
			run; 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_alldeath_m48 plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag2(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;
			/* Time 54 (censor everyone without event at 54) */ 
			data atrisk_alldeath_m54; 
			set thesis.cohort_psweighted_trimmed; 
			if months_to_end_fu gt 54 then censor_flag2 = 0; 
			run; 
			ods graphics on;
			*ods output ProductLimitEstimates=out_limits;
			proc lifetest data=atrisk_alldeath_m54 plots =cif timelist= 0 6 12 18 24 30 36 42 48 54; *CIF ;
			   time months_to_end_fu*censor_flag2(0) /eventcode = 1;
			   strata Met_1px / order=internal;
			   *weight sw_strat_t;
			run;


