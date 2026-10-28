/**************************************************************************************
 * Progname: 01_import.sas
 * Purpose: Import the extraction workbook and standardize exported variable names
 * Date: 2024-12-19
 * Author: Lijuan Zeng
 * Notes:
 ***************************************************************************************/
%include "S:/lzeng3/ALA_SRMA/prog/00_utility.sas";
    
* Set up the environment;
options nocenter nonumber; /*nodate*/
%global progname;
%let progname=%str(01_import);

************************************************************************************************
** input data
************************************************************************************************;
/* 
*Set the encoding for the SAS session to UTF-8;
options encoding="utf-8";
*/

* Get the xlsx file name from the data folder;
filename xlsxlist pipe 'dir /b "S:\lzeng3\ALA_SRMA\indata\*.xlsx"';

%global xlsxfile;
data _null_;
    infile xlsxlist;
    input;
    xlsxfile = _infile_;
    call symputx('xlsxfile', xlsxfile);
run;

%put &xlsxfile; 


* Macro to import a specific sheet from the xlsx file;
%macro import_sheet(sheetname, outname);
    proc import datafile="S:\lzeng3\ALA_SRMA\indata\&xlsxfile"
        out=&outname
        dbms=xlsx
        replace;
        sheet="&sheetname";
    run;
%mend import_sheet;

* Import the "Arms" sheet into the "arms" dataset;
%import_sheet(Arms, arms);
%import_sheet(Outcomes, outcomes);
%import_sheet(%str(Arm Details), arm_details);
%import_sheet(%str(Sample Characteristics), sample_cha);
%import_sheet(%str(Outcome Details), outcome_details);
%import_sheet(%str(Design Details), design_details);
%import_sheet(%str(Risk of Bias - RCTs), rob_rct);
%import_sheet(%str(Categorical - Desc. Statistics), cat_stat);
%import_sheet(%str(Continuous - Desc. Statistics), con_stat);
%import_sheet(%str(Categorical - BAC Comparisons), cat_comp);
%import_sheet(%str(Continuous - BAC Comparisons), con_comp);
%import_sheet(%str(WAC Comparisons), wac_comp);
%import_sheet(%str(NET Differences), net_diff);


/*
* The ROB of Non-RCT ones are not imported yet;
%import_sheet(%str(Risk of Bias -...linical Trials), rob_nrct);
*/

************************************************************************************************
** output data
************************************************************************************************;

************************************************************************************************
*** ARMS ***;
proc sort data = arms out=outdata.arms;
	by extraction_id;
run;

ods rtf file="&outdir.&progname._arms.rtf" ;
footnote "Outputs generated from &progname..sas";
title "Arms";
proc contents data = outdata.arms varnum;
run;
title;
ods rtf close;

*** ARM DETAILS ***;
data arm_details_x;
	set arm_details;
	rename VAR14 = dose
	VAR15 = dose_unit
	What_was_the_DOSE____Was_there_a = dose_adjust
	What_was_the_DOSE____Was_there_1 = dose_adjust_desc
	What_was_the_DOSE____Was_there_d = dose_titrate
	What_was_the_DOSE____Was_there_2 = dose_titrate_desc
	What_was_the_DOSE____Not_reporte = does_nr
	What_was_the_DOSE____Not_report1 = does_nr_desc
	What_was_the_ROUTE_OF_ADMINISTRA = route_admin
	VAR23 = frequency
	What_was_the_DURATION____Amount = duration
	VAR25 = duration_desc
	Did_participants_receive_any_OTH = other_drugs
	What_COINTERVENTIONS_did_partici = cointerventions
	;
run;

proc sort data = arm_details_x out=outdata.arm_details;
	by extraction_id;
run;

ods rtf file="&outdir.&progname._arm_details.rtf" ;
footnote "Outputs generated from &progname..sas";
title "Arm Details";
proc contents data = outdata.arm_details varnum;
run;
title "Freq - arms";
proc freq data= outdata.arm_details;
   tables arms_name  / list missing nopercent nocum;
run;
title "Freq - arms by description";
proc freq data= outdata.arm_details;
   tables arms_name * arms_description / list missing nocum nopercent;
run;
ods rtf close;


************************************************************************************************
*** SAMPLE CHARACTERISTICS ***;
data sample_cha_x;
	set sample_cha;
	rename  Key_Questions = kq
