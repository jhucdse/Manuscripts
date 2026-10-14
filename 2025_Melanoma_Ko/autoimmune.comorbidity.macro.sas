/***********************************************************************************************************************************/
/* autoimmune.comorbidity.macro.sas                                                                                                       */
/* Created: 9/21/2021                                                                                                              */
/* Updated: 1/2/2024 to find autoimmne comorbidities.                                                                   */
/***********************************************************************************************************************************/
/* If you encounter any problems with this macro, please email the SAS log file to seer-medicare@imsweb.com.                       */
/***********************************************************************************************************************************/
/* This SAS macro scans ICD-9 and ICD-10 diagnosis codes from hospital and physician claims for sixteen comorbid                   */
/* conditions and creates variables to indicate each condition found and the earliest date in which it was found.                  */
/* It also calculates 2 comorbidity indices (Charlson Score and NCI Index) for a patient with respect to cancer.                   */
/* Note, this version does not look for HCPCS codes or ICD procedure codes.                                                        */
/*                                                                                                                                 */
/* The macro is designed to look for claims reported in the year prior to diagnosis of cancer, however, the macro                  */
/* can accommodate any time period by inputting different start and end dates for the window of time for which                     */
/* claims are to be scanned for ICD-9 and ICD-10 definitions of comorbid conditions. NCI recommends calculating                    */
/* comorbidity indices using claims for the 12 calendar months prior to the month of diagnosis.                                    */
/*                                                                                                                                 */
/* The macro may be run using only hospital claims (MedPAR) or a combination of hospital and carrier/outpatient claims             */
/* (NCH and Outpatient). If carrier/outpatient claims are used, it has a switch in the call statement that may be used so that     */
/* it can remove claims that are considered to have unreliable diagnosis coding ("ruleouts"). Note, if the RULEOUT Algorithm       */
/* is used, then the input dataset should include claims for at least 30 days before and after the comorbidity "window".           */
/*                                                                                                                                 */
/* In order to use this macro:,                                                                                                    */
/* 1. Include this file in your SAS program                                                                                        */
/*    %include '/directory path/NCI.comorbidity.macro.sas';                                                                        */
/* 2. Create a clean file of claim records to send to the macro. You may include information from the claims files MedPAR,         */
/*    Outpatient and/or Carrier (NCH). All claim records of interest should be "set together" into a single SAS dataset.           */
/* 3. After setting up your dataset, call the macro COMORB. For example:                                                           */
/*    %COMORB(CLAIMS,PATIENT_ID,START_DATE,END_DATE,CLAIM_FROM_DATE,CLAIM_THRU_DATE,FILETYPE,ICD_DGNS_CD1-ICD_DGNS_CD25,Y,COMORB); */
/*    would send the dataset CLAIMS, with the person identifier PATIENT_ID to the macro. The dataset includes diagnosis codes      */
/*    ICD_DGNS_CD1-ICD_DGNS_CD25. Diagnosis codes are in ICD-9 or ICD-10 format. The file source of each claim record is found     */
/*    in the variable, FILETYPE (M=MedPAR, O=Outpatient, N=NCH). The start date of the claim is designated as CLAIM_FROM_DATE.     */
/*    The end date of the claim is designated as CLAIM_THRU_DATE. The CLAIM_THRU_DATE is used to determine if the diagnosis codes  */
/*    are ICD-9 (before 10/1/2015) or ICD-10 (on or after 10/1/2015). The 'Y' indicates that the RULEOUT algorithm will be used.   */
/* 4. The macro returns a SAS dataset (default name=Comorbidities) which contains 1 record for each person who had at least one    */
/*    claim within the window. The variables included in this output data set are the patient ID(s), Charlson Comorbidity Index,   */
/*    NCI Comorbidity Index, and each of the comorbid condition indicator flags for the time period of interest, as well as the    */
/*    date of the first claim for each condition. The data set is sorted by ID.                                                    */
/***********************************************************************************************************************************/
/* INFILE: Dataset name: a SAS dataset of Medicare claims that contains the following variables:                                   */
/* ID: Variable names: Unique ID for each patient. Can be a combination of more than one variable (i.e. patient_id sequence_num).  */
/* STARTDATE: Variable name: Date the comorbidity window starts, in SAS date format.                                               */
/* ENDDATE: Variable name: Date the comorbidity window ends, in SAS date format.                                                   */
/* CLAIMSTARTDATE: Variable name: Start date of the claim found on the claim file, in SAS date format. This can be created         */
/*   by using the input() function (e.g. CLAIMSTARTDATE = input(CLM_FROM_DT,yymmdd8.) or input(ADMSN_DT,yymmdd8.).                 */
/* CLAIMENDDATE: Variable name: End date of the claim found on the claim file, in SAS date format. This can be created             */
/*   by using the input() function (e.g. CLAIMENDDATE = input(CLM_THRU_DT,yymmdd8.) or input(DSCHRG_DT,yymmdd8.).                  */
/* CLAIMTYPE: Variable name: the source of the claim record ('M'=MedPAR, 'O'=Outpatient, 'N'=NCH). Note, do not use DME.           */
/* DXVARLIST: List of variable names: the diagnosis codes in ICD-9 or ICD-10 (e.g. ICD_DGNS_CD1-ICD_DGNS_CD25). If there are       */
/*   multiple variables, some of which cannot be included in a range, please list them using spaces to separate each single        */
/*   element or range (e.g. ADMTG_DGNS_CD PRNCPAL_DGNS_CD LINE_ICD_DGNS_CD ICD_DGNS_CD1-ICD_DGNS_CD25).                            */
/* RULEOUT: Flag: Set this to 'Y' if the "ruleout algorithm" should be invoked (further details below), otherwise set this to 'N'. */
/* OUTFILE: Dataset name: a SAS dataset with the comorbidity indicators, dates, and scores/indices determined by the macro.        */
/*   If an output dataset name is not specified, the default name is Comorbidities.                                                */
/***********************************************************************************************************************************/
/* RULEOUT Algorithm:                                                                                                              */
/*   The ruleout algorithm requires a more stringent criteria for which claims to include when identifying comorbidities.          */
/*   Any "stand-alone" outpatient (Outpatient or NCH) claims that are not confirmed by other claims are considered to be           */
/*   "ruleout" diagnoses and are excluded from consideration. A condition is confirmed if any claim for that condition is          */
/*   found in MedPAR or 2+ instances of claims for that condition are found more than 30 days apart in Outpatient or NCH.          */
/*   All other claims are excluded.                                                                                                */
/***********************************************************************************************************************************/

