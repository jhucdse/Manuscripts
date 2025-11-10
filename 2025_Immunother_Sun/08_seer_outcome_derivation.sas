*******************************************************************************;
* Program name      :	xx_outcome_derivation
* Author            :	Jamie Heyward
* Date created      :	June 14 2022
* Study             : 	
* Purpose           :	Define occurrence of death, irAE and censoring events in the ICI-exposed lung cancer population
* Inputs            :	
* Program completed : 	
* Updated by        :   Xinyi Sun, Jan 2 2024
*********************************************************************************;

LIBNAME seer 'S:\Pharmacoepi0216\Thesis';
LIBNAME thesis 'S:\Pharmacoepi0216\Thesis_new';

/* Create new version of ICI patient list with dummy columns for irAE outcome status (for each version of irAE outcome definition); death; admin censoring; and other censoring; with dates

	irAE v1: ICD-code dx and irAE tx (HCPCS or NDC) within +/- 10 days 
	irAE v2: ICD-code dx and irAE tx (HCPCS or NDC) within -30 to +10 days 
	irAE v3: ICD-code dx alone 
	irAE v4: irAE tx code (HCPCS or NDC) alone
	irAE v5: PMAP database derived: TBD final criteria (probably alteration of time window and specific dx codes used)

	Censoring criteria:
	Admin (survived outcome-free to 2019Dec31); 
	Non-cancer death (SEER) ***NOTE: This variable is incomplete/problematic
	Cancer-specific death (SEER) ***NOTE: This variable is incomplete/problematic
	Death (all-cause) (MBSF)
	Medicare disenrollment before 2019Dec31

	NOTE: SEER death data is missing for the Idaho, New York, Massachusetts and Texas registries (n = 7720 patients). Might not be able to use
		these variables for outcome ascertainment- can use Medicare Beneficiary Summary File instead. This is not cause-specific, so will not have cancer
		specific death available if we use MBSF death variable. 

*/ 

	data thesis.cohort_outcomes;
	set thesis.cohort; 
	irAE_v1= '.'; 								
	irAE_v1_dt= input('.', yymmdd10.); 
	format irAE_v1_dt date9.;
	irAE_v1_doserange= '.'; 								
	irAE_v1_doserange_dt= input('.', yymmdd10.); 
	format irAE_v1_doserange_dt date9.;
	irAE_v2= '.'; 
	irAE_v2_dt= input('.', yymmdd10.);
	format irAE_v2_dt date9.;
	irAE_v3= '.'; 
	irAE_v3_dt= input('.', yymmdd10.);
	format irAE_v3_dt date9.;
	irAE_v4= '.'; 
	irAE_v4_dt= input('.', yymmdd10.);
	format irAE_v4_dt date9.;
	irAE_v4_doserange = '.'; 
	irAE_v4_doserange_dt= input('.', yymmdd10.);
	format irAE_v4_doserange_dt date9.;
	irAE_v5= '.'; 
	irAE_v5_dt= input('.', yymmdd10.);
	format irAE_v5_dt date9.;
	admin_censor = '.';
	admin_censor_dt = input('20191231', yymmdd10.);
	format admin_censor_dt date9.;
	noncancer_death = '.'; 
	noncancer_death_dt = input('.', yymmdd10.); 
	format noncancer_death_dt date9.;
	mcare_disenroll = '.'; 
	mcare_disenroll_dt = input('.', yymmdd10.); 
	format mcare_disenroll_dt date9.;
	cancer_death = '.';
	cancer_death_dt = input('.', yymmdd10.); 
	format cancer_death_dt date9.;
	medicare_death = '.';
	medicare_death_dt = input('.', yymmdd10.); 
	format medicare_death_dt date9.;
	run; 
	

	proc print data = thesis.cohort_outcomes (obs = 5); 
	run; 



/* irAE Dx Codes- for irAE v1, v2, v3 (possibly) v5 */ 

/* Filter Carrier (NCH) Base, Outpatient Base, and MedPAR files on updated eligible cohort patient list and ICI index date */ 

		/* NCH */ 
		proc sql; 
		create table thesis.nchbase_lung_outcomes as
		select *
		from seer.nchbase
		where patient_id in(select distinct patient_id from thesis.cohort);
		quit; 

		data thesis.nchbase_lung_outcomes; 
		set thesis.nchbase_lung_outcomes;
		record_source = "NCH";
		claim_dt = CLM_THRU_DT;
		run; 

		/* Outpatient */ 

		proc sql; 
		create table thesis.outbase_lung_outcomes as
		select *
		from seer.outbase
		where patient_id in(select distinct patient_id from thesis.cohort);
		quit; 

		data thesis.outbase_lung_outcomes; 
		set thesis.outbase_lung_outcomes;
		record_source = "Outpatient";
		claim_dt = CLM_THRU_DT;
		run; 

		/* MedPAR */ 
		proc sql; 
		create table thesis.medpar_lung_outcomes as
		select *
		from seer.medpar
		where patient_id in(select distinct patient_id from thesis.cohort);
		quit; 

		data thesis.medpar_lung_outcomes; 
		set thesis.medpar_lung_outcomes;
		record_source = "MedPAR";
		ICD_DGNS_CD1 = DGNS_1_CD;
		ICD_DGNS_CD2 = DGNS_2_CD;
		ICD_DGNS_CD3 = DGNS_3_CD;
		ICD_DGNS_CD4 = DGNS_4_CD;
		claim_dt = ADMSN_DT;
		clm_id = MEDPAR_ID; 
		run; 


/**/
/*		proc print data = thesis.outbase_lung_outcomes (obs = 5); */
/*		run;*/


		/* Combine Carrier (NCH), Outpatient, and MedPAR files, conserving just a few common data columns */ 
			data thesis.combined_lung_outcomes;
			set thesis.nchbase_lung_outcomes (keep = patient_id clm_id nch_clm_type_cd claim_dt ICD_DGNS_CD1-ICD_DGNS_CD4 record_source) 
				thesis.outbase_lung_outcomes (keep = patient_id clm_id nch_clm_type_cd claim_dt ICD_DGNS_CD1-ICD_DGNS_CD4 record_source)
				thesis.medpar_lung_outcomes (keep = patient_id clm_id nch_clm_type_cd claim_dt ICD_DGNS_CD1-ICD_DGNS_CD4 record_source);
			claim_dt_format = input(claim_dt, yymmdd10.);
			format claim_dt_format date9.;
			run; 

				proc print data = thesis.combined_lung_outcomes (obs = 10);
				run; 



			/* Merge in ICI index date to compare to clm_thru_dt for potential irAE */

				proc sort data = thesis.combined_lung_outcomes; 
				by patient_id;
				run;

				proc sort data = thesis.cohort;
				by patient_id; 
				run;

				data thesis.combined_lung_outcomes1; 
				merge thesis.combined_lung_outcomes (in = a) 
				      thesis.cohort (keep = patient_id ici_index_dt in = b);
				by patient_id;
				if a;
				run; 



			/* Search this file on ICD-10 and ICD-9 codes corresponding to irAE (Brown V et al) in the first 4 ICD positions */ 

					/* Macro with list of ICD-10 dx codes */ 
					/* (Learn how to do this and replace the code below with the macro 

					ALL THE BELOW DID NOT WORK */ 

			/* icd-9 codes */

/*			%macro filter_dataset9;*/
/**/
/*			data lung_irae_icd_match_9;*/
/*			set seer.combined_lung_outcomes1; */
/*			%let icd9_list = 4279, 4281, 42090, 42099, 42091, 42099, 4290, 4290, 42290, 42291, 42293, 42299, 2448, 25541, 25542, 2558, 486, 515, 51633, 51632, 3239, 32381, 32361, 32341, 5589, 5589, 78791, 5565, 56981, 5565, 5695, 5565, 5565, 56089, 5565, 5565, 5733, 57142, 5733, 6929, 6918, 6939, 6929, 6938, 6918, 7821, 6940, 28851, 2849, 28489, 28489, 28489, 7291, 72881, 72881, 37991, 36255, 3643, 5939, 58381, 58389, 58389, 58389, 5908, 58381;*/
/*			%let Columns = ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4; */
/**/
/*			%local i j CurrentCol CurrentValue;*/
/*  */
/*			  %do i = 1 %to %sysfunc(countw(&Columns.));*/
/*			    %let CurrentCol = %scan(&Columns., &i);*/
/*			    */
/*			    %let j = 1;*/
/*			    */
/*			    %do %while (%scan(&icd9_list., &j) ne);*/
/*			      %let CurrentValue = %scan(&icd9_list., &j);*/
/*			      */
/*			      if "&CurrentCol." = "&CurrentValue." then output;*/
/*			      */
/*			      %let j = %eval(&j + 1);*/
/*			    %end;*/
/*			  %end;*/
/**/
/*			run; */
/**/
/*			%mend;*/
/**/
/*			%filter_dataset9;*/
/**/
/*			proc print data = lung_irae_icd_match_9;*/
/*			run; */

			
			/* icd-10 codes */