What_was_the_SAMPLE_SIZE_AT_BASE = sc_sample_size
What_was_the_AGE_DISTRIBUTION_of = sc_age_mean
What_was_the_AGE_DISTRIBUTION_o1 = sc_age_sd
What_was_the_AGE_DISTRIBUTION_o2 = sc_age_se
What_was_the_AGE_DISTRIBUTION_o3 = sc_age_95ci
What_was_the_AGE_DISTRIBUTION_o4 = sc_age_median
What_was_the_AGE_DISTRIBUTION_o5 = sc_age_iqr
What_was_the_AGE_DISTRIBUTION_o6 = sc_age_range
What_was_the_AGE_DISTRIBUTION_o7 = sc_age_cont_nodata
What_was_the_AGE_DISTRIBUTION_o8 = sc_age_cat1_def
What_was_the_AGE_DISTRIBUTION_o9 = sc_age_cat1_n
What_was_the_AGE_DISTRIBUTION_10 = sc_age_cat1_perc
What_was_the_AGE_DISTRIBUTION_11 = sc_age_cat2_def
What_was_the_AGE_DISTRIBUTION_12 = sc_age_cat2_n
What_was_the_AGE_DISTRIBUTION_13 = sc_age_cat2_perc
What_was_the_AGE_DISTRIBUTION_14 = sc_age_cat3_def
What_was_the_AGE_DISTRIBUTION_15 = sc_age_cat3_n
What_was_the_AGE_DISTRIBUTION_16 = sc_age_cat3_perc
What_was_the_AGE_DISTRIBUTION_17 = sc_age_cat4_def
What_was_the_AGE_DISTRIBUTION_18 = sc_age_cat4_n
What_was_the_AGE_DISTRIBUTION_19 = sc_age_cat4_perc
What_was_the_AGE_DISTRIBUTION_20 = sc_age_cat5_def
What_was_the_AGE_DISTRIBUTION_21 = sc_age_cat5_n
What_was_the_AGE_DISTRIBUTION_22 = sc_age_cat5_perc
What_was_the_AGE_DISTRIBUTION_23 = sc_age_cat6_def
What_was_the_AGE_DISTRIBUTION_24 = sc_age_cat6_n
What_was_the_AGE_DISTRIBUTION_25 = sc_age_cat6_perc
What_was_the_AGE_DISTRIBUTION_26 = sc_age_nr_def
What_was_the_AGE_DISTRIBUTION_27 = sc_age_nr_n
What_was_the_AGE_DISTRIBUTION_28 = sc_age_nr_perc
What_was_the_AGE_DISTRIBUTION_29 = sc_age_nd_def
What_was_the_AGE_DISTRIBUTION_30 = sc_age_nd_n
What_was_the_AGE_DISTRIBUTION_31 = sc_age_nd_perc

What_was_the_SEX_DISTRIBUTION_of = sc_sex_male_n
What_was_the_SEX_DISTRIBUTION_o1 = sc_sex_male_perc
What_was_the_SEX_DISTRIBUTION_o2 = sc_sex_female_n
What_was_the_SEX_DISTRIBUTION_o3 = sc_sex_female_perc
What_was_the_SEX_DISTRIBUTION_o4 = sc_sex_nr_n
What_was_the_SEX_DISTRIBUTION_o5 = sc_sex_nr_perc
What_was_the_SEX_DISTRIBUTION_o6 = sc_sex_nd_n
What_was_the_SEX_DISTRIBUTION_o7 = sc_sex_nd_perc

