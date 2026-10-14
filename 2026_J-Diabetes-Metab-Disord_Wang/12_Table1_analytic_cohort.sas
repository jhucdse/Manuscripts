/* add all antidiabetic drug indicator */
data ad.all_claims_with_ad;
  set ad.all_claims_with_ad;
  insulin = 0;
  metformin = 0;
  dpp4 = 0;
  glp1 = 0;
  sglt2 = 0;
  sulf = 0;
  tzd = 0;
  alpha = 0;
  if upcase(bn) in: ('INSULIN') or upcase(gnn) in: ('INSULIN') then insulin = 1;
  if upcase(bn) in: ('METFORMIN') or upcase(gnn) in: ('METFORMIN') then metformin = 1;
  if upcase(bn) in: ('ALOGLIPTIN', 'LINAGLIPTIN', 'SAXAGLIPTIN', 'SITAGLIPTIN') or
     upcase(gnn) in: ('ALOGLIPTIN', 'LINAGLIPTIN', 'SAXAGLIPTIN', 'SITAGLIPTIN') then dpp4 = 1;
  if upcase(bn) in: ('DULAGLUTIDE', 'EXENATIDE', 'LIRAGLUTIDE', 'LIXISENATIDE', 'SEMAGLUTIDE', 'TIRZEPATIDE') or
     upcase(gnn) in: ('DULAGLUTIDE', 'EXENATIDE', 'LIRAGLUTIDE', 'LIXISENATIDE', 'SEMAGLUTIDE', 'TIRZEPATIDE') then glp1 = 1;
  if upcase(bn) in: ('BEXAGLIFLOZIN', 'CANAGLIFLOZIN', 'DAPAGLIFLOZIN', 'EMPAGLIFLOZIN') or
     upcase(gnn) in: ('BEXAGLIFLOZIN', 'CANAGLIFLOZIN', 'DAPAGLIFLOZIN', 'EMPAGLIFLOZIN') then sglt2 = 1;
  if upcase(bn) in: ('GLIMEPIRIDE', 'GLIPIZIDE', 'GLYBURIDE') or
     upcase(gnn) in: ('GLIMEPIRIDE', 'GLIPIZIDE', 'GLYBURIDE') then sulf = 1;
  if upcase(bn) in: ('ROSIGLITAZONE', 'PIOGLITAZONE') or
     upcase(gnn) in: ('ROSIGLITAZONE', 'PIOGLITAZONE') then tzd = 1;
  if upcase(bn) in: ('ACARBOSE', 'MIGLITOL') or
     upcase(gnn) in: ('ACARBOSE', 'MIGLITOL') then alpha = 1;
run;


 proc sort data = ad.all_claims_with_ad;
  by bene_id SRVC_DT;
 run;

data ad.all_claims_without_ad;
  set ad.all_claims_without_ad;
  insulin = 0;
  metformin = 0;
  dpp4 = 0;
  glp1 = 0;
  sglt2 = 0;
  sulf = 0;
  tzd = 0;
  alpha = 0;
  if upcase(bn) in: ('INSULIN') or upcase(gnn) in: ('INSULIN') then insulin = 1;
  if upcase(bn) in: ('METFORMIN') or upcase(gnn) in: ('METFORMIN') then metformin = 1;
  if upcase(bn) in: ('ALOGLIPTIN', 'LINAGLIPTIN', 'SAXAGLIPTIN', 'SITAGLIPTIN') or
     upcase(gnn) in: ('ALOGLIPTIN', 'LINAGLIPTIN', 'SAXAGLIPTIN', 'SITAGLIPTIN') then dpp4 = 1;
  if upcase(bn) in: ('DULAGLUTIDE', 'EXENATIDE', 'LIRAGLUTIDE', 'LIXISENATIDE', 'SEMAGLUTIDE', 'TIRZEPATIDE') or
     upcase(gnn) in: ('DULAGLUTIDE', 'EXENATIDE', 'LIRAGLUTIDE', 'LIXISENATIDE', 'SEMAGLUTIDE', 'TIRZEPATIDE') then glp1 = 1;
  if upcase(bn) in: ('BEXAGLIFLOZIN', 'CANAGLIFLOZIN', 'DAPAGLIFLOZIN', 'EMPAGLIFLOZIN') or
     upcase(gnn) in: ('BEXAGLIFLOZIN', 'CANAGLIFLOZIN', 'DAPAGLIFLOZIN', 'EMPAGLIFLOZIN') then sglt2 = 1;
  if upcase(bn) in: ('GLIMEPIRIDE', 'GLIPIZIDE', 'GLYBURIDE') or
     upcase(gnn) in: ('GLIMEPIRIDE', 'GLIPIZIDE', 'GLYBURIDE') then sulf = 1;
  if upcase(bn) in: ('ROSIGLITAZONE', 'PIOGLITAZONE') or
     upcase(gnn) in: ('ROSIGLITAZONE', 'PIOGLITAZONE') then tzd = 1;
  if upcase(bn) in: ('ACARBOSE', 'MIGLITOL') or
     upcase(gnn) in: ('ACARBOSE', 'MIGLITOL') then alpha = 1;
