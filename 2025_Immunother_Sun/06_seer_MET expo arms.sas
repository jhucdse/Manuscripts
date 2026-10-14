*******************************************************************************;
* Program name      :	06_seer_MET expo arms
* Author            :	Xinyi Sun
* Date created      :	November 22 2024
* Study             : 	
* Purpose           :	Describe antidiabetics treatment pattern, derive the Met vs Non Met expo arms
* Inputs            :	
* Program completed : 	
* Updated by        :   
*********************************************************************************;


LIBNAME seer 'S:\Pharmacoepi0216\Thesis';
LIBNAME thesis 'S:\Pharmacoepi0216\Thesis_new';

/************  Describe antidiabetics use for the cohort *************/
/* Check cohort size */
data thesis.cohort;
set seer.cohort;
run;
proc freq data = thesis.cohort nlevels;
table patient_id /noprint;
run; /*4940*/
proc freq data = thesis.cohort;
tables exposure_arm diabetes;
run;
data missing_records;
    set thesis.cohort;
    if diabetes_date = .;
run; /* 0 missing diabetes_date */

/* 2012-2013 PDE files */
proc sql;
create table pde_cohort_1213 as
select *
from seer.pdesaf1213
where patient_id in(select distinct patient_id from thesis.cohort);
quit;

/* 2014-2019 PDE files */
proc sql;
create table pde_cohort_1419 as
select *
from seer.pdesaf1419
where patient_id in(select distinct patient_id from thesis.cohort);
quit; 

/* No. of observations per person? */
	proc contents data = pde_cohort_1213;
	run;
	proc contents data = pde_cohort_1419;
	run;

	/* Merge the 2 datasets conserving common data columns-- 40/42 of the 2012-2013 data columns and 40/43 of the 2014-2019 data columns */ 
	data thesis.pde_cohort;
		set pde_cohort_1213 (keep = BENEFIT_PHASE BN BRND_GNRC_CD CMPND_CD CTSTRPHC_CVRG_CD CVRD_D_PLAN_PD_AMT DAW_PROD_SLCTN_CD DAYS_SUPLY_NUM DRUG_CVRG_STUS_CD DSPNSNG_STUS_CD FILL_NUM FORMULARY_ID FRMLRY_RX_ID GCDF GCDF_DESC GDC_ABV_OOPT_AMT GDC_BLW_OOPT_AMT GNN LICS_AMT NCVRD_PLAN_PD_AMT OTHR_TROOP_AMT PATIENT_ID PDE_ID PDE_PRSCRBR_ID_FRMT_CD PD_DT PHRMCY_SRVC_TYPE_CD PLAN_CNTRCT_REC_ID PLAN_PBP_REC_NUM PLRO_AMT PRCNG_EXCPTN_CD PROD_SRVC_ID PTNT_PAY_AMT PTNT_RSDNC_CD QTY_DSPNSD_NUM RPTD_GAP_DSCNT_NUM RX_ORGN_CD SRVC_DT STR SUBMSN_CLR_CD TOT_RX_CST_AMT)
			pde_cohort_1419 (keep = BENEFIT_PHASE BN BRND_GNRC_CD CMPND_CD CTSTRPHC_CVRG_CD CVRD_D_PLAN_PD_AMT DAW_PROD_SLCTN_CD DAYS_SUPLY_NUM DRUG_CVRG_STUS_CD DSPNSNG_STUS_CD FILL_NUM FORMULARY_ID FRMLRY_RX_ID GCDF GCDF_DESC GDC_ABV_OOPT_AMT GDC_BLW_OOPT_AMT GNN LICS_AMT NCVRD_PLAN_PD_AMT OTHR_TROOP_AMT PATIENT_ID PDE_ID PDE_PRSCRBR_ID_FRMT_CD PD_DT PHRMCY_SRVC_TYPE_CD PLAN_CNTRCT_REC_ID PLAN_PBP_REC_NUM PLRO_AMT PRCNG_EXCPTN_CD PROD_SRVC_ID PTNT_PAY_AMT PTNT_RSDNC_CD QTY_DSPNSD_NUM RPTD_GAP_DSCNT_NUM RX_ORGN_CD SRVC_DT STR SUBMSN_CLR_CD TOT_RX_CST_AMT);
    run;
	proc print data = thesis.pde_cohort (obs = 10);
	run; /*1,213,757 rows*/
