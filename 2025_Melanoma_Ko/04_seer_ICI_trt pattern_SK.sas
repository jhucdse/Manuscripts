
*******************************************************************************;
* Program name      :	xx_ICI treatment_pattern (+Chemo, etc)
* Author            :	Jamie Heyward
* Date created      :	May 2023
* Study             : 	
* Purpose           :	Describe ICI trt patterns for all ICI patients to place them into different treatment arms
* Inputs            :	
* Program completed : 	
* Updated by        :   Xinyi Sun, for my study, it's a covariate
						Sophia Ko, 12/3/25
*********************************************************************************;


LIBNAME seer 'S:\Pharmacoepi0216\SK_ScM_Thesis25\melanoma project\melanomacohort\Data\processed';
LIBNAME raw 'S:\Pharmacoepi0216\Thesis Project\seer';

/* Describe treatment patterns and combination therapy in order to classify patients by exposure status */ 

/* In Step 1 (a-i) we merged the full treatment history for ICI-exposed patients with 12 months of 
   pre-index enrollment, created indicator variables and running counts for ICI, chemo, and targeted 
   therapy claims, computed timing variables and tracked 
   treatment transitions at both the drug level (within-class switches) and class level 
   (ICI/chemo/targeted). The output is mult_therapy10, a claims-level file with 2178 patients 
   and all treatment records during follow-up.

   In Step 2 (a-f) we use the treatment timing and classification variables from Step 1 to:
       a. Create mult_ici by filtering mult_therapy10 to ICI claims only (excluding atezolizumab)
       b. Identify the index ICI date and all ICI claims occurring on that date
       c. Collapse index-date claims to one row per patient, flagging same-day receipt of 
          2+ distinct ICI agents (i.e., dual ICI = ipilimumab + nivolumab)
       d. Determine line of therapy at index using rx_count: first-line (no prior claims) 
          vs. later-line (prior chemo or targeted therapy claims before ICI index)
       e. Assign each patient to one of four mutually exclusive cohorts:
              1. Mono ICI, first-line                                    n = 1815
              2. Mono ICI, later-line (prior CT or TKI before index)     n = 87
              3. Dual ICI, first-line (nivo + ipi at index)              n = 254
              4. Dual ICI, later-line (prior CT or TKI before index)     n = 21
          and label the index regimen (PEMBROLIZUMAB, NIVOLUMAB, IPILIMUMAB, 
          or IPILIMUMAB + NIVOLUMAB)
       f. Merge cohort and index_regimen back onto mult_ici and mult_therapy10, then 
          stack ICI and non-ICI rows into seer.master_long (the analytic claims-level file 
          preserving all original rows)
*/

			proc print data = seer.tx_all_final_3533  (obs = 20);
			run; 
			proc contents data=seer.tx_all_final_3533; run;



/* 1. Step 1. Add data columns to track exposure (and sequence of use of) ICI, or ICI AND chemo among eligible ICI users */ 
/* SK:  targetted therapy for now, maybe add as a covaraite later on*/

  /* 1a. Filter list of treatments to patients who are ICI-exposed and who had 12 months of insurance coverage before index date, keep ICI index date */
	
		proc sort data = seer.tx_all_final_3533; 
		by patient_id; 
		run; 

		proc sort data = seer.skin_melanoma_analysis_12m; 
		by patient_id; 
		run; 

	data seer.tx_list_ici_pats; 
	merge seer.tx_all_final_3533 (in = a)
		 seer.skin_melanoma_analysis_12m (keep = patient_id first_ici_date in = b);
	by patient_id;
	if b;
	run;

proc print data = seer.tx_list_ici_pats (obs = 10);
run;

	proc freq data = seer.tx_list_ici_pats nlevels;
		table patient_id /noprint;
		run; 

			/* 31740 obs for 2178 pts */
	/* Look at distribution of targeted therapies */
proc freq data = seer.tx_list_ici_pats;
    tables TKI_name / missing;
run;
proc freq data = seer.tx_list_ici_pats;
    tables ICI_name / missing;
run;
proc freq data = seer.tx_list_ici_pats;
    tables Chemo_name / missing;
run;

/* Count records by type */
data check_therapy_types;
    set seer.tx_list_ici_pats;
    if ICI_name ne '.' then therapy_type = "ICI";
    else if chemo_name ne '.' then therapy_type = "Chemo";
    else if TKI_name ne '.' then therapy_type = "Targeted";
    else therapy_type = "Unknown/Other";
run;

proc freq data = check_therapy_types;
    tables therapy_type;
    title "Distribution of Therapy Types";
run;	
 
/* 1b. Add indicator variable for ICI, chemo, AND TARGETED therapy, */
data mult_therapy;
    length ICI_or_chemo_or_tki$ 15;
    set seer.tx_list_ici_pats;
    
    /* Classify treatment type  */
    if ICI_name ne '.' then ICI_or_chemo_or_tki = "ICI";
    else if chemo_name ne '.' then ICI_or_chemo_or_tki = "Chemo";
    else if TKI_name ne '.' then ICI_or_chemo_or_tki = "Targeted";
 
    
    /* Indicators for each type */
    if ICI_or_chemo_or_tki = "ICI" then ICI_indicator = 1;
    else ICI_indicator = 0;
    
    if ICI_or_chemo_or_tki = "Chemo" then chemo_indicator = 1; 
    else chemo_indicator = 0;
    
    if ICI_or_chemo_or_tki = "Targeted" then TKI_indicator = 1;  
    else TKI_indicator = 0;
    
    /* Date conversion */
    tx_date = input(record_dt, yymmdd10.);
    format tx_date date9.;
    
    /* Drug name */
    if ICI_name ne '.' then drug_name = ICI_name; 
    else if chemo_name ne '.' then drug_name = chemo_name;
    else if TKI_name ne '.' then drug_name = TKI_name;
run;

/* 1c. Running count of ICI, chemo, AND TARGETED records */
data mult_therapy1;
    set mult_therapy;
    by patient_id; 
    
    /* ICI count */
    retain ICI_count;
    if first.patient_id then ICI_count = ICI_indicator; 
    else ICI_count = ICI_count + ICI_indicator;
    
    /* Chemo count */
    retain chemo_count;
    if first.patient_id then chemo_count = chemo_indicator; 
    else chemo_count = chemo_count + chemo_indicator;
    
    /* Targeted therapy count - ADD THIS */
    retain TKI_count;
    if first.patient_id then TKI_count = TKI_indicator; 
    else TKI_count = TKI_count + TKI_indicator;
run; 
proc print data = mult_therapy1 (obs =30);
run;

/* 1d. Cumulative totals */
proc sort data = mult_therapy1 out = mult_therapy2;
    by patient_id descending tx_date;  
run; 

data mult_therapy3;
    set mult_therapy2;
    by patient_id;
    
    if first.patient_id then ICI_total = ICI_count;
    retain ICI_total;
    
    if first.patient_id then chemo_total = chemo_count;
    retain chemo_total;
    
    if first.patient_id then TKI_total = TKI_count;  
    retain TKI_total;
run;
proc print data = mult_therapy3 (obs =10);
run;
proc print data = mult_therapy3;
where patient_id ='lnK2020w0100235';
run;

/* 1e. Sort by patient and treatment date */
proc sort data = mult_therapy3; 
    by patient_id tx_date; 
run;

data mult_therapy4; 
    set mult_therapy3;
    by patient_id tx_date;
    
    retain prev_tx_date;
    
    /* Calculate previous treatment date */
    if first.patient_id then do;
        prev_tx_date = .;
        diffdate = .;
    end;
    else do;
        diffdate = tx_date - prev_tx_date;
    end;
    
    /* Update prev_tx_date for next record */
    prev_tx_date = tx_date;
    format prev_tx_date date9.;
run;
proc print data = mult_therapy4 (obs =90);
run;
/* Check for negative diffdate between ICIs (should only be missing for first records) */
proc freq data = mult_therapy4;
    tables diffdate / missing;
    where diffdate < 0;
    title "Check for Negative diffdate";
run; /*2178 missing, which is perfect, this represents the first tx date where there are no prior tx*/
proc sort data=mult_therapy4 out=mult_therapy5;
    by patient_id tx_date;
