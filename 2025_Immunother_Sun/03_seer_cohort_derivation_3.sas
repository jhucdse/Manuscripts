*******************************************************************************;
* Program name      :	xx_cohort_derivation_3
* Author            :	Jamie Heyward
* Date created      :	June 1, 2023
* Study             : 	
* Purpose           :	Assess 7y-eligible patients
* Inputs            :	
* Program completed : 	
* Updated by        : Xinyi Sun, 10-01-2024
*********************************************************************************;

LIBNAME seer 'S:\Pharmacoepi0216\Thesis';
		

/* Add the monthly Medicare Part A/B, Part D, and HMO enrollment status to the SEER Lung Cancer File */

	/* Concatenate the monthly Medicare Part A/B, Part D, and HMO enrollment status for each patient from the MBSFABCD file */
	
		/*		proc contents data = seer.mbsfabcd; */
		/*		run; */

		data enrollment_months;
		set seer.mbsfabcd (keep = patient_id BENE_ENROLLMT_REF_YR MDCR_STATUS_CODE_01-MDCR_STATUS_CODE_12 HMO_IND_01-HMO_IND_12 PTD_CNTRCT_ID_01-PTD_CNTRCT_ID_12);
		run; 

		proc sql;
		create table enrollment_months1 as 
		select *
		from enrollment_months
		where patient_id in(select patient_id from seer.lung_primary_incident_65_tx1); 
		quit; 

				proc print data = enrollment_months1 (obs = 50); 
				run; 

		proc sort data = enrollment_months1 out = enrollment_months1s;
		by patient_id bene_enrollmt_ref_yr; 
		run; 

