*******************************************************************************;
* Program name      :	xx_seer_histology_derivation
* Author            :	Sophia Ko
* Date created      :	January 11 2026
* Study             : 	
* Purpose           :	Update covariates. Use ICD-O-3 in medicare files to create and clean histology covariate.
*						Use ICD and HCPCS codes in medicare files to create and clean surgery covariate
* Inputs            :	
* Program completed : 	
* Updated by        :    Sophia Ko
*********************************************************************************;

LIBNAME seer 'S:\Pharmacoepi0216\SK_ScM_Thesis25\melanoma project\melanomacohort\Data\processed';
LIBNAME raw 'S:\Pharmacoepi0216\Thesis Project\seer';
LIBNAME out 'S:\Pharmacoepi0216\SK_ScM_Thesis25\melanoma project\melanomacohort\Data\processed';

proc contents data=raw.seer_skin;
run;

/*****************************************************************************************
* Cutaneous melanoma histology subgrouping using available SEER ICD-O-3 variables
* Input dataset : skin_ici_patient_comorb_clean
* Output dataset: skin_ici_patient_covar
*
* Available SEER variables:
*   - SITE_RECODE_ICD_O_3_WHO_2008  (char 5) : SEER site recode (ICD-O-3/WHO 2008)
*   - HISTOLOGIC_TYPE_ICD_O_3       (char 4) : ICD-O-3 morphology (e.g., '8743')
*   - BEHAVIOR_CODE_ICD_O_3         (char 1) : behavior ('3' = malignant)
*
*
*****************************************************************************************/

options validvarname=any;

/* --- 0) Labels for melanoma morphology universe --- */
proc format;
  value histo_icdo3_lbl
    8720 = "Malignant melanoma, NOS"
    8721 = "Nodular melanoma"
    8722 = "Balloon cell melanoma"
    8723 = "Regressing melanoma"
    8730 = "Amelanotic melanoma"
    8740 = "Melanoma in junctional nevus"
    8741 = "Melanoma in premalignant melanosis"
    8742 = "Lentigo maligna melanoma"
    8743 = "Superficial spreading melanoma"
    8744 = "Acral lentiginous melanoma"
    8745 = "Desmoplastic melanoma"
    8770 = "Mixed epithelioid & spindle cell melanoma"
    8771 = "Epithelioid cell melanoma"
    8772 = "Spindle cell melanoma, NOS"
    8780 = "Malignant blue nevus"
  ;
run;

/* --- 1) Define my cutaneous melanoma morphology universe --- */
%let cm_histo_universe =
  8720 8721 8722 8723 8730
  8740 8741 8742 8743 8744 8745
  8770 8771 8772
  8780
;

/* --- 2) QC: identify which SITE_RECODE value is "Melanoma of the Skin" in my file --- */
title "QC: SITE_RECODE_ICD_O_3_WHO_2008 distribution (use this to identify Melanoma of the Skin code)";
proc freq data=seer.skin_ici_patient_comorb;
  tables SITE_RECODE_ICD_O_3_WHO_2008 / missing;
run;
title;
 
/* 25010 */

/* --- 3) */
%let cut_melanoma_site_recode = '25010';  

/* --- 4) Build final output with cutaneous melanoma restriction + Option A/B histology variables --- */

options nofmterr; /*reset formats*/

data skin_ici_patient_covar;
  set seer.skin_ici_patient_comorb;

  length cm_site cm_invasive cm_in_universe cm_keep 3;
  length histo_A histo_B $30;
  length histo3 8;

  /* Convert histology char->numeric (handles '8720', etc.) */
  histo3 = input(strip(HISTOLOGIC_TYPE_ICD_O_3), best12.);

  /* Site restriction using SEER site recode */
  cm_site = (strip(SITE_RECODE_ICD_O_3_WHO_2008) in (&cut_melanoma_site_recode));

  /* Invasive malignant only (/3) */
  cm_invasive = (strip(BEHAVIOR_CODE_ICD_O_3) = '3');

  /* Morphology universe restriction */
  cm_in_universe = (histo3 in (&cm_histo_universe));

  /* Final keep flag */
  cm_keep = (cm_site and cm_invasive and cm_in_universe);

  /* Apply format for readability */
  format histo3 histo_icdo3_lbl.;

  /* Option A and Option B only defined for included cohort */
  if cm_keep then do;

    /* Option A: major subtypes + Other */
    select (histo3);
      when (8743) histo_A = "Superficial spreading";
      when (8721) histo_A = "Nodular";
      when (8742) histo_A = "Lentigo maligna";
      when (8744) histo_A = "Acral lentiginous";
      when (8745) histo_A = "Desmoplastic";
      otherwise   histo_A = "Other / rare / NOS";
    end;

    /* Option B: biology-driven collapse */
    if histo3 in (8742, 8745) then histo_B = "Sun-exposed (LMM/DM)";
    else if histo3 = 8744 then histo_B = "Acral lentiginous";
    else histo_B = "Other cutaneous";

  end;
  else do;
    histo_A = "";
    histo_B = "";
  end;

run;

/* --- 5) QC checks among cm_keep=1 --- */
title "QC: Underlying melanoma histology (labeled) among cm_keep=1";
proc freq data=skin_ici_patient_covar;
  where cm_keep = 1;
  tables histo3 / missing;
run;

title "QC: Option A distribution among cm_keep=1";
proc freq data=skin_ici_patient_covar;
  where cm_keep = 1;
  tables histo_A / missing;
run;

title "QC: Option A by exposure among cm_keep=1";
proc freq data=skin_ici_patient_covar;
  where cm_keep = 1;
  tables exposure_arm*histo_A / missing norow nocol nopercent;
run;

title "QC: Option B distribution among cm_keep=1";
proc freq data=skin_ici_patient_covar;
  where cm_keep = 1;
  tables histo_B / missing;
run;

title "QC: Option B by exposure among cm_keep=1";
proc freq data=skin_ici_patient_covar;
  where cm_keep = 1;
  tables exposure_arm*histo_B / missing norow nocol nopercent;
run;

title;

proc print data=skin_ici_patient_covar (obs =10);
run;

data seer.skin_ici_patient_covar;
set skin_ici_patient_covar;
run;


proc print data=seer.skin_ici_patient_covar (obs=10);
run;

proc contents data=seer.skin_ici_patient_covar;
run;

