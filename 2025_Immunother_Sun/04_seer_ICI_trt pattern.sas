
*******************************************************************************;
* Program name      :	xx_ICI treatment_pattern (+Chemo, etc)
* Author            :	Jamie Heyward
* Date created      :	May 2023
* Study             : 	
* Purpose           :	Describe ICI trt patterns for all ICI patients to place them into different treatment arms
* Inputs            :	
* Program completed : 	
* Updated by        :   Xinyi Sun, for my study, it's a covariate
*********************************************************************************;


LIBNAME seer 'S:\Pharmacoepi0216\Thesis';

/* Describe treatment patterns and combination therapy in order to classify patients by exposure status */ 

	/* In Step 1 (a-f) we added data columns to track usage of ICI and chemo, the running total of each therapy type and the 
			number of switches between treatment types (ICI or Chemo) for each patient. We also tracked the timing of each
			dose relative to the prior dose and to the index date (to understand overlapping tx vs likely switch).

	/* In Step 2 (a-xx) we used the information in these columns to place patients into categories of: 
				1. ICI only (received only ICI or ICIs during follow-up, eligible for follow-up from time of 
							initiation to end of ICI use) n = 3919
				2. Chemo -> ICI (transitioned from chemo (first line) to ICI (second line), 
							eligible for follow-up from time of ICI initiation)) n = 8047
				3. ICI -> Chemo (transitioned from ICI (first line) to chemo (second line), 
							eligible for follow-up from time of ICI initiation to switch) n = 1194 (cumulative sum (13160)
				4. Chemo + ICI combination therapy (initiated overlapping recurrent chemo and ICI doses during follow-up (ICI 3rd dose or before),
							eligible for follow-up from time of ICI/chemo inititation to end of follow-up) n = 4104
				5. Chemo + ICI both received at different times (multiple line of tx switches or combination tx started after initial ICI monotherapy,
							eligible for follow-up from time if ICI initiation) n = 2337

	/* In Step 3 (a-xx) we filtered to the list of ICI records to assess use of multiple ICI over the course of follow up. We
			added columns to indicate "switches" between specific ICI molecules during follow-up, the total number of switches,
			molecules implicated in "switches", and the timing between them. We used the information in those columns to place
			ICI-exposed patients (categories 1-5 above) into categories of: 
				1. Single ICI used during follow-up- no "switches"
				2. >1 ICI used during follow-up- at least one "switch"- line of therapy change(s) (not combination use)
						these patients typically would have just 1 "switch" during follow-up
				3. >1 ICI used during follow-up- at least one "switch"- combination therapy
						these patients typically would have >1 "switch" and would alternate between ICI in an ABA or ABAB pattern
						(typically nivolumab/ipilumumab)

	/* In Step 4 (a-xx) we integrated the information from Step 3 with Step 2 to categorize single- or multiple- ICI users according
			to chemotherapy exposure status. Final exposure categories are: 
				1. ICI only (single ICI)
				2. ICI only (multiple ICI)
				3. ICI and chemo combination (single ICI)
				4. ICI and chemo combination (multiple ICI)
				
			*/

/*			proc print data = seer.combined_nch_outrev_lung_tx_inc (obs = 20);*/
/*			run; */




/* 1. Step 1. Add data columns to track exposure (and sequence of use of) ICI, or ICI AND chemo among eligible ICI users */ 


  /* 1a. Filter list of treatments to patients who are ICI-exposed and who had 12 months of insurance coverage before index date, keep ICI index date */
	
		proc sort data = seer.combined_nch_outrev_lung_tx_inc; 
		by patient_id; 
		run; 

		proc sort data = seer.lung_primary_incident_65_tx_12; 
		by patient_id; 
		run; 

	data seer.tx_list_ici_pats; 
	merge seer.combined_nch_outrev_lung_tx_inc (in = a)
		 seer.lung_primary_incident_65_tx_12 (keep = patient_id ici_index_dt in = b);
	by patient_id;
	if b;
	run;

/*			proc print data = seer.tx_list_ici_pats (obs = 10);*/
/*			run; */

	proc freq data = seer.tx_list_ici_pats nlevels;
		table patient_id /noprint;
		run; 

			/* 19,601 */ /* 17,357 */
		
  /* 1b. Add indicator variable for ICI, chemo, and column for which was recieved for each record */

	data mult_therapy;
	length ICI_or_chemo$ 15;
	set seer.tx_list_ici_pats;
	if ICI_name ne '.' then ICI_or_chemo = "ICI";
		else if chemo_name ne '.' then ICI_or_chemo = "Chemo";
			else ICI_or_chemo = '.';  		/* This is the single column indicating ICI or Chemo */
	if ICI_or_chemo = "ICI" then ICI_indicator = 1;
		else ICI_indicator = 0;
	if ICI_or_chemo = "Chemo" then chemo_indicator = 1; 
		else chemo_indicator = 0; 			/* These are indicator columns for ICI and chemo */
	tx_date = input(clm_thru_dt, yymmdd10.);
	format tx_date date9.;
	if ICI_name ne '.' then drug_name = ICI_name; 
		else drug_name = chemo_name;		/* This column contains the name of the drug used */
	run;

/*		proc print data = mult_therapy (obs = 10); */
/*		run; */



	/* 1b. Running count of ICI and chemo records */

	data mult_therapy1;
	set mult_therapy;
	by patient_id; 
		retain ICI_count;
			if first.patient_id then ICI_count = ICI_indicator; 
				else ICI_count = ICI_count + ICI_indicator;
		retain chemo_count;
			if first.patient_id then chemo_count = chemo_indicator; 
				else chemo_count = chemo_count + chemo_indicator;
	run; 

	proc print data = mult_therapy1 (obs = 50); 
	run; 



	/* 1c. Cumulative total of ICI and chemo records per patient */ 

		proc sort data = mult_therapy1 out = mult_therapy2;
		by patient_id descending rx_count;
		run; 

		proc print data = mult_therapy2 (obs = 50); 
		run; 
		
			data mult_therapy3;
			  set mult_therapy2;
			  by patient_id;
			  if first.patient_id then ICI_total = ICI_count;
			  retain ICI_total;
			  if first.patient_id then chemo_total = chemo_count;
			  retain chemo_total; 
			run;

	proc print data = mult_therapy3 (obs = 50); 
			run; 

				proc sort data = mult_therapy3 out = mult_therapy4;
				by patient_id rx_count; 
				run; 
			

	/* 1d. Add prescription date gap between consecutive records */ 

		data mult_therapy4; 
		set mult_therapy4;
		by patient_id; 
		prev_tx_date = lag(tx_date);
			format prev_tx_date date9.;
		if first_tx = 1 then prev_tx_date ='.'; 
 	 	diffdate = tx_date - prev_tx_date;
		run; 

			proc print data = mult_therapy4 (obs = 50); 
			run; 


	/* 1e. Add days since first tx date for each record */

		proc sort data = mult_therapy4; 
		by patient_id; 
		run; 

		data mult_therapy5;
		set mult_therapy4;
		by patient_id; 
		retain first_tx_dt;
		if first.patient_id then first_tx_dt = tx_date;
			format first_tx_dt date9.;
		daysince0 = tx_date - first_tx_dt;
		daysinceindex = tx_date - ici_index_dt;  
		run; 

		proc print data = mult_therapy5 (obs = 10); 
		run; 

		proc freq data = mult_therapy5; 
		table daysince0 daysinceindex;
		run; 


	/* 1f. For exploration: histogram of daysince0 for ICI and Chemo rx */ 

		/* Histogram */ 

		data mult_therapy100;
		set mult_therapy5;
		where daysince0 <100;
		run; 

		ods graphics on;
		proc univariate data = mult_therapy100 noprint;
		class ICI_indicator;
		Title 'Distribution of Days Since Index Date of ICI and Chemo Records';
			histogram daysince0;
		run; 
		ods graphics off;
							


	/* 1g. Add indicator for every transition ICI vs chemo (to determine combo therapy vs line of therapy switch) */

	data mult_therapy6;
	set mult_therapy5;
	by patient_id; 
		prev_drug_name = lag(drug_name);
 			if first_tx = 1 then prev_drug_name='.';
 				if drug_name = prev_drug_name then different_drug = 0;
 				else if first_tx = 1 then different_drug = '.';
					else different_drug = 1;
		prev_tx_type = lag(ICI_or_chemo); 
			if first_tx = 1 then prev_tx_type = '.';
				if ICI_or_chemo = prev_tx_type then different_tx_type = 0;
				else if first_tx = 1 then different_tx_type = '.';
					else different_tx_type = 1;
	run;


	proc print data = mult_therapy6 (obs = 100);
	run; 


	/* 1h. Count total transitions between ICI and chemo */ 

		/* i.e. 1 transition would indicate change in line of tx, many transitions would indicate combination therapy */

		proc sort data = mult_therapy6 out = mult_therapy7; 
		by patient_id; 
		run; 

		data mult_therapy7;
		set mult_therapy7; 
		by patient_id;
			if first.patient_id then ICI_chemo_transition_count = different_tx_type; 
					ICI_chemo_transition_count + different_tx_type;
		run; 
/**/
/*				proc print data = mult_therapy7 (obs = 50);*/
/*				run; */


	/* 1i. Add total ICI/chemo transition sum for each patient */ 

				proc sort data = mult_therapy7 out = mult_therapy8;
				by patient_id descending rx_count;
				run; 

/*					proc print data = mult_therapy8 (obs = 50); */
/*					run; */

				data mult_therapy9;
				set mult_therapy8;
				by patient_id;
				if first.patient_id then ICI_chemo_transition_total = ICI_chemo_transition_count;
				retain ICI_chemo_transition_total;
				run;