What_was_the_BMI_DISTRIBUTION_of = sc_bmi_mean
What_was_the_BMI_DISTRIBUTION_o1 = sc_bmi_sd
What_was_the_BMI_DISTRIBUTION_o2 = sc_bmi_se
What_was_the_BMI_DISTRIBUTION_o3 = sc_bmi_95ci
What_was_the_BMI_DISTRIBUTION_o4 = sc_bmi_median
What_was_the_BMI_DISTRIBUTION_o5 = sc_bmi_iqr
What_was_the_BMI_DISTRIBUTION_o6 = sc_bmi_range
What_was_the_BMI_DISTRIBUTION_o7 = sc_bmi_cont_nodata
What_was_the_BMI_DISTRIBUTION_o8 = sc_bmi_cat1_def
What_was_the_BMI_DISTRIBUTION_o9 = sc_bmi_cat1_n
What_was_the_BMI_DISTRIBUTION_10 = sc_bmi_cat1_perc
What_was_the_BMI_DISTRIBUTION_11 = sc_bmi_cat2_def
What_was_the_BMI_DISTRIBUTION_12 = sc_bmi_cat2_n
What_was_the_BMI_DISTRIBUTION_13 = sc_bmi_cat2_perc
What_was_the_BMI_DISTRIBUTION_14 = sc_bmi_cat3_def
What_was_the_BMI_DISTRIBUTION_15 = sc_bmi_cat3_n
What_was_the_BMI_DISTRIBUTION_16 = sc_bmi_cat3_perc
What_was_the_BMI_DISTRIBUTION_17 = sc_bmi_cat4_def
What_was_the_BMI_DISTRIBUTION_18 = sc_bmi_cat4_n
What_was_the_BMI_DISTRIBUTION_19 = sc_bmi_cat4_perc
What_was_the_BMI_DISTRIBUTION_20 = sc_bmi_cat5_def
What_was_the_BMI_DISTRIBUTION_21 = sc_bmi_cat5_n
What_was_the_BMI_DISTRIBUTION_22 = sc_bmi_cat5_perc
What_was_the_BMI_DISTRIBUTION_23 = sc_bmi_cat6_def
What_was_the_BMI_DISTRIBUTION_24 = sc_bmi_cat6_n
What_was_the_BMI_DISTRIBUTION_25 = sc_bmi_cat6_perc
What_was_the_BMI_DISTRIBUTION_26 = sc_bmi_nr_def
What_was_the_BMI_DISTRIBUTION_27 = sc_bmi_nr_n
What_was_the_BMI_DISTRIBUTION_28 = sc_bmi_nr_perc
What_was_the_BMI_DISTRIBUTION_29 = sc_bmi_nd_def
What_was_the_BMI_DISTRIBUTION_30 = sc_bmi_nd_n
What_was_the_BMI_DISTRIBUTION_31 = sc_bmi_nd_perc

What_was_the_RACE_DISTRIBUTION_o = sc_race_white_def
What_was_the_RACE_DISTRIBUTION_1 = sc_race_white_n
What_was_the_RACE_DISTRIBUTION_2 = sc_race_white_perc
What_was_the_RACE_DISTRIBUTION_3 = sc_race_black_def
What_was_the_RACE_DISTRIBUTION_4 = sc_race_black_n
What_was_the_RACE_DISTRIBUTION_5 = sc_race_black_perc
What_was_the_RACE_DISTRIBUTION_6 = sc_race_asian_def
What_was_the_RACE_DISTRIBUTION_7 = sc_race_asian_n
What_was_the_RACE_DISTRIBUTION_8 = sc_race_asian_perc
What_was_the_RACE_DISTRIBUTION_9 = sc_race_aian_def
What_was_the_RACE_DISTRIBUTION10 = sc_race_aian_n
What_was_the_RACE_DISTRIBUTION11 = sc_race_aian_perc
What_was_the_RACE_DISTRIBUTION12 = sc_race_hawai_def
What_was_the_RACE_DISTRIBUTION13 = sc_race_hawai_n
What_was_the_RACE_DISTRIBUTION14 = sc_race_hawai_perc
What_was_the_RACE_DISTRIBUTION15 = sc_race_nlist1_def
What_was_the_RACE_DISTRIBUTION16 = sc_race_nlist1_n
What_was_the_RACE_DISTRIBUTION17 = sc_race_nlist1_perc
What_was_the_RACE_DISTRIBUTION18 = sc_race_nlist2_def
What_was_the_RACE_DISTRIBUTION19 = sc_race_nlist2_n
What_was_the_RACE_DISTRIBUTION20 = sc_race_nlist2_perc
What_was_the_RACE_DISTRIBUTION21 = sc_race_nr_def
What_was_the_RACE_DISTRIBUTION22 = sc_race_nr_n
What_was_the_RACE_DISTRIBUTION23 = sc_race_nr_perc
What_was_the_RACE_DISTRIBUTION24 = sc_race_nd_def
What_was_the_RACE_DISTRIBUTION25 = sc_race_nd_n
What_was_the_RACE_DISTRIBUTION26 = sc_race_nd_perc

What_was_the_ETHNIC_DISTRIBUTION = sc_ethic_hispanic_n
What_was_the_ETHNIC_DISTRIBUTIO1 = sc_ethic_hispanic_perc
What_was_the_ETHNIC_DISTRIBUTIO2 = sc_ethic_nhispanic_n
What_was_the_ETHNIC_DISTRIBUTIO3 = sc_ethic_nhispanic_perc
What_was_the_ETHNIC_DISTRIBUTIO4 = sc_ethic_nr_n
What_was_the_ETHNIC_DISTRIBUTIO5 = sc_ethic_nr_perc
What_was_the_ETHNIC_DISTRIBUTIO6 = sc_ethic_nd_n
What_was_the_ETHNIC_DISTRIBUTIO7 = sc_ethic_nd_perc

