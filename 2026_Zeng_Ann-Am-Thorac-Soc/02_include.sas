/**************************************************************************************
 * Progname: 02_include.sas
 * Purpose: Derive inclusion flags and study-level analysis datasets
 * Date: 2025-01-30
 * Author: Lijuan Zeng
 * Notes:
 ***************************************************************************************/
%include "S:/lzeng3/ALA_SRMA/prog/00_utility.sas";
    
* Set up the environment;
options nocenter nonumber; /*nodate*/
%global progname;
%let progname=%str(02_include);


************************************************************************************************
** input data
************************************************************************************************;
* Bring in Arms details page to exclude studies with torpirate or phentermine only;
data arm_tponly arm_details1;
	set outdata.arm_details;

	if (index(lowcase(compress(arms_name)), "topiramate")>0 and index(lowcase(compress(arms_name)), "phentermine")=0 ) then tor_only=1;
	if ((index(lowcase(compress(arms_name)), "topiramate")=0 and index(lowcase(compress(arms_name)), "liraglutide")=0) and index(lowcase(compress(arms_name)), "phentermine")>0 ) then phen_only=1;
	if (tor_only or phen_only) and extraction_id ne "60405" then output;
	output arm_details1;
run;
proc sort data =  arm_tponly out =arm_tponly_nd nodupkey;
	by extraction_id;
run;
* review and double-check the excluded ones do not include any combo;
data arm_details2;
	merge 	arm_details1
			arm_tponly_nd (in=tponly keep=extraction_id);
	by extraction_id;
	if tponly = 1 then arm_tponly = 1;
run;
proc freq data= arm_details2 (where = (arm_tponly=1));
   tables arms_name
   / list missing;
run;

************************************************************************************************;
* Clean up variables related to study design details ;
proc sort data = outdata.design_details (where=(not missing(extraction_id))) out = study_list1;
    by extraction_id;
run;
proc freq data = study_list1;
    tables kq;
run;

