/**************************************************************************************
 * Progname: 02_inc_arm_pbo.sas
 * Purpose: Identify placebo arms for the comparative analyses
 * Date: 2025-03-26
 * Author: Lijuan Zeng
 * Notes: 
 ***************************************************************************************/
%include "S:/lzeng3/ALA_SRMA/prog/00_utility.sas";
    
* Set up the environment;
options nocenter nonumber; /*nodate*/
%global progname;
%let progname=%str(02_inc_arm_pbo);


************************************************************************************************;
** Flag arms in a study-level dataset;
************************************************************************************************;

proc sort data=outdata.study_kq1_rct_include out=kq1_include ;
	by extraction_id;
run;

* Bring in Arms details page and clean variables for the included studies;
proc sort data=outdata.arm_details out=arm_details ;
	by extraction_id;
run;
data arm_details1;
	merge 	kq1_include (in=A keep=extraction_id flag_meta_ana study) 
			arm_details;
	by extraction_id;

	* only keep included KQ1 studies and non-crossover;
	if a=1 and flag_meta_ana = 1;
run;

proc sort data=outdata.study_kq1_inc_arms out=kq1_inc_arms;
	by extraction_id;
run;

proc sort data=outdata.kq1_inc_rct_arms_details out=kq1_inc_rct_arms;
	by extraction_id drug_dose arms_name;
run;