What_was_the_HISTORY_PRESENCE_OF = sc_hist_asthma_n
What_was_the_HISTORY_PRESENCE_O1 = sc_hist_asthma_perc
What_was_the_HISTORY_PRESENCE_O2 = sc_hist_copd_n
What_was_the_HISTORY_PRESENCE_O3 = sc_hist_copd_perc
What_was_the_HISTORY_PRESENCE_O4 = sc_hist_bronchitis_n
What_was_the_HISTORY_PRESENCE_O5 = sc_hist_bronchitis_perc
What_was_the_HISTORY_PRESENCE_O6 = sc_hist_pharyngitis_n
What_was_the_HISTORY_PRESENCE_O7 = sc_hist_pharyngitis_perc
What_was_the_HISTORY_PRESENCE_O8 = sc_hist_ochronic_n
What_was_the_HISTORY_PRESENCE_O9 = sc_hist_ochronic_perc
What_was_the_HISTORY_PRESENCE_10 = sc_hist_osa_n
What_was_the_HISTORY_PRESENCE_11 = sc_hist_osa_perc
What_was_the_HISTORY_PRESENCE_12 = sc_hist_other_n
What_was_the_HISTORY_PRESENCE_13 = sc_hist_other_perc
What_was_the_HISTORY_PRESENCE_14 = sc_hist_nd_n
What_was_the_HISTORY_PRESENCE_15 = sc_hist_nd_perc

What_was_were_the_INDICATIONS_fo = sc_ind_diabetes_n
What_was_were_the_INDICATIONS_f1 = sc_ind_diabetes_perc
What_was_were_the_INDICATIONS_f2 = sc_ind_diabetes_def
What_was_were_the_INDICATIONS_f3 = sc_ind_weight_n
What_was_were_the_INDICATIONS_f4 = sc_ind_weight_perc
What_was_were_the_INDICATIONS_f5 = sc_ind_weight_def
What_was_were_the_INDICATIONS_f6 = sc_ind_epilepsy_n
What_was_were_the_INDICATIONS_f7 = sc_ind_epilepsy_perc
What_was_were_the_INDICATIONS_f8 = sc_ind_epilepsy_def
What_was_were_the_INDICATIONS_f9 = sc_ind_migraine_n
What_was_were_the_INDICATIONS_10 = sc_ind_migraine_perc
What_was_were_the_INDICATIONS_11 = sc_ind_migraine_def
What_was_were_the_INDICATIONS_12 = sc_ind_substance_n
What_was_were_the_INDICATIONS_13 = sc_ind_substance_perc
What_was_were_the_INDICATIONS_14 = sc_ind_substance_def
What_was_were_the_INDICATIONS_15 = sc_ind_depression_n
What_was_were_the_INDICATIONS_16 = sc_ind_depression_perc
What_was_were_the_INDICATIONS_17 = sc_ind_depression_def
What_was_were_the_INDICATIONS_18 = sc_ind_cvd_n
What_was_were_the_INDICATIONS_19 = sc_ind_cvd_perc
What_was_were_the_INDICATIONS_20 = sc_ind_cvd_def
What_was_were_the_INDICATIONS_21 = sc_ind_other1_n
What_was_were_the_INDICATIONS_22 = sc_ind_other1_perc
What_was_were_the_INDICATIONS_23 = sc_ind_other1_def
What_was_were_the_INDICATIONS_24 = sc_ind_other2_n
What_was_were_the_INDICATIONS_25 = sc_ind_other2_perc
What_was_were_the_INDICATIONS_26 = sc_ind_other2_def
What_was_were_the_INDICATIONS_27 = sc_ind_nr_n
What_was_were_the_INDICATIONS_28 = sc_ind_nr_perc
What_was_were_the_INDICATIONS_29 = sc_ind_nr_def
What_was_were_the_INDICATIONS_30 = sc_ind_nd_n
What_was_were_the_INDICATIONS_31 = sc_ind_nd_perc
What_was_were_the_INDICATIONS_32 = sc_ind_nd_def

What_was_the_SEVERITY_of_disease = sc_sev_hosp_n
What_was_the_SEVERITY_of_diseas1 = sc_sev_hosp_perc
What_was_the_SEVERITY_of_diseas2 = sc_sev_nhosp_n
What_was_the_SEVERITY_of_diseas3 = sc_sev_nhosp_perc
What_was_the_SEVERITY_of_diseas4 = sc_sev_nr_n
What_was_the_SEVERITY_of_diseas5 = sc_sev_nr_perc
What_was_the_SEVERITY_of_diseas6 = sc_sev_nd_n
What_was_the_SEVERITY_of_diseas7 = sc_sev_nd_perc
;
run;

proc sort data=sample_cha_x out=outdata.sample_cha;
	by extraction_id arms_name;
