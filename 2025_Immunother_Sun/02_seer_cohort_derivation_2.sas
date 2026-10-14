
*******************************************************************************;
* Program name      :	xx_cohort_derivation_2
* Author            :	
* Date created      :	
* Study             : 	
* Purpose           :	
* Inputs            :	
* Program completed : 	
* Updated by        : Xinyi Sun, 10-01-2024
*********************************************************************************;


LIBNAME seer 'S:\Pharmacoepi0216\Thesis';


/* Create table with just patient id, primary site and date of cancer dx */ 

			/* proc print data = seer.lung_primary_incident_65 (obs = 50); 
			run; 
			*/

	/* Need to merge month and year of dx and impute first of the month for the day, also add staging description */ 
	data seer.lung_primary_nsclc_incident_65_1; 
	length stage $150;
	set seer.lung_primary_nsclc_incident_65_1;
	DAY_OF_DIAGNOSIS = '01'; 
	DATE_DX = cat(YEAR_OF_DIAGNOSIS, MONTH_OF_DIAGNOSIS, DAY_OF_DIAGNOSIS);
	DATE_DX_FORMAT = input(DATE_DX, yymmdd10.); 
		format DATE_DX_FORMAT date9.;
	if combined_summary_stage_2004=0 then stage = "In situ";
	else if combined_summary_stage_2004=1 then stage = "Localized";
	else if combined_summary_stage_2004=2 then stage = "Regional by direct extension only";
	else if combined_summary_stage_2004=3 then stage = "Regional lymph nodes involved only";
	else if combined_summary_stage_2004=4 then stage = "Regional by BOTH direct extension AND lymph node involvement";
	else if combined_summary_stage_2004=5 then stage = "Regional, NOS";
	else if combined_summary_stage_2004=7 then stage = "Distant";
	else if combined_summary_stage_2004=9 then stage = "Unknown";
	run; 

		proc print data = seer.lung_primary_nsclc_incident_65_1 (obs = 50); 
		run; 

		proc freq data = seer.lung_primary_nsclc_incident_65_1; 
		table sequence_number;
		run;

		data pat_dx_site_year_stage_seq; 
		set seer.lung_primary_nsclc_incident_65_1 (keep = patient_id primary_site date_dx_format stage sequence_number); 
		run; 

			proc print data = pat_dx_site_year_stage_seq (obs = 50); 
			run; 

			/* No. of appearances per ID? */



/* Filter NCH line file on membership on the lung cancer patient list */ 
proc sql; 
create table seer.nchline_lung as
select *
from seer.nchline
where patient_id in(select distinct patient_id from seer.lung_primary_nsclc_incident_65_1);
quit; 


	/* No. of observations per person? */
	
		proc contents data = seer.nchline_lung; 
		run; 

		proc sql; 
		create table nchline_appearances as
		select patient_id,
		count(distinct clm_id) as n_clm_id
		from seer.nchline_lung
		group by patient_id;
		quit; 

		proc means data = nchline_appearances n mean std min q1 median q3 max;
		var n_clm_id;
		run; 

		proc freq data = nchline_appearances; 
		table n_clm_id;
		run;




/* NCH: Find ICI and chemo administration using HCPCS codes */

/* ICI */ 

	/* source: NCCN guidelines: https://jnccn.org/view/journals/jnccn/20/5/article-p497.xml */ 
	/* source: https://seer.cancer.gov/oncologytoolbox/canmed/hcpcs/?q=&hcpcs=&added_date=01%2F01%2F2013&added_date=12%2F31%2F2019&seerrxcategory.raw=Immunotherapy&paginate_by=25 */
		

	data nch_lung_ici; 
	set seer.nchline_lung;
	where HCPCS_CD in('J9228', 'J9271', 'J9299', 'J9022', 'J9023', 'J9173', 
	'J9113', 'C9027', 'C9453', 'C9483', 'C9491', 'C9492');
	run;

/* Chemotherapy */
/* Note: this does not include TKIs and other CANMed-defined "chemotherapy" that don't have HCPCS code- need NDC, and therefore the Part D file for those exposures */

		/* source: NCCN guidelines: https://jnccn.org/view/journals/jnccn/20/5/article-p497.xml */ 
		/* source for med codes: CANMed database: https://seer.cancer.gov/oncologytoolbox/canmed/hcpcs/?q=&hcpcs=&added_date=01%2F01%2F2013&added_date=12%2F31%2F2019&seerrxcategory.raw=Chemotherapy&paginate_by=25 */

	/* Eligible chemo molecules: 
	Carboplatin
	Cisplatin
	Docetaxel
	Etoposide
	Gemcitabine
	Paclitaxel
	Pemetrexed
	Vinorelbine
	*/


	data nch_lung_chemo; 
	set seer.nchline_lung;
	where HCPCS_CD in('J9045', 'J9060', 'J9171', 'J9181', 'J8560', 'J9201', 'J9305', 'J9390', 'J9264', 'J9265', 'J9267');
	run;