/**/
/*					proc print data = mult_therapy9(obs = 50); */
/*					run; */

				proc sort data = mult_therapy9 out = mult_therapy10; 
				by patient_id rx_count;
				run; 

					proc print data = mult_therapy10(obs = 50); 
					run; 



	/* Step 2. Categorize exposure status according to ICI/Chemo exposure patterns */

		/* 2a. Create frequency table of total ICI/chemo transitions */ 
			/* Individuals with 0 transitions are in category 1 (ICI only) */ 
			/* Individuals with 1 transition are either in category 2 (Chemo -> ICI) or category 3 (ICI -> Chemo) */
			/* Individuals with >1 transition are likely to be in category 4 (Chemo/ICI combo) but may also have transitioned
					between exposure categories one or more times, and could have transitioned from chemo onto ICI+ICI or ICI+Chemo */ 
			/* Individuals with "missing" only got one dose of a therapy during follow-up (category 1). */

			data ICI_chemo_transition_count; 
			set mult_therapy10;
			by patient_id;
			if first.patient_id then first = 1; 
			run; 

			data ICI_chemo_transition_count1;
			set ICI_chemo_transition_count;
			where first = 1;
			run; 

				proc print data = ICI_chemo_transition_count1 (obs = 10); 
				run; 

			proc freq data = ICI_chemo_transition_count1;
			table ICI_chemo_transition_total;
			run; 


				/* 
			ICI_chemo_transition_total Frequency Percent CumulativeFrequency CumulativePercent 
					0 3205 16.97 3205 16.97 
					1 9241 48.93 12446 65.90 
					2 2162 11.45 14608 77.34 
					3 707 3.74 15315 81.09 
					4 277 1.47 15592 82.55 
					5 404 2.14 15996 84.69 
					6 301 1.59 16297 86.29 
					7 388 2.05 16685 88.34 
					8 503 2.66 17188 91.00 
					9 328 1.74 17516 92.74 
					10 163 0.86 17679 93.60 
					11 187 0.99 17866 94.59 
					12 166 0.88 18032 95.47 
					13 145 0.77 18177 96.24 
					14 63 0.33 18240 96.57 
					15 83 0.44 18323 97.01 
					16 39 0.21 18362 97.22 
					17 64 0.34 18426 97.56 
					18 41 0.22 18467 97.78 
					19 37 0.20 18504 97.97 
					20 28 0.15 18532 98.12 
					21 32 0.17 18564 98.29 
					22 22 0.12 18586 98.41 
					23 47 0.25 18633 98.66 
					24 20 0.11 18653 98.76 
					25 29 0.15 18682 98.91 
					26 8 0.04 18690 98.96 
					27 28 0.15 18718 99.11 
					28 12 0.06 18730 99.17 
					29 16 0.08 18746 99.25 
					30 12 0.06 18758 99.32 
					31 11 0.06 18769 99.38 
					32 8 0.04 18777 99.42 
					33 19 0.10 18796 99.52 
					34 1 0.01 18797 99.52 
					35 16 0.08 18813 99.61 
					36 6 0.03 18819 99.64 
					37 8 0.04 18827 99.68 
					38 2 0.01 18829 99.69 
					39 12 0.06 18841 99.76 
					40 5 0.03 18846 99.78 
					41 3 0.02 18849 99.80 
					42 4 0.02 18853 99.82 
					43 2 0.01 18855 99.83 
					44 2 0.01 18857 99.84 
					45 4 0.02 18861 99.86 
					46 2 0.01 18863 99.87 
					49 3 0.02 18866 99.89 
					50 1 0.01 18867 99.89 
					51 6 0.03 18873 99.93 
					52 2 0.01 18875 99.94 
					53 2 0.01 18877 99.95 
					54 1 0.01 18878 99.95 
					55 1 0.01 18879 99.96 
					56 2 0.01 18881 99.97 
					63 2 0.01 18883 99.98 
					65 2 0.01 18885 99.99 
					79 1 0.01 18886 99.99 
					148 1 0.01 18887 100.00 
					Frequency Missing = 714 


			*/

					/* 714 missing? */
/*					proc print data = ICI_chemo_transition_count1;*/
/*					where ICI_chemo_transition_total =.;*/
/*					run; */

					/* They all only got 1 dose of medication during follow-up */ 


		/* 2b. Category 1: Create reference list of patients with 0 transitions to categorize as category 1 */ 

					/* Category 1 (ICI only) */
					data ICI_only_multdose; 
					set ICI_chemo_transition_count1;
					where ICI_chemo_transition_total = 0; 
					run; 

					data ICI_only_1dose;
					set ICI_chemo_transition_count1;
					where ICI_chemo_transition_total =.;
					run;

					data seer.ICI_only; 
					set ICI_only_multdose ICI_only_1dose;
					run;


						/* total patients? */ 
						proc freq data = seer.ICI_only nlevels;
						table patient_id /noprint; 
						run; 

							/* 3919 */ 


	/* 2c. Assess the type of transition among individuals with 1 transition
				(either category 2 (Chemo -> ICI) or category 3 (ICI -> Chemo) */ 

			data single_transition; 
			set ICI_chemo_transition_count;
			where ICI_chemo_transition_total = 1; 
			run; 

/*				proc print data = single_transition (obs = 100); */
/*				run; */

			/* Create variables to categorize transition types */ 
			data single_transition1; 
			set single_transition;
			where different_tx_type = 1;
			transition_drugs = catx("->", prev_drug_name, drug_name);
			transition_type = catx("->", prev_tx_type, ICI_or_chemo);
			if transition_type = "ICI->Chemo" then before_doses = ICI_total;
			else if transition_type = "Chemo->ICI" then before_doses = chemo_total;
			if transition_type = "ICI->Chemo" then after_doses = chemo_total;
			else if transition_type = "Chemo->ICI" then after_doses = ICI_total;
			if transition_type = "ICI->Chemo" then before_after_doses = catx(",", ICI_total, chemo_total);
			else if transition_type = "Chemo->ICI" then before_after_doses = catx(",", chemo_total, ICI_total);
			if transition_type = "ICI->Chemo" then days_to_switch = daysince0;
			else if transition_type = "Chemo->ICI" then days_to_switch = daysince0;
			run; 

/*				proc print data = single_transition1 (obs = 50); */
/*				run; */

				/* Frequency table of what treatment types were implicated in the transition */ 
				proc freq data = single_transition1;
				table transition_type;
				run; 

					/*
					transition_type Frequency Percent CumulativeFrequency CumulativePercent 
							Chemo->ICI 8047 87.08 8047 87.08   

							ICI->Chemo 1194 12.92 9241 100.00 
							*/

					/* The vast majority of transitions were from chemo to ICI (so got ICI second line) */ 


	/* 2d. Create reference table of individuals in category 2 (Chemo -> ICI) and category 3 (ICI -> Chemo) */ 

			/* Category 2 (Chemo -> ICI) */ 
			data seer.chemo_to_ICI; 
			set single_transition1; 
			where transition_type = "Chemo->ICI";
			run; 

				/* Total patients?*/ 
				proc freq data = seer.chemo_to_ICI nlevels;
				table patient_id /noprint; 
				run; 

					/* 8047 patients */ 


			/* Category 3 (ICI -> Chemo) */ 
			data seer.ICI_to_chemo; 
			set single_transition1; 
			where transition_type = "ICI->Chemo";
			run; 

				/* Total patients?*/ 
				proc freq data = seer.ICI_to_chemo nlevels;
				table patient_id /noprint; 
				run; 

					/* 1194 patients */ 


	/* For exploration: transition timing, drug implicated */

			/* Mean no. of records before and after transition- is there a threshold for dose # to have been exposed to both? */ 

				proc sort data = single_transition1 out = single_transition1s;
				by transition_type;
				run; 

				proc means data = single_transition1s;
				by transition_type;
				var before_doses after_doses;
				run; 

					/*

							transition_type=Chemo->ICI

				Variable N Mean Std Dev Minimum Maximum 
				before_doses  8047 16.7228781  12.0524685  1.0000000  205.0000000 
				after_doses   8047 13.2650677  17.9399515  1.0000000  237.0000000


					 
				 
				 			transition_type=ICI->Chemo
				
				Variable N Mean Std Dev Minimum Maximum 
				before_doses  1194  4.6649916  7.5149472  1.0000000 77.0000000 
				after_doses   1194  8.2077052  11.8810989 1.0000000 116.0000000
				 				  
					*/


		/* Frequency table of what meds were implicated in the transition among single transitions */ 

			/* By molecule (for all Category 2 and 3 patients */
			proc freq data = single_transition1; 
			table transition_drugs; 
			run; 

				/* Transition from chemo (class) to ICI (by molecule) for Chemo->ICI patients */
				data single_transition2; 
				set single_transition1;
				if transition_type = "Chemo->ICI" then transition_chemo_ICIname = catx("->", prev_tx_type, drug_name);
				else transition_chemo_ICIname = '.';
				run;

				proc freq data = single_transition2; 
				where transition_chemo_ICIname ne '.';
				table transition_chemo_ICIname; 
				run; 

						/* 
					transition_chemo_ICIname Frequency Percent CumulativeFrequency CumulativePercent 
					Chemo->ATEZOLIZUMAB 		377 	4.68 	377 		4.68 
					Chemo->AVELUMAB 			1 		0.01 	378 		4.70 
					Chemo->DURVALUMAB 			1461 	18.16 	1839 		22.85 
					Chemo->IPILIMUMAB 			222 	2.76 	2061 		25.61 
					Chemo->NIVOLUMAB 			4559 	56.65 	6620 		82.27 
					Chemo->PEMBROLIZUMAB 		1427 	17.73 	8047 		100.00 
 
						*/

				/* The majority of transitions were from chemo to nivolumab specifically (is it second-line in guidelines?) */ 

				/* All of these subjects would be in the ICI-only arm, with prior chemo exposure history */


		/* Comparing mean days to switch among ICI -> Chemo and Chemo -> ICI switchers */

				proc means data = single_transition1;
				var days_to_switch;
				class transition_type;
				run; 

					/* Analysis Variable : days_to_switch  
					transition_type N Obs 	N 		Mean 			Std Dev 		Minimum 	Maximum 
					Chemo->ICI 		8047 	8047 	351.1112216 	365.6479366 	6.0000000 	2775.00 
					ICI->Chemo 		1194 	1194 	96.9715243 		173.3417109 	0 			1249.00 
 
					*/


	/* Step 2f. Assess transition patterns among those with >1 ICI/chemo transition (Category 4 or Category 5- other line of tx switch pattern) */ 

			/* Filter to records of individuals with >1 transition */ 
				data multiple_transition; 
				set ICI_chemo_transition_count; 
				where ICI_chemo_transition_total >1; 
				run; 

				proc print data = multiple_transition (obs = 50);
				run; 

					proc freq data = multiple_transition nlevels;
					table patient_id /noprint; 
					run; 

					/* 6441 patients */ 
				/* Histogram- dates of ICI and chemo records */

				ods graphics on;
				proc univariate data = multiple_transition noprint;
				where daysince0>0 & daysince0<100; 
				class ICI_indicator;
				Title 'Distribution of Days Since Index Date of Chemo and ICI Records';
					histogram daysince0;
				run; 
				ods graphics off;

					/* Records for ICI and chemo seem to be very coordinated, chemo can be weekly, while ICI is once every 3wks */


				/* Histogram- transition dates */ 

				data multiple_transition100_1;
				set multiple_transition;
				where daysince0 <100 & different_tx_type=1;
				run; 