proc freq data = thesis.pde_cohort nlevels;
table patient_id /noprint;
run; 
/* 4938 patients have part D claims, 2 lost*/
		proc sql; 
		create table pde_appearances as
		select patient_id,
		count(distinct pde_id) as n_pde_id
		from thesis.pde_cohort
		group by patient_id;
	    quit; 
		proc means data = pde_appearances n mean std min q1 median q3 max;
		var n_pde_id;
		run; 


/********** Find antidiabetics using NDC codes and retain relevant variables ***********/
proc sql;
create table thesis.cohort_DM_Px as
select 
    a.patient_id, 
    a.SRVC_DT, 
    a.PROD_SRVC_ID, 
    a.BN, 
    a.GNN, 
    a.DAYS_SUPLY_NUM, 
    a.GCDF_DESC, 
    a.STR, 
    b.* 
from 
    thesis.pde_cohort as a
inner join 
    diab.Oral_iv_diab_rx as b
on 
    a.PROD_SRVC_ID = b.ndc
order by 
    a.patient_id, 
    a.SRVC_DT;
quit; /*177,233 rows*/

proc freq data = thesis.cohort_DM_Px nlevels;
table patient_id /noprint;
run; 
/* 3943 patients have antiabetics Px, 995 lost*/

proc sql;
    select 
        sum(case when ndc = '' then 1 else 0 end) as missing_ndc,
        sum(case when PROD_SRVC_ID = '' then 1 else 0 end) as missing_prod_srvc_id
    from thesis.cohort_DM_Px;
quit;
/* No missing ndc codes */

/* Check pde claims of the 2300 lost patients with T2Dm but no antidiabetics claims?? */
/* Step 1: Identify patients who are NOT in thesis.cohort_DM_Px */
proc sql;
   create table lost_patients_no_antidiab as
   select distinct patient_id
   from thesis.pde_cohort
   where patient_id not in (select distinct patient_id from thesis.cohort_DM_Px);
quit;

/* Step 2: Get all records from thesis.pde_cohort for lost patients */
proc sql;
   create table pde_lost_patients_no_antidiab as
   select *
   from thesis.pde_cohort
   where patient_id in (select patient_id from lost_patients_no_antidiab);
quit;

proc sort data= pde_lost_patients_no_antidiab;
    by patient_id SRVC_DT;
run;

proc sort data=pde_lost_patients_no_antidiab out=sorted_patients;
    by patient_id SRVC_DT;
run;
/* Check if they have continuous claims through ICI index date */
/* Identify the first and last records for each patient */
data pde_lost_patients_summary(keep=patient_id first_claim_date first_generic_name last_claim_date last_generic_name);
    set sorted_patients;
    by patient_id;
    retain first_claim_date first_generic_name last_claim_date last_generic_name;

    /* First record for the patient */
    if first.patient_id then do;
        first_claim_date = SRVC_DT;
        first_generic_name = GNN;
    end;

    /* Last record for the patient */
    if last.patient_id then do;
        last_claim_date = SRVC_DT;
        last_generic_name = GNN;
        output;
    end;
run;

proc sql;
    create table pde_lost_patients_summary as
    select 
        a.patient_id,
        a.first_claim_date,
        a.first_generic_name,
        a.last_claim_date,
        a.last_generic_name,
        b.ici_index
    from 
        pde_lost_patients_summary as a
    inner join 
        thesis.cohort(keep=patient_id ici_index) as b
    on 
        a.patient_id = b.patient_id;
quit;

