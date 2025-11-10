
*******************************************************************************;
* Program name      :	xx_cohort_derivation_1
* Author            :	
* Date created      :	
* Study             : 	
* Purpose           :	
* Inputs            :	
* Program completed : 	
* Updated by        : Xinyi Sun, 09-30-2024
*********************************************************************************;


LIBNAME seer 'S:\Pharmacoepi0216\Thesis';


/* */

/* Define cancer primary site of interest for lung cancer */
proc freq data = seer.seer_lung; 
table PRIMARY_SITE;
run; 

/* Filter on primary site is C340-C349 */
data lung_primary; 
set seer.seer_lung;
where PRIMARY_SITE in:('C34');
run; 

proc freq data = lung_primary;
table PRIMARY_SITE;
run; 

/*
Primary Site 
PRIMARY_SITE Frequency Percent Cumulative
Frequency Cumulative
Percent 
C340 15538 3.27 15538 3.27 
C341 235374 49.61 250912 52.88 
C342 20269 4.27 271181 57.15 
C343 127366 26.84 398547 84.00 
C348 4599 0.97 403146 84.97 
C349 71321 15.03 474467 100.00 
*/

/* Filter on NSCLC only? Histology variables? */

/* Here is a list of morphology codes for each subtype of lung cancer 
(in SAS file, "_" are zeroes and there are slashes before behavior code (last digit)).

https://www.training.seer.cancer.gov/lung/abstract-code-stage/morphology.html 

*/

/* Full guide on lung cancer histology codes
https://seer.cancer.gov/tools/solidtumor/Lung_STM.pdf */ 

/* 

Small cell lung cancers include ICD-O morphology codes M-80413, M-80423, M-80433, M-80443, and M-80453. Small cell carcinoma is also called oat cell, round cell, reserve cell, or small cell intermediate cell carcinoma. Small cell cancers are usually central lesions (in the bronchus or toward the center or hilum of the lung). Occasionally, mixed tumors containing small cells and non-small cells are diagnosed. These should be treated as small cell cancers.

Common non-small cell lung cancer histologies:

Squamous or epidermoid (807_3)
Least likely to recur after resection; frequently a central or bronchial lesion.
Adenocarcinoma (814_3)
Usually slow-growing, but can metastasize widely; usually a peripheral lesion.
Bronchioloalveolar (82503)
Avery specific subtype of adenocarcinoma with a distinct characteristic presentation and behavior. Bronchioloalveolar adenocarcinomas arise in the alveolar sacs in the lungs.
Large cell carcinoma (80123)
Also called giant cell or clear cell
Other subtypes of adenocarcinoma are acinar, papillary, and mucinous.
Adenosquamous carcinoma (85603)
A specific histologic variant containing both epithelial (squamous) and glandular (adeno-) cells.
Carcinoids (824_3)
Arise from neuroectoderm (which generates supporting structures of lung). Melanomas, sarcomas and lymphomas may also arise in the lung.
Mesothelioma (905_3)
Linked to asbestos exposure; usually involves the pleura, not the lung.
Non-small cell carcinoma (80463)
A general term used sloppily to separate small cell from the "non-small cell" types (such as adenocarcinoma, squamous cell carcinoma, large cell, etc.) of carcinomas. Only use 8046/3 when there is no other type of non-small cell carcinoma contained in the source documents.

*/

data lung_primary; 
set lung_primary; 
HIST_ICD_O_3_MERGE = catx("/", HISTOLOGIC_TYPE_ICD_O_3, Behavior_code_ICD_O_3); 
run; 

proc freq data = lung_primary;
table HIST_ICD_O_3_MERGE; 
run; 

/* Categorize cancers as NSCLC=1 (NSCLC), NSCLC=0 (SCLC), or NSCLC=2 (unclear from website, can categorize with better source ) */
data lung_primary; 
set lung_primary;
if HIST_ICD_O_3_MERGE in:('8041/3', '8042/3', '8043/3', '8044/3', '8045/3') then NSCLC = 0;
else if HIST_ICD_O_3_MERGE in:('8070/3', '8140/3', '8250/3', '8012/3', '8560/3', '8240/3', '9050/3', '8046/3') then NSCLC = 1; 
else NSCLC = 2; 
run; 

