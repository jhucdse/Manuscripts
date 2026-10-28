/**************************************************************************************
 * Progname: 02_inc_outcome.sas
 * Purpose: Harmonize respiratory outcomes, follow-up categories, and arm-level event data
 * Date: 2025-02-24
 * Author: Lijuan Zeng
 * Notes: 
 * 	 
 ***************************************************************************************/
%include "S:/lzeng3/ALA_SRMA/prog/00_utility.sas";
    
* Set up the environment;
options nocenter nonumber; /*nodate*/
%global progname;
%let progname=%str(02_inc_outcome);


************************************************************************************************;
** Flag arms in a study-level dataset;
************************************************************************************************;

proc sort data=outdata.study_kq1_rct_include out=kq1_include ;
	by extraction_id;
run;

* Bring in Outcome details page and clean variables for the included studies;
proc sort data=outdata.outcome_details out=outcome_details ;
	by extraction_id;
run;
proc sort data=outdata.outcomes out=outcomes ;
	by extraction_id;
run;
proc sort data=outdata.cat_stat out=results ;
	by extraction_id;
run;

* Merge to keep only MA studies;
data outcome_details1;
	merge 	kq1_include (in=A keep=extraction_id flag_meta_ana study) 
			outcome_details;
	by extraction_id;

	* only keep included KQ1 studies and non-crossover;
	if a=1 and flag_meta_ana = 1;

	if index(outcome_source, "Journal article")>0 then source_journal = 1; else source_journal = 0;
	if index(outcome_source, "CSR")>0 then source_csr = 1; else source_csr = 0;
	if index(outcome_source, "Clinicaltrials")>0 then source_ctgov = 1; else source_ctgov = 0;

	if strip(outcome_SAE) = "Not an SAE" then SAE = 0;  
	else if extraction_id = "60687" and missing(outcome_SAE) then SAE = 0;
	else SAE = 1;
run;

* If there are multiple timepoints there would be multiple outcome details entry per term - de-duplicates here;
proc sort data = outcome_details1 out = outcome_details1_nd dupout=_outdups nodupkey;
	by extraction_id outcome_cat outcome_term outcome_source outcome_SAE ;
run;
proc freq data= outcome_details1_nd;
   tables SAE * outcome_SAE  / list missing;
run;

* Merge outcome_details and results to flag corresponding outcomes;
proc sort data = outcome_details1_nd; 
	by extraction_id outcome_cat outcome_term;
run;
proc sort data = results;
	by extraction_id outcome_cat outcome_Term;
run;
data results_details;
	merge 	results
			outcome_details1_nd (keep = extraction_id outcome_cat outcome_Term outcome_sae source: SAE);
	by extraction_id outcome_cat outcome_Term;
run;