/* Filter Outpatient revenue file on membership on the lung cancer patient list */ 

proc sql; 
create table seer.outrev_lung as
select *
from seer.outrevenue
where patient_id in(select distinct patient_id from seer.lung_primary_nsclc_incident_65_1);
quit; 


	/* No. of observations per person? */
	
		proc contents data = seer.outrev_lung; 
		run; 

		proc sql; 
		create table outrev_appearances as
		select patient_id,
		count(distinct clm_id) as n_clm_id
		from seer.outrev_lung
		group by patient_id;
		quit; 

		proc means data = outrev_appearances n mean std min q1 median q3 max;
		var n_clm_id;
		run; 


		/* 
		Analysis Variable : n_clm_id  
N Mean Std Dev Minimum Lower Quartile Median Upper Quartile Maximum 
257662 36.0552429 40.5915826 1.0000000 9.0000000 23.0000000 49.0000000 790.0000000 
		*/ 

		proc freq data = outrev_appearances; 
		table n_clm_id;
		run;



/* Outpatient : Find ICI and chemo administration using HCPCS codes */

/* ICI */ 

	/* source: NCCN guidelines: https://jnccn.org/view/journals/jnccn/20/5/article-p497.xml */ 
	/* source: https://seer.cancer.gov/oncologytoolbox/canmed/hcpcs/?q=&hcpcs=&added_date=01%2F01%2F2013&added_date=12%2F31%2F2019&seerrxcategory.raw=Immunotherapy&paginate_by=25 */
		

	data outrev_lung_ici; 
	set seer.outrev_lung;
	where HCPCS_CD in('J9228', 'J9271', 'J9299', 'J9022', 'J9023', 'J9173', 
	'J9113', 'C9027', 'C9453', 'C9483', 'C9491', 'C9492');
	run;

/* Chemo, etc */
/* Note: this does not include TKIs and other CANMed-defined "chemotherapy" that don't have HCPCS code- need NDC, and therefore the Part D file for those exposures */

		/* source: NCCN guidelines: https://jnccn.org/view/journals/jnccn/20/5/article-p497.xml */ 
		/* source for med codes: CANMed database: https://seer.cancer.gov/oncologytoolbox/canmed/hcpcs/?q=&hcpcs=&added_date=01%2F01%2F2013&added_date=12%2F31%2F2019&seerrxcategory.raw=Chemotherapy&paginate_by=25 */

	data outrev_lung_chemo; 
	set seer.outrev_lung;
	where HCPCS_CD in('J9045', 'J9060', 'J9171', 'J9181', 'J8560', 'J9201', 'J9305', 'J9390', 'J9264', 'J9265', 'J9267');
	run;



/* Don't do this- not using TKI data to define treatment arms */ 

/* [For TKI use] Filter PDE file on membership on the lung cancer patient list */ 


	/* 2012-2013 PDE files */
/*proc sql; */
/*create table seer.pde_lung_1213 as*/
/*select **/
/*from seer.pdesaf1213*/
/*where patient_id in(select distinct patient_id from seer.lung_primary_incident_65);*/
/*quit; */

	/* 2014-2019 PDE files */
/*proc sql; */
/*create table seer.pde_lung_1419 as*/
/*select **/
/*from seer.pdesaf1419*/
/*where patient_id in(select distinct patient_id from seer.lung_primary_incident_65);*/
/*quit; */



	/* No. of observations per person? */
	
/*		proc contents data = seer.pde_lung_1213; */
/*		run; */
/**/
/*		proc contents data = seer.pde_lung_1419; */
/*		run; */


		/* Merge the 2 datasets conserving common data columns-- 40/42 of the 2012-2013 data columns and 40/43 of the 2014-2019 data columns */ 
