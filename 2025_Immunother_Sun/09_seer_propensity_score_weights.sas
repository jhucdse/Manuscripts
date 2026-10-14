*******************************************************************************;
* Program name      :	xx_propensity_score_weights
* Author            :	Jamie Heyward
* Date created      :	July 11 2022
* Study             : 	
* Purpose           :	Calculate propensity score weights to ensure covariate balance between MET exposure arms.
* Inputs            :	
* Program completed : 	
* Updated by        :   Xinyi Sun Jan 13 2025
*********************************************************************************;

LIBNAME seer 'S:\Pharmacoepi0216\Thesis';
LIBNAME thesis 'S:\Pharmacoepi0216\Thesis_new';
/* Clear any titles from prior figures */ 
title;


		/* Add labels to the different categorical variables */ 

		proc format; 
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
							'8'= "Radiation recommended, unknown if administered"
					run; 
proc format;
    value $Race
        '1' = "Non-Hispanic White"
        '2' = "Non-Hispanic Black"
        '5' = "Hispanic"
        '4' = "Other";
run;
/*Not needed*/
data thesis.cohort_outcomes2; 
set thesis.cohort_outcomes2;
format RACEANDORIGINRECODENHWNHBNHAIAN $RaceNH_H.
	 	sex $Sex.
		primary_payer_at_dx $Payer.
		marital_status_at_diagnosis $MaritalStatus.
		exposure_arm ExposureArm.
		combined_summary_stage_2004 $Stage. 
		sequence_number $SequenceNo. 
		primary_site $PrimarySite.
		laterality $Laterality.
		behavior_recode_for_analysis $Behavior.
		RX_Summ_Surg_Prim_Site_1998 $RxSummSurg.
		radiation_recode $Radiation.;
	run; 


/*proc print data = thesis.cohort_outcomes2 (obs = 10); */
/*run;*/
/* use thesis.Rdat_cohort */

/* April 6 update: Subset to overlap_flags1 N = 802 */
proc contents data = thesis.Rdat_cohort; 
run;

proc sql;
 create table thesis.Rdat_cohort as
 select *
 from thesis.Rdat_cohort
 where patient_id in (select distinct patient_id from overlap_flags1);
 quit; 
/* Manual calculation of propensity score weights 

/* Step 1. Propensity Score calculation */ 

	/* Missingness of covariates in dataset: include only those that are nonmissing for all patients */ 
	proc freq data = thesis.Rdat_cohort nlevels;
	table _all_ /noprint;
	run; 


/*

Covariates in model : 

Sociodemographic characteristics
	age_at_ICI
	sex (need to recode to 0,1)
	Race (need to create dummy var)
	year_of_diagnosis (need to create dummy var)
	urbanrural_binary

Cancer characteristics
	stage (need to create dummy var)
   
	(sequence_number
	primary_site
	laterality)						[Area of lungs where tumor is]


Cancer treatment
	chemo (or firstline, they are reverse)
	chemo_count
	days_dx_to_tx
	

Comorbidities
	NCI_index 

*/


*Calculating inverse probability weights

* Analysis cohort: convert continuous/ordinal categorical variables to numeric;

proc freq data = thesis.Rdat_cohort; 
tables MET_1px * (sex Race year_of_diagnosis urbanrural_binary stage chemo);
run;
proc means data= thesis.Rdat_cohort; 
    var age_at_ICI chemo_count days_dx_to_tx NCI_index;
    class Met_1px;
run;
  /* Note: Need to create additonal binary indicator race_NHW, yr_dx_2013, stage_loc for SMD */
