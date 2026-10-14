*******************************************************************************;
* Program name      :	07_seer_Table 1_characteristics
* Author            :	Xinyi Sun
* Date created      :	Jan 1 2025
* Study             : 	
* Purpose           :	Describe baseline characteristics for two groups(Met vs Non-Met) in the final cohort
* Inputs            :	
* Program completed : 	
* Updated by        :  
*********************************************************************************;
LIBNAME seer 'S:\Pharmacoepi0216\Thesis';
LIBNAME thesis 'S:\Pharmacoepi0216\Thesis_new';

proc print data = thesis.cohort_MET_SULFDPP4 (obs=5);
run; 
proc print data = thesis.cohort (obs=5);
run; 

/**************** Updated Jan 15:Final cohort: 1486  *******************/

proc sql;
    create table thesis.cohort as
    select 
        a.*,               
        b.MET_1px,
        b.MET_90d,         
        b.MET_180d,
        b.SULF_1px,
		b.DPP4_1px
    from 
        thesis.cohort as a
    inner join 
        thesis.cohort_met_nonmet_3defs as b
    on 
        a.patient_id = b.patient_id; /* Match records by patient_id */
quit;
Proc freq data = thesis.cohort;
tables MET_1px MET_90d MET_180d;
run; /* 1486 = 1124 + 362 */
data thesis.cohort;
    set thesis.cohort;  
    /* Calculate Age_at_ICI */
    Age_at_ICI = input(substr(ICI_index, 1, 4), 8.) - input(Year_of_Birth, 8.);
run;
/* Continuous vars */
proc means data = thesis.cohort n mean std p25 p50 p75 min max; 
		class MET_1px; 
		var Age_at_ICI NCI_index days_dx_to_tx; 
		run;


/* Not needed: Categorical vars */
 proc sql;
    create table thesis.cohort as
    select 
        a.*,               
        b.prior_tx,         
        b.prior_tx1,
        b.index_regimen 
    from 
        thesis.cohort as a
    inner join 
        seer.LUNG_EXP_MOLECULES as b
    on 
        a.patient_id = b.patient_id; /* Match records by patient_id */
quit;
/* Not needed: Categorize 10-year age groups */
data thesis.cohort;
    set thesis.cohort; 
    
    if Age_at_ICI >= 66 and Age_at_ICI <= 75 then Age_Group = "66-75";
    else if Age_at_ICI >= 76 and Age_at_ICI <= 85 then Age_Group = "76-85";
    else if Age_at_ICI >= 86 and Age_at_ICI <= 96 then Age_Group = "86-96";
    else Age_Group = "Unknown"; /* For values outside the expected range */
run;
/* Categorize race ethnicity */
proc freq data = thesis.cohort;
tables Met_1px*RACEANDORIGINRECODENHWNHBNHAIAN;
run;
proc format;
    value $Race
        '1' = "Non-Hispanic White"
        '2' = "Non-Hispanic Black"
        '5' = "Hispanic"
        '4' = "Other";
run;
data thesis.cohort;
    set thesis.cohort; 
    if RACEANDORIGINRECODENHWNHBNHAIAN in ('1', '2', '5') then do;
        Race = RACEANDORIGINRECODENHWNHBNHAIAN;
    end;
    else Race = '4';
  /* Apply the new format */
    format Race $Race.;
run;

proc freq data = thesis.cohort;
tables Met_1px*Race;
run;


/* Not needed: merge binary surgery, radiation, chemo indicators */
proc freq data = seer.LUNG_EXP_MOLECULES;
tables surgery_binary radiation_binary chemo ICI_name;
run;
proc sql;
    create table thesis.cohort as
    select 
        a.*,               
        b.surgery_binary,         
        b.radiation_binary,
        b.chemo 
    from 
        thesis.cohort as a
    inner join 
        seer.LUNG_EXP_MOLECULES as b
    on 
        a.patient_id = b.patient_id; /* Match records by patient_id */
quit;
proc freq data = thesis.cohort;
tables (MET_1px)*(surgery_binary radiation_binary chemo);
run;
/* Not needed: Categorize surgery_binary radiation_binary as 3 categories, no, yes, and missing? create dummy vars */
data thesis.cohort; 
    set thesis.cohort; 
    /* Create dummy vars */
    surg_yes = (surgery_binary = 1); 
    surg_missing = (missing(surgery_binary)); 
   
    rad_yes = (radiation_binary = 1); 
    rad_missing = (missing(radiation_binary));
