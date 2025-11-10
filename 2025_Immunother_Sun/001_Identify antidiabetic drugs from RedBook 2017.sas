*******************************************************************************;
* Program name      :	001_Identify antidiabetic drugs from RedBook 2017	
* Author            :	Hemal Mehta
* Date created      :	
* Study             : 	
* Purpose           :	
* Inputs            :	
* Program completed : 	
* Updated by        : Xinyi Sun, 11/20/2024: to identify antidiabetic drugs from RedBook 2018
*********************************************************************************;

libname redbook "S:\Pharmacoepi0216\Redbook\";		**\\UT324603;
libname diab 'S:\Pharmacoepi0216\Antidiabetic drugs';

/*---------------------------------------------------------------------------------------------------------------------------------
11/20/2024 modified
CODE	Drug Class											Generic names
					*** ORAL ANTIDIABETIC DRUGS	***
AGLI	Alpha-glucosidase inhibitor							Miglitol, Acarbose
BIAG	Biagunide											Metformin 
DPP4	Dipeptidyl peptidase-4 inhibitor					Sitagliptin, Saxagliptin, Linagliptin, Alogliptin 
SGLT	Sodium-glucose cotransporter 2 (SGLT2) inhibitor	Canaglifozine, Dapagliflozine, Empagliflozin, Ertugliflozin
SULF	Sulfonylureas										Chlorpropamide, Tolbutamide, Tolazemide, Glipizide, Glyburide, Glimepiride
MEGL	Meglitinides										Repaglinide, Nateglinide
TZDS	Thiazolidinedione									Rosiglitazone, Pioglitazone 

					*** INJECTABLE ANTIDIABETIC DRUGS ***
INSU	Insulin												Insulin Lispro, Insulin Glargine, Insulin Aspart, Insulin Glulisine, Insulin Detemir, Insulin Degludec, Insulin & Comb.
GLP1	Incretin Mimetics/
		Glucagon-like peptide-1 (GLP-1) receptor agonist	Albiglutide, Dulaglutide, Exenatide, Liraglutide, Lixisenatide, Semaglutide
AMYL	Amylin analog										Pramlintide
---------------------------------------------------------------------------------------------------------------------------------*/

/*Data redbook;
set redbook.mastertheraclass;
keep ndc productname theraclasscode theraclassdesc;
run;*/

proc sql;
create table redbook_temp as 
select NDCNUM, THERCLS, THRDTDS, THRCLDS, PRODNME
from redbook.mastertheraclass;
quit;
data redbook;
    set redbook_temp(rename=(
        NDCNUM=ndc 
        THERCLS=theraclasscode
        THRDTDS=theradetaildesc
        THRCLDS=theraclassdesc
        PRODNME=productname
    ));
run;
proc print data=redbook(obs=5);
run;

%macro ndc_drug (data_name = , theradrug = , proddrug = , remove = , var = );
Data &data_name;
set redbook;
where theradetaildesc in &theradrug OR productname in &proddrug ; 
if theradetaildesc = &remove then delete;
&var = 1;
run;

proc sort data = &data_name;
by ndc;
run;

%mend ndc_drug;

/********	AGLI	Alpha-glucosidase inhibitor	- Miglitol, Acarbose ********/	
%ndc_drug (data_name = AGLI_Migl, 	theradrug = ("Miglitol"), 
									proddrug = ("MIGLITOL", "GLYSET"), 		  
									remove = (""),			var = AGLI_Migl );
%ndc_drug (data_name = AGLI_Acar, 	theradrug = ("Acarbose"),  
									proddrug = ("ACARBOSE","PRECOSE"), 
									remove = (""),			var = AGLI_Acar );

/********	BIAG	Biagunide - Metformin  							********/	
%ndc_drug (data_name = BIAG_Metf, 	theradrug = ("Metformin & Comb."), 
									proddrug = ("METFORMIN HCL","GLYBURIDE MICRONIZED-METFORMIN HCL", "GLYBURIDE-METFORMIN HCL","GLYBURIDE-METFORMIN HCL AVPAK","GLUCOVANCE", "SEGLUROMET"), 
									remove =   (""),		var = BIAG_Metf );

/********	DPP4	Dipeptidyl peptidase-4 inhibitor - Sitagliptin, Saxagliptin, Linagliptin, Alogliptin  			********/	
%ndc_drug (data_name = DPP4_Sita, 	theradrug = ("Sitagliptin"), 			
									proddrug = ("JANUMET", "JANUMET XR", "JUVISYNC","STEGLUJAN"), 
									remove =   (""), 		var = DPP4_Sita );
%ndc_drug (data_name = DPP4_Saxa, 	theradrug = ("Saxagliptin & Comb."), 	
									proddrug = ("KOMBIGLYZE XR","SAXAGLIPTIN-METFORMIN HCL",""), 
									remove =   (""), 		var = DPP4_Saxa );
