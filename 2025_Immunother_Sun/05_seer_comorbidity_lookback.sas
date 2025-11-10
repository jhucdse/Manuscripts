*******************************************************************************;
* Program name      :	xx_seer_comorbidity_lookback
* Author            :	Jamie Heyward
* Date created      :	June 23 2022
* Study             : 	
* Purpose           :	Curate input file and run NCI comorbidity macro to measure baseline comorbidities and generate Charlson score for lung cancer/ICI patients
* Inputs            :	
* Program completed : 	
* Updated by        :   Xinyi Sun
*********************************************************************************;


LIBNAME seer 'S:\Pharmacoepi0216\Thesis';

/* NOTE: used NCI example program and updated it using my filenames. I am starting the look-back from ICI index date, not cancer dx date.
		This should be run after running the NCI.comorbidity.macro.sas file. 

		I updated the NCI comorbidity macro file referenced above to track and tag additional autoimmune disease comorbidities beyond those
		included in the original NCI version. Those additional comorbidities aren't used to calculate the Charlson or NCI Comorbidity scores. 
		The codes for those autoimmune diseases were pulled from: 
			Kehl et al. Pre-existing autoimmune disease and the risk of immune-related adverse events among patients receiving checkpoint 
			inhibitors for cancer. 2019.  https://pubmed.ncbi.nlm.nih.gov/30877325/

		Could index list against another source: macro can be updated if need be. 

		8/8/23: After conferring with committee, decided to assess lifetime autoimmune disease- not just last 12 months. 

		Also may decide to look at medication use to assess comorbidities. 
*/


/***********************************************************************************************************************/
/*  comorbidity.example.program.sas                                                                                    */
/*  Created: 9/21/2021                                                                                                 */
/***********************************************************************************************************************/
/*  This SAS program is an example of how to build an input file for the comorobidity macro with 2020 Linkage files.   */
/*  SAS date variables are created for the diagnosis date, start & end of the comorbidity window, and the claim from   */
/*  and thru dates. Diagnosis code and other variables are renamed so that they are the same across claims files.      */
/*  All unnecessary variables are dropped, for better efficiency, and the claims files are "set" together.             */
/*  Only the claims within the window (+/- 30 days) are selected out of all claims for the patients in SEER.           */
/*  Then, the comorbidity macro is called.                                                                             */
/***********************************************************************************************************************/

proc print data = seer.lung_primary_incident_65_tx_12 (obs = 5);
run; 
/*Modified date for t2dm dx, as early as study start date/enrollment in Medicare*/
data seer.lung_ici_comorbidities_t2dm;
 set seer.lung_primary_incident_65_tx_12(keep=patient_id ici_index_dt);
  ici_index_month = month(ici_index_dt);
  ici_index_year = year(ici_index_dt);
  Start_date = mdy(1,1,2012); /* Jan 1 2012 */ 
  Start_date_auto = mdy(1,1,2012); /* For autoimmunity: start date for lookback is earliest month of possible lookback - Jan 1 2012 (we are interested in "lifetime" autoimmunity) */
  End_date = mdy(ici_index_month,1,ici_index_year)-1; /* last day of the month before ICI index date */
  format ici_index_dt Start_date Start_date_auto End_date mmddyy10.;
  label 
    ici_index_dt = "Date of ICI initiation"
    Start_date = 'Jan 1 2012' /*as early as study start date/enrollment in Medicare*/
	Start_date_auto = 'Jan 1 2012, first date of autoimmunity lookback'
    End_date   = 'Last day before month of ICI index date'
    ;
run;
/* do this: 12/30 discussion with Hemal, decided to use 1 year comorbidity lookback */
data seer.lung_ici_comorbidities_t2dm;
 set seer.lung_primary_incident_65_tx_12(keep=patient_id ici_index_dt);
  ici_index_month = month(ici_index_dt);
  ici_index_year = year(ici_index_dt);
  Start_date = mdy(ici_index_month,1,ici_index_year-1); /* first day of the month a year before ICI index date */ 
  Start_date_auto = mdy(1,1,2012); /* For autoimmunity: start date for lookback is earliest month of possible lookback - Jan 1 2012 (we are interested in "lifetime" autoimmunity) */
  End_date = mdy(ici_index_month,1,ici_index_year)-1; /* last day of the month before ICI index date */
  format ici_index_dt Start_date Start_date_auto End_date mmddyy10.;
  label 
    ici_index_dt = "Date of ICI initiation"
    Start_date = 'One year before date of ICI index date'
	Start_date_auto = 'Jan 1 2012, first date of autoimmunity lookback'
    End_date   = 'Last day before month of ICI index date'
    ;
run;

