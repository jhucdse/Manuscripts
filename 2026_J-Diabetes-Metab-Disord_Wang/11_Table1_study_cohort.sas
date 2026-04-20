//////////////////// Age //////////////////////
data ad.Table1_Study_Ad;
  merge ad.with_ad(in=a)
        ad.exclude65(in=b keep=bene_id bene_birth_dt age);
  by bene_id;
  if a and b;
run;
 proc sort data=ad.Table1_Study_ad nodupkey;
   by bene_id;
 run;

 /*mean age*/
 proc means data=ad.Table1_Study_AD mean std;
    var age;
 run;


  /* add age to all_t2dm_without_ad */
  data ad.Table1_study_nonad;
    merge ad.without_ad(in=a)
          ad.exclude65(in=b keep=bene_id bene_birth_dt age);
    by bene_id;
    if a and b;
  run;
  proc sort data=ad.Table1_study_nonad nodupkey;
    by bene_id;
  run;

  /*mean age*/
  proc means data=ad.Table1_study_nonad mean std;
     var age;
  run;


///////////////// Gender Race Region /////////////////
data ad.Table1_study_ad;
    merge ad.Table1_study_ad(in=a)
          ad.mbsf(in=b keep=bene_id sex_ident_cd bene_race_cd state_code RTI_RACE_CD);
    by bene_id;
    if a and b;
  run;
  proc sort data=ad.Table1_study_ad nodupkey;
    by bene_id;
  run;

 data ad.Table1_study_nonad;
    merge ad.Table1_study_nonad(in=a)
          ad.mbsf(in=b keep=bene_id sex_ident_cd bene_race_cd state_code RTI_RACE_CD);
    by bene_id;
    if a and b;
  run;
proc sort data=ad.Table1_study_nonad nodupkey;
   by bene_id;
run;

 /* Calculate counts and percentages for sex_ident_cd */
 proc freq data=ad.Table1_study_ad;
     tables sex_ident_cd / out=sex_counts (rename=(percent=sex_pct));
 run;

 proc freq data=ad.Table1_study_nonad;
     tables sex_ident_cd / out=sex_counts (rename=(percent=sex_pct));
 run;

 /* Calculate counts and percentages for bene_race_cd */
  proc freq data=ad.Table1_study_ad;
      tables RTI_RACE_CD / out=race_counts (rename=(percent=race_pct));
  run;

  proc freq data=ad.Table1_study_nonad;
      tables RTI_RACE_CD / out=race_counts (rename=(percent=race_pct));
  run;


 /* Calculate counts and percentages for bene_race_cd */
  proc freq data=ad.Table1_study_ad;
      tables RTI_RACE_CD / out=race_counts (rename=(percent=race_pct));
  run;

  proc freq data=ad.Table1_study_nonad;
      tables RTI_RACE_CD / out=race_counts (rename=(percent=race_pct));
  run;

  /* add classfication of region */
 data ad.Table1_study_ad;
   set ad.Table1_study_ad;
   length Region $20;
     select (state_code);
         /* Northeast */
         when ('07', '20', '22', '30', '41', '47', '31', '33', '39', '73') Region = 'Northeast';
        /* Midwest */
         when ('14', '15', '16', '17', '23', '24', '26', '28', '35', '36', '43', '52', '70', '72') Region = 'Midwest';
        /* South */
         when ('01', '04', '08', '09', '10', '11', '18', '19', '21', '25', '34', '37', '42', '44', '45', '49', '51', '67', '71', '68', '69', '74', '80') Region = 'South';
       /* West */
         when ('02', '03', '05', '06', '12', '13', '27', '29', '32', '38', '46', '50', '53', '55') Region = 'West';
       /* US territory */
         when ('40', '48', '63', '64', '65', '66', '97', '98', '99') Region = "US Territory";
       /* International */
         when ('54', '56', '57', '58', '59', '60', '61', '62') Region = 'International';
       /* Unknown */
          otherwise Region = 'Unknown';
     end;
 run;

 data ad.Table1_study_nonad;
     set ad.Table1_study_nonad;
     length Region $20;
       select (state_code);
           /* Northeast */
           when ('07', '20', '22', '30', '41', '47', '31', '33', '39', '73') Region = 'Northeast';
          /* Midwest */
           when ('14', '15', '16', '17', '23', '24', '26', '28', '35', '36', '43', '52', '70', '72') Region = 'Midwest';
          /* South */
           when ('01', '04', '08', '09', '10', '11', '18', '19', '21', '25', '34', '37', '42', '44', '45', '49', '51', '67', '71', '68', '69', '74', '80') Region = 'South';
         /* West */
           when ('02', '03', '05', '06', '12', '13', '27', '29', '32', '38', '46', '50', '53', '55') Region = 'West';
         /* US territory */
           when ('40', '48', '63', '64', '65', '66', '97', '98', '99') Region = "US Territory";
         /* International */
           when ('54', '56', '57', '58', '59', '60', '61', '62') Region = 'International';
         /* Unknown */
            otherwise Region = 'Unknown';
       end;
   run;


/* Calculate counts and percentages for Region */
  proc freq data=ad.Table1_study_ad;
      tables Region / out=region_counts (rename=(percent=region_pct));
  run;

  proc freq data=ad.Table1_study_nonad;
      tables Region / out=region_counts (rename=(percent=region_pct));
  run;



/* getting all other claims for AD cohort */
 proc sql;
     create table all_op_claims_2016 as
     select bene_id, clm_from_dt, prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
 ,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
 icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
 icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from op16.outpatient_base_claims_k_2016
     where bene_id in (select bene_id from ad.Table1_study_ad);
 Quit;

 proc sql;
     create table all_op_claims_2017 as
     select bene_id, clm_from_dt, prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
 ,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
 icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
 icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from op17.outpatient_base_claims_k_2017
     where bene_id in (select bene_id from ad.Table1_study_ad);
 Quit;

 proc sql;
     create table all_op_claims_2018 as
     select bene_id, clm_from_dt, prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
 ,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
 icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
 icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from op18.outpatient_base_claims_k_2018
     where bene_id in (select bene_id from ad.Table1_study_ad);
 Quit;

 proc sql;
     create table all_op_claims_2019 as
     select bene_id, clm_from_dt, prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
 ,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
 icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
 icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from op19.outpatient_base_claims_2019
     where bene_id in (select bene_id from ad.Table1_study_ad);
 Quit;

 proc sql;
     create table all_op_claims_2020 as
     select bene_id, clm_from_dt, prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
 ,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
 icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
 icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from op20.outpatient_base_claims_2020
     where bene_id in (select bene_id from ad.Table1_study_ad);
 Quit;

proc sql;
    create table all_ip_claims_2016 as
    select bene_id, clm_from_dt, admtg_dgns_cd,  prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from ip16.inpatient_base_claims_k_2016
    where bene_id in (select bene_id from ad.Table1_study_ad);
Quit;

proc sql;
    create table all_ip_claims_2017 as
    select bene_id, clm_from_dt, admtg_dgns_cd,  prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from ip17.inpatient_base_claims_k_2017
    where bene_id in (select bene_id from ad.Table1_study_ad);
Quit;

proc sql;
    create table all_ip_claims_2018 as
    select bene_id, clm_from_dt, admtg_dgns_cd,  prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from ip18.inpatient_base_claims_k_2018
    where bene_id in (select bene_id from ad.Table1_study_ad);
Quit;

proc sql;
    create table all_ip_claims_2019 as
    select bene_id, clm_from_dt, admtg_dgns_cd,  prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from ip19.inpatient_base_claims_2019
    where bene_id in (select bene_id from ad.Table1_study_ad);
Quit;

proc sql;
    create table all_ip_claims_2020 as
    select bene_id, clm_from_dt, admtg_dgns_cd,  prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from ip20.inpatient_base_claims_2020
    where bene_id in (select bene_id from ad.Table1_study_ad);
