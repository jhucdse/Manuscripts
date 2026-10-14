
*******************************************************************************;
* Program name      :	xx_cohort_derivation_2
* Author            :	Xinyi Sun & James Hayward
* Date created      :	
* Study             : 	
* Purpose           :	
* Inputs            :	
* Program completed : 	
* Updated by        : Sophia Ko, 11-15-2025
*********************************************************************************;


LIBNAME seer 'S:\Pharmacoepi0216\SK_ScM_Thesis25\melanoma project\melanomacohort\Data\processed';
LIBNAME raw 'S:\Pharmacoepi0216\Thesis Project\seer';
			
	/* Need to merge month and year of dx and impute first of the month for the day, also add staging description */ 
	proc import datafile="S:\Pharmacoepi0216\SK_ScM_Thesis25\melanoma project\melanomacohort\Data\processed\seer1b.csv"
		out=seer1
		dbms=csv
		replace;
			guessingrows=32767;
	run;
	/* add date of dx field, using 1st of month */

	data seer.seer2;
    length STAGE_LABEL $50 STAGE_GROUP $20;
    set work.seer1; 
    
    /* Step 1: Create day of diagnosis (assume 1st of month) */
    DAY_DX = '01';
    
    /* Step 2: Create date string and convert to SAS date */
    /* Pad month with leading zero if needed */
    MONTH_DX_CHAR = put(MONTH_OF_DIAGNOSIS, z2.);  /* Converts to 2-digit with leading zero */
    DATE_DX_STRING = cat(YEAR_OF_DIAGNOSIS, MONTH_DX_CHAR, DAY_DX);
    DX_DATE = input(DATE_DX_STRING, yymmdd8.);
    format DX_DATE date9.;
	proc sql;
    select count(distinct patient_id) as unique_patients
    from seer.seer2;
	quit;
	proc means data=seer.seer2 n nmiss min max;
    var DX_DATE;
    title "Diagnosis Date Summary";
    format DX_DATE date9.;
run; /* 443 pts missing a diagnosis date */
/* WHILE This section provides specific stage groupings, we ended up using this variable ONLY to filter out stage 0 and unknown cases at dx. 
/* Then we used seer summary stage (local, regional, distant) since this was more complete*/
    /* Step 3: Create readable stage labels based on staging system used */