/*			proc print data = enrollment_months1s (obs = 50); */
/*			run; */


	/* Convert from long to wide so there is one record per patient */ 

	/* For Part A/B Enrollment */ 

				data enrollment_ab; 
				set enrollment_months1s (keep = patient_id bene_enrollmt_ref_yr MDCR_STATUS_CODE_01-MDCR_STATUS_CODE_12); 
				run; 


					/* Need to tranpose data from long to wide, by year... */ 

					/* 2012 */ 
					data enrollment_ab_2012; 
					set enrollment_ab; 
					where bene_enrollmt_ref_yr = 2012;
					run; 

					proc transpose data = enrollment_ab_2012 out = enrollment_ab_long_2012 prefix = twelve;
					by patient_id; 
					var MDCR_STATUS_CODE_01-MDCR_STATUS_CODE_12; 
					run;

						
					/* 2013 */ 
					data enrollment_ab_2013; 
					set enrollment_ab; 
					where bene_enrollmt_ref_yr = 2013;
					run; 

					proc transpose data = enrollment_ab_2013 out = enrollment_ab_long_2013 prefix = thirteen;
					by patient_id; 
					var MDCR_STATUS_CODE_01-MDCR_STATUS_CODE_12; 
					run;

					proc print data = enrollment_ab_long_2013 (obs = 10);
					run; 

					
					/* 2014 */ 
					data enrollment_ab_2014; 
					set enrollment_ab; 
					where bene_enrollmt_ref_yr = 2014;
					run; 

					proc transpose data = enrollment_ab_2014 out = enrollment_ab_long_2014 prefix = fourteen;
					by patient_id; 
					var MDCR_STATUS_CODE_01-MDCR_STATUS_CODE_12; 
					run;

					
					/* 2015 */ 
					data enrollment_ab_2015; 
					set enrollment_ab; 
					where bene_enrollmt_ref_yr = 2015;
					run; 

					proc transpose data = enrollment_ab_2015 out = enrollment_ab_long_2015 prefix = fifteen;
					by patient_id; 
					var MDCR_STATUS_CODE_01-MDCR_STATUS_CODE_12; 
					run;

						proc print data = enrollment_ab_long_2015 (obs = 10); 
						run; 


					/* 2016 */ 
					data enrollment_ab_2016; 
					set enrollment_ab; 
					where bene_enrollmt_ref_yr = 2016;
					run; 

					proc transpose data = enrollment_ab_2016 out = enrollment_ab_long_2016 prefix = sixteen;
					by patient_id; 
					var MDCR_STATUS_CODE_01-MDCR_STATUS_CODE_12; 
					run;

						proc print data = enrollment_ab_2016_long (obs = 10); 
						run; 


					/* 2017 */ 
					data enrollment_ab_2017; 
					set enrollment_ab; 
					where bene_enrollmt_ref_yr = 2017;
					run; 

					proc transpose data = enrollment_ab_2017 out = enrollment_ab_long_2017 prefix = seventeen;
					by patient_id; 
					var MDCR_STATUS_CODE_01-MDCR_STATUS_CODE_12; 
					run;

						
					/* 2018 */ 
					data enrollment_ab_2018; 
					set enrollment_ab; 
					where bene_enrollmt_ref_yr = 2018;
					run; 

					proc transpose data = enrollment_ab_2018 out = enrollment_ab_long_2018 prefix = eighteen;
					by patient_id; 
					var MDCR_STATUS_CODE_01-MDCR_STATUS_CODE_12; 
					run;

						
					/* 2019 */ 
					data enrollment_ab_2019; 
					set enrollment_ab; 
					where bene_enrollmt_ref_yr = 2019;
					run; 

					proc transpose data = enrollment_ab_2019 out = enrollment_ab_long_2019 prefix = nineteen;
					by patient_id; 
					var MDCR_STATUS_CODE_01-MDCR_STATUS_CODE_12; 
					run;

						
					/* 2020 */ 
					data enrollment_ab_2020; 
					set enrollment_ab; 
					where bene_enrollmt_ref_yr = 2020;
					run; 

					proc transpose data = enrollment_ab_2020 out = enrollment_ab_long_2020 prefix = twenty;
					by patient_id; 
					var MDCR_STATUS_CODE_01-MDCR_STATUS_CODE_12; 
					run;


					/* Merge */ 
					
					proc sort data = enrollment_ab_long_2012; 
					by patient_id; 
					run; 

					proc sort data = enrollment_ab_long_2013; 
					by patient_id; 
					run; 

					proc sort data = enrollment_ab_long_2014; 
					by patient_id; 
					run; 

					proc sort data = enrollment_ab_long_2015; 
					by patient_id; 
					run; 

					proc sort data = enrollment_ab_long_2016; 
					by patient_id; 
					run; 

					proc sort data = enrollment_ab_long_2017; 
					by patient_id; 
					run; 

					proc sort data = enrollment_ab_long_2018; 
					by patient_id; 
					run; 

					proc sort data = enrollment_ab_long_2019; 
					by patient_id; 
					run; 

					proc sort data = enrollment_ab_long_2020; 
					by patient_id; 
					run; 



					data enrollment_ab_long; 
					merge enrollment_ab_long_2012 - enrollment_ab_long_2020; 
					by patient_id;
					if _NAME_ = 'MDCR_STATUS_CODE_01' then mon = '01'; 
					else if _NAME_ = 'MDCR_STATUS_CODE_02' then mon = '02'; 
					else if _NAME_ = 'MDCR_STATUS_CODE_03' then mon = '03'; 
					else if _NAME_ = 'MDCR_STATUS_CODE_04' then mon = '04'; 
					else if _NAME_ = 'MDCR_STATUS_CODE_05' then mon = '05'; 
					else if _NAME_ = 'MDCR_STATUS_CODE_06' then mon = '06'; 
					else if _NAME_ = 'MDCR_STATUS_CODE_07' then mon = '07'; 
					else if _NAME_ = 'MDCR_STATUS_CODE_08' then mon = '08'; 
					else if _NAME_ = 'MDCR_STATUS_CODE_09' then mon = '09'; 
					else if _NAME_ = 'MDCR_STATUS_CODE_10' then mon = '10'; 
					else if _NAME_ = 'MDCR_STATUS_CODE_11' then mon = '11'; 
					else if _NAME_ = 'MDCR_STATUS_CODE_12' then mon = '12'; 
					run; 

						proc print data = enrollment_ab_long (obs = 50); 
						run; 

						/* Example of someone with no enrollment information in one year (2020) */ 
		/*				proc print data = enrollment_months;*/
		/*				where patient_id = 'lnK2020V1185287';*/
		/*				run; */
					

				/* Now convert long to wide by year */ 

					/* 2012 */ 
					proc transpose data=enrollment_ab_long out=enrollment_ab_wide_2012 prefix = yr12;
				    by patient_id;
				    id mon;
				    var twelve1;
					run;

					proc transpose data=enrollment_ab_long out=enrollment_ab_wide_2013 prefix = yr13;
				    by patient_id;
				    id mon;
				    var thirteen1;
					run;

					proc transpose data=enrollment_ab_long out=enrollment_ab_wide_2014 prefix = yr14;
				    by patient_id;
				    id mon;
				    var fourteen1;
					run;

					proc transpose data=enrollment_ab_long out=enrollment_ab_wide_2015 prefix = yr15;
				    by patient_id;
				    id mon;
				    var fifteen1;
					run;

					proc transpose data=enrollment_ab_long out=enrollment_ab_wide_2016 prefix = yr16;
				    by patient_id;
				    id mon;
				    var sixteen1;
					run;

					proc transpose data=enrollment_ab_long out=enrollment_ab_wide_2017 prefix = yr17;
				    by patient_id;
				    id mon;
				    var seventeen1;
					run;

					proc transpose data=enrollment_ab_long out=enrollment_ab_wide_2018 prefix = yr18;
				    by patient_id;
				    id mon;
				    var eighteen1;
					run;

					proc transpose data=enrollment_ab_long out=enrollment_ab_wide_2019 prefix = yr19;
				    by patient_id;
				    id mon;
				    var nineteen1;
					run;

					proc transpose data=enrollment_ab_long out=enrollment_ab_wide_2020 prefix = yr20;
				    by patient_id;
				    id mon;
				    var twenty1;
					run;


					/* Merge wide formatted yearly enrollment into one table */ 
						
						/* Sort just to be safe */ 

						proc sort data = enrollment_ab_wide_2012;
						by patient_id; 
						run; 

						proc sort data = enrollment_ab_wide_2013;
						by patient_id; 
						run; 

						proc sort data = enrollment_ab_wide_2014;
						by patient_id; 
						run; 

						proc sort data = enrollment_ab_wide_2015;
						by patient_id; 
						run; 

						proc sort data = enrollment_ab_wide_2016;
						by patient_id; 
						run; 

						proc sort data = enrollment_ab_wide_2017;
						by patient_id; 
						run; 

						proc sort data = enrollment_ab_wide_2018;
						by patient_id; 
						run; 

						proc sort data = enrollment_ab_wide_2019;
						by patient_id; 
						run; 

						proc sort data = enrollment_ab_wide_2020;
						by patient_id; 
						run; 



					data enrollment_months_wide; 
					merge enrollment_ab_wide_2012 - enrollment_ab_wide_2020;
					by patient_id;
					run;

							proc print data = enrollment_months_wide (obs = 10); 
							run; 


	/* For HMO Enrollment */ 

				data enrollment_h; 
				set enrollment_months1s (keep = patient_id bene_enrollmt_ref_yr HMO_IND_01-HMO_IND_12); 
				run; 


					/* Need to tranpose data from long to wide, by year... */ 

					/* 2012 */ 
					data enrollment_h_2012; 
					set enrollment_h; 
					where bene_enrollmt_ref_yr = 2012;
					run; 

					proc transpose data = enrollment_h_2012 out = enrollment_h_long_2012 prefix = twelve;
					by patient_id; 
					var HMO_IND_01-HMO_IND_12; 
					run;

						
					/* 2013 */ 
					data enrollment_h_2013; 
					set enrollment_h; 
					where bene_enrollmt_ref_yr = 2013;
					run; 

					proc transpose data = enrollment_h_2013 out = enrollment_h_long_2013 prefix = thirteen;
					by patient_id; 
					var HMO_IND_01-HMO_IND_12; 
					run;

					
					/* 2014 */ 
					data enrollment_h_2014; 
					set enrollment_h; 
					where bene_enrollmt_ref_yr = 2014;
					run; 

					proc transpose data = enrollment_h_2014 out = enrollment_h_long_2014 prefix = fourteen;
					by patient_id; 
					var HMO_IND_01-HMO_IND_12; 
					run;

					
					/* 2015 */ 
					data enrollment_h_2015; 
					set enrollment_h; 
					where bene_enrollmt_ref_yr = 2015;
					run; 

					proc transpose data = enrollment_h_2015 out = enrollment_h_long_2015 prefix = fifteen;
					by patient_id; 
					var HMO_IND_01-HMO_IND_12; 
					run;


					/* 2016 */ 
					data enrollment_h_2016; 
					set enrollment_h; 
					where bene_enrollmt_ref_yr = 2016;
					run; 

					proc transpose data = enrollment_h_2016 out = enrollment_h_long_2016 prefix = sixteen;
					by patient_id; 
					var HMO_IND_01-HMO_IND_12; 
					run;


					/* 2017 */ 
					data enrollment_h_2017; 
					set enrollment_h; 
					where bene_enrollmt_ref_yr = 2017;
					run; 

					proc transpose data = enrollment_h_2017 out = enrollment_h_long_2017 prefix = seventeen;
					by patient_id; 
					var HMO_IND_01-HMO_IND_12; 
					run;

						
					/* 2018 */ 
					data enrollment_h_2018; 
					set enrollment_h; 
					where bene_enrollmt_ref_yr = 2018;
					run; 

					proc transpose data = enrollment_h_2018 out = enrollment_h_long_2018 prefix = eighteen;
					by patient_id; 
					var HMO_IND_01-HMO_IND_12; 
					run;

						
					/* 2019 */ 
					data enrollment_h_2019; 
					set enrollment_h; 
					where bene_enrollmt_ref_yr = 2019;
					run; 

					proc transpose data = enrollment_h_2019 out = enrollment_h_long_2019 prefix = nineteen;
					by patient_id; 
					var HMO_IND_01-HMO_IND_12; 
					run;

						
					/* 2020 */ 
					data enrollment_h_2020; 
					set enrollment_h; 
					where bene_enrollmt_ref_yr = 2020;
					run; 

					proc transpose data = enrollment_h_2020 out = enrollment_h_long_2020 prefix = twenty;
					by patient_id; 
					var HMO_IND_01-HMO_IND_12; 
					run;


					/* Merge */ 
					
					proc sort data = enrollment_h_long_2012; 
					by patient_id; 
					run; 

					proc sort data = enrollment_h_long_2013; 
					by patient_id; 
					run; 

					proc sort data = enrollment_h_long_2014; 
					by patient_id; 
					run; 

					proc sort data = enrollment_h_long_2015; 
					by patient_id; 
					run; 

					proc sort data = enrollment_h_long_2016; 
					by patient_id; 
					run; 

					proc sort data = enrollment_h_long_2017; 
					by patient_id; 
					run; 

					proc sort data = enrollment_h_long_2018; 
					by patient_id; 
					run; 

					proc sort data = enrollment_h_long_2019; 
					by patient_id; 
					run; 

					proc sort data = enrollment_h_long_2020; 
					by patient_id; 
					run; 



					data enrollment_h_long; 
					merge enrollment_h_long_2012 - enrollment_h_long_2020; 
					by patient_id;
					if _NAME_ = 'HMO_IND_01' then mon = '01'; 
					else if _NAME_ = 'HMO_IND_02' then mon = '02'; 
					else if _NAME_ = 'HMO_IND_03' then mon = '03'; 
					else if _NAME_ = 'HMO_IND_04' then mon = '04'; 
					else if _NAME_ = 'HMO_IND_05' then mon = '05'; 
					else if _NAME_ = 'HMO_IND_06' then mon = '06'; 
					else if _NAME_ = 'HMO_IND_07' then mon = '07'; 
					else if _NAME_ = 'HMO_IND_08' then mon = '08'; 
					else if _NAME_ = 'HMO_IND_09' then mon = '09'; 
					else if _NAME_ = 'HMO_IND_10' then mon = '10'; 
					else if _NAME_ = 'HMO_IND_11' then mon = '11'; 
					else if _NAME_ = 'HMO_IND_12' then mon = '12'; 
					run; 

						proc print data = enrollment_h_long (obs = 50); 
						run; 
					

				/* Now convert long to wide by year */ 

					/* 2012 */ 
					proc transpose data=enrollment_h_long out=enrollment_h_wide_2012 prefix = hyr12;
				    by patient_id;
				    id mon;
				    var twelve1;
					run;

					proc transpose data=enrollment_h_long out=enrollment_h_wide_2013 prefix = hyr13;
				    by patient_id;
				    id mon;
				    var thirteen1;
					run;

					proc transpose data=enrollment_h_long out=enrollment_h_wide_2014 prefix = hyr14;
				    by patient_id;
				    id mon;
				    var fourteen1;
					run;

					proc transpose data=enrollment_h_long out=enrollment_h_wide_2015 prefix = hyr15;
				    by patient_id;
				    id mon;
				    var fifteen1;
					run;

					proc transpose data=enrollment_h_long out=enrollment_h_wide_2016 prefix = hyr16;
				    by patient_id;
				    id mon;
				    var sixteen1;
					run;

					proc transpose data=enrollment_h_long out=enrollment_h_wide_2017 prefix = hyr17;
				    by patient_id;
				    id mon;
				    var seventeen1;
					run;

					proc transpose data=enrollment_h_long out=enrollment_h_wide_2018 prefix = hyr18;
				    by patient_id;
				    id mon;
				    var eighteen1;
					run;

					proc transpose data=enrollment_h_long out=enrollment_h_wide_2019 prefix = hyr19;
				    by patient_id;
				    id mon;
				    var nineteen1;
					run;

					proc transpose data=enrollment_h_long out=enrollment_h_wide_2020 prefix = hyr20;
				    by patient_id;
				    id mon;
				    var twenty1;
					run;


					/* Merge wide formatted yearly enrollment into one table */ 
						
						/* Sort just to be safe */ 

						proc sort data = enrollment_h_wide_2012;
						by patient_id; 
						run; 

						proc sort data = enrollment_h_wide_2013;
						by patient_id; 
						run; 

						proc sort data = enrollment_h_wide_2014;
						by patient_id; 
						run; 

						proc sort data = enrollment_h_wide_2015;
						by patient_id; 
						run; 

						proc sort data = enrollment_h_wide_2016;
						by patient_id; 
						run; 

						proc sort data = enrollment_h_wide_2017;
						by patient_id; 
						run; 

						proc sort data = enrollment_h_wide_2018;
						by patient_id; 
						run; 

						proc sort data = enrollment_h_wide_2019;
						by patient_id; 
						run; 

						proc sort data = enrollment_h_wide_2020;
						by patient_id; 
						run; 



					data enrollment_months_wide_h; 
					merge enrollment_h_wide_2012 - enrollment_h_wide_2020;
					by patient_id;
					run;

							proc print data = enrollment_months_wide_h (obs = 10); 
							run; 
				

		
	/* For Medicare Part D Enrollment */ 
		
				data enrollment_d; 
				set enrollment_months1s (keep = patient_id bene_enrollmt_ref_yr PTD_CNTRCT_ID_01-PTD_CNTRCT_ID_12); 
				run; 

				
				/* Need to tranpose data from long to wide, by year... */ 

					/* 2012 */ 
					data enrollment_d_2012; 
					set enrollment_d; 
					where bene_enrollmt_ref_yr = 2012;
					run; 

					proc transpose data = enrollment_d_2012 out = enrollment_d_long_2012 prefix = twelve;
					by patient_id; 
					var PTD_CNTRCT_ID_01-PTD_CNTRCT_ID_12; 
					run;

						
					/* 2013 */ 
					data enrollment_d_2013; 
					set enrollment_d; 
					where bene_enrollmt_ref_yr = 2013;
					run; 

					proc transpose data = enrollment_d_2013 out = enrollment_d_long_2013 prefix = thirteen;
					by patient_id; 
					var PTD_CNTRCT_ID_01-PTD_CNTRCT_ID_12; 
					run;

					
					/* 2014 */ 
					data enrollment_d_2014; 
					set enrollment_d; 
					where bene_enrollmt_ref_yr = 2014;
					run; 

					proc transpose data = enrollment_d_2014 out = enrollment_d_long_2014 prefix = fourteen;
					by patient_id; 
					var PTD_CNTRCT_ID_01-PTD_CNTRCT_ID_12; 
					run;

					
					/* 2015 */ 
					data enrollment_d_2015; 
					set enrollment_d; 
					where bene_enrollmt_ref_yr = 2015;
					run; 

					proc transpose data = enrollment_d_2015 out = enrollment_d_long_2015 prefix = fifteen;
					by patient_id; 
					var PTD_CNTRCT_ID_01-PTD_CNTRCT_ID_12; 
					run;

						proc print data = enrollment_d_long_2015 (obs = 10); 
						run; 


					/* 2016 */ 
					data enrollment_d_2016; 
					set enrollment_d; 
					where bene_enrollmt_ref_yr = 2016;
					run; 

					proc transpose data = enrollment_d_2016 out = enrollment_d_long_2016 prefix = sixteen;
					by patient_id; 
					var PTD_CNTRCT_ID_01-PTD_CNTRCT_ID_12; 
					run;

						proc print data = enrollment_d_2016_long (obs = 10); 
						run; 


					/* 2017 */ 
					data enrollment_d_2017; 
					set enrollment_d; 
					where bene_enrollmt_ref_yr = 2017;
					run; 

					proc transpose data = enrollment_d_2017 out = enrollment_d_long_2017 prefix = seventeen;
					by patient_id; 
					var PTD_CNTRCT_ID_01-PTD_CNTRCT_ID_12; 
					run;

						
					/* 2018 */ 
					data enrollment_d_2018; 
					set enrollment_d; 
					where bene_enrollmt_ref_yr = 2018;
					run; 

					proc transpose data = enrollment_d_2018 out = enrollment_d_long_2018 prefix = eighteen;
					by patient_id; 
					var PTD_CNTRCT_ID_01-PTD_CNTRCT_ID_12; 
					run;

						
					/* 2019 */ 
					data enrollment_d_2019; 
					set enrollment_d; 
					where bene_enrollmt_ref_yr = 2019;
					run; 

					proc transpose data = enrollment_d_2019 out = enrollment_d_long_2019 prefix = nineteen;
					by patient_id; 
					var PTD_CNTRCT_ID_01-PTD_CNTRCT_ID_12; 
					run;

						
					/* 2020 */ 
					data enrollment_d_2020; 
					set enrollment_d; 
					where bene_enrollmt_ref_yr = 2020;
					run; 

					proc transpose data = enrollment_d_2020 out = enrollment_d_long_2020 prefix = twenty;
					by patient_id; 
					var PTD_CNTRCT_ID_01-PTD_CNTRCT_ID_12; 
					run;


					/* Merge */ 
					
					proc sort data = enrollment_d_long_2012; 
					by patient_id; 
					run; 

					proc sort data = enrollment_d_long_2013; 
					by patient_id; 
					run; 

					proc sort data = enrollment_d_long_2014; 
					by patient_id; 
					run; 

					proc sort data = enrollment_d_long_2015; 
					by patient_id; 
					run; 

					proc sort data = enrollment_d_long_2016; 
					by patient_id; 
					run; 

					proc sort data = enrollment_d_long_2017; 
					by patient_id; 
					run; 

					proc sort data = enrollment_d_long_2018; 
					by patient_id; 
					run; 

					proc sort data = enrollment_d_long_2019; 
					by patient_id; 
					run; 

					proc sort data = enrollment_d_long_2020; 
					by patient_id; 
					run; 



					data enrollment_d_long; 
					merge enrollment_d_long_2012 - enrollment_d_long_2020; 
					by patient_id;
					if _NAME_ = 'PTD_CNTRCT_ID_01' then mon = '01'; 
					else if _NAME_ = 'PTD_CNTRCT_ID_02' then mon = '02'; 
					else if _NAME_ = 'PTD_CNTRCT_ID_03' then mon = '03'; 
					else if _NAME_ = 'PTD_CNTRCT_ID_04' then mon = '04'; 
					else if _NAME_ = 'PTD_CNTRCT_ID_05' then mon = '05'; 
					else if _NAME_ = 'PTD_CNTRCT_ID_06' then mon = '06'; 
					else if _NAME_ = 'PTD_CNTRCT_ID_07' then mon = '07'; 
					else if _NAME_ = 'PTD_CNTRCT_ID_08' then mon = '08'; 
					else if _NAME_ = 'PTD_CNTRCT_ID_09' then mon = '09'; 
					else if _NAME_ = 'PTD_CNTRCT_ID_10' then mon = '10'; 
					else if _NAME_ = 'PTD_CNTRCT_ID_11' then mon = '11'; 
					else if _NAME_ = 'PTD_CNTRCT_ID_12' then mon = '12'; 
					run; 

						proc print data = enrollment_d_long (obs = 50); 
						run; 
					

				/* Now convert long to wide by year */ 

					/* 2012 */ 
					proc transpose data=enrollment_d_long out=enrollment_d_wide_2012 prefix = dyr12;
				    by patient_id;
				    id mon;
				    var twelve1;
					run;

					proc transpose data=enrollment_d_long out=enrollment_d_wide_2013 prefix = dyr13;
				    by patient_id;
				    id mon;
				    var thirteen1;
					run;

					proc transpose data=enrollment_d_long out=enrollment_d_wide_2014 prefix = dyr14;
				    by patient_id;
				    id mon;
				    var fourteen1;
					run;

					proc transpose data=enrollment_d_long out=enrollment_d_wide_2015 prefix = dyr15;
				    by patient_id;
				    id mon;
				    var fifteen1;
					run;

					proc transpose data=enrollment_d_long out=enrollment_d_wide_2016 prefix = dyr16;
				    by patient_id;
				    id mon;
				    var sixteen1;
					run;

					proc transpose data=enrollment_d_long out=enrollment_d_wide_2017 prefix = dyr17;
				    by patient_id;
				    id mon;
				    var seventeen1;
					run;

					proc transpose data=enrollment_d_long out=enrollment_d_wide_2018 prefix = dyr18;
				    by patient_id;
				    id mon;
				    var eighteen1;
					run;

					proc transpose data=enrollment_d_long out=enrollment_d_wide_2019 prefix = dyr19;
				    by patient_id;
				    id mon;
				    var nineteen1;
					run;

					proc transpose data=enrollment_d_long out=enrollment_d_wide_2020 prefix = dyr20;
				    by patient_id;
				    id mon;
				    var twenty1;
					run;


					/* Merge wide formatted yearly enrollment into one table */ 
						
						/* Sort just to be safe */ 

						proc sort data = enrollment_d_wide_2012;
						by patient_id; 
						run; 

						proc sort data = enrollment_d_wide_2013;
						by patient_id; 
						run; 

						proc sort data = enrollment_d_wide_2014;
						by patient_id; 
						run; 

						proc sort data = enrollment_d_wide_2015;
						by patient_id; 
						run; 

						proc sort data = enrollment_d_wide_2016;
						by patient_id; 
						run; 

						proc sort data = enrollment_d_wide_2017;
						by patient_id; 
						run; 

						proc sort data = enrollment_d_wide_2018;
						by patient_id; 
						run; 

						proc sort data = enrollment_d_wide_2019;
						by patient_id; 
						run; 

						proc sort data = enrollment_d_wide_2020;
						by patient_id; 
						run; 



					data enrollment_months_wide_d; 
					merge enrollment_d_wide_2012 - enrollment_d_wide_2020;
					by patient_id;
					run;

							proc print data = enrollment_months_wide_d (obs = 10); 
							run; 
				


	/* Add Medicare Part A/B, HMO, and Part D monthly enrollment columns to the SEER Lung Cancer Patient File */ 
		
				proc sort data = enrollment_months_wide;
				by patient_id; 
				run; 

				proc sort data = enrollment_months_wide_h;
				by patient_id; 
				run; 

				proc sort data = enrollment_months_wide_d;
				by patient_id; 
				run; 

				proc sort data = seer.lung_primary_incident_65_tx1;
				by patient_id; 
				run; 

			data seer.lung_primary_incident_65_tx2;
			merge seer.lung_primary_incident_65_tx1 enrollment_months_wide (drop = _NAME_);
			by patient_id; 
			run; 

			data seer.lung_primary_incident_65_tx3;
			merge seer.lung_primary_incident_65_tx2 enrollment_months_wide_h (drop = _NAME_);
			by patient_id; 
			run; 

			data seer.lung_primary_incident_65_tx4;
			merge seer.lung_primary_incident_65_tx3 enrollment_months_wide_d (drop = _NAME_);
			by patient_id; 
			run;


				proc print data = seer.lung_primary_incident_65_tx4 (obs = 50); 
				run;


		/* Do continuous enrollment lookback for Part A/B, HMO, and Part D */ 

			data enrollment_lookback_abd;	
			set seer.lung_primary_incident_65_tx4;
			where ici_index_dt ne .;
			diag_index = (year(ici_index_dt)-2012)*12+month(ici_index_dt);
			start_mon= diag_index-12;
			run; 

				proc print data = enrollment_lookback_abd (obs = 5); 
				run; 

				/* Check range of diag_index (should be no higher than 96 */ 
					proc freq data = enrollment_lookback_abd;
					table diag_index;
					run;


				/* Rename Medicare Part A/B enrollment columns in ascending numeric order */ 
				data columns_ab_rename;
				set enrollment_lookback_abd (keep = yr:); 
				run; 

				proc sql noprint;
				select catx("=", name, catt('MON', put(varnum, 3. -l)))
				into :rename_list_ab
				separated by " "
				from sashelp.vcolumn
				where libname='WORK'
				and memname='COLUMNS_AB_RENAME';
				quit;

				%put &rename_list_ab;

				proc datasets library=work nodetails nolist;
				modify enrollment_lookback_abd;
				rename &rename_list_ab;

				run; quit;


				/* Rename HMO enrollment columns in ascending numeric order */ 
				data columns_h_rename;
				set enrollment_lookback_abd (keep = hyr:); 
				run; 

				proc sql noprint;
				select catx("=", name, catt('HMON', put(varnum, 3. -l)))
				into :rename_list_h
				separated by " "
				from sashelp.vcolumn
				where libname='WORK'
				and memname='COLUMNS_H_RENAME';
				quit;

				%put &rename_list_h;

				proc datasets library=work nodetails nolist;
				modify enrollment_lookback_abd;
				rename &rename_list_h;

				run; quit;



				/* Rename Medicare Part D enrollment columns in ascending numeric order */ 
				data columns_d_rename;
				set enrollment_lookback_abd (keep = dyr:); 
				run; 

				proc sql noprint;
				select catx("=", name, catt('DMON', put(varnum, 3. -l)))
				into :rename_list_d
				separated by " "
				from sashelp.vcolumn
				where libname='WORK'
				and memname='COLUMNS_D_RENAME';
				quit;

				%put &rename_list_d;

				proc datasets library=work nodetails nolist;
				modify enrollment_lookback_abd;
				rename &rename_list_d;

				run; quit;


				proc print data=enrollment_lookback_abd (obs = 10);
				run;

				data seer.enrollment_months; 
				set enrollment_lookback_abd; 
				run;


		
	/* Do lookback */ 

			/* Medicare Part A/B */
			data enrollment_lookback_abd1;
			set enrollment_lookback_abd;
			ARRAY AB{108} $ MON1 - MON108;
			abflag = 0;
			DO  i = start_mon TO diag_index;
				IF AB{i} in ('10', '11') THEN abflag=abflag+1; 
				END;
			run;

			proc print data = enrollment_lookback_abd1 (obs = 10); 
			run; 

			proc freq data = enrollment_lookback_abd1; 
			table abflag; 
			run; 

				/* 99.7% of potentially eligible ICI users had Medicare A/B eligibility for 12 months prior and during the month ICI was initiated */ 


			/* HMO */
			data enrollment_lookback_abd2;
			set enrollment_lookback_abd1;
			ARRAY H{108} $ HMON1 - HMON108;
			hflag = 0;
			DO  i = start_mon TO diag_index;
				IF H{i} in ('0') THEN hflag=hflag+1; 
				END;
			run;

			proc print data = enrollment_lookback_abd2 (obs = 10); 
			run; 

			proc freq data = enrollment_lookback_abd2; 
			table hflag; 
			run; 

				/* 94.3% of potentially eligible ICI users were not HMO-enrolled in 12 months prior or during the month ICI was initiated */ 

			/* Medicare Part D */
			data seer.enrollment_lookback_abd3;
			set enrollment_lookback_abd2;
			ARRAY D{108} $ DMON1 - DMON108;
			dflag = 0;
			DO  i = start_mon TO diag_index;
				IF D{i} not in ('N', '0', '') THEN dflag=dflag+1; 
				END;
			run;

			proc print data = seer.enrollment_lookback_abd3 (obs = 10); 
			run; 

			proc freq data = seer.enrollment_lookback_abd3; 
			table dflag; 
			run; 

			/* 70.4% of potentially eligible ICI users had Medicare D eligibility for 12 months prior to and during the month ICI was initiated */



	/* How many fell out at each lookback step- 29,850 eligible at start */ 

		/* Medicare A/B - 29,767 */  
		proc freq data = seer.enrollment_lookback_abd3 nlevels;
		where abflag = 13;
		table patient_id /noprint;
		run; 

		/* No HMO enrollment - 28,115 */
		proc freq data = seer.enrollment_lookback_abd3 nlevels;
		where abflag = 13 & hflag = 13;
		table patient_id /noprint;
		run;

		/* Part D- 19,601 */ 
		proc freq data = seer.enrollment_lookback_abd3 nlevels;
		where abflag = 13 & hflag = 13 & dflag = 13; 
		table patient_id /noprint; 
		run; 


	/* 19,601 eligible participants, out of 29,850 ICI-exposed patients (65.7% of potentially eligible) */
    /* 17,357 out of 26,439*/
	/* Attrition: 

                Potentially eligible based on site, sequence, age, ICI exposure
                29,850

                   --> 12 months continuous Medicare A/B enrollment prior to ICI index 
                   29,767 (99.7%)

                             --> 12 months non-HMO enrollment prior to ICI index
                             28,115 (94.5% of Medicare A/B enrolled)

                                    --> 12 months continuous Medicare Part D enrollment prior to ICI index
                                    19,601 (69.7% of non-HMO Medicare A/B enrolled)


		*/

