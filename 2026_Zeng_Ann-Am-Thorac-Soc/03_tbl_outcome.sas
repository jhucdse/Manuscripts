/**************************************************************************************
 * Progname: 03_tbl_outcome.sas
 * Purpose: Combine arm-level summaries and R proportion estimates into outcome tables
 * Date: 2025-03-28
 * Author: Lijuan Zeng
 * Notes: 
 ***************************************************************************************/
%include "S:/lzeng3/ALA_SRMA/prog/00_utility.sas";
    
* Set up the environment;
options nocenter nonumber; /*nodate*/
%global progname;
%let progname=%str(03_tbl_outcome);



************************************************************************************************
** Calculate mean percentages for outcomes with only one study;

** BY drug_Group1;
proc means data=outdata.kq1_inc_rct_results_l_arms_ndsty    noprint nway missing;
   class drug_group0 timec2 drug_group1 outcome_l1 outcome_l2;
   var perc;
   output out=kq1_inc_rct_mean_perc  (drop= _TYPE_ _FREQ_) mean=mean_perc  n=n_study;
run;
proc means data=outdata.kq1_inc_rct_results_l_arms_ndsty    noprint nway missing;
   class drug_group0 timec2 drug_group1 outcome_l1 outcome_l2;
   var total_n;
   output out=kq1_inc_rct_total_n  (drop= _TYPE_ _FREQ_) sum=sum_total_n;
run;
proc means data=outdata.kq1_inc_rct_results_l_arms_ndsty    noprint nway missing;
   class drug_group0 timec2 drug_group1 outcome_l1 outcome_l2;
   var events;
   output out=kq1_inc_rct_events  (drop= _TYPE_ _FREQ_) sum=sum_events;
run;
data outdata.kq1_inc_rct_mean_perc (label = "Created from &progname..sas");
	merge 	kq1_inc_rct_mean_perc (drop=mean_perc)
			kq1_inc_Rct_total_n
			kq1_inc_rct_events;
	by drug_group0 timec2 drug_group1 outcome_l1 outcome_l2;

	label flag_meta = "Flag for drug/time/outcome that needs to be meta-analyzed";
	if n_study >1 then flag_meta = 1;
	mean_perc = sum_events / sum_total_n *100;
	if sum_events ne 0 and mean_perc < 0.1 then mean_perc_c = "< 0.1";
	else mean_perc_c = strip(put(round(mean_perc, 0.1), best.));
run;
proc sort data = outdata.kq1_inc_Rct_mean_perc out=mean_perc;
	by timec2 drug_Group0 outcome_l1 outcome_l2;
run;
proc transpose data=mean_perc    out=kq1_inc_Rct_mean_perc_w (drop=_NAME_)  ;
   by timec2 drug_Group0 outcome_l1 outcome_l2;
   var mean_perc_c;
   id drug_group1;
run;

* by drug_group0 to get the total columns;
proc means data=outdata.kq1_inc_rct_results_l_arms_ndsty    noprint nway missing;
   class drug_group0 timec2 outcome_l1 outcome_l2;
   var perc;
   output out=kq1_inc_rct_mean_perc_tot  (drop= _TYPE_ _FREQ_) mean=mean_perc  n=n_study;
run;
proc means data=outdata.kq1_inc_rct_results_l_arms_ndsty    noprint nway missing;
   class drug_group0 timec2 outcome_l1 outcome_l2;
   var total_n;
   output out=kq1_inc_rct_total_n_tot  (drop= _TYPE_ _FREQ_) sum=sum_total_n;
run;
proc means data=outdata.kq1_inc_rct_results_l_arms_ndsty    noprint nway missing;
   class drug_group0 timec2 outcome_l1 outcome_l2;
   var events;
   output out=kq1_inc_rct_events_tot  (drop= _TYPE_ _FREQ_) sum=sum_events;
