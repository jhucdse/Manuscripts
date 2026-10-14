/* Extract patients with Type 1 diabetes from inpatient claims 2016-2020 */
Data ad.ip_T1DM_2016;
  set ip16.inpatient_base_claims_k_2016;
    where admtg_dgns_cd in: ('E10') or prncpal_dgns_cd in: ('E10') or icd_dgns_cd1 in: ('E10') or icd_dgns_cd2 in: ('E10') or icd_dgns_cd3 in: ('E10') or icd_dgns_cd4 in: ('E10') or
              icd_dgns_cd5 in: ('E10') or icd_dgns_cd6 in: ('E10') or icd_dgns_cd7 in: ('E10') or icd_dgns_cd8 in: ('E10') or icd_dgns_cd9 in: ('E10') or icd_dgns_cd10 in: ('E10') or
              icd_dgns_cd11 in: ('E10') or icd_dgns_cd12 in: ('E10') or icd_dgns_cd13 in: ('E10') or icd_dgns_cd14 in: ('E10') or icd_dgns_cd15 in: ('E10') or icd_dgns_cd16 in: ('E10') or
              icd_dgns_cd17 in: ('E10') or icd_dgns_cd18 in: ('E10') or icd_dgns_cd19 in: ('E10') or icd_dgns_cd20 in: ('E10') or icd_dgns_cd21 in: ('E10') or icd_dgns_cd22 in: ('E10') or
              icd_dgns_cd23 in: ('E10') or icd_dgns_cd24 in: ('E10') or icd_dgns_cd25 in: ('E10');
   run;

Data ad.ip_T1DM_2017;
  set ip17.inpatient_base_claims_k_2017;
    where admtg_dgns_cd in: ('E10') or prncpal_dgns_cd in: ('E10') or icd_dgns_cd1 in: ('E10') or icd_dgns_cd2 in: ('E10') or icd_dgns_cd3 in: ('E10') or icd_dgns_cd4 in: ('E10') or
              icd_dgns_cd5 in: ('E10') or icd_dgns_cd6 in: ('E10') or icd_dgns_cd7 in: ('E10') or icd_dgns_cd8 in: ('E10') or icd_dgns_cd9 in: ('E10') or icd_dgns_cd10 in: ('E10') or
              icd_dgns_cd11 in: ('E10') or icd_dgns_cd12 in: ('E10') or icd_dgns_cd13 in: ('E10') or icd_dgns_cd14 in: ('E10') or icd_dgns_cd15 in: ('E10') or icd_dgns_cd16 in: ('E10') or
              icd_dgns_cd17 in: ('E10') or icd_dgns_cd18 in: ('E10') or icd_dgns_cd19 in: ('E10') or icd_dgns_cd20 in: ('E10') or icd_dgns_cd21 in: ('E10') or icd_dgns_cd22 in: ('E10') or
              icd_dgns_cd23 in: ('E10') or icd_dgns_cd24 in: ('E10') or icd_dgns_cd25 in: ('E10');
   run;

Data ad.ip_T1DM_2018;
  set ip18.inpatient_base_claims_k_2018;
    where admtg_dgns_cd in: ('E10') or prncpal_dgns_cd in: ('E10') or icd_dgns_cd1 in: ('E10') or icd_dgns_cd2 in: ('E10') or icd_dgns_cd3 in: ('E10') or icd_dgns_cd4 in: ('E10') or
              icd_dgns_cd5 in: ('E10') or icd_dgns_cd6 in: ('E10') or icd_dgns_cd7 in: ('E10') or icd_dgns_cd8 in: ('E10') or icd_dgns_cd9 in: ('E10') or icd_dgns_cd10 in: ('E10') or
              icd_dgns_cd11 in: ('E10') or icd_dgns_cd12 in: ('E10') or icd_dgns_cd13 in: ('E10') or icd_dgns_cd14 in: ('E10') or icd_dgns_cd15 in: ('E10') or icd_dgns_cd16 in: ('E10') or
              icd_dgns_cd17 in: ('E10') or icd_dgns_cd18 in: ('E10') or icd_dgns_cd19 in: ('E10') or icd_dgns_cd20 in: ('E10') or icd_dgns_cd21 in: ('E10') or icd_dgns_cd22 in: ('E10') or
              icd_dgns_cd23 in: ('E10') or icd_dgns_cd24 in: ('E10') or icd_dgns_cd25 in: ('E10');
   run;

Data ad.ip_T1DM_2019;
  set ip19.inpatient_base_claims_2019;
    where admtg_dgns_cd in: ('E10') or prncpal_dgns_cd in: ('E10') or icd_dgns_cd1 in: ('E10') or icd_dgns_cd2 in: ('E10') or icd_dgns_cd3 in: ('E10') or icd_dgns_cd4 in: ('E10') or
              icd_dgns_cd5 in: ('E10') or icd_dgns_cd6 in: ('E10') or icd_dgns_cd7 in: ('E10') or icd_dgns_cd8 in: ('E10') or icd_dgns_cd9 in: ('E10') or icd_dgns_cd10 in: ('E10') or
              icd_dgns_cd11 in: ('E10') or icd_dgns_cd12 in: ('E10') or icd_dgns_cd13 in: ('E10') or icd_dgns_cd14 in: ('E10') or icd_dgns_cd15 in: ('E10') or icd_dgns_cd16 in: ('E10') or
              icd_dgns_cd17 in: ('E10') or icd_dgns_cd18 in: ('E10') or icd_dgns_cd19 in: ('E10') or icd_dgns_cd20 in: ('E10') or icd_dgns_cd21 in: ('E10') or icd_dgns_cd22 in: ('E10') or
              icd_dgns_cd23 in: ('E10') or icd_dgns_cd24 in: ('E10') or icd_dgns_cd25 in: ('E10');
   run;

