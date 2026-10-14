options ps=54 ls=72 obs=max pageno=1 compress=yes;

%let workdir=C:\CFI-SAS;

libname new "&workdir.";

**************************************;
* sample datasets:    variables:      ;
* 1.ids               patid           ;
* 2.dx09              patid, dx(icd9) ;
* 3.dx10              patid, dx(icd10);
* 4.px                patid, px(CPT4) ;
**************************************;

**************************************;
* Import the procedure disease nums   ;
* Skip first header row               ;
**************************************;
data px_score;
  infile "&workdir.\px_codes.csv" DLM=',' DSD MISSOVER firstobs=2;

  informat set_type $2.;
  informat code_type $2.;
  informat description $100.;
  informat range_min $5.;
  informat range_max $5.;
  informat Disease_number best32.;

  format set_type $2.;
  format code_type $2.;
  format description $100.;
  format range_min $5.;
  format range_max $5.;
  format Disease_number best12.;

  input
    set_type $
    code_type $
    description $
    range_min $
    range_max $
    Disease_number
  ;

  keep range_min range_max disease_number;
run;

**************************************;
* Import the ICD-9 diagnosis mapping  ;
* Skip first header row               ;
**************************************;
data icd9_score;
  infile "&workdir.\CFI_ICD9CM_V32.csv" DLM=',' DSD MISSOVER firstobs=2;

  informat disease_number best32.;
  informat dx $10.;
  informat description $100.;
  informat icd_ver $12.;

  format disease_number best12.;
  format dx $10.;
  format description $100.;
  format icd_ver $12.;

  input
    disease_number
    dx $
    description $
    icd_ver $
  ;

  keep disease_number dx;
run;

**************************************;
* Add weights                         ;
**************************************;
proc sql;
  create table icd9_weights as
    select dis.dx, dis.disease_number, wgt.weight
    from icd9_score dis, new.disease_weight wgt
    where dis.disease_number = wgt.disease_number;
quit;

**************************************;
* Import the ICD-10 diagnosis mapping ;
* Skip first header row               ;
**************************************;
data icd10_score;
  infile "&workdir.\CFI_ICD10CM_V2020.csv" DLM=',' DSD MISSOVER firstobs=2;

  informat disease_number best32.;
  informat dx $10.;
  informat description $100.;
  informat icd_ver $12.;

  format disease_number best12.;
  format dx $10.;
  format description $100.;
  format icd_ver $12.;

  input
    disease_number
    dx $
    description $
    icd_ver $
  ;
run;

**************************************;
* Add weights                         ;
**************************************;
proc sql;
  create table icd10_weights as
    select dis.dx, dis.disease_number, wgt.weight
    from icd10_score dis, new.disease_weight wgt
    where dis.disease_number = wgt.disease_number;
quit;

**********************************************;
* cpt4 procedures format for frailty disease  ;
**********************************************;

data master;
  length label $5;
  set px_score;
  label = left(put(disease_number, 2.));
  drop disease_number;
run;

data other;
  start = 'other';
  end   = 'other';
  label = 'other';
run;

data study_px;
  set master(rename=(range_min=start range_max=end))
      other;
  fmtname = '$study_px';
run;

proc format cntlin=study_px;
run;

**********************************************;
* Assign a disease number to each procedure   ;
* Keep only rows having a mapped value        ;
**********************************************;
data score_px;
  set new.px(keep=patid px);
  class = put(px, $study_px.);
  if class ne 'other';
  last_d = substr(left(px),5,1);
  if last_d = ' '  or last_d = '0'  or last_d = '1'  or last_d ='2' or
     last_d = '3'  or last_d = '4'  or last_d = '5'  or last_d ='6' or
     last_d = '7'  or last_d = '8'  or last_d = '9';
  drop last_d;
run;

*****************************;
* frailty procedure weight   ;
*****************************;

data weight;
  set new.disease_weight;
  class = left(put(disease_number, 2.));
  keep class weight;
run;

proc sort data=weight;
  by class;
run;

data score;
  set score_px;
  keep patid class;
run;

proc sort nodupkey data=score;
  by patid class;
run;

proc sort data=score;
  by class;
run;

*****************************;
* Assign a weight to each    ;
*****************************;
data scores_px;
  merge score(in=in1)
        weight(in=in2);
  by class;
  if in1 and in2;
run;

*******************************************;
* link icd10/disease/weight to             ;
* prior icd10 dx                           ;
*******************************************;

proc sql;
  create table score_dx10(keep=patid dx disease_number weight) as
    select dx10.patid, diag.dx, diag.disease_number, diag.weight
    from icd10_weights diag, new.dx10 dx10
    where diag.dx = dx10.dx;
quit;

data score_10;
  set score_dx10;
  class = left(put(disease_number, 2.));
  keep patid class weight;
run;

proc sort nodupkey data=score_10;
  by patid class;
run;

*******************************************;
* link icd9/disease/weight to              ;
* prior icd9 dx                            ;
*******************************************;

proc sql;
  create table score_dx09(keep=patid dx disease_number weight) as
    select dx09.patid, diag.dx, diag.disease_number, diag.weight
    from icd9_weights diag, new.dx09 dx09
    where diag.dx = dx09.dx;
quit;

data score_09;
  set score_dx09;
  class = left(put(disease_number, 2.));
  keep patid class weight;
run;

proc sort nodupkey data=score_09;
  by patid class;
run;

*******************************************;
* Combine the procedure, ICD-10 and ICD-9  ;
* weighted files                           ;
*******************************************;
data scores;
  set scores_px
      score_10
      score_09;
  keep patid class weight;
run;

proc sort nodupkey data=scores;
  by patid class;
run;

*******************************************;
* Add up the weights per patient           ;
*******************************************;
data count;
  set scores;
  by patid;
  if first.patid then score = 0.10288;
  score + weight;
  if last.patid then output;
  keep patid score;
run;

*******************************************;
* Ensure all patients in the ids data have ;
* a score. If a patient does not have any  ;
* PX or DX, then default model score is    ;
* assigned.                                ;
*******************************************;
data frailty_score;
  merge new.ids(in=in1 keep=patid)
        count(in=in2);
  by patid;
  if in1;
  if not in2 then score = 0.10288;
  keep patid score;
run;

proc means data=frailty_score;
  var score;
run;