data pde_lost_patients_summary;
    set pde_lost_patients_summary;
    
    /* Convert last_claim_date and ici_index to SAS date values */
    last_claim_date_sas = input(last_claim_date, yymmdd8.);
    ici_index_sas = input(ici_index, yymmdd8.);
    format last_claim_date_sas ici_index_sas yymmdd10.; /* Format for better readability */
    
    /* Compare if last_claim_date is later than ici_index */
    if last_claim_date_sas > ici_index_sas then comparison = "Later";
    else if last_claim_date_sas = ici_index_sas then comparison = "Same";
    else comparison = "Earlier";
run;

/* Check the results */
proc freq data=pde_lost_patients_summary;
table comparison;
run;
/*
Earli 82 3.57 82 3.57 
Later 2196 95.48 2278 99.04 
Same 22 0.96 2300 100.00 

*/

/* Thoughts: These 2300 patients have claims of prescription drugs for chronic conditions
such as Hypertension, High blood lipid, but why there are not claims for antidiabetics??
the NCI comorbidity macro 2021 version identify conditions 
with one inpatient diagnosis or twice or more physician/outpatient diagnoses that are at least 30 days apart.  */





/********************** Create antidiabetics use pattern table ***************************/
proc sort data= thesis.cohort;
    by patient_id;
run;
Proc print data = thesis.cohort(obs=5); 
run;
proc freq data= thesis.cohort;
tables first_dx dx_count total_dx ICI_use chemo_use chemo_count ici_only ici_chemo_combo mult_ici exposure_arm diabetes diabetes_comp Charlson firstline days_dx_to_tx;
run;
/* Inner join , thesis.cohort: 4940 patients, thesis.cohort_DM_Px: 3943 patients */
proc sort data=thesis.cohort_DM_Px;
by patient_id;
run;

data thesis.cohort_ICI_DM_Px;
    merge thesis.cohort(keep = patient_id stage YEAR_OF_BIRTH SEX RACE_ETHNICITY SEQUENCE_NUMBER NSCLC AGE_AT_DX_NUMERIC first_dx total_dx DATE_DX chemo_use chemo_count ici_chemo_combo exposure_arm diabetes diabetes_date diabetes_comp diabetes_comp_date Charlson firstline days_dx_to_tx ici_index in=a) 
          thesis.cohort_DM_Px(in=b);
    by patient_id;
    if a and b; /* Keep only patients present in both tables */
run;

proc print data = thesis.cohort_ICI_DM_Px(obs=20);
run;
proc freq data = thesis.cohort_ICI_DM_Px nlevels;
table patient_id /noprint;
run; /* 3943, same as thesis.cohort_DM_Px */

proc sql;
    select 
        sum(case when ndc = '' then 1 else 0 end) as missing_ndc,
        sum(case when PROD_SRVC_ID = '' then 1 else 0 end) as missing_prod_srvc_id
    from thesis.cohort_ICI_DM_Px;
quit;
/* No missing ndc codes*/


proc freq data = thesis.cohort_ICI_DM_Px;
table DAYS_SUPLY_NUM;
run; /*85% are 30 and 90 days supply*/

/****************************** Define antidiabetics use ************************************/
/*1 year prior to ICI index date*/
 /* Step 1: Convert SRVC_DT and ici_index to date format */
data thesis.cohort_ICI_DM_Px;
    set thesis.cohort_ICI_DM_Px;
    SRVC_DT_date = input(SRVC_DT, yymmdd8.); 
    ici_index_date = input(ici_index, yymmdd8.); 
    format SRVC_DT_date yymmdd10. ici_index_date yymmdd10. diabetes_date yymmdd10.;
run;

proc sort data=thesis.cohort_ICI_DM_Px;
    by patient_id SRVC_DT_date;
run;