run;


 proc sort data = ad.all_claims_without_ad;
  by bene_id SRVC_DT;
 run;

 
/* only keep the first initiation */
proc sql;
  create table ad.initiation_drug_with_ad as
  select a.*
  from ad.all_claims_with_ad as a
  inner join (
    select bene_id, min(abs(SRVC_DT - index_date)) as min_diff
    from ad.all_claims_with_ad
    group by bene_id
  ) as b
  on a.bene_id = b.bene_id
  and abs(a.SRVC_DT - a.index_date) = b.min_diff
  order by a.bene_id;
quit;

proc sql;
  create table ad.initiation_drug_without_ad as
  select a.*
  from ad.all_claims_without_ad as a
  inner join (
    select bene_id, min(abs(SRVC_DT - index_date)) as min_diff
    from ad.all_claims_without_ad
    group by bene_id
  ) as b
  on a.bene_id = b.bene_id
  and abs(a.SRVC_DT - a.index_date) = b.min_diff
  order by a.bene_id;
quit;


proc sql;
    create table ad.initiation_drug_user_with_ad as
    select bene_id,
           max(insulin) as insulin_user,
           max(metformin) as metformin_user,
           max(dpp4) as dpp4_user,
           max(glp1) as glp1_user,
           max(sglt2) as sglt2_user,
           max(sulf) as sulf_user,
           max(tzd) as tzd_user,
           max(alpha) as alpha_user
    from ad.initiation_drug_with_ad
    group by bene_id;

    /* Calculate counts and percentages directly */
    select sum(insulin_user) as insulin_users,
           sum(insulin_user) / count(distinct bene_id) * 100 as insulin_percentage format=8.2,
           sum(metformin_user) as metformin_users,
           sum(metformin_user) / count(distinct bene_id) * 100 as metformin_percentage format=8.2,
           sum(dpp4_user) as dpp4_users,
           sum(dpp4_user) / count(distinct bene_id) * 100 as dpp4_percentage format=8.2,
           sum(glp1_user) as glp1_users,
           sum(glp1_user) / count(distinct bene_id) * 100 as glp1_percentage format=8.2,
           sum(sglt2_user) as sglt2_users,
           sum(sglt2_user) / count(distinct bene_id) * 100 as sglt2_percentage format=8.2,
           sum(sulf_user) as sulf_users,
           sum(sulf_user) / count(distinct bene_id) * 100 as sulf_percentage format=8.2,
           sum(tzd_user) as tzd_users,
           sum(tzd_user) / count(distinct bene_id) * 100 as tzd_percentage format=8.2,
           sum(alpha_user) as alpha_users,
           sum(alpha_user) / count(distinct bene_id) * 100 as alpha_percentage format=8.2
    from ad.initiation_drug_user_with_ad;
quit;