data seer.lung_primary; 
set lung_primary; 
run; 

proc freq data = lung_primary;
table NSCLC*HIST_ICD_O_3_MERGE;
run; 

proc freq data = lung_primary;
table NSCLC;
run; 

/* Restrict to NSCLC = 1 or 2 (not SCLC, which corresponds to NSCLC = 0) */ 
data lung_primary_nsclc; 
set lung_primary; 
where NSCLC in (1,2); 
run; 


/* Define year of cancer dx */ 
proc freq data = lung_primary_nsclc; 
table YEAR_OF_DIAGNOSIS;
run; 

/* Filter on dx in 2013 or sooner */
data lung_primary_nsclc_incident; 
set lung_primary_nsclc;
where YEAR_OF_DIAGNOSIS in('2013', '2014', '2015', '2016', '2017', '2018', '2019');
run; 

proc freq data = lung_primary_nsclc_incident;
table YEAR_OF_DIAGNOSIS;
run;


/* 
Year of Diagnosis 
YEAR_OF_DIAGNOSIS Frequency Percent Cumulative
Frequency Cumulative
Percent 
2013 58250 14.17 58250 14.17 
2014 59013 14.35 117263 28.52 
2015 59855 14.56 177118 43.08 
2016 59959 14.58 237077 57.66 
2017 59991 14.59 297068 72.25 
2018 57733 14.04 354801 86.30 
2019 56344 13.70 411145 100.00 
 
*/


/* Alternative: Filter on tx for cancer began in 2013 or sooner (this would be time 0)
(NOTE*** This filters out a significant proportion of cases, as many appear not to have
treatment coded using this variable */

proc freq data = lung_primary;
table YEAR_THERAPY_STARTED;
run;

/* data lung_primary_incident; 
set lung_primary;
where YEAR_THERAPY_STARTED in('2013', '2014', '2015', '2016', '2017', '2018', '2019');
run; */

/* proc freq data = lung_primary_incident;
table YEAR_OF_DIAGNOSIS;
run; */

/*
Year of Diagnosis 
YEAR_OF_DIAGNOSIS Frequency Percent Cumulative Frequency Cumulative Percent 
2002 1 0.00 1 0.00 
2010 2 0.00 3 0.00 
2011 1 0.00 4 0.00 
2012 184 0.07 188 0.07 
2013 36661 13.59 36849 13.66 
2014 37628 13.95 74477 27.61 
2015 38423 14.24 112900 41.85 
2016 39009 14.46 151909 56.31 
2017 39228 14.54 191137 70.85 
2018 37916 14.05 229053 84.90 
2019 40727 15.10 269780 100.00 
*/

proc freq data = lung_primary_incident;
table YEAR_THERAPY_STARTED;
run;

/*
Year Therapy Started 
YEAR_THERAPY_STARTED Frequency Percent Cumulative
Frequency Cumulative
Percent 
2013 33502 12.42 33502 12.42 
2014 37243 13.80 70745 26.22 
2015 38234 14.17 108979 40.40 
2016 38770 14.37 147749 54.77 
2017 39124 14.50 186873 69.27 
2018 37868 14.04 224741 83.31 
2019 45039 16.69 269780 100.00 
*/


/* Filter on age at dx (in years) >= 66 (due to 1-year continuous enrollment requirement they need to have been at least 66 at time of cohort entry
so they would have been Medicare-eligible for at least a year */

proc freq data = lung_primary_nsclc_incident;
table Agerecodewithsingleages_and_100; 
run; 


	/* 16% of the patients are <66 at time of dx; need to filter them out */ 

data seer.lung_primary_nsclc_incident_65; 
set lung_primary_nsclc_incident;
AGE_AT_DX_NUMERIC = input(Agerecodewithsingleages_and_100, 3.);
run;

data seer.lung_primary_nsclc_incident_65; 
set seer.lung_primary_nsclc_incident_65;
where AGE_AT_DX_NUMERIC >65;
run;