run;

ods rtf file="&outdir.&progname._sample_cha.rtf" ;
footnote "Outputs generated from &progname..sas";
title "Sample characteristics";
proc contents data=outdata.sample_cha  varnum;
run;
title;
ods rtf close;


************************************************************************************************
*** OUTCOMES ***;
** Outcomes;
proc sort data = outcomes out=outdata.outcomes;
	by extraction_id;
run;

** Outcome details;
data outcome_details_x;
	set outcome_Details;
	rename  Key_Questions = kq
			outcomes_name = outcome_cat
			outcomes_unit = outcome_term
			What_SOURCE_S__did_you_use_for_e = outcome_source
			Was_the_outcome_reported_as_a_se = outcome_SAE
	;
run;
proc sort data = outcome_details_x out=outcome_details_x_nd dupout=_check_outcomedups nodupkey;
	by extraction_id  outcome_term outcome_SAE;
run;
proc sort data = outcome_details_x out=outdata.outcome_details dupout=checkups_outcomes nodupkey;
	by extraction_id outcome_cat outcome_term outcome_SAE;
run;
/*
data checkups_outcomes2; set checkups_outcomes; flag=1; run;
proc sort data = checkups_outcomes2; by extraction_id outcome_Term; run;
data _check;
	merge _check_outcomedups (in=A)
			checkups_outcomes2 (in=B);
	by extraction_id outcome_term;
	if A ne B then put "WARNING: " extraction_id= outcome_Term = /;
run;
*/

* print out freq of outcomes;
proc sort data = outdata.outcome_details out = outcomes_list_X;
	by outcome_cat outcome_term;
run;
ods rtf file="&outdir.&progname._outcomes_list.rtf" ;
footnote "Outputs generated from &progname..sas";
title "outcomes list ";
proc sort data = outcomes_list_X nodupkey;
	by outcome_cat outcome_term;
run;

proc contents data=outcomes_list_X varnum; run;

ods rtf close;

proc freq data= outcomes_list_X ;
   tables outcome_cat *  outcome_term
   / list missing;
run;


************************************************************************************************
*** Design details ***;
data design_details_x;
	set design_details;
	rename  Key_Questions = kq
			Is_there_a_reason_why_the_study = design_not_elig
			var13 = design_not_elig_reas
			Do_we_have_a_full_text_journal_a = design_fulltext
			What_was_the_ACTUAL_STUDY_DESIGN = design_actual
			What_was_the_STUDY_DESIGN_FOR_OU = design_analysis
			If_this_is_a_pooled_analysis__is = design_pooled_new
			What_was_the_TEMPORALITY_of_the = design_temporality
			VAR19 = design_study_name
			Did_the_article_mention_cite_bei = design_secondary
			var21 = design_registered_yn
			var22 = design_study_years
			What_were_the_study_COUNTRY_COUN = design_country
			What_was_the_TOTAL_SAMPLE_SIZE_a = design_tot_samplesize
			var25 =design_funding
			What_was_the_SETTING_of_the_stud = design_setting
			What_was_the_LOCATION_of_the_stu = design_location
			How_were_harms_data_COLLECTED_in = design_how_harms_collect
			Were_SELECTION_CRITERIA_used_to = design_selection_crit
			For_AEs_for_which_selection_crit = design_crit_journal
			For_AEs_for_which_selection_cri1 = design_crit_ctgov
			For_AEs_for_which_selection_cri2 = design_crit_csr
			For_AEs_for_which_selection_cri3 = design_crit_other
			Do_you_have_any_NOTES_about_the = design_notes
;
run;

proc sort data = design_details_x out=outdata.design_details;
	by extraction_id;
run;

ods rtf file="&outdir.&progname._design_details.rtf" ;
footnote "Outputs generated from &progname..sas";
title "Design details ";
proc contents data=outdata.design_details varnum; run;

proc freq data= outdata.design_details;
   tables design_: 
   / list missing;
run;

ods rtf close;

************************************************************************************************
*** Risk of bias - RCT ***;
data rob_rct_x;
	set rob_rct;
	rename  Key_Questions = kq
	Random_sequence_generation__sele = rob_select_bias
	Random_sequence_generation__sel1 = rob_select_bias_text
	Allocation_concealment__selectio = rob_alloca_conc
	Allocation_concealment__selecti1 = rob_alloca_conc_text
	Blinding_of_participants_and_per = rob_perfor_bias
	Blinding_of_participants_and_pe1 = rob_perfor_bias_text
	Blinding_of_outcome_assessor__de = rob_detect_bias
	Blinding_of_outcome_assessor__d1 = rob_detect_bias_text
	Incomplete_outcome_data__attriti = rob_attrit_bias
	Incomplete_outcome_data__attrit1 = rob_attrit_bias_text
	Selective_Reporting__reporting_b = rob_report_bias
	Selective_Reporting__reporting_1 = rob_report_bias_text
	Other_Bias__Bias_due_to_problems = rob_other_bias
	Other_Bias__Bias_due_to_problem1 = rob_other_bias_text