Quit;

/* combine all claims for ad cohort */
data ad.ad_other_ip_claims_study;
  set all_ip_claims_2016 all_ip_claims_2017 all_ip_claims_2018 all_ip_claims_2019 all_ip_claims_2020;
run;
data ad.ad_other_op_claims_study;
  set all_op_claims_2016 all_op_claims_2017 all_op_claims_2018 all_op_claims_2019 all_op_claims_2020;
run;


/* getting all other claims for non-AD cohort */
proc sql;
    create table all_op_claims_2016 as
    select bene_id, clm_from_dt, prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from op16.outpatient_base_claims_k_2016
    where bene_id in (select bene_id from ad.Table1_study_nonad);
Quit;

proc sql;
    create table all_op_claims_2017 as
    select bene_id, clm_from_dt, prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from op17.outpatient_base_claims_k_2017
    where bene_id in (select bene_id from ad.Table1_study_nonad);
Quit;

proc sql;
    create table all_op_claims_2018 as
    select bene_id, clm_from_dt, prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from op18.outpatient_base_claims_k_2018
    where bene_id in (select bene_id from ad.Table1_study_nonad);
Quit;

proc sql;
    create table all_op_claims_2019 as
    select bene_id, clm_from_dt, prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from op19.outpatient_base_claims_2019
    where bene_id in (select bene_id from ad.Table1_study_nonad);
Quit;

proc sql;
    create table all_op_claims_2020 as
    select bene_id, clm_from_dt, prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from op20.outpatient_base_claims_2020
    where bene_id in (select bene_id from ad.Table1_study_nonad);
Quit;

proc sql;
    create table all_ip_claims_2016 as
    select bene_id, clm_from_dt, admtg_dgns_cd,  prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from ip16.inpatient_base_claims_k_2016
    where bene_id in (select bene_id from ad.Table1_study_nonad);
Quit;

proc sql;
    create table all_ip_claims_2017 as
    select bene_id, clm_from_dt, admtg_dgns_cd,  prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from ip17.inpatient_base_claims_k_2017
    where bene_id in (select bene_id from ad.Table1_study_nonad);
Quit;

proc sql;
    create table all_ip_claims_2018 as
    select bene_id, clm_from_dt, admtg_dgns_cd,  prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from ip18.inpatient_base_claims_k_2018
    where bene_id in (select bene_id from ad.Table1_study_nonad);
Quit;

proc sql;
    create table all_ip_claims_2019 as
    select bene_id, clm_from_dt, admtg_dgns_cd,  prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from ip19.inpatient_base_claims_2019
    where bene_id in (select bene_id from ad.Table1_study_nonad);
Quit;

proc sql;
    create table all_ip_claims_2020 as
    select bene_id, clm_from_dt, admtg_dgns_cd,  prncpal_dgns_cd, icd_dgns_cd1, icd_dgns_cd2, icd_dgns_cd3, icd_dgns_cd4,icd_dgns_cd5
,icd_dgns_cd6, icd_dgns_cd7, icd_dgns_cd8, icd_dgns_cd9, icd_dgns_cd10, icd_dgns_cd11, icd_dgns_cd12, icd_dgns_cd13, icd_dgns_cd14,
icd_dgns_cd15, icd_dgns_cd16, icd_dgns_cd17, icd_dgns_cd18, icd_dgns_cd19, icd_dgns_cd20, icd_dgns_cd21, icd_dgns_cd22,
icd_dgns_cd23, icd_dgns_cd24, icd_dgns_cd25 from ip20.inpatient_base_claims_2020
    where bene_id in (select bene_id from ad.Table1_study_nonad);
Quit;

/* combine for nonAD */
data ad.nonad_other_ip_claims_study;
  set all_ip_claims_2016 all_ip_claims_2017 all_ip_claims_2018 all_ip_claims_2019 all_ip_claims_2020;
run;
data ad.nonad_other_op_claims_study;
  set all_op_claims_2016 all_op_claims_2017 all_op_claims_2018 all_op_claims_2019 all_op_claims_2020;
run;

proc sort data=ad.ad_other_ip_claims_study;
  by bene_id;
run;
proc sort data=ad.ad_other_op_claims_study;
  by bene_id;
run;
  proc sort data=ad.nonad_other_ip_claims_study;
  by bene_id;
run;
  proc sort data=ad.nonad_other_op_claims_study;
  by bene_id;
run;

/* combine ip and op */
data ad.all_other_ip_claims_study;
  set ad.ad_other_ip_claims_study ad.nonad_other_ip_claims_study;
run;

data ad.all_other_op_claims_study;
  set ad.ad_other_op_claims_study ad.nonad_other_op_claims_study;
run;

/* add index date */
proc sql;
  create table ad.all_other_op_claims_study as
  select a.*, b.index_date
  from ad.all_other_op_claims_study as a
  left join ad.exclude65_id as b
  on a.bene_id = b.bene_id;
quit;

proc sql;
  create table ad.all_other_ip_claims_study as
  select a.*, b.index_date
  from ad.all_other_ip_claims_study as a
  left join ad.exclude65_id as b
  on a.bene_id = b.bene_id;
quit;


////////////////////////// comorbidities /////////////////////////////
////////////////////////  Myocardial Infarction /////////////////////////////
data flag_MI_op;
 set ad.all_other_op_claims_study;
 if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('I21','I22','I252') or icd_dgns_cd1 in: ('I21','I22','I252') or icd_dgns_cd2 in: ('I21','I22','I252') or
                                                 icd_dgns_cd3 in: ('I21','I22','I252') or icd_dgns_cd4 in: ('I21','I22','I252') or icd_dgns_cd5 in: ('I21','I22','I252') or
                                                 icd_dgns_cd6 in: ('I21','I22','I252') or icd_dgns_cd7 in: ('I21','I22','I252') or icd_dgns_cd8 in: ('I21','I22','I252') or
                                                 icd_dgns_cd9 in: ('I21','I22','I252') or icd_dgns_cd10 in: ('I21','I22','I252') or icd_dgns_cd11 in: ('I21','I22','I252') or
                                                 icd_dgns_cd12 in: ('I21','I22','I252') or icd_dgns_cd13 in: ('I21','I22','I252') or icd_dgns_cd14 in: ('I21','I22','I252') or
                                                 icd_dgns_cd15 in: ('I21','I22','I252') or icd_dgns_cd16 in: ('I21','I22','I252') or icd_dgns_cd17 in: ('I21','I22','I252') or
                                                 icd_dgns_cd18 in: ('I21','I22','I252') or icd_dgns_cd19 in: ('I21','I22','I252') or icd_dgns_cd20 in: ('I21','I22','I252') or
                                                 icd_dgns_cd21 in: ('I21','I22','I252') or icd_dgns_cd22 in: ('I21','I22','I252') or icd_dgns_cd23 in: ('I21','I22','I252') or
                                                 icd_dgns_cd24 in: ('I21','I22','I252') or icd_dgns_cd25 in: ('I21','I22','I252')) then flag = 1;
 else flag = 0;
    keep bene_id flag;
