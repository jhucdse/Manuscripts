/**************************************************************************************
 * Progname: 03_tbl_rob.sas
 * Purpose: Output table for risk of bias summary
 * Date: 2025-04-11
 * Author: Lijuan Zeng
 * Notes: 
 * 	 
 ***************************************************************************************/
%include "S:/lzeng3/ALA_SRMA/prog/00_utility.sas";
    
* Set up the environment;
options nocenter nonumber; /*nodate*/
%global progname;
%let progname=%str(03_tbl_rob);


proc sort data = outdata.rob_rct out=rob;
	by extraction_id ;
run;

* Incorporate kq1_include to keep included studies only;
proc sort data=outdata.study_kq1_rct_include out=kq1_include ;
	by extraction_id;
run;

data inc_rob;
	merge 	rob (in=A)
			kq1_include (in=B keep=extraction_id flag_meta_ana study);
	by extraction_id;
	if B = 1; * Included all RCT (and 2 not included for crossover design);
	if A=0 then put "ERROR: " extraction_id = /;

	label 
	rob_select_bias = "Random sequence generation (selection bias)"
	rob_alloca_conc = "Allocation concealment (selection bias)"
	rob_perfor_bias = "Blinding of participants and personnel: Performance bias due to knowledge of the allocated interventions by participants during the study"
	rob_detect_bias = "Blinding of outcome assessor (detection bias): Detection bias due to knowledge of the allocated interventions by outcome assessors"
	rob_attrit_bias = "Incomplete outcome data (attrition bias): Attrition bias due to amount, nature or handling of incomplete outcome data"
	rob_report_bias = "Selective Reporting (reporting bias): Reporting bias due to selective outcome reporting"
	rob_other_bias = "Other bias";
run;
proc contents data=inc_rob varnum; run;

%global varlist;
%let varlist = %str(rob_select_bias rob_alloca_conc rob_perfor_bias rob_detect_bias rob_attrit_bias rob_report_bias rob_other_bias);
proc freq data= inc_rob;
   tables &varlist.  / list missing;
run;

proc print data=inc_rob (where=(missing(rob_other_bias)));
   var rob_other_bias extraction_id study;
run;
title3;

proc sort data =inc_rob ;
	by extraction_id;
run;
proc transpose data=inc_rob    out=rob_l (rename=(_NAME_=rob_param _LABEL_ = rob_label col1= rob_results))  ;
   by extraction_id;
   var &varlist.;
run;

* Create a summary table with counts and percentages for risk of bias;
proc freq data= rob_l;
   tables rob_param * rob_label * rob_results  / out = rob_freq outpct noprint;
run;

data rob_freq1;	
	set rob_freq;

	pct = round(pct_row);
	if rob_param = "rob_select_bias" then order = 1;
	else if rob_param = "rob_alloca_conc" then order = 2;
	else if rob_param = "rob_perfor_bias" then order = 3;
	else if rob_param = "rob_detect_bias" then order = 4;
	else if rob_param = "rob_attrit_bias" then order = 5;
	else if rob_param = "rob_report_bias" then order = 6;
	else if rob_param = "rob_other_bias" then order = 7;

	cnt_pct = strip(put(count, best.)) || " (" || strip(put(pct, best.)) || ")";
run;
proc sort data = rob_freq1;
	by order rob_results;
run;

data rob_freq2;
	set rob_freq1;
	by order rob_label rob_results;

	if first.rob_label then label = rob_label;
run;

options orientation=portrait noquotelenmax nodate nonumber;
ods rtf file="&outdir.&progname..rtf"  style=journal ;
footnote "";
*footnote "Outputs generated from &progname..sas";
ods escapechar = "~";
title; title2;
title3 "Risk of bias - RCT (KQ1)";

proc report data = rob_freq2 nowd;
	column order label rob_results cnt_pct;

	define order / order order = data noprint ;
	define label / "Risk of bias" style(column)=[cellwidth = 5in asis = on] left;
	define rob_results / "" style(column)=[cellwidth = 1 in ] left;
	define cnt_pct / "n (%)" style(column)=[cellwidth = 1 in ] right;

	compute after _page_ /left;
*		line "*&footnote1.";
	endcomp; 
run;

ods rtf close;
