/* In all study cohort, the association between AD & Drug Class */

data reg3_with_ad;
  merge ad.reg1(in=a)
        ad.table1_study_ad(keep=bene_id in=b)
        ad.initiation_drug_user_with_ad(in=c);
  by bene_id;   if a and b;
  if not c then do;
     insulin_user = 0;
     metformin_user = 0;
     dpp4_user      = 0;
             glp1_user      = 0;
             sglt2_user     = 0;
             sulf_user      = 0;
             tzd_user       = 0;
             alpha_user     = 0;
         end;
     run;

 data reg3_without_ad;
  merge ad.reg1(in=a)
        ad.table1_study_nonad(keep=bene_id in=b)
        ad.initiation_drug_user_without_ad(in=c);
  by bene_id;   if a and b;
  if not c then do;
     insulin_user = 0;
     metformin_user = 0;
     dpp4_user      = 0;
             glp1_user      = 0;
             sglt2_user     = 0;
             sulf_user      = 0;
             tzd_user       = 0;
             alpha_user     = 0;
         end;
     run;

 data reg3;
   set reg3_with_ad reg3_without_ad;
 run;

%macro logit_model(outcome);
    proc logistic data=reg3 descending;
        class AD_status(ref='0')
              SEX_IDENT_CD(ref='1')
              RTI_RACE_CD(ref='1')
              region_num(ref='1')
              Low_income(ref='0')
              charlson_index(ref='0') / param=ref;

        model &outcome (event='1') = AD_status
                                     age SEX_IDENT_CD RTI_RACE_CD
                                     region_num Low_income charlson_index / clodds=pl;
    run;
%mend logit_model;

%logit_model(insulin_user);
%logit_model(metformin_user);
%logit_model(dpp4_user);
%logit_model(glp1_user);
%logit_model(sglt2_user);
%logit_model(sulf_user);
%logit_model(tzd_user);
%logit_model(alpha_user);
