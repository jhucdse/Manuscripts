/*getting all inpaient T2DM patients 2016-2020*/

Data Ad.ip_T2DM_2016;
  set ip16.inpatient_base_claims_k_2016;
    where admtg_dgns_cd in: ('E11') or prncpal_dgns_cd in: ('E11') or icd_dgns_cd1 in: ('E11') or icd_dgns_cd2 in: ('E11') or icd_dgns_cd3 in: ('E11') or icd_dgns_cd4 in: ('E11') or
              icd_dgns_cd5 in: ('E11') or icd_dgns_cd6 in: ('E11') or icd_dgns_cd7 in: ('E11') or icd_dgns_cd8 in: ('E11') or icd_dgns_cd9 in: ('E11') or icd_dgns_cd10 in: ('E11') or
              icd_dgns_cd11 in: ('E11') or icd_dgns_cd12 in: ('E11') or icd_dgns_cd13 in: ('E11') or icd_dgns_cd14 in: ('E11') or icd_dgns_cd15 in: ('E11') or icd_dgns_cd16 in: ('E11') or
              icd_dgns_cd17 in: ('E11') or icd_dgns_cd18 in: ('E11') or icd_dgns_cd19 in: ('E11') or icd_dgns_cd20 in: ('E11') or icd_dgns_cd21 in: ('E11') or icd_dgns_cd22 in: ('E11') or
              icd_dgns_cd23 in: ('E11') or icd_dgns_cd24 in: ('E11') or icd_dgns_cd25 in: ('E11');
run;

Data Ad.ip_T2DM_2017;
  set ip17.inpatient_base_claims_k_2017;
    where admtg_dgns_cd in: ('E11') or prncpal_dgns_cd in: ('E11') or icd_dgns_cd1 in: ('E11') or icd_dgns_cd2 in: ('E11') or icd_dgns_cd3 in: ('E11') or icd_dgns_cd4 in: ('E11') or
              icd_dgns_cd5 in: ('E11') or icd_dgns_cd6 in: ('E11') or icd_dgns_cd7 in: ('E11') or icd_dgns_cd8 in: ('E11') or icd_dgns_cd9 in: ('E11') or icd_dgns_cd10 in: ('E11') or
              icd_dgns_cd11 in: ('E11') or icd_dgns_cd12 in: ('E11') or icd_dgns_cd13 in: ('E11') or icd_dgns_cd14 in: ('E11') or icd_dgns_cd15 in: ('E11') or icd_dgns_cd16 in: ('E11') or
              icd_dgns_cd17 in: ('E11') or icd_dgns_cd18 in: ('E11') or icd_dgns_cd19 in: ('E11') or icd_dgns_cd20 in: ('E11') or icd_dgns_cd21 in: ('E11') or icd_dgns_cd22 in: ('E11') or
              icd_dgns_cd23 in: ('E11') or icd_dgns_cd24 in: ('E11') or icd_dgns_cd25 in: ('E11');
run;

Data Ad.ip_T2DM_2018;
  set ip18.inpatient_base_claims_k_2018;
    where admtg_dgns_cd in: ('E11') or prncpal_dgns_cd in: ('E11') or icd_dgns_cd1 in: ('E11') or icd_dgns_cd2 in: ('E11') or icd_dgns_cd3 in: ('E11') or icd_dgns_cd4 in: ('E11') or
              icd_dgns_cd5 in: ('E11') or icd_dgns_cd6 in: ('E11') or icd_dgns_cd7 in: ('E11') or icd_dgns_cd8 in: ('E11') or icd_dgns_cd9 in: ('E11') or icd_dgns_cd10 in: ('E11') or
              icd_dgns_cd11 in: ('E11') or icd_dgns_cd12 in: ('E11') or icd_dgns_cd13 in: ('E11') or icd_dgns_cd14 in: ('E11') or icd_dgns_cd15 in: ('E11') or icd_dgns_cd16 in: ('E11') or
              icd_dgns_cd17 in: ('E11') or icd_dgns_cd18 in: ('E11') or icd_dgns_cd19 in: ('E11') or icd_dgns_cd20 in: ('E11') or icd_dgns_cd21 in: ('E11') or icd_dgns_cd22 in: ('E11') or
              icd_dgns_cd23 in: ('E11') or icd_dgns_cd24 in: ('E11') or icd_dgns_cd25 in: ('E11');
run;

Data Ad.ip_T2DM_2019;
  set ip19.inpatient_base_claims_2019;
    where admtg_dgns_cd in: ('E11') or prncpal_dgns_cd in: ('E11') or icd_dgns_cd1 in: ('E11') or icd_dgns_cd2 in: ('E11') or icd_dgns_cd3 in: ('E11') or icd_dgns_cd4 in: ('E11') or
              icd_dgns_cd5 in: ('E11') or icd_dgns_cd6 in: ('E11') or icd_dgns_cd7 in: ('E11') or icd_dgns_cd8 in: ('E11') or icd_dgns_cd9 in: ('E11') or icd_dgns_cd10 in: ('E11') or
              icd_dgns_cd11 in: ('E11') or icd_dgns_cd12 in: ('E11') or icd_dgns_cd13 in: ('E11') or icd_dgns_cd14 in: ('E11') or icd_dgns_cd15 in: ('E11') or icd_dgns_cd16 in: ('E11') or
              icd_dgns_cd17 in: ('E11') or icd_dgns_cd18 in: ('E11') or icd_dgns_cd19 in: ('E11') or icd_dgns_cd20 in: ('E11') or icd_dgns_cd21 in: ('E11') or icd_dgns_cd22 in: ('E11') or
              icd_dgns_cd23 in: ('E11') or icd_dgns_cd24 in: ('E11') or icd_dgns_cd25 in: ('E11');
