*******************************************************************************;
* Program name      :	06.5_seer_frailty_lookback
* Author            :	Sophia Ko
* Date created      :	March 18 2026
* Study             : 	
* Purpose           :	Curate input file and run Kim frailty macro to measure baseline comorbidities for skin cancer/ICI patients
* Inputs            :	
* Program completed : 	
* Updated by        :   
*********************************************************************************;


LIBNAME seer 'S:\Pharmacoepi0216\SK_ScM_Thesis25\melanoma project\melanomacohort\Data\processed';
LIBNAME raw  'S:\Pharmacoepi0216\Thesis Project\seer';

/* new libname must point to frailty folder — this is where disease_weight lives
   AND where we'll save the 4 input datasets */
LIBNAME new 'S:\Pharmacoepi0216\SK_ScM_Thesis25\melanoma project\melanomacohort\Scripts\frailty macro';

/* Update workdir to point to CSV lookup files in the same folder */
%let workdir = S:\Pharmacoepi0216\SK_ScM_Thesis25\melanoma project\melanomacohort\Scripts\frailty macro;

/***********************************************************************************************************************/
/* STEP 1: IDs — pull unique patient IDs from master cohort file                                                       */
/***********************************************************************************************************************/

data new.ids;
  set seer.skin_ici_patient_covar_plus_surg(keep=PATIENT_ID first_ici_date
      rename=(PATIENT_ID=patid first_ici_date=ici_index_dt));
  Start_date = ici_index_dt - 365;  /* 12-month lookback */
  End_date   = ici_index_dt - 1;
  format ici_index_dt Start_date End_date mmddyy10.;
run;

proc freq data=new.ids nlevels;
  table patid / noprint;
run;

/***********************************************************************************************************************/
/* STEP 2: Build long-format diagnosis code claims                                                                     */
/* Stack MEDPAR + outbase + nchbase, transpose wide dx codes to long, restrict to lookback window                      */
/* ICD-9 = before Oct 1 2015 | ICD-10 = Oct 1 2015 onward                                                            */
/***********************************************************************************************************************/

/* Stack all claims files — same rename logic as your comorbidity script */
data all_claims_wide;
  set
    raw.medpar(in=M keep=PATIENT_ID ADMSN_DT DGNS_1_CD--DGNS_25_CD
      rename=(ADMSN_DT=CLM_FROM_DT
              DGNS_1_CD=ICD_DGNS_CD1   DGNS_2_CD=ICD_DGNS_CD2   DGNS_3_CD=ICD_DGNS_CD3
              DGNS_4_CD=ICD_DGNS_CD4   DGNS_5_CD=ICD_DGNS_CD5   DGNS_6_CD=ICD_DGNS_CD6
              DGNS_7_CD=ICD_DGNS_CD7   DGNS_8_CD=ICD_DGNS_CD8   DGNS_9_CD=ICD_DGNS_CD9
              DGNS_10_CD=ICD_DGNS_CD10 DGNS_11_CD=ICD_DGNS_CD11 DGNS_12_CD=ICD_DGNS_CD12
              DGNS_13_CD=ICD_DGNS_CD13 DGNS_14_CD=ICD_DGNS_CD14 DGNS_15_CD=ICD_DGNS_CD15
              DGNS_16_CD=ICD_DGNS_CD16 DGNS_17_CD=ICD_DGNS_CD17 DGNS_18_CD=ICD_DGNS_CD18
              DGNS_19_CD=ICD_DGNS_CD19 DGNS_20_CD=ICD_DGNS_CD20 DGNS_21_CD=ICD_DGNS_CD21
              DGNS_22_CD=ICD_DGNS_CD22 DGNS_23_CD=ICD_DGNS_CD23 DGNS_24_CD=ICD_DGNS_CD24
              DGNS_25_CD=ICD_DGNS_CD25))
    raw.outbase(in=O keep=PATIENT_ID CLM_FROM_DT ICD_DGNS_CD1-ICD_DGNS_CD25)
    raw.nchbase(in=N keep=PATIENT_ID CLM_FROM_DT ICD_DGNS_CD1-ICD_DGNS_CD12)
    ;
  CLM_FROM_DATE = input(CLM_FROM_DT, yymmdd8.);
  format CLM_FROM_DATE mmddyy10.;
  drop CLM_FROM_DT;
run;

/* Restrict to cohort patients within 12-month lookback window */
proc sql;
  create table claims_window as
  select C.*, S.ici_index_dt, S.Start_date, S.End_date
  from all_claims_wide as C
  inner join new.ids as S on C.PATIENT_ID = S.patid
  where S.Start_date <= C.CLM_FROM_DATE <= S.End_date;
quit;