proc sql;
    create table ad.initiation_drug_user_without_ad as
    select bene_id,
           max(insulin) as insulin_user,
           max(metformin) as metformin_user,
           max(dpp4) as dpp4_user,
           max(glp1) as glp1_user,
           max(sglt2) as sglt2_user,
           max(sulf) as sulf_user,
           max(tzd) as tzd_user,
           max(alpha) as alpha_user
    from ad.initiation_drug_without_ad
    group by bene_id;

    /* Calculate counts and percentages directly */
    select sum(insulin_user) as insulin_users,
           sum(insulin_user) / count(distinct bene_id) * 100 as insulin_percentage format=8.2,
           sum(metformin_user) as metformin_users,
           sum(metformin_user) / count(distinct bene_id) * 100 as metformin_percentage format=8.2,
           sum(dpp4_user) as dpp4_users,
           sum(dpp4_user) / count(distinct bene_id) * 100 as dpp4_percentage format=8.2,
           sum(glp1_user) as glp1_users,
           sum(glp1_user) / count(distinct bene_id) * 100 as glp1_percentage format=8.2,
           sum(sglt2_user) as sglt2_users,
           sum(sglt2_user) / count(distinct bene_id) * 100 as sglt2_percentage format=8.2,
           sum(sulf_user) as sulf_users,
           sum(sulf_user) / count(distinct bene_id) * 100 as sulf_percentage format=8.2,
           sum(tzd_user) as tzd_users,
           sum(tzd_user) / count(distinct bene_id) * 100 as tzd_percentage format=8.2,
           sum(alpha_user) as alpha_users,
           sum(alpha_user) / count(distinct bene_id) * 100 as alpha_percentage format=8.2
    from ad.initiation_drug_user_without_ad;
quit;


/* getting number of drug class */
data ad.initiation_drug_user_with_ad;
    set ad.initiation_drug_user_with_ad;
    num_drug_class = sum(insulin_user, metformin_user, dpp4_user, glp1_user, sglt2_user, sulf_user, tzd_user, alpha_user);
run;

data ad.initiation_drug_user_without_ad;
    set ad.initiation_drug_user_without_ad;
    num_drug_class = sum(insulin_user, metformin_user, dpp4_user, glp1_user, sglt2_user, sulf_user, tzd_user, alpha_user);
run;


/* getting number of drug class distribution */
proc freq data = ad.initiation_drug_user_with_ad;
  tables num_drug_class;
run;

proc freq data = ad.initiation_drug_user_without_ad;
  tables num_drug_class;
run;


/* counting drug use for each class during the whole following 1 year */
proc sql;
    create table ad.drug_user_with_ad as
    select bene_id,
           max(insulin) as insulin_user,
           max(metformin) as metformin_user,
           max(dpp4) as dpp4_user,
           max(glp1) as glp1_user,
           max(sglt2) as sglt2_user,
           max(sulf) as sulf_user,
           max(tzd) as tzd_user,
           max(alpha) as alpha_user
    from ad.all_claims_with_ad
    group by bene_id;

  select sum(insulin_user) as insulin_users,
            sum(insulin_user) / count(distinct bene_id) * 100 as insulin_percentage format=8.2,
            sum(metformin_user) as metformin_users,
            sum(metformin_user) / count(distinct bene_id) * 100 as metformin_percentage format=8.2,
            sum(dpp4_user) as dpp4_users,
            sum(dpp4_user) / count(distinct bene_id) * 100 as dpp4_percentage format=8.2,
            sum(glp1_user) as glp1_users,
            sum(glp1_user) / count(distinct bene_id) * 100 as glp1_percentage format=8.2,
            sum(sglt2_user) as sglt2_users,
            sum(sglt2_user) / count(distinct bene_id) * 100 as sglt2_percentage format=8.2,
            sum(sulf_user) as sulf_users,
            sum(sulf_user) / count(distinct bene_id) * 100 as sulf_percentage format=8.2,
            sum(tzd_user) as tzd_users,
            sum(tzd_user) / count(distinct bene_id) * 100 as tzd_percentage format=8.2,
            sum(alpha_user) as alpha_users,
            sum(alpha_user) / count(distinct bene_id) * 100 as alpha_percentage format=8.2
     from ad.drug_user_with_ad;
 quit;