* Separate by KQs;
data    study_list2 (drop = design_study_years)
        outdata.study_KQ2
		allstudies;
    merge 	study_list1
			arm_tponly_nd (in=tponly keep = extraction_id );
    by extraction_id;

	* flag for crossover studies;
	label flag_crossover = "Flag for crossover studies";
	if extraction_id in ("60680", "60711", "60698") then flag_crossover = 1; else flag_crossover = 0;

	label flag_tponly = "Flag for topiramate only or phentermine only study";
	if tponly = 1 then flag_tponly = 1; else flag_tponly = 0;

	if upcase(substr(strip(kq),1,3))="KQ1" then kq_num = 1;
	else kq_num = 2;

	* study years;
    follow_up_pos = index(strip(design_study_years), "Study recruitment start year: [Follow-up: ");
    if follow_up_pos > 0 then do;
        start_pos = follow_up_pos + length('Study recruitment start year: [Follow-up: ');
		study_start_year = substr(strip(design_study_years), start_pos+1, 4);
    end;
    else study_start_year= ""; 

    follow_up_pos_end = index(strip(design_study_years), "Study follow-up end year: [Follow-up: ");
    if follow_up_pos_end > 0 then do;
        *end_pos = follow_up_pos_end + length('Study recruitment end year: [Follow-up: ');
		study_end_year = substr(strip(design_study_years), length(design_study_years)-4, 4);
    end;
    else study_end_year= ""; 
    drop follow_up_pos follow_up_pos_end start_pos  ;
	
	* registration;
	nct_pos = index(design_registered_yn, "NCT0");
	if nct_pos >0 then do;
		design_registered_yn_fu_nct = substr(strip(design_registered_yn), nct_pos,  11);
	end;
	drop nct_pos;

	other_pos = index(design_registered_yn, "other registry - specify name and number: [Follow-up:");
	if other_pos >0 then do;
		design_registered_yn_fu_other = substr(strip(design_registered_yn), other_pos + 54);
	end;
	drop other_pos;

	* funding;
	if index(design_funding, "Industry")>0 then flag_funding_industry=1; else  flag_funding_industry=0;
	if index(design_funding, "Non-industry")>0 then flag_funding_Nindustry=1; else flag_funding_Nindustry=0;
	if strip(design_funding)="Not reported" then flag_funding_NR = 1; else flag_funding_NR = 0;
	if strip(design_funding)="Explicitly reported that the study was NOT funded" then flag_funding_N = 1; else flag_funding_N = 0;

	* Countries;
	if index(design_country, "US")>0 then country_us=1; else country_us=0;
	if index(design_country, "Canada")>0 then country_ca=1; else country_ca=0;
	if index(design_country, "UK")>0 then country_uk=1; else country_uk=0;
	if index(design_country, "China")>0 then country_china=1; else country_china=0;
	if index(design_country, "Germany")>0 then country_ge=1; else country_ge=0;
	if index(design_country, "France")>0 then country_fr=1; else country_fr=0;
	if index(design_country, "India")>0 then country_in=1; else country_in=0;
	if index(design_country, "Japan")>0 then country_jp=1; else country_jp=0;
	if index(design_country, "Other")>0 then country_ot=1; else country_ot=0;

	* Setting;
	if index(design_setting, "Inpatient")>0 then setting_inpatient=1; else setting_inpatient=0;
	if index(design_setting, "Outpatient")>0 then setting_outpatient=1; else setting_outpatient=0;
	if index(design_setting, "Not reported")>0 then setting_nr=1; else setting_nr=0;

	* Location;
	if index(design_setting, "Urban")>0 then location_urban=1; else location_urban=0;
	if index(design_setting, "Suburban")>0 then location_suburban=1; else location_suburban=0;
	if index(design_setting, "Rural")>0 then location_rural=1; else location_rural=0;
	if index(design_setting, "Not reported")>0 then location_nr=1; else location_nr=0;

	* study name;
	length study $100.;
	if extraction_id = "60387" then study = "D'Alessio" ||" " || strip(publication_date);
	else if extraction_id = "60391" then study = "De Castro" ||" " || strip(publication_date);
	else if extraction_id in ("60412", "60421") then study = "De Wit"  ||" " || strip(publication_date);
	else if extraction_id = "60415" then study = "Del Prato"  ||" " || strip(publication_date);
	else if extraction_id in ("60659" "60660") then study = "O'Neil" ||" " || strip(publication_date);
	else if extraction_id = "60667" then study="Pi-Sunyer"  ||" " || strip(publication_date);
	else if extraction_id = "60720" then study = "von Herrath"  ||" " || strip(publication_date);
	else if extraction_id = "60687" then study = strip(scan(Authors, 1)) ||" " || strip(publication_date) || "a";*Kadowaki 2022a: SURPASS J-combo;
	else if extraction_id = "60688" then study = strip(scan(Authors, 1)) ||" " || strip(publication_date) || "b";*Kadowaki 2022b: STEP 6;
	else if extraction_id = "60737" then study = strip(scan(Authors, 1)) ||" " || strip(publication_date) || "a";* Zinmen 2019a: PIONEER 8;
	else if extraction_id = "65412" then study = strip(scan(Authors, 1)) ||" " || strip(publication_date) || "b"; * Zinman 2019: SUSTAIN 9;
	else if extraction_id = "63752" then study = strip(scan(Authors, 1)) ||" " || strip(publication_date) || "a"; * Marso 2016:  LEADER;
	else if extraction_id = "65359" then study = strip(scan(Authors, 1)) ||" " || strip(publication_date) || "b"; * Marso 2016: SUSTAIN 6;
	else study = strip(scan(Authors, 1)) ||" " || strip(publication_date);

    if substr(strip(kq),1,3) = "KQ2" then 
        output outdata.study_KQ2;
    else if substr(strip(kq),1,3) = "KQ1" then do;
       output study_list2;
    end;

	output allstudies;
run;

proc sort data = allstudies out=check_allstudies dupout = _checkdups nodupkey;
	by study;
run;
************************************************************************************************
** check frequencies of exclusion
************************************************************************************************;
title3 "check number of topiramate or phentermine only studies";
proc freq data= allstudies ;
   tables flag_tponly   / list missing;
run;
proc freq data= allstudies;
   tables design_not_elig * flag_tponly * design_not_elig_reas
   / list missing;
run;


************************************************************************************************
** clean variables;
************************************************************************************************;
data study_list3;
	set study_list2 (keep = extraction_id design_study_name design_secondary);
	by extraction_id;

	* Extract follow-up info;
	array invars 			design_study_name 		design_secondary				;
	array outvars $100.  	design_study_name_fu	design_secondary_fu			;

	re = prxparse('/\[Follow-up:\s*(.*?)\]/');

    do i = 1 to dim(invars);
        if prxmatch(re, invars[i]) then do;
            call prxsubstr(re, invars[i], position, length);
            outvars[i] = substr(invars[i], position+12, length-13);
        end;
        else outvars[i] = ""; 
    end;
    drop position length i re;

run;

