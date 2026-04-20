proc sort data = ad.mbsf2016;
  by bene_id;
run;
proc sort data = ad.mbsf2017;
  by bene_id;
run;
proc sort data = ad.mbsf2018;
  by bene_id;
run;
proc sort data = ad.mbsf2019;
  by bene_id;
run;
proc sort data = ad.mbsf2020;
  by bene_id;
run;


/* Keep only the bene_id column */
proc sort data=ad.exclude65 out=ad.exclude65_id nodupkey;
  by bene_id;
run;
data ad.exclude65_id;
  set ad.exclude65_id(keep=bene_id index_date);
run;


/*continuous enrollment 12 months before index date*/
%macro enroll (yr = );
	Data enroll_&yr;
		merge ad.mbsf&yr.(keep=bene_id mdcr_entlmt_buyin_ind_01-mdcr_entlmt_buyin_ind_12 ptd_cntrct_id_01-ptd_cntrct_id_12 hmo_ind_01-hmo_ind_12)
			  ad.exclude65_id(in=in2 keep=bene_id);
		by bene_id;
		rename mdcr_entlmt_buyin_ind_01-mdcr_entlmt_buyin_ind_12 = mdcr_entlmt_buyin_ind_&yr._01-mdcr_entlmt_buyin_ind_&yr._12
			   ptd_cntrct_id_01-ptd_cntrct_id_12 = ptd_cntrct_id_&yr._01-ptd_cntrct_id_&yr._12
			   hmo_ind_01-hmo_ind_12 = hmo_ind_&yr._01-hmo_ind_&yr._12;
		if in2;
	run;

%mend enroll;
%enroll (yr = 2016);
%enroll (yr = 2017);
%enroll (yr = 2018);
%enroll (yr = 2019);
%enroll (yr = 2020);
proc sort data=enroll_2016 out=enroll_nodup_16 nodup; by bene_id; run;
proc sort data=enroll_2017 out=enroll_nodup_17 nodup; by bene_id; run;
proc sort data=enroll_2018 out=enroll_nodup_18 nodup; by bene_id; run;
proc sort data=enroll_2019 out=enroll_nodup_19 nodup; by bene_id; run;
proc sort data=enroll_2020 out=enroll_nodup_20 nodup; by bene_id; run;


proc sql;
	create table enroll as
	select a.*, b.*, c.*, d.*, e.*
	from enroll_nodup_16 as a, enroll_nodup_17 as b , enroll_nodup_18 as c , enroll_nodup_19 as d  , enroll_nodup_20 as e
	where a.bene_id = b.bene_id = c.bene_id = d.bene_id = e.bene_id
	order by bene_id;
quit;

data enroll_pt;
	merge ad.exclude65_id enroll;              
	by bene_id;
run;

**Part A B D and no HMO enrollment;
data ad.continuous_enrollment;                                                          /*802290 id*/
	set enroll_pt;

Diag_index = (year(index_date)-2016)*12 + month(index_date);
	start_mon= Diag_index-12;

* Part AB;
	ARRAY AB{60} $
                mdcr_entlmt_buyin_ind_2016_01 - mdcr_entlmt_buyin_ind_2016_12
                mdcr_entlmt_buyin_ind_2017_01 - mdcr_entlmt_buyin_ind_2017_12
                mdcr_entlmt_buyin_ind_2018_01 - mdcr_entlmt_buyin_ind_2018_12
                mdcr_entlmt_buyin_ind_2019_01 - mdcr_entlmt_buyin_ind_2019_12
                mdcr_entlmt_buyin_ind_2020_01 - mdcr_entlmt_buyin_ind_2020_12;
   ABflag = 0;
 	DO  i = start_mon TO Diag_index;
 		IF AB{i} in ('3','C') THEN ABflag=ABflag+1;
 	END;
 if ABflag=13;

* Part D;
	ARRAY cd{60} $
                ptd_cntrct_id_2016_01 - ptd_cntrct_id_2016_12
                ptd_cntrct_id_2017_01 - ptd_cntrct_id_2017_12
                ptd_cntrct_id_2018_01 - ptd_cntrct_id_2018_12
                ptd_cntrct_id_2019_01 - ptd_cntrct_id_2019_12
                ptd_cntrct_id_2020_01 - ptd_cntrct_id_2020_12;
  Dflag = 0;
	DO  i = start_mon TO Diag_index;
		IF (substr(cd(i),1,1) in ('H','R','S','E') or substr(cd(i),1,2)='X0') THEN Dflag=Dflag+1;
	END;

if Dflag=13;

* no HMO;
	ARRAY hmo{60} $
                 hmo_ind_2016_01-hmo_ind_2016_12
                 hmo_ind_2017_01-hmo_ind_2017_12
                 hmo_ind_2018_01-hmo_ind_2018_12
                 hmo_ind_2019_01-hmo_ind_2019_12
                 hmo_ind_2020_01-hmo_ind_2020_12;

         hmoflag = 0;
        DO  i = start_mon TO Diag_index;
              IF hmo{i} in ('0') THEN hmoflag=hmoflag+1;
        END;
if hmoflag=13;

 drop
       mdcr_entlmt_buyin_ind_2016_01 - mdcr_entlmt_buyin_ind_2016_12
       mdcr_entlmt_buyin_ind_2017_01 - mdcr_entlmt_buyin_ind_2017_12
       mdcr_entlmt_buyin_ind_2018_01 - mdcr_entlmt_buyin_ind_2018_12
       mdcr_entlmt_buyin_ind_2019_01 - mdcr_entlmt_buyin_ind_2019_12
       mdcr_entlmt_buyin_ind_2020_01 - mdcr_entlmt_buyin_ind_2020_12

       ptd_cntrct_id_2016_01 - ptd_cntrct_id_2016_12
       ptd_cntrct_id_2017_01 - ptd_cntrct_id_2017_12
       ptd_cntrct_id_2018_01 - ptd_cntrct_id_2018_12
       ptd_cntrct_id_2019_01 - ptd_cntrct_id_2019_12
       ptd_cntrct_id_2020_01 - ptd_cntrct_id_2020_12

       hmo_ind_2016_01-hmo_ind_2016_12
       hmo_ind_2017_01-hmo_ind_2017_12
       hmo_ind_2018_01-hmo_ind_2018_12
       hmo_ind_2019_01-hmo_ind_2019_12
       hmo_ind_2020_01-hmo_ind_2020_12
       Diag_index start_mon ABflag Dflag hmoflag i;
  run;