/*****************************************************************************************
* Surgery subgrouping using CMS.gov files
* Input dataset : skin_ici_patient_covar
* Output dataset: skin_ici_patient_covar
*
* Available SEER variables:
*   - SITE_RECODE_ICD_O_3_WHO_2008  (char 5) : SEER site recode (ICD-O-3/WHO 2008)
*   - HISTOLOGIC_TYPE_ICD_O_3       (char 4) : ICD-O-3 morphology (e.g., '8743')
*   - BEHAVIOR_CODE_ICD_O_3         (char 1) : behavior ('3' = malignant)
*
*
*
*****************************************************************************************/
/*=============================================================================*/
/*  HARD-CODED SURGERY PROCEDURE CODE LISTS (NO biopsy)                         */
/*  Builds:                                                                      */
/*    out.cpt_surg_list       (CPT/HCPCS)                                        */
/*    out.icd9px_surg_list    (ICD-9 procedure)                                  */
/*    out.icd10px_surg_list   (ICD-10-PCS excision + detachment)                 */
/*=============================================================================*/

options nocenter nodate nonumber;

/*=============================================================================*/
/*  SECTION 1: CPT / HCPCS surgery codes                                       */
/*=============================================================================*/
data out.cpt_surg_list;
  length code_type $10 code $10 description $200;
  infile datalines truncover;
  input code $ description $200.;
  code_type = "CPT";
  code = upcase(compress(strip(code),'. '));
  if not missing(code);
datalines;
11600 Excision malignant lesion trunk arms legs <=0.5cm
11601 Excision malignant lesion trunk arms legs 0.6-1.0cm
11602 Excision malignant lesion trunk arms legs 1.1-2.0cm
11603 Excision malignant lesion trunk arms legs 2.1-3.0cm
11604 Excision malignant lesion trunk arms legs 3.1-4.0cm
11606 Excision malignant lesion trunk arms legs >4.0cm
11620 Excision malignant lesion scalp neck hands feet genitalia <=0.5cm
11621 Excision malignant lesion scalp neck hands feet genitalia 0.6-1.0cm
11622 Excision malignant lesion scalp neck hands feet genitalia 1.1-2.0cm
11623 Excision malignant lesion scalp neck hands feet genitalia 2.1-3.0cm
11624 Excision malignant lesion scalp neck hands feet genitalia 3.1-4.0cm
11626 Excision malignant lesion scalp neck hands feet genitalia >4.0cm
11640 Excision malignant lesion face ears eyelids nose lips <=0.5cm
11641 Excision malignant lesion face ears eyelids nose lips 0.6-1.0cm
11642 Excision malignant lesion face ears eyelids nose lips 1.1-2.0cm
11643 Excision malignant lesion face ears eyelids nose lips 2.1-3.0cm
11644 Excision malignant lesion face ears eyelids nose lips 3.1-4.0cm
11646 Excision malignant lesion face ears eyelids nose lips >4.0cm
11730 Avulsion of nail plate partial or complete single
11750 Excision of nail and nail matrix permanent removal
21011 Excision soft tissue tumor face scalp subcutaneous <2cm
21012 Excision soft tissue tumor face scalp subcutaneous >=2cm
21013 Excision soft tissue tumor face scalp subfascial <2cm
21014 Excision soft tissue tumor face scalp subfascial >=2cm
21015 Radical resection tumor soft tissue face scalp <2cm
21016 Radical resection tumor soft tissue face scalp >=2cm
27880 Amputation leg through tibia and fibula
28805 Amputation foot transmetatarsal
28810 Amputation metatarsal with toe single
28820 Amputation toe metatarsophalangeal joint
28825 Amputation toe interphalangeal joint
;
run;

proc sort data=out.cpt_surg_list nodupkey;
  by code;
run;

/* QC */
proc sql;
  title "QC1: CPT surgery list counts";
  select count(*) as n_rows, count(distinct code) as n_unique_codes
  from out.cpt_surg_list;
quit;

proc print data=out.cpt_surg_list(obs=15);
  title "QC1a: Sample CPT surgery codes";
run;

title;


/*=============================================================================*/
/*  SECTION 2: ICD-9 procedure surgery codes                                   */
/*=============================================================================*/
data out.icd9px_surg_list;
  length code_type $10 code $7 description $200;
  infile datalines truncover;
  input code $ description $200.;
  code_type = "ICD9PX";
  /* ICD-9 procedure sometimes appears with decimals; remove them for matching */
  code = compress(strip(code),'. ');
  if not missing(code);
datalines;
8.2 Removal of lesion of eyelid, NOS
8.23 Excision of major lesion of eyelid, partial-thickness
8.24 Excision of major lesion of eyelid, full-thickness
18.29 Excision or destruction of other lesion of external ear
21.3 Excision or destruction of lesion of nose, NOS
21.32 Local excision or destruction of other lesion of nose
27.42 Wide excision of lesion of lip
27.43 Other excision of lesion or tissue of lip
61.3 Excision or destruction of lesion or tissue of scrotum
64.2 Local excision or destruction of lesion of penis
71.3 Other local excision or destruction of vulva and perineum
83.39 Excision of lesion of other soft tissue
83.49 Other excision of soft tissue
84.11 Amputation of toe
84.12 Amputation through foot
84.15 Other amputation below knee
85.21 Local excision of lesion of breast
86.23 Removal of nail, nailbed, or nail fold
86.3 Other local excision or destruction of lesion or tissue of skin and subcutaneous tissue
86.4 Radical excision of skin lesion
;
run;

proc sort data=out.icd9px_surg_list nodupkey;
  by code;
run;

/* QC */
proc sql;
  title "QC2: ICD-9 PX surgery list counts";
  select count(*) as n_rows, count(distinct code) as n_unique_codes
  from out.icd9px_surg_list;
quit;

proc print data=out.icd9px_surg_list(obs=15);
  title "QC2a: Sample ICD-9 PX surgery codes";
run;

title;


/*=============================================================================*/
/*  SECTION 3: ICD-10-PCS surgery codes (Excision 0HB* + Detachment 0Y6/0X6)   */
/*=============================================================================*/
data out.icd10px_surg_list;
  length code_type $10 code $7 description $200;
  infile datalines truncover;
  input code $ description $200.;
  code_type = "ICD10PX";
  code = upcase(compress(strip(code),'. '));
  if not missing(code);