run;

Data Ad.ip_T2DM_2020;
  set ip20.inpatient_base_claims_2020;
    where admtg_dgns_cd in: ('E11') or prncpal_dgns_cd in: ('E11') or icd_dgns_cd1 in: ('E11') or icd_dgns_cd2 in: ('E11') or icd_dgns_cd3 in: ('E11') or icd_dgns_cd4 in: ('E11') or
              icd_dgns_cd5 in: ('E11') or icd_dgns_cd6 in: ('E11') or icd_dgns_cd7 in: ('E11') or icd_dgns_cd8 in: ('E11') or icd_dgns_cd9 in: ('E11') or icd_dgns_cd10 in: ('E11') or
              icd_dgns_cd11 in: ('E11') or icd_dgns_cd12 in: ('E11') or icd_dgns_cd13 in: ('E11') or icd_dgns_cd14 in: ('E11') or icd_dgns_cd15 in: ('E11') or icd_dgns_cd16 in: ('E11') or
              icd_dgns_cd17 in: ('E11') or icd_dgns_cd18 in: ('E11') or icd_dgns_cd19 in: ('E11') or icd_dgns_cd20 in: ('E11') or icd_dgns_cd21 in: ('E11') or icd_dgns_cd22 in: ('E11') or
              icd_dgns_cd23 in: ('E11') or icd_dgns_cd24 in: ('E11') or icd_dgns_cd25 in: ('E11');
run;

/*only need 1 inpatient dx, so combine 2017-2020*/
data ad.ip_T2DM;
  set ad.ip_T2DM_2017 ad.ip_T2DM_2018 ad.ip_T2DM_2019 ad.ip_T2DM_2020;
run;
proc sort data = ad.ip_T2DM nodupkey;
  by bene_id;
run;


/* Extract bene_id for patients with Type 2 diabetes from outpatient claims */
Data ad.op_T2DM_2016;
  set op16.outpatient_base_claims_k_2016;
      where prncpal_dgns_cd in: ('E11') or icd_dgns_cd1 in: ('E11') or icd_dgns_cd2 in: ('E11') or icd_dgns_cd3 in: ('E11') or icd_dgns_cd4 in: ('E11') or
               icd_dgns_cd5 in: ('E11') or icd_dgns_cd6 in: ('E11') or icd_dgns_cd7 in: ('E11') or icd_dgns_cd8 in: ('E11') or icd_dgns_cd9 in: ('E11') or icd_dgns_cd10 in: ('E11') or
               icd_dgns_cd11 in: ('E11') or icd_dgns_cd12 in: ('E11') or icd_dgns_cd13 in: ('E11') or icd_dgns_cd14 in: ('E11') or icd_dgns_cd15 in: ('E11') or icd_dgns_cd16 in: ('E11') or
               icd_dgns_cd17 in: ('E11') or icd_dgns_cd18 in: ('E11') or icd_dgns_cd19 in: ('E11') or icd_dgns_cd20 in: ('E11') or icd_dgns_cd21 in: ('E11') or icd_dgns_cd22 in: ('E11') or
               icd_dgns_cd23 in: ('E11') or icd_dgns_cd24 in: ('E11') or icd_dgns_cd25 in: ('E11');
run;

Data ad.op_T2DM_2017;
  set op17.outpatient_base_claims_k_2017;
      where prncpal_dgns_cd in: ('E11') or icd_dgns_cd1 in: ('E11') or icd_dgns_cd2 in: ('E11') or icd_dgns_cd3 in: ('E11') or icd_dgns_cd4 in: ('E11') or
               icd_dgns_cd5 in: ('E11') or icd_dgns_cd6 in: ('E11') or icd_dgns_cd7 in: ('E11') or icd_dgns_cd8 in: ('E11') or icd_dgns_cd9 in: ('E11') or icd_dgns_cd10 in: ('E11') or
               icd_dgns_cd11 in: ('E11') or icd_dgns_cd12 in: ('E11') or icd_dgns_cd13 in: ('E11') or icd_dgns_cd14 in: ('E11') or icd_dgns_cd15 in: ('E11') or icd_dgns_cd16 in: ('E11') or
               icd_dgns_cd17 in: ('E11') or icd_dgns_cd18 in: ('E11') or icd_dgns_cd19 in: ('E11') or icd_dgns_cd20 in: ('E11') or icd_dgns_cd21 in: ('E11') or icd_dgns_cd22 in: ('E11') or
               icd_dgns_cd23 in: ('E11') or icd_dgns_cd24 in: ('E11') or icd_dgns_cd25 in: ('E11');