* Clean up outcome_Term variables and re-assign categories;
data 	results_details1 
		results_delete;
	merge 	kq1_include (in=A keep=extraction_id flag_meta_ana study) 
			results_details (in=B rename=(outcome_term = _outcome_term));
	by extraction_id;

	* only keep included KQ1 studies and non-crossover;
	if a=1 and b=1 and flag_meta_ana = 1;

	* hardcode the terms with special characters or spaces;
	if extraction_id = "60385" and index(_outcome_Term, "Pneumonia")>0 then _outcome_Term = "Pneumonia";
	else if extraction_id = "60650" and index(_outcome_Term, "Bronchitis")>0 then _outcome_term = "Bronchitis";
	else if extraction_id = "67086" and index(_outcome_term, "Viral upper respiratory tract infection (SAE)")>0 then _outcome_Term = "Viral upper respiratory tract infection (SAE)";
	else if extraction_id = "77548" and missing(_outcome_term) then _outcome_Term = "Pneumonia";

	* hardcode some typos;
	/* * Gough 2014 - typos corrected in the SRDR data;
	if extraction_id = "60431" and _outcome_term = "Nasopharyngitis" and compress(timepoint)="52" then do;
		arm1_total_n = "412"; arm1_events = "55";
		arm2_total_n = "412"; arm2_events = "52";
		arm3_total_n = 825; arm3_events = 115;
	end;
	*/

	* Clean up outcome_Term variables;
	length outcome_term $100.;
	if index(_outcome_term, "Influenza")>0 then outcome_term = "Influenza";
	else do;
		outcome_term = strip(tranwrd(_outcome_Term, "(SAE)", ""));
		outcome_term = strip(tranwrd(outcome_term, "(non-SAE)", ""));
	end;

	* Assign categories;
	length outcome_l1 outcome_l2 $100.;
	** Cough;
	if strip(outcome_term) in ("Cough, cold symptoms", "Productive cough", "Cough") then outcome_l2 = "Cough";
	else if strip(outcome_term) = "Allergic cough" then outcome_l2 = "Cough, allergic";
	** Asthma exacerbation;
	else if strip(outcome_Term) = "Asthma Exacerbation" then outcome_l2 = "Asthma exacerbation";
	** Depression;
	else if strip(outcome_term) in ("Depression") then outcome_l2 = "Depression";
	** Bronchitis;
	else if strip(outcome_term) = "Bronchitis" then outcome_l2 = "LRTI: Bronchitis";
	else if strip(outcome_term) in ("Acute bronchitis", "Bronchitis acute") then outcome_l2 = "LRTI: Bronchitis, acute";
	else if strip(outcome_term) in ("Allergic bronchitis", "Bronchitis allergic") then outcome_l2 = "LRTI: Bronchitis, allergic";
	else if strip(outcome_term) in ("Chronic bronchitis", "Bronchitis chronic") then outcome_l2 = "LRTI: Bronchitis, chronic";
	else if strip(outcome_term) in ("Bronchitis viral", "Viral bronchitis") then outcome_l2 = "LRTI: Bronchitis, viral";
	else if strip(outcome_term) in ("Bronchitis bacterial", "Bacterial bronchitis") then outcome_l2 = "LRTI: Bronchitis, bacterial";
	** Pneumonia;
	else if strip(outcome_term) in ("Pneumonia") then outcome_l2 = "LRTI: Pneumonia";
	else if strip(outcome_term) in ("Pneumonia bacterial", "Pneumonia klebsiella", "Pneumonia legionella", 
			"Pneumonia pneumococcal", "Pneumonia pseudomonal", "Pneumonia staphylococcal", "Enterobacter pneumonia", "Pneumonia haemophilus") 
			then outcome_l2 = "LRTI: Pneumonia, bacterial";
	else if strip(outcome_term) in ("Pneumonia viral", "Viral pneumonia", "Pneumonia influenzal", 
			"Pneumonia respiratory syncytial viral", "COVID-19 pneumonia") 
			then outcome_l2 = "LRTI: Pneumonia, viral";
	else if strip(outcome_term) in ("Pneumonia organising", "Organising pneumonia") then outcome_l2 = "LRTI: Pneumonia, organising";
	else if strip(outcome_term) in ("Pneumonia aspiration") then outcome_l2 = "LRTI: Pneumonia, aspiration";
	else if strip(outcome_term) in ("Pneumonia atypical" "Atypical pneumonia") then outcome_l2 = "LRTI: Pneumonia, atypical";
	else if strip(outcome_term) in ("Pneumonia lobar" "Lobar pneumonia") then outcome_l2 = "LRTI: Pneumonia, lobar";
	else if strip(outcome_term) in ("Bronchopneumonia") then outcome_l2 = "LRTI: Bronchopneumonia";
	** Influenza;
	else if strip(outcome_term) in ("Influenza") then outcome_l2 = "LRTI: Influenza";
	** LRTI;
	else if strip(outcome_term) in ("Lower respiratory tract infection") then outcome_l2 = "LRTI: Location not noted";
	else if strip(outcome_term) in ("Lower respiratory tract infection viral", "Viral lower respiratory tract infection") then outcome_l2 = "LRTI: Location not noted, viral";
	else if strip(outcome_term) in ("Lower respiratory tract infection bacterial") then outcome_l2 = "LRTI: Location not noted, bacterial";
	** URTI;
	else if strip(outcome_term) in ("Upper respiratory tract infection") then outcome_l2 = "URTI: Location not noted";
	else if strip(extraction_id) in ("60697" "60716") and index(upcase(outcome_Term), "UPPER RESPIRATORY")>0 then outcome_l2 = "URTI: Location not noted";
	else if strip(outcome_term) in ("Upper respiratory tract infection viral", "Viral upper respiratory tract infection") then outcome_l2 = "URTI: Location not noted, viral";
	else if strip(outcome_term) in ("Upper respiratory tract infection bacterial", "Bacterialupper respiratory tract infection") then outcome_l2 = "URTI: Location not noted, bacterial";
	** Rhinitis;
	else if strip(outcome_term) in ("Rhinitis") then outcome_l2 = "URTI: Rhinitis";
	else if strip(outcome_term) in ("Rhinitis allergic", "Allergic rhinitis") then outcome_l2 = "URTI: Rhinitis, allergic";
	else if strip(outcome_term) in ("Rhinitis viral", "Viral rhinitis") then outcome_l2 = "URTI: Rhinitis, viral";
	else if strip(outcome_term) in ("Rhinitis seasonal", "Seasonal rhinitis") then outcome_l2 = "URTI: Rhinitis, seasonal";
	** Sinusitis;
	else if strip(outcome_term) in ("Sinusitis") then outcome_l2 = "URTI: Sinusitis";
	else if strip(outcome_term) in ("Sinusitis acute", "Acute sinusitis") then outcome_l2 = "URTI: Sinusitis, acute";
	else if strip(outcome_term) in ("Sinusitis chronic", "Chronic sinusitis") then outcome_l2 = "URTI: Sinusitis, chronic";
	else if strip(outcome_term) in ("Sinusitis viral", "Viral sinusitis") then outcome_l2 = "URTI: Sinusitis, viral";
	else if strip(outcome_term) in ("Sinusitis bacterial", "Bacterial sinusitis") then outcome_l2 = "URTI: Sinusitis, bacterial";
	else if strip(outcome_term) in ("Allergic sinusitis") then outcome_l2 = "URTI: Sinusitis, allergic";
	** Nasopharyngitis;
	else if strip(outcome_term) in ("Rhinopharyngitis", "Nasopharyngitis") then outcome_l2 = "URTI: Nasopharyngitis";
	** Pharyngitis;
	else if strip(outcome_term) in ("Pharyngitis") then outcome_l2 = "URTI: Pharyngitis";
	else if extraction_id = "60632" and index(outcome_term, "pharyngitis")>0 then outcome_l2 = "URTI: Pharyngitis";
	else if strip(outcome_term) in ("Pharyngitis viral", "Viral pharyngitis") then outcome_l2 = "URTI: Pharyngitis, viral";
	else if strip(outcome_term) in ("Pharyngitis bacterial", "Bacterial pharyngitis", "Pharyngitis streptococcal") then outcome_l2 = "URTI: Pharyngitis, bacterial";
	else if strip(outcome_term) in ("Pharyngitis acute", "Acute pharyngitis") then outcome_l2 = "URTI: Pharyngitis, acute";
	else if strip(outcome_term) in ("Pharyngitis chronic", "Chronic pharyngitis") then outcome_l2 = "URTI: Pharyngitis, chronic";
	else if strip(outcome_term) in ("Allergic pharyngitis", "Pharyngitis allergic") then outcome_l2 = "URTI: Pharyngitis, allergic";
	** Laryngitis;
	else if strip(outcome_term) in ("Laryngitis") then outcome_l2 = "URTI: Laryngitis";
	else if strip(outcome_term) in ("Laryngitis viral", "Viral laryngitis") then outcome_l2 = "URTI: Laryngitis, viral";
	else if strip(outcome_term) in ("Laryngitis bacterial", "Bacterial laryngitis") then outcome_l2 = "URTI: Laryngitis, bacterial";
	** Tuberculosis;
	else if index(upcase(outcome_Term), "TUBERCULOSIS")>0 then outcome_l2 = "LRTI: Tuberculosis";
	** Respiratory tract infection;
	else if strip(outcome_term) in ("Respiratory tract infection") then outcome_l2 = "RTI: Location not noted";
	else if strip(outcome_term) in ("Respiratory tract infection viral", "Viral respiratory tract infection") then outcome_l2 = "RTI: Location not noted, viral";
	else if strip(outcome_term) in ("Respiratory tract infection bacterial") then outcome_l2 = "RTI: Location not noted, bacterial";	
	else if strip(outcome_Term) = "Upper-airway cough syndrome" then outcome_l2 = "Cough";

	else if strip(outcome_term) in ("Upper respiratory tract congestion", "Upper respiratory tract inflammation",
				"Asthma", "Breathing problems", "Respiratory disorder", "Respiratory tract congestion") then do;
				outcome_l2 = "Other respiratory harms";
				outcome_l1 = "Other respiratory harms";
	end;

	if outcome_l2 = "Depression" then outcome_l1 = "Mental health";
	else if index(outcome_l2, "Cough")>0 then outcome_l1 = "Cough";
	else if index(outcome_l2, "URTI")>0 then outcome_l1 = "Upper respiratory tract infection (URTI)";
	else if index(outcome_l2, "LRTI")>0 then outcome_l1 = "Lower respiratory tract infection (LRTI)";
	else if index(outcome_l2, "RTI")>0 then outcome_l1 = "Respiratory tract infection (RTI)";
	else if outcome_l2 = "Asthma exacerbation" then outcome_l1 = "Exacerbations";
	else if missing(outcome_l1) then outcome_l1 = strip(outcome_cat);

	* create a numeric temporary var for sorting in the next proc sort step;
	arm1_events_n = input(strip(arm1_events), best.);
	arm2_events_n = input(strip(arm2_events), best.);
	events_n_sorting = sum(arm1_events_n, arm2_events_n);
	

	* 2025-03-06 meeting - decided to drop the following since they may not be respiratory specific or not related to KQ1;
	if outcome_l2 in ("LRTI: Influenza", "COVID-19", "Depression") or strip(outcome_term)="COVID-19" then do;
		output results_delete;
		delete;
	end;
	else output results_details1;