data ici_DMpx_comparison (keep = patient_id ici_index_date diabetes_date first_DMpx_date first_MET_date);
    set thesis.cohort_ICI_DM_Px;
    by patient_id;

    retain first_DMpx_date first_MET_date;

    /* Initialize variables for each new patient */
    if first.patient_id then do;
        first_DMpx_date = .; /* Reset for the first record date */
        first_MET_date = .;  /* Reset for the first Metformin record */
    end;

    /* Capture the first record date for each patient */
    if first.patient_id then first_DMpx_date = SRVC_DT_date;

    /* Capture the first Metformin record date (if BIAG_Metf = 1) */
    if BIAG_Metf = 1 and first_MET_date = . then first_MET_date = SRVC_DT_date;

    /* Output at the last record for each patient */
    if last.patient_id then output;
run;

/* Apply date format to the output dataset */
data ici_DMpx_comparison;
    set ici_DMpx_comparison;
    format first_DMpx_date first_MET_date yymmdd10.;
run;

data ici_DMpx_comparison;
    set ici_DMpx_comparison;

    /* Compare first_DMpx_date with ici_index_date */
    if first_DMpx_date < ici_index_date then DMpx_before_ICI = 1; /* Before ICI */
    else DMpx_before_ICI = 0; /* On or after ICI */

    /* Compare first_MET_date with ici_index_date, handle missing values */
    if first_MET_date ne . then do;
        if first_MET_date < ici_index_date then MET_before_ICI = 1; /* Before ICI */
        else MET_before_ICI = 0; /* On or after ICI */
    end;
    else MET_before_ICI = .; 
    /* Calculate days between t2dm Dx and antidiabetics tx*/
    days_dmdx_to_dmpx = first_DMpx_date - diabetes_date;

run;

/* Check the updated dataset */
proc freq data=ici_DMpx_comparison;
tables DMpx_before_ICI MET_before_ICI;
run;
/*
DMpx_before_ICI Frequency Percent Cumulative Frequency Cumulative Percent 
0 79   2.00  79   2.00 
1 3864 98.00 3943 100.00 

MET_before_ICI Frequency Percent Cumulative Frequency Cumulative Percent
0 60   1.85  60   1.85 
1 3180 98.15 3240 100.00 
Frequency Missing = 703
*/

/* Filter the dataset for first dm px after ICI index */
data DMpx_after_ICI_data;
    set ici_DMpx_comparison;
    where DMpx_before_ICI = 0;
    days_ici_to_dmpx = first_DMpx_date - ici_index_date;
	days_dmdx_to_ici = ici_index_date - diabetes_date;
run;

proc univariate data = DMpx_after_ICI_data;
var days_dmdx_to_dmpx days_ici_to_dmpx days_dmdx_to_ici;
run;


/* Among 3864 patients who started antidiabetics use before ICI index, describe their trt pattern within 1 year prior */
 /* Step 1: Filter records of patients not in DMpx_after_ICI_data */
 proc sql;
 create table thesis.cohort_ICI_DM_Px_1y as
 select *
 from thesis.cohort_ICI_DM_Px
 where patient_id not in (select distinct patient_id from DMpx_after_ICI_data);
 quit; /*176822 rows*/
 /* Step 2: Filter records within 1 year prior to ici_index */
data thesis.cohort_ICI_DM_Px_1y;
 set thesis.cohort_ICI_DM_Px_1y;
   if ici_index_date - 365 <= SRVC_DT_date and SRVC_DT_date <= ici_index_date; 
run;
 /* Step 3: Sort the dataset by patient_id and SRVC_DT */
proc sort data=thesis.cohort_ICI_DM_Px_1y;
    by patient_id SRVC_DT_date;
run;

proc freq data = thesis.cohort_ICI_DM_Px_1y nlevels;
table patient_id /noprint;
run; 
/*3523 patients have antidiabetics Px within 1 year prior to ICI index,
call them prevalent antidiabetics users,
lose 341 patients who didn't have antidiabetics Px within 1 year prior,
but started antidiabetics before ICI index */


   /* Step 1: Identify patients who are NOT in thesis.cohort_ICI_DM_Px_1y */
  proc sql;
   create table lost_patients as
   select distinct patient_id
   from thesis.cohort_ICI_DM_Px
   where patient_id not in (select distinct patient_id from thesis.cohort_ICI_DM_Px_1y);
  quit; /* 547 = 122(DmPx after ICI index) +
                 425(DmPx before ICI index but not in the prior year)*/

   /* Step 2: Get all records from thesis.cohort_ICI_DM_Px for lost patients */
  proc sql;
   create table cohort_ICI_DM_Px_lost as
   select *
   from thesis.cohort_ICI_DM_Px
   where patient_id in (select patient_id from lost_patients);
  quit;
