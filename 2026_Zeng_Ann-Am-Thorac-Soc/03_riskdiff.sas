/**************************************************************************************
 * Progname: 03_riskdiff.sas
 * Purpose: Create active-versus-placebo event-count datasets and descriptive risk differences
 * Date: 2025-03-30
 * Author: Lijuan Zeng
 * Notes: 
 ***************************************************************************************/
%include "S:/lzeng3/ALA_SRMA/prog/00_utility.sas";
    
* Set up the environment;
options nocenter nonumber; /*nodate*/
%global progname;
%let progname=%str(03_riskdiff);


************************************************************************************************
** Input data
************************************************************************************************;

proc sort data = outdata.kq1_inc_rct_results_l_arms_ndsty out=kq1_inc_Rct_results;
	by extraction_id study outcome_l1 outcome_l2 timec2_n timec2 drug_dose;
run;

************************************************************************************************;
** Transpose by drug-dose;
proc transpose data=kq1_inc_Rct_results    out=results_w_dose   prefix= p_;
   by extraction_id study outcome_l1 outcome_l2 timec2_n timec2;
   var perc;
   id drug_dose;
run;

************************************************************************************************;
** Transpose by drug total drug_group0;

* Approach 1: There are multiple drug_Group0 per study - so aggregate by study first to take the weighted averages percentages per study;
proc means data=kq1_inc_Rct_results    noprint nway missing;
   class extraction_id study outcome_l1 outcome_l2 timec2_n timec2 drug_group0;
   var perc;
   weight total_n;
   output out= results_l_weighted (drop= _TYPE_ _FREQ_) n=n  mean=weighted_perc;
run;
* Separate out placebo and active drug groups;
proc sort data = results_l_weighted (Where=(drug_group0 = "Placebo")) out=results_placebo (rename=(weighted_perc = perc_pbo) drop=n drug_group0);
	by  extraction_id study outcome_l1 outcome_l2 timec2_n timec2;
run;
proc sort data = results_l_weighted (Where=(drug_group0 ^= "Placebo")) out=results_drug (rename=(weighted_perc = perc_drug) drop=n);
	by  extraction_id study outcome_l1 outcome_l2 timec2_n timec2;
run;
* Merge drug and placebo to calculate risk differences;
data results_combined1	risk_diff1;
	merge 	results_drug (in=drug)
			results_placebo (in=pbo);
	by  extraction_id study outcome_l1 outcome_l2 timec2_n timec2;

	if pbo=1 and drug=0 then put "WARNING: no active? " extraction_id = study= /;

	if cmiss(perc_pbo, perc_drug)=0 then 
		risk_diff = round(perc_drug - perc_pbo, 0.1);

	if not missing(risk_diff) then output risk_diff1;
	output results_combined1;
run;


* Approach 2: sum the events and total_n by drug first then use the combined values for calculating proportion;
proc means data=kq1_inc_Rct_results    noprint nway missing;
   class extraction_id study outcome_l1 outcome_l2 timec2_n timec2 drug_group0;
   var total_n;
   output out= results_l_sum_total_n (drop= _TYPE_ _FREQ_) n=n  sum=total_n;
run;
proc means data=kq1_inc_Rct_results    noprint nway missing;
   class extraction_id study outcome_l1 outcome_l2 timec2_n timec2 drug_group0;
   var events;
   output out= results_l_sum_events (drop= _TYPE_ _FREQ_) n=n  sum=events;
run;

data results_l_sum;
	merge  	results_l_sum_events 
			results_l_sum_total_n (drop=n);
	by extraction_id study outcome_l1 outcome_l2 timec2_n timec2 drug_group0;

	label perc_a = "Percentages - calculated using the total events divided by total sample sizes (%)";
	perc_a= events/total_n * 100;
run; 
* Separate out placebo and active drug groups;
proc sort data = results_l_sum (Where=(drug_group0 = "Placebo")) out=results_sum_placebo (rename=(perc_a = perc_pbo events=events_pbo total_n=total_n_pbo n=n_pbo) drop= drug_group0);
	by  extraction_id study outcome_l1 outcome_l2 timec2_n timec2;
run;
proc sort data = results_l_sum (Where=(drug_group0 ^= "Placebo")) out=results_sum_drug (rename=(perc_a = perc_drug events=events_drug total_n=total_n_drug n=n_drug));
	by  extraction_id study outcome_l1 outcome_l2 timec2_n timec2;
run;
* Merge drug and placebo to calculate risk differences;
data results_combined2	risk_diff2;
	merge 	results_sum_placebo (in=drug)
			results_sum_drug (in=pbo);
	by  extraction_id study outcome_l1 outcome_l2 timec2_n timec2;

	if cmiss(perc_pbo, perc_drug)=0 then 
		risk_diff = round(perc_drug - perc_pbo, 0.1);

	if not missing(risk_diff) then output risk_diff2;
	output results_combined2;
run;

proc sort data=risk_diff1; 
	by extraction_id study outcome_l1 outcome_l2 timec2_n timec2 drug_group0;
run;
proc sort data=risk_diff2; 
	by extraction_id study outcome_l1 outcome_l2 timec2_n timec2 drug_group0;
run;
** Combine both approaches ;
data risk_diff	review_risk_Diff;
	merge 	risk_diff2
			risk_diff1 (rename=(perc_drug = perc_drug1 perc_pbo = perc_pbo1 risk_diff=risk_diff1));
	by extraction_id study outcome_l1 outcome_l2 timec2_n timec2 drug_group0;

	* check how different two approaches are;
	diff_2approaches = risk_diff - risk_diff1;
	if abs(diff_2approaches) > 0.1 then flag_risk_differ = 1;

	if flag_risk_differ = 1 then  output review_risk_Diff;

	output risk_diff;