run;
data flag_MI_ip;
 set ad.all_other_ip_claims_study;
 if (0 <= (index_date - clm_from_dt) <=365) and (admtg_dgns_cd in: ('I21','I22','I252') or
                                                 prncpal_dgns_cd in: ('I21','I22','I252') or icd_dgns_cd1 in: ('I21','I22','I252') or icd_dgns_cd2 in: ('I21','I22','I252') or
                                                 icd_dgns_cd3 in: ('I21','I22','I252') or icd_dgns_cd4 in: ('I21','I22','I252') or icd_dgns_cd5 in: ('I21','I22','I252') or
                                                 icd_dgns_cd6 in: ('I21','I22','I252') or icd_dgns_cd7 in: ('I21','I22','I252') or icd_dgns_cd8 in: ('I21','I22','I252') or
                                                 icd_dgns_cd9 in: ('I21','I22','I252') or icd_dgns_cd10 in: ('I21','I22','I252') or icd_dgns_cd11 in: ('I21','I22','I252') or
                                                 icd_dgns_cd12 in: ('I21','I22','I252') or icd_dgns_cd13 in: ('I21','I22','I252') or icd_dgns_cd14 in: ('I21','I22','I252') or
                                                 icd_dgns_cd15 in: ('I21','I22','I252') or icd_dgns_cd16 in: ('I21','I22','I252') or icd_dgns_cd17 in: ('I21','I22','I252') or
                                                 icd_dgns_cd18 in: ('I21','I22','I252') or icd_dgns_cd19 in: ('I21','I22','I252') or icd_dgns_cd20 in: ('I21','I22','I252') or
                                                 icd_dgns_cd21 in: ('I21','I22','I252') or icd_dgns_cd22 in: ('I21','I22','I252') or icd_dgns_cd23 in: ('I21','I22','I252') or
                                                 icd_dgns_cd24 in: ('I21','I22','I252') or icd_dgns_cd25 in: ('I21','I22','I252')) then flag = 1;
else flag = 0;
    keep bene_id flag;
run;

proc sql;
   create table flag_MI as
   select bene_id,
          max(flag) as flag_MI
   from (
      select bene_id, flag from flag_MI_op
      union all
      select bene_id, flag from flag_MI_ip
   ) as combined
   group by bene_id;
quit;

data ad.table1_study_AD;
  merge ad.table1_study_AD(in=a)
        flag_MI(in=b);
  by bene_id;
  if a and b;
run;
data ad.table1_study_nonad;
  merge ad.table1_study_nonad(in=a)
        flag_MI(in=b);
  by bene_id;
  if a and b;
run;

/* Calculate counts and percentages for MI */
 proc freq data=ad.Table1_study_AD;
     tables flag_MI;
 run;
 proc freq data=ad.Table1_study_nonad;
     tables flag_MI;
 run;


///////////////////////// Congestive Heart Failure //////////////////////
data flag_CHF_op;
  set ad.all_other_op_claims_study;
 if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd1 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd2 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd3 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd4 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd5 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd6 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd7 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd8 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd9 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd10 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd11 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd12 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd13 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd14 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd15 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd16 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd17 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd18 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd19 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd20 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd21 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd22 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd23 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd24 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd25 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290')) then flag=1;
 else flag = 0;
    keep bene_id flag;
run;

data flag_CHF_ip;
  set ad.all_other_ip_claims_study;
 if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 admtg_dgns_cd in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd1 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd2 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd3 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd4 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd5 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd6 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd7 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd8 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd9 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd10 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd11 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd12 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd13 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd14 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd15 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd16 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd17 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd18 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd19 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd20 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd21 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd22 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd23 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd24 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290') or
                                                 icd_dgns_cd25 in: ('I110','I130','I132','I255','I420','I425','I426','I427','I428','I429','I43','I50','P290')) then flag=1;
 else flag = 0;
    keep bene_id flag;
run;

proc sql;
   create table flag_CHF as
   select bene_id,
          max(flag) as flag_CHF
   from (
      select bene_id, flag from flag_CHF_op
      union all
      select bene_id, flag from flag_CHF_ip
   ) as combined
   group by bene_id;
quit;

data ad.table1_study_ad;
  merge ad.table1_study_ad(in=a)
        flag_CHF(in=b);
  by bene_id;
  if a and b;
run;
data ad.table1_study_nonad;
  merge ad.table1_study_nonad(in=a)
        flag_CHF(in=b);
  by bene_id;
  if a and b;
run;

/* Calculate counts and percentages for CHF */
 proc freq data=ad.Table1_study_ad;
     tables flag_CHF;
 run;
 proc freq data=ad.Table1_study_nonad;
     tables flag_CHF;
 run;


////////////////////// Peripheral Vascular Disease ///////////////////
data flag_PVD_op;
  set ad.all_other_op_claims_study;
  if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd1 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd2 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd3 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd4 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd5 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd6 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd7 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd8 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd9 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd10 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd11 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd12 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd13 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd14 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd15 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd16 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd17 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd18 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd19 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd20 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd21 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd22 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd23 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd24 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd25 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959')) then flag=1;
 else flag = 0;
    keep bene_id flag;
run;

data flag_PVD_ip;
  set ad.all_other_ip_claims_study;
  if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  admtg_dgns_cd in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd1 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd2 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd3 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd4 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd5 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd6 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd7 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd8 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd9 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd10 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd11 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd12 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd13 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd14 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd15 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd16 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd17 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd18 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd19 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd20 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd21 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd22 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd23 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd24 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959') OR
                                                  icd_dgns_cd25 in: ('I70','I71','I731','I738','I739','I771','I790','I791','I798','K551','K558','K559','Z958','Z959')) then flag=1;
 else flag = 0;
    keep bene_id flag;
run;

proc sql;
   create table flag_PVD as
   select bene_id,
          max(flag) as flag_PVD
   from (
      select bene_id, flag from flag_PVD_op
      union all
      select bene_id, flag from flag_PVD_ip
   ) as combined
   group by bene_id;
quit;

data ad.table1_study_ad;
  merge ad.table1_study_ad(in=a)
        flag_PVD(in=b);
  by bene_id;
  if a and b;
run;
data ad.table1_study_nonad;
  merge ad.table1_study_nonad(in=a)
        flag_PVD(in=b);
  by bene_id;
  if a and b;
run;

/* Calculate counts and percentages for PVD */
 proc freq data=ad.Table1_study_ad;
     tables flag_PVD;
 run;
 proc freq data=ad.Table1_study_nonad;
     tables flag_PVD;
 run;


////////////////////////// Cerebrovascular Disease ///////////////////////////////
data flag_CD_op;
  set ad.all_other_op_claims_study;
  if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd1 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd2 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd3 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd4 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd5 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd6 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd7 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd8 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd9 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd10 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd11 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd12 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd13 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd14 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd15 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd16 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd17 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd18 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd19 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd20 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd21 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd22 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd23 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd24 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd25 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68')) then flag=1;
 else flag = 0;
    keep bene_id flag;
run;

data flag_CD_ip;
  set ad.all_other_ip_claims_study;
  if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  admtg_dgns_cd in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd1 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd2 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd3 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd4 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd5 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd6 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd7 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd8 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd9 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd10 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd11 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd12 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd13 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd14 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd15 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd16 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd17 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd18 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd19 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd20 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd21 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd22 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd23 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd24 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68') or
                                                  icd_dgns_cd25 in: ('G45','G46','H340','H341','H342','I60','I61','I62','I63','I64','I65','I66','I67','I68')) then flag=1;
 else flag = 0;
    keep bene_id flag;
run;

proc sql;
   create table flag_CD as
   select bene_id,
          max(flag) as flag_CD
   from (
      select bene_id, flag from flag_CD_op
      union all
      select bene_id, flag from flag_CD_ip
   ) as combined
   group by bene_id;
quit;

data ad.table1_study_ad;
  merge ad.table1_study_ad(in=a)
        flag_CD(in=b);
  by bene_id;
  if a and b;
run;
data ad.table1_study_nonad;
  merge ad.table1_study_nonad(in=a)
        flag_CD(in=b);
  by bene_id;
  if a and b;
run;

/* Calculate counts and percentages for CD */
 proc freq data=ad.Table1_study_ad;
     tables flag_CD;
 run;
 proc freq data=ad.Table1_study_nonad;
     tables flag_CD;
 run;