/*		data seer.pde_lung;*/
/*		set seer.pde_lung_1213 (keep = BENEFIT_PHASE BN BRND_GNRC_CD CMPND_CD CTSTRPHC_CVRG_CD CVRD_D_PLAN_PD_AMT DAW_PROD_SLCTN_CD DAYS_SUPLY_NUM DRUG_CVRG_STUS_CD DSPNSNG_STUS_CD FILL_NUM FORMULARY_ID FRMLRY_RX_ID GCDF GCDF_DESC GDC_ABV_OOPT_AMT GDC_BLW_OOPT_AMT GNN LICS_AMT NCVRD_PLAN_PD_AMT OTHR_TROOP_AMT PATIENT_ID PDE_ID PDE_PRSCRBR_ID_FRMT_CD PD_DT PHRMCY_SRVC_TYPE_CD PLAN_CNTRCT_REC_ID PLAN_PBP_REC_NUM PLRO_AMT PRCNG_EXCPTN_CD PROD_SRVC_ID PTNT_PAY_AMT PTNT_RSDNC_CD QTY_DSPNSD_NUM RPTD_GAP_DSCNT_NUM RX_ORGN_CD SRVC_DT STR SUBMSN_CLR_CD TOT_RX_CST_AMT)*/
/*			seer.pde_lung_1419 (keep = BENEFIT_PHASE BN BRND_GNRC_CD CMPND_CD CTSTRPHC_CVRG_CD CVRD_D_PLAN_PD_AMT DAW_PROD_SLCTN_CD DAYS_SUPLY_NUM DRUG_CVRG_STUS_CD DSPNSNG_STUS_CD FILL_NUM FORMULARY_ID FRMLRY_RX_ID GCDF GCDF_DESC GDC_ABV_OOPT_AMT GDC_BLW_OOPT_AMT GNN LICS_AMT NCVRD_PLAN_PD_AMT OTHR_TROOP_AMT PATIENT_ID PDE_ID PDE_PRSCRBR_ID_FRMT_CD PD_DT PHRMCY_SRVC_TYPE_CD PLAN_CNTRCT_REC_ID PLAN_PBP_REC_NUM PLRO_AMT PRCNG_EXCPTN_CD PROD_SRVC_ID PTNT_PAY_AMT PTNT_RSDNC_CD QTY_DSPNSD_NUM RPTD_GAP_DSCNT_NUM RX_ORGN_CD SRVC_DT STR SUBMSN_CLR_CD TOT_RX_CST_AMT);*/
/*			run; */
/**/
/*			proc print data = seer.pde_lung (obs = 100); */
/*			run; */
/**/
/**/
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


		/* 
		Analysis Variable : n_clm_id  
N Mean Std Dev Minimum Lower Quartile Median Upper Quartile Maximum 
268926 35.8273577 40.4818287 1.0000000 8.0000000 22.0000000 49.0000000 790.0000000 
		*/ 



		/* Find TKI using NDC codes */ 
		 


		/* Add TKI name data labels */

/*		data seer.pde_lung_tki; */
/*		set pde_lung_tki;*/
/*		if PROD_SRVC_ID in('71777039001', '71777039101', '71777039201') then TKI_name = 'LAROTRECTINIB';*/
/*		else if PROD_SRVC_ID in('50242009130', '50242009186', '50242009201', '50242009286', '50242009447', '50242009490') then TKI_name = 'ENTRECTINIB'; */
/*		else if PROD_SRVC_ID in('00078069448', '00078069484') then TKI_name = 'CERITINIB';*/
/*		else if PROD_SRVC_ID in('00597013730', '00597013790', '00597013830', '00597013895', '00597014130') then TKI_name = 'AFATINIB';*/
/*		else if PROD_SRVC_ID in('00093766356', '00093766456') then TKI_name = 'ERLOTINIB';*/
/*		else if PROD_SRVC_ID in('00069019730', '00069229930', '00069119830', '63539019790') then TKI_name = 'DACOMITINIB';*/
/*		else if PROD_SRVC_ID in('00069022701', '00069023101') then TKI_name = 'LORLATINIB';*/
/*		else if PROD_SRVC_ID in('00069814020', '00069814120') then TKI_name = 'CRIZOTINIB';*/
/*		else if PROD_SRVC_ID in('00310048230', '00310048293') then TKI_name = 'GEFITINIB';*/
/*		else if PROD_SRVC_ID in('42388002326', '42388002336', '42388002337', '42388002426', '42388002437', '42388002526', '42388002537', '42388001425', '00078064070', '42388001114', '42388001214', '42388001314') then TKI_name = 'CABOZANTINIB';*/
/*		else if PROD_SRVC_ID in('50419039001', '50419039101', '50419039201') then TKI_name = 'LAROTRECTINIB';*/
/*		else if PROD_SRVC_ID in('63304009511', '63304009530', '63304009611', '63304009630', '63304013511', '63304013530') then TKI_name = 'ERLOTINIB';*/
/*		else if PROD_SRVC_ID in('50242013001', '50242013086') then TKI_name = 'ALECTINIB';*/
/*		else if PROD_SRVC_ID in('76189011318', '76189011321') then TKI_name = 'BRIGATINIB';*/
/*		else if PROD_SRVC_ID in('00310135030', '00310135095', '00310134930') then TKI_name = 'OSIMERTINIB';*/
/*		run;*/