/* Transpose from wide to long — one row per dx code per patient */
data claims_long;
  set claims_window;
  array dx(*) ICD_DGNS_CD1-ICD_DGNS_CD25;
  do i = 1 to dim(dx);
    if dx(i) ne ' ' then do;
      dx_code = compress(dx(i), '.'); /* strip decimals */
      output;
    end;
  end;
  keep PATIENT_ID CLM_FROM_DATE dx_code;
  rename PATIENT_ID=patid;
run;

/* Split into ICD-9 (pre Oct 1 2015) and ICD-10 (Oct 1 2015 onward) */
/* Remove duplicates — macro only needs one record per patient-code   */

data new.dx09 new.dx10;
  set claims_long;
  if CLM_FROM_DATE < '01OCT2015'd then output new.dx09;
  else output new.dx10;
  keep patid dx_code;
  rename dx_code=dx;
run;

proc sort nodupkey data=new.dx09; by patid dx; run;
proc sort nodupkey data=new.dx10; by patid dx; run;

proc freq data=new.dx09; tables dx / noprint nlevels; run;
proc freq data=new.dx10; tables dx / noprint nlevels; run;

/***********************************************************************************************************************/
/* STEP 3: Build procedure code dataset (CPT + HCPCS combined)                                                         */
/* Source: nchline for CPT codes and all HCPCS codes (same file used in your ICI identification script)               */
/***********************************************************************************************************************/

/* Pull ALL CPT and HCPCS codes from NCH line — not just ICI codes */
/* This is broader than your ICI identification pull — frailty needs all procedure codes */
data px_nch;
  set raw.nchline(keep=PATIENT_ID CLM_FROM_DT HCPCS_CD
      rename=(CLM_FROM_DT=CLM_FROM_DT_char));
  CLM_FROM_DATE = input(CLM_FROM_DT_char, yymmdd8.);
  format CLM_FROM_DATE mmddyy10.;
  drop CLM_FROM_DT_char;
  where HCPCS_CD ne ' ';
run;

/* Pull HCPCS from DME file if available — confirm filename in your raw library */
/* If raw.dme does not exist, comment this block out                            */
data px_dme;
  set raw.dme(keep=PATIENT_ID CLM_FROM_DT HCPCS_CD
      rename=(CLM_FROM_DT=CLM_FROM_DT_char));
  CLM_FROM_DATE = input(CLM_FROM_DT_char, yymmdd8.);
  format CLM_FROM_DATE mmddyy10.;
  drop CLM_FROM_DT_char;
  where HCPCS_CD ne ' ';
run;

/* Combine CPT and HCPCS */
data all_px;
  set px_nch px_dme;
run;

/* Restrict to cohort patients within lookback window */
proc sql;
  create table px_window as
  select C.PATIENT_ID, C.HCPCS_CD
  from all_px as C
  inner join new.ids as S on C.PATIENT_ID = S.patid
  where S.Start_date <= C.CLM_FROM_DATE <= S.End_date;
quit;

data new.px;
  set px_window;
  rename PATIENT_ID=patid HCPCS_CD=px;
run;

proc sort nodupkey data=new.px; by patid px; run;

proc freq data=new.px nlevels; tables px / noprint; run;

/***********************************************************************************************************************/
/* STEP 4: Quick QC before running macro                                                                               */
/***********************************************************************************************************************/

proc sql;
  select 
    (select count(distinct patid) from new.ids)    as n_ids,
    (select count(distinct patid) from new.dx09)   as n_pts_dx09,
    (select count(distinct patid) from new.dx10)   as n_pts_dx10,
    (select count(distinct patid) from new.px)     as n_pts_px
  ;
quit;

/***********************************************************************************************************************/
/* STEP 5: Run the Kim frailty macro                                                                                   */
/***********************************************************************************************************************/

%include 'S:\Pharmacoepi0216\SK_ScM_Thesis25\melanoma project\melanomacohort\Scripts\frailty macro\Claims Based Frailty 22May2021.sas';

/* Output dataset is frailty_score — defined inside the macro */

/***********************************************************************************************************************/
/* STEP 6: QC frailty scores and export for R                                                                          */
/***********************************************************************************************************************/

proc means data=frailty_score n mean std min p25 median p75 max;
  var score;
run;

/* Distribution check — expect right-skewed, most patients low score */
proc univariate data=frailty_score;
  var score;
  histogram score;
run;

/* Check all cohort patients received a score */
proc sql;
  select count(*) as n_with_score,
         count(distinct patid) as n_unique_pts
  from frailty_score;
quit;

/* Export for R merge */
proc export
  data    = frailty_score
  outfile = 'S:\Pharmacoepi0216\SK_ScM_Thesis25\melanoma project\melanomacohort\Data\processed\frailty_score.csv'
  dbms    = csv
  replace;
run;
