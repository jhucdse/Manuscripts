 /*identify those dx with AD 1 year before index date */

proc sql;
    create table merged as
    select a.*, b.clm_from_dt
    from ad.new_T2DM a
    left join ad.all_ad b
    on a.bene_id = b.bene_id;
 quit;

/* Identify individuals with AD */
proc sql;
   create table ad.with_AD as                           /* 9584 with AD */
   select distinct bene_id
   from merged
   where clm_from_dt between index_date - 365 and index_date;
quit;


 data ad.all_claims_with_AD;
   merge ad.all_antidiabetic_claims(in=a)
         ad.with_AD(in=b);
   by bene_id;
   if a and b;
 run;
proc sort data=ad.all_claims_with_AD(keep=bene_id) nodupkey out=unique_ids;
   by bene_id;
 run;

 proc sort data=ad.all_claims_with_ad;
   by bene_id;
 run;

  data ad.all_claims_with_ad; /* Overwriting the dataset */
    merge ad.all_claims_with_ad (in=a) ad.new_T2DM (in=b);
    by bene_id;
    if a and b;
  run;

data ad.all_claims_with_ad;
   set ad.all_claims_with_ad;
   if SRVC_DT >= index_date and SRVC_DT <= index_date+365;
run;
proc sort data=ad.all_claims_with_ad(keep=bene_id) nodupkey out=unique_ids;             /* 3999 get drug within 1 year after index date*/
  by bene_id;
run;


/* Identify individuals without AD */
proc sql;
  create table ad.without_AD as                          /* 378775 witout AD*/
  select a.bene_id
  from ad.new_T2DM as a
  left join ad.with_AD as b
  on a.bene_id = b.bene_id
  where b.bene_id is null;     /* Keep only IDs that do not exist in with_AD */
quit;

/*getting all claims for treated patients without AD*/
 data ad.all_claims_without_AD;
   merge ad.all_antidiabetic_claims(in=a)
         ad.without_AD(in=b);
   by bene_id;
   if a and b;
 run;
  proc sort data=ad.all_claims_without_AD(keep=bene_id) nodupkey out=unique_ids;
    by bene_id;
  run;

  proc sort data=ad.all_claims_without_ad;
    by bene_id;
  run;

 data ad.all_claims_without_ad;
    merge ad.all_claims_without_ad(in=a) ad.new_T2DM(in=b);
    by bene_id;
    if a and b;
  run;

 /* only keep claims 1 year after index date*/
 data ad.all_claims_without_ad;
   set ad.all_claims_without_ad;
   if SRVC_DT >= index_date and SRVC_DT <= index_date+365;
run;
proc sort data=ad.all_claims_without_ad(keep=bene_id) nodupkey out=unique_ids;        /*244115 get drug within 1 year after index date*/
  by bene_id;
run;