////////////////// COPD ///////////////////////
data flag_COPD_op;
  set ad.all_other_op_claims_study;
  if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd1 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd2 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd3 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd4 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd5 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd6 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd7 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd8 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd9 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd10 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd11 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd12 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd13 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd14 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd15 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd16 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd17 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd18 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd19 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd20 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd21 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd22 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd23 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd24 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd25 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703')) then flag=1;
else flag = 0;
    keep bene_id flag;
run;

data flag_COPD_ip;
  set ad.all_other_ip_claims_study;
  if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  admtg_dgns_cd in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd1 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd2 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd3 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd4 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd5 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd6 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd7 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd8 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd9 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd10 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd11 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd12 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd13 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd14 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd15 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd16 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd17 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd18 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd19 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd20 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd21 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd22 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd23 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd24 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703') OR
                                                  icd_dgns_cd25 in: ('J40','J41','J42','J43','J44','J45','J46','J47','J60','J61','J62','J63','J64','J65','J66','J67','J684',
                                                                       'J701','J703')) then flag=1;
else flag = 0;
    keep bene_id flag;
run;

proc sql;
   create table flag_COPD as
   select bene_id,
          max(flag) as flag_COPD
   from (
      select bene_id, flag from flag_COPD_op
      union all
      select bene_id, flag from flag_COPD_ip
   ) as combined
   group by bene_id;
quit;

data ad.table1_study_ad;
  merge ad.table1_study_ad(in=a)
        flag_COPD(in=b);
  by bene_id;
  if a and b;
run;
data ad.table1_study_nonad;
  merge ad.table1_study_nonad(in=a)
        flag_COPD(in=b);
  by bene_id;
  if a and b;
run;

/* Calculate counts and percentages for COPD */
 proc freq data=ad.Table1_study_ad;
     tables flag_COPD;
 run;
 proc freq data=ad.Table1_study_nonad;
     tables flag_COPD;
 run;


////////////////// Rheumatologic Disease ////////////////////
 data flag_RD_op;
   set ad.all_other_op_claims_study;
   if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd1 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd2 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd3 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd4 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd5 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd6 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd7 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd8 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd9 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd10 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd11 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd12 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd13 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd14 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd15 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd16 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd17 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd18 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd19 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd20 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd21 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd22 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd23 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd24 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd25 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360')) then flag=1;
 else flag = 0;
     keep bene_id flag;
 run;

data flag_RD_ip;
   set ad.all_other_ip_claims_study;
   if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   admtg_dgns_cd in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd1 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd2 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd3 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd4 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd5 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd6 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd7 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd8 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd9 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd10 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd11 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd12 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd13 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd14 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd15 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd16 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd17 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd18 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd19 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd20 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd21 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd22 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd23 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd24 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360') or
                                                   icd_dgns_cd25 in: ('M05','M06','M315','M32','M33','M34','M351','M353','M360')) then flag=1;
 else flag = 0;
     keep bene_id flag;
 run;

 proc sql;
    create table flag_RD as
    select bene_id,
           max(flag) as flag_RD
    from (
       select bene_id, flag from flag_RD_op
       union all
       select bene_id, flag from flag_RD_ip
    ) as combined
    group by bene_id;
 quit;

 data ad.table1_study_ad;
   merge ad.table1_study_ad(in=a)
         flag_RD(in=b);
   by bene_id;
   if a and b;
 run;
 data ad.table1_study_nonad;
   merge ad.table1_study_nonad(in=a)
         flag_RD(in=b);
   by bene_id;
   if a and b;
 run;

 /* Calculate counts and percentages for RD */
  proc freq data=ad.Table1_study_ad;
      tables flag_RD;
  run;
  proc freq data=ad.Table1_study_nonad;
      tables flag_RD;
  run;

 
///////////////// Liver Disease ///////////////////
/* Liver Disease */
data flag_liver_op;
  set ad.all_other_op_claims_study;
  if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                       'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd1 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd2 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd3 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd4 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd5 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd6 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd7 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd8 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd9 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd10 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd11 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd12 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd13 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd14 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd15 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd16 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd17 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd18 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd19 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd20 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd21 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd22 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd23 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd24 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd25 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729')) then flag=1;
else flag = 0;
    keep bene_id flag;
run;

data flag_liver_ip;
  set ad.all_other_ip_claims_study;
  if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                       'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  admtg_dgns_cd in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd1 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd2 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd3 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd4 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd5 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd6 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd7 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd8 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd9 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd10 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd11 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd12 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd13 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd14 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd15 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd16 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd17 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd18 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd19 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd20 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd21 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd22 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd23 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd24 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                  icd_dgns_cd25 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                     'K764','K768','K769','Z944','I850','I864','K704','K711','K721','K765','K766','K767','K729')) then flag=1;
else flag = 0;
    keep bene_id flag;
run;

proc sql;
   create table flag_liver as
   select bene_id,
          max(flag) as flag_liver
   from (
      select bene_id, flag from flag_liver_op
      union all
      select bene_id, flag from flag_liver_ip
   ) as combined
   group by bene_id;
quit;

data ad.table1_study_ad;
  merge ad.table1_study_ad(in=a)
        flag_liver(in=b);
  by bene_id;
  if a and b;
run;
data ad.table1_study_nonad;
  merge ad.table1_study_nonad(in=a)
        flag_liver(in=b);
  by bene_id;
  if a and b;
run;

/* Calculate counts and percentages for Liver */
 proc freq data=ad.Table1_study_ad;
     tables flag_liver;
 run;
 proc freq data=ad.Table1_study_nonad;
     tables flag_liver;
 run;

////////////////// Moderate to severe Renal Disease //////////////////
data flag_Renal_op;
  set ad.all_other_op_claims_study;
  if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd1 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd2 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd3 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd4 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd5 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd6 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd7 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd8 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd9 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd10 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd11 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd12 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd13 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd14 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd15 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd16 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd17 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd18 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd19 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd20 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd21 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd22 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd23 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd24 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd25 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940')) then flag=1;
else flag = 0;
    keep bene_id flag;
run;

data flag_Renal_ip;
  set ad.all_other_ip_claims_study;
  if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  admtg_dgns_cd in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd1 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd2 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd3 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd4 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd5 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd6 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd7 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd8 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd9 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd10 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd11 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd12 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd13 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd14 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd15 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd16 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd17 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd18 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd19 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd20 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd21 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd22 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd23 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd24 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940') or
                                                  icd_dgns_cd25 in: ('I129','I130','I1310','N03','M05','N181','N182','N183','N184','N189','Z940')) then flag=1;
else flag = 0;
    keep bene_id flag;
run;

proc sql;
   create table flag_renal as
   select bene_id,
          max(flag) as flag_renal
   from (
      select bene_id, flag from flag_renal_op
      union all
      select bene_id, flag from flag_renal_ip
   ) as combined
   group by bene_id;
quit;

data ad.table1_study_ad;
  merge ad.table1_study_ad(in=a)
        flag_renal(in=b);
  by bene_id;
  if a and b;
run;
data ad.table1_study_nonad;
  merge ad.table1_study_nonad(in=a)
        flag_renal(in=b);
  by bene_id;
  if a and b;
run;

/* Calculate counts and percentages for Liver */
 proc freq data=ad.Table1_study_ad;
     tables flag_renal;
 run;
 proc freq data=ad.Table1_study_nonad;
     tables flag_renal;
 run;