/*			%macro filter_dataset10;*/
/*			data lung_irae_icd_match_10;*/
/*			set seer.combined_lung_outcomes1; */
/*			%let icd10_list = I498, I49, I499, I501, I30, I309, I300, I308, I319, I514, I40, I409, I401, I408, E11, E039, E038, E03, E059, E05, E2749, E278, E27, J189, J8489, J84114, J84113, G049, G04, G928, G048, G0490, G0481, G0400, G053, G05, K529, K50, K51, K52, K523, K5289, K528, K51513, K515, K51514, K5151, K5150, K51512, K51519, K759, K754, K752, L309, L20, L209, L279, L27, L308, L278, L2089, L208, L30, R21, D7212, D72810, D619, D613, D611, D612, D61, M60, M609, M601, M608, M6010, M6018, H571, H5710, H3538, H35383, H35389, N289, N08, N1419, N142, N141, N144, L130;*/
/*			%let Columns = ICD_DGNS_CD1 ICD_DGNS_CD2 ICD_DGNS_CD3 ICD_DGNS_CD4;*/
/**/
/*			%let NumCols = %sysfunc(countw(&columns.));*/
/*	*/
/*			%do i = 1 %to &NumCols.;*/
/*		    %let CurrentCol = %scan(&Columns., &i.);*/
/*		    */
/*		    %let Values = %superq(icd10_list);*/
/*		    %let j = 1;*/
/*		    %do %while (%qscan(&Values, &j, %str( )) ne);*/
/*		      %let CurrentValue = %qscan(&Values, &j, %str( ));*/
/*		      */
/*		      if &CurrentCol. = "&CurrentValue." then output;*/
/*		      */
/*		      %let j = %eval(%sysfunc(inputn(&j., best.)) + 1);*/
/*		    %end;*/
/*		  %end;*/
/*  */
/*			run; */
/**/
/*			%mend;*/
/**/
/*			%filter_dataset10;*/
/**/
/*			*/
/*			data lung_irae_icd_match;*/
/*			set lung_irae_icd_match_9 lung_irae_icd_match_10;*/
/*			daysfromindex = intck('day', ici_index_dt, claim_dt_format);*/
/*			run;*/

		
			/* How many records per year in original outcomes table */ 
				data thesis.combined_lung_outcomes1;
				set thesis.combined_lung_outcomes1; 
				claim_yr = year(claim_dt_format);
				ici_yr = year(ici_index_dt); 
				run; 

				proc freq data = thesis.combined_lung_outcomes1;
				table claim_yr ici_yr;
				run; 

				/*
				claim_yr Frequency Percent CumulativeFrequency CumulativePercent 
				2012 38422 6.97 38422 6.97 
				2013 14290 2.59 52712 9.56 
				2014 54958 9.97 107670 19.52 
				2015 75616 13.71 183286 33.23 
				2016 92186 16.72 275472 49.95 
				2017 98183 17.80 373655 67.75 
				2018 83501 15.14 457156 82.89 
				2019 94334 17.11 551490 100.00 



				ici_yr Frequency Percent CumulativeFrequency CumulativePercent 
				2015 16722 3.03 16722 3.03 
				2016 105920 19.21 122642 22.24 
				2017 130080 23.59 252722 45.83 
				2018 127850 23.18 380572 69.01 
				2019 170918 30.99 551490 100.00 




				*/

					/* Very few ICI initiators in 2014, relatively few in 2015... would expect very few ICD-9 codes related to irAE as a result. */ 



			data lung_irae_icd_match;
			set thesis.combined_lung_outcomes1; 
			/* icd-10 codes, see Word doc with outcome names and ICD mappings */
			where  ICD_DGNS_CD1 in ('I498', 'I49', 'I499', 'I501', 'I30', 'I309', 'I300', 'I308', 'I319', 'I514', 'I40', 'I409', 'I401', 'I408', 'E11', 'E039', 'E038', 'E03', 'E059', 'E05', 'E2749', 'E278', 'E27', 'J189', 'J8489', 'J84114', 'J84113', 'G049', 'G04', 'G928', 'G048', 'G0490', 'G0481', 'G0400', 'G053', 'G05', 'K529', 'K50', 'K51', 'K52', 'K523', 'K5289', 'K528', 'K51513', 'K515', 'K51514', 'K5151', 'K5150', 'K51512', 'K51519', 'K759', 'K754', 'K752', 'L309', 'L20', 'L209', 'L279', 'L27', 'L308', 'L278', 'L2089', 'L208', 'L30', 'R21', 'D7212', 'D72810', 'D619', 'D613', 'D611', 'D612', 'D61', 'M60', 'M609', 'M601', 'M608', 'M6010', 'M6018', 'H571', 'H5710', 'H3538', 'H35383', 'H35389', 'N289', 'N08', 'N1419', 'N142', 'N141', 'N144', 'L130')
			OR ICD_DGNS_CD2 in ('I498', 'I49', 'I499', 'I501', 'I30', 'I309', 'I300', 'I308', 'I319', 'I514', 'I40', 'I409', 'I401', 'I408', 'E11', 'E039', 'E038', 'E03', 'E059', 'E05', 'E2749', 'E278', 'E27', 'J189', 'J8489', 'J84114', 'J84113', 'G049', 'G04', 'G928', 'G048', 'G0490', 'G0481', 'G0400', 'G053', 'G05', 'K529', 'K50', 'K51', 'K52', 'K523', 'K5289', 'K528', 'K51513', 'K515', 'K51514', 'K5151', 'K5150', 'K51512', 'K51519', 'K759', 'K754', 'K752', 'L309', 'L20', 'L209', 'L279', 'L27', 'L308', 'L278', 'L2089', 'L208', 'L30', 'R21', 'D7212', 'D72810', 'D619', 'D613', 'D611', 'D612', 'D61', 'M60', 'M609', 'M601', 'M608', 'M6010', 'M6018', 'H571', 'H5710', 'H3538', 'H35383', 'H35389', 'N289', 'N08', 'N1419', 'N142', 'N141', 'N144', 'L130')
			OR ICD_DGNS_CD3 in ('I498', 'I49', 'I499', 'I501', 'I30', 'I309', 'I300', 'I308', 'I319', 'I514', 'I40', 'I409', 'I401', 'I408', 'E11', 'E039', 'E038', 'E03', 'E059', 'E05', 'E2749', 'E278', 'E27', 'J189', 'J8489', 'J84114', 'J84113', 'G049', 'G04', 'G928', 'G048', 'G0490', 'G0481', 'G0400', 'G053', 'G05', 'K529', 'K50', 'K51', 'K52', 'K523', 'K5289', 'K528', 'K51513', 'K515', 'K51514', 'K5151', 'K5150', 'K51512', 'K51519', 'K759', 'K754', 'K752', 'L309', 'L20', 'L209', 'L279', 'L27', 'L308', 'L278', 'L2089', 'L208', 'L30', 'R21', 'D7212', 'D72810', 'D619', 'D613', 'D611', 'D612', 'D61', 'M60', 'M609', 'M601', 'M608', 'M6010', 'M6018', 'H571', 'H5710', 'H3538', 'H35383', 'H35389', 'N289', 'N08', 'N1419', 'N142', 'N141', 'N144', 'L130')
			OR ICD_DGNS_CD4 in ('I498', 'I49', 'I499', 'I501', 'I30', 'I309', 'I300', 'I308', 'I319', 'I514', 'I40', 'I409', 'I401', 'I408', 'E11', 'E039', 'E038', 'E03', 'E059', 'E05', 'E2749', 'E278', 'E27', 'J189', 'J8489', 'J84114', 'J84113', 'G049', 'G04', 'G928', 'G048', 'G0490', 'G0481', 'G0400', 'G053', 'G05', 'K529', 'K50', 'K51', 'K52', 'K523', 'K5289', 'K528', 'K51513', 'K515', 'K51514', 'K5151', 'K5150', 'K51512', 'K51519', 'K759', 'K754', 'K752', 'L309', 'L20', 'L209', 'L279', 'L27', 'L308', 'L278', 'L2089', 'L208', 'L30', 'R21', 'D7212', 'D72810', 'D619', 'D613', 'D611', 'D612', 'D61', 'M60', 'M609', 'M601', 'M608', 'M6010', 'M6018', 'H571', 'H5710', 'H3538', 'H35383', 'H35389', 'N289', 'N08', 'N1419', 'N142', 'N141', 'N144', 'L130')
			/* icd-9 codes, see Word doc with outcome names and ICD mappings */ 
			OR ICD_DGNS_CD1 in ('4279', '4281', '42090', '42099', '42091', '42099', '4290', '4290', '42290', '42291', '42293', '42299', '2448', '25541, 25542', '2558', '486', '515', '51633', '51632', '3239', '32381', '32361', '32341', '5589', '5589, 78791', '5565, 56981', '5565, 5695', '5565', '5565, 56089', '5565', '5565', '5733', '57142', '5733', '6929', '6918', '6939', '6929', '6938', '6918', '7821', '6940', '28851', '2849', '28489', '28489', '28489', '7291', '72881', '72881', '37991', '36255', '3643', '5939', '58381', '58389', '58389', '58389', '5908', '58381')
			OR ICD_DGNS_CD2 in ('4279', '4281', '42090', '42099', '42091', '42099', '4290', '4290', '42290', '42291', '42293', '42299', '2448', '25541, 25542', '2558', '486', '515', '51633', '51632', '3239', '32381', '32361', '32341', '5589', '5589, 78791', '5565, 56981', '5565, 5695', '5565', '5565, 56089', '5565', '5565', '5733', '57142', '5733', '6929', '6918', '6939', '6929', '6938', '6918', '7821', '6940', '28851', '2849', '28489', '28489', '28489', '7291', '72881', '72881', '37991', '36255', '3643', '5939', '58381', '58389', '58389', '58389', '5908', '58381')
			OR ICD_DGNS_CD3 in ('4279', '4281', '42090', '42099', '42091', '42099', '4290', '4290', '42290', '42291', '42293', '42299', '2448', '25541, 25542', '2558', '486', '515', '51633', '51632', '3239', '32381', '32361', '32341', '5589', '5589, 78791', '5565, 56981', '5565, 5695', '5565', '5565, 56089', '5565', '5565', '5733', '57142', '5733', '6929', '6918', '6939', '6929', '6938', '6918', '7821', '6940', '28851', '2849', '28489', '28489', '28489', '7291', '72881', '72881', '37991', '36255', '3643', '5939', '58381', '58389', '58389', '58389', '5908', '58381')
			OR ICD_DGNS_CD4 in ('4279', '4281', '42090', '42099', '42091', '42099', '4290', '4290', '42290', '42291', '42293', '42299', '2448', '25541, 25542', '2558', '486', '515', '51633', '51632', '3239', '32381', '32361', '32341', '5589', '5589, 78791', '5565, 56981', '5565, 5695', '5565', '5565, 56089', '5565', '5565', '5733', '57142', '5733', '6929', '6918', '6939', '6929', '6938', '6918', '7821', '6940', '28851', '2849', '28489', '28489', '28489', '7291', '72881', '72881', '37991', '36255', '3643', '5939', '58381', '58389', '58389', '58389', '5908', '58381');
			daysfromindex = intck('day', ici_index_dt, claim_dt_format);
			run; 


			/* Filter on ICD code occurring after ICI index date */ 
			data lung_irae_icd_match; 
			set lung_irae_icd_match; 
			where daysfromindex >0; 
			run; 

				proc freq data = lung_irae_icd_match; 
				table daysfromindex;
				run; 

			proc print data = lung_irae_icd_match (obs = 20); 
			run; 

					/* Add in dx domains (if match on ICD9-10 or ICD-9 codes from list */ 
					data lung_irae_icd_match; 
					length dx_domain_1 $ 25.;
					length dx_domain_2 $ 25.;
					length dx_domain_3 $ 25.;
					length dx_domain_4 $ 25.;
					set lung_irae_icd_match; 
					if ICD_DGNS_CD1 in ('I498', 'I49', 'I499', 'I501', 'I30', 'I309', 'I300', 'I308', 'I319', 'I514', 'I40', 'I409', 'I401', 'I408', '4279', '4281', '42090, 42099', '42091', '42099', '4290', '4290', '42290', '42291') then dx_domain_1 = 'cardiovascular';
					else if ICD_DGNS_CD1 in ('E11', 'E039', 'E038', 'E03', 'E059', 'E05', 'E2749', 'E278', 'E27', '42293', '42299', '2448', '25541, 25542', '2558') then dx_domain_1 = 'endocrine';
					else if ICD_DGNS_CD1 in ('J189', 'J8489', 'J84114', 'J84113', '486', '515', '51633', '51632') then dx_domain_1 = 'pulmonary';
					else if ICD_DGNS_CD1 in ('G049', 'G04', 'G928', 'G048', 'G0490', 'G0481', 'G0400', 'G053', 'G05', '3239', '32381', '32361', '32341') then dx_domain_1 = 'nervous system';
					else if ICD_DGNS_CD1 in ('K529', 'K50', 'K51', 'K52', 'K523', 'K5289', 'K528', 'K51513', 'K515', 'K51514', 'K5151', 'K5150', 'K51512', 'K51519', 'K759', 'K754', 'K752', '5589', '78791', '5565', '56981', '5695', '56089') then dx_domain_1 = 'gastrointestinal';
					else if ICD_DGNS_CD1 in ('L309', 'L20', 'L209', 'L279', 'L27', 'L308', 'L278', 'L2089', 'L208', 'L30', 'R21', 'D7212', 'L130', '5733', '57142') then dx_domain_1 = 'skin';
					else if ICD_DGNS_CD1 in ('D72810', 'D619', 'D613', 'D611', 'D612', 'D61', '6929', '6918', '6939', '6938', '7821') then dx_domain_1 = 'hematologic';
					else if ICD_DGNS_CD1 in ('M60', 'M609', 'M601', 'M608', 'M6010', 'M6018', '6940', '28851', '2849', '28489') then dx_domain_1 = 'musculoskeletal';
					else if ICD_DGNS_CD1 in ('H571', 'H5710', 'H3538', 'H35383', 'H35389', '7291', '72881', '37991', '36255', '3643') then dx_domain_1 = 'ocular';
					else if ICD_DGNS_CD1 in ('N289', 'N08', 'N1419', 'N142', 'N141', 'N144', '5939', '58381', '58389', '5908') then dx_domain_1 = 'renal';
					else dx_domain_1 ='.';
					if ICD_DGNS_CD2 in ('I498', 'I49', 'I499', 'I501', 'I30', 'I309', 'I300', 'I308', 'I319', 'I514', 'I40', 'I409', 'I401', 'I408', '4279', '4281', '42090, 42099', '42091', '42099', '4290', '4290', '42290', '42291') then dx_domain_2 = 'cardiovascular';
					else if ICD_DGNS_CD2 in ('E11', 'E039', 'E038', 'E03', 'E059', 'E05', 'E2749', 'E278', 'E27', '42293', '42299', '2448', '25541, 25542', '2558') then dx_domain_2 = 'endocrine';
					else if ICD_DGNS_CD2 in ('J189', 'J8489', 'J84114', 'J84113', '486', '515', '51633', '51632') then dx_domain_2 = 'pulmonary';
					else if ICD_DGNS_CD2 in ('G049', 'G04', 'G928', 'G048', 'G0490', 'G0481', 'G0400', 'G053', 'G05', '3239', '32381', '32361', '32341') then dx_domain_2 = 'nervous system';
					else if ICD_DGNS_CD2 in ('K529', 'K50', 'K51', 'K52', 'K523', 'K5289', 'K528', 'K51513', 'K515', 'K51514', 'K5151', 'K5150', 'K51512', 'K51519', 'K759', 'K754', 'K752', '5589', '78791', '5565', '56981', '5695', '56089') then dx_domain_2 = 'gastrointestinal';
					else if ICD_DGNS_CD2 in ('L309', 'L20', 'L209', 'L279', 'L27', 'L308', 'L278', 'L2089', 'L208', 'L30', 'R21', 'D7212', 'L130', '5733', '57142') then dx_domain_2 = 'skin';
					else if ICD_DGNS_CD2 in ('D72810', 'D619', 'D613', 'D611', 'D612', 'D61', '6929', '6918', '6939', '6938', '7821') then dx_domain_2 = 'hematologic';
					else if ICD_DGNS_CD2 in ('M60', 'M609', 'M601', 'M608', 'M6010', 'M6018', '6940', '28851', '2849', '28489') then dx_domain_2 = 'musculoskeletal';
					else if ICD_DGNS_CD2 in ('H571', 'H5710', 'H3538', 'H35383', 'H35389', '7291', '72881', '37991', '36255', '3643') then dx_domain_2 = 'ocular';
					else if ICD_DGNS_CD2 in ('N289', 'N08', 'N1419', 'N142', 'N141', 'N144', '5939', '58381', '58389', '5908') then dx_domain_2 = 'renal';
					else dx_domain_2 ='.';
					if ICD_DGNS_CD3 in ('I498', 'I49', 'I499', 'I501', 'I30', 'I309', 'I300', 'I308', 'I319', 'I514', 'I40', 'I409', 'I401', 'I408', '4279', '4281', '42090, 42099', '42091', '42099', '4290', '4290', '42290', '42291') then dx_domain_3 = 'cardiovascular';
					else if ICD_DGNS_CD3 in ('E11', 'E039', 'E038', 'E03', 'E059', 'E05', 'E2749', 'E278', 'E27', '42293', '42299', '2448', '25541, 25542', '2558') then dx_domain_3 = 'endocrine';
					else if ICD_DGNS_CD3 in ('J189', 'J8489', 'J84114', 'J84113', '486', '515', '51633', '51632') then dx_domain_3 = 'pulmonary';
					else if ICD_DGNS_CD3 in ('G049', 'G04', 'G928', 'G048', 'G0490', 'G0481', 'G0400', 'G053', 'G05', '3239', '32381', '32361', '32341') then dx_domain_3 = 'nervous system';
					else if ICD_DGNS_CD3 in ('K529', 'K50', 'K51', 'K52', 'K523', 'K5289', 'K528', 'K51513', 'K515', 'K51514', 'K5151', 'K5150', 'K51512', 'K51519', 'K759', 'K754', 'K752', '5589', '78791', '5565', '56981', '5695', '56089') then dx_domain_3 = 'gastrointestinal';
					else if ICD_DGNS_CD3 in ('L309', 'L20', 'L209', 'L279', 'L27', 'L308', 'L278', 'L2089', 'L208', 'L30', 'R21', 'D7212', 'L130', '5733', '57142') then dx_domain_3 = 'skin';
					else if ICD_DGNS_CD3 in ('D72810', 'D619', 'D613', 'D611', 'D612', 'D61', '6929', '6918', '6939', '6938', '7821') then dx_domain_3 = 'hematologic';
					else if ICD_DGNS_CD3 in ('M60', 'M609', 'M601', 'M608', 'M6010', 'M6018', '6940', '28851', '2849', '28489') then dx_domain_3 = 'musculoskeletal';
					else if ICD_DGNS_CD3 in ('H571', 'H5710', 'H3538', 'H35383', 'H35389', '7291', '72881', '37991', '36255', '3643') then dx_domain_3 = 'ocular';
					else if ICD_DGNS_CD3 in ('N289', 'N08', 'N1419', 'N142', 'N141', 'N144', '5939', '58381', '58389', '5908') then dx_domain_3 = 'renal';
					else dx_domain_3 ='.';
					if ICD_DGNS_CD4 in ('I498', 'I49', 'I499', 'I501', 'I30', 'I309', 'I300', 'I308', 'I319', 'I514', 'I40', 'I409', 'I401', 'I408', '4279', '4281', '42090, 42099', '42091', '42099', '4290', '4290', '42290', '42291') then dx_domain_4 = 'cardiovascular';
					else if ICD_DGNS_CD4 in ('E11', 'E039', 'E038', 'E03', 'E059', 'E05', 'E2749', 'E278', 'E27', '42293', '42299', '2448', '25541, 25542', '2558') then dx_domain_4 = 'endocrine';
					else if ICD_DGNS_CD4 in ('J189', 'J8489', 'J84114', 'J84113', '486', '515', '51633', '51632') then dx_domain_4 = 'pulmonary';
					else if ICD_DGNS_CD4 in ('G049', 'G04', 'G928', 'G048', 'G0490', 'G0481', 'G0400', 'G053', 'G05', '3239', '32381', '32361', '32341') then dx_domain_4 = 'nervous system';
					else if ICD_DGNS_CD4 in ('K529', 'K50', 'K51', 'K52', 'K523', 'K5289', 'K528', 'K51513', 'K515', 'K51514', 'K5151', 'K5150', 'K51512', 'K51519', 'K759', 'K754', 'K752', '5589', '78791', '5565', '56981', '5695', '56089') then dx_domain_4 = 'gastrointestinal';
					else if ICD_DGNS_CD4 in ('L309', 'L20', 'L209', 'L279', 'L27', 'L308', 'L278', 'L2089', 'L208', 'L30', 'R21', 'D7212', 'L130', '5733', '57142') then dx_domain_4 = 'skin';
					else if ICD_DGNS_CD4 in ('D72810', 'D619', 'D613', 'D611', 'D612', 'D61', '6929', '6918', '6939', '6938', '7821') then dx_domain_4 = 'hematologic';
					else if ICD_DGNS_CD4 in ('M60', 'M609', 'M601', 'M608', 'M6010', 'M6018', '6940', '28851', '2849', '28489') then dx_domain_4 = 'musculoskeletal';
					else if ICD_DGNS_CD4 in ('H571', 'H5710', 'H3538', 'H35383', 'H35389', '7291', '72881', '37991', '36255', '3643') then dx_domain_4 = 'ocular';
					else if ICD_DGNS_CD4 in ('N289', 'N08', 'N1419', 'N142', 'N141', 'N144', '5939', '58381', '58389', '5908') then dx_domain_4 = 'renal';
					else dx_domain_4 ='.';
					run; 

						proc print data = lung_irae_icd_match (obs = 20); 
						run; 

/*						proc freq data = lung_irae_icd_match; */
/*						table dx_domain_1; */
/*						run; */
/**/
/*						proc freq data = lung_irae_icd_match; */
/*						table dx_domain_2; */
/*						run; */
/**/
/*						proc freq data = lung_irae_icd_match; */
/*						table dx_domain_3; */
/*						run; */
/**/
/*						proc freq data = lung_irae_icd_match; */
/*						table dx_domain_4; */
/*						run; */


/*

			/* Place first appearing dx in a single column */ 

			data lung_irae_icd_match; 
			set lung_irae_icd_match; 
			if dx_domain_1 ne '.' then icd_dx = ICD_DGNS_CD1; 
			else if dx_domain_2 ne '.' then icd_dx = ICD_DGNS_CD2; 
			else if dx_domain_3 ne '.' then icd_dx = ICD_DGNS_CD3; 
			else if dx_domain_4 ne '.' then icd_dx = ICD_DGNS_CD4; 
			if dx_domain_1 ne '.' then icd_dx_domain = dx_domain_1; 
			else if dx_domain_2 ne '.' then icd_dx_domain = dx_domain_2; 
			else if dx_domain_3 ne '.' then icd_dx_domain = dx_domain_3;
			else if dx_domain_4 ne '.' then icd_dx_domain = dx_domain_4; 
			run; 

				proc print data = lung_irae_icd_match (obs = 20); 
				run; 

			/* De-duplicate list: remove duplicate claims */
			proc sort data = lung_irae_icd_match out = lung_irae_icd_match_dedupe nodupkey;
			by patient_id claim_dt_format icd_dx ;
			run; 


				proc contents data = lung_irae_icd_match; 
				run; 

					/* 9076 records */ 
				
				proc contents data = lung_irae_icd_match_dedupe; 
				run; 

					/* 6954 records */ 

				proc freq data = lung_irae_icd_match_dedupe; 
				table icd_dx_domain; 
				run; 


				/* 

				icd_dx_domain Frequency Percent CumulativeFrequency CumulativePercent 
				cardiovascular 300 4.31 300 4.31 
				endocrine 2484 35.72 2784 40.03 
				gastrointestinal 291 4.18 3075 44.22 
				hematologic 86 1.24 3161 45.46 
				musculoskeletal 14 0.20 3175 45.66 
				nervous system 2 0.03 3177 45.69 
				ocular 5 0.07 3182 45.76 
				pulmonary 3050 43.86 6232 89.62 
				renal 249 3.58 6481 93.20 
				skin 473 6.80 6954 100.00 



				*/


			/* Add running count of appearances per person and total count. */

			/* (If need to re-do, drop the columns created in this step first) */

/*							data lung_irae_icd_match_dedupe; */
/*							set lung_irae_icd_match_dedupe (drop = icd_count icd_total); */
/*							run; */

					proc sort data = lung_irae_icd_match_dedupe;
					by patient_id claim_dt_format; 
					run; 

			data lung_irae_icd_match_dedupe; 
			set lung_irae_icd_match_dedupe; 
			by patient_id; 
			if first.patient_id then icd_count = 1; 
			else icd_count+1; 
			run; 

				proc sort data = lung_irae_icd_match_dedupe; 
				by patient_id descending icd_count; 
				run; 

				data lung_irae_icd_match_dedupe; 
				set lung_irae_icd_match_dedupe; 
				by patient_id; 
				retain icd_total; /* icd_total retains its value across rows for each patient_id */
				if first.patient_id then icd_total = icd_count; 
				run; 

					proc sort data = lung_irae_icd_match_dedupe; 
					by patient_id icd_count; 
					run; 

					proc print data = lung_irae_icd_match_dedupe (obs = 20); 
					run; 


			/* Histogram: Days from Index: by first dx, and by dx type */ 

			/* All dx, all dates */ 
			ods graphics on;
			proc univariate data = lung_irae_icd_match_dedupe noprint;
			Title 'Distribution of Time from Index Date to irAE code';
			histogram daysfromindex;
			run; 
			ods graphics off;

			/* (restricted to first 250 days follow-up) */ 

			/* First dx */
			ods graphics on;
			proc univariate data = lung_irae_icd_match_dedupe noprint;
			where icd_count = 1 & daysfromindex < 250;
			Title 'Distribution of Time from Index Date for first irAE code';
			histogram daysfromindex;
			run; 
			ods graphics off;

			/* By dx domain (first dx) */ 
			ods graphics on;
			proc univariate data = lung_irae_icd_match_dedupe noprint;
			where icd_count = 1 & daysfromindex < 250;
			Title 'Distribution of Time from Index Date for first irAE dx- By Domain';
			histogram daysfromindex;
			class icd_dx_domain; /* 10 domains */
			run; 
			ods graphics off;

				/* Nervous system appear later- mode is around 40 days- others seem to most commonly occur after 14-20 days */


			/* How many unique patients? */ 
			proc freq data = lung_irae_icd_match_dedupe nlevels;
			table patient_id /noprint;
			run; 

				/* 980 unique patients in this list of ICD dx of irae */ 



			/* For irAE v3: list of ICD dx, first per patient */
			data thesis.lung_irae_icd_first;
			set lung_irae_icd_match_dedupe; 
			where icd_count = 1; 
			run; /* 980 rows */ 
             