%ndc_drug (data_name = DPP4_Lina, 	theradrug = ("Linagliptin"), 			
									proddrug = ("TRIJARDY XR", "JENTADUETO", "JENTADUETO XR","GLYXAMBI"), 
									remove =   (""), 		var = DPP4_Lina );
%ndc_drug (data_name = DPP4_Alog, 	theradrug = ("Alogliptin & Comb."),  	
									proddrug = ("ALOGLIPTIN BENZOATE-METFORMIN HYDROCHLORIDE", "KAZANO"), 
									remove =   (""), 		var = DPP4_Alog );

/********	SGLT	Sodium-glucose cotransporter 2 (SGLT2) inhibitor	Canaglifozine, Dapagliflozine, Empagliflozin, Ertugliflozin	********/	
%ndc_drug (data_name = SGLT_Cana,  	theradrug = ("Canagliflozin"), 		 
									proddrug = ("INVOKAMET", "INVOKAMET XR"), 
									remove = (""), 			var = SGLT_Cana );
%ndc_drug (data_name = SGLT_Dapa,  	theradrug = ("Dapagliflozin"), 		 
									proddrug = ("DAPAGLIFLOZIN PROPANEDIOL-METFORMIN HCL","XIGDUO XR","QTERN"), 
									remove = (""), 			var = SGLT_Dapa );
%ndc_drug (data_name = SGLT_Empa,  	theradrug = ("Empagliflozin & Comb."), 
									proddrug = ("TRIJARDY XR","SYNJARDY", "SYNJARDY XR"), 
									remove = (""), 			var = SGLT_Empa );
%ndc_drug (data_name = SGLT_Ertu,  	theradrug = ("Ertugliflozin & Comb."), 
									proddrug = (""), 
									remove = (""), 			var = SGLT_Ertu );

/********   SULF	Sulfonylureas		Chlorpropamide, Tolbutamide, Tolazemide, Glipizide, Glyburide, Glimepiride ********/
%ndc_drug (data_name = SULF_Chlo, 	theradrug = ("Chlorpropamide"), 		
									proddrug = ("CHLORPROPAMIDE"), 	
									remove =   (""),		var = SULF_Chlo );
%ndc_drug (data_name = SULF_Tolb, 	theradrug = ("Tolbutamide"),  		
									proddrug = (""), 				
									remove =   (""),		var = SULF_Tolb );
%ndc_drug (data_name = SULF_Tola, 	theradrug = ("Tolazamide"), 			
									proddrug = (""), 				
									remove =   (""),		var = SULF_Tola );
%ndc_drug (data_name = SULF_Glip, 	theradrug = ("Glipizide"), 			
									proddrug = ("GLIPIZIDE", "GLIPIZIDE/METFORMIN HCL", "METAGLIP"), 		
									remove =   (""),		var = SULF_Glip);
%ndc_drug (data_name = SULF_Glyb, 	theradrug = ("Glyburide & Comb."), 	
									proddrug = ("GLYBURIDE", "GLYBURIDE MICRONIZED-METFORMIN HCL","GLYBURIDE-METFORMIN HCL"), 		
									remove =   (""),		var = SULF_Glyb);
%ndc_drug (data_name = SULF_Glim, 	theradrug = ("Glimepiride & Comb."), 	
									proddrug = (""), 				
									remove =   (""),		var = SULF_Glim );

/******** 	MEGL	Meglitinides										Repaglinide, Nateglinide ********/
%ndc_drug (data_name = MEGL_Repa,	theradrug = ("Repaglinide"), 			
									proddrug = ("METFORMIN HYDROCHLORIDE-REPAGLINIDE", "PRANDIMET"), 				
									remove =   (""),		var = MEGL_Repa );
%ndc_drug (data_name = MEGL_Nate, 	theradrug = ("Nateglinide"), 			
									proddrug = (""), 				
									remove =   (""),		var = MEGL_Nate );

/********  	TZDS	Thiazolidinedione									Rosiglitazone, Pioglitazone ********/ 
%ndc_drug (data_name = TZDS_Rosi, 	theradrug = ("Rosiglitazone"), 		
									proddrug = ("AVANDARYL", "AVANDAMET"), 				
									remove =   (""),		var = TZDS_Rosi );
%ndc_drug (data_name = TZDS_Piog, 	theradrug = ("Pioglitazone"), 		
									proddrug = ("ALOGLIPTIN BENZOATE-PIOGLITAZONE HY", "OSENI", "DUETACT", "PIOGLITAZONE HCL/GLIMEPIRIDE",
												"ACTOPLUS MET", "ACTOPLUS MET XR", "PIOGLITAZONE HCL-METFORMIN HCL"), 				
									remove =   (""),		var = TZDS_Piog );