//////////////// Hemiplegia /////////////////////
 data flag_Hemiplegia_op;
   set ad.all_other_op_claims_study;
   if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd1 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd2 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd3 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd4 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd5 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd6 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd7 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd8 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd9 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd10 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd11 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd12 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd13 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd14 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd15 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd16 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd17 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd18 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd19 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd20 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd21 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd22 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd23 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd24 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd25 in: ('G041','G114','G800','G801','G802','G81','G82','G83')) then flag=1;
 else flag = 0;
     keep bene_id flag;
 run;

 data flag_Hemiplegia_ip;
   set ad.all_other_ip_claims_study;
   if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   admtg_dgns_cd in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd1 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd2 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd3 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd4 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd5 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd6 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd7 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd8 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd9 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd10 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd11 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd12 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd13 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd14 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd15 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd16 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd17 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd18 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd19 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd20 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd21 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd22 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd23 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd24 in: ('G041','G114','G800','G801','G802','G81','G82','G83') or
                                                   icd_dgns_cd25 in: ('G041','G114','G800','G801','G802','G81','G82','G83')) then flag=1;
 else flag = 0;
     keep bene_id flag;
 run;

proc sql;
   create table flag_Hemiplegia as
   select bene_id,
          max(flag) as flag_Hemiplegia
   from (
      select bene_id, flag from flag_Hemiplegia_op
      union all
      select bene_id, flag from flag_Hemiplegia_ip
   ) as combined
   group by bene_id;
quit;

data ad.table1_study_ad;
  merge ad.table1_study_ad(in=a)
        flag_Hemiplegia(in=b);
  by bene_id;
  if a and b;
run;
data ad.table1_study_nonad;
  merge ad.table1_study_nonad(in=a)
        flag_Hemiplegia(in=b);
  by bene_id;
  if a and b;
run;

/* Calculate counts and percentages for Hemiplegia */
 proc freq data=ad.Table1_study_ad;
     tables flag_Hemiplegia;
 run;
 proc freq data=ad.Table1_study_nonad;
     tables flag_Hemiplegia;
 run;


 
///////////////// Solid Tumor ///////////////////// 
 /* Solid Tumor */
data flag_ST_op;
  set ad.all_other_op_claims_study;
  if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd1 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd2 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd3 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd4 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd5 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd6 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd7 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd8 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd9 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd10 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd11 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd12 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd13 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd14 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd15 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd16 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd17 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd18 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd19 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd20 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd21 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd22 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd23 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd24 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd25 in: ('C77','C78','C79','C800','C801','c801'))
                                                  then flag=1;
else flag = 0;
    keep bene_id flag;
run;

data flag_ST_ip;
  set ad.all_other_ip_claims_study;
  if (0 <= (index_date - clm_from_dt) <=365) and (admtg_dgns_cd in: ('C77','C78','C79','C800','C801','c801') or
                                                  prncpal_dgns_cd in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd1 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd2 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd3 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd4 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd5 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd6 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd7 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd8 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd9 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd10 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd11 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd12 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd13 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd14 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd15 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd16 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd17 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd18 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd19 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd20 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd21 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd22 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd23 in: ('C77','C78','C79','C800','C801','c801') or
                                                  icd_dgns_cd24 in: ('C77','C78','C79','C800','C801','c801') or icd_dgns_cd25 in: ('C77','C78','C79','C800','C801','c801'))
                                                  then flag=1;
else flag = 0;
    keep bene_id flag;
run;

proc sql;
   create table flag_ST as
   select bene_id,
          max(flag) as flag_ST
   from (
      select bene_id, flag from flag_ST_op
      union all
      select bene_id, flag from flag_ST_ip
   ) as combined
   group by bene_id;
quit;
 
data ad.table1_study_ad;
  merge ad.table1_study_ad(in=a)
        flag_ST(in=b);
  by bene_id;
  if a and b;
run;
data ad.table1_study_nonad;
  merge ad.table1_study_nonad(in=a)
        flag_ST(in=b);
  by bene_id;
  if a and b;
run;

/* Calculate counts and percentages for RD */
 proc freq data=ad.Table1_study_AD;
     tables flag_ST;
 run;
 proc freq data=ad.Table1_study_nonAD;
     tables flag_ST;
 run;




/////////////////// AIDS ///////////////////////
data flag_aids_op;
  set ad.all_other_op_claims_study;
  if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd1 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd2 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd3 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd4 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd5 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd6 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd7 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd8 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd9 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd10 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd11 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd12 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd13 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd14 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd15 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd16 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd17 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd18 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd19 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd20 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd21 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd22 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd23 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd24 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd25 in: ('B20','B21','B220','B221','B222', 'B24'))
                                                  then flag=1;
else flag = 0;
    keep bene_id flag;
run;

data flag_aids_ip;
  set ad.all_other_ip_claims_study;
  if (0 <= (index_date - clm_from_dt) <=365) and (admtg_dgns_cd in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  prncpal_dgns_cd in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd1 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd2 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd3 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd4 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd5 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd6 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd7 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd8 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd9 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd10 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd11 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd12 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd13 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd14 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd15 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd16 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd17 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd18 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd19 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd20 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd21 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd22 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd23 in: ('B20','B21','B220','B221','B222', 'B24') or
                                                  icd_dgns_cd24 in: ('B20','B21','B220','B221','B222', 'B24') or icd_dgns_cd25 in: ('B20','B21','B220','B221','B222', 'B24'))
                                                  then flag=1;
else flag = 0;
    keep bene_id flag;
run;

proc sql;
   create table flag_AIDS as
   select bene_id,
          max(flag) as flag_AIDS
   from (
      select bene_id, flag from flag_AIDS_op
      union all
      select bene_id, flag from flag_AIDS_ip
   ) as combined
   group by bene_id;
quit;

data ad.table1_study_ad;
  merge ad.table1_study_ad(in=a)
        flag_AIDS(in=b);
  by bene_id;
  if a and b;
run;
data ad.table1_study_nonad;
  merge ad.table1_study_nonad(in=a)
        flag_AIDS(in=b);
  by bene_id;
  if a and b;
run;

/* Calculate counts and percentages for AIDS */
 proc freq data=ad.Table1_study_AD;
     tables flag_AIDS;
 run;
 proc freq data=ad.Table1_study_nonAD;
     tables flag_AIDS;
 run;



//////////////////// Leukemia /////////////////////////
/* Leukemia */
data flag_Leukemia_op;
  set ad.all_other_op_claims_study;
  if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('C91','C92','C93','C94','C95') or icd_dgns_cd1 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd2 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd3 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd4 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd5 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd6 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd7 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd8 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd9 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd10 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd11 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd12 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd13 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd14 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd15 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd16 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd17 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd18 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd19 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd20 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd21 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd22 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd23 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd24 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd25 in: ('C91','C92','C93','C94','C95')) then flag=1;
else flag = 0;
    keep bene_id flag;
run;

data flag_Leukemia_ip;
  set ad.all_other_ip_claims_study;
  if (0 <= (index_date - clm_from_dt) <=365) and (admtg_dgns_cd in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd2 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd3 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd4 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd5 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd6 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd7 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd8 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd9 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd10 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd11 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd12 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd13 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd14 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd15 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd16 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd17 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd18 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd19 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd20 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd21 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd22 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd23 in: ('C91','C92','C93','C94','C95') or
                                                  icd_dgns_cd24 in: ('C91','C92','C93','C94','C95') or icd_dgns_cd25 in: ('C91','C92','C93','C94','C95')) then flag=1;
else flag = 0;
    keep bene_id flag;
run;

proc sql;
   create table flag_Leukemia as
   select bene_id,
          max(flag) as flag_Leukemia
   from (
      select bene_id, flag from flag_Leukemia_op
      union all
      select bene_id, flag from flag_Leukemia_ip
   ) as combined
   group by bene_id;
quit;

data ad.table1_study_ad;
  merge ad.table1_study_ad(in=a)
        flag_Leukemia(in=b);
  by bene_id;
  if a and b;
run;
data ad.table1_study_nonad;
  merge ad.table1_study_nonad(in=a)
        flag_Leukemia(in=b);
  by bene_id;
  if a and b;
run;

/* Calculate counts and percentages for Leukemia */
 proc freq data=ad.Table1_study_AD;
     tables flag_Leukemia;
 run;
 proc freq data=ad.Table1_study_nonAD;
     tables flag_Leukemia;
 run;