* Select studies for KQ1;
data  study_list4;
    merge 	study_list3
			study_list2 (drop = design_study_name design_secondary );
    by extraction_id;

	* convert to numeric study years;
	study_start_year_n = input(strip(study_start_year), best.);
	study_end_year_n = input(strip(study_end_year), best.);

	* Secondary studies;
	label flag_secondary = "Flag for secondary analysis studies";
	if index(design_secondary, "Yes")>0 then do;
		flag_secondary = 1; 
	end;
	else flag_secondary = 0;

	* Flag co-pubs;
	label flag_copub = "Copublication of RCT";
	* flag co-publication without any new data extracted or data extracted into the primary paper;
	if strip(citation_ID) in ("3200242" "3190732" "3190788" "3190762" "3190657" 
							"3190798" "3190755" "3190753" "3190780"
							"3190821") then flag_copub = 1;
	else flag_copub = 0;

	label flag_copub = "Additional copublication data extracted in this record";
	if strip(citation_ID) in ("3200242" "3190732" "3190788" "3190762" "3190657" 
							"3190798" "3190755" "3190753" "3190780" ) then 
	flag_copub_data = 0;
	else if flag_copub = 1 then flag_copub_data = 1;

	label flag_include = "KQ1: Flag for studies included for T1";
	if flag_copub_data ne 0 and flag_tponly = 0  then flag_include = 1;
	else flag_include = 0;

    * selection criteria;
    array critvar       design_crit_journal design_crit_ctgov design_crit_csr design_crit_other;
    array critvar_new $50.  design_crit_journal_new design_crit_ctgov_new design_crit_csr_new design_crit_other_new;

    do i = 1 to dim(critvar);
        if index(critvar[i], "2% of participants")>0 then critvar_new[i] = "ge 2% of participants";
        else if index(critvar[i], "3% of participants")>0 then critvar_new[i] = "ge 3% of participants";
        else if index(critvar[i], "5% of participants")>0 then critvar_new[i] = "ge 5% of participants";
        else if index(critvar[i], "10% of participants")>0 then critvar_new[i] = "ge 10% of participants";
        else if index(critvar[i], "Other")>0 then critvar_new[i] = "Other";
        else critvar_new[i] = "";
    end;

    * hardcode for special cases;
    if extraction_id = "63750" then design_crit_journal_new = "ge 3%/5% of participants";

	drop i;
run;


************************************************************************************************
** Output final data;
************************************************************************************************;
data   	outdata.study_KQ1_include
		outdata.study_KQ1_rct
		outdata.study_KQ1_rct_include
        outdata.study_KQ1_non_rct
        outdata.study_KQ1_not_elig
        outdata.study_KQ1_pooled_no_new
		outdata.study_KQ1_all;
	set study_list4;

	if flag_include = 1 and flag_crossover= 0 then flag_meta_ana = 1; else flag_meta_ana = 0;

	output outdata.study_kq1_all;
    if strip(design_not_elig) = "Yes" then do;
        output outdata.study_KQ1_not_elig;
        delete;
    end;
    
    if strip(design_pooled_new) = "No" then do;
        output outdata.study_KQ1_pooled_no_new;
        delete;
    end;

	* RCT specific;
	if extraction_id = "60656" then do; * Nino 2018 - randomized albiglutide vs placebo, drugs of interest Lira is a non-RCT arm;
		flag_rct = 0;
		output outdata.study_KQ1_non_rct;
	end;
	* 60646: study analyzed portion included both randomized and non-randomized - we will only use the randomized portion for meta-analysis ;
    else if strip(design_analysis) = "RCT" or compress(extraction_id) = "60646" then do;
		flag_rct = 1;
	    output outdata.study_KQ1_rct;
		if flag_include = 1 then output outdata.study_KQ1_rct_include;
	end;
    else do; 
		flag_rct = 0;
		output outdata.study_KQ1_non_rct;
	end;

	if flag_include = 1 then output outdata.study_KQ1_include;
run;

************************************************************************************************
** check steps by steps numbers
************************************************************************************************;
proc sort data=outdata.study_kq1_all (where=(design_not_elig="No" and flag_tponly ne 1)) out= number_records_included;
	by extraction_id;
run;
* 133 obs from above - add 1 study for kq2 - so the total number of included records is 134;

title3 "number of records that are co-publications with no new data of interest or events extracted to the primary records";
proc freq data= number_records_included;
   tables flag_copub_data / list missing;
run;
proc sort data= number_records_included (where=(flag_copub_data ne 0)) out = number_records_newdata;
	by extraction_id;
run;
* 124 records - add 1 study for kq2 - so the total number of included records is 125;

proc freq data=number_records_newdata ;
   tables flag_include* design_pooled_new
   / list missing;
run;
* subtract 6 studies with no new data - so the total number would be 119 - 1 for kq2 and 118 for kq1;


************************************************************************************************
** output data
************************************************************************************************;

ods rtf file="&outdir.&progname..rtf" ;
footnote "Outputs generated from &progname..sas";
title "Inclusion";
proc contents data = outdata.study_KQ1_include  varnum;
run;

title3 "";
proc freq data= outdata.study_KQ1_include;
   tables design_actual * design_analysis   / list missing;
run; 
title3;
proc freq data= outdata.study_KQ1_rct;
   tables flag_include 
   / list missing;
run;

title3 "Freq on all the flags";
proc freq data = outdata.study_KQ1_include;
    table design: flag:/ list missing;
run;
title3;
ods rtf close;