/* irAE Treatment Codes- for irAE v1, v2, v4, v5 */

		/* Guideline-concordant tx: 
			Corticosteroids (Prednisone, Methylprednisolone) 
			Levothyroxine (some thyroid irAE) 
			Triamcinolone (some skin irAE) 

			***NOTE: MAY ADD MORE PRODUCTS BASED ON JCM RECOMMENDATION (COMMITTEE THOUGHT PRUDENT)

			Infliximab (steroid-refractory irAE) */ 

	/* HCPCS codes (IV admin) */

			/* Filter NCH line records on updated list of eligible cohort patients */ 

			proc sql; 
			create table nch_lung_irae_tx as
			select * 
			from seer.nchline_lung
			where patient_id in (select patient_id from thesis.cohort);
			quit;

			data nch_lung_irae_tx;
			set nch_lung_irae_tx;
			record_source = "NCH";
			run; 


			/* Filter Outpatient revenue records on updated list of eligible cohort patients */ 
			proc sql; 
			create table outrev_lung_irae_tx as
			select * 
			from seer.outrev_lung
			where patient_id in (select patient_id from thesis.cohort);
			quit;

			data outrev_lung_irae_tx;
			set outrev_lung_irae_tx;
			record_source = "Outpatient";
			run; 


			/* Combine NCH and Outpatient files, conserving just a few common data columns */ 
			data combined_lung_irae_tx;
			set nch_lung_irae_tx (keep = patient_id clm_id HCPCS_CD CLM_THRU_DT record_source) outrev_lung_irae_tx (keep = patient_id clm_id HCPCS_CD CLM_THRU_DT record_source);
			tx_dt = input(clm_thru_dt, yymmdd10.);
			format tx_dt date9.;
			run; 


				/* Merge in ICI index date */ 
					proc sort data = combined_lung_irae_tx; 
					by patient_id;
					run;

					proc sort data = thesis.cohort;
					by patient_id; 
					run;

				data thesis.combined_lung_irae_tx; 
				merge combined_lung_irae_tx (in = a) 
						thesis.cohort(keep = patient_id ici_index_dt in = b);
				by patient_id;
				if a;
				run; 

		/* Query this list on HCPCS codes for treatments of interest after ICI index date */

			data thesis.combined_lung_irae_tx; 
			set thesis.combined_lung_irae_tx; 
			where HCPCS_CD in ('J7510', 'J2650', 'J7512', 'J7506', 'J7509', 'J1040', 'J1030', 'J1020', 'J2930', 'J2920', 'J3300', 'J3301', 'J7684', 'J1745', 'Q5102', 'Q5103', 'Q5104', 'Q5109')
			and intck('day', ici_index_dt, tx_dt) >0;
			run; 

				/* 609 records of prednisone, methylprednisolone, triamcinolone or infliximab among patients who also had a 'irAE' ICD code after ICI index date */
				
				/* Add drug name to the list */ 
				data thesis.combined_lung_irae_tx; 
				set thesis.combined_lung_irae_tx;
				if HCPCS_CD in ('J7510', 'J2650', 'J7512', 'J7506', 'J7509') then tx_name = "prednisone"; 
				else if HCPCS_CD in ('J7509', 'J1040', 'J1030', 'J1020', 'J2930', 'J2920') then tx_name = "methylprednisolone";
				else if HCPCS_CD in ('J3300', 'J3301', 'J7684') then tx_name = "triamcinolone"; 
				else if HCPCS_CD in ('J1745', 'Q5102', 'Q5103', 'Q5104', 'Q5109') then tx_name = "infliximab";
				run;

					proc print data = thesis.combined_lung_irae_tx (obs = 10); 
					run; 

					proc freq data = thesis.combined_lung_irae_tx; 
					table tx_name;
					run; 

					/*
					The FREQ Procedure

					tx_name Frequency Percent Cumulative
					Frequency CumulativePercent 
					infliximab 3 0.49 3 0.49
					methylpred 420 68.97 423 69.46 
					prednisone 53 8.70 476 78.16 
					triamcinol 133 21.84 609 100.00 



					*/ 

	/* NDC Codes (non-hospital admin, levothyroxine is NDC only) */ 

			/* Filter PDE file on membership on the lung cancer patient list */ 


		/* 2012-2013 PDE files */
		proc sql; 
		create table pde_lung_1213_irae_tx as
		select *
		from seer.pdesaf1213
		where patient_id in(select distinct patient_id from thesis.cohort);
		quit; 

		/* 2014-2019 PDE files */
		proc sql; 
		create table pde_lung_1419_irae_tx as
		select *
		from seer.pdesaf1419
		where patient_id in(select distinct patient_id from thesis.cohort);
		quit; 



		/* Merge the 2 datasets conserving common data columns-- 40/42 of the 2012-2013 data columns and 40/43 of the 2014-2019 data columns */ 
		data thesis.pde_lung;
		set pde_lung_1213_irae_tx (keep = BENEFIT_PHASE BN BRND_GNRC_CD CMPND_CD CTSTRPHC_CVRG_CD CVRD_D_PLAN_PD_AMT DAW_PROD_SLCTN_CD DAYS_SUPLY_NUM DRUG_CVRG_STUS_CD DSPNSNG_STUS_CD FILL_NUM FORMULARY_ID FRMLRY_RX_ID GCDF GCDF_DESC GDC_ABV_OOPT_AMT GDC_BLW_OOPT_AMT GNN LICS_AMT NCVRD_PLAN_PD_AMT OTHR_TROOP_AMT PATIENT_ID PDE_ID PDE_PRSCRBR_ID_FRMT_CD PD_DT PHRMCY_SRVC_TYPE_CD PLAN_CNTRCT_REC_ID PLAN_PBP_REC_NUM PLRO_AMT PRCNG_EXCPTN_CD PROD_SRVC_ID PTNT_PAY_AMT PTNT_RSDNC_CD QTY_DSPNSD_NUM RPTD_GAP_DSCNT_NUM RX_ORGN_CD SRVC_DT STR SUBMSN_CLR_CD TOT_RX_CST_AMT)
			pde_lung_1419_irae_tx (keep = BENEFIT_PHASE BN BRND_GNRC_CD CMPND_CD CTSTRPHC_CVRG_CD CVRD_D_PLAN_PD_AMT DAW_PROD_SLCTN_CD DAYS_SUPLY_NUM DRUG_CVRG_STUS_CD DSPNSNG_STUS_CD FILL_NUM FORMULARY_ID FRMLRY_RX_ID GCDF GCDF_DESC GDC_ABV_OOPT_AMT GDC_BLW_OOPT_AMT GNN LICS_AMT NCVRD_PLAN_PD_AMT OTHR_TROOP_AMT PATIENT_ID PDE_ID PDE_PRSCRBR_ID_FRMT_CD PD_DT PHRMCY_SRVC_TYPE_CD PLAN_CNTRCT_REC_ID PLAN_PBP_REC_NUM PLRO_AMT PRCNG_EXCPTN_CD PROD_SRVC_ID PTNT_PAY_AMT PTNT_RSDNC_CD QTY_DSPNSD_NUM RPTD_GAP_DSCNT_NUM RX_ORGN_CD SRVC_DT STR SUBMSN_CLR_CD TOT_RX_CST_AMT);
			tx_dt = input(srvc_dt, yymmdd10.);
			format tx_dt date9.;
			run; 

			proc print data = thesis.pde_lung (obs = 10); 
			run; 