/*		proc freq data = seer.pde_lung_tki; */
/*		table TKI_name; */
/*		run; */


			/* 
		TKI_name Frequency Percent Cumulative
		Frequency Cumulative
		Percent 
		AFATINIB 15194 21.73 15194 21.73 
		ALECTINIB 4140 5.92 19334 27.65 
		BRIGATINIB 60 0.09 19394 27.73 
		CABOZANTINIB 1691 2.42 21085 30.15 
		CERITINIB 20 0.03 21105 30.18 
		CRIZOTINIB 8647 12.36 29752 42.54 
		DACOMITINIB 76 0.11 29828 42.65 
		ENTRECTINIB 13 0.02 29841 42.67 
		ERLOTINIB 536 0.77 30377 43.44 
		GEFITINIB 4625 6.61 35002 50.05 
		LAROTRECTINIB 8 0.01 35010 50.06 
		LORLATINIB 287 0.41 35297 50.47 
		OSIMERTINIB 34637 49.53 69934 100.00 

		 */ 

/*		proc print data = seer.pde_lung_tki (obs = 50);*/
/*		run; */
			/* no missing */ 




/* Combine the datasets */ 

	/* NCH */
	data seer.nch_lung_tx;
	length record_source $ 20; 
	set nch_lung_ici nch_lung_chemo;
	record_source = "NCH Line";
	run; 
	
	/* Outpat rev */ 
	data seer.outrev_lung_tx;
	length record_source $ 20;
	set outrev_lung_ici outrev_lung_chemo;
	record_source = "Outpatient Rev";
	run; 

	/* Combine NCH and Outpatient files, conserving just a few common data columns */ 
	data seer.combined_nch_outrev_lung_tx;
	set seer.nch_lung_tx (keep = patient_id clm_id HCPCS_CD CLM_THRU_DT record_source) seer.outrev_lung_tx (keep = patient_id clm_id HCPCS_CD CLM_THRU_DT record_source);
	run; 

	/* Label the HCPCS codes with drug ICI names */ 
	data seer.combined_nch_outrev_lung_tx;
	length ICI_name$ 15;
	length chemo_name$ 25;
	length chemo_class$ 35; 
	set seer.combined_nch_outrev_lung_tx; 
	if HCPCS_CD in ('J9228') then ICI_name = 'IPILIMUMAB';
	else if HCPCS_CD in ('J9271', 'C9027') then ICI_name = 'PEMBROLIZUMAB';
	else if HCPCS_CD in ('J9299', 'C9453') then ICI_name = 'NIVOLUMAB';
	else if HCPCS_CD in ('J9022', 'C9483') then ICI_name = 'ATEZOLIZUMAB';
	else if HCPCS_CD in ('J9023', 'C9491') then ICI_name = 'AVELUMAB';
	else if HCPCS_CD in ('J9173', 'C9492') then ICI_name = 'DURVALUMAB';
	else if HCPCS_CD in ('J9113') then ICI_name = 'CEMIPLIMAB-RWLC';
	else ICI_name = '.';
	if HCPCS_CD in ('J9045') then chemo_name = 'CARBOPLATIN';
	else if HCPCS_CD in ('J9060') then chemo_name = 'CARBOPLATIN';
	else if HCPCS_CD in ('J9045') then chemo_name = 'CISPLATIN';
	else if HCPCS_CD in ('J9171') then chemo_name = 'DOCETAXEL';
	else if HCPCS_CD in ('J9181', 'J8560') then chemo_name = 'ETOPOSIDE';
	else if HCPCS_CD in ('J9201') then chemo_name = 'GEMCITABINE';
	else if HCPCS_CD in ('J9264', 'J9265', 'J9267') then chemo_name = 'PACLITAXEL';
	else if HCPCS_CD in ('J9305') then chemo_name = 'PEMETREXED';
	else if HCPCS_CD in ('J9390') then chemo_name = 'VINORELBINE';
	else chemo_name = '.';	
	if HCPCS_CD in ('J0594', 'J8510') then chemo_class = 'ALKYLSULFONATE'; 
	else if HCPCS_CD in ('C9480', 'J9352') then chemo_class = 'NATURAL PRODUCT';
	else if HCPCS_CD in ('J8530', 'J8600', 'J9033', 'J9034', 'J9036', 'J9070', 
		'J9092', 'J9094', 'J9097', 'J9208', 'J9230', 'J9245', 'J9340') then chemo_class = 'NITROGEN MUSTARD';
	else if HCPCS_CD in ('J9050', 'J9320') then chemo_class = 'NITROSUREA';
	else if HCPCS_CD in ('J9045', 'J9060', 'J9263') then chemo_class = 'PLATINUM COMPOUND';
	else if HCPCS_CD in ('J9130') then chemo_class = 'PURINE ANALOG';
	else if HCPCS_CD in ('C1086', 'C9253', 'J8700', 'J9328') then chemo_class = 'TETRAZINE';
	else if HCPCS_CD in ('J8610', 'J9250', 'J9260', 'J9305', 'J9307') then chemo_class = 'FOLIC ACID ANALOG';
	else if HCPCS_CD in ('J3305') then chemo_class = 'FOLIC ACID ANTAGONIST';
	else if HCPCS_CD in ('J8562', 'J9027', 'J9065', 'J9185', 'J9261', 'J9268') then chemo_class = 'PURINE ANALOG';
	else if HCPCS_CD in ('J0894', 'J8520', 'J8521', 'J9025', 'J9098', 'J9100', 
		'J9190', 'J9200', 'J9201') then chemo_class = 'PYRIMIDINE ANALOG';
	else if HCPCS_CD in ('J9179') then chemo_class = 'FUROPYRANS';
	else if HCPCS_CD in ('J9043', 'J9171', 'J9264', 'J9265', 'J9267') then chemo_class = 'TAXANE';
	else if HCPCS_CD in ('J9360', 'J9370', 'J9371', 'J9390') then chemo_class = 'VINCA ALKYLOID';
	else if HCPCS_CD in ('J9280') then chemo_class = 'ALKYLATING AGENT/MITOMYCIN';
	else if HCPCS_CD in ('J9293') then chemo_class = 'ANTHRADENEDIONE';
	else if HCPCS_CD in ('J9000', 'J9002', 'J9150', 'J9151', 'J9178', 'J9211', 'J9270', 'J9357') then chemo_class = 'ANTHRACYCLINE';
	else if HCPCS_CD in ('J9040', 'J9120') then chemo_class = 'CARBOXYLIC ACIDS AND AMINO ACIDS/PEPTIDES';
	else if HCPCS_CD in ('C9240', 'J9207') then chemo_class = 'EPOTHILONES';
	else if HCPCS_CD in ('C9024') then chemo_class = 'ANTHRACYLINE & PYRIMIDINE ANALOG';
	else if HCPCS_CD in ('J9032', 'J9315') then chemo_class = 'HDAC';
	else if HCPCS_CD in ('J7527', 'J9330') then chemo_class = 'mTOR';
	else if HCPCS_CD in ('J9057') then chemo_class = 'PI3K';
	else if HCPCS_CD in ('C9289', 'J9019', 'J9020', 'J9118', 'J9266') then chemo_class = 'ENZYME';
	else if HCPCS_CD in ('J9017') then chemo_class = 'PML/RARa';
	else if HCPCS_CD in ('J9600') then chemo_class = 'CYTOTOXIN';
	else if HCPCS_CD in ('C9297', 'J9262') then chemo_class = 'BCR-ABL';
	else if HCPCS_CD in ('J8560', 'J9181') then chemo_class = 'EPIPODOPHYLLOTOXINS';
	else if HCPCS_CD in ('C9295', 'J9047', 'J9041', 'J9044') then chemo_class = '20S';
	else if HCPCS_CD in ('C9296', 'J9400') then chemo_class = 'VEGF-IgG1';
	else if HCPCS_CD in ('C9474', 'J8705', 'J9206', 'J9351') then chemo_class = 'CAMPOTHECIN ANALOGS';
	else if HCPCS_CD in ('J8565') then chemo_class = 'EGFR';
	else if HCPCS_CD in ('J8999', 'J9999') then chemo_class = 'UNDEFINED';
	else chemo_class = '.';
	run;



					/* Homogenize the claim ID, date, and  drug name fields for combination with the TKI exposure data */ 