;
run;
proc sort data = rob_rct_x out=outdata.rob_rct;
	by extraction_id;
run;

ods rtf file="&outdir.&progname._rob_rct.rtf" ;
footnote "Outputs generated from &progname..sas";
title "Risk of bias - RCT";
proc contents data=outdata.rob_rct varnum; run;
ods rtf close;


************************************************************************************************
*** Categorical statistics ***;
data cat_stat_x;
	set cat_Stat;

	rename  Key_Questions = kq
outcome = outcome_cat
description = outcome_term
description_1 = pop_text

arm_name_1 = arm1_name
arm_description_1 = arm1_text
Total__N_analyzed_ = arm1_total_n
Total_events = arm1_total_events
events = arm1_events
percentage = arm1_perc
Incidence_Rate__per_1000_patient = arm1_ir_1000pm
Incidence_Rate__per_100_ = arm1_ir_100
Incidence_Rate__per_1000_ = arm1_ir_1000
Number_of_people_with__1_episode = arm1_n_gt1episode
Incidence_Rate__per_100_exposure = arm1_ir_100expy
Incidence_Rate__per_100_yrs_ = arm1_ir_100py
VAR32 = arm1_ir_1py

arm_name_2 = arm2_name
arm_description_2 = arm2_text
Total__N_analyzed__1 = arm2_total_n
Total_events_1 = arm2_total_events
events_1 = arm2_events
percentage_1 = arm2_perc
Incidence_Rate__per_1000_patient = arm2_ir_1000pm
Incidence_Rate__per_100__1 = arm2_ir_100
Incidence_Rate__per_1000__1 = arm2_ir_1000
Number_of_people_with__1_episod1 = arm2_n_gt1episode
Incidence_Rate__per_100_exposur1 = arm2_ir_100expy
Incidence_Rate__per_100_yrs__1 = arm2_ir_100py
VAR45 = arm2_ir_1py

arm_name_3 = arm3_name
arm_description_3 = arm3_text
Total__N_analyzed__2 = arm3_total_n
Total_events_2 = arm3_total_events
events_2 = arm3_events
percentage_2 = arm3_perc
Incidence_Rate__per_1000_patien2 = arm3_ir_1000pm
Incidence_Rate__per_100__2 = arm3_ir_100
Incidence_Rate__per_1000__2 = arm3_ir_1000
Number_of_people_with__1_episod2 = arm3_n_gt1episode
Incidence_Rate__per_100_exposur2 = arm3_ir_100expy
Incidence_Rate__per_100_yrs__2 = arm3_ir_100py
VAR58 = arm3_ir_1py

arm_name_4 = arm4_name
arm_description_4 = arm4_text
Total__N_analyzed__3 = arm4_total_n
Total_events_3 = arm4_total_events
events_3 = arm4_events
percentage_3 = arm4_perc
Incidence_Rate__per_1000_patien3 = arm4_ir_1000pm
Incidence_Rate__per_100__3 = arm4_ir_100
Incidence_Rate__per_1000__3 = arm4_ir_1000
Number_of_people_with__1_episod3 = arm4_n_gt1episode
Incidence_Rate__per_100_exposur3 = arm4_ir_100expy
Incidence_Rate__per_100_yrs__3 = arm4_ir_100py
VAR71 = arm4_ir_1py

arm_name_5 = arm5_name
arm_description_5 = arm5_text
Total__N_analyzed__4 = arm5_total_n
Total_events_4 = arm5_total_events
events_4 = arm5_events
percentage_4 = arm5_perc
Incidence_Rate__per_1000_patien4 = arm5_ir_1000pm
Incidence_Rate__per_100__4 = arm5_ir_100
Incidence_Rate__per_1000__4 = arm5_ir_1000
Number_of_people_with__1_episod4 = arm5_n_gt1episode
Incidence_Rate__per_100_exposur4 = arm5_ir_100expy
Incidence_Rate__per_100_yrs__4 = arm5_ir_100py
VAR84 = arm5_ir_1py