/*proc freq data = seer.lung_ici_comorbidities nlevels; 
table patient_id / noprint; 
run; */
proc freq data = seer.lung_ici_comorbidities_t2dm nlevels; 
table patient_id / noprint; 
run; 



data seer.Claims;
  set 
    seer.medpar(in=M keep=PATIENT_ID ADMSN_DT DSCHRG_DT LOS_DAY_CNT ADMTG_DGNS_CD DGNS_1_CD--DGNS_25_CD
      /* rename MEDPAR variables to have the same names as OUTPAT and NCH */
      rename=(ADMSN_DT=CLM_FROM_DT DSCHRG_DT=CLM_THRU_DT ADMTG_DGNS_CD=PRNCPAL_DGNS_CD
              DGNS_1_CD=ICD_DGNS_CD1   DGNS_2_CD=ICD_DGNS_CD2   DGNS_3_CD=ICD_DGNS_CD3   DGNS_4_CD=ICD_DGNS_CD4 
              DGNS_5_CD=ICD_DGNS_CD5   DGNS_6_CD=ICD_DGNS_CD6   DGNS_7_CD=ICD_DGNS_CD7   DGNS_8_CD=ICD_DGNS_CD8 
              DGNS_9_CD=ICD_DGNS_CD9   DGNS_10_CD=ICD_DGNS_CD10 DGNS_11_CD=ICD_DGNS_CD11 DGNS_12_CD=ICD_DGNS_CD12
              DGNS_13_CD=ICD_DGNS_CD13 DGNS_14_CD=ICD_DGNS_CD14 DGNS_15_CD=ICD_DGNS_CD15 DGNS_16_CD=ICD_DGNS_CD16
              DGNS_17_CD=ICD_DGNS_CD17 DGNS_18_CD=ICD_DGNS_CD18 DGNS_19_CD=ICD_DGNS_CD19 DGNS_20_CD=ICD_DGNS_CD20
              DGNS_21_CD=ICD_DGNS_CD21 DGNS_22_CD=ICD_DGNS_CD22 DGNS_23_CD=ICD_DGNS_CD23 DGNS_24_CD=ICD_DGNS_CD24
              DGNS_25_CD=ICD_DGNS_CD25
             )
          )
    seer.outbase(in=O keep=PATIENT_ID CLM_FROM_DT CLM_THRU_DT PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25)
    seer.nchbase(in=N keep=PATIENT_ID CLM_FROM_DT CLM_THRU_DT PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD12) /* removed variable LINE_ICD_DGNS_CD because it is in NCH Line file, not NCH base */
    ;
  if M then Filetype = "M";
  else if O then Filetype = "O";
  else if N then Filetype = "N";
  
  /* create SAS dates from character dates */
  CLM_FROM_DATE = input(CLM_FROM_DT,yymmdd8.);
  CLM_THRU_DATE = input(CLM_THRU_DT,yymmdd8.);
  format CLM_FROM_DATE CLM_THRU_DATE mmddyy10.;
  drop CLM_FROM_DT CLM_THRU_DT;

  /* compute the claim thru date if it is missing */
  if M and missing(CLM_THRU_DATE) then CLM_THRU_DATE = CLM_FROM_DATE + LOS_DAY_CNT;
  else if (N or O) and missing(CLM_THRU_DATE) then CLM_THRU_DATE = CLM_FROM_DATE; 
run;
/* Claims reference table for Charlson/ NCI Index */ 

proc sql;
  create table seer.SelectedClaims as
  select C.*,S.ici_index_dt,S.Start_date,S.End_date
  from
    seer.Claims as C,
    seer.lung_ici_comorbidities_t2dm as S
  where (C.PATIENT_ID=S.PATIENT_ID) and ( (S.Start_date-30)<=C.CLM_FROM_DATE<=(S.End_date+30) )
  order by C.PATIENT_ID, C.CLM_FROM_DATE;
quit;
/* Claims reference table for Charlson/ NCI Index */ 
proc sql;
  create table seer.SelectedClaims as
  select C.*,S.ici_index_dt,S.Start_date,S.End_date
  from
    seer.Claims as C,
    seer.lung_ici_comorbidities as S
  where (C.PATIENT_ID=S.PATIENT_ID) and ( (S.Start_date-30)<=C.CLM_FROM_DATE<=(S.End_date+30) )
  order by C.PATIENT_ID, C.CLM_FROM_DATE;
quit;