/**/
/*					proc print data = multiple_transition100 (obs = 50); */
/*					run; */

				ods graphics on;
				proc univariate data = multiple_transition100_1 noprint;
				class ICI_indicator;
				Title 'Distribution of Days Since Index Date of Chemo/ICI and ICI/Chemo Transitions';
					histogram daysince0;
				run; 
				ods graphics off;

				ods graphics on;
				proc univariate data = multiple_transition100_1 noprint;
				class ICI_indicator;
				Title 'Distribution of Days Since Prior Rx of Chemo/ICI and ICI/Chemo Transitions';
					histogram diffdate;
				run; 
				ods graphics off;
				title;

					/* Almost always, the "transition" from ICI to chemo is on the same day as receipt of ICI- indicating
					that the chemo was administered with the ICI */ 

					/* Individuals appearing to be on combo. therapy start a new "cycle" (new ICI) every 21 or 28 days (get chemo/ICI therapy every 
						3-4 wks) AND receive chemo/ICI on the same day ("gap" between transitions is zero)... this should be the indicator 
						of combo therapy */

				/* Describe transitions in this group */ 
				data multiple_transition1;
				set multiple_transition;
				where different_tx_type = 1;
				transition_drugs = catx("->", prev_drug_name, drug_name);
				transition_type = catx("->", prev_tx_type, ICI_or_chemo);
				run; 

				proc print data = multiple_transition1 (obs = 50);
				run; 

					proc freq data = multiple_transition1; 
					where transition_type = "ICI->Chemo";
					table diffdate; 
					run; 

						/* 89% if ICI->Chemo transitions were 0 days after previous ICI... same day chemo.. 
							Cumulatively 95% of ICI-chemo transitions were =<28 days from ICI, indicating likely co-use of chemo and ICI */

							/* 

					diffdate Frequency Percent CumulativeFrequency CumulativePercent 
								0 30907 89.05 30907 89.05 
								1 20 0.06 30927 89.11 
								2 14 0.04 30941 89.15 
								3 18 0.05 30959 89.20 
								4 13 0.04 30972 89.24 
								5 10 0.03 30982 89.26 
								6 34 0.10 31016 89.36 
								7 195 0.56 31211 89.92 
								8 19 0.05 31230 89.98 
								9 15 0.04 31245 90.02 
								10 15 0.04 31260 90.07 
								11 11 0.03 31271 90.10 
								12 21 0.06 31292 90.16 
								13 52 0.15 31344 90.31 
								14 292 0.84 31636 91.15 
								15 53 0.15 31689 91.30 
								16 50 0.14 31739 91.45 
								17 28 0.08 31767 91.53 
								18 38 0.11 31805 91.64 
								19 40 0.12 31845 91.75 
								20 63 0.18 31908 91.93 
								21 377 1.09 32285 93.02 
								22 88 0.25 32373 93.27 
								23 40 0.12 32413 93.39 
								24 38 0.11 32451 93.50 
								25 37 0.11 32488 93.60 
								26 50 0.14 32538 93.75 
								27 64 0.18 32602 93.93 
								28 262 0.75 32864 94.69 
								29 75 0.22 32939 94.90 
								30 42 0.12 32981 95.02 
								31 34 0.10 33015 95.12 
								32 30 0.09 33045 95.21 
								33 24 0.07 33069 95.28 
								34 55 0.16 33124 95.44 
								35 125 0.36 33249 95.80 
								36 45 0.13 33294 95.93 
								37 26 0.07 33320 96.00 
								38 27 0.08 33347 96.08 
								39 17 0.05 33364 96.13 
								40 27 0.08 33391 96.21 
								41 28 0.08 33419 96.29 
								42 113 0.33 33532 96.61 
								----
								more
						*/

					proc freq data = multiple_transition1; 
					where transition_type = "Chemo->ICI";
					table diffdate; 
					run; 

						/* Almost none of the Chemo->ICI transitions were 0 days apart... 43% were 21days apart, 2% were 7 days apart, 
							3% were 14 days apart and 6% were 28 days apart. Cumulatively, 77% were 28 days or fewer from previous ICI, 
							indicating likely co-use of chemo and ICI in those cases */ 

					/* It appears many are receiving chemo the same day or at least within 4 wks of prior ICI dose... and are taking ICI within 28 days of prior chemo dose.
							Tag those instances */

					data multiple_transition1_1;
					set multiple_transition1; 
						if diffdate < 29 then overlap_chemo_ICI = 1; 
							else if diffdate > 28 then overlap_chemo_ICI = 0;
								else overlap_chemo_ICI ='.';
						if transition_type = "ICI->Chemo" then ICI_to_chemo = 1; 
							else ICI_to_chemo = 0; 
						if transition_type = "Chemo->ICI" then chemo_to_ICI = 1; 
							else chemo_to_ICI = 0;
					by patient_id;
						if first.patient_id then count_overlap = overlap_chemo_ICI;
							else count_overlap + overlap_chemo_ICI;
						if first.patient_id then count_ICI_to_chemo = ICI_to_chemo; 
							else count_ICI_to_chemo + ICI_to_chemo;
						if first.patient_id then count_chemo_to_ICI = chemo_to_ICI;
							else count_chemo_to_ICI + chemo_to_ICI;
					run; 

						proc print data = multiple_transition1_1 (obs = 50);
						run; 

						/* Sum total of overlapping chemo/ICI records */ 
						proc sort data = multiple_transition1_1 out = multiple_transition1_1s; 
						by patient_id descending rx_count; 
						run; 

						data multiple_transition1_1s;
						set multiple_transition1_1s; 
						by patient_id; 
						retain total_overlap;
						if first.patient_id then total_overlap = count_overlap;
						run; 

						proc sort data = multiple_transition1_1s out = multiple_transition1_2;
						by patient_id rx_count;
						run; 

							proc print data = multiple_transition1_2 (obs = 50);
							run;

							proc print data = multiple_transition1_2 (obs = 50);
							where ICI_chemo_transition_total = 2;
							run;


						/* Total_overlap should be similar to total_ICI_to_chemo if the patient is getting combination therapy during follow-up */

							/* Explore relationship between total_ICI_to_chemo and total_overlap in this group */ 
						
							data multiple_transition1_2;
							set multiple_transition1_2;
							by patient_id;
							if first.patient_id then first = 1;
							run; 

							data multiple_transition1_21;
							set multiple_transition1_2;
							where first = 1; 
							pct_overlap = (total_overlap/ICI_chemo_transition_total)*100;
							run; 

								proc print data = multiple_transition1_21 (obs = 50);
								run; 

							proc freq data = multiple_transition1_21;
							table pct_overlap;
							run; 

								/* 13% of ICI/chemo patients had 0% sameday ICI/chemo, 38% had 100% sameday ICI/chemo... many in between (mostly >50%) */

							/*

							pct_overlap Frequency Percent CumulativeFrequency CumulativePercent 
							0 1226 12.81 1226 12.81 
							---
							33.3 108 1.13 1354 14.15 
							---
							50 1590 16.62 2953 30.87 
							--- 
							75 291 3.04 3840 40.14 
							---
							80 227 2.37 4208 43.98 
							---
							83.3 265 2.77 4541 47.47 
							---
							90 75 0.78 5322 55.63 
							---
							100 3643 38.08 9567 100.00 

								*/

							/* Look at the indiviuals with 0 instances of overlapping ICI/chemo doses */
							proc print data = multiple_transition1_2 (obs = 100);
							where total_overlap = 0; 
							run; 

							proc freq data = multiple_transition1_21;
							where total_overlap=0;
							table ICI_chemo_transition_total;
							run; 

								/* 100% of people with 0 "overlapping" chemo + ICI only "transitioned" 2-4 times total
									These were likely all line of therapy switches (not combo) */

										/*

								ICI_chemo_transition_total Frequency Percent CumulativeFrequency CumulativePercent 
										2 1155 94.21 1155 94.21 
										3 63 5.14 1218 99.35 
										4 8 0.65 1226 100.00 

										*/


								/* Patterns of ICI and chemo dispensation in the group (if never overlapping... ) */ 

								data multiple_transition1_nooverlap; 
								set multiple_transition1_2;
								where total_overlap = 0; 
								run; 

								proc sql;
								create table multiple_transition_nooverlap as
								select * 
								from multiple_transition
								where patient_id in (select patient_id from multiple_transition1_nooverlap);
								quit;

									proc print data = multiple_transition_nooverlap (obs = 100); 
									run; 


								/* Histogram of ICI and chemo records in this group */
								ods graphics on;
								proc univariate data = multiple_transition_nooverlap noprint;
								where daysince0<100;
								class ICI_indicator;
								Title 'Distribution of Days Since Index Date of ICI and Chemo Records of Non-Simultaneous Users';
									histogram daysince0;
								run; 
								ods graphics off;

									/* It looks like more chemo records earlier in treatment, more ICI records later in treatment? */

								/* How many days since prior tx type for each transition? */ 
								proc freq data = multiple_transition1_2;
								where total_overlap=0;
								table diffdate; 
								run; 

									/* 25% of these transitions were =<45 days... expand definition of overlap? */

									/* 
								diffdate Frequency Percent CumulativeFrequency CumulativePercent 
									29 70 2.77 70 2.77 
									30 40 1.58 110 4.35 
									31 39 1.54 149 5.89 
									32 31 1.22 180 7.11 
									33 16 0.63 196 7.74 
									34 41 1.62 237 9.36 
									35 140 5.53 377 14.90 
									36 36 1.42 413 16.32 
									37 27 1.07 440 17.38 
									38 25 0.99 465 18.37 
									39 18 0.71 483 19.08 
									40 25 0.99 508 20.07 
									41 33 1.30 541 21.37 
									42 92 3.63 633 25.01 
									43 26 1.03 659 26.04 
									44 25 0.99 684 27.02 
									45 21 0.83 705 27.85 
									---
									more
									---
									*/


							proc freq data = multiple_transition1_2;
							where total_overlap ne 0;
							table ICI_chemo_transition_total;
							run; 

								/* 19% of patients with >0 "sameday" chemo +ICI only "transitioned" 2-5 times total 
									(i.e. it was much less common to have "few" transitions if chemo +ICI were administered 
									on the same day even once). */ 


				/* What is % overlap if exclude individuals with 2-5 ICI/Chemo "transitions" (treat them as line of tx switches)*/ 
				proc freq data = multiple_transition1_21;
				where ICI_chemo_transition_total >5;
				table pct_overlap;
				run; 

				/* 47% have 100% "overlap", 97% have >70% overlap */


				/* What does 60% overlap look like */