/*					data combined_nch_outrev_lung_tx;*/
/*					length TKI_name$ 30;*/
/*					set seer.combined_nch_outrev_lung_tx; */
/*					record_id = clm_id; */
/*					record_dt = clm_thru_dt;*/
/*					drug_cd = HCPCS_cd; */
/*					TKI_name ='.';*/
/*					run; */

/*						proc print data = combined_nch_outrev_lung_tx (obs = 50); */
/*						run; */

/*					data pde_lung_tki; */
/*					length ICI_name$ 30;*/
/*					length chemo_class$ 30;*/
/*					set seer.pde_lung_tki; */
/*					record_id = pde_id; */
/*					record_dt = srvc_dt; */
/*					drug_cd = prod_srvc_id; */
/*					record_source = "Part D";*/
/*					ICI_name ='.';*/
/*					chemo_class ='.';*/
/*					run; */

/*						proc print data = pde_lung_tki (obs = 50); */
/*						run; */

/*					/* Combine PDE data on TKI with the chemo and ICI exposure history */ */
/*					data seer.combined_nch_outrev_pde_lung_tx; */
/*					set combined_nch_outrev_lung_tx (keep = patient_id record_id record_dt record_source ICI_name chemo_class TKI_name) pde_lung_tki (keep = patient_id record_id record_dt record_source ICI_name chemo_class TKI_name);*/
/*					run; */

/*					proc sort data = seer.combined_nch_outrev_pde_lung_tx;*/
/*					by patient_id record_dt;*/
/*					run; */

/*					proc print data = seer.combined_nch_outrev_pde_lung_tx (obs = 100); */
/*					run; */


