/**************************************************************************************
 * Progname: 03_tbl_rd.sas
 * Purpose: Format R risk-difference meta-analysis results as RTF tables
 * Date: 2025-03-30
 * Author: Lijuan Zeng
 * Notes: 
 ***************************************************************************************/
%include "S:/lzeng3/ALA_SRMA/prog/00_utility.sas";
    
* Set up the environment;
options nocenter nonumber; /*nodate*/
%global progname;
%let progname=%str(03_tbl_rd);


************************************************************************************************
** Output one table for each drug: Total - Placebo
************************************************************************************************;
%macro import_sheet(drugname);

	

proc import datafile="S:\lzeng3\ALA_SRMA\data_ma\03_percMA_rd_&drugname..xlsx"
out=&drugname
dbms=xlsx
replace;
run;

* Create a order variable of the outcome and timepoint;
data &drugname._order;
	set &drugname.;
	
	if timepoint = "0-6 months" then timen=1;
	else if timepoint = "7-12 months" then timen=2;
	else if timepoint = "13-24 months" then timen=3;
	else if timepoint = "> 24 months" then timen=4;

	if outcome =   "URTI: Nasopharyngitis" then order = 1;
	else if outcome = "URTI: Sinusitis" then order = 2;
	else if outcome = "URTI: Sinusitis, acute" then order = 2.1;
	else if outcome = "URTI: Sinusitis, allergic" then order = 2.2;
	else if outcome = "URTI: Sinusitis, bacterial" then order = 2.3;
	else if outcome = "URTI: Sinusitis, chronic" then order = 2.4;
	else if outcome = "URTI: Sinusitis, viral" then order = 2.5;
	else if outcome = "URTI: Rhinitis" then order = 3;
	else if outcome = "URTI: Rhinitis, acute" then order = 3.1;
	else if outcome = "URTI: Rhinitis, allergic" then order = 3.2;
	else if outcome = "URTI: Rhinitis, bacterial" then order = 3.3;
	else if outcome = "URTI: Rhinitis, chronic" then order = 3.4;
	else if outcome = "URTI: Rhinitis, viral" then order = 3.5;
	else if outcome = "URTI: Pharyngitis" then order = 4;
	else if outcome = "URTI: Pharyngitis, bacterial" then order = 4.1;
	else if outcome = "URTI: Location not noted" then order = 5;
	else if outcome = "URTI: Location not noted, bacterial" then order = 5.1;
	else if outcome = "URTI: Location not noted, viral" then order = 5.2;
	else if outcome = "LRTI: Bronchitis" then order = 6;
	else if outcome = "LRTI: Bronchitis, bacterial" then order = 6.1;
	else if outcome = "LRTI: Bronchitis, viral" then order = 6.2;
	else if outcome = "LRTI: Pneumonia" then order = 7;
	else if outcome = "LRTI: Pneumonia, bacterial" then order = 7.1;
	else if outcome = "LRTI: Pneumonia, viral" then order = 7.2;
	else if outcome = "LRTI: Location not noted" then order = 8;
	else if outcome = "RTI: Location not noted" then order = 9;
	else if outcome = "RTI: Location not noted, bacterial" then order = 9.1;
	else if outcome = "RTI: Location not noted, viral" then order = 9.2;
	else if outcome = "Cough" then order = 10;
	else if outcome = "Asthma exacerbation" then order = 11;
	else if outcome = "Other respiratory harms" then order = 12;

	if missing(order ) then put "WARNING: Update outcome order " outcome = /;
	tbl_order = timen * 100 + order;

	I_2 = round(I_squared * 100, 1);
	pval = round(heterogeneity_pval, 0.01);

	rd_Ci = strip(put(round(rd_estimate*100, 0.1), best.)) || " (" || strip(put(round(lower_ci*100, 0.1), best.)) || ", " || strip(put(round(upper_ci*100, 0.1), best.)) || ")" ;

	timec = strip(timepoint);

	* Flag stat significant estimates;
	if RD_estimate <0 and upper_ci <0 then bolding = 1;
	else if rd_estimate >0 and lower_ci >0 then bolding = 1;
	else bolding = 0;
run;

proc sort data=&drugname._order;
	by Timepoint tbl_order;
run;

* Preprocess the dataset to blank out repeated timepoint values;
data &drugname._order_prepped;
    set &drugname._order;
    by Timepoint; /* Ensure the data is sorted by tbl_order */
    if not first.Timepoint then Timepoint = ""; /* Blank out repeated timepoints */
run;
proc sort data=&drugname._order_prepped;
	by tbl_order ;
run;


proc freq data= &drugname._order_prepped;
   tables bolding
   / list missing;
run;

** output table;
%let colw = 1.8;
%let footnote1 = %str(Risk differences and corresponding 95% confidence intervals from random effect models were estimated for outcomes that include at least two studies.);
%let footnote2 = %str(Bolded values indicate statistically significant risk differences.);