data seer.seer2;
    set seer.seer2; /* switching from work to seer directory */
 /* For 2013-2015: AJCC 7th edition (numeric codes stored as character) */
    if YEAR_OF_DIAGNOSIS >= 2013 and YEAR_OF_DIAGNOSIS <= 2015 then do;
        if DERIVEDAJCCSTAGEGROUP7THED20102 in ('000', '010', '020') then STAGE_GROUP = 'Stage 0';
        else if DERIVEDAJCCSTAGEGROUP7THED20102 in ('100', '110', '120', '121', '130', '140', '150', '151', '160', '170', '180', '190', '200', '210', '220', '230', '240') 
            then STAGE_GROUP = 'Stage I';
        else if DERIVEDAJCCSTAGEGROUP7THED20102 in ('300', '310', '320', '321', '322', '323', '330', '340', '350', '360', '370', '380', '390', '400', '410', '420', '430') 
            then STAGE_GROUP = 'Stage II';
        else if DERIVEDAJCCSTAGEGROUP7THED20102 in ('500', '510', '520', '530', '540', '541', '542', '550', '560', '570', '580', '590', '600', '610', '620', '630') 
            then STAGE_GROUP = 'Stage III';
        else if DERIVEDAJCCSTAGEGROUP7THED20102 in ('700', '710', '720', '730', '740') 
            then STAGE_GROUP = 'Stage IV';
        else if DERIVEDAJCCSTAGEGROUP7THED20102 = '900' then STAGE_GROUP = 'Occult';
        else if DERIVEDAJCCSTAGEGROUP7THED20102 = '888' then STAGE_GROUP = 'Not Applicable';
        else if DERIVEDAJCCSTAGEGROUP7THED20102 in ('999', '', '1022') then STAGE_GROUP = 'Unknown';
        else STAGE_GROUP = 'Unknown';
    end;
    
    /* For 2016-2017: SEER Combined Stage */
    else if YEAR_OF_DIAGNOSIS >= 2016 and YEAR_OF_DIAGNOSIS <= 2017 then do;
        if substr(DERIVEDSEERCMBSTG_GRP_2016_2017, 1, 1) = '0' then STAGE_GROUP = 'Stage 0';
        else if substr(DERIVEDSEERCMBSTG_GRP_2016_2017, 1, 1) = '1' then STAGE_GROUP = 'Stage I';
        else if substr(DERIVEDSEERCMBSTG_GRP_2016_2017, 1, 1) = '2' then STAGE_GROUP = 'Stage II';
        else if substr(DERIVEDSEERCMBSTG_GRP_2016_2017, 1, 1) = '3' then STAGE_GROUP = 'Stage III';
        else if substr(DERIVEDSEERCMBSTG_GRP_2016_2017, 1, 1) = '4' then STAGE_GROUP = 'Stage IV';
        else if DERIVEDSEERCMBSTG_GRP_2016_2017 = 'OC' then STAGE_GROUP = 'Occult';
        else STAGE_GROUP = 'Unknown';
    end;
    
    /* For 2018-2019: EOD 2018 Stage */
    else if YEAR_OF_DIAGNOSIS >= 2018 and YEAR_OF_DIAGNOSIS <= 2019 then do;
        if substr(DERIVEDEOD2018_STAGE_GROUP_2018, 1, 1) = '0' then STAGE_GROUP = 'Stage 0';
        else if substr(DERIVEDEOD2018_STAGE_GROUP_2018, 1, 1) = '1' then STAGE_GROUP = 'Stage I';
        else if substr(DERIVEDEOD2018_STAGE_GROUP_2018, 1, 1) = '2' then STAGE_GROUP = 'Stage II';
        else if substr(DERIVEDEOD2018_STAGE_GROUP_2018, 1, 1) = '3' then STAGE_GROUP = 'Stage III';
        else if substr(DERIVEDEOD2018_STAGE_GROUP_2018, 1, 1) = '4' then STAGE_GROUP = 'Stage IV';
        else if DERIVEDEOD2018_STAGE_GROUP_2018 = 'OC' then STAGE_GROUP = 'Occult';
        else if DERIVEDEOD2018_STAGE_GROUP_2018 = '88' then STAGE_GROUP = 'Not Applicable';
        else STAGE_GROUP = 'Unknown';
    end;
	 /* Step 4: Use Combined Summary Stage as backup for Unknown cases. THE ISSUE is that these summary stages do not distinguish stage 2 and 3. */
    if STAGE_GROUP = 'Unknown' and not missing(COMBINED_SUMMARY_STAGE_2004) then do;
        if COMBINED_SUMMARY_STAGE_2004 = 0 then STAGE_GROUP = 'Stage 0';
        else if COMBINED_SUMMARY_STAGE_2004 = 1 then STAGE_GROUP = 'Stage I';  /* Localized */
        else if COMBINED_SUMMARY_STAGE_2004 in (2, 3, 4, 5) then STAGE_GROUP = 'Stage II-III';  /* Regional */
        else if COMBINED_SUMMARY_STAGE_2004 = 7 then STAGE_GROUP = 'Stage IV';  /* Distant */
        else if COMBINED_SUMMARY_STAGE_2004 = 9 then STAGE_GROUP = 'Unknown';
        else if COMBINED_SUMMARY_STAGE_2004 = 8 then STAGE_GROUP = 'Not Applicable';
    end;
    
    /* Create flag to indicate if Summary Stage was used */
    if STAGE_GROUP in ('Stage 0', 'Stage I', 'Stage II-III', 'Stage IV') and 
       (DERIVEDAJCCSTAGEGROUP7THED20102 in (., 999) or 
        DERIVEDSEERCMBSTG_GRP_2016_2017 in ('', '99') or 
        DERIVEDEOD2018_STAGE_GROUP_2018 in ('', '99')) then 
            STAGE_SOURCE = 'Summary Stage';
    else STAGE_SOURCE = 'AJCC/EOD Stage';
run;



/* See some examples of the unknown cases */
/* proc print data=seer.seer2 (obs=40);
    where STAGE_GROUP = 'Unknown';
    var YEAR_OF_DIAGNOSIS DERIVEDAJCCSTAGEGROUP7THED20102 Derived_SS1977  Derived_SS2000  SEER_Summary_stage_2000_0103  SEER_Summary_Stage_2000newonly
        DERIVEDSEERCMBSTG_GRP_2016_2017 DERIVEDEOD2018_STAGE_GROUP_2018 Combined_Summary_Stage_2004 ;
    title "Sample of Unknown Stage Cases";
run; */

/* Verify the results */
/*proc freq data=seer.seer2;
    tables STAGE_GROUP / missing;
    title "Distribution of Stage Labels";
run;
/*
STAGE_GROUP Frequency Percent Cumulative
Frequency Cumulative
Percent 
Not Applicable 10 0.02 10 0.02 
Stage 0 34 0.05 44 0.07 
Stage I 43038 67.37 43082 67.44 
Stage II 6715 10.51 49797 77.95 
Stage II-III 2422 3.79 52219 81.74 
Stage III 2830 4.43 55049 86.17 
Stage IV 3214 5.03 58263 91.20 
Unknown 5619 8.80 63882 100.00 

*/
/*
proc freq data=seer.seer2;
    tables YEAR_OF_DIAGNOSIS*STAGE_GROUP / missing nocol nopercent;
    title "Stage Distribution by Diagnosis Year";
run; 

proc print data=seer.seer2 (obs=10);
    var PATIENT_ID YEAR_OF_DIAGNOSIS MONTH_OF_DIAGNOSIS DX_DATE STAGE_GROUP;
    format DX_DATE date9.;
    title "First 10 Records - Check Date and Stage";
run; 
proc freq data=seer.seer2;
    tables DX_DATE / missing nocum;
    title "DX_DATE Missing Value Count";
run;*/
/*excluding individuals without a month of dx and who has missing, unknown, or stage 0 melanoma */
data seer.pat_dx_site_year_stage_seq; 
	set seer.seer2 (keep = patient_id primary_site DX_DATE stage_group sequence_number
						where = (DX_DATE ne .
							and stage_group in ('Stage I', 'Stage II', 'Stage II-III','Stage III', 'Stage IV'))); 
	run; 