arm_name_6 = arm6_name
arm_description_6 = arm6_text
Total__N_analyzed__5 = arm6_total_n
Total_events_5 = arm6_total_events
events_5 = arm6_events
percentage_5 = arm6_perc
Incidence_Rate__per_1000_patien5 = arm6_ir_1000pm
Incidence_Rate__per_100__5 = arm6_ir_100
Incidence_Rate__per_1000__5 = arm6_ir_1000
Number_of_people_with__1_episod5 = arm6_n_gt1episode	
Incidence_Rate__per_100_exposur5 = arm6_ir_100expy
Incidence_Rate__per_100_yrs__5 = arm6_ir_100py
VAR97 = arm6_ir_1py

arm_name_7 = arm7_name
arm_description_7 = arm7_text
Total__N_analyzed__6 = arm7_total_n
Total_events_6 = arm7_total_events
events_6 = arm7_events
percentage_6 = arm7_perc
Incidence_Rate__per_1000_patien6 = arm7_ir_1000pm
Incidence_Rate__per_100__6 = arm7_ir_100
Incidence_Rate__per_1000__6 = arm7_ir_1000
Number_of_people_with__1_episod6 = arm7_n_gt1episode
Incidence_Rate__per_100_exposur6 = arm7_ir_100expy
Incidence_Rate__per_100_yrs__6 = arm7_ir_100py
VAR110 = arm7_ir_1py

arm_name_8 = arm8_name
arm_description_8 = arm8_text
Total__N_analyzed__7 = arm8_total_n
Total_events_7 = arm8_total_events
events_7 = arm8_events
percentage_7 = arm8_perc
Incidence_Rate__per_1000_patien7 = arm8_ir_1000pm
Incidence_Rate__per_100__7 = arm8_ir_100
Incidence_Rate__per_1000__7 = arm8_ir_1000
Number_of_people_with__1_episod7 = arm8_n_gt1episode
Incidence_Rate__per_100_exposur7 = arm8_ir_100expy
Incidence_Rate__per_100_yrs__7 = arm8_ir_100py
VAR123 = arm8_ir_1py

arm_name_9 = arm9_name
arm_description_9 = arm9_text
Total__N_analyzed__8 = arm9_total_n
Total_events_8 = arm9_total_events
events_8 = arm9_events
percentage_8 = arm9_perc
Incidence_Rate__per_1000_patien8 = arm9_ir_1000pm
Incidence_Rate__per_100__8 = arm9_ir_100
Incidence_Rate__per_1000__8 = arm9_ir_1000
Number_of_people_with__1_episod8 = arm9_n_gt1episode
Incidence_Rate__per_100_exposur8 = arm9_ir_100expy
Incidence_Rate__per_100_yrs__8 = arm9_ir_100py
VAR136 = arm9_ir_1py

arm_name_10 = arm10_name
arm_description_10 = arm10_text
Total__N_analyzed__9 = arm10_total_n
Total_events_9 = arm10_total_events
events_9 = arm10_events
percentage_9 = arm10_perc
Incidence_Rate__per_1000_patien9 = arm10_ir_1000pm
Incidence_Rate__per_100__9 = arm10_ir_100
Incidence_Rate__per_1000__9 = arm10_ir_1000
Number_of_people_with__1_episod9 = arm10_n_gt1episode
Incidence_Rate__per_100_exposur9 = arm10_ir_100expy
Incidence_Rate__per_100_yrs__9 = arm10_ir_100py
VAR149 = arm10_ir_1py
;

run;

proc sort data = cat_stat_x out = outdata.cat_stat;
	by extraction_id;
run;

ods rtf file="&outdir.&progname._cat_stat.rtf" ;
footnote "Outputs generated from &progname..sas";
title "Categorical stats";
proc contents data = outdata.cat_stat  varnum;
run;
title;
ods rtf close;

************************************************************************************************
** Categorical comparison;
data cat_comp_x;
	set cat_comp;

	rename  Key_Questions = kq
outcome = outcome_cat
description = outcome_term
description_1 = pop_text

Comparison_Name_1 = comp1_name
Odds_Ratio__OR_ = comp1_or
VAR22 = comp1_or_95ci_low
VAR23 = comp1_or_95ci_high
p_value = comp1_pval
Risk_Difference__RD_ = comp1_rd
VAR26 = comp1_rd_95ci_low
VAR27 = comp1_rd_95ci_high
Risk_Ratio__RR_ = comp1_rr
VAR29 = comp1_rr_95ci_low
VAR30 = comp1_rr_95ci_high
VAR31 = comp1_adjrr
VAR32 = comp1_adjrr_95ci_low
VAR33 = comp1_adjrr_95ci_high