************************************************************************************************;
** Clean up arms in long format;
************************************************************************************************;
data arm_details2;
	merge 	arm_details1 (in=A)
			kq1_inc_arms;
	by extraction_id;

	if A= 1;
	length drug_dose $100.;

	if upcase(strip(arms_name)) = "NO SEMAGLUTIDE" then drug_dose = strip(arms_name);
	else if index(upcase(arms_name),"SEMAGLUTIDE")>0 then do;
		if compress(route_admin)="Oral" then do;
				if	strip(arms_name) in ("Semaglutide 3 mg", "Semaglutide 3mg", "Semaglutide 3mg/d") then drug_dose = "Semaglutide 3 mg (OD)";
			else if strip(arms_name) in ("Semaglutide 7 mg", "Semaglutide 7mg", "Semaglutide 7mg/d") then drug_dose = "Semaglutide 7 mg (OD)";
			else if strip(arms_name) in ("Semaglutide 14 mg", "Semaglutide 14mg", "Semaglutide 14mg/d") or 
				(strip(arms_name)="Semaglutide" and strip(dose) ="14") then drug_dose = "Semaglutide 14 mg (OD)";
			else if strip(arms_name) in ("Semaglutide 25 mg", "Semaglutide 25mg") then drug_dose = "Semaglutide 25 mg (OD)";
			else if strip(arms_name) in ("Semaglutide 50 mg", "Semaglutide 50mg") then drug_dose = "Semaglutide 50 mg (OD)"; 
			else if extraction_id = "60668" then do; * Pieber 2019;
				if strip(arms_name) = "Semaglutide (durability 0-104 wk)" then drug_dose = "Semaglutide 14 mg (OD)";
				else do;
					drug_dose = "SEMA - additional arms"; 
					arms_interest = 0;
				end;
			end;
		end;
		else do;
			if strip(arms_name) in ("Semaglutide 0.05 mg" ) then drug_dose = "Semaglutide 0.05 mg";
			else if strip(arms_name) in ("Semaglutide 0.1 mg", "Semaglutide 0.1mg" ) then drug_dose = "Semaglutide 0.1 mg";
			else if strip(arms_name) in ("Semaglutide 0.2 mg", "Semaglutide 0.2mg" ) then drug_dose = "Semaglutide 0.2 mg";
			* ONeil 2018 included two semaglutide arms of 0.3 and two of 0.4 dose group;
			* the one with FE stands for two week fast-escalation;
			else if strip(arms_name) in ("Semaglutide 0.3 mg", "Semaglutide 0.3mg" , "Semaglutide 0.3 mg FE") then drug_dose = "Semaglutide 0.3 mg";
			else if strip(arms_name) in ("Semaglutide 0.4 mg", "Semaglutide 0.4mg" , "Semaglutide 0.4 mg FE") or 
				(strip(arms_name)="Semaglutide" and index(dose,"0.4")>0) then drug_dose = "Semaglutide 0.4 mg";
			else if strip(arms_name) in ("Semaglutide 0.5 mg", "Semaglutide 0.5mg" ) then drug_dose = "Semaglutide 0.5 mg";
			else if strip(arms_name) in ("Semaglutide 0.8 mg", "Semaglutide 0.8mg", "Semaglutide 0.8mg E" ) then drug_dose = "Semaglutide 0.8 mg";
			else if strip(arms_name) in ("Semaglutide 1 mg", "Semaglutide 1.0mg") or 
				(strip(arms_name)="Semaglutide" and strip(dose) in ("1", "1.0")) then drug_dose = "Semaglutide 1.0 mg";
			else if strip(arms_name) in ("Semaglutide 1.6 mg", "Semaglutide 1.6mg") then drug_dose = "Semaglutide 1.6 mg";
			else if strip(arms_name) in ("Semaglutide 1.7 mg", "Semaglutide 1.7mg") then drug_dose = "Semaglutide 1.7 mg";			
			else if strip(arms_name) in ("Semaglutide 2.4 mg", "Semaglutide 2.4mg") or 
				(strip(arms_name)="Semaglutide" and strip(dose) = "2.4") then drug_dose = "Semaglutide 2.4 mg";			
			else if strip(arms_name) in ("Semaglutide 3 mg", "Semaglutide 3mg") then drug_dose = "Semaglutide 3.0 mg";			
			else if strip(arms_name) in ("Semaglutide 7 mg", "Semaglutide 7mg") then drug_dose = "Semaglutide 7.0 mg";			
			else if strip(arms_name) in ("Semaglutide 14 mg", "Semaglutide 14mg") or 
				(strip(arms_name)="Semaglutide" and strip(dose) ="14") then drug_dose = "Semaglutide 14 mg";
			else if strip(arms_name) in ("Semaglutide 25 mg", "Semaglutide 25mg") then drug_dose = "Semaglutide 25 mg";
			else if strip(arms_name) in ("Semaglutide 50 mg", "Semaglutide 50mg") then drug_dose = "Semaglutide 50 mg"; 
			else if extraction_id = "60647" then do; * Rubino 2021 included an additional run-in group data - no included since we have the sema vs pbo after run-in - to summarize in observational study;
				if strip(arms_name)="Semaglutide run-in period" then do;
					drug_dose = "SEMA - additional arms"; 
					arms_interest = 0;
				end;
				else if (strip(arms_name)="Continued semaglutide" and strip(dose) = "2.4") then 
					drug_dose = "Semaglutide 2.4 mg";
			end;
		end;
	end;

	else if index(upcase(arms_name),"LIRAGLUTIDE")>0 then do;
		if strip(arms_name) in ("Liraglutide 1.2 mg", "Liraglutide 1.2mg") or (strip(arms_name)="Liraglutide" and index(dose, "1.2")>0) then drug_dose = "Liraglutide 1.2 mg";  
		else if strip(arms_name) in ("Liraglutide 0.6 mg", "Liraglutide 0.6mg") then drug_dose = "Liraglutide 0.6 mg";  
		else if strip(arms_name) in ("Liraglutide 0.9 mg", "Liraglutide 0.9mg") or (strip(arms_name)="Liraglutide" and index(dose, "0.9")>0) then drug_dose = "Liraglutide 0.9 mg";  
		else if strip(arms_name) in ("Liraglutide 1.8 mg", "Liraglutide 1.8mg") or (strip(arms_name)="Liraglutide" and index(dose, "1.8")>0) then drug_dose = "Liraglutide 1.8 mg";  
		else if strip(arms_name) in ("Liraglutide 2.4 mg", "Liraglutide 2.4mg") or (strip(arms_name)="Liraglutide" and index(dose, "2.4")>0) then drug_dose = "Liraglutide 2.4 mg";
		else if strip(arms_name) in ("Liraglutide 3.0 mg", "Liraglutide 3 mg", "Liraglutide 3.0mg") or (strip(arms_name)="Liraglutide" and strip(dose) in ("3" "3.0" ) ) then drug_dose = "Liraglutide 3.0 mg";  
		else if compress(extraction_id) = "60667" then do; * Pi-Suyer 2015 - included additional subgroup analyses by pre-diabetes status;
			if index(arms_name, "total")>0 then drug_dose = "Liraglutide 3.0 mg";
			else do; 
				drug_dose = "LIRA - additional arms"; 
				arms_interest = 0;
			end;
		end;
		else if extraction_id = "60650" then do; * Seino 2016 - lira/insulin vs. pbo/insulin;
			drug_dose = "Liraglutide 0.9 mg"; 
		end;
		else if strip(arms_name) in ("Exercise and Liraglutide 3 mg" "Intensive Behavioral Therapy + Liraglutide 3mg") then drug_dose = "Liraglutide 3.0 mg";
		else if extraction_id = "60719" then do; * Tronieri 2019 comparing lira/phen vs lira/pbo;
			if strip(arms_name) = "Liraglutide 3.0 mg/Placebo" then drug_dose = "Liraglutide 3.0 mg";
			else if strip(arms_name)="Liraglutide 3.0 mg/Phentermine 15.0 mg" then drug_dose = strip(arms_name);
		end;
		else if compress(extraction_id)="60646" then do; * Rosenstock 2013;
			if index(arms_name,"Observational")>0 then do; 
				drug_dose = "LIRA - additional arms";
				arms_interest = 0;
			end;
			else if index(arms_name, "Insulin")>0 then drug_dose = "Liraglutide 1.8 mg/Metformin/Insulin";
			else drug_dose = "Liraglutide 1.8 mg/Metformin";
		end;
		else if index(arms_name, "exenatide") then drug_dose = "Liraglutide/Exenatide";
		else if index(upcase(strip(arms_name)),"DEGLUDEC")>0 or  index(upcase(strip(arms_name)),"INSULIN")>0 then drug_dose = "Liraglutide/Insulin";
		else if index(arms_name,"interleukin")>0 then drug_dose = "Liraglutide/Anti-interleukin";
		else drug_dose = strip(arms_name);
	end;

	else if index(upcase(arms_name),"ORLISTAT")>0 then do;
		if strip(arms_name) in ("Orlistat 60 mg") or (strip(arms_name)="Orlistat" and index(dose,"60")>0) then drug_dose = "Orlistat 60 mg";  
		else if strip(arms_name) in ("Orlistat 120 mg") or (strip(arms_name)="Orlistat" and index(dose,"120")>0) then drug_dose = "Orlistat 120 mg";  
		else if strip(arms_name) in ("Orlistat 150 mg") then drug_dose = "Orlistat 150 mg";
		else if strip(arms_name) in ("Orlistat 240 mg") then drug_dose = "Orlistat 240 mg";
		else if strip(arms_name) in ("Orlistat 360 mg") then drug_dose = "Orlistat 360 mg";
		else drug_dose = strip(arms_name);
	end;

	else if index(upcase(arms_name),"SETMELANOTIDE")>0 then do;
		if strip(dose)=3 then drug_Dose = "Setmelanotide 3 mg";
	end;

	else if index(upcase(arms_name),"TIRZEPATIDE")>0 then do;
		if strip(extraction_id) = "60419" then do;
			if index(arms_name, "10")>0 then  drug_dose = "Tirzepatide 10 mg";
			else if  index(arms_name, "15")>0 then  drug_dose = "Tirzepatide 15 mg";
		end;
		else if strip(arms_name) in ("Tirzepatide 1 mg" "Tirzepatide 1mg") then drug_dose = "Tirzepatide 1 mg";  
		else if strip(arms_name) in ("Tirzepatide 5 mg" "Tirzepatide 5mg") then drug_dose = "Tirzepatide 5 mg";  
		else if strip(arms_name) in ("Tirzepatide 10 mg", "Tirzepatide 10mg") or strip(arms_name)="Tirzepatide 2.5 to 10 mg" then drug_dose = "Tirzepatide 10 mg";  
		else if strip(arms_name) in ("Tirzepatide 15 mg", "Tirzepatide 15mg") or strip(arms_name)="Tirzepatide 2.5 to 15 mg" then drug_dose = "Tirzepatide 15 mg";
		else drug_dose = strip(arms_name);
	end;

	else if index(upcase(arms_name), "NALTREXONE")>0 and index(upcase(arms_name), "BUPROPION")>0 then do;
		if index(dose,"16")>0 then drug_dose = "Naltrexone 16 mg/Bupropion 360 mg";
		else drug_dose = "Naltrexone 32 mg/Bupropion 360 mg";
	end;

	else if index(upcase(arms_name), "PHENTERMINE")>0 and index(upcase(arms_name), "TOPIRAMATE")>0 then do;
		if index(arms_name,"15")>0 or index(dose,"92")>0 or (extraction_id = "60730" and index(dose,"15")>0) then drug_dose = "Phentermine 15 mg/Topiramate 92 mg";
		else if index(arms_name,"7.5")>0 or index(dose,"46")>0 then drug_dose = "Phentermine 7.5 mg/Topiramate 46 mg";
		else if index(arms_name,"3.25")>0 or index(dose,"23")>0 then drug_dose = "Phentermine 3.25 mg/Topiramate 23 mg";
	end;