//////////////// Malignant Lymphoma //////////////////////
/*malignancy*/
 data flag_malignancy_op;
   set ad.all_other_op_claims_study;
   if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                        'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                        'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                        'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                        'C96','C97') or
                                                   icd_dgns_cd1 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd2 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd3 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd4 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd5 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd6 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd7 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd8 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd9 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd10 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd11 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd12 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd13 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd14 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd15 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd16 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd17 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd18 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd19 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd20 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd21 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd22 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd23 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd24 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd25 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97')) then flag=1;
else flag = 0;
    keep bene_id flag;
run;


data flag_malignancy_ip;
   set ad.all_other_ip_claims_study;
   if (0 <= (index_date - clm_from_dt) <=365) and (admtg_dgns_cd in:('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   prncpal_dgns_cd in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                        'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                        'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                        'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                        'C96','C97') or
                                                   icd_dgns_cd1 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd2 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd3 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd4 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd5 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd6 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd7 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd8 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd9 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd10 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd11 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd12 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd13 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd14 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd15 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd16 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd17 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd18 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd19 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd20 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd21 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd22 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd23 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd24 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97') or
                                                   icd_dgns_cd25 in: ('C00','C01','C02','C03','C04','C05','C06','C07','C08','C09','C10','C11','C12','C13','C14','C15','C16','C17','C18',
                                                                     'C19','C20','C21','C22','C23','C24','C25','C26','C30','C31','C32','C33','C34','C37','C38','C39','C40','C41','C43',
                                                                     'C45','C46','C47','C48','C49','C50','C51','C52','C53','C54','C55','C56','C57','C58','C60','C61','C62','C63','C64',
                                                                     'C65','C66','C67','C68','C69','C70','C71','C72','C73','C74','C75','C76','C81','C82','C83','C84','C85','C88','C90',
                                                                     'C96','C97')) then flag=1;
else flag = 0;
    keep bene_id flag;
run;

proc sql;
   create table flag_malignancy as
   select bene_id,
          max(flag) as flag_malignancy
   from (
      select bene_id, flag from flag_malignancy_op
      union all
      select bene_id, flag from flag_malignancy_ip
   ) as combined
   group by bene_id;
quit;

data ad.table1_study_ad;
  merge ad.table1_study_ad(in=a)
        flag_malignancy(in=b);
  by bene_id;
  if a and b;
run;
data ad.table1_study_nonad;
  merge ad.table1_study_nonad(in=a)
        flag_malignancy(in=b);
  by bene_id;
  if a and b;
run;

/* Calculate counts and percentages for malignancy */
 proc freq data=ad.Table1_study_AD;
     tables flag_malignancy;
 run;
 proc freq data=ad.Table1_study_nonAD;
     tables flag_malignancy;
 run;



//////////////////////// CCI /////////////////////////////
data CCI_with_ad;
  set ad.table1_study_ad(keep = bene_id age flag_MI flag_CHF flag_PVD flag_CD flag_RD flag_renal fLag_Hemiplegia flag_AIDS flag_Leukemia
                               flag_malignancy flag_PUD flag_COPD);
run;
data CCI_non_ad;
  set ad.table1_study_nonad(keep = bene_id age flag_MI flag_CHF flag_PVD flag_CD flag_RD flag_renal fLag_Hemiplegia flag_AIDS flag_Leukemia
                               flag_malignancy flag_PUD flag_COPD);
run;


/* classify mild or severe liver disease */
data flag_mild_liver_op;
  set ad.all_other_op_claims_study;
    if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                         'K764','K768','K769','Z944') or
                                                    icd_dgns_cd1 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd2 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd3 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd4 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd5 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd6 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd7 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd8 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd9 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd10 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd11 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd12 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd13 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd14 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd15 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd16 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd17 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd18 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd19 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd20 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd21 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd22 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd23 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd24 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd25 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944')) then flag=1;
else flag = 0;
    keep bene_id flag;
run;


data flag_mild_liver_ip;
  set ad.all_other_ip_claims_study;
    if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    admtg_dgns_cd in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd1 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd2 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd3 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd4 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd5 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd6 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd7 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd8 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd9 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd10 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd11 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd12 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd13 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd14 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd15 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd16 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd17 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd18 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd19 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd20 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd21 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd22 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd23 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd24 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944') or
                                                    icd_dgns_cd25 in: ('B18','K700','K701','K702','K703','K709','K713','K714','K715','K717','K73','K74','K760','K762','K763',
                                                                      'K764','K768','K769','Z944')) then flag=1;
else flag = 0;
    keep bene_id flag;
run;

proc sql;
   create table flag_mild_liver as
   select bene_id,
          max(flag) as flag_mild_liver
   from (
      select bene_id, flag from flag_mild_liver_op
      union all
      select bene_id, flag from flag_mild_liver_ip
   ) as combined
   group by bene_id;
quit;

data CCI_with_ad;
  merge CCI_with_ad(in=a)
        flag_mild_liver(in=b);
  by bene_id;
  if a and b;
run;
data CCI_non_ad;
  merge CCI_non_ad(in=a)
        flag_mild_liver(in=b);
  by bene_id;
  if a and b;
run;


data flag_severe_liver_op;
  set ad.all_other_op_claims_study;
    if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd1 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd2 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd3 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd4 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd5 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd6 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd7 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd8 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd9 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd10 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd11 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd12 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd13 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd14 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd15 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd16 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd17 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd18 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd19 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd20 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd21 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd22 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd23 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd24 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd25 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729')) then flag=1;
else flag = 0;
    keep bene_id flag;
run;

data flag_severe_liver_ip;
  set ad.all_other_ip_claims_study;
    if (0 <= (index_date - clm_from_dt) <=365) and (admtg_dgns_cd in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    prncpal_dgns_cd in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd1 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd2 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd3 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd4 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd5 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd6 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd7 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd8 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd9 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd10 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd11 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd12 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd13 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd14 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd15 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd16 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd17 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd18 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd19 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd20 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd21 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd22 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd23 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd24 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729') or
                                                    icd_dgns_cd25 in: ('I850','I864','K704','K711','K721','K765','K766','K767','K729')) then flag=1;
else flag = 0;
    keep bene_id flag;
run;

proc sql;
   create table flag_severe_liver as
   select bene_id,
          max(flag) as flag_severe_liver
   from (
      select bene_id, flag from flag_severe_liver_op
      union all
      select bene_id, flag from flag_severe_liver_ip
   ) as combined
   group by bene_id;
quit;

data CCI_with_ad;
  merge CCI_with_ad(in=a)
        flag_severe_liver(in=b);
  by bene_id;
  if a and b;
run;
data CCI_non_ad;
  merge CCI_non_ad(in=a)
        flag_severe_liver(in=b);
  by bene_id;
  if a and b;
run;

/* Classify TB */
data flag_meta_ST_op;
  set ad.all_other_op_claims_study;
    if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('C77','C78','C79') or icd_dgns_cd1 in: ('C77','C78','C79') or icd_dgns_cd2 in: ('C77','C78','C79') or
                                                    icd_dgns_cd3 in: ('C77','C78','C79') or icd_dgns_cd4 in: ('C77','C78','C79') or icd_dgns_cd5 in: ('C77','C78','C79') or
                                                    icd_dgns_cd6 in: ('C77','C78','C79') or icd_dgns_cd7 in: ('C77','C78','C79') or icd_dgns_cd8 in: ('C77','C78','C79') or
                                                    icd_dgns_cd9 in: ('C77','C78','C79') or icd_dgns_cd10 in: ('C77','C78','C79') or icd_dgns_cd11 in: ('C77','C78','C79') or
                                                    icd_dgns_cd12 in: ('C77','C78','C79') or icd_dgns_cd13 in: ('C77','C78','C79') or icd_dgns_cd14 in: ('C77','C78','C79') or
                                                    icd_dgns_cd15 in: ('C77','C78','C79') or icd_dgns_cd16 in: ('C77','C78','C79') or icd_dgns_cd17 in: ('C77','C78','C79') or
                                                    icd_dgns_cd18 in: ('C77','C78','C79') or icd_dgns_cd19 in: ('C77','C78','C79') or icd_dgns_cd20 in: ('C77','C78','C79') or
                                                    icd_dgns_cd21 in: ('C77','C78','C79') or icd_dgns_cd22 in: ('C77','C78','C79') or icd_dgns_cd23 in: ('C77','C78','C79') or
                                                    icd_dgns_cd24 in: ('C77','C78','C79') or icd_dgns_cd25 in: ('C77','C78','C79')) then flag=1;