run;
data outdata.kq1_inc_rct_mean_perc_tot (label = "Total column by drug_group0; Created from &progname..sas");
	merge 	kq1_inc_rct_mean_perc_tot (drop=mean_perc)
			kq1_inc_Rct_total_n_tot
			kq1_inc_rct_events_tot;
	by drug_group0 timec2 outcome_l1 outcome_l2;
	label flag_meta = "Flag for drug/time/outcome that needs to be meta-analyzed";
	if n_study >1 then flag_meta = 1;
	mean_perc = sum_events/sum_total_n*100;
	if sum_events ne 0 and mean_perc < 0.1 then mean_perc_c = "< 0.1";
	else mean_perc_c = strip(put(round(mean_perc, 0.1), best.));
run;
proc sort data = outdata.kq1_inc_Rct_mean_perc_tot out=mean_perc_tot;
	by timec2 drug_Group0 outcome_l1 outcome_l2;
run;
proc transpose data=mean_perc_tot    out=kq1_inc_Rct_mean_perc_w_Tot (drop=_NAME_)  suffix=_total;
   by timec2 drug_Group0 outcome_l1 outcome_l2;
   var mean_perc_c;
   id drug_group0;
run;
data kq1_inc_Rct_mean_perc_w2; 
	merge kq1_inc_rct_mean_perc_w
			kq1_inc_rct_mean_perc_w_tot;
	by timec2 drug_Group0 outcome_l1 outcome_l2;
	if first.drug_group0 then text_ord = 11;
	else text_ord + 1;
	
	* Assign order for tables;
	if index(outcome_l1, "URTI")>0 then catord = 1;
	else if index(outcome_l1, "LRTI")>0 then catord = 2;
	else if index(outcome_l1, "RTI")>0 then catord =3;
	else if index(outcome_l1, "Cough")>0 then catord = 4;
	else if index(outcome_l1, "Exacerb")>0 then catord = 5;
	else if index(outcome_l1, "Other")>0 then catord = 6;

	text_ord2 = catord * 100 + text_ord;
	textv = "   " ||  strip(outcome_l2);
run;
proc sort data =kq1_inc_Rct_mean_perc_w2 out = outdata.kq1_inc_Rct_mean_perc_w(label = "Mean percentages by outcomes; created from &progname..sas");
	by timec2 drug_group0 text_ord2;
run;

data stack_summ_perc;
	set outdata.stack_study_summ_all
		outdata.kq1_inc_Rct_mean_perc_w ;
	if text_ord in (1,2,3) then do; 
		outcome_l1 = "Summary of studies^";
		ord = text_ord;
	end;
	
	if timec2 = "0-6 months" then timeord=1; 
	else if timec2 = "7-12 months" then timeord = 2; 
	else if timec2 = "13-24 months" then timeord = 3; 
	else if timec2 = "> 24 months" then timeord = 4; 
	if not missing(timec2) and missing(ord) then
	ord = timeord * 1000 + text_ord2;
run;

proc sort data = stack_summ_perc out=outdata.stack_summ_perc;
	by ord;
run;

************************************************************************************************;
** OUTPUT TABLES;
************************************************************************************************;

** Create a dataset for empty rows for categories;
proc sort data = outdata.stack_summ_perc out=outcome_l1 (keep = timeord outcome_l1 catord timec2) nodupkey;
	by timeord timec2 catord outcome_l1;
run;
data outcome_l1_rows (keep = textv ord timeord ord catord empty);
	set outcome_l1;
	length textv $100;
	textv = strip(outcome_l1);
	empty = 1;
	if missing(timeord) then ord = 0;
	else ord = timeord * 1000 + catord * 100;
run;
** Create empty rows for timepoint;
proc sort data=outdata.stack_summ_perc out=timerows (keep = timeord timec2 where=(not missing(timeord))) nodupkey;
	by timeord timec2;
run;
data time_rows ;
	set timerows;
	length textv $100;
	textv = "Study duration: " || strip(timec2);
	ord = timeord * 100;
	empty = 1;
run;

%let colw = 1.5;
%let footnote1 = %str(Proportions are shown for outcomes that include only one study. The 95% confidence intervals for proportions from the random effects models are applicable only when there are more than two studies/arms included in the analysis.);
%let footnote2 = %str(Summary of studies across all study durations.);


* Note 2025-03-06 meeting - to only output summary of studies one per table;