run;
data mult_therapy5;
    set mult_therapy5;
    by patient_id tx_date; 
    
    retain first_tx_dt;
    
    if first.patient_id then first_tx_dt = tx_date;
    
    /* Days since first treatment of any kind */
    daysince0 = tx_date - first_tx_dt;
    
    /* Days since ICI index (can be negative for treatments BEFORE ICI) */
    daysinceindex = tx_date - first_ici_date;
    
    format first_tx_dt date9.;
run;
proc print data = mult_therapy5 (obs =100);
run;

proc sql;
    create table same_day_tx as
    select patient_id, tx_date, count(*) as n_records,
           sum(case when missing(diffdate) then 1 else 0 end) as n_missing_diffdate,
           sum(case when diffdate = 0 then 1 else 0 end) as n_zero_diffdate
    from mult_therapy5
    group by patient_id, tx_date
    having count(*) > 1
    order by patient_id, tx_date;
quit; /*6430 claims on the same date*/

proc print data = same_day_tx (obs=10);
    title "Patients with Multiple Records on Same Date";
run;

/* Summary statistics */
proc means data = mult_therapy5 n nmiss mean median min max;
    var diffdate daysince0 daysinceindex;
    title "Summary of Treatment Timing Variables";
run;

/*  Check for same-day treatments */

proc sql;
    select patient_id, tx_date, count(*) as n_treatments
    from mult_therapy5
    group by patient_id, tx_date
    having count(*) > 1;
quit;
/* Check unique IDs for same-day treatments */
proc sql;
    create table patient_multisameday as
    select patient_id,
           count(*) as n_multisameday_days
    from (
        select patient_id, tx_date
        from mult_therapy5
        group by patient_id, tx_date
        having count(*) > 1
    )
    group by patient_id;
quit; 
proc print data=patient_multisameday;
run;/*1182 unique IDs with same-day prescriptions, hopefully most of these represent dual ICI population */
/*quick QC to check no drop-offs*/
%macro same_day_check(ds);
  proc sql;
    select "&ds" as dataset length=30,
           count(*) as n_rows,
           count(distinct patient_id) as n_pats
    from &ds;
  quit;

  proc sql;
    select "&ds" as dataset length=30,
           count(distinct patient_id) as pats_with_same_day_mult
    from (
      select patient_id, tx_date
      from &ds
      group by patient_id, tx_date
      having count(*) > 1
    ) as t;
  quit;
%mend;

%same_day_check(mult_therapy);
%same_day_check(mult_therapy4);
%same_day_check(mult_therapy5);


/*## **Understanding my Timeline***/
/**/
/*With ICI as the index:*/
/**/
/*- **Negative `daysinceindex`**: Treatments that occurred **before** first ICI (e.g., targeted therapy, chemo)*/
/*- **Zero `daysinceindex`**: The ICI index treatment itself*/
/*- **Positive `daysinceindex`**: Treatments **after** first ICI*/
/**/
/*Example for melanoma patients who might receive:*/
/*- Targeted therapy first (negative days)*/
/*- Then ICI (day 0)*/
/*- Then maintenance ICI or other treatments (positive days)*/
/**/
/*## **Example Patient Timeline***/
/*```*/
/*Day -90: Targeted therapy (dabrafenib/trametinib)*/
/*Day -60: Targeted therapy*/
/*Day -30: Targeted therapy*/
/*Day 0:   First ICI (pembrolizumab) ? INDEX DATE*/
/*Day 21:  ICI dose 2*/
/*Day 42:  ICI dose 3*/
/*Day 100: Chemo (if progression)*/

/*  For exploration: histogram of daysince0 and daysinceindex for ICI and Chemo rx */ 

		/* Histogram */ 

proc print data=mult_therapy5 (obs=5);
run;
proc print data=mult_therapy5;
var ICI_or_chemo_or_tki;
run;
data mult_therapy100;
    set mult_therapy5;
    where daysince0 < 100;
run;
data mult_therapy200;
    set mult_therapy5;
    where daysinceindex < 200;
run;
ods graphics on;

proc univariate data=mult_therapy100 noprint;
    class ICI_or_chemo_or_tki;/*this variable actually includes TKIs */
    var daysince0;
    histogram daysince0;
    title "Distribution of Days Since Index Date of Any ICI, Chemo, or Targetted Therapy Records";
run;
proc univariate data=mult_therapy200 noprint;
    class ICI_or_chemo_or_tki;/*this variable actually includes TKIs */
    var daysinceindex;
    histogram daysinceindex;
    title "Distribution of Days Since Index Date of ICI Therapy Records";
run;
ods graphics off;

/* 1f. Count total rx_count */

proc sort data=mult_therapy5 out=mult_therapy6; 
    by patient_id tx_date;
run;

data mult_therapy6;
    set mult_therapy6;
    by patient_id;
    if first.patient_id then rx_count = 1;
    else rx_count + 1;
run;
proc print data=mult_therapy6(obs=20);
    var patient_id record_dt ICI_name chemo_name tki_name rx_count;
run;
	/* 1g. Identify ALL treatment transitions:
      - between classes (ICI / chemo / targeted)
      - between drugs within a class (e.g., pembrolizumab to nivolumab)
*/

proc sort data=mult_therapy6 out=mult_therapy7_prep; 
    by patient_id tx_date;
run;
data mult_therapy7;
    set mult_therapy7_prep; 
    by patient_id tx_date;
    
    /* Previous drug */
    prev_drug_name = lag(drug_name);
    if first.patient_id then prev_drug_name = "";
    
    /* Previous class */
    prev_tx_type = lag(ICI_or_chemo_or_tki);
    if first.patient_id then prev_tx_type = "";
    
    /* Previous ICI indicator */
    prev_ICI_indicator = lag(ICI_indicator);
    if first.patient_id then prev_ICI_indicator = 0;
    
    /* Drug-level transition (within OR across classes) */
    if first.patient_id then different_drug = .;
    else if drug_name = prev_drug_name then different_drug = 0;
    else different_drug = 1;
    
    /* Class-level transition */
    if first.patient_id then different_tx_type = .;
    else if ICI_or_chemo_or_tki = prev_tx_type then different_tx_type = 0;
    else different_tx_type = 1;
    
    /* Create separate transition indicators */
    if first.patient_id then do;
        class_switch = .;
        within_ICI_switch = .;
    end;
    else do;
        /* Class switch: Different treatment types */
        if different_tx_type = 1 then class_switch = 1;
        else class_switch = 0;
        
        /* Within-ICI switch: Both current and previous are ICI drugs, but different drugs */
        if ICI_indicator = 1 and prev_ICI_indicator = 1 and different_drug = 1 then 
            within_ICI_switch = 1;
        else if ICI_indicator = 1 and prev_ICI_indicator = 1 and different_drug = 0 then 
            within_ICI_switch = 0;
        else 
            within_ICI_switch = .;  /* Not applicable for non-ICI transitions */
    end;
    
    /* Overall indicator */
    if first.patient_id then overall_transition = .;
    else if different_tx_type = 1 then overall_transition = 1;  /* Class change */
    else if different_drug = 1 then overall_transition = 1;     /* Drug change (within class) */
    else overall_transition = 0;                                 /* No change */
run;
/* 1. Quick check: Are class switches now detected? */
proc freq data=mult_therapy7;
    where overall_transition ne .;
    table class_switch within_ICI_switch overall_transition;
    title "Quick Check: Transition Indicators";
run;

/* 2. Cross-tab: Relationship between the two switch types */
proc freq data=mult_therapy7;
    where overall_transition ne .;
    table class_switch * within_ICI_switch / missing nocol nopct;
    title "Class Switch vs Within-ICI Switch";
run;
proc sort data=mult_therapy7 out=mult_therapy8; 
    by patient_id tx_date;
run;

/* 1h. Count all transitions by type */
data mult_therapy8;
    set mult_therapy8;
    by patient_id;
    
    /* Initialize counters on first record */
    if first.patient_id then do;
        total_transition_count = coalesce(overall_transition, 0);
        total_class_switch_count = coalesce(class_switch, 0);
        total_within_ici_switch_count = coalesce(within_ICI_switch, 0);
    end;
    
    /* Accumulate counts */
    total_transition_count + coalesce(overall_transition, 0);
    total_class_switch_count + coalesce(class_switch, 0);
    total_within_ici_switch_count + coalesce(within_ICI_switch, 0);