/*		proc sql; */
/*		create table pde_appearances as*/
/*		select patient_id,*/
/*		count(distinct pde_id) as n_pde_id*/
/*		from seer.pde_lung*/
/*		group by patient_id;*/
/*		quit; */
/**/
/*		proc means data = pde_appearances n mean std min q1 median q3 max;*/
/*		var n_pde_id;*/
/*		run; */


		/* Find oral/non-hospital use of corticosteroids using NDC codes */ 
			
			/* Merge in ICI index date */ 
			proc sort data = thesis.pde_lung; 
			by patient_id;
			run; 

			proc sort data = thesis.cohort;
			by patient_id; 
			run; 

				data thesis.pde_lung; 
				merge thesis.pde_lung (in = a) 
						thesis.cohort (keep = patient_id ici_index_dt in = b);
				by patient_id;
				if a;
				run; 


		data thesis.pde_lung_irae_tx_oral; 
		set thesis.pde_lung; 
		where PROD_SRVC_ID in ('00054981725', '00054981729', '00054981825', '00054981829', '00591544201', '00591544205', '00591544210', '00591544221', '00591544243', '00591544301', '00591544305', '00591544310', '00378064201', '00378064205', '00378064210', '00615154239', '00143147301', '00143147305', '00143147310', '00143147325', '00143147701', '00143147705', '00143147710', '00143147725', '24236021713', '24236021755', '24236021758', '24236024803', '24236024810', '24236024813', '24236024853', '24236024858', '24236041803', '24236041813', '24236041853', '24236041855', '24236041858', '24236062504', '24236062513', '24236062520', '43063010910', '43063043210', '43063043212', '43063043214', '43063043215', '43063043220', '43063043221', '43063043230', '45802030321', '45802030367', '49349055002', '49349055003', '49349055008', '49349055013', '49349055050', '49349060702', '49349060703', '49349060708', '49349060757', '49349071702', '49349072502', '49349078302', '49349078353', '49349099702', '52125005402', '52125052255', '52125077502', '52125077503', '52125077508', '52125077513', '52125077515', '52125077538', '52125077550', '52125095702', '52125095703', '52125095706', '52125095713', '52125095749', '52125095753', '52125095755', '52125095758', '58118973800', '58118973801', '58118973802', '58118973803', '58118973808', '61786004902', '61786004903', '61786004908', '61786004913', '61786004915', '61786004938', '61786004950', '00378064101', '00378064110', '55700073321', '49999011000', '49999011006', '49999011007', '49999011010', '49999011015', '49999011018', '49999011020', '49999011021', '49999011030', '50436432501', '50436432502', '50436432602', '52125099603', '53808054201', '53808054301', '54569033100', '54569033101', '54569033102', '54569033104', '54569033105', '54569033107', '54569033108', '54569033201', 
				'54569033202', '54569033203', '54569033205', '54569033209', '54569033300', '54569330200', '54569330201', '54569584000', '54868118300', '54868118301', '54868118302', '54868118303', '54868118304', '54868118306', '54868118307', '54868118308', '54868118309', '54868523000', '55154494600', '55154495000', '55154496509', '55695001500', '55695002400', '58118001801', '58118001802', '58118001803', '58118001808', '58118533800', '58118533801', '58118533803', '58118533808', '59746017306', '59746017309', '59746017310', '59746017506', '59746017509', '59746017510', '61786063308', '61919099507', '63187003705', '63187003708', '63187003709', '63187003710', '63187003720', '63187003721', '63187003730', '63187003740', '63187003742', '64725147301', '00054001720', '00054001725', '00054001729', '00054001820', '00054001825', '00054001829', '00054001920', '00054001925', '16590032610', '16590032615', '16590032620', '16590032621', '16590032630', '16590062421', '16590062448', '24236010703', '42549064714', '60219170701', '60219170703', '60219170705', '60219170801', '60219170805', '54348050610', '54348050620', '70518110500', '70518110501', '70518110502', '70518110503', '70518110504', '71335173601', '71335173602', '71335173603', '71335173604', '71335173605', '71335173606', '71335152500', '71335152501', '71335152502', '71335152503', '71335152504', '71335152505', '71335152506', '71335152507', '71335152508', '71335152509', '71335151601', '71335151602', '71335151603', '71335151604', '71335151605', '71335151606', '71335151607', '71205040710', '71205040715', '71205040718', '71205040720', '71205040721', '71205040730', '71205040760', '71205040790', '70954006010', '70954006020', '70954006030', '70518024200', '70518024201', '70518024202', '70518024203', '70518024204', '70518024205', '61786053802', '61786053803', 
				'61786053855', '61786053858', '63187030005', '63187030006', '63187030008', '63187030009', '63187030010', '63187030012', '63187030015', '63187030018', '63187030020', '63187030021', '63187030024', '63187030027', '63187030028', '63187030030', '63187030036', '63187030040', '63187030042', '63187080705', '63187080706', '63187080707', '63187080708', '63187080709', '63187080710', '63187080712', '63187080714', '63187080715', '63187080718', '63187080720', '63187080721', '63187080724', '63187080730', '63187080740', '63187080742', '50090280400', '50090280401', '50090280402', '50090280405', '50090280407', '55700072820', '55700072821', '43063009706', '43063009709', '70518156100', '70518156101', '70518047300', '70518047301', '70518047302', '70518047303', '60760061518', '70954006110', '60760071512', '60760071521', '72189024607', '71335191500', '71335191501', '71335191502', '71335191503', '71335191504', '71335191505', '71335191506', '71335191507', '71335191508', '71335191509', '51655070118', '51655070120', '51655070153', '10544004620', '10544004630', '10544004642', '43063070305', '43063070306', '43063070309', '43063070310', '43063070312', '43063070314', '43063070315', '43063070318', '43063070320', '43063070321', '43063070325', '43063070330', '45865067040', '52959012600', '52959012605', '52959012607', '52959012610', '52959012612', '52959012614', '52959012615', '52959012618', '52959012620', '52959012621', '52959012625', '52959012630', '52959012637', '52959012640', '52959012642', '52959012644', '52959012645', '52959012650', '52959012660', '52959012670', '52125025505', '54569304300', '54569304301', '54569304302', '54569304305', '54569304306', '54569304307', '55289033005', '55289033007', '55289033010', '55700020310', '55700020314', '55700020315', '55700020318', '55700020320', '55700020321', 
				'55700020330', '55700020815', '55700020820', '55700020821', '55700020830', '55700020840', '55700020848', '55700020860', '58118544208', '60687013401', '60687013411', '63187008505', '63187008506', '63187008509', '63187008510', '63187008515', '63187008520', '63187008521', '63187008524', '63187008530', '63629157900', '63629157901', '63629157902', '63629157903', '63629157904', '63629157905', '63629157906', '63629157907', '63629157908', '63629157909', '64380078401', '64380078406', '64380078407', '64380078408', '64380078501', '64380078506', '64380078507', '64380078508', '70518030700', '60687014501', '60687014511', '00440816701', '00440816705', '00440816710', '00440816715', '10544050907', '10544050910', '10544050912', '10544050915', '10544050920', '10544050930', '00463614105', '10544004515', '10544004520', '10544004820', '10544004842', '10544009342', '10544012510', '10544012515', '10544012530', '10544047320', '10544050820', '10544050830', '10544050842', '10544053821', '10544053830', '10544091420', '10544091421', '10544091510', '10544091530', '12634018800', '12634018801', '12634018852', '12634018854', '12634018855', '12634018857', '12634018871', '12634018879', '12634018880', '12634018881', '12634018882', '12634018884', '12634018885', '12634018891', '21695030620', '21695030621', '21695030628', '21695030630', '21695030636', '21695030639', '21695030642', '21695030650', '21695030710', '21695030712', '21695030714', '21695030715', '21695030720', '21695030721', '21695030730', '33261012900', '33261012910', '33261012912', '33261012915', '33261012920', '33261012921', '33261012927', '33261012930', '33261012940', '33261012942', '33261012948', '33261012950', '33261012960', '33261012990', '33261035200', '33261035210', '33261035212', '33261035215', '33261035220', '33261035221', '33261035227', 
				'33261035230', '33261035240', '33261035242', '33261035248', '33261035250', '33261035260', '33261035290', '21695076521', '21695076548', '35356067400', '35356067410', '35356067415', '35356067418', '35356067420', '35356067421', '35356067430', '35356067460', '35356067490', '35356067712', '35356067714', '35356067715', '35356067718', '35356067720', '35356067721', '35356067728', '35356067730', '35356067740', '35356067748', '35356067760', '35356067790', '35356081810', '35356081815', '35356081818', '35356081820', '35356081821', '35356081830', '43063042610', '43063042612', '43063042620', '43063042621', '43063042628', '43063042630', '43063042640', '43063042642', '43063042650', '43063042660', '43063047205', '43063047206', '43063047207', '43063047209', '43063047210', '43063047212', '43063047214', '43063047215', '43063047220', '43063047221', '43063047225', '43063047230', '43063059005', '43063059006', '43063059009', '43063059010', '43063059012', '43063059014', '43063059015', '43063059018', '43063059020', '43063059021', '43063059025', '43063059030', '43063064410', '43063064415', '43063064420', '43063064421', '43063064430', '43063064440', '43063064442', '43063064450', '43063064460', '43063060821', '43063061021', '50090009901', '50090009902', '50090009903', '50090009905', '50090009909', '50090010000', '50090010001', '50090010002', '50090010005', '50090010006', '50090010007', '42291077050', '42291077101', '42291077150', '48433032101', '48433032110', '50090010100', '50436175001', '50436175004', '51655032018', '51655032020', '51655032021', '51655032030', '51655032053', '51655032054', '52125055502', '52959012707', '52959012710', '52959012711', '52959012712', '52959012715', '52959012718', '52959012720', '52959012721', '52959012725', '52959012730', '52959012737', '52959012742', '53217025510', 
				'53217025512', '53217025514', '53217025520', '53217025521', '53217025524', '53217025527', '53217025530', '53217025540', '53217025542', '53217025548', '53217025550', '53217025560', '53217025590', '53217028807', '53217028810', '53217028812', '53217028814', '53217028815', '53217028818', '53217028820', '53217028821', '53217028830', '53217028860', '53808039901', '54868083600', '54868083601', '54868083602', '54868083603', '54868083604', '54868083605', '54868083606', '54868083607', '54868083608', '54868083609', '54868090800', '54868090801', '54868090803', '54868090805', '54868090806', '54868409500', '55700007215', '55700007218', '55700007220', '55700007221', '55700007230', '55700007260', '55700007290', '59115014001', '59115014010', '58118002708', '59115014101', '59115014110', '59115014155', '60429013101', '60429013105', '60429013110', '60429013201', '60429013205', '60429013210', '60760017935', '61919034205', '61919034210', '61919034212', '61919034214', '61919034220', '61919034221', '61919034230', '63629662101', '63629662102', '63629662103', '63629662104', '63629662105', '63629662106', '63629662107', '63629662108', '63629662109', '63629665801', '63629665901', '63629665902', '63629665903', '63629665904', '63629665905', '63629665906', '63629666001', '63629738801', '63739051910', '63739052010', '63739058810', '66336005815', '66336005890', '66336009415', '66336009421', '67296014001', '67296014002', '67296014003', '67296014009', '67296024701', '67296024702', '67296024703', '67296024705', '67296024706', '67296060001', '67296060002', '67296060003', '67296060201', '67296060202', '67296103201', '67296103203', '67296103204', '67296119403', '67296119405', '67296175501', '67296175502', '67296175507', '67296176701', '67296176703', '68071230401', '68071519502', '68387024010', '68387024025', 
				'68387024115', '68788147301', '68788147302', '68788147303', '68788147304', '68788147305', '68788147306', '68788147308', '68788147309', '68788641402', '68788644001', '68788644002', '68788644003', '68788644004', '68788644005', '68788644006', '68788644007', '68788644008', '68788644009', '68788917801', '68788917802', '68788917803', '68788917804', '68788917805', '68788917806', '68788917807', '68788917808', '68788917809', '68788917901', '68788917902', '68788917903', '68788917904', '68788917906', '68788917907', '68788917908', '68788917909', '68788950301', '68788950302', '68788950303', '68788950304', '68788950306', '68788950307', '68788950308', '68788950309', '68788951300', '68788951301', '68788951302', '68788951303', '68788951304', '68788951306', '68788951307', '68788951308', '68788951309', '69668012020', '70518020500', '70518094800', '70518112000', '70518192000', '70934029112', '70934029115', '70934029120', '70934029121', '70934029130', '70934029140', '70934029142', '70934058010', '70934058015', '70934058020', '70934058021', '70934058030', '70934058040', '70934058042', '76237022830', '59651048701', '59651048705', '59651048778', '59651048801', '59651048805', '59651048878', '59651048901', '59651048978', '71205046005', '71205046007', '71205046008', '71205046030', '71205046060', '71205046090', '68788816602', '68788816603', '68071266100', '68071266101', '68071266102', '68071266103', '68071266105', '00143973901', '00143973905', '00143973910', '00527293337', '00527293341', '70954005910', '70954005920', '70954005930', '70954005940', '63187024305', '63187024307', '63187024308', '63187024310', '63187024315', '63187024320', '63187024321', '63187024330', '63187024340', '64380094901', '64380094906', '68071220901', '68071220906', '68071269604', '68071523301', '68071524200', '68071524201', 
				'68071524202', '68071524203', '68071524204', '68071524205', '68071524206', '68071524207', '68071524208', '68788821201', '68788821202', '68788821203', '68788821205', '68788821208', '70518255500', '70518255501', '70518291600', '70518291601', '70518291602', '70518291603', '70518291604', '70518291605', '70518291606', '70518291607', '70518291608', '70934009606', '70934009610', '70934009612', '70934009615', '70934009620', '70934009621', '70934009630', '71205066505', '71205066510', '71205066520', '71205066521', '71205066524', '71205066530', '71205066560', '71205066590', '71335206900', '71335206901', '71335206902', '71335206903', '71335206904', '71335206905', '71335206906', '71335206907', '71335206908', '71335206909', '71335207900', '71335207901', '71335207902', '71335207903', '71335207904', '71335207905', '71335207906', '71335207907', '71335207908', '71335207909', '71335212201', '71335212202', '71335212203', '00527293437', '00527293441', '00603533915', '00603533921', '00603533928', '00603533931', '00603533932', '00615839105', '00615839130', '00615839139', '71205040305', '71205040306', '71205040307', '71205040310', '71205040312', '71205040330', '71205040360', '71205040390', '70518030600', '70518030601', '00143973801', '00143973805', '00143973810', '00603533815', '00603533821', '00603533828', '00603533831', '00603533832', '67296097401', '67296097402', '67296097405', '70518007300', '70518007301', '70518007302', '70518007303', '70518007304', '70518007305', '70518007306', '70518007307', '70518007308', '71329010301', '71329010302', '71329010401', '71329010402', '71329010501', '50090612201', '50090612202', '50090612203', '50090612205', '50090612209', '50090612300', '50090612301', '50090612302', '50090612305', '50090612307', '71335216001', '71335216002', '71335216003', '71335216004', 
				'71335216005', '71335216006', '71335216007', '71205042110', '71205042118', '71205042120', '71205042121', '71205042124', '71205042128', '71205042130', '71205042140', '71205042142', '71205042160', '71205042190', '71205042163', '60760079012', '60760079021', '68071277106', '68071277101', '70518213800', '70518213801', '70518213802', '70518213803', '70518354000', '70518355500', '68788763701', '68788763702', '68788763703', '68788763704', '68788763706', '68788763707', '68788763708', '68788763709', '68788930901', '68788930902', '68788930903', '68788930904', '68788930905', '68788930906', '68788930907', '68788930908', '68788930909', '61919023510', '61919023515', '61919023521', '61919023530', '61919023540', '61919023542', '68788811601', '68788811602', '68788811603', '68788811604', '68788811605', '68788811606', '68788811607', '68788811608', '68788811609', '00615844005', '00615844039', '71205072910', '71205072914', '71205072920', '71205072921', '71205072930', '71205072960', '71205072963', '71205072990', '68071278100', '68071278102', '68071278107', '68071278103', '00615844139', '50090622500', '50090625900', '00615359305', '00615359330', '00615359339', '63629158700', '63629158701', '63629158702', '63629158703', '63629158704', '63629158705', '63629158706', '63629158707', '63629158708', '63629158709', '68788775200', '68788775201', '68788775202', '68788775203', '68788775204', '68788775205', '68788775206', '68788775208', '68788775209', '70518155300', '70518155301', '55154494900', '61919032621', '61919032605', '61919032630', '70934025921', '70934025930', '70934025942', '49999002812', '49999002814', '49999002815', '49999002820', '49999002821', '49999002830', '49999002840', '49999002848', '49999002860', '49999002865', '50090009700', '50090009701', '50090009702', '50090009704', '50090009705', 
				'50090009707', '50090009708', '50090009800', '50090009801', '50090010200', '50090100100', '50090100200', '50090199000', '50090199001', '50090199002', '50090199005', '50090199007', '50090253200', '50090253201', '50090253202', '50090253204', '50090253205', '50090253207', '50090253208', '50090260800', '50090260801', '50090278901', '50090278902', '50090278903', '50090278905', '50090278909', '50090478401', '50090478402', '50090478403', '50090478405', '50090478409', '50090478500', '50090478501', '50090478502', '50090478505', '50090478507', '50090545300', '50090565701', '50090566000', '51655072621', '61919040421', '61919040430', '67296141903', '70518185400', '70518185401', '70518211500', '70518211501', '70518211502', '70518313800', '70518313801', '70934013705', '70934013707', '70934021810', '70934021815', '70934021820', '70934021821', '70934021830', '70934067412', '70934083110', '70934083112', '70934083115', '70934083120', '70934083121', '70934083130', '70934083140', '70934083142', '00527293537', '50090198901', '50090198902', '50090198903', '50090198905', '50090198909', '50090199100', '50090278600', '63629456201', '63629456202', '63629456203', '63629456204', '63629456205', '63629456206', '63629456207', '10135077701', '10135077710', '10135077801', '10135077805', '10135077810', '10135077901', '42291078350', '42708016621', '51655034907', '51655034955', '50090637600', '51655020820', '51655020818', '51655020827', '51655020852', '51655020853', '51655020854', '51655020855', '51655020821', '51655024253', '51655041020', '51655041049', '51655041021', '51655041027', '51655041052', '51655041053', '51655041054', '51655041621', '51655041654', '51655048855', '51655049349', '51655071655', '51655077952', '51655093520', '51655093907', '51655093955', '51655097220', '51655097221', '51655097227', 
				'51655097251', '51655097252', '51655097253', '51655097254', '67296144401', '67296144402', '67296144407', '67296144601', '67296145501', '67296145503', '67296145508', '67296145509', '67296145701', '67296145702', '67296145703', '67296145707', '67296182705', '70518231400', '70518231401', '70518231402', '70518231403', '70518340100', '70518340101', '70518340102', '70518347600', '70518347601', '70518347602', '70518347603', '70934009512', '70934009515', '70934009520', '70934009521', '70934009530', '70934009540', '70934009542', '70934030710', '70934030715', '70934030718', '70934030720', '70934030721', '70934030730', '70934047110', '70934047112', '70934047115', '70934047118', '70934047120', '70934047105', '70934047121', '70934047130', '70934047140', '71205074106', '71205074110', '71205074114', '71205074115', '71205074120', '71205074121', '71205074124', '71205074128', '71205074130', '71205074160', '71205074190', '71205075505', '71205075506', '71205075507', '71205075510', '71205075512', '71205075514', '71205075515', '71205075518', '71205075520', '71205075521', '71205075524', '71205075528', '71205075530', '71205075560', '71205075590', '71205079710', '71205079714', '71205079720', '71205079721', '71205079730', '71205079760', '71205079790', '71335214901', '71335214902', '71335214903', '71335214904', '71335214905', '71335214906', '71335214907', '72189043010', '72189043020', '72189043021', '80425010501', '80425010502', '82982004163', '82982004215', '70934054305', '50090565601', '50090565602', '50090565605', '50090565607', '50090565600', '50090565604', '50090565608', 
			'51662148301', '68382091801', '68382091805', '68382091818', '68382091877', '68382091901', '68382091905', '68382091911', '68382091977', '70771135001', '70771135004', '70771135005', '70771135007', '70771135101', '70771135104', '70771135105', '70771135108', '00409568423', '00409568523', '49349075501', '49349075508', '49349094801', '00703004501', '00703005101', '00703005104', '00703006301', '54868059000', '55045324305', '55154392905', '55154393205', '00009000302', '00009075801', '55150026203', '55150026303', '55150026420', '55154393905', '55154938305', '55154955705', '61699004702', '63323025503', '63323025803', '00009007301', '00009017601', '00009354701', '54771354701', '59746000314', '59746001504', '59762005001', '59762005101', '00009027401', '00703003101', '00703003104', '00703004301', '00009307301', '00009307303', '00009307322', '00009307323', '51662142901', '70121157401', '70121157405', '69665021001', '69665031001', '70121157301', '70121157305', '00009347501', '00009347503', '00009347522', '00009347523', '00781313171', '00781313195', '49349084041', '50090225300', '52125051501', '52584011312', '52584019009', '53217012301', '54569155500', '54569155501', '55154394005', '55154394008', '55154394405', '63187047401', '70121100001', '70121100005', '70121100101', '70121100105', '00009079601', '00179012470', '00781313271', '00781313295', '00781313670', '00781313775', '21695084910', '21695085005', '21695095205', '25021080705', '25021080810', '53225365001', '61786002757', '70385201601', '70518051600', '70518108800', '70518142400', '55154394105', '55154394108', '70518202300', '70518202301', '70518245900', '50090209800', '52584003930', '52584004725', '50090027100', '50090027101', '50090031201', '50090043600', '50090055600', '50090182300', '00009003906', '00009003928', '00009003930', 
			'00009003932', '00009003933', '00009004704', '00009004722', '00009004725', '00009004726', '00009004727', '00009028002', '00009028003', '00009028024', '00009028025', '00009028051', '00009028052', '00009030602', '00009030612', '00009030624',
		'00703024101', '00703024301', '00703024501', '16714013001', '16714013025', '16714014001', '16714015001', '70121116801', '70121116901', '00003031505', '00003031520', '52125071201', '52125071208', '70121165401', '70121165101', '70121165105', '70121165201', '70121165301', '70121165501', '70121165701', '70121165705', '00003029305', '00003029320', '00003029328', '54868023500', '54868023501', '54868023502', '55045324801', '55045324804', '70121104902', '70121104905', '00003049420', '00781308475', '21695036001', '21695036010', '49349094641', '49349094741', '53225361001', '54868023400', '68258890305', '68788063601', '70529004801', '70529004802', '70529004803', '50090025600', '50090029501', '50090081900', '50090236000', '63187066101', '70518007500',
	'0074372719', '0074434119', '0074455211', '0074518211', '0074659419', '0074662411', '0074706811', '0074706911', '0074707019', '0074714811', '0074714919', '0074929619', '0378180010', '0378180310', '0378180510', '0378180710', '0378180910', '0378181110', '0378181310', '0378181510', '0378181710', '0378181910', '0378182177', '0378182310', '0480868201', '0480868701', '0480869001', '0480869301', '0480870101', '0480870401', '0480870701', '0480871001', '0480871501', '0480871801', '0480872210', '0480872501', '0527328043', '0527328143', '0527328243', '0527328343', '0527328443', '0527328543', '0527328643', '0527328743', '0527328843', '0527328943', '0527329043', '0527329143', '0527495132', '0527495232', '0527495332', '0527495432', '0527495532', '0527495632', '0527495732', '0527495832', '0527495932', '0527496032', '0527496132', '0527496232', '0904694961', '0904695061', '0904695161', '0904695261', '0904695361', '0904695461', '0904695561', '0904695661', '0904695761', '1672944715', '1672944815', '1672944915', '1672945015', '1672945115', '1672945215', '1672945315', '1672945415', '1672945515', '1672945615', '1672945715', '1672945815', '2420100201', '2433801614', '2433803214', '2433806514', '2433809714', '2433811314', '3172228401', '3172228501', '3172228601', '3172228701', '3172228801', '3172228901', '3172229001', '3172229101', '3172229201', '3172229301', '3172229401', '3172229501', '3334239310', '3334239410', '3334239510', '3334239610', '3334239710', '3334239810', '3334239910', '3334240010', '3334240110', '3334240210', '3334240310', '3334240410', '4202320101', '4202320201', '4202320301', '4219232701', '4219232801', '4219232901', '4219233001', '4219233101', '4229203820', '4229203920', '4229204020', '4229204120', '4335329660', '4360241710', '4360241810', '4360241910', '4360242010', '4360242110', 
	'4360242210', '4360242310', '4360242410', '4360242510', '4360242610', '4360242710', '4360242810', '4374209551', '4778164010', '4778164310', '4778164610', '4778164910', '4778165110', '4778165410', '4778165710', '4778165910', '4778166210', '4778166510', '4778166810', '4778167110', '4950237815', '5009046250', '5009046670', '5009046680', '5009046700', '5009046880', '5009047990', '5009051760', '5009052160', '5009052290', '5009057920', '5009058210', '5009058870', '5009060870', '5009060890', '5009060900', '5009061000', '5009061010', '5009061030', '5009061040', '5009061052', '5009061150', '5009061160', '5009061180', '5107944020', '5107944120', '5107944220', '5107944320', '5107944420', '5107944520', '5165512852', '5165545352', '5165547926', '5165548326', '5165548426', '5165548526', '5165551352', '5165552852', '5165553252', '5165553752', '5165554452', '5165555752', '5165557652', '5165557852', '5165557952', '5165558352', '5165560452', '5165568752', '5165569452', '5165569652', '5165570552', '5165571452', '5165572352', '5165572752', '5165572852', '5165573952', '5165574252', '5165578352', '5165584652', '5165592352', '5165592452', '5165598552', '5165598952', '5165599752', '5265219501', '5300211190', '5300258000', '5380811131', '5380811141', '5380811151', '5515435580', '5515435590', '5515435600', '5515435610', '5515435620', '5515435630', '5515443760', '5515443770', '5515453620', '5515453800', '5515453810', '5515453950', '5546610411', '5546610511', '5546610611', '5546610711', '5546610811', '5546610911', '5546611011', '5546611111', '5546611211', '5546611311', '5546611411', '5546611511', '6068745301', '6068746401', '6068747501', '6068748601', '6068749701', '6068750801', '6068751901', '6068753001', '6068754101', '6068755201', '6068756301', '6079385001', '6079385101', '6079385201', '6079385301', 
	'6079385401', '6079385501', '6079385601', '6079385701', '6079385801', '6079385901', '6079386001', '6084680101', '6084680201', '6084680301', '6084680401', '6084680501', '6084680601', '6084680701', '6084680801', '6084680901', '6084681001', '6084681101', '6084681201', '6191987290', '6318745930', '6318746030', '6318749630', '6318754930', '6318756930', '6318757230', '6318757330', '6318758130', '6318761130', '6318763530', '6318785130', '6318792430', '6318798230', '6332364710', '6332364894', '6332364894', '6332364994', '6332364994', '6332364994', '6332388514', '6332388514', '6332388514', '6332389010', '6332389510', '6362920881', '6362920891', '6362920901', '6362920911', '6362920921', '6362920941', '6362945561', '6362982651', '6362987111', '6362987121', '6362991881', '6668910502', '6679420002', '6679420102', '6807122789', '6807125313', '6807126239', '6807126989', '6807127319', '6807128029', '6807151779', '6807152269', '6807152279', '6807152359', '6818096501', '6818096601', '6818096701', '6818096801', '6818096901', '6818097001', '6818097101', '6818097201', '6818097301', '6818097401', '6818097501', '6818097601', '6878876893', '6878876971', '6878876983', '6878877043', '6878877201', '6878877243', '6878877253', '6878877283', '6878877291', '6878877591', '6878877643', '6878879113', '6878879291', '6878879421', '6878879431', '6878879441', '6878879451', '6878879533', '6878879543', '6878879693', '6878882893', '6878882903', '6878883823', '6923811631', '6923811641', '6923811681', '6923811691', '6923811771', '6923811781', '6923811831', '6923812751', '6923812761', '6923812771', '6923812781', '6923812791', '6923818301', '6923818311', '6923818321', '6923818331', '6923818341', '6923818351', '6923818361', '6923818371', '6923818381', '6923818391', '6923818401', '6923818411', '7051111110', '7051111210', 
	'7051111310', '7051826580', '7051827470', '7051831540', '7086045110', '7086045210', '7086045310', '7093488730', '7093489430', '7093489530', '7093489630', '7093489730', '7093489830', '7093489930', '7120501830', '7120522130', '7120522230', '7120523230', '7120523730', '7120524030', '7120524230', '7120525530', '7120526130', '7120535130', '7120535230', '7120535330', '7120535430', '7120538230', '7120551230', '7120554330', '7120564230', '7120564630', '7120565530', '7120568130', '7133504141', '7133514231', '7133514351', '7133514381', '7133514471', '7133514561', '7133514651', '7133514781', '7133515021', '7133515121', '7133515281', '7133516371', '7133517341', '7133518141', '7133518271', '7133518281', '7133518611', '7133519401', '7133519451', '7133519471', '7133519551', '7133519661', '7133519871', '7133519981', '7133520071', '7133520901', '7133521381', '7133596171', '7185800051', '7185800101', '7185800121', '7185800131', '7185800151', '7185800171', '7185800201', '7185800251', '7185800301', '7185800351', '7185800401', '7185800451', '7185800501', '7185800551', '7185800601', '7185801051', '7185801101', '7185801121', '7185801131', '7185801151', '7185801171', '7185801201', '7185801251', '7185801301', '7185801351', '7185801401', '7185801451', '7185801501', '7185801551', '7185801601', '7218901490', '7218907390', '7218910730', '7218915530', '7218915930', '7218916030', '7218916390', '7218917330', '7218917430', '7218920290', '7218920630', '7218921890', '7218925090', '7218934690', '7230502530', '7230505030', '7230507530', '7230508830', '7230510030', '7230511230', '7230512530', '7230513730', '7230515030', '7230517530', '7230520030', '7278927230', '7278929730', '7286523610', '7286523710', '7286523810', '7286523910', '7286524010', '7286524110', '7286524210', '7286524310', '7286524410', '7286524510', 
	'7286524610', '7286524710', '7642056801', '7642056901', '7642057001', '8234700054', '8234700104', '8234700154', '8234700204', '8234700254', '8234700304', '8234700354', '8234700404', '8234700454', '8234700504', '8234700554', '8234700604')
		and intck('day', ici_index_dt, tx_dt) >0;
		run; 

			/* 1556 observations */ 



		/* Add irAE tx name data labels */

		data thesis.pde_lung_irae_tx_oral; 
		set thesis.pde_lung_irae_tx_oral;
		if PROD_SRVC_ID in('00054981725', '00054981729', '00054981825', '00054981829', '00591544201', '00591544205', '00591544210', '00591544221', '00591544243', '00591544301', '00591544305', '00591544310', '00378064201', '00378064205', '00378064210', '00615154239', '00143147301', '00143147305', '00143147310', '00143147325', '00143147701', '00143147705', '00143147710', '00143147725', '24236021713', '24236021755', '24236021758', '24236024803', '24236024810', '24236024813', '24236024853', '24236024858', '24236041803', '24236041813', '24236041853', '24236041855', '24236041858', '24236062504', '24236062513', '24236062520', '43063010910', '43063043210', '43063043212', '43063043214', '43063043215', '43063043220', '43063043221', '43063043230', '45802030321', '45802030367', '49349055002', '49349055003', '49349055008', '49349055013', '49349055050', '49349060702', '49349060703', '49349060708', '49349060757', '49349071702', '49349072502', '49349078302', '49349078353', '49349099702', '52125005402', '52125052255', '52125077502', '52125077503', '52125077508', '52125077513', '52125077515', '52125077538', '52125077550', '52125095702', '52125095703', '52125095706', '52125095713', '52125095749', '52125095753', '52125095755', '52125095758', '58118973800', '58118973801', '58118973802', '58118973803', '58118973808', '61786004902', '61786004903', '61786004908', '61786004913', '61786004915', '61786004938', '61786004950', '00378064101', '00378064110', '55700073321', '49999011000', '49999011006', '49999011007', '49999011010', '49999011015', '49999011018', '49999011020', '49999011021', '49999011030', '50436432501', '50436432502', '50436432602', '52125099603', '53808054201', '53808054301', '54569033100', '54569033101', '54569033102', '54569033104', '54569033105', '54569033107', '54569033108', '54569033201', 
				'54569033202', '54569033203', '54569033205', '54569033209', '54569033300', '54569330200', '54569330201', '54569584000', '54868118300', '54868118301', '54868118302', '54868118303', '54868118304', '54868118306', '54868118307', '54868118308', '54868118309', '54868523000', '55154494600', '55154495000', '55154496509', '55695001500', '55695002400', '58118001801', '58118001802', '58118001803', '58118001808', '58118533800', '58118533801', '58118533803', '58118533808', '59746017306', '59746017309', '59746017310', '59746017506', '59746017509', '59746017510', '61786063308', '61919099507', '63187003705', '63187003708', '63187003709', '63187003710', '63187003720', '63187003721', '63187003730', '63187003740', '63187003742', '64725147301', '00054001720', '00054001725', '00054001729', '00054001820', '00054001825', '00054001829', '00054001920', '00054001925', '16590032610', '16590032615', '16590032620', '16590032621', '16590032630', '16590062421', '16590062448', '24236010703', '42549064714', '60219170701', '60219170703', '60219170705', '60219170801', '60219170805', '54348050610', '54348050620', '70518110500', '70518110501', '70518110502', '70518110503', '70518110504', '71335173601', '71335173602', '71335173603', '71335173604', '71335173605', '71335173606', '71335152500', '71335152501', '71335152502', '71335152503', '71335152504', '71335152505', '71335152506', '71335152507', '71335152508', '71335152509', '71335151601', '71335151602', '71335151603', '71335151604', '71335151605', '71335151606', '71335151607', '71205040710', '71205040715', '71205040718', '71205040720', '71205040721', '71205040730', '71205040760', '71205040790', '70954006010', '70954006020', '70954006030', '70518024200', '70518024201', '70518024202', '70518024203', '70518024204', '70518024205', '61786053802', '61786053803', 
				'61786053855', '61786053858', '63187030005', '63187030006', '63187030008', '63187030009', '63187030010', '63187030012', '63187030015', '63187030018', '63187030020', '63187030021', '63187030024', '63187030027', '63187030028', '63187030030', '63187030036', '63187030040', '63187030042', '63187080705', '63187080706', '63187080707', '63187080708', '63187080709', '63187080710', '63187080712', '63187080714', '63187080715', '63187080718', '63187080720', '63187080721', '63187080724', '63187080730', '63187080740', '63187080742', '50090280400', '50090280401', '50090280402', '50090280405', '50090280407', '55700072820', '55700072821', '43063009706', '43063009709', '70518156100', '70518156101', '70518047300', '70518047301', '70518047302', '70518047303', '60760061518', '70954006110', '60760071512', '60760071521', '72189024607', '71335191500', '71335191501', '71335191502', '71335191503', '71335191504', '71335191505', '71335191506', '71335191507', '71335191508', '71335191509', '51655070118', '51655070120', '51655070153', '10544004620', '10544004630', '10544004642', '43063070305', '43063070306', '43063070309', '43063070310', '43063070312', '43063070314', '43063070315', '43063070318', '43063070320', '43063070321', '43063070325', '43063070330', '45865067040', '52959012600', '52959012605', '52959012607', '52959012610', '52959012612', '52959012614', '52959012615', '52959012618', '52959012620', '52959012621', '52959012625', '52959012630', '52959012637', '52959012640', '52959012642', '52959012644', '52959012645', '52959012650', '52959012660', '52959012670', '52125025505', '54569304300', '54569304301', '54569304302', '54569304305', '54569304306', '54569304307', '55289033005', '55289033007', '55289033010', '55700020310', '55700020314', '55700020315', '55700020318', '55700020320', '55700020321', 
				'55700020330', '55700020815', '55700020820', '55700020821', '55700020830', '55700020840', '55700020848', '55700020860', '58118544208', '60687013401', '60687013411', '63187008505', '63187008506', '63187008509', '63187008510', '63187008515', '63187008520', '63187008521', '63187008524', '63187008530', '63629157900', '63629157901', '63629157902', '63629157903', '63629157904', '63629157905', '63629157906', '63629157907', '63629157908', '63629157909', '64380078401', '64380078406', '64380078407', '64380078408', '64380078501', '64380078506', '64380078507', '64380078508', '70518030700', '60687014501', '60687014511', '00440816701', '00440816705', '00440816710', '00440816715', '10544050907', '10544050910', '10544050912', '10544050915', '10544050920', '10544050930', '00463614105', '10544004515', '10544004520', '10544004820', '10544004842', '10544009342', '10544012510', '10544012515', '10544012530', '10544047320', '10544050820', '10544050830', '10544050842', '10544053821', '10544053830', '10544091420', '10544091421', '10544091510', '10544091530', '12634018800', '12634018801', '12634018852', '12634018854', '12634018855', '12634018857', '12634018871', '12634018879', '12634018880', '12634018881', '12634018882', '12634018884', '12634018885', '12634018891', '21695030620', '21695030621', '21695030628', '21695030630', '21695030636', '21695030639', '21695030642', '21695030650', '21695030710', '21695030712', '21695030714', '21695030715', '21695030720', '21695030721', '21695030730', '33261012900', '33261012910', '33261012912', '33261012915', '33261012920', '33261012921', '33261012927', '33261012930', '33261012940', '33261012942', '33261012948', '33261012950', '33261012960', '33261012990', '33261035200', '33261035210', '33261035212', '33261035215', '33261035220', '33261035221', '33261035227', 
				'33261035230', '33261035240', '33261035242', '33261035248', '33261035250', '33261035260', '33261035290', '21695076521', '21695076548', '35356067400', '35356067410', '35356067415', '35356067418', '35356067420', '35356067421', '35356067430', '35356067460', '35356067490', '35356067712', '35356067714', '35356067715', '35356067718', '35356067720', '35356067721', '35356067728', '35356067730', '35356067740', '35356067748', '35356067760', '35356067790', '35356081810', '35356081815', '35356081818', '35356081820', '35356081821', '35356081830', '43063042610', '43063042612', '43063042620', '43063042621', '43063042628', '43063042630', '43063042640', '43063042642', '43063042650', '43063042660', '43063047205', '43063047206', '43063047207', '43063047209', '43063047210', '43063047212', '43063047214', '43063047215', '43063047220', '43063047221', '43063047225', '43063047230', '43063059005', '43063059006', '43063059009', '43063059010', '43063059012', '43063059014', '43063059015', '43063059018', '43063059020', '43063059021', '43063059025', '43063059030', '43063064410', '43063064415', '43063064420', '43063064421', '43063064430', '43063064440', '43063064442', '43063064450', '43063064460', '43063060821', '43063061021', '50090009901', '50090009902', '50090009903', '50090009905', '50090009909', '50090010000', '50090010001', '50090010002', '50090010005', '50090010006', '50090010007', '42291077050', '42291077101', '42291077150', '48433032101', '48433032110', '50090010100', '50436175001', '50436175004', '51655032018', '51655032020', '51655032021', '51655032030', '51655032053', '51655032054', '52125055502', '52959012707', '52959012710', '52959012711', '52959012712', '52959012715', '52959012718', '52959012720', '52959012721', '52959012725', '52959012730', '52959012737', '52959012742', '53217025510', 
				'53217025512', '53217025514', '53217025520', '53217025521', '53217025524', '53217025527', '53217025530', '53217025540', '53217025542', '53217025548', '53217025550', '53217025560', '53217025590', '53217028807', '53217028810', '53217028812', '53217028814', '53217028815', '53217028818', '53217028820', '53217028821', '53217028830', '53217028860', '53808039901', '54868083600', '54868083601', '54868083602', '54868083603', '54868083604', '54868083605', '54868083606', '54868083607', '54868083608', '54868083609', '54868090800', '54868090801', '54868090803', '54868090805', '54868090806', '54868409500', '55700007215', '55700007218', '55700007220', '55700007221', '55700007230', '55700007260', '55700007290', '59115014001', '59115014010', '58118002708', '59115014101', '59115014110', '59115014155', '60429013101', '60429013105', '60429013110', '60429013201', '60429013205', '60429013210', '60760017935', '61919034205', '61919034210', '61919034212', '61919034214', '61919034220', '61919034221', '61919034230', '63629662101', '63629662102', '63629662103', '63629662104', '63629662105', '63629662106', '63629662107', '63629662108', '63629662109', '63629665801', '63629665901', '63629665902', '63629665903', '63629665904', '63629665905', '63629665906', '63629666001', '63629738801', '63739051910', '63739052010', '63739058810', '66336005815', '66336005890', '66336009415', '66336009421', '67296014001', '67296014002', '67296014003', '67296014009', '67296024701', '67296024702', '67296024703', '67296024705', '67296024706', '67296060001', '67296060002', '67296060003', '67296060201', '67296060202', '67296103201', '67296103203', '67296103204', '67296119403', '67296119405', '67296175501', '67296175502', '67296175507', '67296176701', '67296176703', '68071230401', '68071519502', '68387024010', '68387024025', 
				'68387024115', '68788147301', '68788147302', '68788147303', '68788147304', '68788147305', '68788147306', '68788147308', '68788147309', '68788641402', '68788644001', '68788644002', '68788644003', '68788644004', '68788644005', '68788644006', '68788644007', '68788644008', '68788644009', '68788917801', '68788917802', '68788917803', '68788917804', '68788917805', '68788917806', '68788917807', '68788917808', '68788917809', '68788917901', '68788917902', '68788917903', '68788917904', '68788917906', '68788917907', '68788917908', '68788917909', '68788950301', '68788950302', '68788950303', '68788950304', '68788950306', '68788950307', '68788950308', '68788950309', '68788951300', '68788951301', '68788951302', '68788951303', '68788951304', '68788951306', '68788951307', '68788951308', '68788951309', '69668012020', '70518020500', '70518094800', '70518112000', '70518192000', '70934029112', '70934029115', '70934029120', '70934029121', '70934029130', '70934029140', '70934029142', '70934058010', '70934058015', '70934058020', '70934058021', '70934058030', '70934058040', '70934058042', '76237022830', '59651048701', '59651048705', '59651048778', '59651048801', '59651048805', '59651048878', '59651048901', '59651048978', '71205046005', '71205046007', '71205046008', '71205046030', '71205046060', '71205046090', '68788816602', '68788816603', '68071266100', '68071266101', '68071266102', '68071266103', '68071266105', '00143973901', '00143973905', '00143973910', '00527293337', '00527293341', '70954005910', '70954005920', '70954005930', '70954005940', '63187024305', '63187024307', '63187024308', '63187024310', '63187024315', '63187024320', '63187024321', '63187024330', '63187024340', '64380094901', '64380094906', '68071220901', '68071220906', '68071269604', '68071523301', '68071524200', '68071524201', 
				'68071524202', '68071524203', '68071524204', '68071524205', '68071524206', '68071524207', '68071524208', '68788821201', '68788821202', '68788821203', '68788821205', '68788821208', '70518255500', '70518255501', '70518291600', '70518291601', '70518291602', '70518291603', '70518291604', '70518291605', '70518291606', '70518291607', '70518291608', '70934009606', '70934009610', '70934009612', '70934009615', '70934009620', '70934009621', '70934009630', '71205066505', '71205066510', '71205066520', '71205066521', '71205066524', '71205066530', '71205066560', '71205066590', '71335206900', '71335206901', '71335206902', '71335206903', '71335206904', '71335206905', '71335206906', '71335206907', '71335206908', '71335206909', '71335207900', '71335207901', '71335207902', '71335207903', '71335207904', '71335207905', '71335207906', '71335207907', '71335207908', '71335207909', '71335212201', '71335212202', '71335212203', '00527293437', '00527293441', '00603533915', '00603533921', '00603533928', '00603533931', '00603533932', '00615839105', '00615839130', '00615839139', '71205040305', '71205040306', '71205040307', '71205040310', '71205040312', '71205040330', '71205040360', '71205040390', '70518030600', '70518030601', '00143973801', '00143973805', '00143973810', '00603533815', '00603533821', '00603533828', '00603533831', '00603533832', '67296097401', '67296097402', '67296097405', '70518007300', '70518007301', '70518007302', '70518007303', '70518007304', '70518007305', '70518007306', '70518007307', '70518007308', '71329010301', '71329010302', '71329010401', '71329010402', '71329010501', '50090612201', '50090612202', '50090612203', '50090612205', '50090612209', '50090612300', '50090612301', '50090612302', '50090612305', '50090612307', '71335216001', '71335216002', '71335216003', '71335216004', 
				'71335216005', '71335216006', '71335216007', '71205042110', '71205042118', '71205042120', '71205042121', '71205042124', '71205042128', '71205042130', '71205042140', '71205042142', '71205042160', '71205042190', '71205042163', '60760079012', '60760079021', '68071277106', '68071277101', '70518213800', '70518213801', '70518213802', '70518213803', '70518354000', '70518355500', '68788763701', '68788763702', '68788763703', '68788763704', '68788763706', '68788763707', '68788763708', '68788763709', '68788930901', '68788930902', '68788930903', '68788930904', '68788930905', '68788930906', '68788930907', '68788930908', '68788930909', '61919023510', '61919023515', '61919023521', '61919023530', '61919023540', '61919023542', '68788811601', '68788811602', '68788811603', '68788811604', '68788811605', '68788811606', '68788811607', '68788811608', '68788811609', '00615844005', '00615844039', '71205072910', '71205072914', '71205072920', '71205072921', '71205072930', '71205072960', '71205072963', '71205072990', '68071278100', '68071278102', '68071278107', '68071278103', '00615844139', '50090622500', '50090625900', '00615359305', '00615359330', '00615359339', '63629158700', '63629158701', '63629158702', '63629158703', '63629158704', '63629158705', '63629158706', '63629158707', '63629158708', '63629158709', '68788775200', '68788775201', '68788775202', '68788775203', '68788775204', '68788775205', '68788775206', '68788775208', '68788775209', '70518155300', '70518155301', '55154494900', '61919032621', '61919032605', '61919032630', '70934025921', '70934025930', '70934025942', '49999002812', '49999002814', '49999002815', '49999002820', '49999002821', '49999002830', '49999002840', '49999002848', '49999002860', '49999002865', '50090009700', '50090009701', '50090009702', '50090009704', '50090009705', 
				'50090009707', '50090009708', '50090009800', '50090009801', '50090010200', '50090100100', '50090100200', '50090199000', '50090199001', '50090199002', '50090199005', '50090199007', '50090253200', '50090253201', '50090253202', '50090253204', '50090253205', '50090253207', '50090253208', '50090260800', '50090260801', '50090278901', '50090278902', '50090278903', '50090278905', '50090278909', '50090478401', '50090478402', '50090478403', '50090478405', '50090478409', '50090478500', '50090478501', '50090478502', '50090478505', '50090478507', '50090545300', '50090565701', '50090566000', '51655072621', '61919040421', '61919040430', '67296141903', '70518185400', '70518185401', '70518211500', '70518211501', '70518211502', '70518313800', '70518313801', '70934013705', '70934013707', '70934021810', '70934021815', '70934021820', '70934021821', '70934021830', '70934067412', '70934083110', '70934083112', '70934083115', '70934083120', '70934083121', '70934083130', '70934083140', '70934083142', '00527293537', '50090198901', '50090198902', '50090198903', '50090198905', '50090198909', '50090199100', '50090278600', '63629456201', '63629456202', '63629456203', '63629456204', '63629456205', '63629456206', '63629456207', '10135077701', '10135077710', '10135077801', '10135077805', '10135077810', '10135077901', '42291078350', '42708016621', '51655034907', '51655034955', '50090637600', '51655020820', '51655020818', '51655020827', '51655020852', '51655020853', '51655020854', '51655020855', '51655020821', '51655024253', '51655041020', '51655041049', '51655041021', '51655041027', '51655041052', '51655041053', '51655041054', '51655041621', '51655041654', '51655048855', '51655049349', '51655071655', '51655077952', '51655093520', '51655093907', '51655093955', '51655097220', '51655097221', '51655097227', 
				'51655097251', '51655097252', '51655097253', '51655097254', '67296144401', '67296144402', '67296144407', '67296144601', '67296145501', '67296145503', '67296145508', '67296145509', '67296145701', '67296145702', '67296145703', '67296145707', '67296182705', '70518231400', '70518231401', '70518231402', '70518231403', '70518340100', '70518340101', '70518340102', '70518347600', '70518347601', '70518347602', '70518347603', '70934009512', '70934009515', '70934009520', '70934009521', '70934009530', '70934009540', '70934009542', '70934030710', '70934030715', '70934030718', '70934030720', '70934030721', '70934030730', '70934047110', '70934047112', '70934047115', '70934047118', '70934047120', '70934047105', '70934047121', '70934047130', '70934047140', '71205074106', '71205074110', '71205074114', '71205074115', '71205074120', '71205074121', '71205074124', '71205074128', '71205074130', '71205074160', '71205074190', '71205075505', '71205075506', '71205075507', '71205075510', '71205075512', '71205075514', '71205075515', '71205075518', '71205075520', '71205075521', '71205075524', '71205075528', '71205075530', '71205075560', '71205075590', '71205079710', '71205079714', '71205079720', '71205079721', '71205079730', '71205079760', '71205079790', '71335214901', '71335214902', '71335214903', '71335214904', '71335214905', '71335214906', '71335214907', '72189043010', '72189043020', '72189043021', '80425010501', '80425010502', '82982004163', '82982004215', '70934054305', '50090565601', '50090565602', '50090565605', '50090565607', '50090565600', '50090565604', '50090565608') then tx_name = "prednisone";
			else if PROD_SRVC_ID in('51662148301', '68382091801', '68382091805', '68382091818', '68382091877', '68382091901', '68382091905', '68382091911', '68382091977', '70771135001', '70771135004', '70771135005', '70771135007', '70771135101', '70771135104', '70771135105', '70771135108', '00409568423', '00409568523', '49349075501', '49349075508', '49349094801', '00703004501', '00703005101', '00703005104', '00703006301', '54868059000', '55045324305', '55154392905', '55154393205', '00009000302', '00009075801', '55150026203', '55150026303', '55150026420', '55154393905', '55154938305', '55154955705', '61699004702', '63323025503', '63323025803', '00009007301', '00009017601', '00009354701', '54771354701', '59746000314', '59746001504', '59762005001', '59762005101', '00009027401', '00703003101', '00703003104', '00703004301', '00009307301', '00009307303', '00009307322', '00009307323', '51662142901', '70121157401', '70121157405', '69665021001', '69665031001', '70121157301', '70121157305', '00009347501', '00009347503', '00009347522', '00009347523', '00781313171', '00781313195', '49349084041', '50090225300', '52125051501', '52584011312', '52584019009', '53217012301', '54569155500', '54569155501', '55154394005', '55154394008', '55154394405', '63187047401', '70121100001', '70121100005', '70121100101', '70121100105', '00009079601', '00179012470', '00781313271', '00781313295', '00781313670', '00781313775', '21695084910', '21695085005', '21695095205', '25021080705', '25021080810', '53225365001', '61786002757', '70385201601', '70518051600', '70518108800', '70518142400', '55154394105', '55154394108', '70518202300', '70518202301', '70518245900', '50090209800', '52584003930', '52584004725', '50090027100', '50090027101', '50090031201', '50090043600', '50090055600', '50090182300', '00009003906', '00009003928', '00009003930', 
			'00009003932', '00009003933', '00009004704', '00009004722', '00009004725', '00009004726', '00009004727', '00009028002', '00009028003', '00009028024', '00009028025', '00009028051', '00009028052', '00009030602', '00009030612', '00009030624') then tx_name = "methylprednisolone";
			else if PROD_SRVC_ID in ('00703024101', '00703024301', '00703024501', '16714013001', '16714013025', '16714014001', '16714015001', '70121116801', '70121116901', '00003031505', '00003031520', '52125071201', '52125071208', '70121165401', '70121165101', '70121165105', '70121165201', '70121165301', '70121165501', '70121165701', '70121165705', '00003029305', '00003029320', '00003029328', '54868023500', '54868023501', '54868023502', '55045324801', '55045324804', '70121104902', '70121104905', '00003049420', '00781308475', '21695036001', '21695036010', '49349094641', '49349094741', '53225361001', '54868023400', '68258890305', '68788063601', '70529004801', '70529004802', '70529004803', '50090025600', '50090029501', '50090081900', '50090236000', '63187066101', '70518007500') then tx_name = "triamcinolone";
			else if PROD_SRVC_ID in ('0074372719', '0074434119', '0074455211', '0074518211', '0074659419', '0074662411', '0074706811', '0074706911', '0074707019', '0074714811', '0074714919', '0074929619', '0378180010', '0378180310', '0378180510', '0378180710', '0378180910', '0378181110', '0378181310', '0378181510', '0378181710', '0378181910', '0378182177', '0378182310', '0480868201', '0480868701', '0480869001', '0480869301', '0480870101', '0480870401', '0480870701', '0480871001', '0480871501', '0480871801', '0480872210', '0480872501', '0527328043', '0527328143', '0527328243', '0527328343', '0527328443', '0527328543', '0527328643', '0527328743', '0527328843', '0527328943', '0527329043', '0527329143', '0527495132', '0527495232', '0527495332', '0527495432', '0527495532', '0527495632', '0527495732', '0527495832', '0527495932', '0527496032', '0527496132', '0527496232', '0904694961', '0904695061', '0904695161', '0904695261', '0904695361', '0904695461', '0904695561', '0904695661', '0904695761', '1672944715', '1672944815', '1672944915', '1672945015', '1672945115', '1672945215', '1672945315', '1672945415', '1672945515', '1672945615', '1672945715', '1672945815', '2420100201', '2433801614', '2433803214', '2433806514', '2433809714', '2433811314', '3172228401', '3172228501', '3172228601', '3172228701', '3172228801', '3172228901', '3172229001', '3172229101', '3172229201', '3172229301', '3172229401', '3172229501', '3334239310', '3334239410', '3334239510', '3334239610', '3334239710', '3334239810', '3334239910', '3334240010', '3334240110', '3334240210', '3334240310', '3334240410', '4202320101', '4202320201', '4202320301', '4219232701', '4219232801', '4219232901', '4219233001', '4219233101', '4229203820', '4229203920', '4229204020', '4229204120', '4335329660', '4360241710', '4360241810', '4360241910', '4360242010', '4360242110', 
	'4360242210', '4360242310', '4360242410', '4360242510', '4360242610', '4360242710', '4360242810', '4374209551', '4778164010', '4778164310', '4778164610', '4778164910', '4778165110', '4778165410', '4778165710', '4778165910', '4778166210', '4778166510', '4778166810', '4778167110', '4950237815', '5009046250', '5009046670', '5009046680', '5009046700', '5009046880', '5009047990', '5009051760', '5009052160', '5009052290', '5009057920', '5009058210', '5009058870', '5009060870', '5009060890', '5009060900', '5009061000', '5009061010', '5009061030', '5009061040', '5009061052', '5009061150', '5009061160', '5009061180', '5107944020', '5107944120', '5107944220', '5107944320', '5107944420', '5107944520', '5165512852', '5165545352', '5165547926', '5165548326', '5165548426', '5165548526', '5165551352', '5165552852', '5165553252', '5165553752', '5165554452', '5165555752', '5165557652', '5165557852', '5165557952', '5165558352', '5165560452', '5165568752', '5165569452', '5165569652', '5165570552', '5165571452', '5165572352', '5165572752', '5165572852', '5165573952', '5165574252', '5165578352', '5165584652', '5165592352', '5165592452', '5165598552', '5165598952', '5165599752', '5265219501', '5300211190', '5300258000', '5380811131', '5380811141', '5380811151', '5515435580', '5515435590', '5515435600', '5515435610', '5515435620', '5515435630', '5515443760', '5515443770', '5515453620', '5515453800', '5515453810', '5515453950', '5546610411', '5546610511', '5546610611', '5546610711', '5546610811', '5546610911', '5546611011', '5546611111', '5546611211', '5546611311', '5546611411', '5546611511', '6068745301', '6068746401', '6068747501', '6068748601', '6068749701', '6068750801', '6068751901', '6068753001', '6068754101', '6068755201', '6068756301', '6079385001', '6079385101', '6079385201', '6079385301', 
	'6079385401', '6079385501', '6079385601', '6079385701', '6079385801', '6079385901', '6079386001', '6084680101', '6084680201', '6084680301', '6084680401', '6084680501', '6084680601', '6084680701', '6084680801', '6084680901', '6084681001', '6084681101', '6084681201', '6191987290', '6318745930', '6318746030', '6318749630', '6318754930', '6318756930', '6318757230', '6318757330', '6318758130', '6318761130', '6318763530', '6318785130', '6318792430', '6318798230', '6332364710', '6332364894', '6332364894', '6332364994', '6332364994', '6332364994', '6332388514', '6332388514', '6332388514', '6332389010', '6332389510', '6362920881', '6362920891', '6362920901', '6362920911', '6362920921', '6362920941', '6362945561', '6362982651', '6362987111', '6362987121', '6362991881', '6668910502', '6679420002', '6679420102', '6807122789', '6807125313', '6807126239', '6807126989', '6807127319', '6807128029', '6807151779', '6807152269', '6807152279', '6807152359', '6818096501', '6818096601', '6818096701', '6818096801', '6818096901', '6818097001', '6818097101', '6818097201', '6818097301', '6818097401', '6818097501', '6818097601', '6878876893', '6878876971', '6878876983', '6878877043', '6878877201', '6878877243', '6878877253', '6878877283', '6878877291', '6878877591', '6878877643', '6878879113', '6878879291', '6878879421', '6878879431', '6878879441', '6878879451', '6878879533', '6878879543', '6878879693', '6878882893', '6878882903', '6878883823', '6923811631', '6923811641', '6923811681', '6923811691', '6923811771', '6923811781', '6923811831', '6923812751', '6923812761', '6923812771', '6923812781', '6923812791', '6923818301', '6923818311', '6923818321', '6923818331', '6923818341', '6923818351', '6923818361', '6923818371', '6923818381', '6923818391', '6923818401', '6923818411', '7051111110', '7051111210', 
	'7051111310', '7051826580', '7051827470', '7051831540', '7086045110', '7086045210', '7086045310', '7093488730', '7093489430', '7093489530', '7093489630', '7093489730', '7093489830', '7093489930', '7120501830', '7120522130', '7120522230', '7120523230', '7120523730', '7120524030', '7120524230', '7120525530', '7120526130', '7120535130', '7120535230', '7120535330', '7120535430', '7120538230', '7120551230', '7120554330', '7120564230', '7120564630', '7120565530', '7120568130', '7133504141', '7133514231', '7133514351', '7133514381', '7133514471', '7133514561', '7133514651', '7133514781', '7133515021', '7133515121', '7133515281', '7133516371', '7133517341', '7133518141', '7133518271', '7133518281', '7133518611', '7133519401', '7133519451', '7133519471', '7133519551', '7133519661', '7133519871', '7133519981', '7133520071', '7133520901', '7133521381', '7133596171', '7185800051', '7185800101', '7185800121', '7185800131', '7185800151', '7185800171', '7185800201', '7185800251', '7185800301', '7185800351', '7185800401', '7185800451', '7185800501', '7185800551', '7185800601', '7185801051', '7185801101', '7185801121', '7185801131', '7185801151', '7185801171', '7185801201', '7185801251', '7185801301', '7185801351', '7185801401', '7185801451', '7185801501', '7185801551', '7185801601', '7218901490', '7218907390', '7218910730', '7218915530', '7218915930', '7218916030', '7218916390', '7218917330', '7218917430', '7218920290', '7218920630', '7218921890', '7218925090', '7218934690', '7230502530', '7230505030', '7230507530', '7230508830', '7230510030', '7230511230', '7230512530', '7230513730', '7230515030', '7230517530', '7230520030', '7278927230', '7278929730', '7286523610', '7286523710', '7286523810', '7286523910', '7286524010', '7286524110', '7286524210', '7286524310', '7286524410', '7286524510', 
	'7286524610', '7286524710', '7642056801', '7642056901', '7642057001', '8234700054', '8234700104', '8234700154', '8234700204', '8234700254', '8234700304', '8234700354', '8234700404', '8234700454', '8234700504', '8234700554', '8234700604') then tx_name = "levothyroxine"; 
		record_source = "PDE"; 
		run;

		proc freq data = thesis.pde_lung_irae_tx_oral; 
		table tx_name; 
		run; 

		/* no levothyroxine,triamcinolone... interesting */ 

			proc print data = thesis.pde_lung_irae_tx_oral (obs = 10); 
			run; 