/*proc freq data = seer.pat_dx_site_year_stage_seq;
	tables stage_group DX_date;
	run;
proc sql;
    select count(distinct patient_id) as unique_patients
    from seer.pat_dx_site_year_stage_seq;
quit;

proc print data = seer.pat_dx_site_year_stage_seq (obs = 50); 
	run; 


/* Filter NCH line file for the skin cancer patient list */ 

/*proc sql; 
create table seer.nchline_skin as
select *
from raw.nchline
where patient_id in(select distinct patient_id from seer.pat_dx_site_year_stage_seq);
quit; 

	
	/*	proc contents data = seer.nchline_skin; 
		run; 	/* 16,706,149 observations */


		proc sql; 
		create table work.nchline_appearances as
		select patient_id,
		count(distinct clm_id) as n_clm_id
		from seer.nchline_skin
		group by patient_id;
		quit; 


		proc means data = work.nchline_appearances n mean std min q1 median q3 max;
		var n_clm_id;
		run;  /* 46,155 rows, meaning 46,155 unique IDs have a claim*/

		/* N Mean Std Dev Minimum Lower Quartile Median Upper Quartile Maximum 
46155 170.5236052 155.9591803 1.0000000 52.0000000 138.0000000 245.0000000 2717.00 
*/	


/* NCH: Find ICI and chemo administration using HCPCS codes */

/* ICI */ 

	/* source: https://www.sciencedirect.com/science/article/pii/S2667026724000365?via%3Dihub */ 
	/* source: https://seer.cancer.gov/oncologytoolbox/canmed/hcpcs/?q=&hcpcs=&added_date=01%2F01%2F2013&added_date=12%2F31%2F2019&seerrxcategory.raw=Immunotherapy&paginate_by=25 */
		
	data seer.nch_skin_ici; 
	set seer.nchline_skin;
	where HCPCS_CD in('J9228', 'J9271', 'J9299', 'J9022', 'J9024', 'J9298', 
	'J9289', 'C9027', 'C9453', 'C9483', 'C9284');
	run; /*17513 unique records */
	proc freq data = seer.nch_skin_ici; 
		table HCPCS_CD;
		run;
	proc sql; 
		create table seer.nch_skin_ici_appearances as
		select patient_id,
		count(distinct clm_id) as n_clm_id
		from seer.nch_skin_ici
		group by patient_id;
		quit; 

		proc means data = seer.nch_skin_ici_appearances n mean std min q1 median q3 max;
		var n_clm_id;
		run; /* 1283 unique record IDs with a total of 17,513 claims for an ICI in nch files */


/* 
	Chemotherapy */
/* Note: this does not include TKIs and other CANMed-defined "chemotherapy" that don't have HCPCS code- need NDC, and therefore the Part D file for those exposures */

		/* source: supplemental figures, Jamie Heyward's paper: https://cdn.jamanetwork.com/ama/content_public/journal/oncology/939658/coi250015supp1_prod_1752269267.15894.pdf?Expires=1766100855&Signature=apdTbQSpEPzmUeTUC~dMKfdPjpyycIYpUC5O05OclhZN7pKcQSxjcO~aBKzOdvtXpGvoJZ1WSCmaNj4r9O364C1VwuDErf0DtFU3sJ~RtNdwPjCwTTqbaTNc~-M63~nb174HezvuEsIofcKlt-NA8wYa8AIHDGkCPzftcw~0XRCDVHgck-cP~DX53kB0PjaLe-ylXxNmbLo-PEMGuUiGzqs8-QmU44e0AwRmK7c5HUZ9QX~D3Ab9yMoM4G-EJmPynNDXtv2ML8QRQ2jxm5GPKFdr2CnudRHimv06tBc8KGv8mOm-EM4ZLKuR5EuTpmfYyms~8AQ-sNNH2kMpi1ITBw__&Key-Pair-Id=APKAIE5G5CRDK6RD3PGA
		/* source: NCCN guidelines: https://www.nccn.org/patients/guidelines/content/PDF/melanoma-patient.pdf */ 
		/* source for med codes: CANMed database: https://seer.cancer.gov/oncologytoolbox/canmed/hcpcs/?q=&hcpcs=&added_date=01%2F01%2F2013&added_date=12%2F31%2F2019&seerrxcategory.raw=Chemotherapy&paginate_by=25 */

	/* Eligible chemo molecules (Jamie's original list for NSCLC): 
	Carboplatin
	Cisplatin
	Docetaxel /* confirmed, was never approved for melanoma 
	Etoposide /* confirmed, was never approved for melanoma
	Gemcitabine /* confirmed, was never approved for melanoma
	Paclitaxel
	Pemetrexed /* confirmed, was never approved for melanoma
	Vinorelbine /* confirmed, was never approved for melanoma

	/* Eligible chemo molecules (SK final list  for melanoma):
	Carboplatin
	Cisplatin
	Dacarbazine (DTIC) 
	Nab-paclitaxel 
	Paclitaxel
	Temozolomide (Temodar) 
	*/
	

	data seer.nch_skin_chemo; 
	set seer.nchline_skin;
	where HCPCS_CD in('J9045', 'J9060', 'J9130', 'J9264', 'J9265', 'J9267', 'C9253', 'J9328', 'C1086', 'J8700');
	run; /* 1516 chemo obs */

	proc freq data = seer.nch_skin_chemo; 
		table HCPCS_CD;
		run;
	proc sql; 
		create table seer.nch_skin_chemo_appearances as
		select patient_id,
		count(distinct clm_id) as n_clm_id
		from seer.nch_skin_chemo
		group by patient_id;
		quit; 

	proc means data = seer.nch_skin_chemo_appearances n mean std min q1 median q3 max;
		var n_clm_id;
		run; /*166 unique pts with 1516 total claims for chemo in nch files */