/*				proc print data = multiple_transition1_21;*/
/*				where pct_overlap = 60 & ICI_chemo_transition_total>5; */
/*				run; */
/**/
/*				proc print data = multiple_transition; */
/*				where patient_id = 'lnK2022T0993601'; */
/*				run; */
/**/
/*				proc print data = multiple_transition; */
/*				where patient_id = 'lnK2022U0833922'; */
/*				run; */


				
				/* What does 37.5% overlap look like */
/*				proc print data = multiple_transition1_21;*/
/*				where pct_overlap = 37.5 & ICI_chemo_transition_total>5; */
/*				run; */
/**/
/*				proc print data = multiple_transition; */
/*				where patient_id = 'lnK2020z7726428'; */
/*				run; */


				
/* 2g. Category 4 and 5: Categorize people whose first (or early) ICI rx is on same day as a chemo rx as multiple therapy; others are ICI only (may be multiple switchers but in ITT analysis will not matter) */ 

	/* Dataset with all records of people with same-day ICI and chemo */ 
	data ICI_chemo_combo; 
	set multiple_transition1; 
	where TRANSITION_TYPE = "ICI->Chemo" & DIFFDATE = 0; 
	run; 

	proc sort data = ICI_chemo_combo; 
	by patient_id rx_count; 
	run; 

	/* Flag first instance of same-day ICI and chemo */ 
	data ICI_chemo_combo_first; 
	set ICI_chemo_combo; 
	by patient_id; 
	if first.patient_id then firstcombo = 1; 
	run; 

	data ICI_chemo_combo_first1; 
	set ICI_chemo_combo_first;
	where firstcombo = 1; 
	run; 

	/* On what ICI dose did it occur? */ 
	proc freq data = ICI_chemo_combo_first1; 
	table ICI_count; 
	run; 


		/* 

	ICI_COUNT 
	Frequency Percent CumulativeFrequency CumulativePercent 
		1 		3723 		83.48 	3723 	83.48 
		2 		346 		7.76 	4069 	91.23 
		3 		47 			1.05 	4116 	92.29 
		---
		77 		1 			0.02 	4460 	100.00 

			*/

	proc freq data = ICI_chemo_combo nlevels; 
	table patient_id /noprint; 
	run; 

			/* 4460 */ 

	/* Anyone getting simultaneous chemo on 1st, 2nd or 3rd-ever ICI dose is classified as combination tx */ 
	data ICI_chemo_combo_first1_3; 
	set ICI_chemo_combo_first1;
	where ICI_count < 4; 
	run; 

	proc freq data = ICI_chemo_combo_first1_3;
	table ICI_count*daysince0; 
	run; 

	/* Most who got chemo on same day as 2nd ICI dose were getting it day 0 (meaning 2 ICI and 1 chemo that day) 
		Some received chemo +2nd dose or chemo + 3rd dose very long after index date (like 100+ days)- don't include
		Filter on 70 days or less from index date (on-schedule 3rd dose should be 63 days from index date) */


	/* Category 4- List of patients on combo therapy (Category 4)  */ 
	data seer.ICI_chemo_combo_first1_3; 
	set ICI_chemo_combo_first1_3;
	where daysince0 < 70; 
	run; 

		proc freq data = seer.ICI_chemo_combo_first1_3 nlevels;
		table patient_id /noprint;
		run; 

		proc print data = seer.ICI_chemo_combo_first1_3 (obs = 10); 
		run; 
			
		/* 4104 patients on multi-tx */ 

			
			/* How many ICI/Chemo transitions in this group? */ 
			proc freq data = seer.ICI_chemo_combo_first1_3;
			where ICI_CHEMO_TRANSITION_COUNT = 1; 
			table ICI_CHEMO_TRANSITION_TOTAL;
			run; 

				/* 4% had 2 transitions, 14% had 3 transitions, 82% had 4 or more transitions */ 

			/* How many had prior chemo tx before ICI index date? */ 
			proc freq data = seer.ICI_chemo_combo_first1_3; 
			table chemo_count; 
			run; 

			/* 23% had at least 3 chemo doses prior to ICI index date */ 



	/* Category 5- List of "mult therapy" patients who will be classfied as ICI users (Category 5) */ 
	proc sql; 
	create table seer.ICI_chemo_nocombo as
	select *
	from multiple_transition1 
	where patient_id not in(select patient_id from seer.ICI_chemo_combo_first1_3); 
	quit; 

		/* Filter to first obs per patient */ 
			proc sort data = seer.ICI_chemo_nocombo; 
			by patient_id;
			run; 

		data seer.ICI_chemo_nocombo; 
		set seer.ICI_chemo_nocombo; 
		by patient_id;
		if first.patient_id then first = 1; 
		run; 

		data seer.ICI_chemo_nocombo1;
		set seer.ICI_chemo_nocombo;
		where first = 1; 
		run; 

		proc freq data = seer.ICI_chemo_nocombo nlevels;
		table patient_id /noprint;
		run; 
			
		/* 2337 patients not classified as combo tx */ 

			

			proc freq data = seer.ICI_chemo_nocombo;
			where ICI_CHEMO_TRANSITION_COUNT = 1;
			table ICI_CHEMO_TRANSITION_TOTAL;
			run; 
				
				/* 80% had 2 transitions, 6% had 3 transitions, 91% had 5 or less */ 



		




			/* Expand to chemo within 21 days of ICI */ 
					/* NOTE: IT DOES NOT SIGNIFICANTLY CHANGE THE NUMBER OF PATIENTS WITH ICI+CHEMO COMBO: KEEP IT AT 0 DAYS */ 
		/*	data ICI_chemo_combo1; */
		/*	set multiple_transition1; */
		/*	where TRANSITION_TYPE = "ICI->Chemo" & DIFFDATE <22; */
		/*	run; */
		/**/
		/*	data ICI_chemo_combo1_first; */
		/*	set ICI_chemo_combo1; */
		/*	by patient_id; */
		/*	if first.patient_id then firstcombo = 1; */
		/*	run; */
		/**/
		/*	data ICI_chemo_combo1_first1; */
		/*	set ICI_chemo_combo1_first;*/
		/*	where firstcombo = 1; */
		/*	run; */
		/**/
		/*	proc freq data = ICI_chemo_combo1_first1; */
		/*	table ICI_COUNT; */
		/*	run; */

				/* 

			ICI_COUNT 
			Frequency Percent CumulativeFrequency CumulativePercent 
				1 		3775 	74.44 	3775 		74.44 
				2 		369 	7.28 	4144 		81.72 
				3 		78 		1.54 	4222 		83.26 
				---
				132 	1 		0.02 	5071 		100.00 

				*/ 

		/*	proc freq data = ICI_chemo_combo1_first1 nlevels; */
		/*	table patient_id /noprint; */
		/*	run; */

				/* 5071 */ 