run;


proc sort data = risk_diff out=outdata.risk_diff (label = "Risk difference drug total - placebo; Created from &progname.");
	by drug_group0 extraction_id study outcome_l1 outcome_l2 timec2_n timec2;
run;








************************************************************************************************;
** Transpose by drug total drug_group1;

* Approach 1: There are multiple drug_Group0 per study - so aggregate by study first to take the weighted averages percentages per study;
proc means data=kq1_inc_Rct_results    noprint nway missing;
   class extraction_id study outcome_l1 outcome_l2 timec2_n timec2 drug_group1;
   var perc;
   weight total_n;
   output out= results_l_weighted (drop= _TYPE_ _FREQ_) n=n  mean=weighted_perc;
run;
* Separate out placebo and active drug groups;
proc sort data = results_l_weighted (Where=(drug_group1 = "Placebo")) out=results_placebo (rename=(weighted_perc = perc_pbo) drop=n drug_group1);
	by  extraction_id study outcome_l1 outcome_l2 timec2_n timec2;
run;
proc sort data = results_l_weighted (Where=(drug_group1 ^= "Placebo")) out=results_drug (rename=(weighted_perc = perc_drug) drop=n);
	by  extraction_id study outcome_l1 outcome_l2 timec2_n timec2;
run;
* Merge drug and placebo to calculate risk differences;
data results_combined1	risk_diff1;
	merge 	results_drug (in=drug)
			results_placebo (in=pbo);
	by  extraction_id study outcome_l1 outcome_l2 timec2_n timec2;

	if pbo=1 and drug=0 then put "WARNING: no active? " extraction_id = study= /;
	if drug=1 and pbo=0 then put "NOTE: no placebo " extraction_id = study = /;
	if cmiss(perc_pbo, perc_drug)=0 then 
		risk_diff = round(perc_drug - perc_pbo, 0.1);

	if not missing(risk_diff) then output risk_diff1;
	output results_combined1;
run;


* Approach 2: sum the events and total_n by drug first then use the combined values for calculating proportion;
proc means data=kq1_inc_Rct_results    noprint nway missing;
   class extraction_id study outcome_l1 outcome_l2 timec2_n timec2 drug_group1;
   var total_n;
   output out= results_l_sum_total_n (drop= _TYPE_ _FREQ_) n=n  sum=total_n;
run;
proc means data=kq1_inc_Rct_results    noprint nway missing;
   class extraction_id study outcome_l1 outcome_l2 timec2_n timec2 drug_group1;
   var events;
   output out= results_l_sum_events (drop= _TYPE_ _FREQ_) n=n  sum=events;
run;

data results_l_sum;
	merge  	results_l_sum_events 
			results_l_sum_total_n (drop=n);
	by extraction_id study outcome_l1 outcome_l2 timec2_n timec2 drug_group1;

	label perc_a = "Percentages - calculated using the total events divided by total sample sizes (%)";
	perc_a= events/total_n * 100;
run; 
* Separate out placebo and active drug groups;
proc sort data = results_l_sum (Where=(drug_group1 = "Placebo")) out=results_sum_placebo (rename=(perc_a = perc_pbo events=events_pbo total_n=total_n_pbo n=n_pbo) drop= drug_group1);
	by  extraction_id study outcome_l1 outcome_l2 timec2_n timec2;
run;
proc sort data = results_l_sum (Where=(drug_group1 ^= "Placebo")) out=results_sum_drug (rename=(perc_a = perc_drug events=events_drug total_n=total_n_drug n=n_drug));
	by  extraction_id study outcome_l1 outcome_l2 timec2_n timec2;
run;
* Merge drug and placebo to calculate risk differences;
data results_combined2	risk_diff2;
	merge 	results_sum_placebo (in=drug)
			results_sum_drug (in=pbo);
	by  extraction_id study outcome_l1 outcome_l2 timec2_n timec2;

	if cmiss(perc_pbo, perc_drug)=0 then 
		risk_diff = round(perc_drug - perc_pbo, 0.1);

	if not missing(risk_diff) then output risk_diff2;
	output results_combined2;
run;

proc sort data=risk_diff1; 
	by extraction_id study outcome_l1 outcome_l2 timec2_n timec2 drug_group1;
run;
proc sort data=risk_diff2; 
	by extraction_id study outcome_l1 outcome_l2 timec2_n timec2 drug_group1;
run;
** Combine both approaches ;
data risk_diff	review_risk_Diff;
	merge 	risk_diff2
			risk_diff1 (rename=(perc_drug = perc_drug1 perc_pbo = perc_pbo1 risk_diff=risk_diff1));
	by extraction_id study outcome_l1 outcome_l2 timec2_n timec2 drug_group1;

	* check how different two approaches are;
	diff_2approaches = risk_diff - risk_diff1;
	if abs(diff_2approaches) > 0.1 then flag_risk_differ = 1;

	if flag_risk_differ = 1 then  output review_risk_Diff;

	output risk_diff;
run;


proc sort data = risk_diff out=outdata.risk_diff_drug_group1 (label = "Risk difference drug/dose total - placebo; Created from &progname.");
	by drug_group1 extraction_id study outcome_l1 outcome_l2 timec2_n timec2;
run;