run;

proc freq data= arm_details2;
   tables drug_dose
   / list missing;
run;

data arm_details3;
	set arm_details2;
	by extraction_id;

	* Create a new drug group variable for table summary;
	length drug_group1 drug_group0 $100.;
	if index(drug_dose, "Liraglutide")>0 then do;
		drug_group0 = "Liraglutide";
		if drug_dose in ("Liraglutide 1.2 mg", "Liraglutide 1.8 mg", "Liraglutide 3.0 mg") then drug_group1 = strip(drug_dose);
		else drug_group1 = "Liraglutide Other";
	end;
	else if index(drug_dose, "Semaglutide")>0 then do;
		drug_group0 = "Semaglutide";
		if drug_dose in ("Semaglutide 1.0 mg", "Semaglutide 2.4 mg", "Semaglutide 14 mg (OD)") then drug_group1 = strip(drug_dose);
		else drug_group1 = "Semaglutide Other";
	end;
	else if index(drug_dose, "Tirzepatide")>0 then do;
		drug_group0 = "Tirzepatide";
		if drug_dose in ("Tirzepatide 5 mg", "Tirzepatide 10 mg", "Tirzepatide 15 mg") then drug_group1 = strip(drug_dose);
		else drug_group1 = "Tirzepatide Other";
	end;
	else if index(drug_dose, "Orlistat")>0 then do;
		drug_group0 = "Orlistat";
		drug_group1 = strip(drug_dose);
	end;
	else if index(drug_dose, "Setmelanotide")>0 then do;
		drug_group0 = "Setmelanotide";
		drug_group1 = strip(drug_dose);
	end;
	else if index(drug_dose, "Naltrexone")>0 then do;
		drug_group0 = "Naltrexone/Bupropion";
		drug_group1 = strip(drug_dose);
	end;
	else if index(drug_dose, "Topiramate")>0 then do;
		drug_group0 = "Phentermine/Topiramate";
		drug_group1 = strip(drug_dose);
	end;