options orientation=portrait noquotelenmax nodate nonumber;
ods rtf file="&outdir.&progname._&drugname..rtf"  style=journal ;
footnote "";
*footnote "Outputs generated from &progname..sas";
ods escapechar = "~";
title; title2;
title3 "&drugname.";
proc report data = &drugname._order_prepped nowd;
	column tbl_order timepoint outcome RD_CI number_of_studies pval bolding bolded;

	define tbl_order / order order = data noprint ;
	define timepoint / "Study durations"   style(column)=[cellwidth = 1in asis = on] ;
	define outcome / "Outcome" style(column)=[cellwidth = 2in asis = on] left;
	define RD_CI / "Risk differences (Drug-Placebo)~n% (95% CI)*" style(column)=[cellwidth = &colw. in	] center;
	define number_of_studies / "Number of studies" style(column)=[cellwidth = 0.8 in	] center;
/*	define i_2 / "I(*ESC*){unicode '00B2'x} (%)" style(column)=[cellwidth = 0.8 in	] center;*/
	define pval / "Heterogeneity p-value" style(column)=[cellwidth = 1 in	] center;
	define bolding / display noprint;
	define bolded / computed noprint;

   /* Apply bold formatting to RD_with_CI when bold=1 */
    compute bolded;
	   if bolding = 1 then call define(_row_, "style/merge", "style={font_weight=bold}");
    endcomp;

	compute after _page_ /left;
		line "*&footnote1.";
		line "*&footnote2.";
	endcomp; 
run;	

ods rtf close;


%mend import_sheet;


%import_sheet(lira);
%import_sheet(sema);
%import_sheet(tirz);
%import_sheet(orli);
%import_sheet(nabu);
%import_sheet(phto);




*************************************************************************************************
** Output by drug-dose
************************************************************************************************;
%macro readinds(suf);
proc import datafile="S:\lzeng3\ALA_SRMA\data_ma\03_percMA_rd_drug_group1&suf..csv"
	out=dat_drug_dose&suf.
	dbms=csv
	replace;
	guessingrows = 10000;
run;

* Output separate dataset for each drug;
data dat_lira&suf. dat_sema&suf. dat_tirz&suf. dat_rest&suf.;
	set dat_drug_dose&suf.;

	if index(drug,"Liraglutide")>0 and index(drug, "Other")=0 then output dat_lira&suf.;
	else if index(drug,"Semaglutide")>0 and index(drug, "Other")=0  then output dat_sema&suf.;
	else if index(drug,"Tirzepatide")>0 and index(drug, "Other")=0  then output dat_tirz&suf.;
	else if index(drug,"Orlistat")>0 or index(drug, "Naltre")>0 or index(drug,"Phen")>0  then output dat_rest&suf.;
run;
%mend readinds;

%readinds;
%readinds(_diabetes);
%readinds(_weight);


proc freq data= dat_drug_dose;
   tables drug   / list missing;
run;


%macro outtbl (drugname);
/*
%let drugname = sema;
*/