run;
proc freq data=mult_therapy8;
table total_transition_count total_within_ici_switch_count;
run;

/* 1i. Add total counts for each patient */
proc sort data=mult_therapy8 out=mult_therapy9;
    by patient_id descending rx_count;  
run;

data mult_therapy9;
    set mult_therapy9;
    by patient_id;
    
    if first.patient_id then do;
        /* Find max values across all records for this patient */
        total_transition_total = .;
        total_class_switch_total = .;
        total_within_ici_switch_total = .;
    end;
    
    /* Update to the maximum value seen so far */
    total_transition_total = max(total_transition_total, total_transition_count);
    total_class_switch_total = max(total_class_switch_total, total_class_switch_count);
    total_within_ici_switch_total = max(total_within_ici_switch_total, total_within_ici_switch_count);
    
    /* Retain across all patient records */
    retain total_transition_total total_class_switch_total total_within_ici_switch_total;
run;

proc print data=mult_therapy9 (obs = 150);
run;
/*checking final frequencies*/
/* Get one record per patient and check totals */
proc sort data=mult_therapy9 out=one_per_patient nodupkey;
    by patient_id;
run;

proc freq data=one_per_patient;
    table total_transition_total total_class_switch_total total_within_ici_switch_total;
    title "Patient-Level Transition Totals - FIXED";
run;

proc sort data=mult_therapy9 out=mult_therapy10;
    by patient_id rx_count;
run;

proc print data=mult_therapy10 (obs=50);
run;
proc contents data=mult_therapy10;
run;

proc print data=mult_therapy10 (obs=20);
    var patient_id tx_date daysince0 daysinceindex diffdate 
        ICI_or_chemo_or_tki drug_name rx_count;
run;
/*mult_therapy10 and mult_ICI are CLAIM level, not pts level files */


/*////////////////////////BEGGINING OF Step 2/////////////////////////*/ 

/*=== Bridge: Create mult_ici directly from Step 1 output ===*/
data mult_ici;
    set mult_therapy10;
    where ICI_indicator = 1
      and ICI_name ne 'ATEZOLIZUMAB';  /* moved from Step 2 */
run;

proc freq data=mult_ici nlevels;
    tables patient_id / noprint;
run;  /* expect 2177 */
/* In Step 3 use the information in step 1 columns to place patients into categories of: 
				1. Mono ICI (first-line)
						n=
				2. Mono ICI (second or later line, exposure to CT or TKI before ICI index)
						n=
				3. Dual ICI (first-line, nivo/ipi at index)
						n=
				4. Dual ICI (second or later line, exposure to CT or TKI before nivo/ipi index)
						n=

		/* 3a. Show frequency tables (again) of total ICI/chemo/TKI transitions */ 

			data ICI_chemo_transition_count; 
			set seer.mult_ici;
			by patient_id;
			if first.patient_id then first = 1; 
			run; 

			data ICI_chemo_transition_count1;
			set ICI_chemo_transition_count;
			where first = 1;
			run; 

				proc print data = ICI_chemo_transition_count1 (obs = 20); 
				run; 
				proc print data = ICI_chemo_transition_count (obs = 20); 
				run; 

			proc freq data = ICI_chemo_transition_count1;
			table total_transition_total;
			run; 
			
			proc freq data = ICI_chemo_transition_count1;
			table total_within_ICI_switch_total;
			run; /*over the entire course of follow-up, 567 pts switched between any two ICI types*/
			
			proc freq data = ICI_chemo_transition_count1;
			table total_class_switch_total;
			run; 
/* Step 3b. Create dataset with only first tx_date for ICI*/
		
	proc print data=mult_ici (obs=5);
	run;
	proc sort data=mult_ici;
    by patient_id tx_date;
	run;

	data index_ici;
    set mult_ici;
    where ICI_indicator = 1 and tx_date = first_ici_date;
	run; /*out of 2177 pts, 3373 claims, explained by  multiple claims on the index date for dual ICI or duplicate records from billing error*/
	proc print data=index_ici (obs=200);
	run;
/* Step 3c. collapsing index row into one per pts, so those with two ICI as first tx on one day marked as dual*/
proc sql;
    create table index_ici_patient as
    select patient_id,
           first_ici_date,
           count(distinct ICI_name) as n_unique_ici,
           max(case when ICI_name='NIVOLUMAB' then 1 else 0 end) as has_nivo,
           max(case when ICI_name='IPILIMUMAB' then 1 else 0 end) as has_ipi
    from index_ici
    group by patient_id, first_ici_date;
quit;
/* Step 3d: determine line of therapy at index (first or second or later)*/
proc sql;
    create table index_rx as
    select patient_id,
           min(rx_count) as index_rx_count
    from index_ici
    group by patient_id;
quit;
data index_rx;
    set index_rx;
    if index_rx_count = 1 then prior_tx = 0;
    else prior_tx = 1;
run;
data index_summary; /*merge tx and patient file*/
    merge index_ici_patient index_rx;
    by patient_id;
run;

/*Step 3e. final cohort assignment at index*/
data cohorts;
    set index_summary;

    length cohort $60;

    if n_unique_ici=1 and prior_tx=0 then
        cohort='1. Mono ICI, first-line';
    else if n_unique_ici=1 and prior_tx=1 then
        cohort='2. Mono ICI, later-line';
    else if n_unique_ici>=2 and has_nivo=1 and has_ipi=1 and prior_tx=0 then
        cohort='3. Dual ICI, first-line';
    else if n_unique_ici>=2 and has_nivo=1 and has_ipi=1 and prior_tx=1 then
        cohort='4. Dual ICI, later-line';

		keep patient_id cohort;
run;
proc freq data=cohorts;
    tables cohort / missing;
run;
proc freq data=index_summary;
    tables n_unique_ici*(has_nivo has_ipi) / missing;
run; /*all pts with dual at dx received nivo + ipi combination
/*table of breakdown of ICI type by mono at index groups*/
proc sort data=index_ici;
    by patient_id;
run;

data mono_index_ici;
    merge index_ici_patient(in=a)
          index_ici(in=b);
    by patient_id;

    if a and b;
    if n_unique_ici = 1;
    if first.patient_id;

    keep patient_id ICI_name;
run;

proc freq data=mono_index_ici;
    tables ICI_name / missing;
    title 'ICI at Index among Mono-ICI Patients';
run;

/*============================================================*/
/* Create index_regimen using actual ICI names at index       */
/*============================================================*/
proc sort data=index_ici;
    by patient_id ICI_name;
run;

proc sort data=index_ici_patient;
    by patient_id;
run;

data index_regimen;
    merge index_ici_patient(in=a)
          index_ici(in=b);
    by patient_id;

    if a and b;
    if first.patient_id;

    length index_regimen $50;

    /* Mono ICI: use actual drug name */
    if n_unique_ici = 1 then
        index_regimen = ICI_name;

    /* Dual (or rare triple): force nivo + ipi */
    else if n_unique_ici >= 2 then
        index_regimen = 'IPILIMUMAB + NIVOLUMAB';

    keep patient_id index_regimen n_unique_ici has_nivo has_ipi;
run;
proc freq data=index_regimen;
    tables index_regimen;
run;

proc freq data=index_regimen;
    where index_regimen = 'IPILIMUMAB + NIVOLUMAB';
    tables has_nivo * has_ipi / missing;
run;

/*Step 3f: attach cohort, index_regimen, to mult_therapy10 and mult_ici*/
proc sort data=mult_ici;
    by patient_id;
run;

proc sort data=mult_therapy10;
    by patient_id;
run;

proc sort data=cohorts;
    by patient_id;
run;
proc sort data=index_regimen;
    by patient_id;
run;

/* Add cohort + index_regimen to mult_ici  */
data mult_ici_cohort;
    merge mult_ici(in=a)
          cohorts(in=b)
          index_regimen(in=c);
    by patient_id;
    if a;
run;

/* Add cohort + index_regimen to full therapy data */
data mult_therapy_cohort;
    merge mult_therapy10(in=a)
          cohorts(in=b)
          index_regimen(in=c);
    by patient_id;
    if a;
run;
/*stack non-ICI rows in mult_therapy10 back into ICI only rows in mult_ici*/
/* Keep only non-ICI rows from mult_therapy10 */
data non_ici_rows;
    set mult_therapy_cohort;
    where ICI_indicator = 0;
run;