/*		proc freq data = thesis.pde_lung_irae_tx_oral; */
/*		table cortico_name; */
/*		run; */

			/* Add flag for whether oral steroids meds were > 1mg/kg dosage (i.e. 50MG or higher) */ 
			data thesis.pde_lung_irae_tx_oral; 
			set thesis.pde_lung_irae_tx_oral; 
			dosage = input(scan(STR,1,""), Best12.); 
			if tx_name in ('prednisone', 'methylprednisolone') & dosage ge 50 then _1mgkg = 1; 
				else _1mgkg = 0; 
			run; 

				proc freq data = thesis.pde_lung_irae_tx_oral; 
				table tx_name*_1mgkg; 
				run; 


			/* Combine list of HCPCS codes and NDC codes */ 

			data irae_tx_combine; 
			set thesis.combined_lung_irae_tx (keep = patient_id record_source tx_dt tx_name) thesis.pde_lung_irae_tx_oral (keep = patient_id record_source tx_dt tx_name dosage _1mgkg); 
			run; 
				
				proc sort data = irae_tx_combine; 
				by patient_id; 
				run; 

/*				proc print data = irae_tx_combine (obs = 20); */
/*				run; */

				/* De-duplicate likely duplicate claim records- (same HCPCS or NDC code and date for same patient) */

				proc sort data=irae_tx_combine out=irae_tx_combine_dedupe nodupkey;
    			by _all_;
				run;

				proc contents data = irae_tx_combine; 
				run; 

					/* 2165 records */

				proc contents data = irae_tx_combine_dedupe; 
				run; 

					/* 2090 records */


				/* [Without dose threshold] Add running count of tx and total tx count */
				proc sort data = irae_tx_combine_dedupe; 
				by patient_id tx_dt;
				run; 

				data irae_tx_combine_dedupe; 
				set irae_tx_combine_dedupe;
				by patient_id;
				if first.patient_id then tx_count = 1; 
				else tx_count+1;
				run; 

					proc sort data = irae_tx_combine_dedupe; 
					by patient_id descending tx_count;
					run; 

					data irae_tx_combine_dedupe; 
					set irae_tx_combine_dedupe;
					by patient_id;
					retain tx_total; 
					if first.patient_id then tx_total = tx_count; 
					run; 

					proc sort data = irae_tx_combine_dedupe; 
					by patient_id tx_count;
					run;

					proc print data = irae_tx_combine_dedupe (obs = 10); 
					run; 

				/* For irAE v4: list of patients with just first tx record */ 
				data thesis.lung_irae_tx_first;
				set irae_tx_combine_dedupe;
				where tx_count = 1; 
				run; 

					/* 613 patients */ 

			/* [With dosage threshold] Add running count of tx and total tx count */
				proc sort data=irae_tx_combine out=irae_tx_combine_dedupe nodupkey;
    			by _all_;
				run; 

				proc freq data = irae_tx_combine_dedupe; 
				table record_source; 
				run; 

				proc sort data = irae_tx_combine_dedupe; 
				by patient_id tx_dt;
				run; 

				data irae_tx_combine_dedupe_dosage; 
				set irae_tx_combine_dedupe;
				where record_source in('NCH', 'Out') or _1mgkg = 1; /*What does this step do?*/
				by patient_id;
				if first.patient_id then tx_count = 1; 
				else tx_count+1;
				run; 

					proc sort data = irae_tx_combine_dedupe_dosage; 
					by patient_id descending tx_count;
					run; 

					data irae_tx_combine_dedupe_dosage; 
					set irae_tx_combine_dedupe_dosage;
					by patient_id;
					retain tx_total; 
					if first.patient_id then tx_total = tx_count; 
					run; 

					proc sort data = irae_tx_combine_dedupe_dosage; 
					by patient_id tx_count;
					run;

					proc print data = irae_tx_combine_dedupe_dosage (obs = 50); 
					run; 

				/* For irAE v4_dosage: list of patients with just first tx record */ 
				data thesis.lung_irae_tx_first_dosage;
				set irae_tx_combine_dedupe_dosage;
				where tx_count = 1; 
				run; 

					/* 251 patients */ 


			
	/* For irAE v1 and v2: Merge in irAE drug tx information to the list of ICD irAE dx codes on common patient_id */ 
			
	/* Merge tx names and dates to outcomes file with dx- 
				THIS IS A Cartesian JOIN 
				(every record with common patient_id in both tables are compared, so different row for every dx/tx combination by patient) */ 


		/* [No dose threshold] */ 

				/* Change record_source field in tx data so it is not lost in merge */ 
				data irae_tx_combine_dedupe; 
				set irae_tx_combine_dedupe; 
				record_source_tx = record_source; 
				run; 

				proc sort data = lung_irae_icd_match_dedupe; 
				by patient_id; 
				run; 

				proc sort data = irae_tx_combine_dedupe; 
				by patient_id; 
				run; 
		
			PROC SQL;
		    CREATE TABLE lung_irae_icd_match_tx AS
		    SELECT *
		    FROM lung_irae_icd_match_dedupe
		    INNER JOIN irae_tx_combine_dedupe
		    ON lung_irae_icd_match_dedupe.patient_id = irae_tx_combine_dedupe.patient_id;
			QUIT;