************************************************************************************************
** Bring in meta-analysis spreadsheet output from R;
/*
%let drugname = Orlistat;
%let dsname = Orlistat_total;
*/
%macro readin(drugname, dsname );
proc import datafile="S:\lzeng3\ALA_SRMA\data_ma\03_percMA_wSumm_&drugname..csv"
	out=_&dsname.
	dbms=csv
	replace;
	guessingrows = 10000;
run;
data &dsname.;
	set _&dsname.;
	&dsname. = strip(effect_ci) || "; " || strip(put(num_arms, best.));
run;
proc sort data = &dsname. (keep = time_frame ae_term &dsname.);
	by time_frame ae_term;
run;
%mend readin;




%macro fmttbl(drug,suf, varlist);
data all_&suf. (rename=(time_frame=timec2));
	length ae_Term $100.;
	merge &varlist.;
	by time_frame ae_term;

	* if values missing then assign dashlines;
	array vars &suf.:;
	do i = 1 to dim(vars);
		if missing(vars[i]) then vars[i] = "--";
	end;
	drop i;

	if time_frame = "0-6 months" then timen=1;
	else if time_frame = "7-12 months" then timen=2;
	else if time_frame = "13-24 months" then timen=3;
	else if time_frame = "> 24 months" then timen=4;

	if ae_term =   "URTI: Nasopharyngitis" then order = 1;
	else if ae_term = "URTI: Sinusitis" then order = 2;
	else if ae_term = "URTI: Sinusitis, acute" then order = 2.1;
	else if ae_term = "URTI: Sinusitis, allergic" then order = 2.2;
	else if ae_term = "URTI: Sinusitis, bacterial" then order = 2.3;
	else if ae_term = "URTI: Sinusitis, chronic" then order = 2.4;
	else if ae_term = "URTI: Sinusitis, viral" then order = 2.5;
	else if ae_term = "URTI: Rhinitis" then order = 3;
	else if ae_term = "URTI: Rhinitis, acute" then order = 3.1;
	else if ae_term = "URTI: Rhinitis, allergic" then order = 3.2;
	else if ae_term = "URTI: Rhinitis, bacterial" then order = 3.3;
	else if ae_term = "URTI: Rhinitis, chronic" then order = 3.4;
	else if ae_term = "URTI: Rhinitis, viral" then order = 3.5;
	else if ae_term = "URTI: Rhinitis, seasonal" then order = 3.6;
	else if ae_term = "URTI: Pharyngitis" then order = 4;
	else if ae_term = "URTI: Pharyngitis, allergic" then order = 4.1;
	else if ae_term = "URTI: Pharyngitis, bacterial" then order = 4.2;
	else if ae_term = "URTI: Pharyngitis, viral" then order = 4.3;
	else if ae_term = "URTI: Laryngitis" then order = 4.9;
	else if ae_term = "URTI: Location not noted" then order = 5;
	else if ae_term = "URTI: Location not noted, bacterial" then order = 5.1;
	else if ae_term = "URTI: Location not noted, viral" then order = 5.2;
	else if ae_term = "LRTI: Bronchitis" then order = 6;
	else if ae_term = "LRTI: Bronchitis, allergic" then order = 6.1;
	else if ae_term = "LRTI: Bronchitis, acute" then order = 6.2;
	else if ae_term = "LRTI: Bronchitis, chronic" then order = 6.3;
	else if ae_term = "LRTI: Bronchitis, bacterial" then order = 6.4;
	else if ae_term = "LRTI: Bronchitis, viral" then order = 6.5;
	else if ae_term = "LRTI: Bronchopneumonia" then order = 6.6;
	else if ae_term = "LRTI: Pneumonia" then order = 7;
	else if ae_term = "LRTI: Pneumonia, bacterial" then order = 7.1;
	else if ae_term = "LRTI: Pneumonia, viral" then order = 7.2;
	else if ae_term = "LRTI: Pneumonia, aspiration" then order = 7.3;
	else if ae_term = "LRTI: Pneumonia, atypical" then order = 7.3;
	else if ae_term = "LRTI: Pneumonia, lobar" then order = 7.3;
	else if ae_term = "LRTI: Pneumonia, organising" then order = 7.3;
	else if ae_term = "LRTI: Location not noted" then order = 8;
	else if ae_term = "LRTI: Location not noted, bacterial" then order = 8.1;
	else if ae_term = "LRTI: Location not noted, viral" then order = 8.2;
	else if ae_term = "RTI: Location not noted" then order = 9;
	else if ae_term = "RTI: Location not noted, bacterial" then order = 9.1;
	else if ae_term = "RTI: Location not noted, viral" then order = 9.2;
	else if ae_term = "Cough" then order = 10;
	else if ae_term = "Cough, allergic" then order = 10.1;
	else if ae_term = "Asthma exacerbation" then order = 11;
	else if ae_term = "Other respiratory harms" then order = 12;

	if missing(order ) then put "WARNING: Update outcome order " ae_term = /;
	ord = sum(timen * 100, order);

	textv = "   " || strip(ae_term);