datalines;
/* --- ICD-10-PCS EXCISION (0HB) --- */
0HB0XZZ Excision of scalp skin, external approach
0HB1XZZ Excision of face skin, external approach
0HB2XZZ Excision of right ear skin, external approach
0HB3XZZ Excision of left ear skin, external approach
0HB4XZZ Excision of neck skin, external approach
0HB5XZZ Excision of chest skin, external approach
0HB6XZZ Excision of back skin, external approach
0HB7XZZ Excision of abdomen skin, external approach
0HB8XZZ Excision of buttock skin, external approach
0HB9XZZ Excision of perineum skin, external approach
0HBAXZZ Excision of genitalia skin, external approach
0HBBXZZ Excision of right upper arm skin, external approach
0HBCXZZ Excision of left upper arm skin, external approach
0HBDXZZ Excision of right lower arm skin, external approach
0HBEXZZ Excision of left lower arm skin, external approach
0HBFXZZ Excision of right hand skin, external approach
0HBGXZZ Excision of left hand skin, external approach
0HBHXZZ Excision of right upper leg skin, external approach
0HBJXZZ Excision of left upper leg skin, external approach
0HBKXZZ Excision of right lower leg skin, external approach
0HBLXZZ Excision of left lower leg skin, external approach
0HBMXZZ Excision of right foot skin, external approach
0HBNXZZ Excision of left foot skin, external approach
0HBQXZZ Excision of finger nail, external approach
0HBRXZZ Excision of toe nail, external approach

/* --- ICD-10-PCS DETACHMENT LOWER (0Y6) --- */
0Y6H0Z1 Detachment at right lower leg, high, open approach
0Y6H0Z2 Detachment at right lower leg, mid, open approach
0Y6H0Z3 Detachment at right lower leg, low, open approach
0Y6J0Z1 Detachment at left lower leg, high, open approach
0Y6J0Z2 Detachment at left lower leg, mid, open approach
0Y6J0Z3 Detachment at left lower leg, low, open approach
0Y6M0Z0 Detachment at right foot, complete, open approach
0Y6M0Z4 Detachment at right foot, complete 1st ray, open approach
0Y6M0Z5 Detachment at right foot, complete 2nd ray, open approach
0Y6M0Z6 Detachment at right foot, complete 3rd ray, open approach
0Y6M0Z7 Detachment at right foot, complete 4th ray, open approach
0Y6M0Z8 Detachment at right foot, complete 5th ray, open approach
0Y6N0Z0 Detachment at left foot, complete, open approach
0Y6N0Z4 Detachment at left foot, complete 1st ray, open approach
0Y6N0Z5 Detachment at left foot, complete 2nd ray, open approach
0Y6N0Z6 Detachment at left foot, complete 3rd ray, open approach
0Y6N0Z7 Detachment at left foot, complete 4th ray, open approach
0Y6N0Z8 Detachment at left foot, complete 5th ray, open approach
0Y6P0Z0 Detachment at right 1st toe, complete, open approach
0Y6P0Z1 Detachment at right 1st toe, high, open approach
0Y6P0Z2 Detachment at right 1st toe, low, open approach
0Y6Q0Z0 Detachment at left 1st toe, complete, open approach
0Y6Q0Z1 Detachment at left 1st toe, high, open approach
0Y6Q0Z2 Detachment at left 1st toe, low, open approach
0Y6R0Z0 Detachment at right 2nd toe, complete, open approach
0Y6R0Z1 Detachment at right 2nd toe, high, open approach
0Y6R0Z2 Detachment at right 2nd toe, mid, open approach
0Y6R0Z3 Detachment at right 2nd toe, low, open approach
0Y6S0Z0 Detachment at left 2nd toe, complete, open approach
0Y6S0Z1 Detachment at left 2nd toe, high, open approach
0Y6S0Z2 Detachment at left 2nd toe, mid, open approach
0Y6S0Z3 Detachment at left 2nd toe, low, open approach
0Y6T0Z0 Detachment at right 3rd toe, complete, open approach
0Y6T0Z1 Detachment at right 3rd toe, high, open approach
0Y6T0Z2 Detachment at right 3rd toe, mid, open approach
0Y6T0Z3 Detachment at right 3rd toe, low, open approach
0Y6U0Z0 Detachment at left 3rd toe, complete, open approach
0Y6U0Z1 Detachment at left 3rd toe, high, open approach
0Y6U0Z2 Detachment at left 3rd toe, mid, open approach
0Y6U0Z3 Detachment at left 3rd toe, low, open approach
0Y6V0Z0 Detachment at right 4th toe, complete, open approach
0Y6V0Z1 Detachment at right 4th toe, high, open approach
0Y6V0Z2 Detachment at right 4th toe, mid, open approach
0Y6V0Z3 Detachment at right 4th toe, low, open approach
0Y6W0Z0 Detachment at left 4th toe, complete, open approach
0Y6W0Z1 Detachment at left 4th toe, high, open approach
0Y6W0Z2 Detachment at left 4th toe, mid, open approach
0Y6W0Z3 Detachment at left 4th toe, low, open approach
0Y6X0Z0 Detachment at right 5th toe, complete, open approach
0Y6X0Z1 Detachment at right 5th toe, high, open approach
0Y6X0Z2 Detachment at right 5th toe, mid, open approach
0Y6X0Z3 Detachment at right 5th toe, low, open approach
0Y6Y0Z0 Detachment at left 5th toe, complete, open approach
0Y6Y0Z1 Detachment at left 5th toe, high, open approach
0Y6Y0Z2 Detachment at left 5th toe, mid, open approach
0Y6Y0Z3 Detachment at left 5th toe, low, open approach

