*******************************************************************************;
* Program name      :	001_Redbook 2017 codes in excel
* Author            :	Hemal Mehta
* Date created      :	11/16/2017
* Study             : 	
* Purpose           :	To export redbook drug names and thera class in excel file
* Inputs            :	
* Program completed : 	
* Updated by        :   Xinyi Sun,11/19/2024: Modification and Reason: To get newer 2018 Redbook excel file
*********************************************************************************;

/**********************************************************************************************************
		Output unique drugnames and theraclass codes in excel file.
		Use this excel file to search any drugs 	
**********************************************************************************************************/

libname redbook "S:\Pharmacoepi0216\Redbook\";		** \\Ut313302\m		-	2018 RedBook;

proc print data = redbook.redbook (obs=5);
run; /* Variables needed: NDCNUM PRODNME THERCLS THRCLDS MASTFRM GENNME */


/*data redbook;*/
/*set redbook.mastertheraclass;*/
/*keep ndc productname theraclasscode theraclassdesc masterFormCode;*/
/*run;*/
/**/
/*proc sort data = redbook out = RB2017.prod_thera_unique_rb17 (keep = theraclasscode theraclassdesc productname) nodupkey ; */
/*by theraclassdesc productname; */
/*run;*/
/**/
/*Proc sort data = RB2017.prod_thera_unique_rb17;*/
/*by theraclasscode;*/
/*run;*/
/**/
/*Data RB2017.prod_thera_unique_rb17;*/
/*retain theraclasscode theraclassdesc productname;*/
/*set RB2017.prod_thera_unique_rb17;*/
/*run;*/

proc sql;
create table redbook.prod_thera_unique_rb18 as 
select THERCLS as theraclasscode, THRCLDS as theraclassdesc,  PRODNME as productname, count (NDCNUM) as num_ndc
from redbook.mastertheraclass
group by theraclasscode, theraclassdesc, productname;
quit;

proc export 
  data = redbook.prod_thera_unique_rb18
  dbms=xlsx 
  outfile="S:\Pharmacoepi0216\Redbook\generic_thera_unique_redbook_2018.xlsx" 
  replace;
run;

/**********************************************************************************************************
NOTE: The export data set has 59556 observations and 4 variables.
NOTE: "S:\Pharmacoepi0216\Redbook\prod_thera_unique_redbook_2018.xlsx" file was successfully
      created.		

NOTE: The export data set has 13537 observations and 4 variables.
NOTE: "S:\Pharmacoepi0216\Redbook\generic_thera_unique_redbook_2018.xlsx" file was successfully
      created.
	
**********************************************************************************************************/