run;

Data ad.op_T2DM_2018;
  set op18.outpatient_base_claims_k_2018;
      where prncpal_dgns_cd in: ('E11') or icd_dgns_cd1 in: ('E11') or icd_dgns_cd2 in: ('E11') or icd_dgns_cd3 in: ('E11') or icd_dgns_cd4 in: ('E11') or
               icd_dgns_cd5 in: ('E11') or icd_dgns_cd6 in: ('E11') or icd_dgns_cd7 in: ('E11') or icd_dgns_cd8 in: ('E11') or icd_dgns_cd9 in: ('E11') or icd_dgns_cd10 in: ('E11') or
               icd_dgns_cd11 in: ('E11') or icd_dgns_cd12 in: ('E11') or icd_dgns_cd13 in: ('E11') or icd_dgns_cd14 in: ('E11') or icd_dgns_cd15 in: ('E11') or icd_dgns_cd16 in: ('E11') or
               icd_dgns_cd17 in: ('E11') or icd_dgns_cd18 in: ('E11') or icd_dgns_cd19 in: ('E11') or icd_dgns_cd20 in: ('E11') or icd_dgns_cd21 in: ('E11') or icd_dgns_cd22 in: ('E11') or
               icd_dgns_cd23 in: ('E11') or icd_dgns_cd24 in: ('E11') or icd_dgns_cd25 in: ('E11');
run;

Data ad.op_T2DM_2019;
  set op19.outpatient_base_claims_2019;
      where prncpal_dgns_cd in: ('E11') or icd_dgns_cd1 in: ('E11') or icd_dgns_cd2 in: ('E11') or icd_dgns_cd3 in: ('E11') or icd_dgns_cd4 in: ('E11') or
               icd_dgns_cd5 in: ('E11') or icd_dgns_cd6 in: ('E11') or icd_dgns_cd7 in: ('E11') or icd_dgns_cd8 in: ('E11') or icd_dgns_cd9 in: ('E11') or icd_dgns_cd10 in: ('E11') or
               icd_dgns_cd11 in: ('E11') or icd_dgns_cd12 in: ('E11') or icd_dgns_cd13 in: ('E11') or icd_dgns_cd14 in: ('E11') or icd_dgns_cd15 in: ('E11') or icd_dgns_cd16 in: ('E11') or
               icd_dgns_cd17 in: ('E11') or icd_dgns_cd18 in: ('E11') or icd_dgns_cd19 in: ('E11') or icd_dgns_cd20 in: ('E11') or icd_dgns_cd21 in: ('E11') or icd_dgns_cd22 in: ('E11') or
               icd_dgns_cd23 in: ('E11') or icd_dgns_cd24 in: ('E11') or icd_dgns_cd25 in: ('E11');
run;

Data ad.op_T2DM_2020;
  set op20.outpatient_base_claims_2020;
      where prncpal_dgns_cd in: ('E11') or icd_dgns_cd1 in: ('E11') or icd_dgns_cd2 in: ('E11') or icd_dgns_cd3 in: ('E11') or icd_dgns_cd4 in: ('E11') or
               icd_dgns_cd5 in: ('E11') or icd_dgns_cd6 in: ('E11') or icd_dgns_cd7 in: ('E11') or icd_dgns_cd8 in: ('E11') or icd_dgns_cd9 in: ('E11') or icd_dgns_cd10 in: ('E11') or
               icd_dgns_cd11 in: ('E11') or icd_dgns_cd12 in: ('E11') or icd_dgns_cd13 in: ('E11') or icd_dgns_cd14 in: ('E11') or icd_dgns_cd15 in: ('E11') or icd_dgns_cd16 in: ('E11') or
               icd_dgns_cd17 in: ('E11') or icd_dgns_cd18 in: ('E11') or icd_dgns_cd19 in: ('E11') or icd_dgns_cd20 in: ('E11') or icd_dgns_cd21 in: ('E11') or icd_dgns_cd22 in: ('E11') or
               icd_dgns_cd23 in: ('E11') or icd_dgns_cd24 in: ('E11') or icd_dgns_cd25 in: ('E11');
 un;

/* combine op 2017-2020*/
data ad.op_T2DM;
  set ad.op_T2DM_2017 ad.op_T2DM_2018 ad.op_T2DM_2019 ad.op_T2DM_2020;
run;
proc sort data = ad.op_T2DM;
  by bene_id;
run;

/*need more then 2 dx in op data, so deleting those who only have 1 dx in op data*/
proc sql;
  create table op_t2dm_count as
  select*, count(*) as dx_count
  from ad.op_t2dm
  group by bene_id;
quit;
data ad.op_t2dm;
  set op_t2dm_count;
  if dx_count > 1;
run;

/* combine ip and op T2DM patients */
data ad.all_T2DM;                      
  set ad.ip_t2dm ad.op_t2dm;
run;
proc sort data = ad.all_T2DM;                                               /*1949045 id */
  by bene_id;
run;