/* Filter Outpatient revenue file for skin cancer patient list */ 
/*
proc sql; 
create table seer.outrev_skin as
select *
from raw.outrevenue
where patient_id in(select distinct patient_id from seer.pat_dx_site_year_stage_seq);
quit; 


	/* No. of observations */
	/*
		proc contents data = seer.outrev_skin; 
		run;  /* 7,782,510*/
/*
		proc sql; 
		create table seer.outrev_appearances as
		select patient_id,
		count(distinct clm_id) as n_clm_id
		from seer.outrev_skin
		group by patient_id;
		quit; 

		proc means data = seer.outrev_appearances n mean std min q1 median q3 max;
		var n_clm_id;
		run; /* 38,853 unique pts have a claim in outrev file */


		/* 
N Mean Std Dev Minimum Lower Quartile Median Upper Quartile Maximum 
38853 31.1845160 36.9817621 1.0000000 8.0000000 19.0000000 40.0000000 508.0000000 

		*/ 


/* Outpatient : Find ICI and chemo administration using HCPCS codes. Targeted therapy via IV not applicable for melanoma */

/* ICI */ 

	/* source: https://www.sciencedirect.com/science/article/pii/S2667026724000365?via%3Dihub */ 
	/* source: https://seer.cancer.gov/oncologytoolbox/canmed/hcpcs/?q=&hcpcs=&added_date=01%2F01%2F2013&added_date=12%2F31%2F2019&seerrxcategory.raw=Immunotherapy&paginate_by=25 */
		

	data seer.outrev_skin_ici; 
	set seer.outrev_skin;
	where HCPCS_CD in('J9228', 'J9271', 'J9299', 'J9022', 'J9024', 'J9298', 
	'J9289', 'C9027', 'C9453', 'C9483','C9284');
	run;
	/* check outrev_skin_ici */
	proc contents data = seer.outrev_skin_ici; 
	run;
    
		proc sql; 
		create table seer.outrev_skin_ici_appearances as
		select patient_id,
		count(distinct clm_id) as n_clm_id
		from seer.outrev_skin_ici
		group by patient_id;
		quit; 

		proc means data = seer.outrev_skin_ici_appearances n mean std min q1 median q3 max;
		var n_clm_id;
		run; /*2427 unique pts with an ICI claim in the outrev file */

/* Chemo, etc */
/* Note: this does not include TKIs and other CANMed-defined "chemotherapy" that don't have HCPCS code- need NDC, and therefore the Part D file for those exposures */

		/* source: NCCN guidelines: https://jnccn.org/view/journals/jnccn/20/5/article-p497.xml */ 
		/* source for med codes: CANMed database: https://seer.cancer.gov/oncologytoolbox/canmed/hcpcs/?q=&hcpcs=&added_date=01%2F01%2F2013&added_date=12%2F31%2F2019&seerrxcategory.raw=Chemotherapy&paginate_by=25 */

	data seer.outrev_skin_chemo; 
	set seer.outrev_skin;
	where HCPCS_CD in('J9045', 'J9060', 'J9130', 'J9264', 'J9265', 'J9267', 'C9253', 'J9328', 'C1086', 'J8700');
	run; /*  1798 chemo observations in the outrev file*/
	proc sql; 
		create table seer.outrev_skin_chemo_appearances as
		select patient_id,
		count(distinct clm_id) as n_clm_id
		from seer.outrev_skin_chemo
		group by patient_id;
		quit; 
	proc means data = seer.outrev_skin_chemo_appearances n mean std min q1 median q3 max;
		var n_clm_id;
		run; /*250 unique pts with 1,798 chemo obs in the outrev file */