/* Step 3. Categorize ICI-exposed "mult therapy" users as single, switch-, or multi-ICI users  */ 


		/* Step 3a. Flag instances of ICI transition/switch */

		data mult_ICI; 
		set mult_therapy10; 
		where ICI_indicator = 1; 
		ICI_name = drug_name;
		ICI_date = tx_date;
			format ICI_date date9.;
		by patient_id; 
		ICI_name_lag1 = lag(ICI_name);
 				if first.patient_id then ICI_name_lag1='.';
 					if ICI_name = ICI_name_lag1 then different_ICI = 0;
 					else if first.patient_id then different_ICI = '.';
						else different_ICI = 1;
		ICI_date_lag1 = lag(ICI_date); 
			format ICI_date_lag1 date9.;
			if first.patient_id then ICI_date_lag1 = '.';
		diffdate_ICI = ICI_date - ICI_date_lag1;
		run; 

		proc print data = mult_ICI (obs = 50); 
		run; 

		proc print data = mult_ICI (obs = 50);
		where different_ICI = 1; 
		run; 


		/* Step 3b. Classify patients with ICI "switch" on same day as prior ICI- i.e. 2 ICI on same day- early in treatment
			This is analogous to how simultaneous chemo + ICI was defined */ 
		data mult_ICI_sameday; 
		set mult_ICI; 
		where different_ICI = 1 & diffdate_ICI = 0; 
		run; 

		proc print data = mult_ICI_sameday (obs = 20); 
		run; 

		proc freq data = mult_ICI_sameday; 
		table ICI_count; 
		run; 
		
			/* Most simultaneous use of 2 different ICI is relatively early in dosing (2nd, 3rd, 4th total ICI dose) */ 

		proc freq data = mult_ICI_sameday nlevels; 
		table patient_id /noprint;
		run; 

				/* ONLY 402 patients with same-day use of 2 different ICI *

	
		/* Step 3c. Classify those whose first instance of simultaneous ICI + ICI is on 2nd or 3rd-ever ICI dose */ 
		proc sort data = mult_ICI_sameday; 
		by patient_id ICI_count; 
		run; 

		data mult_ICI_sameday1; 
		set mult_ICI_sameday; 
		by patient_id; 
		if first.patient_id then first_multICI = 1; 
		run; 

			proc print data = mult_ICI_sameday1 (obs = 50); 
			run; 

		data mult_ICI_sameday2; 
		set mult_ICI_sameday1; 
		where first_multICI = 1; 
		run; 

		proc freq data = mult_ICI_sameday2; 
		table ICI_count; 
		run; 

		data mult_ICI_sameday3; 
		set mult_ICI_sameday2; 
		where ICI_count<4 & daysince0 < 30; 
		run;

			/* 290 individuals */

		proc freq data = mult_ICI_sameday3; 
		table daysince0; 
		run; 


			/* 

		daysince0 Frequency Percent CumulativeFrequency CumulativePercent 
			0 287 98.97 287 98.97 
			14 1 0.34 288 99.31 
			28 2 0.69 290 100.00 

		*/

		data seer.mult_ICI_sameday3; 
		set mult_ICI_sameday3; 
		transition_drugs_ICI = catx("->", ICI_name_lag1, ICI_name);
		run; 

		proc print data = seer.mult_ICI_sameday3 (obs = 50); 
		run; 





			/* 3d. For exploration:  Coding patterns of ICI "switch" */ 

				/* Running count of ICI "switches" */ 
				proc sort data = mult_ICI out = mult_ICI1;
				by patient_id;
				run; 

/*					proc print data = mult_ICI1 (obs = 50);*/
/*					run; */

				data mult_ICI2;
				set mult_ICI1;
				by patient_id; 
					if first.patient_id then ICI_switch_count = different_ICI; 
					ICI_switch_count + different_ICI;
				run; 

/*					proc print data = mult_ICI2 (obs = 50); */
/*					run; */



			/* Sum total of ICI switches */ 
					proc sort data = mult_ICI2 out = mult_ICI3;
					by patient_id descending rx_count;
					run; 

						proc print data = mult_ICI3 (obs = 50); 
						run; 

				data mult_ICI4;
				  set mult_ICI3;
				  by patient_id;
				  if first.patient_id then ICI_switch_total = ICI_switch_count;
				  retain ICI_switch_total;
				run;

/*					proc print data = mult_ICI4 (obs = 50); */
/*					run; */

					proc sort data = mult_ICI4 out = mult_ICI5;
					by patient_id rx_count; 
					run; 
						
/*						proc print data = mult_ICI5 (obs = 50); */
/*						run; */


		/* Final table- multiple ICI */ 
		data seer.mult_ICI; 
		set mult_ICI5;
		run; 
				
/*			proc print data = seer.mult_ICI (obs = 50); */
/*			run; */

			proc freq data = seer.mult_ICI nlevels;
			table patient_id /noprint; 
			run; 

					/* 19,601 */

/*					proc print data = seer.mult_ICI (obs = 50); */
/*					where ICI_switch_total = 1; */
/*					run; */


			/* Summarize switch molecules to see which qualify as multi-therapy (e.g. with ipi/nivo) and which were starting new lines of therapy */ 
			data mult_ICI_switchname; 
			set seer.mult_ICI;
			where different_ICI = 1; 
			ICI_transition = catx('->', ICI_name_lag1, ICI_name);
			run; 


			/* Summarize switches among those who "switched" only once (mostly line of tx change? */ 
			
						/* For patients with at least 2 "switches" */
						data mult_ICI_switchname_2; 
						set mult_ICI_switchname;
						where ICI_switch_total > 1; 
						by patient_id; 
						ICI_name_lag2 = lag(ICI_name_lag1);
							if ICI_switch_count = 1 then ICI_name_lag2 = '.';
						ICI_name_lag3 = lag(ICI_name_lag2); 
							if ICI_switch_count <3 then ICI_name_lag3 = '.';
						diffdate_ICI_lag1 = lag(diffdate_ICI);
							if ICI_switch_count = 1 then diffdate_ICI_lag1 = '.';
						diffdate_ICI_lag2 = lag(diffdate_ICI_lag1);
							if ICI_switch_count <3 then diffdate_ICI_lag2 = '.';
						run; 

							proc print data = mult_ICI_switchname_2 (obs = 50); 
							run; 


						/* Summarize transition patterns among those who switched twice+ */ 
						data mult_ici_switchname_2_1;
						set mult_ici_switchname_2;
						where ICI_switch_count = 2;
						ICItransition2 =  catx('->', ICI_name_lag2, ICI_name_lag1, ICI_name);
						diffdates2 = catx('->', diffdate_ICI_lag1, diffdate_ICI);
						run; 

							proc print data = mult_ici_switchname_2_1 (obs = 50); 
							run; 

						proc freq data = mult_ici_switchname_2_1;
						table ICItransition2 diffdates2; 
						run; 

				

						/* Summarize transition patterns among those who switched thrice+ */ 
						data mult_ici_switchname_2_2;
						set mult_ici_switchname_2;
						where ICI_switch_count = 3;
						ICItransition3 =  catx('->', ICI_name_lag3, ICI_name_lag2, ICI_name_lag1, ICI_name);
						diffdates3 = catx('->', diffdate_ICI_lag2, diffdate_ICI_lag1, diffdate_ICI);
						run; 

						proc freq data = mult_ici_switchname_2_2;
						table ICItransition3 diffdates3; 
						run; 

							/* 88% are alternating ipi/nivo */




					/* No. of unique patient ID by transition type */ 

					data mult_ICI_switchname_2;
					set mult_ICI_switchname_2;
					if ICI_switch_count = 2 then secondswitch = 1; 
					run; 

					proc sql; 
					create table two_transition_patient_count as
					select transition2,
					count(distinct patient_id) as n_transition_patient
					from mult_ICI_switchname_2
					group by transition2;
					quit; 

						/* View */ 
						proc print data = two_transition_patient_count; 
						run; 

					



				/* Table of # of ICI transitions among ICI exposed */ 
				data mult_ICI_first;
				set seer.mult_ICI;
				by patient_id;
				if first.patient_id then first = 1;
				run; 

				data mult_ICI_first;
				set mult_ICI_first;
				where first = 1; 
				run; 

				proc freq data = mult_ICI_first;
				table ICI_switch_total;
				run; 
				
				/* 
				ICI_switch_total Frequency Percent CumulativeFrequency CumulativePercent 
				0 16023 94.05 16023 94.05 
				1 683 4.01 16706 98.06 
				2 84 0.49 16790 98.55 
				3 83 0.49 16873 99.04 
				4 28 0.16 16901 99.20 
				5 52 0.31 16953 99.51 
				6 11 0.06 16964 99.57 
				7 42 0.25 17006 99.82 
				8 16 0.09 17022 99.91 
				10 4 0.02 17026 99.94 
				11 2 0.01 17028 99.95 
				12 2 0.01 17030 99.96 
				13 2 0.01 17032 99.97 
				14 2 0.01 17034 99.98 
				15 1 0.01 17035 99.99 
				19 2 0.01 17037 100.00 
				Frequency Missing = 2564 

			*/