/* --- ICD-10-PCS DETACHMENT UPPER (0X6) --- */
0X6J0Z0 Detachment at right hand, complete, open approach
0X6J0Z4 Detachment at right hand, complete 1st ray, open approach
0X6J0Z5 Detachment at right hand, complete 2nd ray, open approach
0X6J0Z6 Detachment at right hand, complete 3rd ray, open approach
0X6J0Z7 Detachment at right hand, complete 4th ray, open approach
0X6J0Z8 Detachment at right hand, complete 5th ray, open approach
0X6K0Z0 Detachment at left hand, complete, open approach
0X6K0Z4 Detachment at left hand, complete 1st ray, open approach
0X6K0Z5 Detachment at left hand, complete 2nd ray, open approach
0X6K0Z6 Detachment at left hand, complete 3rd ray, open approach
0X6K0Z7 Detachment at left hand, complete 4th ray, open approach
0X6K0Z8 Detachment at left hand, complete 5th ray, open approach
0X6L0Z0 Detachment at right thumb, complete, open approach
0X6L0Z1 Detachment at right thumb, high, open approach
0X6L0Z2 Detachment at right thumb, low, open approach
0X6M0Z0 Detachment at left thumb, complete, open approach
0X6M0Z1 Detachment at left thumb, high, open approach
0X6M0Z2 Detachment at left thumb, low, open approach
0X6N0Z0 Detachment at right index finger, complete, open approach
0X6N0Z1 Detachment at right index finger, high, open approach
0X6N0Z2 Detachment at right index finger, mid, open approach
0X6N0Z3 Detachment at right index finger, low, open approach
0X6P0Z0 Detachment at left index finger, complete, open approach
0X6P0Z1 Detachment at left index finger, high, open approach
0X6P0Z2 Detachment at left index finger, mid, open approach
0X6P0Z3 Detachment at left index finger, low, open approach
0X6Q0Z0 Detachment at right middle finger, complete, open approach
0X6Q0Z1 Detachment at right middle finger, high, open approach
0X6Q0Z2 Detachment at right middle finger, mid, open approach
0X6Q0Z3 Detachment at right middle finger, low, open approach
0X6R0Z0 Detachment at left middle finger, complete, open approach
0X6R0Z1 Detachment at left middle finger, high, open approach
0X6R0Z2 Detachment at left middle finger, mid, open approach
0X6R0Z3 Detachment at left middle finger, low, open approach
0X6S0Z0 Detachment at right ring finger, complete, open approach
0X6S0Z1 Detachment at right ring finger, high, open approach
0X6S0Z2 Detachment at right ring finger, mid, open approach
0X6S0Z3 Detachment at right ring finger, low, open approach
0X6T0Z0 Detachment at left ring finger, complete, open approach
0X6T0Z1 Detachment at left ring finger, high, open approach
0X6T0Z2 Detachment at left ring finger, mid, open approach
0X6T0Z3 Detachment at left ring finger, low, open approach
0X6V0Z0 Detachment at right little finger, complete, open approach
0X6V0Z1 Detachment at right little finger, high, open approach
0X6V0Z2 Detachment at right little finger, mid, open approach
0X6V0Z3 Detachment at right little finger, low, open approach
0X6W0Z0 Detachment at left little finger, complete, open approach
0X6W0Z1 Detachment at left little finger, high, open approach
0X6W0Z2 Detachment at left little finger, mid, open approach
0X6W0Z3 Detachment at left little finger, low, open approach
;
run;

proc sort data=out.icd10px_surg_list nodupkey;
  by code;
run;

/* QC */
proc sql;
  title "QC3: ICD-10-PCS surgery list counts";
  select count(*) as n_rows, count(distinct code) as n_unique_codes
  from out.icd10px_surg_list;
quit;

proc print data=out.icd10px_surg_list(obs=20);
  title "QC3a: Sample ICD-10-PCS surgery codes";
run;

title;


/*=============================================================================*/
/*  SECTION 4: Final summary + duplicates check                                */
/*=============================================================================*/
proc sql;
  title "QC4: Final library counts (unique codes)";
  select "CPT_SURG" as library, count(distinct code) as n from out.cpt_surg_list
  union all
  select "ICD9PX_SURG", count(distinct code) from out.icd9px_surg_list
  union all
  select "ICD10PX_SURG", count(distinct code) from out.icd10px_surg_list;
quit;

title "QC4b: Duplicates check (should be 0 in all)";
proc sql;
  select "CPT" as library, (count(*)-count(distinct code)) as n_dups from out.cpt_surg_list
  union all
  select "ICD9PX", (count(*)-count(distinct code)) from out.icd9px_surg_list
  union all
  select "ICD10PX", (count(*)-count(distinct code)) from out.icd10px_surg_list;
quit;
title;
/*=============================================================================*/
/*  SECTION B: Prepare cohort dates                                           */
/*=============================================================================*/

proc sort data=seer.skin_ici_patient_covar
          out=work.cohort_dates
          nodupkey;
    by patient_id;
run;

/* QC: DX + ICI date completeness */
proc sql;
    title "QC B0: Cohort missing DX_DATE / ici_index_dt";
    select count(*) as n_ids,
           sum(missing(DX_DATE)) as missing_dx_date,
           sum(missing(ici_index_dt)) as missing_ici_index_dt
    from work.cohort_dates;
quit;
title;
/*=============================================================================*/
/*  SECTION C: OUTREV – CPT surgery matches                                   */
/*=============================================================================*/
/*=============================================================================*/
/* FIX: point to correct datasets + avoid missing FORMAT errors                */
/*=============================================================================*/

options nofmterr;   /* prevents failure when formats are missing */

/* Use your actual datasets */
%let cohort_ds     = seer.skin_ici_patient_covar;
%let outrev_skin_ds= seer.outrev_skin;     /* <== IMPORTANT: use library.dataset */

/* Build a minimal cohort file (only vars we need) to avoid format lookups */
data work.cohort_dates;
  set &cohort_ds(keep=patient_id DX_DATE ici_index_dt exposure_arm index_regimen STAGE_GROUP STAGE_LABEL);
run;

proc sort data=work.cohort_dates nodupkey;
  by patient_id;
run;

/* QC: DX + ICI completeness */
proc sql;
  title "QC: cohort missing DX_DATE / ici_index_dt";
  select count(*) as n_ids,
         sum(missing(DX_DATE)) as missing_dx_date,
         sum(missing(ici_index_dt)) as missing_ici_index_dt
  from work.cohort_dates;
quit;
title;

/* Sort the OUTREV skin file (minimal keep as well) */
data work.outrev0;
  set &outrev_skin_ds(keep=patient_id HCPCS_CD CLM_THRU_DT);
run;

proc sort data=work.outrev0 out=work.outrev_sorted;
  by patient_id;
run;
/*=============================================================================*/
/*  SECTION C (FIXED): OUTREV CPT surgery matches (correct code standardizing) */
/*=============================================================================*/

options nofmterr;

%let cohort_ds      = seer.skin_ici_patient_covar;
%let outrev_skin_ds = seer.outrev_skin;

/*------------------------------------------------------------*/
/* C0: Minimal cohort file (avoid format loading issues)       */
/*------------------------------------------------------------*/
data work.cohort_dates;
  set &cohort_ds(keep=patient_id DX_DATE ici_index_dt
                      exposure_arm index_regimen STAGE_GROUP STAGE_LABEL);
run;

proc sort data=work.cohort_dates nodupkey;
  by patient_id;
run;

/*------------------------------------------------------------*/
/* C1: Minimal OUTREV file                                    */
/*------------------------------------------------------------*/
data work.outrev0;
  set &outrev_skin_ds(keep=patient_id HCPCS_CD CLM_THRU_DT);
run;

proc sort data=work.outrev0 out=work.outrev_sorted;
  by patient_id;
run;