/* Stack non-ICI rows + enriched ICI rows */
data seer.master_long;
    set non_ici_rows
        mult_ici_cohort;
run;
proc sql;
    select count(*) as therapy_rows from mult_therapy10;
    select count(*) as master_rows  from master_long;
quit; /*QC confirmed: number of rows preserved across both*/
proc sql;
    select count(*) as ici_rows_original from mult_ici;
    select count(*) as ici_rows_master
    from master_long
    where ICI_indicator = 1;
quit; 
/* Optional QC: index_regimen populated */
proc freq data=seer.master_long;
    where ICI_indicator = 1 and tx_date = first_ici_date;
    tables index_regimen / missing;
run;
/*3373 is not equal to pts 2178, because of both duplicate billing lines & dual ICI presence*/
data work.master_long;
    set seer.master_long;
run;

proc sql;
    create table same_day_ici_claims as
    select patient_id,
           first_ici_date,
           count(*) as n_ici_claims,
           count(distinct ICI_name) as n_unique_ici
    from index_ici
    group by patient_id, first_ici_date
    having calculated n_ici_claims > 1;
quit;

proc freq data=same_day_ici_claims;
    tables n_unique_ici;
run;


/*
 Frequency Percent Cumulative Frequency Cumulative Percent 
1. Mono ICI, first-line 1815 83.37 1815 83.37 
2. Mono ICI, later-line 87 4.00 1902 87.37 
3. Dual ICI, first-line 254 11.67 2156 99.04 
4. Dual ICI, later-line 21 0.96 2177 100.00 


/*mono ICI breakdown:
index_regimen Frequency Percent Cumulative Frequency Cumulative Percent 
IPILIMUMAB 				304 13.96 304 13.96 
IPILIMUMAB + NIVOLUMAB  275 12.63 579 26.60 
NIVOLUMAB 				783 35.97 1362 62.56 
PEMBROLIZUMAB 			815 37.44 2177 100.00 

*/

*************************************************************************************************;
*////////////////////////////////////STEP 3////////////////////////////////////
*************************************************************************************************;


/* 4a. explore the second line of treatment people, what was the breakdown of prior therapy */
/*============================================================*/
/* Explore prior therapy among second-line (or later) ICI pts */
/*============================================================*/

/* 4a: Step 1: Identify all ICI rows on the index date /*/

data index_ici;
    set master_long;
    where ICI_indicator = 1
      and tx_date = first_ici_date;
run;


/* 4a Step 2: Determine line of therapy using rx_count */
proc sql;
    create table index_rx as
    select patient_id,
           min(rx_count) as index_rx_count
    from index_ici
    group by patient_id;
quit;

data index_rx;
    set index_rx;
    if index_rx_count > 1 then second_line = 1;
    else second_line = 0;
run;

/* 4a Step 3: Capture prior therapy type at index */
data prior_therapy;
    set index_ici;
    by patient_id;

    if first.patient_id then do;
        prior_chemo = (chemo_count > 0);
        prior_tki   = (TKI_count > 0);

        if prior_chemo=1 and prior_tki=0 then prior_tx_type = 'Chemo only';
        else if prior_chemo=0 and prior_tki=1 then prior_tx_type = 'TKI only';
        else if prior_chemo=1 and prior_tki=1 then prior_tx_type = 'Chemo + TKI';
        else prior_tx_type = 'Neither';
        output;
    end;

    keep patient_id prior_chemo prior_tki prior_tx_type;
run;

/* 4a Step 4: Restrict to second-line (or later) ICI patients */
data second_line_prior;
    merge index_rx prior_therapy;
    by patient_id;
    if second_line = 1;
run;

/* 4a Step 5: Breakdown of prior therapy */
proc freq data=second_line_prior;
    table prior_tx_type / missing;
	title 'Breakdown of prior therapy among mono and dual ICI users';
run;

/* prior_tx_type Frequency Percent Cumulative
Frequency Cumulative
Percent 
Chemo + TK 1 0.93 1 0.93 
Chemo only 36 33.33 37 34.26 
TKI only 71 65.74 108 100.00 

*/

/* 4a Step 6: Stratify by index ICI regimen (mono vs dual) */
/* Assumes index_ici_patient already created */
data second_line_prior2;
    merge second_line_prior index_ici_patient;
    by patient_id;
run;

proc freq data=second_line_prior2;
    table prior_tx_type * n_unique_ici / missing;
run;
/*
1 pts received 3 different ICIs on the index date??*/

/*Seems to be a different trend of prior therapy whether someone was given a single ICI as first ICI or dual, with more people with prior exposure to TKI or chemo
receiving single ICI */


/* 4b check: 
/*============================================================*/
/* QC: Identify chemo and/or TKI given on the same day as     */
/* index ICI (first_ici_date)                                 */
/*============================================================*/

data index_day_all;
    set master_long;
    where tx_date = first_ici_date;
run;

proc sql;
    create table index_day_flags as
    select patient_id,
           max(ICI_indicator)   as ici_same_day,
           max(chemo_indicator) as chemo_same_day,
           max(TKI_indicator)   as tki_same_day
    from index_day_all
    group by patient_id;
quit;

data index_day_flags;
    set index_day_flags;
    length same_day_tx $30;

    if chemo_same_day=1 and tki_same_day=0 then same_day_tx='ICI + Chemo';
    else if chemo_same_day=0 and tki_same_day=1 then same_day_tx='ICI + TKI';
    else if chemo_same_day=1 and tki_same_day=1 then same_day_tx='ICI + Chemo + TKI';
    else same_day_tx='ICI only';
run;

proc freq data=index_day_flags;
    table same_day_tx / missing;
run;

/* quick QC: confirm that prior tx classifications do not overlap with same-day tx classifications (which will be used as a covaraite*/
data qc_prior_vs_sameday;
    merge prior_therapy index_day_flags;
    by patient_id;
run;

proc freq data=qc_prior_vs_sameday;
    tables prior_tx_type * same_day_tx / missing;
run; /*there are 13 patients who have a chemo clm on the same day as ICI index
only 1/13 patients had a prior CT claim, before they had CT + ICI on the same day
1/37 patients who had prior CT, also had CT claim on the same day as ICI index*/


/* 4c. same day therapy check*/
/*============================================================*/
/* QC: Chemo and/or TKI on the FIRST DAY of ICI index         */
/* Patient-level breakdown                                   */
/* Dataset: mult_ici                                         */
/*============================================================*/

/*4c Step 1: Pull ALL treatment records on index ICI date */
data index_day_all;
    set master_long;
    where tx_date = first_ici_date;
run;

/*4c Step 2: Collapse to ONE record per patient with flags */
proc sql;
    create table index_day_ct_tki as
    select patient_id,
           max(chemo_indicator) as chemo_same_day,
           max(TKI_indicator)   as tki_same_day
    from index_day_all
    group by patient_id;
quit;

/* 4c Step 3: Create mutually exclusive categories */
data index_day_ct_tki;
    set index_day_ct_tki;
    length index_day_tx $30;

    if chemo_same_day=1 and tki_same_day=1 then index_day_tx='Chemo + TKI';
    else if chemo_same_day=1 and tki_same_day=0 then index_day_tx='Chemo only';
    else if chemo_same_day=0 and tki_same_day=1 then index_day_tx='TKI only';
    else index_day_tx='Neither';
run;

/*4c  Step 4: Frequency table (FINAL QC OUTPUT) */
proc freq data=index_day_ct_tki;
    table index_day_tx / missing;
run; 
/* 99.4% of patients initiated ICI without:
		same-day chemotherapy
		same-day TKI */

proc freq data=master_long nlevels;
    where tx_date = first_ici_date;
    tables patient_id / noprint;
run;
proc freq data=master_long;
    where tx_date = first_ici_date;
    tables chemo_indicator TKI_indicator;
run;
proc freq data=index_ici;
    tables ICI_indicator chemo_indicator TKI_indicator;
run;



/*////////////////////////// Step 4: create TKI and Chemo sequence indicators on patient-level * ////////////////////////

/*============================================================*/
/* Create 3-level TKI exposure variable relative to index ICI */
/*============================================================*/