/* Filter on first cancer dx during follow-up window */ 
/* No. of appearances per ID */ 
		proc sort data = seer.lung_primary_nsclc_incident_65;
		by patient_id;
		run; 

			data seer.lung_primary_nsclc_incident_65;
			set seer.lung_primary_nsclc_incident_65;
			by patient_id;
			first_dx = first.patient_id;
			if first.patient_id then dx_count = 1;
			else dx_count +1;
			run; 

				proc print data = seer.lung_primary_nsclc_incident_65 (obs = 50); 
				run; 


				/* Total dx during follow-up */ 
				proc sort data = seer.lung_primary_nsclc_incident_65; 
				by patient_id descending dx_count; 
				run; 

			data seer.lung_primary_nsclc_incident_65; 
			set seer.lung_primary_nsclc_incident_65;
			by patient_id; 
			if first.patient_id then total_dx = dx_count; 
			retain total_dx; 
			run; 

				proc sort data = seer.lung_primary_nsclc_incident_65;
				by patient_id dx_count; /*Ascending*/
				run; 

					proc print data = seer.lung_primary_nsclc_incident_65 (obs = 50); 
					run; 

			proc freq data = seer.lung_primary_nsclc_incident_65; 
			where first_dx = 1;
			table total_dx;
			run; 

					/*
				total_dx Frequency Percent CumulativeFrequency CumulativePercent 
					1 324334 97.19 324334 97.19 
					2 8957 2.68 333291 99.87 
					3 390 0.12 333681 99.99 
					4 31 0.01 333712 100.00 
					5 3 0.00 333715 100.00 
					*/

				/* ~3% of patients had more than 1 dx between 2013-2019, need to remove the records for subsequent dx after the first. */

			/* Restrict to first dx per patient */ 
			data seer.lung_primary_nsclc_incident_65_1; 
			set seer.lung_primary_nsclc_incident_65;
			where first_dx=1; 
			run; 

				proc contents data = seer.lung_primary_nsclc_incident_65_1;
				run; 

				/* 333715 total records */ 

				proc freq data = seer.lung_primary_nsclc_incident_65_1 nlevels; 
				table patient_id /noprint;
				run; 

				/* 333715 unique patient ID */ 




/* Describe cohort [NOTE- haven't run again with SCLC excluded] */ 

proc contents data = seer.lung_primary_nsclc_incident_65_1;
run;

proc print data = seer.lung_primary_nsclc_incident_65_1 (obs = 10); 
run; 

				proc contents data = seer.lung_primary_nsclc_incident_65_1;
				run; 

					/* 400500 records */ 

				proc freq data = seer.lung_primary_nsclc_incident_65_1 nlevels; 
				table patient_id /noprint;
				run; 

					/* 389076 unique patient ID */ 



/* Age */ 

/* Single ages */
proc freq data = seer.lung_primary_nsclc_incident_65_1; 
table AGE_AT_DX_NUMERIC; 
run;

/* Age bands */
proc freq data = seer.lung_primary_nsclc_incident_65_1; 
table AGE_RECODE_WITH_1_YEAR_OLDS; 
run; 

/*
Age Recode with <1 Year Olds 
AGE_RECODE_WITH_1_YEAR_OLDS Frequency Percent Cumulative Frequency Cumulative Percent 
14 93071 23.24 93071 23.24 
15 101740 25.40 194811 48.64 
16 87940 21.96 282751 70.60 
17 64122 16.01 346873 86.61 
18 53627 13.39 400500 100.00 


Code Description
00 Age 00
01 Ages 01-04
02 Ages 05-09
03 Ages 10-14
04 Ages 15-19
05 Ages 20-24
06 Ages 25-29
07 Ages 30-34
08 Ages 35-39
09 Ages 40-44
10 Ages 45-49
11 Ages 50-54
12 Ages 55-59
13 Ages 60-64
14 Ages 65-69
15 Ages 70-74
16 Ages 75-79
17 Ages 80-84
18 Ages 85+
29 Unknown Age
*/


/*Didn't see this output*/
proc means data = seer.lung_primary_nsclc_incident_65_1 n mean std min q1 median q3 max;
var Agerecodewithsingleages_and_100;
run;