/* Compare first ICI tx date to diagnosis date- prevalent ICI users... (initiated ICI prior to first dx in database) */ 

		/* Mark the first record of medication use and ICI use specifically by patient   */

               /* proc sort data = seer.combined_nch_outrev_lung_tx;
				/*by patient_id clm_thru_dt;*/
				/*run;*/
                proc sort data = seer.combined_nch_outrev_lung_tx;
				by patient_id clm_thru_dt; 
				run; 
			data seer.combined_nch_outrev_lung_tx;
			set seer.combined_nch_outrev_lung_tx;
			by patient_id;
			first_tx = first.patient_id;
			if first.patient_id then rx_count = 1;
			else rx_count +1;
			run; 

					proc print data = seer.combined_nch_outrev_lung_tx (obs = 100); 
					run; 

			data seer.combined_nch_outrev_lung_ICI;   /* ICI */
			set seer.combined_nch_outrev_lung_tx;
			where ICI_name ne '.'; /* not equal to missing*/
			by patient_id;
			first_ICI = first.patient_id;
			if first.patient_id then ICI_tx_count = 1;
			else ICI_tx_count +1;
			run; 

					proc print data = seer.combined_nch_outrev_lung_ICI (obs = 100); 
					run; 


			/* Filter to first chronological ICI record for each patient */ 
			data first_ICI_tx; 
			set seer.combined_nch_outrev_lung_ICI;
			where first_ICI = 1; 
			run; 

				proc freq data = first_ICI_tx nlevels; 
				table patient_id /noprint; 
				run; 

					/* 30158 unique patients */ 

						proc print data = first_ICI_tx (obs = 50); 
						run; 

			/* Merge in the site and date of lung cancer dx */ 

				proc sort data = first_ICI_tx;
				by patient_id;
				run; 

				proc sort data = pat_dx_site_year_stage_seq;
				by patient_id; 
				run; 

			data first_ICI_tx_dx_date_compare; 
				merge first_ICI_tx pat_dx_site_year_stage_seq; /* Outer join, all ids from both tables*/
				by patient_id; 
			run;  

				proc print data = first_ICI_tx_dx_date_compare (obs = 50); 
				run; 	

				/* Filter out records with diagnosis date but no medication
					Convert tx and dx dates to date format and compare them */ 

				data first_ICI_tx_dx_date_compare; 
				set first_ICI_tx_dx_date_compare;
				where first_ICI ne .;
				run;

				data first_ICI_tx_dx_date_compare; 
				set first_ICI_tx_dx_date_compare;
				first_ICI_tx_dt = input(clm_thru_dt, yymmdd10.);
					ICI_tx_date_format = first_ICI_tx_dt; 
					format ICI_tx_date_format date9.;
						dx_tx_gap_days = ICI_tx_date_format - date_dx_format; 
						if dx_tx_gap_days >0 then ICI_tx_after_dx = 1; 
						else ICI_tx_after_dx = 0;
				run; 

						proc print data = first_ICI_tx_dx_date_compare (obs = 10); 
						run; 

						proc freq data = first_ICI_tx_dx_date_compare nlevels;
						table patient_id /noprint;
						run; 

							/* 30158 unique patients, good */

					proc freq data = first_ICI_tx_dx_date_compare;
					table ICI_tx_after_dx;
					run; 

					/*

					ICI_tx_after_dx Frequency Percent CumulativeFrequency CumulativePercent 
							0 			308 	1.02 		308 			1.02 
							1 			29850 	98.98 		30158 			100.00 

					*/

					proc print data = first_ICI_tx_dx_date_compare;
					where ICI_tx_after_dx = 0; 
					run; 

						proc freq data = first_ICI_tx_dx_date_compare;
						where ICI_tx_after_dx = 0;
						table sequence_number;
						run; 

							/*
					SEQUENCE_NUMBER Frequency Percent CumulativeFrequency CumulativePercent 
							00 			151 	49.03 		151 			49.03 
							01 			4 		1.30 		155 			50.32 
							02 			86 		27.92 		241 			78.25 
							03 			51 		16.56 		292 			94.81 
							04 			8 		2.60 		300 			97.40 
							05 			4 		1.30 		304 			98.70 
							06 			2 		0.65 		306 			99.35 
							07 			1 		0.32 		307 			99.68 
							09 			1 		0.32 		308 			100.00 


							*/			
						
						/* Half of patients with "ICI tx before dx" had lung cancer as their 2nd, 3rd, 4th cancer dx lifetime; 49% on first or only cancer */
								
							proc freq data = first_ICI_tx_dx_date_compare;
							where ICI_tx_after_dx = 1;
							table sequence_number;
							run; 

								/* 70% of patients with "ICI tx after dx" were on their only cancer or first of multiple cancers, 23% on 2nd cancer */

						/* Exclude patients receiving ICI prior to FIRST cancer dx in the database */ 
						data prevalent_users;
						set first_ICI_tx_dx_date_compare; 
						where ICI_tx_after_dx = 0;
						run; 

						proc sql;
						create table seer.combined_nch_outrev_lung_tx_inc as 
						select * from seer.combined_nch_outrev_lung_tx
						where patient_id not in (select patient_id from prevalent_users);
						quit;

							proc print data = seer.combined_nch_outrev_lung_tx_inc (obs = 10); 
							run; 



						/* Approach 2: Censor treatments received prior to dx date for patients who had treatment for previous cancer (?) */ 