data tki_exposure;
    set index_ici;
    by patient_id;

    /* Use first index row only (handles dual ICI correctly) */
    if first.patient_id then do;

        if TKI_count > 0 then TKI_exposure = 'Pre-index TKI';
        else if TKI_count = 0 and TKI_total > 0 then TKI_exposure = 'Post-index only TKI';
        else if TKI_total = 0 then TKI_exposure = 'Never TKI';

        output;
    end;

    keep patient_id TKI_exposure;
run;

/* QC frequency */
proc freq data=tki_exposure;
    table TKI_exposure / missing;
run;

/*============================================================*/
/* Create 3-level CHEMO exposure variable relative to index ICI */
/*============================================================*/

data chemo_exposure;
    set index_ici;
    by patient_id;

    /* Use first index row only (handles dual ICI correctly) */
    if first.patient_id then do;

        if chemo_count > 0 then chemo_exposure = 'Pre-index Chemo';
        else if chemo_count = 0 and chemo_total > 0 then chemo_exposure = 'Post-index only Chemo';
        else if chemo_total = 0 then chemo_exposure = 'Never Chemo';

        output;
    end;

    keep patient_id chemo_exposure;
run;

/* QC frequency */
proc freq data=chemo_exposure;
    table chemo_exposure / missing;
run;
/*add tki sequence indicator to ici_index*/
proc sort data=index_ici;
    by patient_id;
run;

proc sort data=tki_exposure;
    by patient_id;
run;

data index_ici;
    merge index_ici(in=a)
          tki_exposure(in=b);
    by patient_id;
    if a;
run;

/* add chemo sequence indicator to ici_index*/
proc sort data=chemo_exposure;
    by patient_id;
run;

data index_ici;
    merge index_ici(in=a)
          chemo_exposure(in=b);
    by patient_id;
    if a;
run;

/*============================================================*/
/* Save final analytic dataset                                */
/*============================================================*/

proc sort data=index_ici;
    by patient_id;
run;
proc sort data=master_long;
    by patient_id;
run;

data mult_ici_with_itt;
    merge master_long(in=a)
          index_ici(in=b);
    by patient_id;
    if a;
run;

data seer.mult_ici_with_itt;
    set mult_ici_with_itt;
run;

/* Confirm row counts unchanged */
proc sql;
    select count(*) as n_rows from mult_therapy;
	select count(*) as n_rows from mult_ici;
	select count(*) as n_rows from master_long;
    select count(*) as n_rows from seer.mult_ici_with_itt;
quit;

/* Confirm cohort attached */
proc freq data=seer.mult_ici_with_itt;
    tables cohort / missing;
run; /*need to drop 6 claims for the participant lnK2022T0153400, not sure how they slipped through but they do not have any ICI claims*/
proc freq data=seer.mult_ici_with_itt;
    where missing(cohort);
    tables index_regimen ICI_name / missing;
run;

proc print data=seer.mult_ici_with_itt;
    where missing(cohort);
    by patient_id;
    id patient_id;
    var first_ici_date ICI_name index_regimen;
run;
proc print data=seer.mult_ici_with_itt;
where patient_id = 'lnK2022T0153400';
run;

data seer.mult_ici_with_itt;
    set seer.mult_ici_with_itt;
    if patient_id = "lnK2022T0153400" then delete;
run;

proc freq data=seer.mult_ici_with_itt nlevels;
	table patient_id/noprint;
run;
proc contents data=seer.mult_ici_with_itt;
run;
proc print data=seer.mult_ici_with_itt (obs=30);
run;
proc sort data=seer.mult_ici_with_itt;
    by patient_id;
run;
data mult_ici_patientlevel;
    set seer.mult_ici_with_itt;
    by patient_id;
    if first.patient_id;
run;
proc freq data=mult_ici_patientlevel;

table tki_exposure*cohort;
run;
proc freq data=mult_ici_patientlevel;
table chemo_exposure*cohort;
run;
/*now add important columns to seer short data file */

proc sort data=MULT_ICI_WITH_ITT;
    by patient_id;
run;

data ici_patient_level;
    set MULT_ICI_WITH_ITT;
    by patient_id;

    if first.patient_id then output;

    keep patient_id
         chemo_exposure
         tki_exposure
         cohort
		 index_regimen
         exposure_arm
         first_ici_date
         first_tx_dt
		 chemo_total
		 tki_total
		 ici_total
         total_transition_total
         total_within_ici_switch_total
         total_class_switch_total;
run;
proc freq data=ici_patient_level nlevels;
    tables patient_id / noprint;
run;
proc sort data=seer.skin_melanoma_analysis_12m;
    by patient_id;
run;

proc sort data=ici_patient_level;
    by patient_id;
run;

data skin_melanoma_analysis_12m_rx;
    merge seer.skin_melanoma_analysis_12m(in=a)
          ici_patient_level(in=b);
    by patient_id;

    if a;  /* keep original short cohort */
run;
/*Q C*/
proc sql;
    select count(*) as rows_before from seer.skin_melanoma_analysis_12m;
    select count(*) as rows_after  from skin_melanoma_analysis_12m_rx;
quit;
proc freq data=skin_melanoma_analysis_12m_rx;
    tables cohort
           exposure_arm
           chemo_exposure
           tki_exposure / missing;
run;
proc freq data=skin_melanoma_analysis_12m_rx;
table cohort*index_regimen;
run;
/*save final dataset, making sure to drop atezolizuamb & the individual who was misclassified as dual ICI ipi+nivo, but they actually received ipi+pembro (foud this after running QC on code above)*/
proc contents data=seer.skin_melanoma_analysis_12m_rx;
run;
/*-------------------------------------------------------------*/
/* Reclassify ipi+pembro at index as mono ICI ipilimumab       */
/* Then save final analytic file                               */
/*-------------------------------------------------------------*/
/* Point to the sensitivity subfolder */
libname sensit "S:/Pharmacoepi0216/SK_ScM_Thesis25/melanoma project/melanomacohort/Data/processed/sensitivity analysis";  /* update path to match your folder structure */

/* Step 1: Identify from sensitivity folder */
proc sql;
    create table ipi_pembro_index as
    select patient_id
    from sensit.sensitivity_dual_regimen
    where dual_regimen = 'IPILIMUMAB + PEMBROLIZUMAB'
      and dual_timing = 'At index (day 0)';
quit;
proc print data=ipi_pembro_index;
run;
/* Step 2: Copy to work for updating */
options nofmterr;
data skin_melanoma_analysis_12m_rx;
    set seer.skin_melanoma_analysis_12m_rx;
run;

/* Step 3: Reclassify — removed extra ) */
proc sql;
    update skin_melanoma_analysis_12m_rx
    set index_regimen = 'IPILIMUMAB',
        exposure_arm = 1,
        cohort = '1. Mono ICI, first-line'
    where patient_id = 'lnK2022V0126847';
quit;

/* Verify before saving */
proc sql;
    select patient_id, index_regimen, exposure_arm, cohort
    from skin_melanoma_analysis_12m_rx
    where patient_id = 'lnK2022V0126847';
quit;


/* Step 4: Drop missing cohort + save final */
data seer.skin_melanoma_analysis_12m_rx;
    set skin_melanoma_analysis_12m_rx;
    where not missing(cohort);
run;

/* Step 5: QC */
proc freq data=seer.skin_melanoma_analysis_12m_rx;
    tables index_regimen / missing;
    title "Index Regimen After Reclassification";
run;

proc freq data=seer.skin_melanoma_analysis_12m_rx;
    tables cohort / missing;
    title "Cohort After Reclassification";
run;

proc freq data=seer.skin_melanoma_analysis_12m_rx;
    tables exposure_arm * index_regimen / missing norow nocol;
    title "Exposure Arm by Index Regimen — Confirm Alignment";
run;

proc sql;
    select count(distinct patient_id) as n_patients
    from seer.skin_melanoma_analysis_12m_rx;
quit;


*************************************************************************************************
/*///////////////////////////STEP 5: Reconsidering Exposure Definition ///////////////////////////////*/
/* If I decide to collapse my exposure into mono vs dual, without regard to first or second line tx, then 
/* I will need to use exposure_arm, a binary indicator with 1 = mono ICI at index, and 2 = Dual-agent at index */
*************************************************************************************************;

proc contents data=skin_melanoma_analysis_12m_rx;
run;
data skin_melanoma_analysis_12m_rx;
    set seer.skin_melanoma_analysis_12m_rx;
    by patient_id;

    if cohort in ('1. Mono ICI, first-line',
                  '2. Mono ICI, later-line') then exposure_arm = 1;
    else if cohort in ('3. Dual ICI, first-line',
                       '4. Dual ICI, later-line') then exposure_arm = 2;