/* Sex */ 
proc freq data = seer.lung_primary_nsclc_incident_65_1;
table sex;
run; 

/*
Code Description
1 Male
2 Female
9 Not stated (unknown)
*/


/* Race */ 
proc freq data = seer.lung_primary_nsclc_incident_65_1;
table race_ethnicity;
run;

/*
Code Description
01 White
02 Black
03 American Indian, Aleutian, Alaskan Native or Eskimo 
(includes all indigenous populations of the Western 
hemisphere) 
04 Chinese
05 Japanese
06 Filipino
07 Hawaiian
08 Korean (Effective with 1/1/1988 dx)
10 Vietnamese (Effective with 1/1/1988 dx)
11 Laotian (Effective with 1/1/1988 dx)
12 Hmong (Effective with 1/1/1988 dx)
13 Kampuchean (including Khmer and Cambodian) (Effective 
with 1/1/1988 dx)
14 Thai (Effective with 1/1/1994 dx)
15 Asian Indian or Pakistani, NOS (Effective with 1/1/1988 dx)
16 Asian Indian (Effective with 1/1/2010 dx)
17 Pakistani (Effective with 1/1/2010 dx)
20 Micronesian, NOS (Effective with 1/1/1991)
21 Chamorran (Effective with 1/1/1991 dx)
22 Guamanian, NOS (Effective with 1/1/1991 dx)
25 Polynesian, NOS (Effective with 1/1/1991 dx)
26 Tahitian (Effective with 1/1/1991 dx)
27 Samoan (Effective with 1/1/1991 dx)
28 Tongan (Effective with 1/1/1991 dx) 
30 Melanesian, NOS (Effective with 1/1/1991 dx)
31 Fiji Islander (Effective with 1/1/1991 dx)
32 New Guinean (Effective with 1/1/1991 dx)
96 Other Asian, including Asian, NOS and Oriental, NOS 
(Effective with 1/1/1991 dx)
97 Pacific Islander, NOS (Effective with 1/1/1991 dx)
98 Other
99 Unknown

*/


/* Sequence number */ 
proc freq data = seer.lung_primary_nsclc_incident_65_1;
table sequence_number;
run; 

/*
In Situ/Malignant as Federally Required based on Diagnosis Year
Code Description
00 One primary only in the patient’s lifetime
01 First of two or more primaries
02 Second of two or more primaries
.. (Actual number of this primary)
59 Fifty-ninth of fifty-nine or more primaries
99 Unspecified or unknown sequence number of Federally required in situ or malignant 
tumors. Sequence number 99 can be used if there is a malignant tumor and its 
sequence number is unknown. (If there is known to be more than one malignant 
tumor, then the tumors must be sequenced.)
Non-malignant Tumor as Federally Required based on Diagnosis Year
Code Description
60 Only one non-malignant tumor or central registry-defined neoplasm
61 First of two or more non-malignant tumors or central registry-defined neoplasms
62 Second of two or more non-malignant tumors or central registry-defined neoplasms
.. ..
87 Twenty-seventh of twenty-seven
88 Unspecified or unknown sequence number of non-malignant tumor or central-registry 
defined neoplasms. (Sequence number 88 can be used if there is a non-malignant 
tumor and its sequence number is unknown. If there is known to be more than one 
non-malignant tumor, then the tumors must be sequenced.)
*/


/* Stage at dx */ 
proc freq data = seer.lung_primary_incident_65_first;
table combined_summary_stage_2004;
run; 

	/* What does this variable mean? What are categories? */


/* Primary site */ 
proc freq data = seer.lung_primary_nsclc_incident_65_1;
table PRIMARY_SITE;
run; 

/*
Primary Site 
PRIMARY_SITE Frequency Percent Cumulative Frequency Cumulative Percent 
C340 12748 3.18 12748 3.18 
C341 194605 48.59 207353 51.77 
C342 16740 4.18 224093 55.95 
C343 108862 27.18 332955 83.13 
C348 3800 0.95 336755 84.08 
C349 63745 15.92 400500 100.00 
*/

