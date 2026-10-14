/*getting all antidiabetic drug claims 2016-2020*/

data ad.all_antidiabetic_2017;
  set partd17.pde_file_2017(keep = bene_id dob_dt gndr_cd srvc_dt qty_dspnsd_num days_suply_num bn str gnn formulary_id frmlry_rx_id);
    where upcase(bn) in: ('METFORMIN','ALOGLIPTIN', 'LINAGLIPTIN', 'SAXAGLIPTIN', 'SITAGLIPTIN', 'DULAGLUTIDE', 'EXENATIDE', 'LIRAGLUTIDE', 'LIXISENATIDE','SEMAGLUTIDE', 'TIRZEPATIDE','BEXAGLIFLOZIN', 'CANAGLIFLOZIN',
                          'DAPAGLIFLOZIN', 'EMPAGLIFLOZIN', 'GLIMEPIRIDE', 'GLIPIZIDE', 'GLYBURIDE', 'ROSIGLITAZONE', 'PIOGLITAZONE', 'INSULIN', 'ACARBOSE', 'MIGLITOL')
    or upcase(gnn) in: ('METFORMIN','ALOGLIPTIN', 'LINAGLIPTIN', 'SAXAGLIPTIN', 'SITAGLIPTIN', 'DULAGLUTIDE', 'EXENATIDE', 'LIRAGLUTIDE', 'LIXISENATIDE','SEMAGLUTIDE', 'TIRZEPATIDE','BEXAGLIFLOZIN', 'CANAGLIFLOZIN',
                          'DAPAGLIFLOZIN', 'EMPAGLIFLOZIN', 'GLIMEPIRIDE', 'GLIPIZIDE', 'GLYBURIDE', 'ROSIGLITAZONE', 'PIOGLITAZONE', 'INSULIN', 'ACARBOSE', 'MIGLITOL');
 run;

 data ad.all_antidiabetic_2018;
  set partd18.pde_file_2018(keep = bene_id dob_dt gndr_cd srvc_dt qty_dspnsd_num days_suply_num bn str gnn formulary_id frmlry_rx_id);
    where upcase(bn) in: ('METFORMIN','ALOGLIPTIN', 'LINAGLIPTIN', 'SAXAGLIPTIN', 'SITAGLIPTIN', 'DULAGLUTIDE', 'EXENATIDE', 'LIRAGLUTIDE', 'LIXISENATIDE','SEMAGLUTIDE', 'TIRZEPATIDE','BEXAGLIFLOZIN', 'CANAGLIFLOZIN',
                          'DAPAGLIFLOZIN', 'EMPAGLIFLOZIN', 'GLIMEPIRIDE', 'GLIPIZIDE', 'GLYBURIDE', 'ROSIGLITAZONE', 'PIOGLITAZONE', 'INSULIN', 'ACARBOSE', 'MIGLITOL')
    or upcase(gnn) in: ('METFORMIN','ALOGLIPTIN', 'LINAGLIPTIN', 'SAXAGLIPTIN', 'SITAGLIPTIN', 'DULAGLUTIDE', 'EXENATIDE', 'LIRAGLUTIDE', 'LIXISENATIDE','SEMAGLUTIDE', 'TIRZEPATIDE','BEXAGLIFLOZIN', 'CANAGLIFLOZIN',
                          'DAPAGLIFLOZIN', 'EMPAGLIFLOZIN', 'GLIMEPIRIDE', 'GLIPIZIDE', 'GLYBURIDE', 'ROSIGLITAZONE', 'PIOGLITAZONE', 'INSULIN', 'ACARBOSE', 'MIGLITOL');
 run;

 data ad.all_antidiabetic_2019;
  set partd19.pde_file_2019(keep = bene_id dob_dt gndr_cd srvc_dt qty_dspnsd_num days_suply_num bn str gnn formulary_id frmlry_rx_id);
    where upcase(bn) in: ('METFORMIN','ALOGLIPTIN', 'LINAGLIPTIN', 'SAXAGLIPTIN', 'SITAGLIPTIN', 'DULAGLUTIDE', 'EXENATIDE', 'LIRAGLUTIDE', 'LIXISENATIDE','SEMAGLUTIDE', 'TIRZEPATIDE','BEXAGLIFLOZIN', 'CANAGLIFLOZIN',
                          'DAPAGLIFLOZIN', 'EMPAGLIFLOZIN', 'GLIMEPIRIDE', 'GLIPIZIDE', 'GLYBURIDE', 'ROSIGLITAZONE', 'PIOGLITAZONE', 'INSULIN', 'ACARBOSE', 'MIGLITOL')
    or upcase(gnn) in: ('METFORMIN','ALOGLIPTIN', 'LINAGLIPTIN', 'SAXAGLIPTIN', 'SITAGLIPTIN', 'DULAGLUTIDE', 'EXENATIDE', 'LIRAGLUTIDE', 'LIXISENATIDE','SEMAGLUTIDE', 'TIRZEPATIDE','BEXAGLIFLOZIN', 'CANAGLIFLOZIN',
                          'DAPAGLIFLOZIN', 'EMPAGLIFLOZIN', 'GLIMEPIRIDE', 'GLIPIZIDE', 'GLYBURIDE', 'ROSIGLITAZONE', 'PIOGLITAZONE', 'INSULIN', 'ACARBOSE', 'MIGLITOL');
 run;

 data ad.all_antidiabetic_2020;
  set partd20.pde_file_2020(keep = bene_id dob_dt gndr_cd srvc_dt qty_dspnsd_num days_suply_num bn str gnn formulary_id frmlry_rx_id);
    where upcase(bn) in: ('METFORMIN','ALOGLIPTIN', 'LINAGLIPTIN', 'SAXAGLIPTIN', 'SITAGLIPTIN', 'DULAGLUTIDE', 'EXENATIDE', 'LIRAGLUTIDE', 'LIXISENATIDE','SEMAGLUTIDE', 'TIRZEPATIDE','BEXAGLIFLOZIN', 'CANAGLIFLOZIN',
                          'DAPAGLIFLOZIN', 'EMPAGLIFLOZIN', 'GLIMEPIRIDE', 'GLIPIZIDE', 'GLYBURIDE', 'ROSIGLITAZONE', 'PIOGLITAZONE', 'INSULIN', 'ACARBOSE', 'MIGLITOL')
    or upcase(gnn) in: ('METFORMIN','ALOGLIPTIN', 'LINAGLIPTIN', 'SAXAGLIPTIN', 'SITAGLIPTIN', 'DULAGLUTIDE', 'EXENATIDE', 'LIRAGLUTIDE', 'LIXISENATIDE','SEMAGLUTIDE', 'TIRZEPATIDE','BEXAGLIFLOZIN', 'CANAGLIFLOZIN',
                          'DAPAGLIFLOZIN', 'EMPAGLIFLOZIN', 'GLIMEPIRIDE', 'GLIPIZIDE', 'GLYBURIDE', 'ROSIGLITAZONE', 'PIOGLITAZONE', 'INSULIN', 'ACARBOSE', 'MIGLITOL');
 run;


/*  combine all antidiabetic claims 2017-2020 */
data ad.all_antidiabetic_claims;
  set ad.all_antidiabetic_2017 ad.all_antidiabetic_2018 ad.all_antidiabetic_2019 ad.all_antidiabetic_2020;
run;


/* add all antidiabetic drug indicator */
data ad.all_antidiabetic_claims;
  set ad.all_antidiabetic_claims;
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


 proc sort data = ad.all_antidiabetic_claims;
  by bene_id SRVC_DT;
 run;