run;

** Study summary;
proc sort data =outdata.stack_summ_perc (where=(drug_group0 = "&drug." )) out = tbl_&suf. (keep = drug_Group0 timec2 text: &suf.: outcome: ord);
	by ord outcome_l1 textv;
run;
proc sort data=tbl_&suf. out=_catrows_&suf. (keep=outcome_l1 timec2) nodupkey;
	by timec2 outcome_l1;
run;
data catrows_&suf.;
	set _catrows_&suf. (rename=(outcome_l1 = textv));
	if timec2 = "0-6 months" then timen=1;
	else if timec2 = "7-12 months" then timen=2;
	else if timec2 = "13-24 months" then timen=3;
	else if timec2 = "> 24 months" then timen=4;

	if textv = "Summary of studies^" then order = 0;
	else if textv = "Upper respiratory tract infection (URTI)" then order = 0.1;
	else if textv = "Lower respiratory tract infection (LRTI)" then order = 5.99;
	else if textv = "Respiratory tract infection (RTI)" then order = 8.99;
	else if textv = "Cough" then order = 9.99;
	else if textv = "Exacerbations" then order = 10.99;
	else if textv = "Other respiratory harms" then order = 11.99;
	ord = sum(timen * 100, order);
run;
proc sort data = all_&suf.; by ord; run;
proc sort data = catrows_&suf.; by ord; run;



data tabledata_&suf.;
	set tbl_&suf. (where=(text_ord in (1, 2, 3)) 
%if &suf.=%str(phen) %then %do;
	rename=(Phentermine_3_25_mg_Topiramate_2 = Phentermine_3_25_mg_Topiramate 
			Phentermine_7_5_mg_Topiramate_46 = Phentermine_7_5_mg_Topiramate
			Phentermine_15_mg_Topiramate_92 = Phentermine_15_mg_Topiramate)
%end;
%else %if &suf.=%str(nalt) %then %do;
	rename=(Naltrexone_16_mg_Bupropion_360_m = Naltrexone_16_mg_Bupropion_360	
			Naltrexone_32_mg_Bupropion_360_m = Naltrexone_32_mg_Bupropion_360	)
%end;
	)
		time_rows (in=timerow)
		all_&suf.
		catrows_&suf. (in=catrows);
	array columns &suf.:;
	do i = 1 to dim(columns);
		if outcome_l1 = "Summary of studies^" and missing(columns[i]) then columns[i]="--";
		else if empty ne 1 and missing(columns[i]) and catrows ne 1 then columns[i] = "0";
	end;
	if timerow=1 then bold=1; else bold = 0;
run;
proc sort data=tabledata_&suf.;
	by ord;
run;
%mend fmttbl;


************************************************************************************************;
** Liraglutide;
%readin(Liraglutide, Liraglutide_total);

* by dose;
%readin(Liraglutide_1_2_mg, Liraglutide_1_2_mg);
%readin(Liraglutide_1_8_mg, Liraglutide_1_8_mg);
%readin(Liraglutide_3_0_mg, Liraglutide_3_0_mg);
%readin(Liraglutide_Other, Liraglutide_Other);

%fmttbl(Liraglutide,lira, %str( Liraglutide_1_2_mg	Liraglutide_1_8_mg	Liraglutide_3_0_mg	Liraglutide_Other	Liraglutide_total));


options orientation=landscape noquotelenmax nodate nonumber;
ods rtf file="&outdir.&progname._bydrugdose_Lira.rtf"  style=journal ;
footnote "";
*footnote "Outputs generated from &progname..sas";
ods escapechar = "~";
title; title2;
title3 "Liraglutide";