data thesis.cohort_psweights; 
    set thesis.Rdat_cohort; 
    *where cancer_death ne '.'; /*If full cohort, don't*/
    /* Create binary dummy vars for each categorical variable */
    if sex = 1 then sex_binary = 1; else sex_binary = 0;

    if Race = 1 then Race_NHW = 1; else Race_NHW = 0; 
    if Race = 2 then Race_NHB = 1; else Race_NHB = 0;
    if Race = 5 then Race_Hisp = 1; else Race_Hisp = 0;
    if Race = 4 then Race_Other = 1; else Race_Other = 0;
    
	if year_of_diagnosis = '2013' then yr_dx_2013 = 1; else yr_dx_2013 = 0;
    if year_of_diagnosis = '2014' then yr_dx_2014 = 1; else yr_dx_2014 = 0;
    if year_of_diagnosis = '2015' then yr_dx_2015 = 1; else yr_dx_2015 = 0;
    if year_of_diagnosis = '2016' then yr_dx_2016 = 1; else yr_dx_2016 = 0;
    if year_of_diagnosis = '2017' then yr_dx_2017 = 1; else yr_dx_2017 = 0;
    if year_of_diagnosis = '2018' then yr_dx_2018 = 1; else yr_dx_2018 = 0;
    if year_of_diagnosis = '2019' then yr_dx_2019 = 1; else yr_dx_2019 = 0;
    
	if stage = 'Localized' then stage_loc = 1; else stage_loc = 0;
    if stage = 'Regional by direct extension only' then stage_reg = 1; else stage_reg = 0;
    if stage = 'Unknown' then stage_unk = 1; else stage_unk = 0;
	if stage = 'Distant' then stage_dis = 1; else stage_dis = 0;

run;

proc freq data = thesis.cohort_psweights; 
tables MET_1px * (sex Race year_of_diagnosis urbanrural_binary stage chemo);
*tables Met_1px* (sex_binary Race_NHW Race_NHB Race_Hisp Race_Other
                 yr_dx_2013 yr_dx_2014 yr_dx_2015 yr_dx_2016 yr_dx_2017 yr_dx_2018 yr_dx_2019
                 stage_loc stage_reg stage_unk stage_dis);
run;

proc means data=thesis.cohort_psweights;
     var age_at_ICI chemo_count days_dx_to_tx NCI_index;
    class Met_1px;
run;
proc contents data = thesis.cohort_psweights; 
run; 
/*** IPEW ***/
*Estimate denominator for ipew - output a dataset called denom_ipew, prob is ps, denominator depends on Met_1px;

proc logistic data=thesis.cohort_psweights desc;
class sex_binary Race_NHB Race_Hisp Race_Other
                 yr_dx_2014 yr_dx_2015 yr_dx_2016 yr_dx_2017 yr_dx_2018 yr_dx_2019
				 urbanrural_binary 
                 stage_reg stage_unk stage_dis
                 chemo;
model Met_1px =  sex_binary Race_NHB Race_Hisp Race_Other /* Same list of categorical variables from 'class' statement */ 
                 yr_dx_2014 yr_dx_2015 yr_dx_2016 yr_dx_2017 yr_dx_2018 yr_dx_2019
				 urbanrural_binary 
                 stage_reg stage_unk stage_dis
                 chemo
				 /* Continuous variables not included in 'class' statment; all are numeric */
				 age_at_ICI chemo_count days_dx_to_tx NCI_index
					 / link = glogit;
output out=denom_ipew p= ps;
run;
/*Transform denominator*/ 
proc freq data = denom_ipew;
tables _LEVEL_;
run; /* ps = P(Met_1px =1| covs) */

data denom_ipew; 
    set denom_ipew; 
    if Met_1px = 1 then d_e = ps;
    else if Met_1px = 0 then d_e = 1 - ps;
    keep patient_id ps d_e;  /* remove ps */
run;

proc means data = denom_ipew; 
var d_e; 
run; 

*Generate numerator for stabilized ipew - output a dataset called num_ipew, P(E=e), where e = observed exposure status;

proc logistic data=thesis.cohort_psweights desc;
model Met_1px= /link = glogit;
output out=num_ipew p=ps;
run;

*Transform numerator;
data num_ipew; 
    set num_ipew; 
    if Met_1px = 1 then n_e = ps;
    else if Met_1px = 0 then n_e = 1 - ps;
    keep patient_id n_e;  
run;

*Generate stabilized and unstabilized weights by merging the datasets with regression output (merge on the unique identifier in your dataset, &id);

data thesis.cohort_psweighted;
merge thesis.cohort_psweights denom_ipew num_ipew ;
by patient_id;
ipew = 1/d_e; 
sipew = n_e * ipew;
run;

	proc print data = thesis.cohort_psweighted (obs = 10); 
	run;

*Check the distribution of your IPTW - the mean should be 1. Sum for uw should be 2x the sum of sw. Range of uw should be greater than sw;