*** Begin macro COMORB_auto;
%macro AUTOIMMUNE(INFILE,ID,STARTDATE,ENDDATE,CLAIMSTARTDATE,CLAIMENDDATE,CLAIMTYPE,DXVARLIST,RULEOUT,OUTFILE);

%LET conditions = autoimmune;

data claims;
set &INFILE(keep=&ID &STARTDATE &ENDDATE &CLAIMSTARTDATE &CLAIMENDDATE &CLAIMTYPE &DXVARLIST);

*** Select claim records in appropriate window;
*** Keep 30 days extra on both sides of the window for the RULEOUT Algorithm (for confirming diagnoses in the Outpatient and Carrier files);
%IF (&RULEOUT=Y OR &RULEOUT=1 OR &RULEOUT=R) %THEN %DO;
 where (&STARTDATE - 30) <= &CLAIMSTARTDATE <= (&ENDDATE + 30);
 inwindow = (&STARTDATE <= &CLAIMSTARTDATE <= &ENDDATE);
%END;
%ELSE %DO; 
 where &STARTDATE <= &CLAIMSTARTDATE <= &ENDDATE;
 inwindow = 1;
%END;

 *** Determine if the claim has ICD-9 or ICD-10 diagnosis codes, based on the claim end date;
 if &CLAIMENDDATE<mdy(10,1,2015) then ICDVRSN = 9;
 else if &CLAIMENDDATE>= mdy(10,1,2015) then ICDVRSN = 10;

 length &conditions 3.;
 array _conditions &conditions;
 do over _conditions; _conditions = 0; end;

 array dxcodes(*) $ &DXVARLIST;
 do i=1 to dim(dxcodes);
  if not missing(dxcodes(i)) then do;
   *** Convert any lowercase letters to uppercase;
   dxcode = upcase(dxcodes(i));

   *** Indentify autoimmune comorbidities based on ICD-9 diagnosis codes in the claims;
   if ICDVRSN=9 then do;
    if dxcode in:('555','5550','5551','5552','5559','556','5560','5561','5562','5563','5564','5565','5566','5568','5569','714','7140','7141','7142','71430','71431','71432','71433','7144','71481','71489','7149','696','6960','6961','6962','6963','6964','6965','6968','710','7100','7101','7102','7103','7104','7105','7108','7109','720','7200','7201','7202','72081','72099','7209','135','28731','340','70901','446','4460','4461','44620','44621','44629','4463','4464','4465','4466','4467','725','2830','694','6940','6941','6942','6943','6944','6945','69460','69461','6948','6949','6954') then autoimmune=1;  /* Autoimmune diseases*/ 
   end;

   *** Indentify automimmune comorbidities based on ICD-10 diagnosis codes in the claims;
   else if ICDVRSN=10 then do;
    if dxcode in:('K50','K5000','K50011','K50012','K50013','K50014','K50018','K50019','K5010','K50111','K50112','K50113','K50114','K50118','K50119','K5080','K50811','K50812','K50813','K50814','K50818','K50819','K5090','K50911','K50912','K50913','K50914','K50918','K50919','K51','K5100','K51011','K51012','K51013','K51014','K51018','K51019','K5120','K51211','K51212','K51213','K51214','K51218','K51219','K5130','K51311','K51312','K51313','K51314','K51318','K51319','K5140','K51411','K51412','K51413','K51414','K51418','K51419','K5150','K51511','K51512','K51513','K51514','K51518','K51519','K5180','K51811','K51812','K51813','K51814','K51818','K51819','K5190','K51911','K51912','K51913','K51914','K51918','K51919','K52','K521','K5221','K5222','K5229','K523','K5281','K5282','K52831','K52832','K52838','K52839','K5289','K529',
'M091','M092','M05','M06','M07','L40','M090','M35','M45','D86','D693','G35','L80','M31','M32','D59','L10','L11','L12','L13','L93','M34','M33','M30','M08','M07') then autoimmune=1;  /* Autoimmune diseases */
   end;
  end;
 end;

 drop i dxcode &DXVARLIST;