proc report data = tabledata_lira nowd;
	column ord textv Liraglutide_1_2_mg	Liraglutide_1_8_mg	Liraglutide_3_0_mg	Liraglutide_other	Liraglutide_total  ;

	define ord / order order = data noprint ;
	define textv / "Study summaries and outcomes" style(column)=[cellwidth = 2.5in asis = on] left;
	define Liraglutide_1_2_mg / "Liraglutide~n1.2 mg~n% or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;
	define Liraglutide_1_8_mg / "Liraglutide~n1.8 mg~n% or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;
	define Liraglutide_3_0_mg / "Liraglutide~n3.0 mg~n% or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;
	define Liraglutide_other / "Liraglutide~n Other doses~n% or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;
	define Liraglutide_total / "Liraglutide~n Total~n% or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;

	compute after _page_ /left;
		line "*&footnote1.";
		line "^&footnote2.";
	endcomp; 
run;

ods rtf close;






************************************************************************************************;
** Semaglutide;
%readin(Semaglutide, Semaglutide_total);

* by dose;
%readin(Semaglutide_1_0_mg, Semaglutide_1_0_mg);
%readin(Semaglutide_2_4_mg, Semaglutide_2_4_mg);
%readin(Semaglutide_14_mg__OD_, Semaglutide_14_mg__OD_);
%readin(Semaglutide_Other, Semaglutide_Other);

%fmttbl(%str(Semaglutide),sema, %str( Semaglutide_1_0_mg	Semaglutide_2_4_mg	Semaglutide_14_mg__OD_	Semaglutide_Other	Semaglutide_total));

options orientation=landscape noquotelenmax nodate nonumber;
ods rtf file="&outdir.&progname._bydrugdose_Sema.rtf"  style=journal ;
footnote "";
*footnote "Outputs generated from &progname..sas";
ods escapechar = "~";
title; title2;
title3 "Semaglutide";

proc report data = tabledata_sema nowd;
	column ord textv Semaglutide_1_0_mg Semaglutide_2_4_mg Semaglutide_14_mg__OD_ Semaglutide_other Semaglutide_total;

	define ord / order order = data noprint ;
	define textv / "Study summaries and outcomes" style(column)=[cellwidth = 2.5in asis = on] left;
	define Semaglutide_1_0_mg / "Semaglutide~n1.0 mg~n % or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;
	define Semaglutide_2_4_mg / "Semaglutide~n 2.4 mg~n % or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;
	define Semaglutide_14_mg__OD_/ "Semaglutide~n 14 mg (OD)~n % or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;
	define Semaglutide_other / "Semaglutide~n Other doses~n % or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;
	define Semaglutide_total / "Semaglutide~n Total~n % or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;

	compute after _page_ /left;
		line "*&footnote1.";
		line "^&footnote2.";
	endcomp; 
run;

ods rtf close;



************************************************************************************************;
** Tirzepatide;
%readin(Tirzepatide, Tirzepatide_total);

* by dose;
%readin(Tirzepatide_5_mg, Tirzepatide_5_mg);
%readin(Tirzepatide_10_mg, Tirzepatide_10_mg);
%readin(Tirzepatide_15_mg, Tirzepatide_15_mg);
%readin(Tirzepatide_Other, Tirzepatide_Other);

%fmttbl(%str(Tirzepatide),tirz, %str( Tirzepatide_5_mg	Tirzepatide_10_mg	Tirzepatide_15_mg	Tirzepatide_Other	Tirzepatide_total));



options orientation=landscape noquotelenmax nodate nonumber;
ods rtf file="&outdir.&progname._bydrugdose_Tirz.rtf"  style=journal ;
footnote "";
*footnote "Outputs generated from &progname..sas";
ods escapechar = "~";
title; title2;
title3 "Tirzepatide";