/*load PDE files to explore oral targeted therapy patterns */

	/* 2012-2013 PDE files */
/*proc sql;
create table seer.pde_skin_1213 as
select *
from raw.pdesaf1213
where patient_id in(select distinct patient_id from seer.pat_dx_site_year_stage_seq);
quit; /*494,072 rows and 43 columns*/


	/* 2014-2019 PDE files */
/*proc sql;
create table seer.pde_skin_1419 as
select *
from raw.pdesaf1419
where patient_id in(select distinct patient_id from seer.pat_dx_site_year_stage_seq);
quit; /* 6,820,906 rows and 43 columns */
	
/*proc contents data = seer.pde_skin_1213;
run;
proc contents data = seer.pde_skin_1419;
run;


/* Merge the 2 datasets conserving common data columns-- 40/42 of the 2012-2013 data columns and 40/43 of the 2014-2019 data columns */ 
/*data seer.pde_skin;
set seer.pde_skin_1213 (keep = BENEFIT_PHASE BN BRND_GNRC_CD CMPND_CD CTSTRPHC_CVRG_CD CVRD_D_PLAN_PD_AMT DAW_PROD_SLCTN_CD DAYS_SUPLY_NUM DRUG_CVRG_STUS_CD DSPNSNG_STUS_CD FILL_NUM FORMULARY_ID FRMLRY_RX_ID GCDF GCDF_DESC GDC_ABV_OOPT_AMT GDC_BLW_OOPT_AMT GNN LICS_AMT NCVRD_PLAN_PD_AMT OTHR_TROOP_AMT PATIENT_ID PDE_ID PDE_PRSCRBR_ID_FRMT_CD PD_DT PHRMCY_SRVC_TYPE_CD PLAN_CNTRCT_REC_ID PLAN_PBP_REC_NUM PLRO_AMT PRCNG_EXCPTN_CD PROD_SRVC_ID PTNT_PAY_AMT PTNT_RSDNC_CD QTY_DSPNSD_NUM RPTD_GAP_DSCNT_NUM RX_ORGN_CD SRVC_DT STR SUBMSN_CLR_CD TOT_RX_CST_AMT)
seer.pde_skin_1419 (keep = BENEFIT_PHASE BN BRND_GNRC_CD CMPND_CD CTSTRPHC_CVRG_CD CVRD_D_PLAN_PD_AMT DAW_PROD_SLCTN_CD DAYS_SUPLY_NUM DRUG_CVRG_STUS_CD DSPNSNG_STUS_CD FILL_NUM FORMULARY_ID FRMLRY_RX_ID GCDF GCDF_DESC GDC_ABV_OOPT_AMT GDC_BLW_OOPT_AMT GNN LICS_AMT NCVRD_PLAN_PD_AMT OTHR_TROOP_AMT PATIENT_ID PDE_ID PDE_PRSCRBR_ID_FRMT_CD PD_DT PHRMCY_SRVC_TYPE_CD PLAN_CNTRCT_REC_ID PLAN_PBP_REC_NUM PLRO_AMT PRCNG_EXCPTN_CD PROD_SRVC_ID PTNT_PAY_AMT PTNT_RSDNC_CD QTY_DSPNSD_NUM RPTD_GAP_DSCNT_NUM RX_ORGN_CD SRVC_DT STR SUBMSN_CLR_CD TOT_RX_CST_AMT);
run;
/**/
proc print data = seer.pde_skin (obs = 100);
run;
/**/
proc sql;
create table work.pde_appearances as
select patient_id,
count(distinct pde_id) as n_pde_id
from seer.pde_skin
group by patient_id;
quit;
/**/
proc means data = work.pde_appearances n mean std min q1 median q3 max;
var n_pde_id;
run; 
		/*
Analysis Variable : n_pde_id  
N Mean Std Dev Minimum Lower Quartile Median Upper Quartile Maximum 
45,749 187.8144440 179.8422577 1.0000000 69.0000000 144.0000000 250.0000000 4061.00 

/* Part D file: Define Melanoma-specific TKIs */
data seer.pde_skin_tki;
set seer.pde_skin;  

/* BRAF Inhibitors */
if PROD_SRVC_ID in('50242009001', '50242009002', '50242009086') then TKI_name = 'VEMURAFENIB';
else if PROD_SRVC_ID in('00173084708', '00173084608', '00173084761', '00173084765', '00078068166', '00078068266','00078115421' ) then TKI_name = 'DABRAFENIB';
else if PROD_SRVC_ID in('70255002501', '70255002503', '70255002001') then TKI_name = 'ENCORAFENIB';

/* MEK Inhibitors */
else if PROD_SRVC_ID in('00173084813', '00078066615', '00173084913', '00173085813', '00078066815', '00173084865' ) then TKI_name = 'TRAMETINIB';
else if PROD_SRVC_ID in('50242071701', '50242071786') then TKI_name = 'COBIMETINIB';
else if PROD_SRVC_ID in('70255001003', '70255001002' ) then TKI_name = 'BINIMETINIB';