run;
proc freq data=skin_melanoma_analysis_12m_rx;
table exposure_arm*cohort;
run;
proc freq data=skin_melanoma_analysis_12m_rx;
table index_regimen*year_of_diagnosis;
run;

proc freq data=skin_melanoma_analysis_12m_rx;
table cohort*year_of_diagnosis;
run;
/* Create temporary year variable from first ICI date */
data skin_melanoma_analysis_12m_rx_yr;
    set skin_melanoma_analysis_12m_rx;
    index_ici_year = year(first_ici_date);
run;

/* Table of index regimen by index ICI year */
proc freq data=skin_melanoma_analysis_12m_rx_yr;
    tables index_regimen * index_ici_year / missing;
run;
/* Table of cohort by index ICI year */
proc freq data=skin_melanoma_analysis_12m_rx_yr;
    tables cohort * index_ici_year / missing;
run;
proc freq data=skin_melanoma_analysis_12m_rx_yr;
    tables cohort * index_regimen * index_ici_year / missing;
run;



*************************************************************************************************
/*///////////////////////////STEP 6: Summary of Final Cohort ///////////////////////////////*/
*************************************************************************************************;

	

		/* Regimen by exposure arm */ 
		proc freq data = skin_melanoma_analysis_12m_rx; 
		where exposure_arm = 1; 
		table index_regimen; 
		run; 

		proc freq data = skin_melanoma_analysis_12m_rx; 
		where exposure_arm = 2; 
		table index_regimen; 
		run; 
 

		/* Regimen by exposure arm and stage at diagnosis */ 
		proc freq data = skin_melanoma_analysis_12m_rx; 
		where exposure_arm = 1; 
		table index_regimen*STAGE_GROUP; 
		run; 

		proc freq data = skin_melanoma_analysis_12m_rx; 
		where exposure_arm = 2; 
		table index_regimen*STAGE_GROUP; 
		run; 

		

		/* Dx to treatment gap by regimen and stage at diagnosis */ 
		/*JH looked at days to tx (first of any?), SK looks at months to first ICI */
		/* SK CONSIDER using a day to first tx variable (instead of months_dx_to_ici) in later exploration */

		proc means data = skin_melanoma_analysis_12m_rx n mean std p25 p50 p75 min max; 
		where exposure_arm = 1;
		class index_regimen stage_group; 
		var months_dx_to_ici; 
		run; 

		proc means data = skin_melanoma_analysis_12m_rx n mean std p25 p50 p75 min max; 
		where exposure_arm = 2;
		class index_regimen stage_group; 
		var months_dx_to_ici; 
		run; 


		/* Months from dx to ICI tx */ 
		proc means data = skin_melanoma_analysis_12m_rx n mean std p25 p50 p75 min max; 
		where exposure_arm = 1;
		class index_regimen cohort; 
		var months_dx_to_ici; 
		run; 

		proc means data = skin_melanoma_analysis_12m_rx n mean std p25 p50 p75 min max; 
		where exposure_arm = 2;
		class index_regimen cohort; 
		var months_dx_to_ici; 
		run; 




		/* Index date by regimen */ 
		/* Single ICI */ 
		proc univariate data = skin_melanoma_analysis_12m_rx noprint; 
		where exposure_arm = 1; 
		histogram first_ici_date; 
		class index_regimen; 
		run;

		proc sgplot data = skin_melanoma_analysis_12m_rx; 
		where exposure_arm = 1; 
		histogram first_ici_date / group = index_regimen transparency = 0.5; 
		density first_ici_date / type=kernel group=index_regimen; 
		run;
		/*all exposures*/
		proc sgplot data = skin_melanoma_analysis_12m_rx;  
		histogram first_ici_date / group = index_regimen transparency = 0.5; 
		title 'ICI Regimen Over Time';
		density first_ici_date / type=kernel group=index_regimen; 
		run;

		/* ICI + ICI */

		proc univariate data = skin_melanoma_analysis_12m_rx noprint; 
		where exposure_arm = 2; 
		histogram first_ici_date; 
		class index_regimen; 
		run;

		proc sgplot data = skin_melanoma_analysis_12m_rx; 
		where exposure_arm = 2; 
		histogram first_ICI_date / group = index_regimen transparency = 0.5; 
		density sw / type=kernel group=exposure_arm; 
		run;

		/* Regimen by prior surgery status */ 
		proc contents data=skin_melanoma_analysis_12m_rx;
		run; /*summ_surg is numeric, so no $ needed*/
		proc format;
    	value Surgery
        0        = 'None'
        10-19    = 'Tumor destruction'
        20-80    = 'Resection'
        90       = 'NOS'
        98-99    = 'Unknown or special';
		run; 

		data seer.skin_melanoma_analysis_12m_rx; 
			set skin_melanoma_analysis_12m_rx; 
			format RX_SUMM_SURG_PRIM_SITE_1998 Surgery.; 
		run; 

		proc freq data = skin_melanoma_analysis_12m_rx; 
		where exposure_arm = 1; 
		table index_regimen*RX_SUMM_SURG_PRIM_SITE_1998; 
		run; 

		proc freq data = skin_melanoma_analysis_12m_rx; 
		where exposure_arm = 2; 
		table index_regimen*RX_SUMM_SURG_PRIM_SITE_1998; 
		run; 


		/* Regimen by prior radiation status */ 
		proc format; 
		value  Radiation_recode 0 = 'None/Unknown'
						 1 - 6 = 'Radiation (any)'
						 7 = 'Refused'
						 8 = 'Recommended/unknown';
						 run; 

				
					data skin_melanoma_analysis_12m_rx; 
					set skin_melanoma_analysis_12m_rx; 
					format radiation_recode  Radiation_recode.; 
					run; 
		
		proc freq data = skin_melanoma_analysis_12m_rx; 
		where exposure_arm = 1; 
		table index_regimen* Radiation_recode; 
		run; 

		proc freq data = skin_melanoma_analysis_12m_rx; 
		where exposure_arm = 2; 
		table index_regimen*radiation_recode; 
		run; 


		/* Organize chemo, radiation, surgery status by regimen */ 
	proc freq data=skin_melanoma_analysis_12m_rx;
    tables index_regimen * chemo_exposure / missing;
	run;

		data skin_melanoma_analysis_12m_rx; 
		set seer.skin_melanoma_analysis_12m_rx; 
		if RX_SUMM_SURG_PRIM_SITE_1998 ne '00' & RX_SUMM_SURG_PRIM_SITE_1998 ne'' then surgery_binary = 1; 
			else if RX_SUMM_SURG_PRIM_SITE_1998 in('00') then surgery_binary = 0; 
			else if RX_SUMM_SURG_PRIM_SITE_1998 = '' then surgery_binary = '';
		if radiation_recode in (1:6) then radiation_binary = 1;
			else if radiation_recode not in (1:6) and radiation_recode ne '' then radiation_binary = 0; 
			else if radiation_recode = '' then radiation_binary = '';
		run;