else flag = 0;
    keep bene_id flag;
run;

data flag_meta_ST_ip;
  set ad.all_other_ip_claims_study;
    if (0 <= (index_date - clm_from_dt) <=365) and (admtg_dgns_cd in: ('C77','C78','C79') or
                                                    prncpal_dgns_cd in: ('C77','C78','C79') or icd_dgns_cd1 in: ('C77','C78','C79') or icd_dgns_cd2 in: ('C77','C78','C79') or
                                                    icd_dgns_cd3 in: ('C77','C78','C79') or icd_dgns_cd4 in: ('C77','C78','C79') or icd_dgns_cd5 in: ('C77','C78','C79') or
                                                    icd_dgns_cd6 in: ('C77','C78','C79') or icd_dgns_cd7 in: ('C77','C78','C79') or icd_dgns_cd8 in: ('C77','C78','C79') or
                                                    icd_dgns_cd9 in: ('C77','C78','C79') or icd_dgns_cd10 in: ('C77','C78','C79') or icd_dgns_cd11 in: ('C77','C78','C79') or
                                                    icd_dgns_cd12 in: ('C77','C78','C79') or icd_dgns_cd13 in: ('C77','C78','C79') or icd_dgns_cd14 in: ('C77','C78','C79') or
                                                    icd_dgns_cd15 in: ('C77','C78','C79') or icd_dgns_cd16 in: ('C77','C78','C79') or icd_dgns_cd17 in: ('C77','C78','C79') or
                                                    icd_dgns_cd18 in: ('C77','C78','C79') or icd_dgns_cd19 in: ('C77','C78','C79') or icd_dgns_cd20 in: ('C77','C78','C79') or
                                                    icd_dgns_cd21 in: ('C77','C78','C79') or icd_dgns_cd22 in: ('C77','C78','C79') or icd_dgns_cd23 in: ('C77','C78','C79') or
                                                    icd_dgns_cd24 in: ('C77','C78','C79') or icd_dgns_cd25 in: ('C77','C78','C79')) then flag=1;
else flag = 0;
    keep bene_id flag;
run;

proc sql;
   create table flag_meta_ST as
   select bene_id,
          max(flag) as flag_meta_ST
   from (
      select bene_id, flag from flag_meta_ST_op
      union all
      select bene_id, flag from flag_meta_ST_ip
   ) as combined
   group by bene_id;
quit;

data CCI_with_Ad;
  merge CCI_with_Ad(in=a)
        flag_meta_ST(in=b);
  by bene_id;
  if a and b;
run;
data CCI_non_Ad;
  merge CCI_non_Ad(in=a)
        flag_meta_ST(in=b);
  by bene_id;
  if a and b;
run;

data flag_local_st_op;
  set ad.all_other_op_claims_study;
    if (0 <= (index_date - clm_from_dt) <=365) and (prncpal_dgns_cd in: ('C800','C801','c801') or icd_dgns_cd1 in: ('C800','C801','c801') or
                                                    icd_dgns_cd2 in: ('C800','C801','c801') or icd_dgns_cd3 in: ('C800','C801','c801') or
                                                    icd_dgns_cd4 in: ('C800','C801','c801') or icd_dgns_cd5 in: ('C800','C801','c801') or
                                                    icd_dgns_cd6 in: ('C800','C801','c801') or icd_dgns_cd7 in: ('C800','C801','c801') or
                                                    icd_dgns_cd8 in: ('C800','C801','c801') or icd_dgns_cd9 in: ('C800','C801','c801') or
                                                    icd_dgns_cd10 in: ('C800','C801','c801') or icd_dgns_cd11 in: ('C800','C801','c801') or
                                                    icd_dgns_cd12 in: ('C800','C801','c801') or icd_dgns_cd13 in: ('C800','C801','c801') or
                                                    icd_dgns_cd14 in: ('C800','C801','c801') or icd_dgns_cd15 in: ('C800','C801','c801') or
                                                    icd_dgns_cd16 in: ('C800','C801','c801') or icd_dgns_cd17 in: ('C800','C801','c801') or
                                                    icd_dgns_cd18 in: ('C800','C801','c801') or icd_dgns_cd19 in: ('C800','C801','c801') or
                                                    icd_dgns_cd20 in: ('C800','C801','c801') or icd_dgns_cd21 in: ('C800','C801','c801') or
                                                    icd_dgns_cd22 in: ('C800','C801','c801') or icd_dgns_cd23 in: ('C800','C801','c801') or
                                                    icd_dgns_cd24 in: ('C800','C801','c801') or icd_dgns_cd25 in: ('C800','C801','c801')) then flag=1;
else flag = 0;
    keep bene_id flag;
run;

data flag_local_st_ip;
  set ad.all_other_ip_claims_study;
    if (0 <= (index_date - clm_from_dt) <=365) and (admtg_dgns_cd in: ('C800','C801','c801') or
                                                    prncpal_dgns_cd in: ('C800','C801','c801') or icd_dgns_cd1 in: ('C800','C801','c801') or
                                                    icd_dgns_cd2 in: ('C800','C801','c801') or icd_dgns_cd3 in: ('C800','C801','c801') or
                                                    icd_dgns_cd4 in: ('C800','C801','c801') or icd_dgns_cd5 in: ('C800','C801','c801') or
                                                    icd_dgns_cd6 in: ('C800','C801','c801') or icd_dgns_cd7 in: ('C800','C801','c801') or
                                                    icd_dgns_cd8 in: ('C800','C801','c801') or icd_dgns_cd9 in: ('C800','C801','c801') or
                                                    icd_dgns_cd10 in: ('C800','C801','c801') or icd_dgns_cd11 in: ('C800','C801','c801') or
                                                    icd_dgns_cd12 in: ('C800','C801','c801') or icd_dgns_cd13 in: ('C800','C801','c801') or
                                                    icd_dgns_cd14 in: ('C800','C801','c801') or icd_dgns_cd15 in: ('C800','C801','c801') or
                                                    icd_dgns_cd16 in: ('C800','C801','c801') or icd_dgns_cd17 in: ('C800','C801','c801') or
                                                    icd_dgns_cd18 in: ('C800','C801','c801') or icd_dgns_cd19 in: ('C800','C801','c801') or
                                                    icd_dgns_cd20 in: ('C800','C801','c801') or icd_dgns_cd21 in: ('C800','C801','c801') or
                                                    icd_dgns_cd22 in: ('C800','C801','c801') or icd_dgns_cd23 in: ('C800','C801','c801') or
                                                    icd_dgns_cd24 in: ('C800','C801','c801') or icd_dgns_cd25 in: ('C800','C801','c801')) then flag=1;
else flag = 0;
    keep bene_id flag;
run;

proc sql;
   create table flag_local_ST as
   select bene_id,
          max(flag) as flag_local_ST
   from (
      select bene_id, flag from flag_local_ST_op
      union all
      select bene_id, flag from flag_local_ST_ip
   ) as combined
   group by bene_id;
quit;