run;


proc freq data= results_details1;
   tables outcome_l1 * outcome_l2
   / list missing;
run;
title3 "Review extracted and coded terms";
proc freq data= results_details1;
   tables outcome_l2 * outcome_term   / list missing;
run;
title3;


************************************************************************************************;
* For the same outcome_Term, if there are both SAE and non-SAE, use non-SAE as the primary (variable SAE 0 or 1);
* 2025-03-08 - updated to use descending events counts as some studies SAE numbers are higher than non-SAEs;
proc sort data = results_details1 out=results1_sort;
	by extraction_id outcome_term timepoint descending events_n_sorting ;
run;

proc sort data = results1_sort out=results1_first dupout=results1_nonfirst nodupkey;
	by extraction_id outcome_Term timepoint;
run; 

data _null_;
	set results1_sort;
	by extraction_id outcome_term timepoint;

	if not (first.timepoint and last.timepoint) then put "WARNING: review " extraction_id = outcome_Term= timepoint= SAE = arm1_events= arm2_events= /;
run;


data results1_sort0;
	set results1_first(in=first)
		results1_nonfirst;
	if first=1 then results_primary = 1;
	/*
	* hardcode for Nissen 2016 - AE does not include SAE from ctgov;
	if extraction_id = "66931" and outcome_l2 = "LRTI: Pneumonia" then do;
		if SAE= 1 then results_primary = 1;
		else results_primary = .;
	end;
	*/
run;
proc sort data = results1_sort0;
	by extraction_id outcome_cat outcome_term descending results_primary;
run;

************************************************************************************************;
* Check if there are duplicates per study per outcome_l2;
* For duplicates per study/timepoint/term, we keep the records with the highest numbers of events for analysis;
* records noted in 02_inc_outcome_dupterms.txt;
proc sort data = results1_sort0(where=(results_primary = 1)) out = results1_sort1;
	/* REVIEW R06: Imported arm1_events/arm2_events are character fields here.
	   Check numeric ordering for the highest-event duplicate-selection rule. */
	by extraction_id timepoint outcome_l2 descending arm1_events descending arm2_events;
run;
data results1_sort2;
	set results1_sort1;
	by extraction_id timepoint outcome_l2;

	if not (first.outcome_l2 and last.outcome_l2) then put "WARNING: Duplicates " extraction_id = timepoint= outcome_l2 = outcome_term= SAE= arm1_events=/;

	if first.outcome_l2 and last.outcome_l2 then results_unique = 1;
	else if first.outcome_l2 then results_unique = 1;
	else results_unique = 0;