/*						data prior_cancer_dx; */
/*						set first_tx_dx_date_compare;*/
/*						where tx_after_dx = 0 & sequence_number not in ('00','01');*/
/*						run; */
/**/
/*							proc print data = prior_cancer_dx (obs = 50);*/
/*							run;*/

							/* Filter the list of chemo and ICI on membership on this list */
/*							proc sql; */
/*							create table prior_cancer_dx_records as*/
/*							select * */
/*							from seer.combined_nch_outrev_lung_tx */
/*							where patient_id in(select patient_id from prior_cancer_dx); */
/*							quit; */
/**/
/*								proc contents data = prior_cancer_dx_records; */
/*								run; */
/**/
/*								proc print data = prior_cancer_dx_records (obs = 50); */
/*								run; */

							/* Merge in the date of lung cancer dx for patients with prior cancer */ 
/*								proc sort data = prior_cancer_dx_records;*/
/*								by patient_id; */
/*								run; */
/**/
/*							proc sql;*/
/*    						create table prior_cancer_compare_dx_tx as*/
/*    						select * from prior_cancer_dx_records as x left join pat_dx_site_year_stage_seq as y*/
/*    						on x.patient_id = y.patient_id;*/
/*							quit;*/
/*								*/
/*								proc print data = pat_dx_site_year_stage_seq;*/
/*								where patient_id = 'lnK2020w0004329';*/
/*								run;*/
/**/
/*								proc contents data = prior_cancer_compare_dx_tx; */
/*								run; */
/**/
/*								proc print data = prior_cancer_compare_dx_tx (obs = 50); */
/*								run;*/
/**/
/*					proc print data = first_tx_dx_date_compare (obs = 50); */
/*					run; */

					
/* How many records from each source of data? */ 

proc freq data = seer.combined_nch_outrev_lung_tx_inc(where = (ICI_name ne '.'));
table ICI_name*record_source;
run; 


proc freq data = seer.combined_nch_outrev_lung_tx_inc(where = (chemo_class ne '.'));
table chemo_name*record_source;
run; 


proc freq data = seer.combined_nch_outrev_lung_tx_inc(where = (chemo_class ne '.'));
table chemo_class*record_source;
run; 


/* Place of service- NCH records */ 
proc freq data = seer.nch_lung_tx;
table LINE_PLACE_OF_SRVC_CD;
run; 

/* 
Line Place Of Service Code 
LINE_PLACE_OF_SRVC_CD Frequency Percent Cumulative
Frequency Cumulative
Percent 
01 10 0.00 10 0.00 
11 819813 99.95 819823 99.95 
12 55 0.01 819878 99.95 
13 5 0.00 819883 99.95 
14 1 0.00 819884 99.95 
19 98 0.01 819982 99.97 
21 3 0.00 819985 99.97 
22 185 0.02 820170 99.99 
24 85 0.01 820255 100.00 

*/ 

/* 
11 = Office. Location, other than a hospital, skilled nursing facility (SNF), military treatment facility,
community health center, State or local public health clinic, or intermediate care facility (ICF),
where the health professional routinely provides health examinations, diagnosis, and
treatment of illness or injury on an ambulatory basis.
*/


/* No. of unique patients by class */ 

		/* ICI */

		proc sql; 
		create table ici_patient_count as
		select ICI_name,
		count(distinct patient_id) as n_ici_patient
		from seer.combined_nch_outrev_lung_tx_inc
		group by ICI_name;
		quit; 

			/* View */ 
			proc print data = ici_patient_count; 
			run; 


		/* Chemo (name) */ 
		
		proc sql; 
		create table chemo_patient_count as
		select chemo_name,
		count(distinct patient_id) as n_chemo_patient
		from seer.combined_nch_outrev_lung_tx_inc
		group by chemo_name;
		quit; 

			/* View */ 
			proc print data = chemo_patient_count; 
			run; 

		/* Chemo (class) */ 
		
		proc sql; 
		create table chemo_patient_count_class as
		select chemo_class,
		count(distinct patient_id) as n_chemo_patient
		from seer.combined_nch_outrev_lung_tx_inc
		group by chemo_class;
		quit; 

			/* View */ 
			proc print data = chemo_patient_count_class; 
			run; 


		/* No. of unique patients by ICI/chemo combo */ 
		
				/* Create */