data CCI_with_Ad;
  merge CCI_with_Ad(in=a)
        flag_local_ST(in=b);
  by bene_id;
  if a and b;
run;
data CCI_non_Ad;
  merge CCI_non_Ad(in=a)
        flag_local_ST(in=b);
  by bene_id;
  if a and b;
run;



/* calculate CCI */
data CCI_with_ad;
    set CCI_with_ad;

    /* Step 1: Assign points for each condition */
    /* Conditions scoring 1 point */
    score_MI = flag_MI;        /* Myocardial Infarction */
    score_CHF = flag_CHF;      /* Congestive Heart Failure */
    score_PVD = flag_PVD;      /* Peripheral Vascular Disease */
    score_CD = flag_CD;        /* Cerebrovascular Disease */
    score_COPD = flag_COPD;    /* Chronic Obstructive Pulmonary Disease */
    score_RD = flag_RD;        /* Rheumatologic Disease */
    score_PUD = flag_PUD;      /* Peptic Ulcer Disease */
    score_mild_liver = flag_mild_liver;  /* Mild Liver Disease */

/* Conditions scoring 2 points */
    score_renal = 2 * flag_renal;       /* Moderate to Severe Renal Disease */
    score_local_ST = 2 * flag_local_ST;
    score_leukemia = 2 * flag_leukemia; /* Leukemia */
    score_lymphoma = 2 * flag_malignancy; /* Malignant Lymphoma */
    score_Hemiplegia = 2 * flag_Hemiplegia;  /* Hemiplegia or Paraplegia */
/* Conditions scoring 3 points */
    score_severe_liver = 3 * flag_severe_liver;  /* Moderate to Severe Liver Disease */

/* Conditions scoring 6 points */
    score_meta_ST = 6 * flag_meta_ST;   /* Metastatic Solid Tumor */
    score_AIDS = 6 * flag_AIDS;              /* AIDS */

/* Step 2: Calculate total Charlson Comorbidity Index */
    charlson_index = sum(score_MI, score_CHF, score_PVD, score_CD, score_COPD,
                         score_RD, score_PUD, score_mild_liver, score_local_ST,
                         score_severe_liver, score_renal,
                         score_meta_ST, score_leukemia, score_lymphoma,
                         score_Hemiplegia, score_AIDS);
run;

proc means data=CCI_with_ad mean std min max;
    var charlson_index;
run;

proc freq data=CCI_with_ad;
    tables charlson_index;
run;

data CCI_non_ad;
    set CCI_non_ad;

    /* Step 1: Assign points for each condition */
    /* Conditions scoring 1 point */
    score_MI = flag_MI;        /* Myocardial Infarction */
    score_CHF = flag_CHF;      /* Congestive Heart Failure */
    score_PVD = flag_PVD;      /* Peripheral Vascular Disease */
    score_CD = flag_CD;        /* Cerebrovascular Disease */
    score_COPD = flag_COPD;    /* Chronic Obstructive Pulmonary Disease */
    score_RD = flag_RD;        /* Rheumatologic Disease */
    score_PUD = flag_PUD;      /* Peptic Ulcer Disease */
    score_mild_liver = flag_mild_liver;  /* Mild Liver Disease */

/* Conditions scoring 2 points */
    score_renal = 2 * flag_renal;       /* Moderate to Severe Renal Disease */
    score_local_ST = 2 * flag_local_ST;
    score_leukemia = 2 * flag_leukemia; /* Leukemia */
    score_lymphoma = 2 * flag_malignancy; /* Malignant Lymphoma */
    score_Hemiplegia = 2 * flag_Hemiplegia;  /* Hemiplegia or Paraplegia */
/* Conditions scoring 3 points */
    score_severe_liver = 3 * flag_severe_liver;  /* Moderate to Severe Liver Disease */

/* Conditions scoring 6 points */
    score_meta_ST = 6 * flag_meta_ST;   /* Metastatic Solid Tumor */
    score_AIDS = 6 * flag_AIDS;              /* AIDS */

/* Step 2: Calculate total Charlson Comorbidity Index */
    charlson_index = sum(score_MI, score_CHF, score_PVD, score_CD, score_COPD,
                         score_RD, score_PUD, score_mild_liver, score_local_ST,
                         score_severe_liver, score_renal,
                         score_meta_ST, score_leukemia, score_lymphoma,
                         score_Hemiplegia, score_AIDS);
run;

proc means data=CCI_non_ad mean std min max;
    var charlson_index;
run;

proc freq data=CCI_non_ad;
    tables charlson_index;
run;


/* add CCI to table1 */
 data ad.table1_study_ad;
   merge ad.table1_study_ad(in=a)
         CCI_with_ad(keep=bene_id charlson_index in=b);
   by bene_id;
   if a and b;
 run;

data ad.table1_study_nonad;
   merge ad.table1_study_nonad(in=a)
         CCI_non_ad(keep=bene_id charlson_index in=b);
   by bene_id;
   if a and b;
 run;


/////////////////////////// Income /////////////////////////
data table1_study_ad;
  merge ad.table1_study_ad(in=a)
        ad.new_t2dm(in=b);
  by bene_id;
  if a and b;
run;

data table1_study_ad;
  set table1_study_ad;
  index_year = year(index_date);
run;



proc sql;
  create table merged_ad as
  select a.*, b.*
  from table1_study_ad as a
  left join ad.mbsf as b
  on a.bene_id = b.bene_id and a.index_year = b.BENE_ENROLLMT_REF_YR;
quit;


data merged_ad_income;
  set merged_ad;

  index_month = month(index_date);

  array lis_vars{12} $ CST_SHR_GRP_CD_01 - CST_SHR_GRP_CD_12;
  array dual_vars{12} $ DUAL_STUS_CD_01 - DUAL_STUS_CD_12;

  lis_flag = 0;
  dual_flag = 0;

  if lis_vars{index_month} in ('01','02','03','04','05','06','07','08') then lis_flag = 1;
  if dual_vars{index_month} not in ('NA', '00', '09', '99') then dual_flag = 1;

  if lis_flag = 1 or dual_flag = 1 then low_income = 1;
  else low_income = 0;

  drop index_month;
run;

proc freq data=merged_ad_income;
  tables low_income;
run;

data ad.Table1_study_ad;
  merge ad.Table1_study_ad(in=a)
        merged_ad_income(keep=bene_id low_income in=b);
  by bene_id;
  if a and b;
run;


/*nonAD group*/
data table1_study_nonad;
  merge ad.table1_study_nonad(in=a)
        ad.new_t2dm(in=b);
  by bene_id;
  if a and b;
run;

data table1_study_nonad;
  set table1_study_nonad;
  index_year = year(index_date);
run;

proc sql;
  create table merged_ad as
  select a.*, b.*
  from table1_study_nonad as a
  left join ad.mbsf as b
  on a.bene_id = b.bene_id and a.index_year = b.BENE_ENROLLMT_REF_YR;
quit;

data merged_ad_income;
  set merged_ad;

  index_month = month(index_date);

  array lis_vars{12} $ CST_SHR_GRP_CD_01 - CST_SHR_GRP_CD_12;
  array dual_vars{12} $ DUAL_STUS_CD_01 - DUAL_STUS_CD_12;

  lis_flag = 0;
  dual_flag = 0;

  if lis_vars{index_month} in ('01','02','03','04','05','06','07','08') then lis_flag = 1;
  if dual_vars{index_month} not in ('NA', '00', '09', '99') then dual_flag = 1;

  if lis_flag = 1 or dual_flag = 1 then low_income = 1;
  else low_income = 0;

  drop index_month;
run;

proc freq data=merged_ad_income;
  tables low_income;
run;

data ad.Table1_study_nonad;
  merge ad.Table1_study_nonad(in=a)
        merged_ad_income(keep=bene_id low_income in=b);
  by bene_id;
  if a and b;
run;