Comparison_Name_2 = comp2_name
Odds_Ratio__OR__1 = comp2_or
VAR36 = comp2_or_95ci_low
VAR37 = comp2_or_95ci_high
p_value_1 = comp2_pval
Risk_Difference__RD__1 = comp2_rd
VAR40 = comp2_rd_95ci_low
VAR41 = comp2_rd_95ci_high
Risk_Ratio__RR__1 = comp2_rr
VAR43 = comp2_rr_95ci_low
VAR44 = comp2_rr_95ci_high
VAR45 = comp2_adjrr
VAR46 = comp2_adjrr_95ci_low
VAR47 = comp2_adjrr_95ci_high
	;
run;

proc sort data = cat_comp_x out = outdata.cat_comp;
	by extraction_id;	
run;

ods rtf file="&outdir.&progname._cat_comp.rtf" ;
footnote "Outputs generated from &progname..sas";
title "Categorical comparison";
proc contents data = outdata.cat_comp  varnum;
run;
ods rtf close;



************************************************************************************************
** Continuous statistics;
** Note: only 1 study with up to 3 arms reported continuous results;
data con_stat_x;
	set con_stat;

	rename  Key_Questions = kq
outcome = outcome_cat
description = outcome_term
description_1 = pop_text

arm_name_1 = arm1_name
arm_description_1 = arm1_text
Total__N_analyzed_ = arm1_total_n
Mean = arm1_mean
SD = arm1_sd

arm_name_2 = arm2_name
arm_description_2 = arm2_text
Total__N_analyzed__1 = arm2_total_n
Mean_1 = arm2_mean
SD_1 = arm2_sd

arm_name_3 = arm3_name
arm_description_3 = arm3_text
Total__N_analyzed__2 = arm3_total_n
Mean_2 = arm3_mean
SD_2 = arm3_sd
	;
run;

proc sort data = con_stat_x out = outdata.con_stat;
	by extraction_id;
run;

ods rtf file="&outdir.&progname._con_stat.rtf" ;
footnote "Outputs generated from &progname..sas";
title "Continuous stats";
proc contents data = outdata.con_stat  varnum;
run;
ods rtf close;

************************************************************************************************
** Continuous comparison;
data con_comp_x;
	set con_comp;

	rename  Key_Questions = kq
outcome = outcome_cat
description = outcome_term
description_1 = pop_text

Comparison_Name_1 = comp1_name
p_value__MD_ = comp1_p_value
;
run;

proc sort data = con_comp_x out = outdata.con_comp;
	by extraction_id;
run;

ods rtf file="&outdir.&progname._con_comp.rtf" ;
footnote "Outputs generated from &progname..sas";
title "Continuous comparison";
proc contents data = outdata.con_comp  varnum;
run;
ods rtf close;

************************************************************************************************
** WAC comparison;
** Note: only 1 study (KQ2) with up to 3 arms reported continuous results;
data wac_comp_x;
	set wac_comp;

	rename  Key_Questions = kq
outcome = outcome_cat
description = outcome_term
description_1 = pop_text

WAC_Comparator = wac_comp
arm_name_1 = arm1_name
arm_description_1 = arm1_text
Odds_Ratio__OR_ = arm1_or
VAR22 = arm1_or_95ci_low
VAR23 = arm1_or_95ci_high
p_value__MD_ = arm1_p_value

arm_name_2 = arm2_name
arm_description_2 = arm2_text
Odds_Ratio__OR__1 = arm2_or
VAR28 = arm2_or_95ci_low
VAR29 = arm2_or_95ci_high
p_value__MD__1 = arm2_p_value

arm_name_3 = arm3_name
arm_description_3 = arm3_text
Odds_Ratio__OR__2 = arm3_or
VAR34 = arm3_or_95ci_low
VAR35 = arm3_or_95ci_high
p_value__MD__2 = arm3_p_value
	;
run;

proc sort data = wac_comp_x out = outdata.wac_comp;
	by extraction_id;
run;
ods rtf file="&outdir.&progname._wac_comp.rtf" ;
footnote "Outputs generated from &progname..sas";
title "WAC comparison";
proc contents data = outdata.wac_comp  varnum;
run;
ods rtf close;

************************************************************************************************
** NET differences;
data net_diff_x;
	set net_diff;

	rename  Key_Questions = kq
description = outcome_term
description_1 = pop_text

WAC_Comparator = wac_comp
Comparison_Name_1 = comp_name
p_value__NMD_ = p_value
	;
run;

proc sort data = net_diff_x out=outdata.net_diff;
	by extraction_id;
run;

ods rtf file="&outdir.&progname._net_diff.rtf" ;
footnote "Outputs generated from &progname..sas";
title "NET differences";
proc contents data = outdata.net_diff  varnum;
run;
ods rtf close;