/* Describe DM trt pattern among 3523 patients have antidiabetics Px within 1 year prior to ICI index */

 /*** Build cohorts of MET vs non-MET ***/
  /* Prevalent MET definition 1: 1 Px MET */
  /* Create table with drug class count */
proc sql;
    create table antidiab_pattern as
    select patient_id,
           case 
               when sum(BIAG) > 0 then 1
               else 0
           end as MET_1px,
           case 
               when sum(AGLI) > 0 then 1
               else 0
           end as AGLT_1px,
           case 
               when sum(DPP4) > 0 then 1
               else 0
           end as DPP4_1px,
		   case 
               when sum(SGLT) > 0 then 1
               else 0
           end as SGLT_1px,
		   case 
               when sum(SULF) > 0 then 1
               else 0
           end as SULF_1px,
		   case 
               when sum(MEGL) > 0 then 1
               else 0
           end as MEGL_1px,
		   case 
               when sum(TZDS) > 0 then 1
               else 0
           end as TZDS_1px,
		   case 
               when sum(INSU) > 0 then 1
               else 0
           end as INSU_1px,
		   case 
               when sum(GLP1) > 0 then 1
               else 0
           end as GLP1_1px,
		   case 
               when sum(AMYL) > 0 then 1
               else 0
           end as AMYL_1px
    from thesis.cohort_ICI_DM_Px_1y
    group by patient_id;
quit;
data antidiab_pattern;
set antidiab_pattern;
theraclass_ct = sum(AGLT_1px, MET_1px, DPP4_1px, SGLT_1px, SULF_1px, MEGL_1px, TZDS_1px, INSU_1px, GLP1_1px, AMYL_1px);
oral_diab_ct = sum(AGLT_1px, MET_1px, DPP4_1px, SGLT_1px, SULF_1px, MEGL_1px, TZDS_1px);
iv_diab_ct = sum(INSU_1px, GLP1_1px, AMYL_1px);
run;

Proc freq data = antidiab_pattern;
tables MET_1px;
/*tables MET_1px * (AGLT_1px DPP4_1px SGLT_1px SULF_1px MEGL_1px TZDS_1px INSU_1px GLP1_1px AMYL_1px); */
/*tables (AGLT_1px MET_1px DPP4_1px SGLT_1px SULF_1px MEGL_1px TZDS_1px INSU_1px GLP1_1px AMYL_1px) * (AGLT_1px MET_1px DPP4_1px SGLT_1px SULF_1px MEGL_1px TZDS_1px INSU_1px GLP1_1px AMYL_1px);*/
run;
/* No one uses AMYL */

Proc freq data = antidiab_pattern;
/*tables theraclass_ct oral_diab_ct iv_diab_ct;*/
tables theraclass_ct * MET_1px / norow nopercent;
run;
  /* Find those who only used insulin */
proc sql;
    create table insu_only as
	select patient_id, INSU_1px, theraclass_ct  
from antidiab_pattern
where INSU_1px = 1 and theraclass_ct = 1;
quit; /*324 only used insulin*/
proc print data=thesis.cohort_ICI_DM_Px_1y;
    where patient_id in ("lnK2020w0084006", "lnK2020w0127852", "lnK2020w0184152", "lnK2020w0235719", "lnK2020w0254241");
run;
/* Exclude 1 year Px of those only used insulin */
Proc sql;
 create table thesis.cohort_ICI_DM_Px_1y as
 select *
 from thesis.cohort_ICI_DM_Px_1y
 where patient_id not in (select patient_id from insu_only);