proc means data = thesis.cohort_psweighted mean sum min max p1 p99;
var ipew sipew; 
run; 

proc means data = thesis.cohort_psweighted mean sum min max p1 p99;
var ipew sipew; 
class Met_1px;
run; 

proc means data = thesis.cohort_psweighted mean sum min max; 
var d_e n_e; 
run; 

		/* 

Variable Mean Sum Minimum Maximum 1st Pctl 99th Pctl 
uw 2.0024817  2973.69  1.0695134  14.7718287  1.0983618  7.9369764
sw 1.0004757  1485.71  0.2786866  3.6009441   0.4742586  1.9832956

 well stablized

		*/

* Trim the lower and upper 1% of weights (creating new weight variable sw_t); 
data thesis.cohort_psweighted_trimmed;
set thesis.cohort_psweighted; 
if sipew > 1.9832956 then sipew_t = 1.9832956; 
else if sipew < 0.4742586 then sipew_t = 0.4742586; 
else sipew_t = sipew; 
run;
*April 6 update;
data thesis.cohort_psweighted_trimmed;
set thesis.cohort_psweighted; 
if sipew > 1.9050690 then sipew_t = 1.9050690; 
else if sipew < 0.5125229 then sipew_t = 0.5125229; 
else sipew_t = sipew; 
run;

proc means data= thesis.cohort_psweighted_trimmed mean sum min max nothreads;
var sipew_t;
run;


proc means data= thesis.cohort_psweighted_trimmed mean sum min max nothreads;
var sipew_t;
class Met_1px;
run;

