data T2DM_16_19;
   set ad.ip_T2DM_2016 ad.ip_T2DM_2017 ad.ip_T2DM_2018 ad.ip_T2DM_2019
       ad.op_T2DM_2016 ad.op_T2DM_2017 ad.op_T2DM_2018 ad.op_T2DM_2019;KEEP bene_id clm_from_dt;
 run;
 proc sort data = T2DM_16_19;
   by bene_id;
 run;

  proc sql;
     create table merged as
     select a.*, b.clm_from_dt
     from ad.exclude_T1DM a
     left join T2DM_16_19 b
     on a.bene_id = b.bene_id;
  quit;

 /* Identify individuals to exclude */
  proc sql;
     create table to_exclude as
     select distinct bene_id
     from merged
     where clm_from_dt between index_date - 365 and index_date -1;
  quit;

  /* Exclude the identified individuals from continuous_enrolllment */
  proc sql;
     create table ad.new_T2DM as                                           /* 388359 */
     select *
     from ad.exclude_T1DM
     where bene_id not in (select bene_id from to_exclude);
 quit;