/*			proc contents data= lung_irae_icd_match_tx; */
/*			run; */
            /* 17715 rows */

				/* Add gap between dx and tx, remove records where tx was triamcinolone other than for skin dx and levothyroxine for other than thyroid dx */ 
				data lung_irae_icd_match_tx; 
				set lung_irae_icd_match_tx; 
				dx_tx_gap = intck('day', claim_dt_format, tx_dt);
				if tx_name = "triamcinol" & icd_dx_domain ne "skin" then delete;
				if tx_name = "levothyrox" & icd_dx_domain ne "endocrine" then delete; /*  no levothyroxine found in PDE data though */ 
				run; /* 34986 rows */

				proc print data = lung_irae_icd_match_tx (obs = 50); 
				run; 

				proc freq data = lung_irae_icd_match_tx; 
				table tx_name*icd_dx_domain; 
				run; 

				/* For dosage-dependent case definition: filter out records where oral steroids below threshold */ 
				data lung_irae_icd_match_tx_dosage; 
				set lung_irae_icd_match_tx; 
				if record_source_tx in('PDE') & _1mgkg = 0 then delete;
				run; /* 16716-->3714 rows left */

			/* irAE v1: Filter on tx date within +/- 10 days of irAE "dx" */ 
				data thesis.lung_irae_icd_match_tx1; 
				set lung_irae_icd_match_tx;
				where dx_tx_gap < 11 & dx_tx_gap > -11; 
				run; /* 1482 rows */

					proc freq data = thesis.lung_irae_icd_match_tx1 nlevels;
					table patient_id /noprint;
					run; 

						/* 314 patients with irAE tx within +/- 10 days of irAE dx code after initiating ICI  */

			/* irAE v1 (dosage threshold and date buffer changed to reflect V1 from Aim 1 ) */ 
				data thesis.lung_irae_icd_match_tx1_d; 
				set lung_irae_icd_match_tx_dosage;
				where dx_tx_gap < 41 & dx_tx_gap > -41; 
				run; 

					proc freq data = thesis.lung_irae_icd_match_tx1_d nlevels;
					table patient_id /noprint;
					run; 

					/* 133 patients with irAE tx (including oral steroids >50mg) within +/- 40 days of irAE dx code after initiating ICI */ 


			/* irAE v2: Filter on tx date within -40 to + 40 days of irAE "dx" */
				data thesis.lung_irae_icd_match_tx2; 
				set lung_irae_icd_match_tx;
				where dx_tx_gap < 41 & dx_tx_gap > -41; 
				run; 

					proc freq data = thesis.lung_irae_icd_match_tx2 nlevels;
					table patient_id /noprint;
					run; 

					proc freq data = thesis.lung_irae_icd_match_tx2 nlevels;
					table dx_tx_gap;
					run; 

						/* 416 patients with irAE tx within +/- 40 days of irAE dx code after initiating ICI */ 
							

