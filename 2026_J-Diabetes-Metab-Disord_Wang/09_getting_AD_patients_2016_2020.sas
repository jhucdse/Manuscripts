/*extract AD claims from inpatient files 2016-2020 */
data ad.ip_ad_2016;
   set ip16.inpatient_base_claims_k_2016;
   where admtg_dgns_cd in: ('G30', 'G301', 'G308', 'G309') or prncpal_dgns_cd in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd1 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd2 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd3 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd4 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd5 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd6 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd7 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd8 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd9 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd10 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd11 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd12 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd13 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd14 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd15 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd16 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd17 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd18 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd19 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd20 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd21 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd22 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd23 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd24 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd25 in: ('G30', 'G301', 'G308', 'G309');
 run;

 data ad.ip_ad_2017;
   set ip17.inpatient_base_claims_k_2017;
   where admtg_dgns_cd in: ('G30', 'G301', 'G308', 'G309') or prncpal_dgns_cd in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd1 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd2 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd3 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd4 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd5 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd6 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd7 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd8 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd9 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd10 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd11 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd12 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd13 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd14 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd15 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd16 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd17 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd18 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd19 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd20 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd21 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd22 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd23 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd24 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd25 in: ('G30', 'G301', 'G308', 'G309');
 run;

 data ad.ip_ad_2018;
   set ip18.inpatient_base_claims_k_2018;
   where admtg_dgns_cd in: ('G30', 'G301', 'G308', 'G309') or prncpal_dgns_cd in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd1 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd2 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd3 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd4 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd5 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd6 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd7 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd8 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd9 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd10 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd11 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd12 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd13 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd14 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd15 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd16 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd17 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd18 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd19 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd20 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd21 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd22 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd23 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd24 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd25 in: ('G30', 'G301', 'G308', 'G309');
 run;

data ad.ip_ad_2019;
   set ip19.inpatient_base_claims_2019;
   where admtg_dgns_cd in: ('G30', 'G301', 'G308', 'G309') or prncpal_dgns_cd in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd1 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd2 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd3 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd4 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd5 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd6 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd7 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd8 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd9 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd10 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd11 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd12 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd13 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd14 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd15 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd16 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd17 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd18 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd19 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd20 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd21 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd22 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd23 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd24 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd25 in: ('G30', 'G301', 'G308', 'G309');
 run;

  data ad.ip_ad_2020;
   set ip20.inpatient_base_claims_2020;
   where admtg_dgns_cd in: ('G30', 'G301', 'G308', 'G309') or prncpal_dgns_cd in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd1 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd2 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd3 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd4 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd5 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd6 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd7 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd8 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd9 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd10 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd11 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd12 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd13 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd14 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd15 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd16 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd17 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd18 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd19 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd20 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd21 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd22 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd23 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd24 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd25 in: ('G30', 'G301', 'G308', 'G309');
 run;


/* extract AD claims from outpatient files */
data ad.op_ad_2016;
   set op16.outpatient_base_claims_k_2016;
   where prncpal_dgns_cd in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd1 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd2 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd3 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd4 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd5 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd6 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd7 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd8 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd9 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd10 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd11 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd12 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd13 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd14 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd15 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd16 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd17 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd18 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd19 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd20 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd21 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd22 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd23 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd24 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd25 in: ('G30', 'G301', 'G308', 'G309');
 run;

data ad.op_ad_2017;
   set op17.outpatient_base_claims_k_2017;
   where prncpal_dgns_cd in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd1 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd2 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd3 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd4 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd5 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd6 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd7 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd8 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd9 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd10 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd11 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd12 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd13 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd14 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd15 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd16 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd17 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd18 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd19 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd20 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd21 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd22 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd23 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd24 in: ('G30', 'G301', 'G308', 'G309') or
         icd_dgns_cd25 in: ('G30', 'G301', 'G308', 'G309');
 run;


 data ad.op_ad_2018;
    set op18.outpatient_base_claims_k_2018;
    where prncpal_dgns_cd in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd1 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd2 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd3 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd4 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd5 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd6 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd7 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd8 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd9 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd10 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd11 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd12 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd13 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd14 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd15 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd16 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd17 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd18 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd19 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd20 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd21 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd22 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd23 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd24 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd25 in: ('G30', 'G301', 'G308', 'G309');
  run;


data ad.op_ad_2019;
    set op19.outpatient_base_claims_2019;
    where prncpal_dgns_cd in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd1 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd2 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd3 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd4 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd5 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd6 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd7 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd8 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd9 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd10 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd11 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd12 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd13 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd14 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd15 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd16 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd17 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd18 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd19 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd20 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd21 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd22 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd23 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd24 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd25 in: ('G30', 'G301', 'G308', 'G309');
  run;

 data ad.op_ad_2020;
    set op20.outpatient_base_claims_2020;
    where prncpal_dgns_cd in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd1 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd2 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd3 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd4 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd5 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd6 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd7 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd8 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd9 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd10 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd11 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd12 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd13 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd14 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd15 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd16 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd17 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd18 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd19 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd20 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd21 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd22 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd23 in: ('G30', 'G301', 'G308', 'G309') or icd_dgns_cd24 in: ('G30', 'G301', 'G308', 'G309') or
          icd_dgns_cd25 in: ('G30', 'G301', 'G308', 'G309');
  run;

 /* combine all AD 2016-2020*/
data ad.all_ad;
   set ad.op_ad_2017 ad.op_ad_2018 ad.op_ad_2019 ad.op_ad_2020 ad.op_ad_2016
       ad.ip_ad_2016 ad.ip_ad_2017 ad.ip_ad_2018 ad.ip_ad_2019 ad.ip_ad_2020;
run;
proc sort data = ad.all_ad;
    by bene_id;
run;


 /* check how many people in the cohort*/ 
 proc sort data=ad.all_ad(keep=bene_id) nodupkey out=unique_ids;                 /* 306942 id*/
   by bene_id;
 run;