proc print data=skin_melanoma_analysis_12m_rx (obs=50);
var index_regimen;
run;
data skin_melanoma_analysis_12m_rx;
    set skin_melanoma_analysis_12m_rx;

    length prior_tx prior_tx1 $40;

    /*----------------------------------*/
    /* Define prior CHEMO indicator     */
    /*----------------------------------*/
    if chemo_exposure = 'Pre-index Chemo' then prior_chemo = 1;
    else if chemo_exposure in ('Post-index only Chemo','Never Chemo') then prior_chemo = 0;
    else prior_chemo = .;

    /*----------------------------------*/
    /* PRIOR_TX: fully observed only    */
    /*----------------------------------*/
    if prior_chemo=0 & surgery_binary=0 & radiation_binary=0 then prior_tx='None';
    else if prior_chemo=1 & surgery_binary=0 & radiation_binary=0 then prior_tx='Chemo';
    else if prior_chemo=0 & surgery_binary=1 & radiation_binary=0 then prior_tx='Surgery';
    else if prior_chemo=0 & surgery_binary=0 & radiation_binary=1 then prior_tx='Radiation';
    else if prior_chemo=1 & surgery_binary=1 & radiation_binary=0 then prior_tx='Chemo + Surgery';
    else if prior_chemo=1 & surgery_binary=0 & radiation_binary=1 then prior_tx='Chemo + Radiation';
    else if prior_chemo=0 & surgery_binary=1 & radiation_binary=1 then prior_tx='Surgery + Radiation';
    else if prior_chemo=1 & surgery_binary=1 & radiation_binary=1 then prior_tx='Chemo + Surgery + Radiation';
    else prior_tx='';

    /*----------------------------------*/
    /* PRIOR_TX1: allow missing values  */
    /*----------------------------------*/
    if prior_chemo=0 & surgery_binary=0 & radiation_binary=0 then prior_tx1='None';
    else if prior_chemo=1 & surgery_binary=0 & radiation_binary=0 then prior_tx1='Chemo';
    else if prior_chemo=0 & surgery_binary=1 & radiation_binary=0 then prior_tx1='Surgery';
    else if prior_chemo=0 & surgery_binary=0 & radiation_binary=1 then prior_tx1='Radiation';
    else if prior_chemo=1 & surgery_binary=1 & radiation_binary=0 then prior_tx1='Chemo + Surgery';
    else if prior_chemo=1 & surgery_binary=0 & radiation_binary=1 then prior_tx1='Chemo + Radiation';
    else if prior_chemo=0 & surgery_binary=1 & radiation_binary=1 then prior_tx1='Surgery + Radiation';
    else if prior_chemo=1 & surgery_binary=1 & radiation_binary=1 then prior_tx1='Chemo + Surgery + Radiation';

    /* Missing component handling */
    else if radiation_binary = . then prior_tx1 = cats('Radiation missing');
    else if surgery_binary = . then prior_tx1 = cats('Surgery missing');
    else if prior_chemo = . then prior_tx1 = cats('Chemo missing');

run;

proc freq data = skin_melanoma_analysis_12m_rx;
		table exposure_arm*chemo_exposure exposure_arm*tki_exposure; 
		run; 
 

		proc freq data = skin_melanoma_analysis_12m_rx;
		table index_regimen*prior_tx index_regimen*prior_tx1; 
		run; 

		proc means data = skin_melanoma_analysis_12m_rx n mean std p25 p50 p75 min max; 
		class index_regimen prior_tx; 
		var months_dx_to_ICI; 
		run; 


proc print data = skin_melanoma_analysis_12m_rx (obs = 5);
run; 


		data seer.skin_melanoma_analysis_12m_rx; 
		set skin_melanoma_analysis_12m_rx; 
		format radiation_recode  Radiation_recode.; 
		run; 
dm 'odsresults; clear;';

/*QC1*/


proc freq data=seer.tx_list_ici_pats;
  tables ICI_name chemo_name TKI_name / missing;
run;

proc sql;
  select 
    sum(missing(ICI_name)) as ICI_blank_missing,
    sum(strip(ICI_name)='.') as ICI_dot_missing
  from seer.tx_list_ici_pats;
quit;
/*not a serious issue, just missingness s stored in two formats, "" and "."*/

/* QC 2*/
data qc_multi_populated;
  set seer.tx_list_ici_pats;
  n_nonmiss = (not missing(strip(ICI_name)) and strip(ICI_name) ne '.')
            + (not missing(strip(chemo_name)) and strip(chemo_name) ne '.')
            + (not missing(strip(TKI_name)) and strip(TKI_name) ne '.');
  if n_nonmiss >= 2;
run;

proc freq data=qc_multi_populated;
  tables n_nonmiss;
run;

proc print data=qc_multi_populated(obs=50);
  var patient_id record_dt ICI_name chemo_name TKI_name;
run;
/* returns 0 rows, rules out Dual ICI being “hidden” on one row because two drugs were stuffed into different columns*/

/*QC3*/
proc contents data=mult_therapy;
run;
 proc sql;
  select 
    sum(missing(first_ici_date)) as n_missing_tx_date,
    sum(missing(first_ici_date) and ICI_indicator=1) as n_missing_tx_date_ici
  from mult_therapy;
quit;

proc print data=mult_therapy(obs=100);
  where missing(first_ici_date);
  var patient_id record_dt ICI_name chemo_name TKI_name;
run;
/*QC passed*/
/*QC4*/
/*find multi-ICI on index date that is not nivo +ipi */
proc sql;
  create table qc_multi_ici_not_ipi_nivo as
  select *
  from index_ici_patient
  where n_unique_ici >= 2 and not (has_nivo=1 and has_ipi=1);
quit;

proc print data=qc_multi_ici_not_ipi_nivo(obs=50);
run;

/* QC pass*/

/*QC5*/
/*detect spacing that could lead to misclassification*/
proc sql;
  create table qc_ici_name_variants as
  select patient_id, first_ici_date,
         ICI_name,
         cats('[', ICI_name, ']') as bracketed,
         length(ICI_name) as len
  from index_ici
  order by patient_id, first_ici_date, ICI_name;
quit;

proc print data=qc_ici_name_variants(obs=200);
run;
/*QC pass*/

/*QC6*/
/*This is the best end-to-end audit: recompute “dual at index day” from raw index_ici and compare to your exposure_arm.*/

/* recompute dual flag from raw index-day ICI claims */
proc sql;
  create table qc_dual_raw as
  select patient_id,
         (count(distinct upcase(strip(ICI_name))) >= 2 
          and max(upcase(strip(ICI_name))='NIVOLUMAB')=1
          and max(upcase(strip(ICI_name))='IPILIMUMAB')=1) as dual_raw
  from index_ici
  group by patient_id;
quit;

/* pull your final exposure_arm */
proc sort data=skin_melanoma_analysis_12m_rx out=final_one nodupkey;
  by patient_id;
run;

proc sql;
  create table qc_compare as
  select a.patient_id,
         a.exposure_arm,
         b.dual_raw
  from final_one as a
  left join qc_dual_raw as b
    on a.patient_id=b.patient_id;
quit;

proc freq data=qc_compare;
  tables exposure_arm*dual_raw / missing;
run;

/* list discordant patients */
proc print data=qc_compare(obs=200);
  where (exposure_arm=1 and dual_raw=1) or (exposure_arm=2 and dual_raw=0);
run;


/*check that 275 dual are labelled corrrectly*/
/* Reconstruct index-day ICI exposure from FINAL long data */
proc sql;
  create table qc_dual_truth as
  select patient_id,
         count(*) as n_ici_claims,
         count(distinct upcase(strip(ICI_name))) as n_unique_ici,
         max(upcase(strip(ICI_name))='NIVOLUMAB')  as has_nivo,
         max(upcase(strip(ICI_name))='IPILIMUMAB') as has_ipi
  from seer.master_long
  where ICI_indicator = 1
    and tx_date = first_ici_date
  group by patient_id;
quit;

proc freq data=qc_dual_truth;
  tables n_unique_ici*(has_nivo has_ipi) / missing;
run;
proc sql;
  create table qc_compare_final as
  select a.patient_id,
         a.exposure_arm,
         (b.n_unique_ici=2 and b.has_nivo=1 and b.has_ipi=1) as dual_truth
  from skin_melanoma_analysis_12m_rx as a
  left join qc_dual_truth as b
    on a.patient_id=b.patient_id;
quit;

/* force missing ? 0 */
data qc_compare_final;
  set qc_compare_final;
  if missing(dual_truth) then dual_truth = 0;
run;

proc freq data=qc_compare_final;
  tables exposure_arm*dual_truth / missing;
run;


*************************************************************************************************
/*///////////////////////////Alternate Analysis: Expanding Dual ICI Definition ///////////////////////////////*/
*************************************************************************************************;

/*=============================================================*/
/* Explore: Ever same-day dual ICI use during follow-up        */
/*=============================================================*/
/*=============================================================*/
/* Dual ICI Analysis: Ever same-day dual ICI during follow-up  */
/* Input:  mult_ici (ICI claims-level, from Step 1 bridge)     */
/* Output: Patient-level dual ICI flags and cumulative windows  */
/*=============================================================*/


/*-------------------------------------------------------------*/
/* 1. Find ALL same-day dual ICI dates per patient             */
/*-------------------------------------------------------------*/
proc sql;
    create table all_dual_dates as
    select patient_id,
           tx_date,
           count(distinct ICI_name) as n_unique_ici,
           catx(' + ', min(ICI_name), max(ICI_name)) as dual_regimen length=60
    from mult_ici
    group by patient_id, tx_date
    having calculated n_unique_ici >= 2
    order by patient_id, tx_date;