/*					proc print data = lung_irae_icd_match_tx1 (obs = 50); */
/*					run; */


						/* Sort by claim date, tx date to arrange table sensibly */ 

						proc sort data = thesis.lung_irae_icd_match_tx1; 
						by patient_id claim_dt_format tx_dt; 
						run; 

						proc sort data = thesis.lung_irae_icd_match_tx1_d; 
						by patient_id claim_dt_format tx_dt; 
						run; 

						proc sort data = thesis.lung_irae_icd_match_tx2; 
						by patient_id claim_dt_format tx_dt; 
						run; 


							/* Not every row is a unique irAE; many rows might correspond to the same dx, for example... how to filter down? */ 

						/* Distribution of irae domain in v1 */ 
						proc freq data = thesis.lung_irae_icd_match_tx1; 
						table icd_dx_domain; 
						run; 

						/*

						icd_dx_domain Frequency Percent CumulativeFrequency CumulativePercent 
						cardiovascular 36 2.43 36 2.43 
						endocrine 247 16.67 283 19.10 
						gastrointestinal 114 7.69 397 26.79 
						hematologic 6 0.40 403 27.19 
						musculoskeletal 7 0.47 410 27.67 
						pulmonary 929 62.69 1339 90.35 
						renal 47 3.17 1386 93.52 
						skin 96 6.48 1482 100.00 

						 */

						/* 60% are pulmonary */ 


						/* Distribution of irae domain in irAE v1 (updated) */
						proc freq data = thesis.lung_irae_icd_match_tx1_d; 
						table icd_dx_domain; 
						run; 

						/* 
						icd_dx_domain Frequency Percent CumulativeFrequency CumulativePercent 
						cardiovascular 34 4.68 34 4.68 
						endocrine 215 29.57 249 34.25 
						gastrointestinal 85 11.69 334 45.94 
						hematologic 7 0.96 341 46.91 
						musculoskeletal 4 0.55 345 47.46 
						pulmonary 307 42.23 652 89.68 
						renal 18 2.48 670 92.16 
						skin 57 7.84 727 100.00 


						*/ 

						/* 42% are pulmonary, 30% are endocrine */ 


						/* Distribution of irae domain in v2 */ 
						proc freq data = thesis.lung_irae_icd_match_tx2; 
						table icd_dx_domain; 
						run; 

						/* 

						icd_dx_domain Frequency Percent CumulativeFrequency CumulativePercent 
						cardiovascular 119 3.17 119 3.17 
						endocrine 839 22.38 958 25.55 
						gastrointestinal 265 7.07 1223 32.62 
						hematologic 22 0.59 1245 33.21 
						musculoskeletal 18 0.48 1263 33.69 
						pulmonary 2125 56.68 3388 90.37 
						renal 144 3.84 3532 94.21 
						skin 217 5.79 3749 100.00 



						*/

						/*57% are pulmonary */ 

				/* Create running count of ICD*tx ascertained irAE per person, tag the first */

				/* irAE v1 */ 
				data thesis.lung_irae_icd_match_tx1; 
				set thesis.lung_irae_icd_match_tx1; 
				by patient_id;
				if first.patient_id then first = 1; 
				else first = 0; 
				if first.patient_id then icd_tx_ct = 1;
				else icd_tx_ct+1;
				run; 
					
					proc print data = thesis.lung_irae_icd_match_tx1 (obs = 50); 
					run; 

				/* Timing */ 

				ods graphics on;
				proc univariate data = thesis.lung_irae_icd_match_tx1 noprint;
				where daysfromindex < 250;
				Title 'Distribution of Time from Index Date for irAE dx';
				histogram daysfromindex;
				run; 
				ods graphics off;

				/* By domain */ 
				ods graphics on;
				proc univariate data = thesis.lung_irae_icd_match_tx1 noprint;
				where daysfromindex < 250;
				Title 'Distribution of Time from Index Date for first irAE dx- By Domain';
				histogram daysfromindex;
				class icd_dx_domain; 
				run; 
				ods graphics off;



				/* irAE v1 (updated, dosage threshold) */ 
				data thesis.lung_irae_icd_match_tx1_d; 
				set thesis.lung_irae_icd_match_tx1_d; 
				by patient_id;
				if first.patient_id then first = 1; 
				else first = 0; 
				if first.patient_id then icd_tx_ct = 1;
				else icd_tx_ct+1;
				run; 
					
					proc print data = thesis.lung_irae_icd_match_tx1_d (obs = 50); 
					run; 

				/* Timing */ 

				ods graphics on;
				proc univariate data = thesis.lung_irae_icd_match_tx1_d noprint;
				where daysfromindex < 250;
				Title 'Distribution of Time from Index Date for irAE dx';
				histogram daysfromindex;
				run; 
				ods graphics off;

				/* By domain */ 
				ods graphics on;
				proc univariate data = thesis.lung_irae_icd_match_tx1_d noprint;
				where daysfromindex < 250;
				Title 'Distribution of Time from Index Date for first irAE dx- By Domain';
				histogram daysfromindex;
				class icd_dx_domain; 
				run; 
				ods graphics off;


				/* irAE v2 */ 
				data thesis.lung_irae_icd_match_tx2; 
				set thesis.lung_irae_icd_match_tx2; 
				by patient_id;
				if first.patient_id then first = 1; 
				else first = 0; 
				if first.patient_id then icd_tx_ct = 1;
				else icd_tx_ct+1;
				run; 
					
					proc print data = thesis.lung_irae_icd_match_tx2 (obs = 50); 
					run; 

						

				/* Filter to first treated irAE per person */

				/* irAE v1 */ 
				data lung_irae_first1; 
				set thesis.lung_irae_icd_match_tx1;
				where first = 1; 
				run;  

				/* irAE v1 (updated,dosage threshold) */ 
				data lung_irae_first1_d; 
				set thesis.lung_irae_icd_match_tx1_d;
				where first = 1; 
				run;  

				/* irAE v2 */ 
				data lung_irae_first2; 
				set thesis.lung_irae_icd_match_tx2;
				where first = 1; 
				run; 
/**/
/*				proc print data = lung_irae_first; */
/*				run; */

				proc freq data = lung_irae_first1; 
				table icd_dx_domain; 
				run; 

										/*

					icd_dx_domain Frequency Percent Cumulative
					Frequency CumulativePercent 
				cardiovascular 15 4.78 15 4.78 
				endocrine 79 25.16 94 29.94 
				gastrointestinal 15 4.78 109 34.71 
				hematologic 1 0.32 110 35.03 
				musculoskeletal 2 0.64 112 35.67 
				pulmonary 157 50.00 269 85.67 
				renal 11 3.50 280 89.17 
				skin 34 10.83 314 100.00 


				*/


				proc freq data = lung_irae_first1_d; 
				table icd_dx_domain; 
				run; 

				/* 

				The FREQ Procedure
				icd_dx_domain Frequency Percent Cumulative
				Frequency CumulativePercent 
				cardiovascular 7 5.26 7 5.26 
				endocrine 52 39.10 59 44.36 
				gastrointestinal 7 5.26 66 49.62 
				hematologic 2 1.50 68 51.13 
				musculoskeletal 1 0.75 69 51.88 
				pulmonary 42 31.58 111 83.46 
				renal 6 4.51 117 87.97 
				skin 16 12.03 133 100.00 




				*/


				proc freq data = lung_irae_first2; 
				table icd_dx_domain; 
				run; 

									/* 
					icd_dx_domain Frequency Percent Cumulative
					Frequency CumulativePercent 
				cardiovascular 22 5.29 22 5.29 
				endocrine 114 27.40 136 32.69 
				gastrointestinal 21 5.05 157 37.74 
				hematologic 3 0.72 160 38.46 
				musculoskeletal 3 0.72 163 39.18 
				pulmonary 189 45.43 352 84.62 
				renal 17 4.09 369 88.70 
				skin 47 11.30 416 100.00 




					*/

				/* Timing */ 
				ods graphics on;
				proc univariate data = lung_irae_first1 noprint;
				where daysfromindex < 250;
				Title 'Distribution of Time from Index Date for first irAE dx- By Domain';
				histogram daysfromindex;
				run; 
				ods graphics off;

				/* By domain */ 
				ods graphics on;
				proc univariate data = lung_irae_first1 noprint;
				where daysfromindex < 250;
				Title 'Distribution of Time from Index Date for first irAE dx- By Domain';
				histogram daysfromindex;
				class icd_dx_domain; 
				run; 
				ods graphics off;



/* Assess Medicare enrollment status during follow-up */ 

		/* This table contains all enrollment months for all eligible patients (from enrollment look-back step) */

		proc print data = seer.enrollment_months (obs = 50); 
		run;


		/* Filter on patients with 12mo insurance enrollment from index date */
		proc sql; 
		create table enrollment_months as
		select *
		from seer.enrollment_months
		where patient_id in (select patient_id from thesis.cohort); 
		quit; 

		/* Conserve needed columns */ 
		data enrollment_months; 
		set enrollment_months (keep = patient_id ici_index_dt MON: HMON: DMON: drop = MONTH:);
		where ici_index_dt ne .;
		run;

			
			proc print data = enrollment_months (obs = 5); 
			run; 

		/* Convert from wide to long: PROC transpose */ 
			proc transpose data = enrollment_months out = enrollment_months_long;
			by patient_id; 
			var MON1 - MON108 HMON1 - HMON108 DMON1 - DMON108; 
			run; /*481140 rows*/

				proc print data = enrollment_months_long (obs = 500); 
				run; 

		/* For each patient, flag first instance of not being Medicare enrolled, after being previously enrolled
				Add month and year columns so that enrollment status change can to anchored to a calendar date */ 
			data enrollment_months_long1; 
			length changetype $ 20.;
			length change $ 5.;
			set enrollment_months_long; 
			if _NAME_ in:('MON') and COL1 in ('', '00', '20', '21', '31') then status = 0;
			else if _NAME_ in:('HMON') and COL1 not in ('', '0') then status = 0; 
			else if _NAME_ in:('DMON') and COL1 in ('', '0', 'N') then status = 0;
			else status = 1;
			status_lag = lag(status); 
			if status = status_lag then change = '.';
			else if _NAME_ in ('MON1', 'HMON1', 'DMON1') then change = '.';
			else if status ne status_lag then change = catx(', ', status, status_lag);
			if change = '0, 1' then changetype = 'disenrolled';
			else if change = '1, 0' then changetype = 'enrolled';
			by patient_id;
			if first.patient_id then rec_cnt = 1;
			else rec_cnt+1;
			run; 

				proc print data = enrollment_months_long1 (obs = 50);
				run; 

			/* Add month counter */
			data enrollment_months_long2;
			set enrollment_months_long1;
			month+1;
			if month = 13 then month = 1; 
			run;

				proc print data = enrollment_months_long2 (obs = 500); 
				run; 


				/* Add year counter */ 
				data enrollment_months_long21; 
				set enrollment_months_long2;
				where month = 1; 
				run; 

					proc print data = enrollment_months_long21 (obs = 50); 
					run;

				data enrollment_months_long21; 
				set  enrollment_months_long21;
				yearnum+1;
				if yearnum = 10 then yearnum = 1; 
				year = yearnum+2011;
				run; 

/*					proc print data = enrollment_months_long21 (obs = 50); */
/*					run; */

				proc sort data = enrollment_months_long2;
				by patient_id rec_cnt;
				run; 

				proc sort data = enrollment_months_long21;
				by patient_id rec_cnt;
				run; 

				data enrollment_months_long3;
				merge enrollment_months_long2 (in = a) 
						enrollment_months_long21 (keep = patient_id rec_cnt year in = b);
				by patient_id rec_cnt;
				if a; 
				run;

				proc sort data = enrollment_months_long3;
				by patient_id rec_cnt;
				run; 

/*				proc print data = enrollment_months_long3 (obs = 50); */
/*				run; */

				/* Fill in missing year for non-month1 */ 
				data enrollment_months_long4; 
				set enrollment_months_long3;
				retain _year; 
				if not missing(year) then _year=year;
				else year = _year;
				drop _year;
				run; 

					proc print data = enrollment_months_long4 (obs  = 50);
					run; 


				/* Create full date variable for each row */ 
				data enrollment_months_long5; 
				set enrollment_months_long4; 
				enroll_date = mdy(month,1,year); 
				format enroll_date date9.;
				run; 

					proc print data = enrollment_months_long5 (obs  = 50);
					run; 

				/* Merge in ICI index date to remove records from before that date */
				proc sort data = enrollment_months_long5;
				by patient_id; 
				run; 

				proc sort data = thesis.cohort; 
				by patient_id; 
				run; 

				data enrollment_months_long6;
				merge enrollment_months_long5 (in = a)
						thesis.cohort (keep = patient_id ici_index_dt in = b);
					by patient_id;
					if a;
					run; 

/*					proc print data = enrollment_months_long6 (obs = 50); */
/*					run; */

				data enrollment_months_long7; 
				set enrollment_months_long6; 
				where enroll_date > ici_index_dt; 
				run; 

/*					proc print data = enrollment_months_long7 (obs = 50); */
/*					run; */




		/* Now find the disenroll dates for every patient for A/B, HMO (enrolling), D */
		data enrollment_months_disenroll;
		set enrollment_months_long7;
		where changetype = 'disenrolled';
		run; 

			proc print data = enrollment_months_disenroll (obs  = 50);
			run;

		/* Tag earliest date and filter to that one */ 
		proc sort data = enrollment_months_disenroll; 
		by patient_id enroll_date;
		run; 


		data enrollment_first_disenroll; 
		set enrollment_months_disenroll; 
		by patient_id; 
		if first.patient_id then first = 1; 
		run; 

/*			proc print data = enrollment_first_disenroll (obs  = 50);*/
/*			run;*/

		data thesis.enrollment_first_disenroll_1;
		set enrollment_first_disenroll; 
		where first = 1; 
		run; 

			proc print data = thesis.enrollment_first_disenroll_1 (obs  = 50);
			run;



/* Add outcome status to the master ICI patient list */ 

		/* Using the different irAE versions, add irAE outcome status and date to the list of ICI patients */ 

		/* irAE v1 */

			proc sort data = lung_irae_first1;
			by patient_id; 
			run;

			proc sort data = thesis.cohort_outcomes; 
			by patient_id; 
			run; 

			data thesis.cohort_outcomes1; 
				merge thesis.cohort_outcomes (in = a) 
						lung_irae_first1 (keep = patient_id tx_dt in = b);
				by patient_id;
				if a;
				run; 

/*				proc print data = thesis.cohort_outcomes1 (obs = 5); */
/*				run; */

				data thesis.cohort_outcomes1; 
				set thesis.cohort_outcomes1; 
				if tx_dt ne '.' then irae_v1 = 1; 
				else irae_v1 = 0; 
				irae_v1_dt = tx_dt; 
				run; 

/*				proc print data = thesis.cohort_outcomes1 (obs = 5); */
/*				run;  */

				data thesis.cohort_outcomes1; 
				set thesis.cohort_outcomes1 (drop = tx_dt); 
				run; 


		/* irAE v1 update (dose threshold for oral corticosteroids and -40 to +40 days tx window) */ 
				
				proc sort data = lung_irae_first1_d;
				by patient_id; 
				run; 

				data thesis.cohort_outcomes1; 
				merge thesis.cohort_outcomes1 (in = a) 
						lung_irae_first1_d (keep = patient_id tx_dt in = b);
				by patient_id;
				if a;
				run; 

/*				proc print data = thesis.cohort_outcomes1 (obs = 5); */
/*				run; */

				data thesis.cohort_outcomes1; 
				set thesis.cohort_outcomes1; 
				if tx_dt ne '.' then irae_v1_doserange = 1; 
				else irae_v1_doserange = 0; 
				irae_v1_doserange_dt = tx_dt; 
				run;

				data thesis.cohort_outcomes1; 
				set thesis.cohort_outcomes1 (drop = tx_dt); 
				run; 


		/* irAE v2 (-40 to +40 days tx window) */ 

				proc sort data = lung_irae_first2;
				by patient_id; 
				run; 

				data thesis.cohort_outcomes1; 
				merge thesis.cohort_outcomes1 (in = a) 
						lung_irae_first2 (keep = patient_id tx_dt in = b);
				by patient_id;
				if a;
				run; 