proc report data = tabledata_tirz nowd;
	column ord textv tirzepatide_other Tirzepatide_5_mg Tirzepatide_10_mg Tirzepatide_15_mg Tirzepatide_total;

	define ord / order order = data noprint ;
	define textv / "Study summaries and outcomes" style(column)=[cellwidth = 2.5in asis = on] left;
	define tirzepatide_other / "Tirzepatide 1 mg~n % or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;
	define Tirzepatide_5_mg / "Tirzepatide 5 mg~n % or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;
	define Tirzepatide_10_mg / "Tirzepatide 10 mg~n % or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;
	define Tirzepatide_15_mg / "Tirzepatide 15 mg~n % or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;
	define Tirzepatide_total / "Tirzepatide Total~n % or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;

	compute after _page_ /left;
		line "*&footnote1.";
		line "^&footnote2.";
	endcomp; 
run;

ods rtf close;



************************************************************************************************;
** Orlistat;
%readin(Orlistat, Orlistat_total);

* by dose;
%readin(Orlistat_60_mg, Orlistat_60_mg);
%readin(Orlistat_120_mg, Orlistat_120_mg);
%readin(Orlistat_150_mg, Orlistat_150_mg);

%fmttbl(%str(Orlistat),orli, %str( Orlistat_60_mg	Orlistat_120_mg	Orlistat_150_mg	Orlistat_total));


options orientation=landscape noquotelenmax nodate nonumber;
ods rtf file="&outdir.&progname._bydrugdose_Orli.rtf"  style=journal ;
footnote "";
*footnote "Outputs generated from &progname..sas";
ods escapechar = "~";
title; title2;
title3 "Orlistat";

proc report data = tabledata_orli nowd;
	column ord textv orlis:;

	define ord / order order = data noprint ;
	define textv / "Study summaries and outcomes" style(column)=[cellwidth = 2.5in asis = on] left;
	define orlistat_60_mg / "Orlistat 60 mg~n % or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;
	define orlistat_120_mg / "Orlistat 120 mg~n % or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;
	define orlistat_150_mg / "Orlistat 150 mg~n % or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;
	define orlistat_total / "Orlistat Total~n % or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;

	compute after _page_ /left;
		line "*&footnote1.";
		line "^&footnote2.";
	endcomp; 
run;

ods rtf close;


************************************************************************************************;
** Naltrexone-bupropion;
%readin(Naltrexone_Bupropion, Naltrexone_Bupropion_total);

* by dose;
%readin(Naltrexone_16_mg_Bupropion_360_mg, Naltrexone_16_mg_Bupropion_360);
%readin(Naltrexone_32_mg_Bupropion_360_mg, Naltrexone_32_mg_Bupropion_360);

%fmttbl(%str(Naltrexone/Bupropion),nalt, %str(Naltrexone_Bupropion_total Naltrexone_16_mg_Bupropion_360	Naltrexone_32_mg_Bupropion_360	));


options orientation=landscape noquotelenmax nodate nonumber;
ods rtf file="&outdir.&progname._bydrugdose_NalBu.rtf"  style=journal ;
footnote "";
*footnote "Outputs generated from &progname..sas";
ods escapechar = "~";
title; title2;
title3 "Naltrexone/Bupropion";
*footnote1 j=l "Proportions are shown for outcomes that include only one study. The 95% confidence intervals for proportions from the random effects models are applicable only when there are more than two studies included in the analysis. ";
proc report data = tabledata_nalt nowd;
	column ord textv  Naltrexone_16_mg_Bupropion_360	Naltrexone_32_mg_Bupropion_360	Naltrexone_Bupropion_total;

	define ord / order order = data noprint ;
	define textv / "Study summaries and outcomes" style(column)=[cellwidth = 2.5in asis = on] left;
	define Naltrexone_16_mg_Bupropion_360 / "Naltrexone 16 mg/Bupropion 360 mg~n % or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in ] right;
	define Naltrexone_32_mg_Bupropion_360 / "Naltrexone 32 mg/Bupropion 360 mg~n % or % (95% CI);~n# arms*" style(column)=[cellwidth = &colw. in	] right;
	define naltrexone_bupropion_total / "Naltrexone/Bupropion Total~n % or % (95% CI);~n# arms*" style(column)=[cellwidth= &colw. in	] right;

	compute after _page_ /left;
		line "*&footnote1.";
		line "^&footnote2.";
	endcomp; 
run;	

ods rtf close;