run;
proc freq data = thesis.cohort;
tables (MET_1px)*(surg_yes surg_missing rad_yes rad_missing);
run;

/* Update Jan 15: Merge chemo and ICI molecule name */
proc sql;
    create table thesis.cohort as
    select 
        a.*,
        b.chemo,
        b.ICI_name
    from 
        thesis.cohort as a
    inner join 
        seer.LUNG_EXP_MOLECULES as b
    on 
        a.patient_id = b.patient_id; /* Match records by patient_id */
quit;
/* Categorize ICI_target */
data thesis.cohort; 
    set thesis.cohort;

    length ICI_target $20; /* Define length of the new variable ICI_target */

    if ICI_name in ("ATEZOLIZUMAB", "DURVALUMAB") then ICI_target = "PDL1";
    else if ICI_name in ("NIVOLUMAB", "PEMBROLIZUMAB") then ICI_target = "PD1";
    else if ICI_name = "IPILIMUMAB" then ICI_target = "CTLA4";
    else ICI_target = "UNKNOWN"; 
run;

/* Categorize urban-rural status binary: 01-03 as 0 (Metro), 04-09 as 1 (NonMetro) */
proc freq data = thesis.cohort;
tables Met_1px *rural_urban_continuum_code_2013;
run;

data thesis.cohort;
    set thesis.cohort;
    if rural_urban_continuum_code_2013 in ('01', '02', '03') then urbanrural_binary = 0;
    else if rural_urban_continuum_code_2013 in ('04', '05', '06', '07', '08', '09') then urbanrural_binary = 1;
run;


/* Categorical vars descriptive stats */
proc freq data = thesis.cohort;
/* tables (MET_1px)*(SEX Race year_of_diagnosis urbanrural_binary medianhouseholdincomeinflationa);*/
/* tables (MET_1px)* (COMBINED_SUMMARY_STAGE_2004 primary_site SEQUENCE_NUMBER LATERALITY firstline ICI_target ICI_name);*/
run;
/* Exclude 1 stage in situ */
data thesis.cohort;
    set thesis.cohort;
    where stage ne 'In situ'; 
run; /* 1485 */
/* Rerun descriptive stats*/
/* Continuous vars descriptive stats */
proc means data = thesis.cohort n mean std p25 p50 p75 min max; 
		class MET_1px; 
		var Age_at_ICI NCI_index days_dx_to_tx chemo_count chemocount1; /*chemocount is in table1*/
		run;
proc freq data = thesis.cohort;
/* tables (MET_1px)*(SEX Race year_of_diagnosis urbanrural_binary);*/ 
/* tables (MET_1px)* (COMBINED_SUMMARY_STAGE_2004 chemo firstline ICI_target ICI_name);*/ /*primary_site SEQUENCE_NUMBER LATERALITY*/
run;
/* No longer needed: Drug use descriptive */
proc freq data = thesis.cohort_met_nonmet;
tables MET_1px * (AGLT_1px DPP4_1px SGLT_1px SULF_1px MEGL_1px TZDS_1px INSU_1px GLP1_1px AMYL_1px); 

/*tables MET_1px * theraclass_ct;*/
run;
proc freq data=thesis.cohort_met_nonmet order=freq;
    tables thera_pattern;
    where MET_1px = 0 and theraclass_ct = 1;
run;
proc freq data=thesis.cohort_met_nonmet order=freq;
    tables thera_pattern;
    where MET_1px = 1 and theraclass_ct = 2;
run;
proc freq data=thesis.cohort_met_nonmet order=freq;
    tables thera_pattern;
    where MET_1px = 0 and theraclass_ct = 2;
run;
proc freq data=thesis.cohort_met_nonmet order=freq;
    tables thera_pattern;
    where MET_1px = 1 and theraclass_ct = 3;
run;
proc freq data=thesis.cohort_met_nonmet order=freq;
    tables thera_pattern;
    where MET_1px = 0 and theraclass_ct = 3;
run;