else delete;  /* Remove non-melanoma TKIs */
run;

proc freq data = seer.pde_skin_tki;
table TKI_name;
run;
/*
TKI_name Frequency Percent Cumulative
Frequency Cumulative
Percent 
BINIMETINIB 350 4.86 350 4.86 
COBIMETINIB 220 3.05 570 7.91 
DABRAFENIB 2824 39.17 3394 47.08 
ENCORAFENIB 340 4.72 3734 51.80 
TRAMETINIB 2741 38.02 6475 89.82 
VEMURAFENIB 734 10.18 7209 100.00 

*/
/* unique ID with a tki */
proc sql;
create table tki_appearances as
select patient_id,
count(distinct pde_id) as n_pde_id
from seer.pde_skin_tki
group by patient_id;
quit;
/**/
proc means data = tki_appearances n mean std min q1 median q3 max;
var n_pde_id;
run;	/*617 unique pts with a tki prescribed */

proc print data = seer.pde_skin_tki (obs = 50);
run; 

/* explore ICI use in pde files */
data seer.pde_skin_ici;
set seer.pde_skin;  

/* ICI NDC codes */
if PROD_SRVC_ID in('00003232822', '00003232711' ) then ICI_name = 'ipilimumab';
else if PROD_SRVC_ID in('00006302602', '00006302902', '00006302604', '00006302601', '00006302901' ) then ICI_name = 'pembrolizumab';
else if PROD_SRVC_ID in('00003373413', '00003377412', '00003377211') then ICI_name = 'nivolumab';
 /* ALSO search by generic name (catches any with missing NDCs) */
    else if upcase(GNNM) contains 'IPILIMUMAB' then ICI_name = 'Ipilimumab';
    else if upcase(GNNM) contains 'PEMBROLIZUMAB' then ICI_name = 'Pembrolizumab';
    else if upcase(GNNM) contains 'NIVOLUMAB' then ICI_name = 'Nivolumab';
    
else delete;  /* Remove non-melanoma ICIs */
run;

proc freq data = seer.pde_skin_ici;
table ICI_name patient_id;
run;
proc sql;
    select 
        ICI_name,
        count(distinct patient_id) as n_unique_patients,
        count(*) as n_total_claims
    from seer.pde_skin_ici
    group by ICI_name;
quit; /* 20 unique pts with 45 total NDC claim for an ICI */

/* Combine the datasets */ 

	/* NCH */
	data seer.nch_skin_tx;
	length record_source $ 20; /* allows for enough room for NCH line and Outpatient rev variables*/
	set seer.nch_skin_ici seer.nch_skin_chemo;
	record_source = "NCH Line";
	run; 
	
	/* Outpat rev */ 
	data seer.outrev_skin_tx;
	length record_source $ 20;
	set seer.outrev_skin_ici seer.outrev_skin_chemo;
	record_source = "Outpatient Rev";
	run; 

	/* Combine NCH and Outpatient files, conserving just a few common data columns */ 
	data seer.combined_nch_outrev_skin_tx;
	set seer.nch_skin_tx (keep = patient_id clm_id HCPCS_CD CLM_THRU_DT record_source) seer.outrev_skin_tx (keep = patient_id clm_id HCPCS_CD CLM_THRU_DT record_source);
	run; 
	proc freq data=seer.combined_nch_outrev_skin_tx;
tables record_source / missing;
run;
proc sql;
    select count(distinct patient_id) as unique_patients
    from seer.combined_nch_outrev_skin_tx;
quit;

/* record_source Frequency Percent Cumulative
Frequency Cumulative
Percent 
NCH Line 19029 37.57 19029 37.57 
Outpatient Rev 31626 62.43 50655 100.00 
*/
/*50,655 out of the original ~63k unique pts have a claim in the combined NCH & outpatient files*/

 /* Label the HCPCS codes with drug ICI names */

data seer.combined_nch_outrev_skin_tx;
	length ICI_name$ 15;
	length chemo_name$ 25; 
	set seer.combined_nch_outrev_skin_tx; 
	if HCPCS_CD in ('J9228') then ICI_name = 'IPILIMUMAB';
else if HCPCS_CD in ('J9271', 'C9027') then ICI_name = 'PEMBROLIZUMAB';
else if HCPCS_CD in ('J9299', 'C9453', 'J9289') then ICI_name = 'NIVOLUMAB';
else if HCPCS_CD in ('J9022', 'C9483', 'J9024') then ICI_name = 'ATEZOLIZUMAB';
else if HCPCS_CD in ('J9298') then ICI_name = 'NIVOLUMAB-RELATLIMAB';
else ICI_name = '.';
	if HCPCS_CD in ('J9045') then chemo_name = 'CARBOPLATIN';
	else if HCPCS_CD in ('J9060') then chemo_name = 'CISPLATIN';
	else if HCPCS_CD in ('J9130') then chemo_name = 'DACARBAZINE';
	else if HCPCS_CD in ('J9264') then chemo_name = 'NAB-PACLITAXEL';
	else if HCPCS_CD in ('J9265', 'J9267') then chemo_name = 'PACLITAXEL';
	else if HCPCS_CD in ('C9253', 'J9328','C1086', 'J8700') then chemo_name = 'TEMOZOLOMIDE';
	else chemo_name = '.';