/********  	INSL	Insulin		Insulin Lispro, Insulin Glargine, Insulin Aspart, Insulin Glulisine, Insulin Detemir, Insulin Degludec,Insulin & Comb.  ********/ 
%ndc_drug (data_name = INSU, theradrug = ("Insulin - Beef", "Insulin - Pork", "Insulin - Beef & Pork", "Insulin - Human",
										   "Insulin Lispro", "Insulin Glargine", "Insulin Aspart",
										  "Insulin Glulisine", "Insulin Detemir", "Insulin Degludec", "Insulin & Comb."), 		
							  proddrug = ("INSULIN BEEF", "INSULIN BOVINE"), 							remove =   (""),	var = INSU );

/********	GLP1	Incretin Mimetics/
		Glucagon-like peptide-1 (GLP-1) receptor agonist		Albiglutide, Dulaglutide, Exenatide, Liraglutide, Lixisenatide,Semaglutide			********/
%ndc_drug (data_name = GLP1_Albi, theradrug = ("Albiglutide"), 			proddrug = (""), 				remove =   (""),	var = GLP1_Albi );
%ndc_drug (data_name = GLP1_Dula, theradrug = ("Dulaglutide"), 			proddrug = (""), 				remove =   (""),	var = GLP1_Dula );
%ndc_drug (data_name = GLP1_Exen, theradrug = ("Exenatide"), 			proddrug = (""), 				remove =   (""),	var = GLP1_Exen );
%ndc_drug (data_name = GLP1_Lira, theradrug = ("Liraglutide & Comb."), 	proddrug = ("XULTOPHY 100/3.6"), 				remove =   (""),	var = GLP1_Lira );
%ndc_drug (data_name = GLP1_Lixi, theradrug = ("Lixisenatide"), 		proddrug = ("SOLIQUA 100/33"), 				remove =   (""),	var = GLP1_Lixi );
%ndc_drug (data_name = GLP1_Sema, theradrug = ("Semaglutide"), 		    proddrug = (""), 				remove =   (""),	var = GLP1_Sema );

/********	AMYL	Amylin analog	Pramlintide	********/
%ndc_drug (data_name = AMYL_Pram, theradrug = ("Pramlintide"), 			proddrug = (""), 				remove =   (""),	var = AMYL_Pram );


/**********************************************************************************************************
			FINAL NDC CODES						
**********************************************************************************************************/

Data diab.oral_iv_diab_rx ;
Merge 	AGLI_Migl
		AGLI_Acar
		BIAG_Metf
		DPP4_Sita
		DPP4_Saxa
		DPP4_Lina
		DPP4_Alog
		SGLT_Cana
		SGLT_Dapa
		SGLT_Empa
		SGLT_Ertu
		SULF_Chlo
		SULF_Tolb
		SULF_Tola
		SULF_Glip
		SULF_Glyb
		SULF_Glim
		MEGL_Repa
		MEGL_Nate
		TZDS_Rosi
		TZDS_Piog

		Insu
		GLP1_Albi
		GLP1_Dula
		GLP1_Exen
		GLP1_Lira
		GLP1_Lixi
		GLP1_Sema
		AMYL_Pram;
by ndc;

if AGLI_Migl | AGLI_Acar 		then AGLI = 1;
if BIAG_Metf			 		then BIAG = 1;
if DPP4_Sita | DPP4_Saxa | DPP4_Lina | DPP4_Alog then DPP4 = 1;
if SGLT_Cana | SGLT_Dapa | SGLT_Empa |SGLT_Ertu then SGLT = 1;
if SULF_Chlo | SULF_Tolb | SULF_Tola | SULF_Glip| SULF_Glyb | SULF_Glim then SULF = 1;
if MEGL_Repa | MEGL_Nate 		then MEGL = 1;
if TZDS_Rosi | TZDS_Piog 		then TZDS = 1;

**Insu is already defined;
if GLP1_Albi | GLP1_Dula | GLP1_Exen | GLP1_Lira | GLP1_Lixi|GLP1_Sema then GLP1 = 1;
if AMYL_Pram = 1 then AMYL = 1;

if AGLI | BIAG | DPP4 | SGLT | SULF | MEGL | TZDS 	then oral_diab 	= 1;
if INSU | GLP1 | AMYL 						then iv_diab 	= 1;

run;

Proc freq data = diab.oral_iv_diab_rx ;
/*tables oral_diab iv_diab / list missing;*/
/*tables oral_diab * (AGLI BIAG DPP4 SGLT SULF MEGL TZDS) / list ;*/
/*tables iv_diab   * (INSU GLP1 AMYL)/ list ;*/
tables (AGLI BIAG DPP4 SGLT SULF MEGL TZDS INSU GLP1 AMYL) * (AGLI BIAG DPP4 SGLT SULF MEGL TZDS INSU GLP1 AMYL) / nopercent norow nocol missing;
run;




/**********************************************************************************************************

Some NDC are common in two classes because of combination product. 

	AGLI 	139
	BIAG 	2372
	DPP4 	209
    SGLT    133
	SULF 	3201
	MEGL 	107
	TZDS	509

	INSU 	390
	GLP1 	74
	AMYL	7

	ORAL	6099
	IV 		468

	TOTAL	6567	

**********************************************************************************************************/