quit;
proc freq data = thesis.cohort_ICI_DM_Px_1y nlevels;
table patient_id /noprint;
run; /* 3199 */


/* Final cohort: N = 3199 using def1, MET vs Non-Met(exclude those only used insulin) */
Proc sql;
 create table thesis.cohort_MET_NonMET as
 select *
 from antidiab_pattern
 where patient_id not in (select patient_id from insu_only);
quit;
proc freq data = thesis.cohort_MET_NonMET nlevels;
table patient_id /noprint;
run; /* 3199 = 2499 MET + 700 Non-MET*/
data thesis.Cohort_met_nonmet;
    set thesis.Cohort_met_nonmet;
    thera_pattern = catx('', MET_1px, AGLT_1px, DPP4_1px, SGLT_1px, SULF_1px, MEGL_1px, TZDS_1px, INSU_1px, GLP1_1px, AMYL_1px);
run;

proc freq data=thesis.cohort_MET_NonMET order=freq;
tables thera_pattern;
where MET_1px = 1;
run;
proc freq data=thesis.cohort_MET_NonMET order=freq;
tables thera_pattern;
where MET_1px = 0;
run;


/* Update Jan 15: Hemal&Caleb suggested expo and ref groups: MET(only) vs SULF/&DPP-4 */
data thesis.cohort_MET_SULFDPP4;
    set thesis.cohort_MET_NonMET;
    where thera_pattern in ('1 0 0 0 0 0 0 0 0 0', '0 0 0 0 1 0 0 0 0 0', '0 0 1 0 0 0 0 0 0 0', '0 0 1 0 1 0 0 0 0 0');
run; /* 1486 = 1124 + 362 */

/* 1 year Px-Only include those in the final cohort-*/
Proc sql;
 create table thesis.cohort_ICI_DM_Px_1y as
 select *
 from thesis.cohort_ICI_DM_Px_1y
 where patient_id in (select patient_id from thesis.cohort_MET_SULFDPP4);
quit;
proc freq data = thesis.cohort_ICI_DM_Px_1y nlevels;
table patient_id /noprint;
run; /* 1486 */


/* Prevalent MET definition 2 and 3: For def1 MET cohort, 90/180 days Px MET */
proc sort data=thesis.cohort_ICI_DM_Px_1y;
    by patient_id SRVC_DT_date;
run;
proc sql;
    create table MET_def2or3 as
    select 
        a.patient_id,
        coalesce(sum(b.DAYS_SUPLY_NUM), 0) as MET_days_sup, /* Sum is 0 if no records */
        case 
            when calculated MET_days_sup >= 90 then 1
            when calculated MET_days_sup = 0 then 0
            else . /* between 1 and 89 */
        end as MET_90d
    from 
        (select distinct patient_id from thesis.cohort_ICI_DM_Px_1y) as a /* Ensure all patients are included */
    left join 
        thesis.cohort_ICI_DM_Px_1y as b
    on 
        a.patient_id = b.patient_id and b.BIAG = 1 /* Only include records where BIAG = 1 */
    group by 
        a.patient_id;
quit;

Proc freq data = MET_def2or3;
tables MET_90d;
run;
/*** Def2: 90d MET 
MET_90d   Frequency   Percent
0         362         25.31
1         1068        74.69
***/

/* Prevalent MET definition 3: For def1 MET cohort, 180 days Px MET */
data MET_def2or3;
    set MET_def2or3;
    if MET_days_sup >= 180 then MET_180d = 1;
    else if MET_days_sup = 0 then MET_180d = 0; 
    else MET_180d = .; /* Assign missing for other cases */
run;
Proc freq data = MET_def2or3;
tables MET_180d;
run;
/*** Def3: 180d MET 
MET_90d   Frequency   Percent
0         361         27.63
1         948         72.37
***/