/*
ICD-O-2/3	Term
C34.0	Main bronchus
C34.1	Upper lobe, lung
C34.2	Middle lobe, lung (right lung only)
C34.3	Lower lobe, lung
C34.8	Overlapping lesion of lung
C34.9	Lung, NOS
*/

/* Laterality */ 
proc freq data = seer.lung_primary_nsclc_incident_65_1;
table LATERALITY;
run; 


/* 
Laterality 
LATERALITY Frequency Percent Cumulative
Frequency Cumulative
Percent 
0 532 0.13 532 0.13 
1 212874 53.15 213406 53.28 
2 152380 38.05 365786 91.33 
3 1255 0.31 367041 91.65 
4 3810 0.95 370851 92.60 
9 29649 7.40 400500 100.00 
*/

/* 
Code Description
0 Not a paired site
1 Right: origin of primary
2 Left: origin of primary
3 Only one side involved, right or left origin unspecified
4 Bilateral involvement, lateral origin unknown; stated to be single primary
• Both ovaries involved simultaneously, single histology
• Bilateral retinoblastomas
• Bilateral Wilms’s tumors
5 Paired site: midline tumor
9 Paired site, but no information concerning laterality; midline tumor
*/



/* Summary of cancer tx received */ 


/* Year first treatment started */ 

proc freq data = seer.lung_primary_nsclc_incident_65_1; 
table YEAR_THERAPY_STARTED; 
run; 

	/* If there is no year of treatment listed (missing), did they not receive tx? */ 


/* 
Year Therapy Started 
YEAR_THERAPY_STARTED Frequency Percent Cumulative
Frequency Cumulative
Percent 
1979 2 0.00 2 0.00 
1980 3 0.00 5 0.00 
1981 3 0.00 8 0.00 
1982 1 0.00 9 0.00 
1983 3 0.00 12 0.00 
1984 8 0.00 20 0.01 
1985 5 0.00 25 0.01 
1986 5 0.00 30 0.01 
1987 4 0.00 34 0.01 
1988 8 0.00 42 0.01 
1989 14 0.00 56 0.02 
1990 12 0.00 68 0.02 
1991 10 0.00 78 0.03 
1992 33 0.01 111 0.04 
1993 26 0.01 137 0.05 
1994 27 0.01 164 0.06 
1995 43 0.02 207 0.07 
1996 41 0.01 248 0.09 
1997 43 0.02 291 0.10 
1998 51 0.02 342 0.12 
1999 77 0.03 419 0.15 
2000 226 0.08 645 0.23 
2001 290 0.10 935 0.33 
2002 298 0.10 1233 0.43 
2003 418 0.15 1651 0.58 
2004 465 0.16 2116 0.74 
2005 551 0.19 2667 0.94 
2006 680 0.24 3347 1.18 
2007 817 0.29 4164 1.46 
2008 984 0.35 5148 1.81 
2009 1093 0.38 6241 2.19 
2010 1197 0.42 7438 2.61 
2011 1392 0.49 8830 3.10 
2012 1412 0.50 10242 3.60 
2013 33502 11.76 43744 15.36 
2014 37243 13.08 80987 28.44 
2015 38234 13.42 119221 41.86 
2016 38770 13.61 157991 55.47 
2017 39124 13.74 197115 69.21 
2018 37868 13.30 234983 82.51 
2019 45039 15.81 280022 98.32 
2020 4772 1.68 284794 100.00 
2021 4 0.00 284798 100.00 
Frequency Missing = 189669 
*/



/* Surgery of primary site */ 
proc freq data = seer.lung_primary_nsclc_incident_65_1;
table RX_SUMM_SURG_PRIM_SITE_1998;
run; 