run;

proc sort data = results1_sort2(where=(results_unique=1)) out=results1_unique;
	by extraction_id timepoint outcome_l2;
run;

* Include back SAE records;
data results1;
	set results1_unique
		results1_sort0(where=(results_primary ^= 1));
run;


************************************************************************************************;
* Re-organize the data into long format;
%let keepvar = %str(extraction_id citation_name authors publication_date study kq outcome_l1 outcome_l2 results_primary outcome_sae sae source:
	population timepoint unit);
proc sort data=results1 ;
	by &keepvar.;
run;

* clean and stack one by one;
data results_arm1;
	set results1 (keep=&keepvar. arm1_: rename=(arm1_name=name arm1_text=text arm1_total_n=_total_n arm1_total_events=total_events
		arm1_events=_events arm1_perc=_perc arm1_ir_100=_ir_100 arm1_ir_1000=ir_1000 arm1_n_gt1episode=n_gt1episode
		arm1_ir_100expy=ir_100expy arm1_ir_100py=ir_100py arm1_ir_1py=ir_1py));
	if not missing(name);
	total_n = input(strip(_total_n), best.);
	events = input(strip(_events), best.);
	perc = input(strip(_perc), best.);
	ir_100 = input(strip(_ir_100), best.);
	drop _:;
run;

data results_arm2;
	set results1 (keep=&keepvar. arm2_: rename=(arm2_name=name arm2_text=text arm2_total_n=_total_n arm2_total_events=total_events
		arm2_events=_events arm2_perc=_perc arm2_ir_100=_ir_100 arm2_ir_1000=ir_1000 arm2_n_gt1episode=n_gt1episode
		arm2_ir_100expy=ir_100expy arm2_ir_100py=ir_100py arm2_ir_1py=ir_1py	arm2_ir_1000pm=_ir_1000pm));
	if not missing(name);
	total_n = input(strip(_total_n), best.);
	events = input(strip(_events), best.);
	perc = input(strip(_perc), best.);
	ir_100 = input(strip(_ir_100), best.);
	ir_1000pm = input(strip(_ir_1000pm), best.);
	drop _:;
run;

data results_arm3;
	set results1 (keep=&keepvar. arm3_: rename=(arm3_name=name arm3_text=text arm3_total_n=total_n arm3_total_events=total_events
		arm3_events=_events arm3_perc=_perc arm3_ir_100=_ir_100 arm3_ir_1000=_ir_1000 arm3_n_gt1episode=_n_gt1episode
		arm3_ir_100expy=_ir_100expy arm3_ir_100py=ir_100py arm3_ir_1py=_ir_1py	arm3_ir_1000pm=_ir_1000pm));
	if not missing(name);
	*total_n = input(strip(_total_n), best.);
	events = input(strip(_events), best.);
	perc = input(strip(_perc), best.);
	ir_100 = input(strip(_ir_100), best.);
	ir_1000 = input(strip(_ir_1000), best.);
	n_gt1episode = input(strip(_n_gt1episode), best.);
	ir_100expy = input(strip(_ir_100expy), best.);
	ir_1py = input(strip(_ir_1py), best.);
	ir_1000pm = input(strip(_ir_1000pm), best.);
	drop _:;
run;

data results_arm4;
	set results1 (keep=&keepvar. arm4_: rename=(arm4_name=name arm4_text=text arm4_total_n=total_n arm4_total_events=total_events
		arm4_events=_events arm4_perc=_perc arm4_ir_100=ir_100 arm4_ir_1000=_ir_1000 arm4_n_gt1episode=_n_gt1episode
		arm4_ir_100expy=_ir_100expy arm4_ir_100py=_ir_100py arm4_ir_1py=_ir_1py	arm4_ir_1000pm=_ir_1000pm));
	if not missing(name);
	*total_n = input(strip(_total_n), best.);
	events = input(strip(_events), best.);
	perc = input(strip(_perc), best.);
	ir_1000 = input(strip(_ir_1000), best.);
	n_gt1episode = input(strip(_n_gt1episode), best.);
	ir_100expy = input(strip(_ir_100expy), best.);
	ir_100py = input(strip(_ir_100py), best.);
	ir_1py = input(strip(_ir_1py), best.);
	ir_1000pm = input(strip(_ir_1000pm), best.);
	drop _:;
run;

data results_arm5;
	set results1 (keep=&keepvar. arm5_: rename=(arm5_name=name arm5_text=text arm5_total_n=total_n arm5_total_events=total_events
		arm5_events=_events arm5_perc=_perc arm5_ir_100=ir_100 arm5_ir_1000=_ir_1000 arm5_n_gt1episode=_n_gt1episode
		arm5_ir_100expy=_ir_100expy arm5_ir_100py=_ir_100py arm5_ir_1py=_ir_1py	arm5_ir_1000pm=_ir_1000pm));
	if not missing(name);
	*total_n = input(strip(_total_n), best.);
	events = input(strip(_events), best.);
	perc = input(strip(_perc), best.);
	ir_1000 = input(strip(_ir_1000), best.);
	n_gt1episode = input(strip(_n_gt1episode), best.);
	ir_100expy = input(strip(_ir_100expy), best.);
	ir_100py = input(strip(_ir_100py), best.);
	ir_1py = input(strip(_ir_1py), best.);
	ir_1000pm = input(strip(_ir_1000pm), best.);
	drop _:;