/* Step 4. Add exposure classification to lung ICI patient list, using patient lists generated in Steps 2 and 3 */ 


	/* Step 4a. Classify individuals who got ICI alone (not in combination with chemotherapy)

				Other lists to reference are already intact: 
				- Combination Chemo/ICI users
				- Combination ICI users (either with or without chemo)
				These lists will be used to place individuals into category 1, 2, 3, or 4 using PROC SQL */ 


	/* Combine patient lists where patient was getting ICI without simultaneous chemo */ 
	data seer.ici_nocombo_patients;
	set seer.ICI_only seer.chemo_to_ICI seer.ICI_to_chemo seer.ICI_chemo_nocombo1; 
	run; 

		proc freq data = seer.ici_nocombo_patients nlevels;
		table patient_id /noprint; 
		run;

		/* 15497 patients */ 


	/* 4b. Add indicator variable for membership in exposure category 1, 2, 3, or 4 */ 

		proc sort data = seer.lung_primary_incident_65_tx_12; 
		by patient_id; 
		run; 

		proc sort data = seer.ici_nocombo_patients; 
		by patient_id; 
		run; 

		proc sort data = seer.ICI_chemo_combo_first1_3; 
		by patient_id; 
		run; 

		proc sort data = seer.mult_ICI_sameday3; 
		by patient_id;
		run; 


		/* ICI only flag */ 
		data lung_exp1; 
		merge seer.lung_primary_incident_65_tx_12 (in = a) seer.ici_nocombo_patients (keep = patient_id chemo_count in = b);
		by patient_id;
		if a;
		ici_only = b; 
		run;

		/* ICI/chemo combo flag */ 
		data lung_exp2; 
		merge lung_exp1 (in = a) seer.ICI_chemo_combo_first1_3 (keep = patient_id chemo_count in = b);
		by patient_id;
		if a;
		ici_chemo_combo = b; 
		run;

		/* Multiple ICI flag */ 
		data lung_exp3; 
		merge lung_exp2 (in = a) seer.mult_ICI_sameday3 (keep = patient_id chemo_count in = b);
		by patient_id;
		if a;
		mult_ici = b; 
		run;

			proc print data = seer.mult_ICI_sameday3; 
			run; 


		/* Create single column with exposure arm designation */ 
		data seer.lung_exp; 
		set lung_exp3; 
		if ici_only = 1 & mult_ici = 0 then exposure_arm = 1; 
		else if ici_only = 1 & mult_ici = 1 then exposure_arm = 2;
		else if ici_chemo_combo = 1 & mult_ici = 0 then exposure_arm = 3; 
		else if ici_chemo_combo = 1 & mult_ici = 1 then exposure_arm = 4; 
		run; 

		proc freq data = seer.lung_exp;
		table exposure_arm; 
		run; 

		/* Number of chemo doses received prior to or on date of ICI index exposure */ 
		proc freq data = seer.lung_exp;
		table exposure_arm*chemo_count; 
		run; 

		/* Most patients had at least one dose of chemo prior to or on date of ICI index- including those on combo therapy, but many others as well */ 

			/*

		exposure_arm Frequency Percent CumulativeFrequency CumulativePercent 
			1 15208 77.59 15208 77.59 
			2 289 1.47 15497 79.06 
			3 4102 20.93 19599 99.99 
			4 2 0.01 19601 100.00 

		*/

		/* There are only 2 patients in the chemo/multiple ICI group; exclude from analysis or fold into group 3? */

		proc print data = seer.lung_exp (obs = 50); 
		run; 


		/* Distribution of index dates by arm */ 
		ods graphics on;
		proc univariate data = seer.lung_exp noprint;
		class exposure_arm;
		Title 'Distribution of Index Date of ICI by Arm';
			histogram ici_index_dt;
		run; 
		ods graphics off;




*******************************************************************************
	/* Add "index" ICI exposure regimen to table */ 
*******************************************************************************

	 *For exposure arm 1 (ICI): 		use column "ICI_name" from seer.ici_index
		  exposure arm 2 (ICI/ICI): 	in addition to ICI_name above: use column "transition_drugs" from seer.mult_ICI_sameday3 
		  exposure arm 3 (ICI/Chemo): 	in addition to ICI_name above: use column "transition_drugs" from seer.ICI_chemo_combo_first1_3
		  exposure arm 4 (ICI/ICI/Chemo): N/A;