run;

/* Homogenize the claim ID, date, and  drug name fields for combination with the TKI exposure data */ 
data combined_nch_outrev_skin_tx;
length TKI_name$ 30;
set seer.combined_nch_outrev_skin_tx; 
record_id = clm_id; 
record_dt = clm_thru_dt;
drug_cd = HCPCS_cd; 
TKI_name ='.';
run; 
proc print data = combined_nch_outrev_skin_tx (obs = 20);
run;
proc sql;
    select count(distinct patient_id) as unique_patients
    from seer.combined_nch_outrev_skin_tx;
quit;

data pde_skin_tki;
length ICI_name$ 30;
length chemo_name$ 30;
set seer.pde_skin_tki;
record_id = pde_id;
record_dt = srvc_dt; 
drug_cd = prod_srvc_id; 
record_source = "Part D";
ICI_name ='.';
chemo_name ='.';
run;

proc print data = pde_skin_tki (obs = 50);
run;

/* Combine PDE data on TKI with the chemo and ICI exposure history */
data seer.combined_nch_outrev_pde_skin_tx;
set combined_nch_outrev_skin_tx (keep = patient_id record_id record_dt record_source ICI_name chemo_name TKI_name) pde_skin_tki (keep = patient_id record_id record_dt record_source ICI_name chemo_name TKI_name);
run;

proc sort data = seer.combined_nch_outrev_pde_skin_tx;
by patient_id record_dt;
run;
proc sql;
    select count(distinct patient_id) as unique_patients
    from seer.combined_nch_outrev_pde_skin_tx;
quit;

proc print data = seer.combined_nch_outrev_pde_skin_tx (obs = 20);
run; 
proc sql;
    select count(distinct record_id) as unique_records
    from seer.combined_nch_outrev_pde_skin_tx;
quit; /*44,645 unique records*/
proc sql;
    select count(distinct patient_id) as unique_patient
    from seer.combined_nch_outrev_pde_skin_tx;
quit; /*4175 unique patients have at least one ICI, CT, or TKI claim */

proc sql;
    select count(distinct patient_id) as total_cohort
    from seer.seer2;  
quit;
proc sql;
    select 'NCH' as source, count(distinct patient_id) as n_patients
    from seer.nch_skin_tx
    union
    select 'OUTREV' as source, count(distinct patient_id) as n_patients
    from seer.outrev_skin_tx
    union
    select 'PDE' as source, count(distinct patient_id) as n_patients
    from seer.pde_skin_tki;
quit;
proc sql;
    select count(distinct patient_id) as pts_with_ici
    from seer.nch_outrev_pde_skin_ici_only
    where ICI_name ne '.';
quit; /* out of 4174 pts with any tx claim, 3537 have an ICI claim */
proc print data = seer.nch_outrev_pde_skin_ici_only (obs =15);
run;
proc contents data = seer.nch_outrev_pde_skin_ici_only;
run;

/*==============================================================*/
/*   FINAL SEER–MEDICARE ICI/CHEMO/TKI PIPELINE — CLEAN SCRIPT  */
/*==============================================================*/

/*-------------------------------------------------------------------*/
/* STEP 1: Restrict to TRUE ICI CLAIMS FROM ANY SOURCE               */
/*-------------------------------------------------------------------*/
data seer.tx_ici;
    set seer.combined_nch_outrev_pde_skin_tx;
    where ICI_name not in ('.', '', ' ');
run;

proc sort data=seer.tx_ici;
    by patient_id record_dt;
run;

/*-------------------------------------------------------------------*/
/* STEP 2: First ICI per patient  (FIXED)                             */
/*-------------------------------------------------------------------*/
proc sort data=seer.tx_ici;
    by patient_id record_dt;
run;

data first_ici;
    set seer.tx_ici;
    by patient_id;

    if first.patient_id then do;
        first_ici_date = input(strip(record_dt), anydtdte.);
        first_ici_drug = strip(ICI_name);
        format first_ici_date date9.;
        output;
    end;

    keep patient_id first_ici_date first_ici_drug;
run;

/*QC*/
proc sql;
  select count(*) as n_rows,
         count(distinct patient_id) as n_pats,
         sum(missing(first_ici_date)) as n_missing_first_ici_date
  from first_ici;
quit;
/*-------------------------------------------------------------------*/
/* STEP 3: First chemo per patient                                   */
/*-------------------------------------------------------------------*/
proc sort data=seer.combined_nch_outrev_pde_skin_tx out=tx_all;
    by patient_id record_dt;
run;