run;

data results_arm6;
	set results1 (keep=&keepvar. arm6_: rename=(arm6_name=name arm6_text=text arm6_total_n=total_n arm6_total_events=total_events
		arm6_events=_events arm6_perc=_perc arm6_ir_100=_ir_100 arm6_ir_1000=_ir_1000 arm6_n_gt1episode=_n_gt1episode
		arm6_ir_100expy=_ir_100expy arm6_ir_100py=_ir_100py arm6_ir_1py=_ir_1py	arm6_ir_1000pm=_ir_1000pm));
	if not missing(name);
	*total_n = input(strip(_total_n), best.);
	events = input(strip(_events), best.);
	perc = input(strip(_perc), best.);
	if extraction_id = "60667" then do;
		if index(_ir_100,"<0.1")>0 then ir_100 = 0.05;
	end;
	else ir_100 = input(strip(_ir_100), best.);
	ir_1000 = input(strip(_ir_1000), best.);
	n_gt1episode = input(strip(_n_gt1episode), best.);
	ir_100expy = input(strip(_ir_100expy), best.);
	ir_100py = input(strip(_ir_100py), best.);
	ir_1py = input(strip(_ir_1py), best.);
	ir_1000pm = input(strip(_ir_1000pm), best.);
	drop _:;
run;

data results_arm7;
	set results1 (keep=&keepvar. arm7_: rename=(arm7_name=name arm7_text=text arm7_total_n=total_n arm7_total_events=total_events
		arm7_events=_events arm7_perc=_perc arm7_ir_100=_ir_100 arm7_ir_1000=_ir_1000 arm7_n_gt1episode=_n_gt1episode
		arm7_ir_100expy=_ir_100expy arm7_ir_100py=_ir_100py arm7_ir_1py=_ir_1py	arm7_ir_1000pm=_ir_1000pm));
	if not missing(name);
	*total_n = input(strip(_total_n), best.);
	events = input(strip(_events), best.);
	perc = input(strip(_perc), best.);
	ir_100 = input(strip(_ir_100), best.);
	ir_1000 = input(strip(_ir_1000), best.);
	n_gt1episode = input(strip(_n_gt1episode), best.);
	ir_100expy = input(strip(_ir_100expy), best.);
	ir_100py = input(strip(_ir_100py), best.);
	ir_1py = input(strip(_ir_1py), best.);
	ir_1000pm = input(strip(_ir_1000pm), best.);
	drop _:;
run;

data results_arm8;
	set results1 (keep=&keepvar. arm8_: rename=(arm8_name=name arm8_text=text arm8_total_n=total_n arm8_total_events=total_events
		arm8_events=_events arm8_perc=_perc arm8_ir_100=_ir_100 arm8_ir_1000=_ir_1000 arm8_n_gt1episode=_n_gt1episode
		arm8_ir_100expy=_ir_100expy arm8_ir_100py=_ir_100py arm8_ir_1py=_ir_1py	arm8_ir_1000pm=_ir_1000pm));
	if not missing(name);
	*total_n = input(strip(_total_n), best.);
	events = input(strip(_events), best.);
	perc = input(strip(_perc), best.);
	ir_100 = input(strip(_ir_100), best.);
	ir_1000 = input(strip(_ir_1000), best.);
	n_gt1episode = input(strip(_n_gt1episode), best.);
	ir_100expy = input(strip(_ir_100expy), best.);
	ir_100py = input(strip(_ir_100py), best.);
	ir_1py = input(strip(_ir_1py), best.);
	ir_1000pm = input(strip(_ir_1000pm), best.);
	drop _:;
run;

data results_arm9;
	set results1 (keep=&keepvar. arm9_: rename=(arm9_name=name arm9_text=text arm9_total_n=total_n arm9_total_events=total_events
		arm9_events=_events arm9_perc=_perc arm9_ir_100=_ir_100 arm9_ir_1000=_ir_1000 arm9_n_gt1episode=_n_gt1episode
		arm9_ir_100expy=_ir_100expy arm9_ir_100py=_ir_100py arm9_ir_1py=_ir_1py	arm9_ir_1000pm=_ir_1000pm));
	if not missing(name);
	*total_n = input(strip(_total_n), best.);
	events = input(strip(_events), best.);
	perc = input(strip(_perc), best.);
	ir_100 = input(strip(_ir_100), best.);
	ir_1000 = input(strip(_ir_1000), best.);
	n_gt1episode = input(strip(_n_gt1episode), best.);
	ir_100expy = input(strip(_ir_100expy), best.);
	ir_100py = input(strip(_ir_100py), best.);
	ir_1py = input(strip(_ir_1py), best.);
	ir_1000pm = input(strip(_ir_1000pm), best.);
	drop _:;
run;

data results_arm10;
	set results1 (keep = &keepvar. arm10_: );
	if not missing(arm10_name);
run;
* Note: arm10 is All arms combined - disregard;

* Stack all arms;
data results_long (rename=(name=arms_name));
	set results_arm1 	results_arm2	results_arm3	results_arm4	results_arm5
		results_arm6	results_arm7	results_arm8	results_arm9;
	if strip(name) not in ("Total") and not missing(total_n);

	if missing(events) and cmiss(total_n, perc)=0 then events = total_n * perc / 100;
run;

proc sort data = results_long out=outdata.kq1_inc_rct_results_long;
	by &keepvar. arms_name text;
run;



************************************************************************************************;
* Merge arms_details and results_long to keep data from arms of interst;
proc sort data = outdata.kq1_inc_rct_arms_details out = arms;
	by extraction_id arms_name;