/* Count # of appearances per ID */ 

		
		/* ICI only */

		proc sql; 
		create table ici_record_count as
		select patient_id,
		count(distinct clm_id) as n_ici_record
		from seer.combined_nch_outrev_lung_tx_inc
		where ICI_name ne '.'
		group by patient_id;
		quit; 

			/* There are 29,850 unique patients receiving ICI */ 

		proc means data = ici_record_count n mean std min q1 median q3 max;
		var n_ici_record;
		run; 

		proc freq data = ici_record_count; 
		table n_ici_record;
		run;


		/* Histogram */ 

		ods graphics on;
		proc univariate data = ici_record_count noprint;
		Title 'Distribution of ICI Records by Patient';
			histogram n_ici_record;
		run; 
		ods graphics off;


		
		/* Chemo only */ 

		proc sql; 
		create table chemo_record_count as
		select patient_id,
		count(distinct clm_id) as n_chemo_record
		from seer.combined_nch_outrev_lung_tx_inc
		where chemo_name ne '.'
		group by patient_id;
		quit; 

			/* There are 76,282 unique patients receiving chemo */ 

		proc means data = chemo_record_count n mean std min q1 median q3 max;
		var n_chemo_record;
		run; 

		proc freq data = chemo_record_count; 
		table n_chemo_record;
		run;

		
		/* Histogram */ 

		ods graphics on;
		proc univariate data = chemo_record_count noprint;
		Title 'Distribution of Chemo Records by Patient';
		histogram n_chemo_record;
		run; 
		ods graphics off;



/* View some records */ 

		proc sort data = seer.combined_nch_outrev_lung_tx_inc; 
		by patient_id clm_thru_dt; 
		run; 

		proc print data = seer.combined_nch_outrev_lung_tx_inc (obs = 50); 
		run; 



/* Merge ICI or chemo exposure status with the list of lung cancer patients */ 

		/* Combine ICI patients from NCH and Outrev to reference */ 

		data combined_ici;
		set nch_lung_ici (keep = patient_id clm_id HCPCS_CD CLM_THRU_DT) outrev_lung_ici (keep = patient_id clm_id HCPCS_CD CLM_THRU_DT);
		run; 

			proc sql; 
			create table combined_ici_inc as
			select *
			from combined_ici
			where patient_id not in(select patient_id from prevalent_users);
			quit;

		data combined_chemo;
		set nch_lung_chemo (keep = patient_id clm_id HCPCS_CD CLM_THRU_DT) outrev_lung_chemo (keep = patient_id clm_id HCPCS_CD CLM_THRU_DT);
		run;

			proc sql; 
			create table combined_chemo_inc as
			select *
			from combined_chemo
			where patient_id not in(select patient_id from prevalent_users);
			quit;


		/* Add chemo, ICI exposure status to the SEER Lung Cancer File */ 
		proc sql; 
		create table seer.lung_nsclc_incident_65_tx as
		select *, patient_id in(select patient_id from combined_ici_inc) as ICI_use, patient_id in(select patient_id from combined_chemo_inc) as chemo_use
		from seer.lung_primary_nsclc_incident_65_1;
		quit;

		proc print data = seer.lung_nsclc_incident_65_tx (obs = 100); 
		run;

		proc freq data = seer.lung_nsclc_incident_65_tx; 
		table ICI_use*chemo_use;
		run; 


		/* Add ICI index date to SEER Lung Cancer File */ 
		proc sort data = combined_ici_inc;
		by patient_id clm_thru_dt;
		run; 

		data combined_ici_inc1; 
		set combined_ici_inc;
		by patient_id; 
		if first.patient_id then first = 1; 
		run; 

		data combined_ici_inc2;
		set combined_ici_inc1 (keep = patient_id clm_thru_dt first);
		where first = 1; 
		run; 


		data seer.lung_nsclc_incident_65_tx1;
		merge seer.lung_nsclc_incident_65_tx combined_ici_inc2 (drop = first);
		by patient_id;
		ici_index = clm_thru_dt;
		ici_index_dt = input(clm_thru_dt, yymmdd10.);
		format ici_index_dt date9.;
		run; 

			proc print data = seer.lung_nsclc_incident_65_tx1 (obs = 10); 
			run; 




/*
 
29,490 patients (7.93 of total) take ICI (in total), of which:
22,960 patients (6.17 of total) take ICI and also exposed to chemo (77.86% of ICI users)
6,530 patients (1.76 of total) take ICI and not exposed to chemo (22.14% of ICI users) 
 
			*/

/* 
26,439 patients (7.92 of total) take ICI (in total), of which:
19,926 patients (5.97 of total) take ICI and also exposed to chemo (75.37% of ICI users)
6,513 patients (1.95 of total) take ICI and not exposed to chemo (24.63% of ICI users) 

			*/
 


		/* Incorporate TKI */ 
/*		proc freq data = seer.lung_primary_incident_65_tx; */
/*		table TKI_use*ICI_use*chemo_use;*/
/*		run; */