run;


proc sort data=arm_details3 (where=(missing(drug_dose))) out=arm_details_comp;
	by extraction_id drug_dose arms_name;
run;
proc freq data=arm_details_comp ;
   tables arms_name
   / list missing;
run;


************************************************************************************************;
** Clean up comparison groups;

** Placebos;
data arm_details_comp_pbo arm_details_comp_other;
	set arm_details_comp;
	if index(upcase(arms_name), "PLACEBO")>0 then do;
		if extraction_id = "60667" then do; * Pi-Sunyer 2015 - use the total lira and total pbo instead of by stratified by pre-diabetes status results;
			if index(arms_name, "diabetes")>0 then do;
				drug_dose = "PBO - additional arms"; 
				arms_interest = 0;
			end;
			else if strip(arms_name) = "Placebo, total" then drug_dose = "Placebo";
		end;
		else if index(arms_name, "mg")>0 then do;
			drug_dose = "Placebo";
		end;
		else if extraction_id = "60434" then do; * Haqq 2022 - use double-blind phase data and ignore the open-label part ;
			drug_dose = "Placebo";
		end;
		else if extraction_id = "60647" then do; * Rubino 2021 - sema vs placebo (labeled as Switched to Placebo) starting at W20;
			drug_dose = "Placebo";
		end;
		else if extraction_id = "60650" then do; * Seino 2016 - Lira/insulin vs. Pbo/insulin;
			drug_dose = "Placebo";
		end;
		else if compress(arms_name) = "Placebo" then 
			drug_dose = "Placebo";
		drug_group0 = "Placebo";
		drug_group1 = strip(drug_dose);

		output arm_details_comp_pbo;
	end;
	else output arm_details_comp_other;

run;

proc sort data=arm_details_comp_pbo (where=(not missing(drug_dose) and arms_interest ne 0))
	out =outdata.kq1_inc_rct_arms_details_pbo (label = "Arm details for included RCT placebo arms; Created from &progname.") dupout=_checkdup_pbo nodupkey;
	by extraction_id drug_dose arms_name;
run;

************************************************************************************************
** output data
************************************************************************************************;

ods rtf file="&outdir.&progname..rtf" ;
footnote "Outputs generated from &progname..sas";
title3 "Review placebo arms";
proc freq data= outdata.kq1_inc_rct_arms_details_pbo;
   tables drug_Dose * arms_name / list missing;
run;

ods rtf close;
title;