/*------------------------------------------------------------*/
/* C2: Merge + date window + CLEAN HCPCS properly             */
/*     Key fix: keep the full HCPCS code (strip blanks/dots)  */
/*------------------------------------------------------------*/
data work.outrev_merge;
  merge work.outrev_sorted(in=a)
        work.cohort_dates(in=b);
  by patient_id;
  if a and b;

  /* date */
  proc_dt = input(strip(CLM_THRU_DT), yymmdd8.);
  format proc_dt date9.;
  date_ok   = (not missing(proc_dt));
  in_window = (date_ok and proc_dt >= DX_DATE and proc_dt <= ici_index_dt);

  /* full code cleaning */
  length code $10;
  code = upcase(strip(HCPCS_CD));
  code = compress(code, ". ");          /* remove dots/spaces only */
  /* optional: remove hyphens if any */
  code = compress(code, "-");

  code_ok = (not missing(code));
run;

/* QC C2a: confirm codes are not collapsing to 1-char */
proc sql;
  title "QC C2a: OUTREV rows in-window with code";
  select count(*) as n_rows,
         sum(in_window) as n_in_window,
         sum(in_window and code_ok) as n_in_window_with_code,
         sum(in_window and code_ok and length(code)=1) as n_len1_codes
  from work.outrev_merge;
quit;
title;

/* QC C2b: show top 30 codes in-window (should look like J1234 etc) */
proc freq data=work.outrev_merge order=freq;
  where in_window=1 and code_ok=1;
  tables code / nocum;
  title "QC C2b: Top OUTREV HCPCS_CD values after cleaning (in-window)";
run;
title;

/*------------------------------------------------------------*/
/* C3: Standardize CPT library similarly                       */
/*------------------------------------------------------------*/
data work.cpt_std;
  set out.cpt_surg_list(keep=code);
  length cpt $10;
  cpt = upcase(strip(code));
  cpt = compress(cpt, ". ");
  cpt = compress(cpt, "-");
run;

proc sort data=work.cpt_std nodupkey;
  by cpt;
run;

/* QC C3: CPT library size */
proc sql;
  title "QC C3: CPT surgery code count (unique)";
  select count(*) as n_cpt_codes
  from work.cpt_std;
quit;
title;

/*------------------------------------------------------------*/
/* C4: Match OUTREV ? CPT library                              */
/*------------------------------------------------------------*/
proc sql;
  create table out.surg_match_outrev as
  select a.patient_id,
         "OUTREV" as source length=6,
         a.code as code length=10,
         a.proc_dt,
         a.exposure_arm,
         a.index_regimen,
         a.STAGE_GROUP,
         a.STAGE_LABEL,
         a.DX_DATE,
         a.ici_index_dt
  from work.outrev_merge as a
  inner join work.cpt_std as b
    on a.code = b.cpt
  where a.in_window=1 and a.code_ok=1;
quit;

/* QC C4: match size + codes */
proc sql;
  title "QC C4: FINAL OUTREV surgery matches";
  select count(*) as matched_rows,
         count(distinct patient_id) as matched_patients
  from out.surg_match_outrev;
quit;
title;

proc freq data=out.surg_match_outrev order=freq;
  tables code / nocum;
  title "QC C4a: Matched OUTREV CPT codes (should show real CPTs like 11600 etc)";
run;
title;
/*=============================================================================*/
/*  SECTION D (FIXED): MEDPAR ICD-9/10 procedure surgery matches                */
/*=============================================================================*/

options nofmterr;

/*--------------*/
/* D0: Minimal MEDPAR */
/*--------------*/
data work.medpar0;
  set raw.medpar(
    keep=patient_id
         SRGCL_PRCDR_:          /* pulls all SRGCL_PRCDR* variables */
  );
run;

proc sort data=work.medpar0 out=work.medpar_sorted;
  by patient_id;
run;

/*--------------*/
/* D1: Build ICD9/ICD10 procedure lookup tables (cleaned) */
/*--------------*/
data work.icd9px_std;
  set out.icd9px_surg_list(keep=code);
  length px $7;
  px = compress(upcase(strip(code)), '. -');
run;
proc sort data=work.icd9px_std nodupkey; by px; run;

data work.icd10px_std;
  set out.icd10px_surg_list(keep=code);
  length px $7;
  px = compress(upcase(strip(code)), '. -');
run;
proc sort data=work.icd10px_std nodupkey; by px; run;

/* QC D1: library sizes (SAS-safe) */
proc sql;
  title "QC D1: ICD procedure library sizes";
  select "ICD9PX" as lib, count(*) as n from work.icd9px_std
  union all
  select "ICD10PX", count(*) from work.icd10px_std;
quit;
title;

/*--------------*/
/* D1b: Auto-detect MEDPAR procedure code vars + procedure date vars */
/*--------------*/
proc sql noprint;
  /* code vars like SRGCL_PRCDR_1_CD */
  select name into :medpar_px_vars separated by ' '
  from dictionary.columns
  where libname='WORK'
    and memname='MEDPAR_SORTED'
    and upcase(name) like 'SRGCL_PRCDR_%_CD'
  order by name;

  /* date vars like SRGCL_PRCDR_PRFRM_1_DT */
  select name into :medpar_dt_vars separated by ' '
  from dictionary.columns
  where libname='WORK'
    and memname='MEDPAR_SORTED'
    and upcase(name) like 'SRGCL_PRCDR_PRFRM_%_DT'
  order by name;
quit;

%put NOTE: MEDPAR px vars = &medpar_px_vars;
%put NOTE: MEDPAR dt vars = &medpar_dt_vars;

/* QC D1c: counts of detected vars */
proc sql;
  title "QC D1c: MEDPAR detected procedure variable counts";
  select count(*) as n_px_vars
  from dictionary.columns
  where libname='WORK' and memname='MEDPAR_SORTED' and upcase(name) like 'SRGCL_PRCDR_%_CD';

  select count(*) as n_dt_vars
  from dictionary.columns
  where libname='WORK' and memname='MEDPAR_SORTED' and upcase(name) like 'SRGCL_PRCDR_PRFRM_%_DT';
quit;
title;

/*--------------*/
/* D2: Create candidate long file (one row per procedure slot) */
/*--------------*/
data work.medpar_px_long;
  merge work.medpar_sorted(in=a)
        work.cohort_dates(in=b);
  by patient_id;
  if a and b;

  length code $10;
  format proc_dt date9.;

  array pcd {*} $ &medpar_px_vars;
  array pdt {*} $ &medpar_dt_vars;

  /* safety: only iterate over min(#code,#date) */
  n = dim(pcd);
  if dim(pdt) < n then n = dim(pdt);

  do i=1 to n;
    code = compress(upcase(strip(pcd[i])), '. -');
    if missing(code) then continue;

    proc_dt = input(strip(pdt[i]), yymmdd8.);
    if missing(proc_dt) then continue;

    if proc_dt < DX_DATE then continue;
    if proc_dt > ici_index_dt then continue;

    output;
  end;

  keep patient_id code proc_dt DX_DATE ici_index_dt
       exposure_arm index_regimen STAGE_GROUP STAGE_LABEL;
