proc sql;
    create table ad.table1_study_ad as
    select a.*,
           case
               when b.bene_id is not null then 1
               else 0
           end as treatment
    from ad.table1_study_ad as a
    left join ad.table1_with_ad as b
    on a.bene_id = b.bene_id;
quit;

proc sql;
    create table ad.table1_study_nonad as
    select a.*,
           case
               when b.bene_id is not null then 1
               else 0
           end as treatment
    from ad.table1_study_nonad as a
    left join ad.table1_without_ad as b
    on a.bene_id = b.bene_id;
quit;


data ad.reg1;
  set ad.table1_study_ad ad.table1_study_nonad;
run;

proc sql;
    create table ad.reg1 as
    select a.*,
           case
               when b.bene_id is not null then 1
               when c.bene_id is not null then 0
               else .
           end as AD_status
    from ad.reg1 as a
    left join ad.table1_study_ad as b
    on a.bene_id = b.bene_id
    left join ad.table1_study_nonad as c
    on a.bene_id = c.bene_id;
quit;

data ad.reg1;
    set ad.reg1;
    if RTI_RACE_CD = 0 then RTI_RACE_CD = 3;
run;

data ad.reg1;
    set ad.reg1;
    if region = "Northeast" then region_num = 1;
    else if region = "Midwest" then region_num = 2;
    else if region = "South" then region_num = 3;
    else if region = "West" then region_num = 4;
    else if region in ("International", "US Territory", "Unknown") then region_num = 5;
run;

data ad.reg1;
    set ad.reg1;
    if charlson_index >= 5 then charlson_index = 5;
run;


proc logistic data=ad.reg1 descending;
    class AD_status(ref='0')
          SEX_IDENT_CD(ref='1') RTI_RACE_CD(ref='1') region_num(ref='1') 
          Low_income(ref='0') charlson_index(ref='0') / param=ref;
    model treatment(event='1') = AD_status
                                 age SEX_IDENT_CD RTI_RACE_CD region_num
                                 Low_income charlson_index / clodds=pl;
run;