/*
RX Summ-Surg Prim site 1998+ 
RX_SUMM_SURG_PRIM_SITE_1998 Frequency Percent Cumulative
Frequency Cumulative
Percent 
00 118881 71.27 118881 71.27 
12 347 0.21 119228 71.48 
13 96 0.06 119324 71.54 
15 174 0.10 119498 71.64 
19 54 0.03 119552 71.68 
20 183 0.11 119735 71.79 
21 9390 5.63 129125 77.42 
22 2588 1.55 131713 78.97 
23 282 0.17 131995 79.14 
24 163 0.10 132158 79.23 
25 18 0.01 132176 79.24 
30 3989 2.39 136165 81.64 
33 28110 16.85 164275 98.49 
45 782 0.47 165057 98.96 
46 313 0.19 165370 99.15 
47 31 0.02 165401 99.16 
48 32 0.02 165433 99.18 
55 220 0.13 165653 99.32 
56 706 0.42 166359 99.74 
65 7 0.00 166366 99.74 
66 11 0.01 166377 99.75 
70 17 0.01 166394 99.76 
80 42 0.03 166436 99.78 
90 236 0.14 166672 99.93 
99 123 0.07 166795 100.00 
Frequency Missing = 61774 
*/



/* Scope of regional lymph node surgery */ 
proc freq data = seer.lung_primary_nsclc_incident_65_1;
table RX_SUMM_SCOPE_REG_LN_SUR_2003;
run; 


/* Surgical procedure of other site */ 
proc freq data = seer.lung_primary_nsclc_incident_65_1;
table RX_SUMM_SURG_OTH_REG_DIS_2003;
run; 


/* Order in which surgery and radiation therapies were 
administered */ 
proc freq data = seer.lung_primary_nsclc_incident_65_1;
table RX_SUMM_SURG_RAD_SEQ;
run; 


/* Reason for no surgery */ 
proc freq data = seer.lung_primary_nsclc_incident_65_1;
table REASONNOCANCER_DIRECTED_SURGERY;
run; 

/* 
Code Description
0 Surgery performed
No surgery 
Code Description
1* Surgery not recommended
2* Contraindicated due to other conditions; Autopsy Only case
(1973-2002)
5 Patient died before recommended surgery
6 Unknown reason for no surgery
7* Patient or patient’s guardian refused
Unknown if surgery performed 
Code Description
8 Recommended, unknown if done
9 Unknown if surgery performed; Death Certificate Only 
case; Autopsy only case (2003+)
14 Blank
*Codes not used prior to 1988. Code ‘2’ used only for Autopsy Only cases prior to 1988.

*/


/* Radiation tx summary */ 
proc freq data = seer.lung_primary_nsclc_incident_65_1;
table RADIATION_RECODE;
run; 

/* 
Code Description
0 None/Unknown; diagnosed at autopsy
1 Beam radiation
2 Radioactive implants
3 Radioisotopes
4 Combination of 1 with 2 or 3
5 Radiation, NOS—method or source not specified
6 Other radiation (1973-1987 cases only)
7 Patient or patient's guardian refused radiation therapy
8 Radiation recommended, unknown if administered
*/ 


/* Sequencing of systemic therapy and surgical 
procedures given as part of first course of treatment */ 
proc freq data = seer.lung_primary_nsclc_incident_65_1;
table RX_Summ_Systemic_Surg_Seq;
run; 

/* 

RX Summ--Systemic Surg Seq 
RX_SUMM_SYSTEMIC_SURG_SEQ Frequency Percent Cumulative Frequency Cumulative Percent 
0 217200 88.38 217200 88.38 
2 1336 0.54 218536 88.93 
3 26474 10.77 245010 99.70 
4 432 0.18 245442 99.87 
5 6 0.00 245448 99.88 
6 12 0.00 245460 99.88 
7 216 0.09 245676 99.97 
9 77 0.03 245753 100.00 
Frequency Missing = 154747 

*/

/* before and after surgery
5 Intraoperative systemic therapy
6 Intraoperative systemic

Code Description
0 No systemic therapy and/or surgical procedures; unknown if 
surgery and/or systemic therapy given
2 Systemic therapy before surgery
3 Systemic therapy after surgery
4 Systemic therapy both  therapy with other therapy administered 
before and/or after surgery
7 Surgery both before and after systemic therapy
9 Sequence unknown, but both surgery and systemic therapy 
given

*/


/* Chemotherapy tx summary */ 
proc freq data = seer.lung_primary_nsclc_incident_65_1;
table CHEMOTHERAPY_RECODE_YES_NO_UNK;
run; 