proc sql;
    create table thesis.cohort_met_nonmet_3defs as
    select 
        a.*,                /* Select all variables from cohort_met_nonmet */
        b.MET_90d,          /* Include MET_90d from MET_def2or3 */
        b.MET_180d          /* Include MET_180d from MET_def2or3 */
    from 
        thesis.cohort_met_nonmet as a
    inner join 
        MET_def2or3 as b
    on 
        a.patient_id = b.patient_id; /* Match records by patient_id */
quit;
Proc freq data = thesis.cohort_met_nonmet_3defs;
tables MET_1px MET_90d MET_180d;
run;


* Update April 4th 2025: Check overlap of ICI+MET or ICI+comparator using 30days +/- ICI index;
  /* Antidiabetics */
 /* Step 1: Filter records of patients in thesis.cohort N = 1485 */
 proc sql;
 create table thesis.checkoverlap_dmpx as
 select *
 from thesis.cohort_ICI_DM_Px
 where patient_id in (select distinct patient_id from thesis.cohort);
 quit; /*41748 rows*/
 /* Step 2: Filter records within 1 year prior to ici_index and after ici_index */
data thesis.checkoverlap_dmpx;
 set thesis.checkoverlap_dmpx;
   if ici_index_date - 365 <= SRVC_DT_date; 
run; /*12903 rows*/
 /* Step 3: Sort the dataset by patient_id and SRVC_DT */
proc sort data=thesis.checkoverlap_dmpx;
    by patient_id SRVC_DT_date;
run;

 /*ICI*/
proc sql;
 create table thesis.checkoverlap_ici as
 select *
 from mult_therapy4
 where patient_id in (select distinct patient_id from thesis.cohort);
 quit; 

 /*Distribution of ICI_total*/
 proc univariate data = thesis.checkoverlap_ici; 
	var ICI_total; 
	run;


/* Check overlap by exposure Met_1px */
/* Step 1: Merge cohort with medication data */
proc sql;
    create table med_with_exposure as
    select a.*, b.Met_1px
    from thesis.checkoverlap_dmpx a
    inner join thesis.cohort b
    on a.patient_id = b.patient_id;
quit;

/* Step 2: Calculate days from ICI index date */
data med_with_timediff;
    set med_with_exposure;
    format SRVC_DT_date ici_index_date yymmdd10.;
    days_from_ici = SRVC_DT_date - ici_index_date;
run;

/* Step 3: Filter for ±30 days around ICI index */
data overlap_30days;
    set med_with_timediff;
    if -30 <= days_from_ici <= 30;
run;

data overlap_60days;
    set med_with_timediff;
    if -60 <= days_from_ici <= 60;
run;
/* Step 4: Aggregate flags by patient and medication class */
proc sql;
    create table overlap_flags1 as
    select 
        patient_id,
        Met_1px,
        max(BIAG) as met_use_within30,
        max(max(DPP4), max(SULF)) as dpp4sulf_use_within30
    from overlap_30days
    group by patient_id, Met_1px;
quit;

proc sql;
    create table overlap_flags2 as
    select 
        patient_id,
        Met_1px,
        max(BIAG) as met_use_within60,
        max(max(DPP4), max(SULF)) as dpp4sulf_use_within60
    from overlap_60days
    group by patient_id, Met_1px;
quit;

/* Step 5: Summarize by exposure group */
proc means data=overlap_flags1 n mean;
    class Met_1px;
    var met_use_within30 dpp4sulf_use_within30;
run;
data overlap_flags1;
  set overlap_flags1;
  if (Met_1px = 1 and met_use_within30 = 1) or 
     (Met_1px = 0 and dpp4sulf_use_within30 = 1);
run;
/* 802 participants */
proc means data=overlap_flags2 n mean;
    class Met_1px;
    var met_use_within60 dpp4sulf_use_within60;
run;

data overlap_flags2;
  set overlap_flags2;
  if (Met_1px = 1 and met_use_within60 = 1) or 
     (Met_1px = 0 and dpp4sulf_use_within60 = 1);
run;
/* 1136 participants */