/* Claims reference table for autoimmune conditions (different start date (Start_date_auto) */ 
proc sql;
  create table seer.SelectedClaims_Auto as
  select C.*,S.ici_index_dt,S.Start_date_auto,S.End_date
  from
    seer.Claims as C,
    seer.lung_ici_comorbidities_t2dm as S
  where (C.PATIENT_ID=S.PATIENT_ID) and ( (S.Start_date_auto-30)<=C.CLM_FROM_DATE<=(S.End_date+30) )
  order by C.PATIENT_ID, C.CLM_FROM_DATE;
quit;
proc print data = seer.SelectedClaims_Auto(obs=5);
run;

/*Modified NCI macro only use t2dm codes*/
%include 'S:\Pharmacoepi0216\Thesis SEER Medicare concurrent MET and ICI\NCI.comorbidity.macro.t2dm.sas';
%COMORB(seer.SelectedClaims,PATIENT_ID,Start_date,End_date,CLM_FROM_DATE,CLM_THRU_DATE,Filetype,
        PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25,R,Comorbidities); /* removed variable LINE_ICD_DGNS_CD from this list as it is not in NCH base file- it is in line file */

proc contents varnum;
proc means;
run;

/* Tried finding autoimmune commorbidities, need to modify auto macro, get all the icd codes use macro */
%include 'S:\Pharmacoepi0216\Thesis SEER Medicare concurrent MET and ICI\autoimmune.comorbidity.macro.sas';
%AUTOIMMUNE(seer.SelectedClaims_Auto,PATIENT_ID,Start_date_auto,End_date,CLM_FROM_DATE,CLM_THRU_DATE,Filetype,
        PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25,R,Comorbidities_autoimmune); /* removed variable LINE_ICD_DGNS_CD from this list as it is not in NCH base file- it is in line file */

proc contents varnum;
proc means;
run; 

/*
%include 'S:\JamieHeyward\Dissertation Aim 2 SEER Medicare Cohort Study\irAE.extra_risk_factors.macro.sas';
%RISKFACT(seer.SelectedClaims,PATIENT_ID,Start_date,End_date,CLM_FROM_DATE,CLM_THRU_DATE,Filetype,
        PRNCPAL_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25,R,irAE_ExtraRiskFactors); /* removed variable LINE_ICD_DGNS_CD from this list as it is not in NCH base file- it is in line file */
/*
proc contents varnum;
proc means;
run;
*/

/* New: add medication co-exposures from Part D */ 





	/* Add comorbidity data to the lung cancer ICI patient file */ 
			proc sort data = seer.lung_exp; /* File with lung cancer ICI patient data including exposure arm */ 
			by patient_id; 
			run; 

			proc sort data = Comorbidities; 
			by patient_id;
			run; /* 17349 patients */

		/*	proc sort data = Comorbidities_autoimmune; 
			by patient_id;
			run;

			proc sort data = irAE_ExtraRiskFactors; 
			by patient_id;
			run;
       */

			proc freq data = Comorbidities;
			tables diabetes;
			run; /* 4945 diabetes */

data seer.lung_ici_patient_comorb_t2dm; 
	merge seer.lung_exp (in = a)
			Comorbidities (drop = start_date end_date in=b); 
	by patient_id;
	if a;
	run; 

proc freq data = seer.lung_ici_patient_comorb_t2dm; 
			tables diabetes;
			run;
/*
    data seer.lung_ici_patient_comorb; 
	merge seer.lung_exp (in = a)
			Comorbidities (drop = start_date end_date in=b); 
	by patient_id;
	if a;
	run; 

	data seer.lung_ici_patient_comorb; 
	merge lung_ici_patient_comorb (in = a)
			Comorbidities_autoimmune (drop = start_date end_date in=b); 
	by patient_id;
	if a;
	run; 

	data seer.lung_ici_patient_comorb; 
	merge seer.lung_ici_patient_comorb (in = a)
			irAE_ExtraRiskFactors (drop = start_date end_date in=b); 
	by patient_id;
	if a;
	run; 
*/

proc print data = seer.lung_ici_patient_comorb_t2dm (obs = 5); 
		run; 
		proc print data = seer.lung_ici_patient_comorb (obs = 5); 
		run; 


/* Cohort stats- cancer patient demographics, tx characteristics, ICI use */ 

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
					'35'= "Medicaid – Administered through a Managed Care plan"
					'60'= "Medicare/Medicare, NOS"
					'61'= "Medicare with supplement, NOS"
					'62'= "Medicare – Administered through a Managed Care plan"
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
			value $SequenceNo '00' ="One primary only in the patient’s lifetime"
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
							'5'= "Radiation, NOS—method or source not specified"
							'6'= "Other radiation (1973-1987 cases only)"
							'7'= "Patient or patient's guardian refused radiation therapy"
							'8'= "Radiation recommended, unknown if administered"
					run; 