/*				proc print data = thesis.cohort_outcomes1 (obs = 5); */
/*				run; */

				data thesis.cohort_outcomes1; 
				set thesis.cohort_outcomes1; 
				if tx_dt ne '.' then irae_v2 = 1; 
				else irae_v2 = 0; 
				irae_v2_dt = tx_dt; 
				run;

				data thesis.cohort_outcomes1; 
				set thesis.cohort_outcomes1 (drop = tx_dt); 
				run; 

				


		/* irAE v3 (no tx requirement) */ 

				proc sort data = thesis.lung_irae_icd_first; 
				by patient_id; 
				run; 

				data thesis.cohort_outcomes1; 
				merge thesis.cohort_outcomes1 (in = a) 
						thesis.lung_irae_icd_first (keep = patient_id claim_dt_format in = b);
				by patient_id;
				if a;
				run; 

/*				proc print data = thesis.cohort_outcomes1 (obs = 5); */
/*				run; */

				data thesis.cohort_outcomes1; 
				set thesis.cohort_outcomes1; 
				if claim_dt_format ne '.' then irae_v3 = 1; 
				else irae_v3 = 0; 
				irae_v3_dt = claim_dt_format; 
				run;

				data thesis.cohort_outcomes1; 
				set thesis.cohort_outcomes1 (drop = claim_dt_format); 
				run; 


		/* irAE v4 (no dx requirement) */ 

				proc sort data = thesis.lung_irae_tx_first; 
				by patient_id; 
				run; 

				data thesis.cohort_outcomes1; 
				merge thesis.cohort_outcomes1 (in = a) 
						thesis.lung_irae_tx_first (keep = patient_id tx_dt in = b);
				by patient_id;
				if a;
				run; 

/*				proc print data = thesis.cohort_outcomes1 (obs = 5); */
/*				run; */

				data thesis.cohort_outcomes1; 
				set thesis.cohort_outcomes1; 
				if tx_dt ne '.' then irae_v4 = 1; 
				else irae_v4 = 0; 
				irae_v4_dt = tx_dt; 
				run; 

				data thesis.cohort_outcomes1; 
				set thesis.cohort_outcomes1 (drop = tx_dt); 
				run; 


			/* irAE v4 update- (no dx requirement)- dose threshold for oral steroids */ 

				proc sort data = thesis.lung_irae_tx_first_dosage; 
				by patient_id; 
				run; 

				data thesis.cohort_outcomes1; 
				merge thesis.cohort_outcomes1 (in = a) 
						thesis.lung_irae_tx_first_dosage (keep = patient_id tx_dt in = b);
				by patient_id;
				if a;
				run; 

/*				proc print data = thesis.cohort_outcomes1 (obs = 5); */
/*				run; */

				data thesis.cohort_outcomes1; 
				set thesis.cohort_outcomes1; 
				if tx_dt ne '.' then irae_v4_doserange = 1; 
				else irae_v4_doserange = 0; 
				irae_v4_doserange_dt = tx_dt; 
				run; 

				data thesis.cohort_outcomes1; 
				set thesis.cohort_outcomes1 (drop = tx_dt); 
				run; 


				proc print data = thesis.cohort_outcomes1 (obs = 5); 
				run; 


	/* Medicare disenrollment */
			proc sort data = thesis.enrollment_first_disenroll_1; 
			by patient_id; 
			run; 

			data thesis.cohort_outcomes1; 
			merge thesis.cohort_outcomes1 (in = a) 
					thesis.enrollment_first_disenroll_1 (keep = patient_id enroll_date in = b);
			by patient_id;
			if a;
			run; 

			data thesis.cohort_outcomes1; 
			set thesis.cohort_outcomes1; 
			if enroll_date ne '.' then mcare_disenroll = 1; 
			else mcare_disenroll = 0; 
			mcare_disenroll_dt = enroll_date; 

			data thesis.cohort_outcomes1; 
			set thesis.cohort_outcomes1 (drop = enroll_date); 
			run; 

			proc print data = thesis.cohort_outcomes1 (obs = 50); 
			run; 
			proc freq data = thesis.cohort_outcomes1;
			table mcare_disenroll;
			run;

/*     
			mcare_disenroll Frequency Percent CumulativeFrequency CumulativePercent 
			0 366 24.65 366 24.65 
			1 1119 75.35 1485 100.00 
 

			why so many disenroll? but maybe have died before disenrollment.
*/


	/* Death (2 sources; SEER Cancer File & Medicare enrollment file) */ 

			/* Death: SEER (missing data for 7720 enrolless from Idaho, Massachusetts, New York, and Texas) */ 
			data thesis.cohort_outcomes1; 
			set thesis.cohort_outcomes1;
			seer_death_dt = cat(seer_dateofdeath_year, seer_dateofdeath_month,'01');
				if seer_death_dt = '01' then seer_death_dt =.;
			seer_death_dt_format = input(seer_death_dt, yymmdd10.);
				format seer_death_dt_format date9.;
			if SEERcausespecificdeathclassific = 1 then cancer_death = 1; 
				else if SEERcausespecificdeathclassific =. then cancer_death = .; 
				else if SEERcausespecificdeathclassific in (0,8) then cancer_death = 0; /* 8 = Noncancer death */
			if SEERcausespecificdeathclassific = 1 then cancer_death_dt = seer_death_dt_format;
			if SEERothercauseofdeathclassifica in (1,8) then noncancer_death = 1; *8 = unknown COD, classifying as noncancer here;
				else if SEERothercauseofdeathclassifica =. then noncancer_death = .; 
				else if SEERothercauseofdeathclassifica =0 then noncancer_death = 0; 
			if SEERothercauseofdeathclassifica in (1,8) then noncancer_death_dt = seer_death_dt_format; 
			run; 
/**/
			proc freq data = thesis.cohort_outcomes1; 
			table SEERcausespecificdeathclassific SEERothercauseofdeathclassifica; 
			run; 

/*			proc print data = thesis.cohort_outcomes1 (obs = 10); */
/*			run; */
/**/
			proc freq data = thesis.cohort_outcomes1;
			table seer_death_dt; 
			run; 

/*			data thesis.cohort_outcomes1; */
/*			set thesis.cohort_outcomes1 (drop = seer_death_dt seer_death_dt_format);*/
/*			run; */

				proc freq data = thesis.cohort_outcomes1; 
				table Met_1px*(cancer_death noncancer_death); 
				run; 

				proc freq data = thesis.cohort_outcomes1 nlevels; 
				table cancer_death noncancer_death; 
				run;  

				/*
				cancer_death Frequency Percent CumulativeFrequency CumulativePercent 
				. 507 34.14 507 34.14 
				0 491 33.06 998 67.21 
				1 487 32.79 1485 100.00 


                 487 died of cancer, . =  507 from 4 states, 485 =  (alive or dead of other reason) + 6 (dead, missing COD)

				noncancer_death Frequency Percent CumulativeFrequency CumulativePercent 
				. 507 34.14 507 34.14 
				0 893 60.13 1400 94.28 
				1 85 5.72 1485 100.00 


                 85 died of reasons other than cancer, . = 507 from 4 states

 
				*/

					/* Missing for 507 patients.. cannot use these variables */ 

/*				proc print data = thesis.cohort_outcomes1 (obs = 20);*/
/*				run;*/


			/* Death: MBSF File (complete data for all enrollees, not cause-specific) 
				NOTE: Have death dates through 2020, as opposed to 2019 for SEER death, this 
				exceeds admin censoring date */ 

			proc print data = seer.mbsfabcd (obs = 10); 
			run; 

			proc sql; 
			create table mbsf_death as
			select patient_id, bene_enrollmt_ref_yr, bene_death_dt
			from seer.mbsfabcd
			where patient_id in (select patient_id from thesis.cohort_outcomes1);
			quit; 

			proc sort data = mbsf_death; 
			by patient_id bene_enrollmt_ref_yr;
			run; 

			data mbsf_death1;
			set mbsf_death; 
			by patient_id; 
			if last.patient_id then lastenrollyr = 1; 
			run; 

			data thesis.mbsf_death; 
			set mbsf_death1; 
			where lastenrollyr = 1; 
			medicare_death_dt = input(bene_death_dt, yymmdd10.);
				format medicare_death_dt date9.;
			if medicare_death_dt ne . then medicare_death = '1';
				else medicare_death = '0'; 
			run; 
		 
			proc freq data = thesis.mbsf_death nlevels;
			table patient_id /noprint;
			run; 

				/* 1485 rows.. all patients included */ 

/*				proc print data = thesis.mbsf_death (obs = 50); */
/*				run; */

				proc freq data = thesis.mbsf_death; 
				table medicare_death; 
				run; 

					/* 
				death Frequency Percent CumulativeFrequency CumulativePercent 
				0 386 25.99 386 25.99 
				1 1099 74.01 1485 100.00 
 


					*/

				/* 74% of patients died before end of 2020 */ 


			/* Merge into outcomes dataset */

			data thesis.cohort_outcomes1; 
			merge thesis.cohort_outcomes1 (in = a) 
					thesis.mbsf_death (keep = patient_id medicare_death medicare_death_dt in = b);
			by patient_id;
			if a;
			run; 

			proc contents data = thesis.cohort_outcomes1; 
			run; 

				proc print data = thesis.cohort_outcomes1 (obs = 10); 
				run; 


				/* Incidence of different outcomes by expo arms: Met vs NMet*/ 
				proc freq data = thesis.cohort_outcomes1; 
				/*table MET_1px*(irae_v1 irae_v1_doserange irae_v2 irae_v3 irae_v4 irae_v4_doserange cancer_death noncancer_death medicare_death mcare_disenroll);*/
                table Met_1px* (cancer_death noncancer_death medicare_death);
                run; 

					/* Only 34% of patients died from cancer (cause-specific)? 6% from non-cancer causes? 
						There is a huge discrepancy between SEER-coded death and Medicare death (76% before 2020) */

		/* Look at patients with mismatched SEER and Medicare Death status or death date. Who are they? */ 


/* Prepare censoring variables & outcomes */

	data thesis.cohort_outcomes2;
	set thesis.cohort_outcomes1;
	
	/**************************************** Followup end date ***************************************************************/
	 /*
	* competing risks model for irAE;
	* followup_end_date = minimum of (censor_date, death_date, outcome_date);
	followup_end_date1 = min(mcare_disenroll_dt, admin_censor_dt, medicare_death_dt, irAE_v1_dt);
	format followup_end_date1 date9.;
	
	years_to_end_followup1 = (followup_end_date1 - ici_index_dt)/365;

	followup_end_date1_d = min(mcare_disenroll_dt, admin_censor_dt, medicare_death_dt, irAE_v1_doserange_dt);
	format followup_end_date1_d date9.;
	
	years_to_end_followup1_d = (followup_end_date1_d - ici_index_dt)/365;

	followup_end_date2 = min(mcare_disenroll_dt, admin_censor_dt, medicare_death_dt, irAE_v2_dt);
	format followup_end_date2 date9.;
	
	years_to_end_followup2 = (followup_end_date2 - ici_index_dt)/365;

	followup_end_date3 = min(mcare_disenroll_dt, admin_censor_dt, medicare_death_dt, irAE_v3_dt);
	format followup_end_date3 date9.;
	
	years_to_end_followup3 = (followup_end_date3 - ici_index_dt)/365;

	followup_end_date4 = min(mcare_disenroll_dt, admin_censor_dt, medicare_death_dt, irAE_v4_dt);
	format followup_end_date4 date9.;
	
	years_to_end_followup4 = (followup_end_date4 - ici_index_dt)/365;

	followup_end_date4_d = min(mcare_disenroll_dt, admin_censor_dt, medicare_death_dt, irAE_v4_doserange_dt);
	format followup_end_date4_d date9.;
	
	years_to_end_followup4_d = (followup_end_date4_d - ici_index_dt)/365; 
	 */



	* Cox model for death; 
	* followup_end_date = minimum of (censor_date, death_date);
	followup_end_date11 = min(mcare_disenroll_dt, admin_censor_dt, medicare_death_dt);
	format followup_end_date11 date9.;
	
	years_to_end_followup11 = (followup_end_date11 - ici_index_dt)/365;

	
	/************************************ Censor flag and outcomes ***************************************************************/

	 /*
	* censor flag for competing risks model;
	if followup_end_date1 = irAE_v1_dt then censor_flag1 = 1; * event coded =1;
	else if followup_end_date1 = medicare_death_dt then censor_flag1 = 2;
	else censor_flag1 = 0;

	if followup_end_date1_d = irAE_v1_doserange_dt then censor_flag1_d = 1; * event coded =1;
	else if followup_end_date1_d = medicare_death_dt then censor_flag1_d = 2;
	else censor_flag1_d = 0;

	if followup_end_date2 = irAE_v2_dt then censor_flag2 = 1; * event coded =1;
	else if followup_end_date2 = medicare_death_dt then censor_flag2 = 2;
	else censor_flag2 = 0;

	if followup_end_date3 = irAE_v3_dt then censor_flag3 = 1; * event coded =1;
	else if followup_end_date3 = medicare_death_dt then censor_flag3 = 2;
	else censor_flag3 = 0;

	if followup_end_date4 = irAE_v4_dt then censor_flag4 = 1; * event coded =1;
	else if followup_end_date4 = medicare_death_dt then censor_flag4 = 2;
	else censor_flag4 = 0;

	if followup_end_date4_d = irAE_v4_doserange_dt then censor_flag4_d = 1; * event coded =1;
	else if followup_end_date4_d = medicare_death_dt then censor_flag4_d = 2;
	else censor_flag4_d = 0;
     */

	* censor flag for cox regression model for time to death;
	if followup_end_date11 = medicare_death_dt then censor_flag_11 = 1; * event coded =1;
	else censor_flag_11 = 0;


	run;

	proc print data = thesis.cohort_outcomes2 (obs = 20); 
	run; 


proc freq data = thesis.cohort_outcomes2;
	table (/* censor_flag1 censor_flag1_d censor_flag2 censor_flag3 censor_flag4 censor_flag4_d */ censor_flag_11)* MET_1px;
run;
/*

censor_flag_11   MET_1px 
                 0              1
0                153(42.3)      461(41.1)
1                209(57.7)      662(59.0)

*/



/* Drop some columns prior to analysis? Those not being used? */ 


/* Death analysis- different data sources */ 

/* See how death status agrees within databases that report death (i.e. all except Idaho, Mass, Tex, NY) 
	NOTE: new column needed to indicate death before end of f/u period */ 

data cohort_death_compare; 
set thesis.cohort_outcomes2; 
if medicare_death= 1 & medicare_death_dt le admin_censor_dt then medicare_death_2019 = 1; 
else medicare_death_2019 = 0; 
run; 

proc freq data = cohort_death_compare;
table medicare_death_2019 medicare_death; 
run;
          /*
              medicare_death_2019 Frequency Percent CumulativeFrequency CumulativePercent 
              0 596 40.13 596 40.13 
              1 889 59.87 1485 100.00 


              medicare_death Frequency Percent CumulativeFrequency Cumulative Percent 
              0 386 25.99 386 25.99 
              1 1099 74.01 1485 100.00 




          */

proc print data = cohort_death_compare (obs = 20); 
run; 


proc freq data = cohort_death_compare;
where seer_registry not in ('61', '62', '63', '66');
table cancer_death noncancer_death medicare_death_2019 medicare_death; 
run; 

/* 
cancer_death Frequency Percent Cumulative
Frequency CumulativePercent 
0 491 50.20 491 50.20 
1 487 49.80 978 100.00 



noncancer_death Frequency Percent Cumulative
Frequency CumulativePercent 
0 893 91.31 893 91.31 
1 85 8.69 978 100.00 



medicare_death_2019 Frequency Percent Cumulative
Frequency CumulativePercent 
0 405 41.41 405 41.41 
1 573 58.59 978 100.00 



medicare_death Frequency Percent Cumulative
Frequency CumulativePercent 
0 405 41.41 405 41.41 
1 573 58.59 978 100.00 



!!!Actually cancer_death + noncancer_death (572) aligned well with medicare_death_2019 (573)

*/


/**/
/*proc freq data =thesis.cohort_outcomes2 nlevels;*/
/*table cancer_death*seer_registry;*/
/*run; */


/**/
/**/
/*proc freq data = thesis.cohort_outcomes2;*/
/*table medicare_death;*/
/*run; */



/* Kaplan Meier curves by expo group */


ods graphics on;
proc lifetest data=thesis.cohort_outcomes2  plots=survival(atrisk (outside(0.15)));
time years_to_end_followup11 * censor_flag_11(0);
strata MET_1px;
run;

data thesis.cohort_outcomes2;
set cohort_death_compare;
run;
data thesis.Rdat_cohort;
    set thesis.cohort_outcomes2(keep = 
        patient_id seer_registry ICI_index_dt stage SEX Race year_of_diagnosis urbanrural_binary Age_at_ICI NCI_index firstline 
        days_dx_to_tx MET_1px MET_90d MET_180d chemo chemo_count ICI_name ICI_target irAE_v1 irAE_v1_dt 
        irAE_v1_doserange irAE_v1_doserange_dt irAE_v2 irAE_v2_dt 
        irAE_v3 irAE_v3_dt irAE_v4 irAE_v4_dt irAE_v4_doserange 
        irAE_v4_doserange_dt irAE_v5 irAE_v5_dt admin_censor 
        admin_censor_dt noncancer_death noncancer_death_dt 
        mcare_disenroll mcare_disenroll_dt cancer_death cancer_death_dt 
        medicare_death_2019 medicare_death medicare_death_dt seer_death_dt seer_death_dt_format
    );
run;

proc freq data=thesis.cohort_outcomes2;
tables PRCDA_Region;
run;
/*
PRCDA_REGION Frequency Percent Cumulative
Frequency CumulativePercent 
2 797 53.67 797 53.67 
3 113 7.61 910 61.28 
4 197 13.27 1107 74.55 
5 352 23.70 1459 98.25 
6 26 1.75 1485 100.00 

data dictionary doen't have 4 meaning
*/