* Create a order variable of the outcome and timepoint;
data &drugname._order;
	set dat_&drugname.;
	
	%if &drugname.=%str(lira) or &drugname.=%str(lira_diabetes) or &drugname.=%str(lira_weight) %then %do;
		if index(drug,"1.2")>0 then drugn=1;
		else if index(drug,"1.8")>0 then drugn=2;
		else if index(drug,"3.0")>0 then drugn=3;
	%end;
	%else %if &drugname.=%str(sema) or &drugname.=%str(sema_diabetes) or &drugname.=%str(sema_weight) %then %do;
		if index(drug,"1.0")>0 then drugn=1;
		else if index(drug,"2.4")>0 then drugn=2;
		else if index(drug,"14")>0 then drugn=3;
	%end;
	%else %if &drugname.=%str(tirz) or &drugname.=%str(tirz_diabetes) or &drugname.=%str(tirz_weight) %then %do;
		if index(drug,"15 mg")>0 then drugn=3;
		else if index(drug,"10 mg")>0 then drugn=2;
		else if index(drug,"5 mg")>0 then drugn=1;
	%end;
	%else %if &drugname.=%str(rest) %then %do;
		if index(drug,"Orli")>0 then drugn=1;
		else if index(drug,"Nal")>0 then drugn=2;
		else if index(drug,"Phen")>0 then drugn=3;
	%end;


	if timepoint = "0-6 months" then timen=1;
	else if timepoint = "7-12 months" then timen=2;
	else if timepoint = "13-24 months" then timen=3;
	else if timepoint = "> 24 months" then timen=4;

	if outcome =   "URTI: Nasopharyngitis" then order = 1;
	else if outcome = "URTI: Sinusitis" then order = 2;
	else if outcome = "URTI: Sinusitis, acute" then order = 2.1;
	else if outcome = "URTI: Sinusitis, allergic" then order = 2.2;
	else if outcome = "URTI: Sinusitis, bacterial" then order = 2.3;
	else if outcome = "URTI: Sinusitis, chronic" then order = 2.4;
	else if outcome = "URTI: Sinusitis, viral" then order = 2.5;
	else if outcome = "URTI: Rhinitis" then order = 3;
	else if outcome = "URTI: Rhinitis, acute" then order = 3.1;
	else if outcome = "URTI: Rhinitis, allergic" then order = 3.2;
	else if outcome = "URTI: Rhinitis, bacterial" then order = 3.3;
	else if outcome = "URTI: Rhinitis, chronic" then order = 3.4;
	else if outcome = "URTI: Rhinitis, viral" then order = 3.5;
	else if outcome = "URTI: Pharyngitis" then order = 4;
	else if outcome = "URTI: Pharyngitis, bacterial" then order = 4.1;
	else if outcome = "URTI: Location not noted" then order = 5;
	else if outcome = "URTI: Location not noted, bacterial" then order = 5.1;
	else if outcome = "URTI: Location not noted, viral" then order = 5.2;
	else if outcome = "LRTI: Bronchitis" then order = 6;
	else if outcome = "LRTI: Bronchitis, bacterial" then order = 6.1;
	else if outcome = "LRTI: Bronchitis, viral" then order = 6.2;
	else if outcome = "LRTI: Pneumonia" then order = 7;
	else if outcome = "LRTI: Pneumonia, bacterial" then order = 7.1;
	else if outcome = "LRTI: Pneumonia, viral" then order = 7.2;
	else if outcome = "LRTI: Location not noted" then order = 8;
	else if outcome = "RTI: Location not noted" then order = 9;
	else if outcome = "RTI: Location not noted, bacterial" then order = 9.1;
	else if outcome = "RTI: Location not noted, viral" then order = 9.2;
	else if outcome = "Cough" then order = 10;
	else if outcome = "Asthma exacerbation" then order = 11;
	else if outcome = "Other respiratory harms" then order = 12;

	if missing(order ) then put "WARNING: Update outcome order " outcome = /;
	tbl_order = sum(drugn * 1000, timen * 100, order);

	I_2 = round(I_squared * 100, 1);
	pval = round(heterogeneity_pval, 0.01);

	rd_Ci = strip(put(round(rd_estimate*100, 0.1), best.)) || " (" || strip(put(round(lower_ci*100, 0.1), best.)) || ", " || strip(put(round(upper_ci*100, 0.1), best.)) || ")" ;

	timec = strip(timepoint);
	drugc = strip(drug);

	* Flag stat significant estimates;
	if RD_estimate <0 and upper_ci <0 then bolding = 1;
	else if rd_estimate >0 and lower_ci >0 then bolding = 1;
	else bolding = 0;
run;


proc sort data=&drugname._order;
	by drug timen Timepoint tbl_order;
run;

* Preprocess the dataset to blank out repeated timepoint values;
data &drugname._order_prepped;
    set &drugname._order;
    by drug timen Timepoint; /* Ensure the data is sorted by tbl_order */
	if not first.drug then drug = "";
    if not first.Timepoint then Timepoint = ""; /* Blank out repeated timepoints */
run;
proc sort data=&drugname._order_prepped;
	by tbl_order ;
run;


** output table;
%let colw = 1.2;
%let footnote1 = %str(Risk differences and corresponding 95% confidence intervals from random effect models were estimated for outcomes that include at least two studies.);
%let footnote2 = %str(Bolded values indicate statistically significant risk differences.);

options orientation=portrait noquotelenmax nodate nonumber;
ods rtf file="&outdir.&progname._&drugname._dose.rtf"  style=journal ;
footnote "";
ods escapechar = "~";
title; title2;
title3 "&drugname.";
proc report data = &drugname._order_prepped nowd;
	column tbl_order drug timepoint outcome RD_CI number_of_studies pval bolding bolded;

	define tbl_order / order order = data noprint ;
	define drug / "Drug/dose"   style(column)=[cellwidth = 1.4in asis = on] ;
	define timepoint / "Study durations"   style(column)=[cellwidth = 1in asis = on] ;
	define outcome / "Outcome" style(column)=[cellwidth = 2in asis = on] left;
	define RD_CI / "Risk differences (Drug-Placebo)~n% (95% CI)*" style(column)=[cellwidth = &colw. in	] right;
	define number_of_studies / "Number of studies" style(column)=[cellwidth = 0.8 in	] right;
	define pval / "Heterogeneity p-value" style(column)=[cellwidth = 1 in	] right;
	define bolding / display noprint;
	define bolded / computed noprint;

    compute bolded;
	   if bolding = 1 then call define(_row_, "style/merge", "style={font_weight=bold}");
    endcomp;

	compute after _page_ /left;
		line "*&footnote1.";
		line "*&footnote2.";
	endcomp; 
run;	

ods rtf close;

%mend outtbl;

%outtbl(lira); %outtbl(lira_diabetes); %outtbl(lira_weight);
%outtbl(sema); %outtbl(sema_diabetes); %outtbl(sema_weight);
%outtbl(tirz); %outtbl(tirz_diabetes); %outtbl(tirz_weight);
%outtbl(rest);
