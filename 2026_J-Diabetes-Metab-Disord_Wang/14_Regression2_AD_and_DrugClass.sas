/* Among ID initiating drugs, association between AD & drug class */

data reg2_with_ad;
  merge ad.reg1(in=a)
        ad.table1_with_ad(keep=bene_id in=b) ad.initiation_drug_user_with_ad(in=c);
  by bene_id;
  if a and b and c;
run;

data reg2_without_ad;
  merge ad.reg1(in=a)
        ad.table1_without_ad(keep=bene_id in=b) ad.initiation_drug_user_without_ad(in=c);
  by bene_id;
  if a and b;
run;

data ad.reg2;
  set reg2_with_ad reg2_without_ad;
run;


%macro logit_model(outcome);
    proc logistic data=ad.reg2 descending;
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