*Trim the lower 3.3% of weights in each exposure arm (method 2, From Yoshida et al. https://academic.oup.com/aje/article/188/3/609/5231606);
/*
proc univariate data = thesis.cohort_psweighted noprint;
var sipew; 
class Met_1px;
output out = pctl33 pctlpts = 3.3 pctlpre = pctl; 
run; 

data thesis.cohort_psweighted_trimmed1;
set thesis.cohort_psweighted; 
if Met_1px = 0 and sipew < 0.4473092222 then sipew_t2 = 0.4473092222; 
else if Met_1px = 0 and sipew ge 0.4473092222 then sipew_t2 = sipew;
if Met_1px = 1 and sipew < 0.8420486969 then sipew_t2 = 0.8420486969; 
else if Met_1px = 1 and sipew ge 0.8420486969 then sipew_t2 = sipew;
run; 

proc means data= thesis.cohort_psweighted_trimmed1 mean sum min max nothreads;
var sipew_t2;
class Met_1px;
run;
*/
	*Trim the lower and upper 1% of weights within each exposure arm;
/*
proc means data = thesis.cohort_psweighted mean sum min max p1 p99;
var ipew sipew; 
class Met_1px; 
run; 

data thesis.cohort_psweighted_trimmed2;
set thesis.cohort_psweighted; 
if Met_1px = 0 and sipew < 0.3786393 then sipew_t3 = 0.3786393; 
else if Met_1px = 0 and sipew > 2.5754904 then sipew_t3 = 2.5754904;
if Met_1px = 1 and sipew < 0.8295798 then sipew_t3 = 0.8295798; 
else if Met_1px = 1 and sipew > 1.6067039 then sipew_t3 = 1.6067039;
run; 
*/

*Check to see if exposure and covariates are associated in new pseudopopulation (thesis.cohort_psweighted);

proc logistic data=thesis.cohort_psweighted_trimmed desc;
weight sipew;
class sex_binary Race_NHB Race_Hisp Race_Other
                 yr_dx_2014 yr_dx_2015 yr_dx_2016 yr_dx_2017 yr_dx_2018 yr_dx_2019
				 urbanrural_binary 
                 stage_reg stage_unk stage_dis
                 chemo;
model Met_1px =  sex_binary Race_NHB Race_Hisp Race_Other /* Same list of categorical variables from 'class' statement */ 
                 yr_dx_2014 yr_dx_2015 yr_dx_2016 yr_dx_2017 yr_dx_2018 yr_dx_2019
				 urbanrural_binary 
                 stage_reg stage_unk stage_dis
                 chemo
				 /* Continuous variables not included in 'class' statment; all are numeric */
				 age_at_ICI chemo_count days_dx_to_tx NCI_index
					 / link = glogit;			
run;

	*It doesn't appear that any of the odds ratio estimates for exposure(1 vs 0) are very high are very low for any of the covariates. 
		There are some that are low or high due to small sample size.; 



/* Balancing: Diagnostics */ 

* Areas of common support: For each exposure, display distribution of d (predicted prob) for the exposure arms; 

		/* Boxplots */ 
		PROC SGPLOT  DATA = thesis.cohort_psweighted_trimmed;
		   VBOX ps 
		   / category = Met_1px;
		   title 'Predicted prob of Met_1px = 1 by exposure actually received';
		RUN; 

			/* After weighting */ 

			/* Not trimmed */ 
			PROC SGPLOT  DATA = thesis.cohort_psweighted_trimmed;
		   		VBOX ps 
		   		/ category = Met_1px weight = sipew;
		  		title 'Predicted prob of Met_1px = 1 by exposure actually received (after weighting)';
			RUN; 

			/* Trimmed */ 
			PROC SGPLOT  DATA = thesis.cohort_psweighted_trimmed;
		   		VBOX ps 
		   		/ category = Met_1px weight = sipew_t;
		  		title 'Predicted prob of Met_1px = 1 by exposure actually received (after weighting-trimmed)';
			RUN; 


		/* Histograms */

		/* With plotline */ 
		proc sgplot data = thesis.cohort_psweighted_trimmed;       
		  histogram ps / group=Met_1px transparency=0.5;     
		  density ps / type=kernel group=Met_1px; 
		  xaxis min = 0 max = 1; 
		  title 'Distribution of predicted probability of Met_1px = 1 by exposure actually received';
		run;

			/* After weighting */ 

			/* Not trimmed */ 
			proc sgplot data = thesis.cohort_psweighted_trimmed;       
			  histogram ps / group=Met_1px transparency=0.5 weight = sipew ;     
			  density ps / type=kernel group=Met_1px weight = sipew; 
			  xaxis min = 0 max = 1; 
			  title 'Distribution of predicted probability of Met_1px = 1 by exposure actually received (after weighting)';
			run;
			title;

			/* Trimmed */ 
			proc sgplot data = thesis.cohort_psweighted_trimmed;       
			  histogram ps / group=Met_1px transparency=0.5 weight = sipew_t;     
			  density ps / type=kernel group=Met_1px weight = sipew_t; 
			  xaxis min = 0 max = 1; 
			  title 'Distribution of predicted probability of Met_1px = 1 by exposure actually received (after weighting-trimmed)';
			run;
			title;

/* Distribution of pscore and weights - Separate plots */

		proc univariate data = thesis.cohort_psweighted_trimmed; 
		var ps; 
		class Met_1px; 
		histogram; 
		run; /*propensity score */

		proc univariate data = thesis.cohort_psweighted_trimmed; 
		var sipew; 
		class Met_1px;
		histogram; 
		run; /*stabilized weights*/

		proc univariate data = thesis.cohort_psweighted_trimmed; 
		var sipew_t; 
		class Met_1px;
		histogram; 
		run; /*stabilized weights- trimmed*/

		*With plotline;
		title; 
		ods graphics / width=500px height=500px;

		/* Stabilized weights- not trimmed */
		proc sgplot data = thesis.cohort_psweighted_trimmed;       
		  histogram sipew / group=Met_1px transparency=0.5;     
		  density sipew / type=kernel group=Met_1px; 
		  title 'Distribution of stabilized weights across exposure groups- untrimmed';
		run;
		title;

		proc sgplot data = thesis.cohort_psweighted_trimmed;          
		  density sipew / type=kernel group=Met_1px; 
		run;

		/* Stabilized weights- trimmed */
		proc sgplot data = thesis.cohort_psweighted_trimmed;       
		  histogram sipew_t / group=Met_1px transparency=0.5;     
		  density sipew_t / type=kernel group=Met_1px; 
		  title 'Distribution of stabilized weights across exposure groups- trimmed';
		run;
		title;

		proc sgplot data = thesis.cohort_psweighted_trimmed;          
		  density sipew_t / type=kernel group=Met_1px; 
		run;

/* Demographics- distribution after weighting */ 
/* Categorical variables */
proc freq data = thesis.cohort_psweighted_trimmed;
table Met_1px*(sex Race year_of_diagnosis urbanrural_binary stage chemo);
weight sipew_t;
run; 

/* Continuous variables */ 
proc means data = thesis.cohort_psweighted_trimmed; 
var age_at_ICI chemo_count days_dx_to_tx NCI_index;
class Met_1px;
weight sipew_t;
run; 


/* Standardized differences */ 
		*******NOTE: Hemal suggests creating n dummy variables for the categorical variables with n>2 categories;

	%include 'S:\Pharmacoepi0216\Thesis SEER Medicare concurrent MET and ICI\stdiff.macro.sas';

		/* Before weighting */ 
        %stdiff(dataset = thesis.cohort_psweighted_trimmed,
		        group = Met_1px,
                mean = age_at_ICI chemo_count days_dx_to_tx NCI_index,
                proportion = sex_binary Race_NHW Race_NHB Race_Hisp Race_Other 
                 yr_dx_2013 yr_dx_2014 yr_dx_2015 yr_dx_2016 yr_dx_2017 yr_dx_2018 yr_dx_2019
				 urbanrural_binary 
                 stage_loc stage_reg stage_unk stage_dis /* Remember 3 addtional indicators */
                 chemo);


		/* After weighting */
	    %stdiff(dataset = thesis.cohort_psweighted_trimmed,
		        group = Met_1px,
                mean = age_at_ICI chemo_count days_dx_to_tx NCI_index,
                proportion = sex_binary Race_NHW Race_NHB Race_Hisp Race_Other 
                 yr_dx_2013 yr_dx_2014 yr_dx_2015 yr_dx_2016 yr_dx_2017 yr_dx_2018 yr_dx_2019
				 urbanrural_binary 
                 stage_loc stage_reg stage_unk stage_dis
                 chemo,  /* Remember 3 additional indicators */
                 w  = sipew_t); /* Add weight */

 		/* Well balanced, all SMDs absolute value < 0.1 */


/* Descriptives of those 4 states without cause of death data */
Data thesis.cohort_tbS1_4excluded;
    set thesis.cohort_psweighted_trimmed;
     where cancer_death = '.';
run;
/* Continuous vars */
proc means data = thesis.cohort_tbS1_4excluded n mean std p25 p50 p75 min max; 
		class MET_1px; 
        var age_at_ICI chemo_count days_dx_to_tx NCI_index;
		run;
/* Categorical vars descriptive stats */
proc freq data = thesis.cohort_tbS1_4excluded;
tables Met_1px*(sex Race year_of_diagnosis urbanrural_binary stage chemo);
run;
/* Before weighting */ 
        %stdiff(dataset = thesis.cohort_tbS1_4excluded,
		        group = Met_1px,
                mean = age_at_ICI chemo_count days_dx_to_tx NCI_index,
                proportion = sex_binary Race_NHW Race_NHB Race_Hisp Race_Other 
                 yr_dx_2013 yr_dx_2014 yr_dx_2015 yr_dx_2016 yr_dx_2017 yr_dx_2018 yr_dx_2019
				 urbanrural_binary 
                 stage_loc stage_reg stage_unk stage_dis /* Remember 3 addtional indicators */
                 chemo);

*March 20 update: 978 subset;
*April 6 update: 544 subset overlap_flag1;
/************** Cancer-specific mortality: n=978 ************/
data thesis.cohort_psweights_fg; 
    set thesis.Rdat_cohort; 
    where cancer_death ne '.'; 
    /* Create binary dummy vars for each categorical variable */
    if sex = 1 then sex_binary = 1; else sex_binary = 0;

    if Race = 1 then Race_NHW = 1; else Race_NHW = 0; 
    if Race = 2 then Race_NHB = 1; else Race_NHB = 0;
    if Race = 5 then Race_Hisp = 1; else Race_Hisp = 0;
    if Race = 4 then Race_Other = 1; else Race_Other = 0;
    
	if year_of_diagnosis = '2013' then yr_dx_2013 = 1; else yr_dx_2013 = 0;
    if year_of_diagnosis = '2014' then yr_dx_2014 = 1; else yr_dx_2014 = 0;
    if year_of_diagnosis = '2015' then yr_dx_2015 = 1; else yr_dx_2015 = 0;
    if year_of_diagnosis = '2016' then yr_dx_2016 = 1; else yr_dx_2016 = 0;
    if year_of_diagnosis = '2017' then yr_dx_2017 = 1; else yr_dx_2017 = 0;
    if year_of_diagnosis = '2018' then yr_dx_2018 = 1; else yr_dx_2018 = 0;
    if year_of_diagnosis = '2019' then yr_dx_2019 = 1; else yr_dx_2019 = 0;
    
	if stage = 'Localized' then stage_loc = 1; else stage_loc = 0;
    if stage = 'Regional by direct extension only' then stage_reg = 1; else stage_reg = 0;
    if stage = 'Unknown' then stage_unk = 1; else stage_unk = 0;
	if stage = 'Distant' then stage_dis = 1; else stage_dis = 0;

run;

proc freq data = thesis.cohort_psweights_fg; 
tables MET_1px * (sex Race year_of_diagnosis urbanrural_binary stage chemo);
*tables Met_1px* (sex_binary Race_NHW Race_NHB Race_Hisp Race_Other
                 yr_dx_2013 yr_dx_2014 yr_dx_2015 yr_dx_2016 yr_dx_2017 yr_dx_2018 yr_dx_2019
                 stage_loc stage_reg stage_unk stage_dis);
run;

proc means data=thesis.cohort_psweights_fg;
     var age_at_ICI chemo_count days_dx_to_tx NCI_index;
    class Met_1px;
run;
proc contents data = thesis.cohort_psweights_fg; 
run; 
/*** IPEW ***/
*Estimate denominator for ipew - output a dataset called denom_ipew, prob is ps, denominator depends on Met_1px;
proc logistic data=thesis.cohort_psweights_fg desc;
class sex_binary Race_NHB Race_Hisp Race_Other
                 yr_dx_2014 yr_dx_2015 yr_dx_2016 yr_dx_2017 yr_dx_2018 yr_dx_2019
				 urbanrural_binary 
                 stage_reg stage_unk stage_dis
                 chemo;
model Met_1px =  sex_binary Race_NHB Race_Hisp Race_Other /* Same list of categorical variables from 'class' statement */ 
                 yr_dx_2014 yr_dx_2015 yr_dx_2016 yr_dx_2017 yr_dx_2018 yr_dx_2019
				 urbanrural_binary 
                 stage_reg stage_unk stage_dis
                 chemo
				 /* Continuous variables not included in 'class' statment; all are numeric */
				 age_at_ICI chemo_count days_dx_to_tx NCI_index
					 / link = glogit;
output out=denom_ipew p= ps;
run;
/*Transform denominator*/ 
proc freq data = denom_ipew;
tables _LEVEL_;
run; /* ps = P(Met_1px =1| covs) */

data denom_ipew; 
    set denom_ipew; 
    if Met_1px = 1 then d_e = ps;
    else if Met_1px = 0 then d_e = 1 - ps;
    keep patient_id ps d_e;  /* remove ps */
run;

proc means data = denom_ipew; 
var d_e; 
run; 

*Generate numerator for stabilized ipew - output a dataset called num_ipew, P(E=e), where e = observed exposure status;
proc logistic data=thesis.cohort_psweights_fg desc;
model Met_1px= /link = glogit;
output out=num_ipew p=ps;
run;

*Transform numerator;
data num_ipew; 
    set num_ipew; 
    if Met_1px = 1 then n_e = ps;
    else if Met_1px = 0 then n_e = 1 - ps;
    keep patient_id n_e;  
run;

*Generate stabilized and unstabilized weights by merging the datasets with regression output (merge on the unique identifier in your dataset, &id);
data thesis.cohort_psweights_fg;
merge thesis.cohort_psweights_fg denom_ipew num_ipew ;
by patient_id;
ipew = 1/d_e; 
sipew = n_e * ipew;
run;

	proc print data = thesis.cohort_psweights_fg (obs = 10); 
	run;

*Check the distribution of your IPTW - the mean should be 1. Sum for uw should be 2x the sum of sw. Range of uw should be greater than sw;

proc means data = thesis.cohort_psweights_fg mean sum min max p1 p99;
var sipew; 
run; 

proc means data = thesis.cohort_psweights_fg mean sum min max p1 p99;
var ipew sipew; 
class Met_1px;
run; 
		/* 
sipew:
Mean Sum Minimum Maximum 1st Pctl 99th Pctl 
0.9997360 977.7417717 0.2827021 2.8159515 0.4502985 2.0112094 

 well stablized

		*/

* Trim the lower and upper 1% of weights (creating new weight variable sw_t); 
data thesis.cohort_psweighted_fg_trimmed;
set thesis.cohort_psweights_fg; 
if sipew > 2.0112094 then sipew_t = 2.0112094; 
else if sipew < 0.4502985 then sipew_t = 0.4502985; 
else sipew_t = sipew; 
run;
*April 6 update;
data thesis.cohort_psweighted_fg_trimmed;
set thesis.cohort_psweights_fg; 
if sipew > 2.0705048 then sipew_t = 2.0705048; 
else if sipew < 0.4468673 then sipew_t = 0.4468673; 
else sipew_t = sipew; 
run;

proc means data= thesis.cohort_psweighted_fg_trimmed mean sum min max nothreads;
var sipew_t;
run;

proc means data= thesis.cohort_psweighted_fg_trimmed mean sum min max nothreads;
var sipew_t;
class Met_1px;
run;
*Check to see if exposure and covariates are associated in new pseudopopulation (thesis.cohort_psweighted_fg_trimmed));
proc logistic data=thesis.cohort_psweighted_fg_trimmed desc;
weight sipew;
class sex_binary Race_NHB Race_Hisp Race_Other
                 yr_dx_2014 yr_dx_2015 yr_dx_2016 yr_dx_2017 yr_dx_2018 yr_dx_2019
				 urbanrural_binary 
                 stage_reg stage_unk stage_dis
                 chemo;