run;

*** Sort claims by ID and date of claim;
proc sort data=claims;
 by &ID &CLAIMSTARTDATE;
run;

*** Find the first claim date, first claim date in the window, and last claim date for each comorbidity;
data conditions;
 set claims;
 by &ID &CLAIMSTARTDATE;

 *** identifies the last (or only) ID variable;
 %LET IDvar = %SCAN(&ID,-1);

 *** identifies subjects that have ANY claims in the window;
 retain anyclaims;
 if first.&IDvar then anyclaims = 0;
 if inwindow then anyclaims = 1;

%DO i=1 %TO 1; /*only 1 autoimmune */
 %LET cond = %SCAN(&conditions,&i);

 if first.&IDvar then do; &cond._date=.; first_&cond.=.; last_&cond.=.; hosp_&cond.=0; end;
 retain &cond._date first_&cond. last_&cond. hosp_&cond.;

 if &cond then do;
  if inwindow and &cond._date=. then &cond._date = &CLAIMSTARTDATE;
  if first_&cond.=. then first_&cond. = &CLAIMSTARTDATE; 
  last_&cond. = &CLAIMSTARTDATE;
  if &CLAIMTYPE=:'M' then hosp_&cond. = 1;
  format &cond._date first_&cond. last_&cond. mmddyy10.;
 end;

%END;

 if last.&IDvar then output;
 drop &CLAIMTYPE &CLAIMSTARTDATE &CLAIMENDDATE ICDVRSN inwindow;
run;

*** set the default output filename;
%IF %LENGTH(&OUTFILE)=0 %THEN %LET OUTFILE=Comorbidities_autoimmune;/* output filename = Comorbidities_autoimmune*/

*** Check for comorbidities and create comorbidity indicators and Charlson & NCI Index scores;
data &OUTFILE;
 set conditions;

*** Rule out unconfirmed conditions if the RULEOUT indicator flag is set in macro call;
 %DO i=1 %TO 1;
 %LET cond = %SCAN(&conditions,&i);
  %IF (&RULEOUT=Y OR &RULEOUT=1 OR &RULEOUT=R) %THEN %DO;
  if &cond._date>. then do; if hosp_&cond.=0 and (last_&cond. - first_&cond.)<=30 then &cond._date = .; end;
  %END;
  &cond. = (&cond._date>.);
%END; 


 *** Only keep subjects with at least one claim in the window;
 if anyclaims;
 
 keep &ID &STARTDATE &ENDDATE autoimmune autoimmune_date;
 drop first_: last_: hosp_:;
 
 label 
 autoimmune              = 'Autoimmune diseases'
 autoimmune_date         = 'First indication of Autoimmune diseases'
;
run;

%mend; 
*** End macro AUTOIMMUNE;
