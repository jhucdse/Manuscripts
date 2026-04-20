/*getting a list of bene_id for all_T2DM */
proc sort data=ad.all_t2dm out=all_t2dm_id nodupkey;
  by bene_id;
run;
data all_t2dm_id;
  set all_t2dm_id (keep = bene_id);
run;


/*getting all mbsf 2016-2020*/
proc sql;
  create table ad.mbsf2016 as
  select * from mbsf16.mbsf_abcd_summary_2016
  where bene_id in (select bene_id from all_t2dm_id);
quit;

proc sql;
  create table ad.mbsf2017 as
  select * from mbsf17.mbsf_abcd_summary_2017
  where bene_id in (select bene_id from all_t2dm_id);
quit;

proc sql;
  create table ad.mbsf2018 as
  select * from mbsf18.mbsf_abcd_summary_2018
  where bene_id in (select bene_id from all_t2dm_id);
quit;

proc sql;
  create table ad.mbsf2019 as
  select * from mbsf19.mbsf_abcd_summary_2019
  where bene_id in (select bene_id from all_t2dm_id);
quit;

proc sql;
  create table ad.mbsf2020 as
  select * from mbsf20.mbsf_abcd_summary_2020
  where bene_id in (select bene_id from all_t2dm_id);
quit;


/*combine all T2DM mbsf data 2016-2020 */
data ad.mbsf;
  set ad.mbsf2016 ad.mbsf2017 ad.mbsf2018 ad.mbsf2019 ad.mbsf2020;
run;


/*getting rid of those who are not in the 20% sample group*/
Data ad.mbsf;
Set ad.mbsf;
Where sample_group ne ' ';
Run;