model Met_1px =  sex_binary Race_NHB Race_Hisp Race_Other /* Same list of categorical variables from 'class' statement */ 
                 yr_dx_2014 yr_dx_2015 yr_dx_2016 yr_dx_2017 yr_dx_2018 yr_dx_2019
				 urbanrural_binary 
                 stage_reg stage_unk stage_dis
                 chemo
				 /* Continuous variables not included in 'class' statment; all are numeric */
				 age_at_ICI chemo_count days_dx_to_tx NCI_index
					 / link = glogit;			
run;

	*It doesn't appear that any of the odds ratio estimates for exposure(1 vs 0) are very high are very low for any of the covariates. 
		There are some that are low or high due to small sample size.; 


/* Balancing: Diagnostics */ 

* Areas of common support: For each exposure, display distribution of d (predicted prob) for the exposure arms; 

		/* Boxplots */ 
		PROC SGPLOT  DATA = thesis.cohort_psweighted_fg_trimmed;
		   VBOX ps 
		   / category = Met_1px;
		   title 'Predicted prob of Met_1px = 1 by exposure actually received';
		RUN; 

			/* After weighting */ 

			/* Not trimmed */ 
			PROC SGPLOT  DATA = thesis.cohort_psweighted_fg_trimmed;
		   		VBOX ps 
		   		/ category = Met_1px weight = sipew;
		  		title 'Predicted prob of Met_1px = 1 by exposure actually received (after weighting)';
			RUN; 

			/* Trimmed */ 
			PROC SGPLOT  DATA = thesis.cohort_psweighted_fg_trimmed;
		   		VBOX ps 
		   		/ category = Met_1px weight = sipew_t;
		  		title 'Predicted prob of Met_1px = 1 by exposure actually received (after weighting-trimmed)';
			RUN; 


		/* Histograms */

		/* With plotline */ 
		proc sgplot data = thesis.cohort_psweighted_fg_trimmed;    
		  histogram ps / group=Met_1px transparency=0.5;     
		  density ps / type=kernel group=Met_1px; 
		  xaxis min = 0 max = 1; 
		  title 'Distribution of predicted probability of Met_1px = 1 by exposure actually received';
		run;

			/* After weighting */ 

			/* Not trimmed */ 
			proc sgplot data = thesis.cohort_psweighted_fg_trimmed; 
			  histogram ps / group=Met_1px transparency=0.5 weight = sipew ;     
			  density ps / type=kernel group=Met_1px weight = sipew; 
			  xaxis min = 0 max = 1; 
			  title 'Distribution of predicted probability of Met_1px = 1 by exposure actually received (after weighting)';
			run;
			title;

			/* Trimmed */ 
			proc sgplot data = thesis.cohort_psweighted_fg_trimmed;     
			  histogram ps / group=Met_1px transparency=0.5 weight = sipew_t;     
			  density ps / type=kernel group=Met_1px weight = sipew_t; 
			  xaxis min = 0 max = 1; 
			  title 'Distribution of predicted probability of Met_1px = 1 by exposure actually received (after weighting-trimmed)';
			run;
			title;