quit;

/* Top-level counts */
proc sql;
    select count(distinct patient_id) as n_ever_dual_ici,
           count(*) as n_dual_ici_dates
    from all_dual_dates;
quit;


/*-------------------------------------------------------------*/
/* 2. One row per patient: ICI index date (deduplicated)       */
/*-------------------------------------------------------------*/
proc sql;
    create table ici_index_dates as
    select distinct patient_id, first_ici_date
    from mult_ici;
quit;


/*-------------------------------------------------------------*/
/* 3. First-ever dual ICI date per patient + days from index   */
/*-------------------------------------------------------------*/
/*-------------------------------------------------------------*/
/* 3. First-ever dual ICI date per patient (FIXED)             */
/*    Step A: Collapse to one row per patient BEFORE joining   */
/*    Step B: Add index date via separate join                 */
/*-------------------------------------------------------------*/

/* Step A: one row per patient — guaranteed */
proc sql;
    create table first_dual_a as
    select patient_id,
           min(tx_date) as first_dual_date format=date9.
    from all_dual_dates
    group by patient_id;
quit;

/* QC: must equal 397 */
proc sql;
    select count(*) as n_check from first_dual_a;
quit;

/* Step B: add index date */
proc sql;
    create table first_dual as
    select a.patient_id,
           a.first_dual_date,
           b.first_ici_date format=date9.,
           a.first_dual_date - b.first_ici_date as days_to_dual
    from first_dual_a a
    inner join ici_index_dates b
        on a.patient_id = b.patient_id;
quit;

/* QC: must still equal 397 */
proc sql;
    select count(*) as n_patients_ever_dual from first_dual;
quit;




/*-------------------------------------------------------------*/
/* 4. Add dual regimen and timing labels                       */
/*-------------------------------------------------------------*/

/* Get the regimen from the first dual date */
proc sql;
    create table first_dual_detail as
    select a.*,
           b.dual_regimen
    from first_dual a
    left join all_dual_dates b
        on a.patient_id = b.patient_id
       and a.first_dual_date = b.tx_date;
quit;

data first_dual_detail;
    set first_dual_detail;
    length dual_timing $30;
    if days_to_dual = 0 then dual_timing = 'At index (day 0)';
    else if days_to_dual > 0 then dual_timing = 'After index';
    else dual_timing = 'ERROR: before index';
run;


/*-------------------------------------------------------------*/
/* 5. Patient-level summary statistics                         */
/*-------------------------------------------------------------*/

/* Overall */
proc means data=first_dual_detail n mean std median q1 q3 min max;
    var days_to_dual;
    title "Days from ICI Index to First Dual ICI (All Ever-Dual, Patient-Level)";
run;

/* Among those who started dual AFTER index */
proc means data=first_dual_detail n mean std median q1 q3 min max;
    where days_to_dual > 0;
    var days_to_dual;
    title "Days from ICI Index to First Dual ICI (Post-Index Starters Only)";
run;

/* Timing and regimen frequencies */
proc freq data=first_dual_detail;
    tables dual_timing / missing;
    title "First Dual ICI: At Index vs. After Index (Patient-Level)";
run;

proc freq data=first_dual_detail;
    tables dual_regimen / missing;
    title "First Dual ICI Regimen (Patient-Level)";
run;

proc freq data=first_dual_detail;
    tables dual_timing * dual_regimen / missing norow nocol;
    title "Dual ICI Regimen by Timing";
run;


/*-------------------------------------------------------------*/
/* 6. Cumulative window counts (for chart)                     */
/*-------------------------------------------------------------*/
proc sql;
    select 'At index (Day 0)' as Window length=50,
           sum(days_to_dual = 0) as n_cumulative,
           sum(days_to_dual = 0) / count(*) * 100 as pct_of_dual format=5.1
    from first_dual
    union all
    select 'Within 42 days (2 cycles)',
           sum(days_to_dual <= 42),
           sum(days_to_dual <= 42) / count(*) * 100
    from first_dual
    union all
    select 'Within 84 days (4 cycles, full induction)',
           sum(days_to_dual <= 84),
           sum(days_to_dual <= 84) / count(*) * 100
    from first_dual
    union all
    select 'Ever during follow-up',
           count(*),
           100
    from first_dual;
quit;

/* As % of total ICI-exposed */
proc sql;
    select 'At index (Day 0)' as Window length=50,
           sum(days_to_dual = 0) as n_cumulative,
           sum(days_to_dual = 0) / (select count(distinct patient_id) from mult_ici) * 100 
               as pct_of_all_ici format=5.1
    from first_dual
    union all
    select 'Within 42 days (2 cycles)',
           sum(days_to_dual <= 42),
           sum(days_to_dual <= 42) / (select count(distinct patient_id) from mult_ici) * 100
    from first_dual
    union all
    select 'Within 84 days (4 cycles, full induction)',
           sum(days_to_dual <= 84),
           sum(days_to_dual <= 84) / (select count(distinct patient_id) from mult_ici) * 100
    from first_dual
    union all
    select 'Ever during follow-up',
           count(*),
           count(*) / (select count(distinct patient_id) from mult_ici) * 100
    from first_dual;
quit;
/*-------------------------------------------------------------*/
/* 7. Histogram: days to first dual among post-index starters  */
/*-------------------------------------------------------------*/
ods graphics on;

proc univariate data=first_dual_detail noprint;
    where days_to_dual > 0;
    var days_to_dual;
    histogram days_to_dual / midpoints=0 to 1400 by 42;
    title "Days from ICI Index to First Dual ICI (Post-Index, 42-Day Bins)";
run;

ods graphics off;


/*-------------------------------------------------------------*/
/* 8. Investigate non-standard regimens                        */
/*-------------------------------------------------------------*/
proc print data=first_dual_detail;
    where dual_regimen not in ('IPILIMUMAB + NIVOLUMAB');
    var patient_id first_ici_date first_dual_date days_to_dual dual_regimen dual_timing;
    title "Non-Standard Dual ICI Regimens — Potential Coding Errors";
run;

proc sql;
    select dual_regimen,
           count(distinct patient_id) as n_patients
    from first_dual_detail
    where dual_regimen not in ('IPILIMUMAB + NIVOLUMAB')
    group by dual_regimen;
quit;


/*-------------------------------------------------------------*/
/* 9. Optional: Add diagnosis date for time from dx to dual    */
/*    Uncomment and replace dx_date with your variable name    */
/*-------------------------------------------------------------*/
/*
proc sql;
    create table first_dual_dx as
    select a.*,
           b.dx_date format=date9.,
           a.first_dual_date - b.dx_date as days_dx_to_dual
    from first_dual_detail a
    left join seer.skin_melanoma_analysis_12m b
        on a.patient_id = b.patient_id;
quit;

proc means data=first_dual_dx n mean std median q1 q3 min max;
    var days_dx_to_dual days_to_dual;
    title "Time to First Dual ICI: From Diagnosis and From ICI Index";
run;
*/


/*save dataset*/

/*-------------------------------------------------------------*/
/* Sensitivity dataset: patient-level dual ICI classification   */
/*-------------------------------------------------------------*/
data seer.sensitivity_dual_regimen;
    set first_dual_detail;

    length window $50;

    if days_to_dual = 0 then window = '1. At index (Day 0)';
    else if days_to_dual <= 42 then window = '2. Within 42 days (2 cycles)';
    else if days_to_dual <= 84 then window = '3. Within 84 days (4 cycles)';
    else window = '4. Beyond induction';

    keep patient_id dual_regimen window first_ici_date first_dual_date days_to_dual dual_timing;
    format first_ici_date first_dual_date date9.;
run;

/* QC */
proc freq data=seer.sensitivity_dual_regimen;
    tables window dual_regimen dual_timing / missing;
    title "Sensitivity Dual Regimen: Window and Regimen Breakdown";
run;

proc means data=seer.sensitivity_dual_regimen n mean median min max;
    class window;
    var days_to_dual;
    title "Days to Dual by Window";
run;

proc sql;
    select count(distinct patient_id) as n_patients
    from seer.sensitivity_dual_regimen;
quit;