Data ad.ip_T1DM_2020;
  set ip20.inpatient_base_claims_2020;
    where admtg_dgns_cd in: ('E10') or prncpal_dgns_cd in: ('E10') or icd_dgns_cd1 in: ('E10') or icd_dgns_cd2 in: ('E10') or icd_dgns_cd3 in: ('E10') or icd_dgns_cd4 in: ('E10') or
              icd_dgns_cd5 in: ('E10') or icd_dgns_cd6 in: ('E10') or icd_dgns_cd7 in: ('E10') or icd_dgns_cd8 in: ('E10') or icd_dgns_cd9 in: ('E10') or icd_dgns_cd10 in: ('E10') or
              icd_dgns_cd11 in: ('E10') or icd_dgns_cd12 in: ('E10') or icd_dgns_cd13 in: ('E10') or icd_dgns_cd14 in: ('E10') or icd_dgns_cd15 in: ('E10') or icd_dgns_cd16 in: ('E10') or
              icd_dgns_cd17 in: ('E10') or icd_dgns_cd18 in: ('E10') or icd_dgns_cd19 in: ('E10') or icd_dgns_cd20 in: ('E10') or icd_dgns_cd21 in: ('E10') or icd_dgns_cd22 in: ('E10') or
              icd_dgns_cd23 in: ('E10') or icd_dgns_cd24 in: ('E10') or icd_dgns_cd25 in: ('E10');
   run;


 /* Extract bene_id for patients with Type 1 diabetes from outpatient claims 2016-2020 */
 Data ad.op_T1DM_2016;
   set op16.outpatient_base_claims_k_2016;
    where prncpal_dgns_cd in: ('E10') or icd_dgns_cd1 in: ('E10') or icd_dgns_cd2 in: ('E10') or icd_dgns_cd3 in: ('E10') or icd_dgns_cd4 in: ('E10') or
             icd_dgns_cd5 in: ('E10') or icd_dgns_cd6 in: ('E10') or icd_dgns_cd7 in: ('E10') or icd_dgns_cd8 in: ('E10') or icd_dgns_cd9 in: ('E10') or icd_dgns_cd10 in: ('E10') or
             icd_dgns_cd11 in: ('E10') or icd_dgns_cd12 in: ('E10') or icd_dgns_cd13 in: ('E10') or icd_dgns_cd14 in: ('E10') or icd_dgns_cd15 in: ('E10') or icd_dgns_cd16 in: ('E10') or
             icd_dgns_cd17 in: ('E10') or icd_dgns_cd18 in: ('E10') or icd_dgns_cd19 in: ('E10') or icd_dgns_cd20 in: ('E10') or icd_dgns_cd21 in: ('E10') or icd_dgns_cd22 in: ('E10') or
             icd_dgns_cd23 in: ('E10') or icd_dgns_cd24 in: ('E10') or icd_dgns_cd25 in: ('E10');
  run;

 Data ad.op_T1DM_2017;
   set op17.outpatient_base_claims_k_2017;
    where prncpal_dgns_cd in: ('E10') or icd_dgns_cd1 in: ('E10') or icd_dgns_cd2 in: ('E10') or icd_dgns_cd3 in: ('E10') or icd_dgns_cd4 in: ('E10') or
             icd_dgns_cd5 in: ('E10') or icd_dgns_cd6 in: ('E10') or icd_dgns_cd7 in: ('E10') or icd_dgns_cd8 in: ('E10') or icd_dgns_cd9 in: ('E10') or icd_dgns_cd10 in: ('E10') or
             icd_dgns_cd11 in: ('E10') or icd_dgns_cd12 in: ('E10') or icd_dgns_cd13 in: ('E10') or icd_dgns_cd14 in: ('E10') or icd_dgns_cd15 in: ('E10') or icd_dgns_cd16 in: ('E10') or
             icd_dgns_cd17 in: ('E10') or icd_dgns_cd18 in: ('E10') or icd_dgns_cd19 in: ('E10') or icd_dgns_cd20 in: ('E10') or icd_dgns_cd21 in: ('E10') or icd_dgns_cd22 in: ('E10') or
             icd_dgns_cd23 in: ('E10') or icd_dgns_cd24 in: ('E10') or icd_dgns_cd25 in: ('E10');
  run;

 Data ad.op_T1DM_2018;
   set op18.outpatient_base_claims_k_2018;
    where prncpal_dgns_cd in: ('E10') or icd_dgns_cd1 in: ('E10') or icd_dgns_cd2 in: ('E10') or icd_dgns_cd3 in: ('E10') or icd_dgns_cd4 in: ('E10') or
             icd_dgns_cd5 in: ('E10') or icd_dgns_cd6 in: ('E10') or icd_dgns_cd7 in: ('E10') or icd_dgns_cd8 in: ('E10') or icd_dgns_cd9 in: ('E10') or icd_dgns_cd10 in: ('E10') or
             icd_dgns_cd11 in: ('E10') or icd_dgns_cd12 in: ('E10') or icd_dgns_cd13 in: ('E10') or icd_dgns_cd14 in: ('E10') or icd_dgns_cd15 in: ('E10') or icd_dgns_cd16 in: ('E10') or
             icd_dgns_cd17 in: ('E10') or icd_dgns_cd18 in: ('E10') or icd_dgns_cd19 in: ('E10') or icd_dgns_cd20 in: ('E10') or icd_dgns_cd21 in: ('E10') or icd_dgns_cd22 in: ('E10') or
             icd_dgns_cd23 in: ('E10') or icd_dgns_cd24 in: ('E10') or icd_dgns_cd25 in: ('E10');
  run;

 Data ad.op_T1DM_2019;
   set op19.outpatient_base_claims_2019;
    where prncpal_dgns_cd in: ('E10') or icd_dgns_cd1 in: ('E10') or icd_dgns_cd2 in: ('E10') or icd_dgns_cd3 in: ('E10') or icd_dgns_cd4 in: ('E10') or
             icd_dgns_cd5 in: ('E10') or icd_dgns_cd6 in: ('E10') or icd_dgns_cd7 in: ('E10') or icd_dgns_cd8 in: ('E10') or icd_dgns_cd9 in: ('E10') or icd_dgns_cd10 in: ('E10') or
             icd_dgns_cd11 in: ('E10') or icd_dgns_cd12 in: ('E10') or icd_dgns_cd13 in: ('E10') or icd_dgns_cd14 in: ('E10') or icd_dgns_cd15 in: ('E10') or icd_dgns_cd16 in: ('E10') or
             icd_dgns_cd17 in: ('E10') or icd_dgns_cd18 in: ('E10') or icd_dgns_cd19 in: ('E10') or icd_dgns_cd20 in: ('E10') or icd_dgns_cd21 in: ('E10') or icd_dgns_cd22 in: ('E10') or
             icd_dgns_cd23 in: ('E10') or icd_dgns_cd24 in: ('E10') or icd_dgns_cd25 in: ('E10');
  run;

 Data ad.op_T1DM_2020;
   set op20.outpatient_base_claims_2020;
    where prncpal_dgns_cd in: ('E10') or icd_dgns_cd1 in: ('E10') or icd_dgns_cd2 in: ('E10') or icd_dgns_cd3 in: ('E10') or icd_dgns_cd4 in: ('E10') or
             icd_dgns_cd5 in: ('E10') or icd_dgns_cd6 in: ('E10') or icd_dgns_cd7 in: ('E10') or icd_dgns_cd8 in: ('E10') or icd_dgns_cd9 in: ('E10') or icd_dgns_cd10 in: ('E10') or
             icd_dgns_cd11 in: ('E10') or icd_dgns_cd12 in: ('E10') or icd_dgns_cd13 in: ('E10') or icd_dgns_cd14 in: ('E10') or icd_dgns_cd15 in: ('E10') or icd_dgns_cd16 in: ('E10') or
             icd_dgns_cd17 in: ('E10') or icd_dgns_cd18 in: ('E10') or icd_dgns_cd19 in: ('E10') or icd_dgns_cd20 in: ('E10') or icd_dgns_cd21 in: ('E10') or icd_dgns_cd22 in: ('E10') or
             icd_dgns_cd23 in: ('E10') or icd_dgns_cd24 in: ('E10') or icd_dgns_cd25 in: ('E10');
  run;

 
/* combine 2016-2020*/
data ad.T1DM;
   set ad.ip_T1DM_2016 ad.ip_T1DM_2017 ad.ip_T1DM_2018 ad.ip_T1DM_2019 ad.ip_T1DM_2020
       ad.op_T1DM_2017 ad.op_T1DM_2018 ad.op_T1DM_2019 ad.op_T1DM_2020 ad.op_T1DM_2016;
 run;
 proc sort data = ad.T1DM;
   by bene_id;
 run;

/*delete all rows with T1DM dx 12 months prior to index_date */

 proc sql;
    create table merged as
    select a.*, b.clm_from_dt
    from ad.continuous_enrollment a
    left join ad.T1DM b
    on a.bene_id = b.bene_id;
 quit;

 /* Identify individuals to exclude */
 proc sql;
    create table to_exclude as
    select distinct bene_id
    from merged
    where clm_from_dt between index_date - 365 and index_date;
 quit;

/* Exclude the identified individuals from continuous_enrolllment */
proc sql;
   create table ad.exclude_T1DM as                                           /* 785447 */
   select *
   from ad.continuous_enrollment
   where bene_id not in (select bene_id from to_exclude);
quit; 