run;
proc sort data = outdata.kq1_inc_rct_arms_details_pbo out = arms_pbo;
	by extraction_id arms_name;
run;
data arms_all;
	set arms
		arms_pbo;
run;
proc sort data=arms_all; 
	by extraction_id arms_name;
run;

proc freq data= arms;
   tables arms_name   / list missing;
run;
proc sort data = outdata.kq1_inc_rct_results_long out = results_l;
	by extraction_id arms_name;
run;
proc freq data= results_l;
   tables arms_name   / list missing;
run;

data results_l_arms;
	merge 	arms_all (in=A keep = extraction_id arms_name drug_dose drug_g:)
			results_l (in=B);
	by extraction_id arms_name;

	if A and B;

	if cmiss(events, total_n)>0 then 
	put "WARNING: review data " extraction_id  arms_name= outcome_l2 = events= total_n = /;

	* clean up time points;
	label time = "Timepoint (months)";
	label timec = "Timepoint";
	length timec timec2 $50.;
	if missing(unit) and extraction_id = "60400" then unit = "wk";

	if strip(unit) = "wk" then do;
		if index(timepoint,"12")>0 or index(timepoint,"14")>0 then do; time = 3; timec = "3 months"; end;
		else if index(timepoint,"16")>0 or index(timepoint,"17")>0 then do; time = 4; timec = "4 months"; end;
		else if strip(timepoint) in ("24" "26" "26 wks plus 30 days follow-up" "27" "28") or 
			index(timepoint,"24")>0 or index(timepoint,"26")>0 or index(timepoint,"27")>0  or index(timepoint,"28")>0 
			then do; 
				time = 6; timec = "6 months"; 
		end;
		else if strip(timepoint) in ("30" "31" "32" "34" "35" "36" "40" "44" "46") or index(timepoint,"30")>0  or index(timepoint,"40")>0  
			or index(timepoint,"31")>0 or index(timepoint,"34")>0
			then do; 
				time = 9; timec = "9 months"; 
		end;
		else if strip(timepoint) in ("48" "52" "54" "56" "57" "58" "0-56" "60" ) or index(timepoint,"52")>0 or index(timepoint,"54")>0 
			or index(timepoint,"56")>0 or index(timepoint,"57")>0 or index(timepoint,"58")>0 or index(timepoint,"59")>0 or index(timepoint,"60")>0 
			then do; 
				time = 12; timec = "12 months"; 
		end;
		else if strip(timepoint) in ("64" "68" "72" "75") or index(timepoint,"64")>0 or index(timepoint,"68")>0 or index(timepoint,"72")>0
			or index(timepoint,"75")>0
			then do; 
				time = 15; timec = "15 months"; 
		end;
		else if strip(timepoint) in ("78" "80") or index(timepoint, "78")>0 or index(timepoint,"80")>0  then do;
			time = 18; timec = "18 months";
		end;
		else if strip(timepoint) in ("104" "109") then do; 
			time=24; timec = "24 months"; 
		end;
	end;
	else if strip(unit) = "mo" then do;
		if index(timepoint, "24") >0 then do; 
			time = 24; timec = "24 months";
		end;
		else if index(timepoint, "60") >0 then do;
			time = 60; timec = "> 24 months";
		end;
	end;
	else if strip(unit) = "d" then do;
		if index(timepoint,"85")>0 then do; time = 3; timec = "3 months"; end;
		else put "WARNING: to add " extraction_id=  timepoint = unit = /;
	end;
	else if strip(unit) = "year" then do;
		if index(timepoint, "2")>0 then do; time = 24; timec = "24 months"; end;
		else put "WARNING: to add " extraction_id=  timepoint = unit = /;
	end;

	* Code specific studies;
	if extraction_id = "66931" then do; * Nissen 2016 - max follow up 4 years but the study was terminated early ~ 3 years after FPI;
		time = 36; timec = "> 24 months";
	end;
	else if extraction_id="60667" then do; * Pi-Sunyer 2015 - report lira total group - CSR reported week 56 and journal 58 weeks for same outcome - use CSR results;
		if index(timepoint,"58")>0 then do;
			flag_timepoint_drop = 1; 
		end;
		else if index(timepoint, "56")>0 then do;
			time = 12; timec = "12 months";
		end;
	end;
	else if extraction_id = "60380" then do; * Buse 2019 - report by period which we do not need;
		if strip(timepoint) in ("26-40" "26-78") then flag_timepoint_drop = 1; 
	end;
	else if extraction_id = "60727" then do; * Wilding 2021;
		if index(timepoint, "68")>0 then flag_timepoint_Drop = 1; * w68 reported in manuscript and the rest w75 from ctgov - same numbers so drop one;
	end;

	/* REVIEW R05: SAS missing numeric time satisfies time le 6.
	   Confirm all retained timepoints are mapped before interpreting categories. */
	if time le 6 then do; timec2 = "0-6 months"; timec2_n=1; end;
	else if time le 12 then do; timec2 = "7-12 months"; timec2_n=2; end;
	else if time le 24 then do; timec2 = "13-24 months"; timec2_n=3; end;
	else do; timec2 = "> 24 months"; timec2_n=4; end;
run;
proc freq data=results_l_arms (where=(flag_timepoint_drop ne 1));
   tables timec timec * timepoint * unit 
			drug_group0 * timec * timepoint * unit   / list missing;
run;			
proc freq data=results_l_arms (where=(flag_timepoint_drop ne 1));
   tables drug_group0 * timec  drug_group0 * timec2
		/ list missing;