/* Distribution of pscore and weights - Separate plots */

		proc univariate data = thesis.cohort_psweighted_fg_trimmed;
		var ps; 
		class Met_1px; 
		histogram; 
		run; /*propensity score */

		proc univariate data = thesis.cohort_psweighted_fg_trimmed;
		var sipew; 
		class Met_1px;
		histogram; 
		run; /*stabilized weights*/

		proc univariate data = thesis.cohort_psweighted_fg_trimmed;
		var sipew_t; 
		class Met_1px;
		histogram; 
		run; /*stabilized weights- trimmed*/

		*With plotline;
		title; 
		ods graphics / width=500px height=500px;

		/* Stabilized weights- not trimmed */
		proc sgplot data = thesis.cohort_psweighted_fg_trimmed;     
		  histogram sipew / group=Met_1px transparency=0.5;     
		  density sipew / type=kernel group=Met_1px; 
		  title 'Distribution of stabilized weights across exposure groups- untrimmed';
		run;
		title;

		proc sgplot data = thesis.cohort_psweighted_fg_trimmed;     
		  density sipew / type=kernel group=Met_1px; 
		run;

		/* Stabilized weights- trimmed */
		proc sgplot data = thesis.cohort_psweighted_fg_trimmed;      
		  histogram sipew_t / group=Met_1px transparency=0.5;     
		  density sipew_t / type=kernel group=Met_1px; 
		  title 'Distribution of stabilized weights across exposure groups- trimmed';
		run;
		title;

		proc sgplot data = thesis.cohort_psweighted_fg_trimmed;      
		  density sipew_t / type=kernel group=Met_1px; 
		run;