data first_chemo;
    set tx_all;
    where chemo_name not in ('.', '', ' ');
    by patient_id;
    if first.patient_id then do;
        first_chemo_date = input(record_dt, yymmdd8.);
        first_chemo_drug = chemo_name;
        format first_chemo_date date9.;
        keep patient_id first_chemo_date first_chemo_drug;
    end;
run;

/*-------------------------------------------------------------------*/
/* STEP 4: First TKI per patient                                     */
/*-------------------------------------------------------------------*/
data first_tki;
    set tx_all;
    where tki_name not in ('.', '', ' ');
    by patient_id;
    if first.patient_id then do;
        first_tki_date = input(record_dt, yymmdd8.);
        first_tki_drug = tki_name;
        format first_tki_date date9.;
        keep patient_id first_tki_date first_tki_drug;
    end;
run;



/*-------------------------------------------------------------------*/
/* STEP 5: Merge SEER + Tx Dates To Compute ICI Timing               */
/*-------------------------------------------------------------------*/
proc sql;
    create table seer.skin_melanoma_ici_tx as
    select 
        a.*,
        b.first_ici_date,
        b.first_ici_drug,
        1 as ici_use,

        /* ICI timing relative to diagnosis */
        case
            when a.DX_DATE = . then .
            when b.first_ici_date < a.DX_DATE then 0
            when b.first_ici_date >= a.DX_DATE then 1
        end as ici_after_dx,

        (b.first_ici_date - a.DX_DATE)/30.44 as months_dx_to_ici format=8.1,

        /* Chemo */
        c.first_chemo_date,
        c.first_chemo_drug,
        (c.patient_id > '') as chemo_use,
        case 
            when c.first_chemo_date = . or a.DX_DATE = . then .
            when c.first_chemo_date < a.DX_DATE then 0
            when c.first_chemo_date >= a.DX_DATE then 1
        end as chemo_after_dx,
        (c.first_chemo_date - a.DX_DATE)/30.44 as months_dx_to_chemo format=8.1,

        /* TKI */
        d.first_tki_date,
        d.first_tki_drug,
        (d.patient_id > '') as tki_use,
        case 
            when d.first_tki_date = . or a.DX_DATE = . then .
            when d.first_tki_date < a.DX_DATE then 0
            when d.first_tki_date >= a.DX_DATE then 1
        end as tki_after_dx,
        (d.first_tki_date - a.DX_DATE)/30.44 as months_dx_to_tki format=8.1

    from seer.seer2 as a
    inner join first_ici as b on a.patient_id = b.patient_id
    left join first_chemo as c on a.patient_id = c.patient_id
    left join first_tki   as d on a.patient_id = d.patient_id;
quit;

/*-------------------------------------------------------------------*/
/* STEP 6: Keep valid diagnosis dates                                */
/*-------------------------------------------------------------------*/
data seer.skin_melanoma_analysis;
    set seer.skin_melanoma_ici_tx;
    where DX_DATE ne .;
run;

/*-------------------------------------------------------------------*/
/* STEP 7: PATIENT-LEVEL ICI TIMING CLASSIFICATION                   */
/*-------------------------------------------------------------------*/
/* --------------------------------------*/
/*      THIS IS WHERE THE PREVALENT ICI USERS ARE IDENTIFIED       */
/*-------------------------------------------------------------------*/

proc sql;
    create table seer.ici_patient_level as
    select patient_id,
           max(case when ici_after_dx = 0 then 1 else 0 end) as any_pre_dx,
           max(case when ici_after_dx = 1 then 1 else 0 end) as any_post_dx
    from seer.skin_melanoma_analysis
    group by patient_id;
quit;

/*-------------------------------------------------------------------*/
/* Create final incident / prevalent user classification             */
/*-------------------------------------------------------------------*/
data seer.ici_patient_level;
    set seer.ici_patient_level;

    length ici_user_type $12;

    if any_pre_dx = 1 then ici_user_type = "Prevalent";   /* <-- 4 USERS HERE */
    else if any_post_dx = 1 then ici_user_type = "Incident"; /* <-- 3533 USERS */
    else ici_user_type = "Unknown";
run;

proc freq data=seer.ici_patient_level;
    tables ici_user_type / missing;
run;

/*-------------------------------------------------------------------*/
/* STEP 8: Keep final INCIDENT cohort only (3533 patients)           */
/*-------------------------------------------------------------------*/
proc sql;
    create table seer.incident_ici_ids as
    select patient_id
    from seer.ici_patient_level
    where ici_user_type = "Incident";
quit;
proc contents data=seer.incident_ici_ids;
run;

/*-------------------------------------------------------------------*/
/* STEP 9: FINAL TX DATASET FOR JUST THE 3533 INCIDENT USERS         */
/*-------------------------------------------------------------------*/
proc sql;
    create table seer.tx_all_final_3533 as
    select *
    from seer.combined_nch_outrev_pde_skin_tx
    where patient_id in (select patient_id from seer.incident_ici_ids);
quit;

/*==============================================================*/
/* END CLEAN PIPELINE                                           */
/*==============================================================*/
proc contents data=seer.tx_all_final_3533;
run;