run;

* Check if there are any duplicates;
proc sort data = results_l_arms (where=(flag_timepoint_drop ne 1)) out=kq1_inc_rct_results_l_arms_st ;
	by extraction_id outcome_l2 drug_dose arms_name timec descending results_primary;
run;

title3 "check if there are duplicates and the results_primary should be used if duplicates exist";
proc sort data = kq1_inc_rct_results_l_arms_st out=kq1_inc_rct_results_l_arms dupout=_Checkdups nodupkey;
	by extraction_id outcome_l2 drug_dose arms_name timec;
run;
proc freq data=kq1_inc_rct_results_l_arms ;
   tables results_primary   / list missing;
run;
proc freq data= _checkdups;
   tables results_primary / list missing;
run;
title3;

proc sort data = results_l_arms (where=(flag_timepoint_drop ne 1)) 
	out=outdata.kq1_inc_rct_results_l_arms (label = "Created from &progname.");
	by extraction_id outcome_l2 time;
run;

************************************************************************************************;
** Combine same dosing within the study;
proc sort data=outdata.kq1_inc_rct_results_l_arms (where=(results_primary = 1)) out=dup_dose_studies dupout = xx nodupkey;
	by extraction_id outcome_l2 drug_dose timec;
run;
proc freq data= xx;
   tables extraction_id * drug_dose * arms_name  * outcome_l2 / list missing;
run;
/*
Extraction_ID drug_dose Arms_Name Frequency Percent Cumulative
Frequency Cumulative
Percent 
60631 Semaglutide 0.8 mg Semaglutide 0.8mg E 10 45.45 10 45.45 
60659 Semaglutide 0.3 mg Semaglutide 0.3 mg FE 5 22.73 15 68.18 
60659 Semaglutide 0.4 mg Semaglutide 0.4 mg FE 5 22.73 20 90.91 
60707 Liraglutide 3.0 mg Liraglutide 3 mg 2 9.09 22 100.00 
*/
/* REVIEW R07: This sums over timec2, omitting the original timepoint.
   Confirm no repeated participants/timepoints are counted within a category. */
proc means data= outdata.kq1_inc_rct_results_l_arms (where=(results_primary = 1))   noprint nway missing;
   class extraction_id drug_dose drug_group1 drug_group0 citation_name authors publication_Date study outcome_l1 outcome_l2 timec2 timec2_n;
   var total_n events;
   output out=kq1_inc_rct_results_l_arms_sum  (drop= _TYPE_ _FREQ_) sum=;
run;

data kq1_inc_rct_results_l_arms_sum2;
	set kq1_inc_rct_results_l_arms_sum;
	if cmiss(total_n, events)>0 then put "ERROR: missing " extraction_id total_n = events = /;
	label 	
			perc = "Proportion (%)";
	if cmiss(total_n, events)=0 then do;
		perc = round(events/total_n *100 , 0.1);
	end;

	studyarm = strip(study) || "-" || strip(drug_group1);
run;

proc sort data = kq1_inc_rct_results_l_arms_sum2
	out=outdata.kq1_inc_rct_results_l_arms_ndsty (label = "No duplicates by study/drugdose/time Created from &progname.");
	by extraction_id outcome_l2 timec2;
run;

proc freq data= outdata.kq1_inc_rct_results_l_arms_ndsty;
   tables drug_group0* drug_dose   / list missing;
run;


************************************************************************************************
** output data
************************************************************************************************;
ods rtf file="&outdir.&progname._checkterms.rtf" ;
footnote "Outputs generated from &progname..sas";

proc freq data= results_details1;
   tables outcome_l2 outcome_l1*outcome_l2
   / list missing;
run;
ods rtf close;

ods rtf file="&outdir.&progname..rtf" ;
footnote "Outputs generated from &progname..sas";
proc contents data=outdata.kq1_inc_rct_results_l_arms_ndsty  varnum; run;

proc freq data= outdata.kq1_inc_rct_results_l_arms_ndsty ;
   tables drug_group1 * timec2 * outcome_l2   / list missing nocum;
run;

ods rtf close;


ods rtf file="&outdir.&progname._bydrug.rtf"  ;
footnote "Outputs generated from &progname..sas";
title3 "Show number of studies";
proc freq data= outdata.kq1_inc_rct_results_l_arms_ndsty;
   tables drug_group0 * timec2   / list missing;
run;

proc freq data= outdata.kq1_inc_rct_results_l_arms_ndsty (where=(drug_group0 = "Liraglutide")) ;
   tables timec2 * outcome_l2 * drug_group1  /  missing nocum;
run;
title3;

proc freq data= outdata.kq1_inc_rct_results_l_arms_ndsty (where=(drug_group0 = "Semaglutide")) ;
   tables timec2 * outcome_l2 * drug_group1  /  missing nocum;
run;
proc freq data= outdata.kq1_inc_rct_results_l_arms_ndsty (where=(drug_group0 = "Tirzepatide")) ;
   tables timec2 * outcome_l2 * drug_group1  /  missing nocum;
run;
proc freq data= outdata.kq1_inc_rct_results_l_arms_ndsty (where=(drug_group0 = "Naltrexone/Bupropion")) ;
   tables timec2 * outcome_l2 * drug_group1  /  missing nocum;
run;
proc freq data= outdata.kq1_inc_rct_results_l_arms_ndsty (where=(drug_group0 = "Phentermine/Topiramate")) ;
   tables timec2 * outcome_l2 * drug_group1  /  missing nocum;