run;

/* QC D2: candidate rows */
proc sql;
  title "QC D2: MEDPAR candidate procedure rows in window";
  select count(*) as candidate_rows,
         count(distinct patient_id) as candidate_patients
  from work.medpar_px_long;
quit;
title;

/*--------------*/
/* D3: Label ICD9 vs ICD10 by lookup and keep only matched */
/*--------------*/
proc sql;
  create table out.surg_match_medpar as
  select a.patient_id,
         "MEDPAR" as source length=6,
         a.code length=10,
         a.proc_dt,
         a.exposure_arm,
         a.index_regimen,
         a.STAGE_GROUP,
         a.STAGE_LABEL,
         a.DX_DATE,
         a.ici_index_dt,
         case when b.px is not null then "ICD9PX"
              when c.px is not null then "ICD10PX"
              else "" end as code_type length=6
  from work.medpar_px_long as a
  left join work.icd9px_std  as b on a.code=b.px
  left join work.icd10px_std as c on a.code=c.px
  where (b.px is not null or c.px is not null);
quit;

/* QC D3: matches */
proc sql;
  title "QC D3: MEDPAR surgery matches";
  select count(*) as matched_rows,
         count(distinct patient_id) as matched_patients
  from out.surg_match_medpar;
quit;
title;

proc freq data=out.surg_match_medpar;
  tables code_type / missing;
  title "QC D3a: MEDPAR matches by ICD version";
run;
title;
/*=============================================================================*/
/*  SECTION E (REBUILT): NCH (Carrier) CPT/HCPCS surgery matching               */
/*  Uses SEER.NCHLINE_SKIN to avoid sorting massive RAW NCH                     */
/*=============================================================================*/

options nofmterr;

%let idvar = patient_id;
%let nch_ds = seer.nchline_skin;

/*---- E0: Confirm dataset exists --------------------------------------------*/
%macro assert_exists(ds);
  %if not %sysfunc(exist(&ds)) %then %do;
    %put ERROR: Dataset &ds does not exist.;
    %abort cancel;
  %end;
%mend;
%assert_exists(&nch_ds);

/*---- E0b: Resolve NCH code/date vars (auto-detect with sane defaults) -------*/
%let nch_code_var = HCPCS_CD;
%let nch_date_var = CLM_THRU_DT;

%macro resolve_nch_vars(ds=);
  %local mem has_code has_date;

  %let mem = %upcase(%scan(&ds,2,.));

  proc sql noprint;
    /* If defaults exist, keep */
    select count(*) into :has_code
    from dictionary.columns
    where libname=%upcase("%scan(&ds,1,.)") and memname="&mem"
      and upcase(name)=upcase("&nch_code_var");

    select count(*) into :has_date
    from dictionary.columns
    where libname=%upcase("%scan(&ds,1,.)") and memname="&mem"
      and upcase(name)=upcase("&nch_date_var");
  quit;

  /* code var */
  %if &has_code=0 %then %do;
    proc sql noprint;
      select name into :nch_code_var trimmed
      from dictionary.columns
      where libname=%upcase("%scan(&ds,1,.)") and memname="&mem"
        and (
             upcase(name)='HCPCS_CD'
          or upcase(name)='LINE_HCPCS_CD'
          or upcase(name) like '%HCPCS%'
          or upcase(name) like '%CPT%'
        )
      order by (upcase(name)='HCPCS_CD') desc,
               (upcase(name)='LINE_HCPCS_CD') desc,
               name;
    quit;
  %end;

  /* date var */
  %if &has_date=0 %then %do;
    proc sql noprint;
      select name into :nch_date_var trimmed
      from dictionary.columns
      where libname=%upcase("%scan(&ds,1,.)") and memname="&mem"
        and (
             upcase(name)='LINE_SRVC_DT'
          or upcase(name)='SRVC_DT'
          or upcase(name)='CLM_THRU_DT'
          or upcase(name)='CLM_FROM_DT'
          or upcase(name) like '%SRVC%DT%'
          or upcase(name) like '%LINE%DT%'
          or upcase(name) like '%THRU%DT%'
          or upcase(name) like '%FROM%DT%'
        )
      order by (upcase(name)='LINE_SRVC_DT') desc,
               (upcase(name)='SRVC_DT') desc,
               (upcase(name)='CLM_THRU_DT') desc,
               name;
    quit;
  %end;

  /* Final validation */
  proc sql noprint;
    select count(*) into :has_code
    from dictionary.columns
    where libname=%upcase("%scan(&ds,1,.)") and memname="&mem"
      and upcase(name)=upcase("&nch_code_var");

    select count(*) into :has_date
    from dictionary.columns
    where libname=%upcase("%scan(&ds,1,.)") and memname="&mem"
      and upcase(name)=upcase("&nch_date_var");
  quit;

  %if &has_code=0 or &has_date=0 %then %do;
    %put ERROR: Could not resolve required vars in &ds..;
    %put ERROR: code=&nch_code_var (exists=&has_code) date=&nch_date_var (exists=&has_date);
    %abort cancel;
  %end;

  %put NOTE: Using NCH vars: code=&nch_code_var date=&nch_date_var;
%mend;

%resolve_nch_vars(ds=&nch_ds);

/* QC E0 */
proc sql;
  title "QC E0: NCH dataset + chosen variables";
  select "&nch_ds" as nch_ds length=40,
         "&nch_code_var" as code_var length=32,
         "&nch_date_var" as date_var length=32;
quit;
title;