/* Demographics- distribution after weighting */ 
/* Categorical variables */
proc freq data = thesis.cohort_psweighted_fg_trimmed;
table Met_1px*(sex Race year_of_diagnosis urbanrural_binary stage chemo);
weight sipew_t;
run; 

/* Continuous variables */ 
proc means data = thesis.cohort_psweighted_fg_trimmed;
var age_at_ICI chemo_count days_dx_to_tx NCI_index;
class Met_1px;
weight sipew_t;
run; 


   /*Check balance for cancer-specific mortality subset*/
        /* Before weighting */ 
        %stdiff(dataset = thesis.cohort_psweighted_fg_trimmed,
		        group = Met_1px,
                mean = age_at_ICI chemo_count days_dx_to_tx NCI_index,
                proportion = sex_binary Race_NHW Race_NHB Race_Hisp Race_Other 
                 yr_dx_2013 yr_dx_2014 yr_dx_2015 yr_dx_2016 yr_dx_2017 yr_dx_2018 yr_dx_2019
				 urbanrural_binary 
                 stage_loc stage_reg stage_unk stage_dis /* Remember 3 addtional indicators */
                 chemo);
        /* After weighting */ 
        %stdiff(dataset = thesis.cohort_psweighted_fg_trimmed,
		        group = Met_1px,
                mean = age_at_ICI chemo_count days_dx_to_tx NCI_index,
                proportion = sex_binary Race_NHW Race_NHB Race_Hisp Race_Other 
                 yr_dx_2013 yr_dx_2014 yr_dx_2015 yr_dx_2016 yr_dx_2017 yr_dx_2018 yr_dx_2019
				 urbanrural_binary 
                 stage_loc stage_reg stage_unk stage_dis
                 chemo,  /* Remember 3 additional indicators */
                 w  = sipew_t); /* Add weight */