run;
proc freq data= outdata.kq1_inc_rct_results_l_arms_ndsty (where=(drug_group0 = "Setmelanotide")) ;
   tables timec2 * outcome_l2 * drug_group1  /  missing nocum;
run;
proc freq data= outdata.kq1_inc_rct_results_l_arms_ndsty (where=(drug_group0 = "Orlistat")) ;
   tables timec2 * outcome_l2 * drug_group1  /  missing nocum;
run;
ods rtf close;





************************************************************************************************
** Output frequencies - NUMBER OF STUDIES
************************************************************************************************;
proc sort data=outdata.kq1_inc_Rct_results_l_arms_ndsty out=study_timec2_drug ;
	by drug_Group0  drug_group1 study timec2_n;
run;

* Calculate mean median of sample size total_n;
proc sort data=outdata.kq1_inc_Rct_results_l_arms_ndsty out=_study_drug ;
	by drug_Group0  drug_group1 study timec2_n;
run;
proc sort data=_study_drug out=study_drug nodupkey;
	by drug_group0 drug_group1 study;
run;

* By drug-dose;
proc means data=study_drug    noprint nway missing;
   class  drug_group0 drug_group1;
   var total_n;
   output out=kq1_inc_rct_total_n  (drop= _TYPE_ _FREQ_) n=n_study 
   mean=mean_total_n  min=min_total_n max=max_total_n
   p25=p25_total_n median=median_total_n p75=p75_total_n sum=sum_total_n;
run;
data kq1_inc_Rct_total_n2;
	set kq1_inc_Rct_total_n;
	length median_IQR $100.;
	median_IQR = strip(put(median_total_n, best.)) || " [" || strip(put(p25_total_n, best.)) || "-" || strip(put(p75_total_n, best.)) || "]";
	nc = strip(put(n_study, best.));
	sum_total_nc = strip(put(sum_total_n, best.));
run;
proc sort data= kq1_inc_Rct_total_n2;
	by drug_group0 drug_group1;
run;
proc transpose data=kq1_inc_Rct_total_n2    out=kq1_inc_Rct_total_n_median (drop=_NAME_) ;
   by drug_group0 ;
   var median_iqr;
   id drug_Group1;
run;
proc transpose data=kq1_inc_Rct_total_n2    out=kq1_inc_Rct_total_n_n (drop=_NAME_) ;
   by drug_group0 ;
   var nc;
   id drug_Group1;
run;
proc transpose data=kq1_inc_Rct_total_n2    out=kq1_inc_Rct_total_n_sum(drop=_NAME_)  ;
   by  drug_group0;
   var sum_total_nc;
   id drug_Group1;
run;
* Stack values;
data stack_study_summ;
	set kq1_inc_rct_total_n_median (in=median)
		kq1_inc_rct_Total_n_n (in=nobs)
		kq1_inc_rct_total_n_sum (in=sum);
	length textv $100.;
	if median = 1 then do; textv = "Median sample size [IQR]"; text_ord = 2;end;
	else if nobs = 1 then do; textv = "Number of studies"; text_ord = 1; end;
	else if sum = 1 then do; textv = "Overall sample size"; text_ord = 3; end;
run;
proc sort data = stack_study_summ;
	by  drug_group0 text_ord;
run;

* By drug -total;
proc means data=study_drug    noprint nway missing;
   class  drug_group0;
   var total_n;
   output out=kq1_inc_rct_all  (drop= _TYPE_ _FREQ_) n=n_study 
   mean=mean_total_n  min=min_total_n max=max_total_n
   p25=p25_total_n median=median_total_n p75=p75_total_n sum=sum_total_n;
run;
data kq1_inc_Rct_all2;
	set kq1_inc_Rct_all;
	length median_IQR $100.;
	median_IQR = strip(put(median_total_n, best.)) || " [" || strip(put(p25_total_n, best.)) || "-" || strip(put(p75_total_n, best.)) || "]";
	nc = strip(put(n_study, best.));
	sum_total_nc = strip(put(sum_total_n, best.));
run;
proc sort data= kq1_inc_Rct_all2;
	by  drug_group0;
run;
proc transpose data=kq1_inc_Rct_all2    out=kq1_inc_Rct_all_median (drop=_NAME_) suffix=_total;
   by  drug_group0;
   var median_iqr;
   id drug_Group0;
run;
proc transpose data=kq1_inc_Rct_all2    out=kq1_inc_Rct_all_n (drop=_NAME_) suffix = _total;
   by   drug_group0;
   var nc;
   id drug_Group0;
run;
proc transpose data=kq1_inc_Rct_all2    out=kq1_inc_Rct_all_sum(drop=_NAME_) suffix=_total ;
   by  drug_Group0 ;
   var sum_total_nc;
   id drug_Group0;
run;
* Stack values;
data stack_study_summ_total;
	set kq1_inc_rct_all_median (in=median)
		kq1_inc_rct_all_n (in=nobs)
		kq1_inc_rct_all_sum (in=sum);
	length textv $100.;
	if median = 1 then do; textv = "   " || "Median sample size [IQR]"; text_ord = 2;end;
	else if nobs = 1 then do; textv = "   " || "Number of studies"; text_ord = 1; end;
	else if sum = 1 then do; textv = "   " || "Overall sample size"; text_ord = 3; end;
run;
proc sort data = stack_study_summ_total;
	by drug_group0 text_ord;
run;

** Merge by drug and total columns;
data outdata.stack_study_summ_all (label = "Arms summary: created in &progname..sas");
	merge 	stack_Study_summ
			stack_study_summ_total;
	by drug_Group0 text_ord;
run;