/*---- E1: Build NCH merge WITHOUT sorting the big NCH file -------------------*/
/* Uses cohort hash to keep only the 2177 patients */
data work.nch_merge;
  length code $10;
  format proc_dt date9.;
  if 0 then set work.cohort_dates; /* compile vars */

  if _n_=1 then do;
    /* cohort hash */
    declare hash hcoh(dataset:"work.cohort_dates(keep=&idvar DX_DATE ici_index_dt exposure_arm index_regimen STAGE_GROUP STAGE_LABEL)");
    hcoh.defineKey("&idvar");
    hcoh.defineData("DX_DATE","ici_index_dt","exposure_arm","index_regimen","STAGE_GROUP","STAGE_LABEL");
    hcoh.defineDone();
  end;

  set &nch_ds(keep=&idvar &nch_code_var &nch_date_var);

  /* keep only cohort patients */
  if hcoh.find() ne 0 then delete;

  /* code standardization */
  code = compress(upcase(strip(&nch_code_var)), ". -");
  code_ok = not missing(code);

  /* date conversion: char yyyymmdd OR numeric SAS date */
  proc_dt = .;
  if vtype(&nch_date_var)='C' then do;
    if prxmatch('/^\d{8}$/', strip(&nch_date_var)) then proc_dt = input(strip(&nch_date_var), yymmdd8.);
  end;
  else do;
    proc_dt = &nch_date_var;
  end;
  date_ok = not missing(proc_dt);

  in_window = (date_ok and proc_dt >= DX_DATE and proc_dt <= ici_index_dt);

  keep &idvar code proc_dt date_ok code_ok in_window
       DX_DATE ici_index_dt exposure_arm index_regimen STAGE_GROUP STAGE_LABEL;
run;

/* QC E1 */
proc sql;
  title "QC E1: NCH in-window + code nonmissing";
  select count(*) as n_rows,
         sum(in_window) as n_in_window,
         sum(in_window and code_ok) as n_in_window_with_code
  from work.nch_merge;
quit;
title;

/*---- E2: Match to CPT surgery library (work.cpt_std) ------------------------*/
/* Expect work.cpt_std has variable CPT (standardized) */
proc sql;
  create table out.surg_match_nch as
  select a.&idvar,
         "NCH" as source length=6,
         a.code length=10,
         a.proc_dt,
         a.exposure_arm,
         a.index_regimen,
         a.STAGE_GROUP,
         a.STAGE_LABEL,
         a.DX_DATE,
         a.ici_index_dt
  from work.nch_merge as a
  inner join work.cpt_std as b
    on a.code = b.cpt
  where a.in_window=1 and a.code_ok=1;
quit;

/* QC E2 */
proc sql;
  title "QC E2: NCH surgery matches";
  select count(*) as matched_rows,
         count(distinct &idvar) as matched_patients
  from out.surg_match_nch;
quit;
title;

proc freq data=out.surg_match_nch order=freq;
  tables code / nocum;
  title "QC E2a: Matched NCH CPT/HCPCS codes";
run;
title;

/*=============================================================================*/
/*  SECTION F: Stack all surgery matches into one long master file             */
/*  Requires:                                                                  */
/*    out.surg_match_outrev                                                    */
/*    out.surg_match_nch                                                       */
/*    out.surg_match_medpar                                                    */
/*=============================================================================*/

options nofmterr;

%let cohort_ds = seer.skin_ici_patient_covar;
%let idvar = patient_id;

/*---- F0: Confirm required match datasets exist -----------------------------*/
%macro assert_exists(ds);
  %if not %sysfunc(exist(&ds)) %then %do;
    %put ERROR: Dataset &ds does not exist.;
    %abort cancel;
  %end;
%mend;

%assert_exists(out.surg_match_outrev);
%assert_exists(out.surg_match_nch);
%assert_exists(out.surg_match_medpar);

/*---- F1: Stack (standardize variable list across sources) ------------------*/
data out.surg_long_all;
  length source $6 code $10;
  format proc_dt date9.;

  set out.surg_match_outrev(in=a)
      out.surg_match_nch(in=b)
      out.surg_match_medpar(in=c);

  /* ensure common names exist */
  /* source/code/proc_dt should already exist from each section */

  /* QC safety: drop nonsense */
  if missing(&idvar) then delete;
  if missing(proc_dt) then delete;
run;

/* QC F1: stacked counts */
proc sql;
  title "QC F1: Stacked surgery match counts by source";
  select source,
         count(*) as n_rows,
         count(distinct &idvar) as n_patients
  from out.surg_long_all
  group by source;
quit;
title;

/* QC F2: overall */
proc sql;
  title "QC F2: Overall stacked surgery matches";
  select count(*) as n_rows,
         count(distinct &idvar) as n_patients
  from out.surg_long_all;
quit;
title;


/*=============================================================================*/
/*  SECTION G: Collapse to patient level pre-ICI surgery indicator             */
/*  Rule: any qualifying procedure BETWEEN DX_DATE and ici_index_dt inclusive  */
/*=============================================================================*/

/* G0: Get cohort dates (avoid format errors) */
data work.cohort_dates;
  set &cohort_ds(keep=&idvar DX_DATE ici_index_dt exposure_arm index_regimen STAGE_GROUP STAGE_LABEL);
run;

proc sort data=work.cohort_dates nodupkey;
  by &idvar;
run;

/* G1: Re-apply window using cohort dates (belt-and-suspenders QC) */
proc sort data=out.surg_long_all out=work.surg_sorted;
  by &idvar proc_dt;
run;

data work.surg_inwindow;
  merge work.surg_sorted(in=a)
        work.cohort_dates(in=b);
  by &idvar;
  if a and b;

  in_window = (not missing(proc_dt) and proc_dt >= DX_DATE and proc_dt <= ici_index_dt);
  if in_window=1 then output;
run;

/* QC G1 */
proc sql;
  title "QC G1: Surgery matches after enforcing DX->ICI window again";
  select count(*) as n_rows,
         count(distinct &idvar) as n_patients
  from work.surg_inwindow;
quit;
title;

/* G2: Patient-level summary: indicator + earliest surgery date + source */
proc sort data=work.surg_inwindow;
  by &idvar proc_dt;
run;

data out.pre_ici_surg_patient;
  set work.surg_inwindow;
  by &idvar;

  retain pre_ici_surg earliest_surg_dt earliest_surg_source;
  format earliest_surg_dt date9.;

  if first.&idvar then do;
    pre_ici_surg = 1;
    earliest_surg_dt = proc_dt;
    earliest_surg_source = source;
    output;
  end;

  keep &idvar pre_ici_surg earliest_surg_dt earliest_surg_source;
run;

/* QC G2: should be one row per patient with surgery */
proc sql;
  title "QC G2: pre_ici_surg_patient uniqueness";
  select count(*) as n_rows,
         count(distinct &idvar) as n_patients
  from out.pre_ici_surg_patient;
quit;
title;

/* G3: Merge back to full cohort, fill 0 for those without surgery */
proc sort data=out.pre_ici_surg_patient;
  by &idvar;
run;

data out.cohort_with_surg;
  merge work.cohort_dates(in=a)
        out.pre_ici_surg_patient(in=b);
  by &idvar;
  if a;

  if not b then do;
    pre_ici_surg = 0;
    earliest_surg_dt = .;
    earliest_surg_source = "";
  end;