************************************************************************************************;
** Phentermine/Topiramate;
%readin(Phentermine_Topiramate, Phentermine_Topiramate_total);
* by dose;
%readin(Phentermine_3_25_mg_Topiramate_23_mg, Phentermine_3_25_mg_Topiramate);
%readin(Phentermine_7_5_mg_Topiramate_46_mg, Phentermine_7_5_mg_Topiramate);
%readin(Phentermine_15_mg_Topiramate_92_mg, Phentermine_15_mg_Topiramate);

%fmttbl(%str(Phentermine/Topiramate),phen, %str(Phentermine_Topiramate_total Phentermine_3_25_mg_Topiramate	Phentermine_7_5_mg_Topiramate	Phentermine_15_mg_Topiramate	));

options orientation=landscape noquotelenmax nodate nonumber;
ods rtf file="&outdir.&progname._bydrugdose_PhenTop.rtf"  style=journal ;
footnote "";
*footnote "Outputs generated from &progname..sas";
ods escapechar = "~";
title; title2;
title3 "Phentermine/Topiramate";

proc report data = tabledata_phen nowd;
	column ord textv  Phentermine_3_25_mg_Topiramate	Phentermine_7_5_mg_Topiramate	Phentermine_15_mg_Topiramate	Phentermine_Topiramate_total;

	define ord / order order = data noprint ;
	define textv / "Study summaries and outcomes" style(column)=[cellwidth = 2.5in asis = on] left;
	define Phentermine_3_25_mg_Topiramate / "Phentermine 7.5 mg/Topiramate 46 mg~n % or % (95% CI)*" style(column)=[cellwidth = &colw. in ] right;
	define Phentermine_7_5_mg_Topiramate / "Phentermine 7.5 mg/Topiramate 46 mg~n % or % (95% CI)*" style(column)=[cellwidth = &colw. in ] right;
	define Phentermine_15_mg_Topiramate / "Phentermine 15 mg/Topiramate 92 mg~n % or % (95% CI)*" style(column)=[cellwidth = &colw. in ] right;
	define Phentermine_Topiramate_total / "Phentermine/Topiramate Total~n % or % (95% CI)*" style(column)=[cellwidth = &colw. in ] right;

	compute after _page_ /left;
		line "*&footnote1.";
		line "^&footnote2.";
	endcomp; 
run;

ods rtf close;


************************************************************************************************;
** Setmelanotide;
proc sort data =outdata.stack_summ_perc (where=(drug_group0 = "Setmelanotide" )) out = tbl_setm (keep = drug_Group0 timec2 text: set: outcome: ord);
	by ord outcome_l1 textv;
run;
data tabledata_setm;
	set tbl_setm
		time_rows
		outcome_l1_rows (in=catrow);

	array columns set:;
	do i = 1 to dim(columns);
		if outcome_l1 = "Summary of studies^" and missing(columns[i]) then columns[i]="--";
		else if empty ne 1 and missing(columns[i]) then columns[i] = "0";
	end;

	* no outcomes for 7-12, 13-24 & >24 months;
	if timeord in (2, 3, 4) and not missing(catord) then delete;

	* if total is zero then delete;
	if strip(Setmelanotide_total)="0"  then delete;

	* delete extra cats rows with no data;
	if timeord=1 and catord in (2,3,6)   then delete;

run;
proc sort data=tabledata_setm;
	by ord;
run;


options orientation=landscape noquotelenmax nodate nonumber;
ods rtf file="&outdir.&progname._bydrugdose_Setme.rtf"  style=journal ;
footnote "";
*footnote "Outputs generated from &progname..sas";
ods escapechar = "~";
title; title2;
title3 "Setmelanotide";

proc report data = tabledata_setm nowd;
	column ord textv Setmelanotide_3_mg;

	define ord / order order = data noprint ;
	define textv / "Study summaries and outcomes" style(column)=[cellwidth = 2.5in asis = on] left;
	define Setmelanotide_3_mg / "Setmelanotide 3 mg~n %*" style(column)=[cellwidth = &colw. in ] right;

	compute after _page_ /left;
		line "*Proportions are shown for outcomes that include only one study.";
	endcomp; 
run;

ods rtf close;