/* Describing molecule by tx arm */ 
	/* Need list of first ICI received (for ICI only group and those who got complex management) */ 

		data seer.ici_index; 
		set mult_therapy10; 
		where ici_indicator = 1 & daysinceindex = 0; 
		run; 

		proc sort data = seer.ici_index; 
		by patient_id; 
		run; 

		data seer.ici_index; 
		set seer.ici_index; 
		by patient_id; 
		if first.patient_id then first =1; 
		run; 

		data seer.ici_index; 
		set seer.ici_index; 
		where first = 1; 
		run; 


	/* Next, need components of chemo/ICI regimens- can obtain from existing data tables : */ 
		proc sql;
		create table chemo_ICI_combo as
		select * 
		from multiple_transition
		where patient_id in (select patient_id from seer.ICI_chemo_combo_first1_3);
		quit;

			proc sort data = chemo_ICI_combo; 
			by patient_id tx_date; 
			run; 

		data chemo_ICI_combo; 
		set chemo_ICI_combo; 
		by patient_id;
		if tx_date < ici_index_dt then delete; 
		run; 

			proc sort data = chemo_ICI_combo; 
			by patient_id tx_date; 
			run; 

		data chemo_ICI_combo; 
		set chemo_ICI_combo; 
		by patient_id;
		if first.patient_id then first =1;
			else first = 0; 
		if first ne 1 and different_drug ne 1 then delete;
		if first.patient_id then n = 1; 
		else if not first.patient_id then n+1;
		run;

			proc freq data = chemo_ICI_combo nlevels; 
			table patient_id /noprint; 
			run; 

			proc freq data = chemo_ICI_combo; 
			table n; 
			run; 

			proc freq data = chemo_ICI_combo; 
			table first; 
			run; 

		data chemo_ICI_combo; 
		set chemo_ICI_combo;
		by patient_id; 
		lag_drug = lag(drug_name); 
		lag2_drug = lag(lag_drug); 
		chemo_ICI_regimen = catx("->", lag2_drug, lag_drug, drug_name);
		chemo_ICI_regimen1 = catx("->", lag_drug, drug_name);
		run; 

			proc freq data = chemo_ICI_combo nlevels; 
			table patient_id /noprint; 
			run; 

			proc freq data = chemo_ICI_combo; 
			table n; 
			run; 

		data chemo_ICI_combo1; 
		length chemo_ICI_regimen2$ 50; 
		set chemo_ICI_combo; 
		where n in(1,2,3); 
		if chemo_ICI_regimen in ('ATEZOLIZUMAB->CARBOPLATIN->ATEZOLIZUMAB', 'ATEZOLIZUMAB->CARBOPLATIN->ETOPOSIDE',
								'ATEZOLIZUMAB->CARBOPLATIN->GEMCITABINE', 'ATEZOLIZUMAB->CARBOPLATIN->PACLITAXEL',
								'ATEZOLIZUMAB->CARBOPLATIN->PEMETREXED', 'ATEZOLIZUMAB->ETOPOSIDE->CARBOPLATIN',
								'ATEZOLIZUMAB->PACLITAXEL->CARBOPLATIN', 'ATEZOLIZUMAB->PEMETREXED->CARBOPLATIN',
								'ATEZOLIZUMAB->PEMETREXED->ATEZOLIZUMAB')
								then chemo_ici_regimen2 = 'ATEZOLIZUMAB & CARBOPLATIN+';
			else if chemo_ICI_regimen in ('ATEZOLIZUMAB->ETOPOSIDE->ATEZOLIZUMAB', 'ATEZOLIZUMAB->PACLITAXEL->ATEZOLIZUMAB', 
									  'ATEZOLIZUMAB->PEMBROLIZUMAB->PEMETREXED')
								then chemo_ici_regimen2 = 'ATEZOLIZUMAB & CHEMO (OTHER)';
			else if chemo_ICI_regimen in ('DURVALUMAB->CARBOPLATIN->ETOPOSIDE', 'DURVALUMAB->PEMBROLIZUMAB->CARBOPLATIN',
									  'DURVALUMAB->CARBOPLATIN->DURVALUMAB', 'DURVALUMAB->CARBOPLATIN->PEMETREXED',
									  'DURVALUMAB->CARBOPLATIN->PACLITAXEL', 'DURVALUMAB->PEMBROLIZUMAB->PACLITAXEL',
									  'DURVALUMAB->PACLITAXEL->CARBOPLATIN') 
								then chemo_ICI_regimen2 = 'DURVALUMAB & CARBOPLATIN+';
			else if chemo_ICI_regimen in ('IPILIMUMAB->PACLITAXEL->IPILIMUMAB', 'IPILIMUMAB->VINORELBINE->IPILIMUMAB') 
								then chemo_ICI_regimen2 = 'IPILIMUMAB & CHEMO (VAR.)';
			else if chemo_ICI_regimen in ('NIVOLUMAB->CARBOPLATIN->ETOPOSIDE', 'NIVOLUMAB->CARBOPLATIN->GEMCITABINE', 
									  'NIVOLUMAB->CARBOPLATIN->NIVOLUMAB', 'NIVOLUMAB->CARBOPLATIN->PACLITAXEL',
									  'NIVOLUMAB->CARBOPLATIN->PEMETREXED', 'NIVOLUMAB->PEMBROLIZUMAB->CARBOPLATIN', 
									  'NIVOLUMAB->PEMETREXED->NIVOLUMAB','NIVOLUMAB->GEMCITABINE->NIVOLUMAB',
									  'NIVOLUMAB->DOCETAXEL->CARBOPLATIN', 'NIVOLUMAB->GEMCITABINE->PACLITAXEL',
									  'NIVOLUMAB->PEMBROLIZUMAB->PEMETREXED', 'NIVOLUMAB->DOCETAXEL->GEMCITABINE',
									  'NIVOLUMAB->PEMETREXED->NIVOLUMAB', 'NIVOLUMAB->DOCETAXEL->NIVOLUMAB',
									  'NIVOLUMAB->GEMCITABINE->NIVOLUMAB', 'NIVOLUMAB->PACLITAXEL->CARBOPLATIN',
								      'NIVOLUMAB->CARBOPLATIN->DOCETAXEL', 'NIVOLUMAB->PACLITAXEL->GEMCITABINE') 
								then chemo_ICI_regimen2 = 'NIVOLUMAB & CARBOPLATIN+';
			else if chemo_ICI_regimen in ('NIVOLUMAB->PACLITAXEL->NIVOLUMAB')
								then chemo_ICI_regimen2 = 'NIVOLUMAB & CHEMO (VAR.)'; 
			else if chemo_ICI_regimen in ('NIVOLUMAB->PEMETREXED->NIVOLUMAB')
								then chemo_ICI_regimen2 = 'NIVOLUMAB & PEMETREXED'; 
			else if chemo_ICI_regimen in ('PEMBROLIZUMAB->CARBOPLATIN->DOCETAXEL', 'PEMBROLIZUMAB->CARBOPLATIN->ETOPOSIDE', 
									  'PEMBROLIZUMAB->CARBOPLATIN->GEMCITABINE', 'PEMBROLIZUMAB->CARBOPLATIN->PEMBROLIZUMAB', 
									  'PEMBROLIZUMAB->DOCETAXEL->CARBOPLATIN', 'PEMBROLIZUMAB->CARBOPLATIN->PACLITAXEL',
   									  'PEMBROLIZUMAB->CARBOPLATIN->PEMETREXED', 'PEMBROLIZUMAB->ETOPOSIDE->CARBOPLATIN',
									  'PEMBROLIZUMAB->GEMCITABINE->CARBOPLATIN', 'PEMBROLIZUMAB->PACLITAXEL->CARBOPLATIN',
									  'PEMBROLIZUMAB->PEMETREXED->CARBOPLATIN')
								then chemo_ICI_regimen2 = 'PEMBROLIZUMAB & CARBOPLATIN+';
			else if chemo_ICI_regimen in ('PEMBROLIZUMAB->DOCETAXEL->PEMBROLIZUMAB', 'PEMBROLIZUMAB->GEMCITABINE->PEMETREXED',
									  'PEMBROLIZUMAB->PACLITAXEL->PEMBROLIZUMAB', 'PEMBROLIZUMAB->PEMETREXED->PEMBROLIZUMAB',
									  'PEMBROLIZUMAB->VINORELBINE->PEMBROLIZUMAB', 'PEMBROLIZUMAB->GEMCITABINE->PEMBROLIZUMAB')
								then chemo_ICI_regimen2 = 'PEMBROLIZUMAB & CHEMO (OTHER)';
		run; 


			/* Different ways of depicting regimen */ 

			proc freq data = chemo_ICI_combo1; 
			where n = 3; /* Not available for all 4104 patients */ 
			table chemo_ICI_regimen chemo_ICI_regimen2; /* 3 molecules (simplified second) */ 
			run; 

			proc freq data = chemo_ICI_combo1; 
			where n = 2; /* 2 molecules; available for all patients */
			table chemo_ICI_regimen1; 
			run; 

			/* 19601 observations */ 

		/* Merge in index regimen info */ 
			proc sort data = seer.ici_index; 
			by patient_id; 
			run; 

			proc sort data = seer.mult_ICI_sameday3; 
			by patient_id; 
			run; 

			proc sort data = seer.ICI_chemo_combo_first1_3; 
			by patient_id; 
			run; 

			proc sort data = seer.lung_exp; 
			by patient_id; 
			run; 

		/* Index ICI */ 
		data lung_exp_ind1; 
		merge seer.lung_exp (in = a) seer.ici_index (keep = patient_id ICI_name in = b);
		by patient_id;
		if a;
		run;

		/* ICI/chemo combo components */ 
		data chemo_ICI_combo2; 
		set chemo_ICI_combo1; 
		where n = 2; 
		run; 

		data lung_exp_ind2; 
		merge lung_exp_ind1 (in = a) chemo_ICI_combo2 (keep = patient_id chemo_ICI_regimen1 in = b);
		by patient_id;
		if a;
		ici_chemo_combo = b; 
		run;

		data chemo_ICI_combo3; 
		set chemo_ICI_combo1; 
		where n = 3; 
		run; 

		data lung_exp_ind3; 
		merge lung_exp_ind2 (in = a) chemo_ICI_combo3 (keep = patient_id chemo_ICI_regimen2 in = b);
		by patient_id;
		if a;
		ici_chemo_combo1 = b; 
		run;


		/* Multiple ICI regimen info */ 
		data lung_exp_ind4; 
		merge lung_exp_ind3 (in = a) seer.mult_ICI_sameday3 (keep = patient_id transition_drugs_ICI in = b);
		by patient_id;
		if a;
		mult_ici = b; 
		run;

		/* Merge index regimen into a single column */ 
		data seer.lung_exp_molecules; 
		length index_regimen$ 30;
		set lung_exp_ind4; 
		index_regimen = ICI_name; 
		if chemo_ICI_regimen2 ne '' then index_regimen = chemo_ICI_regimen2;  /* substitute in chemo/ICI molecules if relevant */ 
				else if chemo_ICI_regimen2 ='' & chemo_ICI_regimen1 ne '' then index_regimen = chemo_ICI_regimen1;
				if index_regimen = 'ATEZOLIZUMAB->CARBOPLATIN' then index_regimen = 'ATEZOLIZUMAB & CARBOPLATIN+';
				else if index_regimen in('ATEZOLIZUMAB->DOCETAXEL', 'ATEZOLIZUMAB->ETOPOSIDE', 'ATEZOLIZUMAB->PACLITAXEL', 'ATEZOLIZUMAB->PEMBROLIZUMAB', 'ATEZOLIZUMAB->PEMETREXED') then index_regimen = 'ATEZOLIZUMAB & CHEMO (OTHER)';
				else if index_regimen = 'IPILIMUMAB->DOCETAXEL' then index_regimen = 'IPILIMUMAB & CHEMO (VAR.)';
				else if index_regimen in ('NIVOLUMAB->GEMCITABINE ', 'NIVOLUMAB->PACLITAXEL', 'NIVOLUMAB->PEMETREXED') then index_regimen = 'NIVOLUMAB & CHEMO (VAR.)';
				else if index_regimen = 'PEMBROLIZUMAB->CARBOPLATIN' then index_regimen = 'PEMBROLIZUMAB & CARBOPLATIN+'; 
				else if index_regimen in('PEMBROLIZUMAB->DOCETAXEL', 'PEMBROLIZUMAB->PACLITAXEL', 'PEMBROLIZUMAB->PEMETREXED', 'PEMBROLIZUMAB->VINORELBINE') then index_regimen = 'PEMBROLIZUMAB & CHEMO (OTHER)';
		if transition_drugs_ICI ne '' then index_regimen = transition_drugs_ICI; /* substitute in ICI/ICI molecules if relevant */
			if index_regimen = 'NIVOLUMAB->IPILIMUMAB' then index_regimen = 'IPILIMUMAB->NIVOLUMAB'; /* standardize label for combo. regimen */
		chemo_count1 = chemo_count;
		if exposure_arm = '3' then chemo_count1 = chemo_count -1; 
		if chemo_count1 > 0 then firstline = 0 ; 
		else firstline = 1; 
		days_dx_to_tx = ici_index_dt - date_dx_format; 
		run; 



******************************************************
			/* Summary */ 