run;

/* QC G3: distribution */
proc freq data=out.cohort_with_surg;
  tables pre_ici_surg / missing;
  title "QC G3: pre_ici_surg distribution in full cohort";
run;
title;


/*=============================================================================*/
/*  SECTION H: Distributions by exposure arm, index regimen, stage             */
/*=============================================================================*/

proc freq data=out.cohort_with_surg;
  tables pre_ici_surg*exposure_arm / missing nocol norow;
  title "QC H1: pre_ici_surg by exposure_arm";
run;
title;

proc freq data=out.cohort_with_surg;
  tables pre_ici_surg*index_regimen / missing nocol norow;
  title "QC H2: pre_ici_surg by index_regimen";
run;
title;

proc freq data=out.cohort_with_surg;
  tables pre_ici_surg*STAGE_GROUP pre_ici_surg*STAGE_LABEL / missing;
  title "QC H3: pre_ici_surg by stage";
run;
title;


/*=============================================================================*/
/*  SECTION I: Add pre_ici_surg back into the master cohort dataset            */
/*  Output: OUT.skin_ici_patient_covar_plus_surg                               */
/*=============================================================================*/

proc sort data=&cohort_ds out=work.cohort_base;
  by &idvar;
run;

proc sort data=out.cohort_with_surg out=work.surgflag;
  by &idvar;
run;

data out.skin_ici_patient_covar_plus_surg;
  merge work.cohort_base(in=a)
        work.surgflag(in=b keep=&idvar pre_ici_surg earliest_surg_dt earliest_surg_source);
  by &idvar;
  if a;

  /* QC safety: if missing after merge, force 0 */
  if missing(pre_ici_surg) then pre_ici_surg=0;
run;

/* QC I1 */
proc sql;
  title "QC I1: Final cohort + surg variable present";
  select count(*) as n_rows,
         count(distinct &idvar) as n_patients,
         sum(pre_ici_surg=1) as n_surg_patients,
         sum(pre_ici_surg=0) as n_nosurg_patients
  from out.skin_ici_patient_covar_plus_surg;
quit;
title;

/* QC I2: spot check */
proc print data=out.skin_ici_patient_covar_plus_surg(obs=20);
  var &idvar DX_DATE ici_index_dt pre_ici_surg earliest_surg_dt earliest_surg_source exposure_arm index_regimen STAGE_GROUP STAGE_LABEL;
  title "QC I2: Spot-check merged variables";
run;
title;


/*QC against known surgery cases in SEER file, using RX_Summ_Surg_Prim_Site_1998*/

/*Field Description: Surgery of Primary Site describes a surgical procedure that removes and/or */
/*destroys tissue of the primary site performed as part of the initial work-up or */
/*first course of therapy. The actual coding schemes for individual sites and */
/*diagnosis years can be viewed here */
/*General Coding Structure */
/*Code Description*/
/*00 None no surgical procedure of primary site diagnosed at */
	/*autopsy only*/
/*10-19 Site-specific codes. Tumor destruction no pathologic */
	/*specimen or unknown whether there is a pathologic */
	/*specimen*/
/*20-80 Site-specific codes. Resection pathologic specimen*/
/*90 Surgery, NOS. A surgical procedure to the primary site */
	/*was done, but no information on the type of surgical */
	/*procedure is provided.*/
/*98 Special codes for hematopoietic, reticuloendothelial, */
	/*immunoproliferative, myeloproliferative diseases illdefined sites and unknown primaries (See site-specific */
	/*codes for the sites and histologies), except death */
	/*certificate only*/
/*99 Unknown if surgery performed death certificate only*/
/*126 Blank*/


proc freq data=out.skin_ici_patient_covar_plus_surg;
  tables RX_SUMM_SURG_PRIM_SITE_1998 * pre_ici_surg / missing;
  title "SEER Surgery of Primary Site vs CMS-identified surgery";
run;
data work.seer_vs_cms;
  set out.skin_ici_patient_covar_plus_surg;

  if 20 <= RX_SUMM_SURG_PRIM_SITE_1998 <= 80 then seer_surg = 1;
  else if RX_SUMM_SURG_PRIM_SITE_1998 = 90 then seer_surg = 1; /* optional */
  else seer_surg = 0;
run;

proc freq data=work.seer_vs_cms;
  tables seer_surg * pre_ici_surg / missing;
  title "Collapsed SEER surgery vs CMS surgery";
run;

/* RX_Summ_Systemic_Sur_Seq*/
/*Research Plus Limited-Field: No*/
/*Field Description: This data item records the sequencing of systemic therapy and surgical */
/*procedures given as part of first course of treatment. */
/*Code Description*/
/*0 No systemic therapy and/or surgical procedures; unknown if */
/*surgery and/or systemic therapy given*/
/*2 Systemic therapy before surgery*/
/*3 Systemic therapy after surgery*/
/*4 Systemic therapy both before and after surgery*/
/*5 Intraoperative systemic therapy*/
/*6 Intraoperative systemic therapy with other therapy administered */
/*before and/or after surgery*/
/*7 Surgery both before and after systemic therapy*/
/*9 Sequence unknown, but both surgery and systemic therapy */
/*given*/

data work.seq_compare;
  set out.skin_ici_patient_covar_plus_surg;

  length seer_seq_grp $40;

  select (RX_SUMM_SYSTEMIC_SURG_SEQ);
    when (3) seer_seq_grp = "Systemic after surgery";
    when (7) seer_seq_grp = "Surgery before & after systemic";
    when (4) seer_seq_grp = "Systemic before & after surgery";
    when (2) seer_seq_grp = "Systemic before surgery";
    when (9) seer_seq_grp = "Both given, sequence unknown";
    when (5,6) seer_seq_grp = "Intraoperative systemic";
    otherwise seer_seq_grp = "None/unknown";
  end;
run;

proc freq data=work.seq_compare;
  tables seer_seq_grp * pre_ici_surg / missing nocol norow;
  title "Collapsed SEER Systemic–Surgery Sequence vs CMS Surgery";
run;

proc sql;
  title "QC: CMS surgery rate among SEER 'Systemic after surgery'";
  select
    sum(pre_ici_surg=1) as cms_surg,
    sum(pre_ici_surg=0) as cms_no_surg,
    calculated cms_surg / (calculated cms_surg + calculated cms_no_surg)
      as pct_with_cms_surg format=percent8.1
  from work.seq_compare
  where RX_SUMM_SYSTEMIC_SURG_SEQ = 3;
quit;