data seer.lung_ici_patient_comorb_t2dm; 
set seer.lung_ici_patient_comorb_t2dm; 
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

/* Demographics */ 

	proc contents data = seer.lung_ici_patient_comorb2_t2dm; 
	run; 

	Data seer.lung_ici_patient_comorb2_t2dm;
	Set seer.lung_ici_patient_comorb_t2dm;
	run;

	/* Add "first-line" status to dataset so that demog table can be stratified by line of therapy */ 
	data seer.lung_ici_patient_comorb2_t2dm; 
	set seer.lung_ici_patient_comorb2_t2dm; 
	if exposure_arm = 3 then chemocount1 = chemo_count-1; 
	else chemocount1 = chemo_count; 
	if chemocount1 lt 1 then firstline = 1; 
	else firstline = 0; 
	run; 

	/* Add dx to tx gap in days */ 
	data seer.lung_ici_patient_comorb2_t2dm; 
	set seer.lung_ici_patient_comorb2_t2dm;
	days_dx_to_tx = ici_index_dt - date_dx_format; 
	run; 

	proc freq data = seer.lung_ici_patient_comorb2_t2dm; 
	table firstline; 
	run; 

	/* Add treatment gap */ 


/* Categorical variables */
proc freq data = seer.lung_ici_patient_comorb2_t2dm;
where firstline = 1; 
table (seer_registry RACEANDORIGINRECODENHWNHBNHAIAN sex state rural_urban_continuum_code medianhouseholdincomeinflationa year_of_diagnosis primary_payer_at_dx marital_status_at_diagnosis)*exposure_arm;
run; 

proc freq data = seer.lung_ici_patient_comorb2_t2dm;
where firstline = 0; 
table (seer_registry RACEANDORIGINRECODENHWNHBNHAIAN sex state rural_urban_continuum_code medianhouseholdincomeinflationa year_of_diagnosis primary_payer_at_dx marital_status_at_diagnosis)*exposure_arm;
run; 

/* Continuous variables */ 
proc means data = seer.lung_ici_patient_comorb2_t2dm; 
where firstline = 1; 
var age_at_dx_numeric; 
class exposure_arm;
run; 

proc means data = seer.lung_ici_patient_comorb2_t2dm; 
where firstline = 0; 
var age_at_dx_numeric; 
class exposure_arm;
run;


proc means data = seer.lung_ici_patient_comorb2_t2dm; 
where firstline = 1; 
var days_dx_to_tx; 
class exposure_arm;
run; 

proc means data = seer.lung_ici_patient_comorb2_t2dm; 
where firstline = 0; 
var days_dx_to_tx; 
class exposure_arm;
run;



/* Diagnosis information */ 
proc freq data = seer.lung_ici_patient_comorb2_t2dm; 
where firstline = 1; 
table (combined_summary_stage_2004 sequence_number primary_site laterality behavior_recode_for_analysis totalnumberofinsitumalignanttum RX_Summ_Surg_Prim_Site_1998)*exposure_arm; 
run; 

proc freq data = seer.lung_ici_patient_comorb2_t2dm; 
where firstline = 0; 
table (combined_summary_stage_2004 sequence_number primary_site laterality behavior_recode_for_analysis totalnumberofinsitumalignanttum RX_Summ_Surg_Prim_Site_1998)*exposure_arm; 
run; 




/* Tx info (from SEER Cancer file) */ 

proc freq data = seer.lung_ici_patient_comorb2_t2dm;
table (radiation_recode rx_summ_surg_prim_site_1998)*exposure_arm; 
run; 



proc means data = seer.lung_ici_patient_comorb2_t2dm;
where firstline = 1; 
var NCI_index Charlson;
class exposure_arm;
run; 

proc means data = seer.lung_ici_patient_comorb2_t2dm;
where firstline = 0; 
var NCI_index Charlson;
class exposure_arm;
run; 
/*Diabetes*/
proc freq data = seer.lung_ici_patient_comorb2_t2dm;
table diabetes*exposure_arm;
run; 

/* Table of diabetes by exposure_arm
diabetes(Diabetes) ICI   ICI + ICI ICI + Chemo  4   Total 
0                  10403 18        1982         1   12404
1                  4210  5         730          0   4945  
missing = 8 
*/

/** Only 4945 ICI users with DM
how many of them are using Met??
/

/* Final eligible cohort setup */
Proc print data = seer.lung_ici_patient_comorb_t2dm(obs=5); 
run;

data seer.cohort;
    set seer.lung_ici_patient_comorb2_t2dm;
    where diabetes = 1 and exposure_arm ne 2;
run; /* 4940 eligible patients */
proc freq data = seer.cohort;
tables exposure_arm nsclc;
run;