proc sql;
    create table ad.drug_user_without_ad as
    select bene_id,
           max(insulin) as insulin_user,
           max(metformin) as metformin_user,
           max(dpp4) as dpp4_user,
           max(glp1) as glp1_user,
           max(sglt2) as sglt2_user,
           max(sulf) as sulf_user,
           max(tzd) as tzd_user,
           max(alpha) as alpha_user
    from ad.all_claims_without_ad
    group by bene_id;

  select sum(insulin_user) as insulin_users,
            sum(insulin_user) / count(distinct bene_id) * 100 as insulin_percentage format=8.2,
            sum(metformin_user) as metformin_users,
            sum(metformin_user) / count(distinct bene_id) * 100 as metformin_percentage format=8.2,
            sum(dpp4_user) as dpp4_users,
            sum(dpp4_user) / count(distinct bene_id) * 100 as dpp4_percentage format=8.2,
            sum(glp1_user) as glp1_users,
            sum(glp1_user) / count(distinct bene_id) * 100 as glp1_percentage format=8.2,
            sum(sglt2_user) as sglt2_users,
            sum(sglt2_user) / count(distinct bene_id) * 100 as sglt2_percentage format=8.2,
            sum(sulf_user) as sulf_users,
            sum(sulf_user) / count(distinct bene_id) * 100 as sulf_percentage format=8.2,
            sum(tzd_user) as tzd_users,
            sum(tzd_user) / count(distinct bene_id) * 100 as tzd_percentage format=8.2,
            sum(alpha_user) as alpha_users,
            sum(alpha_user) / count(distinct bene_id) * 100 as alpha_percentage format=8.2
     from ad.drug_user_without_ad;
 quit;


/* getting number of drug class */
data ad.drug_user_with_ad;
    set ad.drug_user_with_ad;
    num_drug_class = sum(insulin_user, metformin_user, dpp4_user, glp1_user, sglt2_user, sulf_user, tzd_user, alpha_user);
run;

data ad.drug_user_without_ad;
    set ad.drug_user_without_ad;
    num_drug_class = sum(insulin_user, metformin_user, dpp4_user, glp1_user, sglt2_user, sulf_user, tzd_user, alpha_user);
run;

/* getting number of drug class distribution */
proc freq data = ad.drug_user_with_ad;
  tables num_drug_class;
run;

proc freq data = ad.drug_user_without_ad;
  tables num_drug_class;
run;


/*  getting drug class transitions to draw Sanky Plot*/
proc sql;
    create table ad.drug_class_transitions as
    select a.num_drug_class as initiation_class,
           b.num_drug_class as followup_class,
           count(a.bene_id) as count
    from ad.initiation_drug_user_with_ad as a
    inner join ad.drug_user_with_ad as b
    on a.bene_id = b.bene_id
    group by a.num_drug_class, b.num_drug_class;
quit;

proc sql;
    create table ad.drug_class_transitions_nonad as
    select a.num_drug_class as initiation_class,
           b.num_drug_class as followup_class,
           count(a.bene_id) as count
    from ad.initiation_drug_user_without_ad as a
    inner join ad.drug_user_without_ad as b
    on a.bene_id = b.bene_id
    group by a.num_drug_class, b.num_drug_class;
quit;


   /* add CCI to table1 */
 data ad.table1_with_ad;
   merge ad.table1_with_ad(in=a)
         CCI_with_ad(keep=bene_id charlson_index in=b);
   by bene_id;
   if a and b;
 run;

data ad.table1_without_ad;
   merge ad.table1_without_ad(in=a)
         CCI_non_ad(keep=bene_id charlson_index in=b);
   by bene_id;
   if a and b;
 run;



/////////////////// Income ////////////////////////
/* AD group*/
data table1_with_ad;
  merge ad.table1_with_ad(in=a)
        ad.new_t2dm(in=b);
  by bene_id;
  if a and b;
run;

data table1_with_ad;
  set table1_with_ad;
  index_year = year(index_date);
run;

proc sql;
  create table merged_ad as
  select a.*, b.*
  from table1_with_ad as a
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

data ad.Table1_with_ad;
  merge ad.Table1_with_ad(in=a)
        merged_ad_income(keep=bene_id low_income in=b);
  by bene_id;
  if a and b;
run;


/* nonAD group */
data table1_without_ad;
  merge ad.table1_without_ad(in=a)
        ad.new_t2dm(in=b);
  by bene_id;
  if a and b;
run;

data table1_without_ad;
  set table1_without_ad;
  index_year = year(index_date);
run;

proc sql;
  create table merged_nonad as
  select a.*, b.*
  from table1_without_ad as a
  left join ad.mbsf as b
  on a.bene_id = b.bene_id and a.index_year = b.BENE_ENROLLMT_REF_YR;
quit;

data merged_nonad_income;
  set merged_nonad;
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

proc freq data=merged_nonad_income;
  tables low_income;
run;

data ad.Table1_without_ad;
  merge ad.Table1_without_ad(in=a)
        merged_nonad_income(keep=bene_id low_income in=b);
  by bene_id;
  if a and b;
run;