/* List of ICI patients with 12-month non-HMO continuous enrollment in Medicare Part A/B and Part D prior to ICI index date */
	
		data lookback_eligible; 
		set seer.enrollment_lookback_abd3;
		where abflag = 13 & hflag = 13 & dflag = 13; 
		run; 

		proc sql;
		create table seer.lung_primary_incident_65_tx_12 as
		select *
		from seer.lung_primary_incident_65_tx1
		where patient_id in (select patient_id from lookback_eligible);
		quit;

			proc freq data = seer.lung_primary_incident_65_tx_12 nlevels;
			table patient_id /noprint;
			run; 

				/* 19,601 patients on the Lung Cancer patient list */



/* Cohort summary stats for tables- make this its own script??? */ 

/* SEER Registry */ 

/* Coding: 

			Code Description
	0000001501 San Francisco-Oakland SMSA (1975+)
	0000001502 Connecticut (1975+)
	0000001520 Metropolitan Detroit (1975+)
	0000001521 Hawaii (1975+)
	0000001522 Iowa (1975+)
	0000001523 New Mexico (1975+)
	0000001525 Seattle (Puget Sound) (1975+)
	0000001526 Utah (1975+)
	0000001527 Metropolitan Atlanta (1975+)
	0000001531 San Jose-Monterey (1992+)
	0000001535 Los Angeles (1992+)
	0000001537 Rural Georgia (1992+)
	0000001541 Greater California (excl. SF, Los Ang. & SJ) (2000+)
	0000001542 Kentucky (2000+)
	0000001543 Louisiana (2000+)
	0000001544 New Jersey (2000+)
	0000001547 Greater Georgia (excluding AT and RG)
	0000001561 Idaho* (2000+)
	0000001562 New York* (2000+)
	0000001563 Massachusetts* (2000+)
	0000001566 Texas* (2000+)

		(Year in parentheses refers to first diagnosis year of data available)
		*Note: Registry data only available in limited-field databases.


		*/
	proc freq data = seer.lung_primary_incident_65_tx_12; 
	tables seer_registry sequence_number; 
	run; 

	/*
	Registry 
SEER_REGISTRY Frequency Percent CumulativeFrequency CumulativePercent 
	01 515 2.63 515 2.63 	San Francisco-Oakland SMSA
	02 724 3.69 1239 6.32 
	20 668 3.41 1907 9.73 
	21 112 0.57 2019 10.30 
	22 752 3.84 2771 14.14 
	23 188 0.96 2959 15.10 
	25 627 3.20 3586 18.29 
	26 147 0.75 3733 19.04 
	27 291 1.48 4024 20.53 
	31 307 1.57 4331 22.10 		San Jose-Monterey (1992+)
	35 836 4.27 5167 26.36 		LOS ANGELES
	37 36 0.18 5203 26.54 
	41 2320 11.84 7523 38.38  GREATER CALIFORNIA (excl. SF, Los Ang. & SJ)
	42 1160 5.92 8683 44.30 
	43 655 3.34 9338 47.64 
	44 2059 10.50 11397 58.14  NEW JERSEY
	47 984 5.02 12381 63.17 
	61 202 1.03 12583 64.20 	IDAHO
	62 3009 15.35 15592 79.55   NEW YORK
	63 1426 7.28 17018 86.82 	MASSACHUSETTS
	66 2583 13.18 19601 100.00   TEXAS

	*/

	proc sql; 
	create table overlap as
	select *
	from seer.lung_primary_incident_65_tx_12 
	where patient_id in (select patient_id from seer.seer_lung_update); 
	quit; 

	proc freq data = overlap nlevels; 
	table patient_id / noprint; 
	run; 

	proc sql; 
	create table not_overlap as
	select *
	from seer.lung_primary_incident_65_tx_12 
	where patient_id not in (select patient_id from seer.seer_lung_update); 
	quit; 

	proc print data = not_overlap; 
	run; 

	/* there are 19591 total patients from original 19601- so 10 were lost from the cohort after updating enrollment file */ 


	/* Updated cohort with those patients excluded: do this after exposure arm derivation / etc */ 

