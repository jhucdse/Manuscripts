/*getting index date for patients*/
proc sql;
   create table min_date as
   select bene_id, min(CLM_FROM_DT) as index_date
   from ad.all_t2dm
   group by bene_id;
 quit;

data ad.all_t2dm;
   merge ad.all_t2dm(in=a) min_date(in=b);
   by bene_id;
   if a;
 run;

proc sort data=ad.all_t2dm;
  by bene_id CLM_FROM_DT;
run;

 /* only keep those index_date from Jan 1 2017 to Dec 31 2019*/
data ad.all_t2dm_17_19;
    set ad.all_t2dm;
    if index_date >= '01JAN2017'd and index_date <= '31DEC2019'd;
run;

/*getting date of birth for patients */
proc sort data=ad.mbsf out=ad.mbsfv2 nodupkey;
    by bene_id;
run;

data ad.all_t2dm_17_19;                                                        /* 1772168 */
  merge ad.all_t2dm_17_19(in=a) ad.mbsfv2(in=b keep=bene_id bene_birth_dt);
  by bene_id;
  birth_date = bene_birth_dt;
  if a and b;
run;

/*only keep those with age >= 66 at the time of index date*/
data ad.exclude65;                                                              /* 1300917 */
  set ad.all_t2dm_17_19;
   age = int((index_date - birth_date)/365.25);
      if age >= 66;
run;