******************************************************;

		/* NSCLC / SCLC by exposure arm */ 
		proc freq data = seer.lung_exp_molecules; 
		table NSCLC*exposure_arm; 
		run; 

		/* Regimen by exposure arm */ 
		proc freq data = seer.lung_exp_molecules; 
		where exposure_arm = 1; 
		table index_regimen; 
		run; 

		proc freq data = seer.lung_exp_molecules; 
		where exposure_arm = 2; 
		table index_regimen; 
		run; 

		proc freq data = seer.lung_exp_molecules; 
		where exposure_arm = 3; 
		table index_regimen; 
		run; 

		/* Regimen by exposure arm and stage at diagnosis */ 
		proc freq data = seer.lung_exp_molecules; 
		where exposure_arm = 1; 
		table index_regimen*stage; 
		run; 

		proc freq data = seer.lung_exp_molecules; 
		where exposure_arm = 2; 
		table index_regimen*stage; 
		run; 

		proc freq data = seer.lung_exp_molecules; 
		where exposure_arm = 3; 
		table index_regimen*stage; 
		run; 

		/* Dx to treatment gap by regimen and stage at diagnosis */ 
		proc means data = seer.lung_exp_molecules n mean std p25 p50 p75 min max; 
		where exposure_arm = 1;
		class index_regimen stage; 
		var days_dx_to_tx; 
		run; 

		proc means data = seer.lung_exp_molecules n mean std p25 p50 p75 min max; 
		where exposure_arm = 2;
		class index_regimen stage; 
		var days_dx_to_tx; 
		run; 

		proc means data = seer.lung_exp_molecules n mean std p25 p50 p75 min max; 
		where exposure_arm = 3;
		class index_regimen stage; 
		var days_dx_to_tx; 
		run; 



		/* Regimen by exposure arm and first vs. second-line */ 
		proc freq data = seer.lung_exp_molecules; 
		where exposure_arm = 1; 
		table index_regimen*firstline; 
		run; 

		proc freq data = seer.lung_exp_molecules; 
		where exposure_arm = 2; 
		table index_regimen*firstline; 
		run; 

		proc freq data = seer.lung_exp_molecules; 
		where exposure_arm = 3; 
		table index_regimen*firstline; 
		run; 

		/* Days from dx to tx */ 
		proc means data = seer.lung_exp_molecules n mean std p25 p50 p75 min max; 
		where exposure_arm = 1;
		class index_regimen firstline; 
		var days_dx_to_tx; 
		run; 

		proc means data = seer.lung_exp_molecules n mean std p25 p50 p75 min max; 
		where exposure_arm = 2;
		class index_regimen firstline; 
		var days_dx_to_tx; 
		run; 

		proc means data = seer.lung_exp_molecules n mean std p25 p50 p75 min max; 
		where exposure_arm = 3;
		class index_regimen firstline; 
		var days_dx_to_tx; 
		run; 


		/* Index date by regimen */ 
		/* Single ICI */ 
		proc univariate data = seer.lung_exp_molecules noprint; 
		where exposure_arm = 1; 
		histogram ici_index_dt; 
		class index_regimen; 
		run;

		proc sgplot data = seer.lung_exp_molecules; 
		where exposure_arm = 1; 
		histogram ici_index_dt / group = index_regimen transparency = 0.5; 
		density ici_index_dt / type=kernel group=index_regimen; 
		run;

		/* ICI + ICI */

		proc univariate data = seer.lung_exp_molecules noprint; 
		where exposure_arm = 2; 
		histogram ici_index_dt; 
		class index_regimen; 
		run;

		proc sgplot data = seer.lung_exp_molecules; 
		where exposure_arm = 2; 
		histogram ici_index_dt / group = index_regimen transparency = 0.5; 
		density sw / type=kernel group=exposure_arm; 
		run;

		/* ICI + CHEMO */

		proc univariate data = seer.lung_exp_molecules noprint; 
		where exposure_arm = 3; 
		histogram ici_index_dt; 
		class index_regimen; 
		run;

		proc sgplot data = seer.lung_exp_molecules; 
		where exposure_arm = 3; 
		histogram ici_index_dt / group = index_regimen transparency = 0.5; 
		density sw / type=kernel group=exposure_arm; 
		run;

		/* Regimen by prior surgery status */ 
		proc format; 
		value $Surgery '00' = 'None'
						'10'-'19' = 'Tumor destruction'
						'20'-'80' = 'Resection' 
						'90' = 'NOS'
						'98'-'99'= 'Unknown or special';
						run; 

					data seer.lung_exp_molecules; 
					set seer.lung_exp_molecules; 
					format RX_SUMM_SURG_PRIM_SITE_1998 Surgery.; 
					run; 

		proc freq data = seer.lung_exp_molecules; 
		where exposure_arm = 1; 
		table index_regimen*RX_SUMM_SURG_PRIM_SITE_1998; 
		run; 

		proc freq data = seer.lung_exp_molecules; 
		where exposure_arm = 2; 
		table index_regimen*RX_SUMM_SURG_PRIM_SITE_1998; 
		run; 

		proc freq data = seer.lung_exp_molecules; 
		where exposure_arm = 3; 
		table index_regimen*RX_SUMM_SURG_PRIM_SITE_1998; 
		run; 

		/* Regimen by prior radiation status */ 
		proc format; 
		value $Radiation '0' = 'None/Unknown'
						 '1' - '6' = 'Radiation (any)'
						 '7' = 'Refused'
						 '8' = 'Recommended/unknown';
						 run; 

				
					data seer.lung_exp_molecules; 
					set seer.lung_exp_molecules; 
					format radiation_recode Radiation.; 
					run; 
		
		proc freq data = seer.lung_exp_molecules; 
		where exposure_arm = 1; 
		table index_regimen*radiation_recode; 
		run; 

		proc freq data = seer.lung_exp_molecules; 
		where exposure_arm = 2; 
		table index_regimen*radiation_recode; 
		run; 

		proc freq data = seer.lung_exp_molecules; 
		where exposure_arm = 3; 
		table index_regimen*radiation_recode; 
		run; 


		/* Organize chemo, radiation, surgery status by regimen */ 

		data seer.lung_exp_molecules; 
		set seer.lung_exp_molecules; 
		if RX_SUMM_SURG_PRIM_SITE_1998 ne '00' & RX_SUMM_SURG_PRIM_SITE_1998 ne'' then surgery_binary = 1; 
			else if RX_SUMM_SURG_PRIM_SITE_1998 in('00') then surgery_binary = 0; 
			else if RX_SUMM_SURG_PRIM_SITE_1998 = '' then surgery_binary = '';
		if radiation_recode in (1:6) then radiation_binary = 1;
			else if radiation_recode not in (1:6) and radiation_recode ne '' then radiation_binary = 0; 
			else if radiation_recode = '' then radiation_binary = '';
		run;

		data seer.lung_exp_molecules; 
		length prior_tx$ 30;
		length prior_tx1$ 30; 
		set seer.lung_exp_molecules; 
		if firstline = 0 then chemo = 1; 
		else if firstline = 1 then chemo = 0; 
		if chemo = 0 & surgery_binary = 0 & radiation_binary = 0 then prior_tx = 'None';
		else if  chemo = 1 & surgery_binary = 0 & radiation_binary = 0 then prior_tx = 'Chemo';
		else if  chemo = 0 & surgery_binary = 1 & radiation_binary = 0 then prior_tx = 'Surg';
		else if  chemo = 0 & surgery_binary = 0 & radiation_binary = 1 then prior_tx = 'Rad';
		else if  chemo = 1 & surgery_binary = 1 & radiation_binary = 0 then prior_tx = 'Chemo+Surg';
		else if  chemo = 1 & surgery_binary = 0 & radiation_binary = 1 then prior_tx = 'Chemo+Rad';
		else if  chemo = 0 & surgery_binary = 1 & radiation_binary = 1 then prior_tx = 'Surg+Rad';
		else if  chemo = 1 & surgery_binary = 1 & radiation_binary = 1 then prior_tx = 'Chemo+Surg+Rad';
		if chemo = 0 & surgery_binary = 0 & radiation_binary = 0 then prior_tx1 = 'None';
		else if  chemo = 1 & surgery_binary = 0 & radiation_binary = 0 then prior_tx1 = 'Chemo';
		else if  chemo = 0 & surgery_binary = 1 & radiation_binary = 0 then prior_tx1 = 'Surg';
		else if  chemo = 0 & surgery_binary = 0 & radiation_binary = 1 then prior_tx1 = 'Rad';
		else if  chemo = 1 & surgery_binary = 1 & radiation_binary = 0 then prior_tx1 = 'Chemo+Surg';
		else if  chemo = 1 & surgery_binary = 0 & radiation_binary = 1 then prior_tx1 = 'Chemo+Rad';
		else if  chemo = 0 & surgery_binary = 1 & radiation_binary = 1 then prior_tx1 = 'Surg+Rad';
		else if  chemo = 1 & surgery_binary = 1 & radiation_binary = 1 then prior_tx1 = 'Chemo+Surg+Rad';
		else if  chemo = 0 & surgery_binary = 0 & radiation_binary = . then prior_tx1 = 'None (Rad. missing)';
		else if  chemo = 1 & surgery_binary = 0 & radiation_binary = . then prior_tx1 = 'Chemo (Rad. missing)';
		else if  chemo = 0 & surgery_binary = 1 & radiation_binary = . then prior_tx1 = 'Surg (Rad. missing)';
		else if  chemo = 1 & surgery_binary = 1 & radiation_binary = . then prior_tx1 = 'Chemo+Surg (Rad. missing)';
		else if  chemo = 0 & surgery_binary = . & radiation_binary = 0 then prior_tx1 = 'None (Surg. missing)';
		else if  chemo = 1 & surgery_binary = . & radiation_binary = 0 then prior_tx1 = 'Chemo (Surg. missing)';
		else if  chemo = 0 & surgery_binary = . & radiation_binary = 1 then prior_tx1 = 'Rad (Surg. missing)';
		else if  chemo = 1 & surgery_binary = . & radiation_binary = 1 then prior_tx1 = 'Chemo+Rad (Surg. missing)';
		else if  chemo = 0 & surgery_binary = . & radiation_binary = . then prior_tx1 = 'None (Surg.+Rad. missing)';
		else if  chemo = 1 & surgery_binary = . & radiation_binary = . then prior_tx1 = 'Chemo (Surg.+Rad. missing)';
		run; 

		proc freq data = seer.lung_exp_molecules;
		where exposure_arm = 1; 
		table index_regimen*prior_tx index_regimen*prior_tx1; 
		run; 

		proc means data = seer.lung_exp_molecules n mean std p25 p50 p75 min max; 
		where exposure_arm = 1; 
		class index_regimen prior_tx; 
		var days_dx_to_tx; 
		run; 

		proc freq data = seer.lung_exp_molecules;
		where exposure_arm = 2; 
		table index_regimen*prior_tx index_regimen*prior_tx1; 
		run;  

		proc means data = seer.lung_exp_molecules n mean std p25 p50 p75 min max; 
		where exposure_arm = 2; 
		class index_regimen prior_tx; 
		var days_dx_to_tx; 
		run; 

		proc freq data = seer.lung_exp_molecules;
		where exposure_arm = 3; 
		table index_regimen*prior_tx index_regimen*prior_tx1; 
		run; 

		proc means data = seer.lung_exp_molecules n mean std p25 p50 p75 min max; 
		where exposure_arm = 3; 
		class index_regimen prior_tx; 
		var days_dx_to_tx; 
		run; 
 




dm 'odsresults; clear;';







 












