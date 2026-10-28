/**************************************************************************************
 * Progname: 02_inc_samchar.sas
 * Purpose: Clean sample characteristics and derive study-indication flags
 * Date: 2025-03-04
 * Author: Lijuan Zeng
 * Notes: 
 ***************************************************************************************/
%include "S:/lzeng3/ALA_SRMA/prog/00_utility.sas";
    
* Set up the environment;
options nocenter nonumber; /*nodate*/
%global progname;
%let progname=%str(02_inc_samchar);

************************************************************************************************
** Clean up sample characteristics for the included studies for KQ1
************************************************************************************************;
proc sort data = outdata.sample_cha out=sc1;
	by extraction_id arms_name;
run;

* Incorporate kq1_include to keep included studies only;
proc sort data=outdata.study_kq1_rct_include out=kq1_include ;
	by extraction_id;
run;
proc freq data=kq1_include ;
   tables flag_meta_ana   / list missing;
run;

data inc_sc1;
	merge 	sc1 (in=A)
			kq1_include (in=B keep=extraction_id flag_meta_ana study);
	by extraction_id;
	if A and B and flag_meta_ana=1;

run;

* Incorporate kq1_inc_rct_arms_Details for arms of interest;
proc sort data = outdata.kq1_inc_rct_arms_details out=kq1_arms;
	by extraction_id arms_name;
run;
proc sort data = inc_sc1; by extraction_id arms_name; run;

data inc_sc2;
	merge 	kq1_arms (in=A keep = extraction_id arms_name drug_Group:)
			inc_sc1 (in=B rename=(
			sc_age_mean=_sc_age_mean 	sc_age_sd=_sc_age_sd 	sc_age_median=_sc_age_median
			sc_sex_male_n=_sc_sex_male_n	sc_sex_male_perc=_sc_sex_male_perc	
			sc_sex_female_n=_sc_sex_female_n	sc_sex_female_perc=_sc_sex_female_perc
			sc_bmi_mean=_sc_bmi_mean	sc_bmi_sd=_sc_bmi_sd	sc_bmi_median=_sc_bmi_median
			/* sc_race_white_n=_sc_race_white_n	sc_race_black_n=_sc_race_black_n	sc_race_asian_n=_sc_race_asian_n sc_race_aian_n=_sc_race_aian_n*/
			sc_race_hawai_n=_sc_race_hawai_n	
			sc_ethic_hispanic_n=_sc_ethic_hispanic_n	sc_ethic_nhispanic_n=_sc_ethic_nhispanic_n
			sc_ind_diabetes_n=_sc_ind_diabetes_n	sc_ind_weight_n=_sc_ind_weight_n	sc_ind_migraine_n=_sc_ind_migraine_n
			sc_ind_diabetes_perc=_sc_ind_diabetes_perc	sc_ind_weight_perc=_sc_ind_weight_perc 
			sc_ind_migraine_perc=_sc_ind_migraine_perc	sc_ind_cvd_perc = _sc_ind_cvd_perc
			sc_ind_other1_perc = _sc_ind_other1_perc
			));
	by extraction_id arms_name;
	if A and B;

	array charvars 	_sc_age_mean _sc_age_sd _sc_age_median 
					_sc_sex_male_n 	_sc_sex_male_perc 	_sc_sex_female_n 	_sc_sex_female_perc
					_sc_bmi_mean _sc_bmi_sd _sc_bmi_median
					/* _sc_race_white_n	_sc_race_black_n	_sc_race_asian_n	_sc_race_aian_n  */
					_sc_race_hawai_n
					_sc_ethic_hispanic_n	_sc_ethic_nhispanic_n
					_sc_ind_diabetes_n	_sc_ind_weight_n	_sc_ind_migraine_n
					_sc_ind_diabetes_perc	_sc_ind_weight_perc	_sc_ind_migraine_perc
					_sc_ind_cvd_perc _sc_ind_other1_perc;
	array numvars 	sc_age_mean sc_age_sd sc_age_median
					sc_sex_male_n	sc_sex_male_perc	sc_sex_female_n		sc_sex_female_perc
					sc_bmi_mean	sc_bmi_sd	sc_bmi_median
					/* sc_race_white_n	 sc_race_black_n	sc_race_asian_n	sc_race_aian_n  */
					sc_race_hawai_n
					sc_ethic_hispanic_n	sc_ethic_nhispanic_n
					sc_ind_diabetes_n	sc_ind_weight_n	sc_ind_migraine_n
					sc_ind_diabetes_perc	sc_ind_weight_perc	sc_ind_migraine_perc
					sc_ind_cvd_perc sc_ind_other1_perc;

	do i=1 to dim(charvars);
		if missing(numvars[i]) then numvars[i] = input(charvars[i], best.);
	end;

	/* sc_age_mean = input(strip(_sc_age_mean), best.);
	sc_age_sd = input(strip(_sc_age_sd), best.);
	sc_age_median = input(strip(_sc_age_median), best.); */
	if not missing(sc_age_range) then do;
		if index(sc_age_range, ";")>0 then do;
			sc_age_min = input(scan(sc_age_Range, 1, ";"), best.);
			sc_age_max = input(scan(sc_age_range, 2, ";"), best.);
		end;
		else if index(sc_age_range, ",")>0 then do;
			sc_age_min = input(scan(sc_age_Range, 1, ","), best.);
			sc_age_max = input(scan(sc_age_range, 2, ","), best.);
		end;
	end;

	if not missing(sc_bmi_range) then do;
		if index(sc_bmi_range, ";")>0 then do;
			sc_bmi_min = input(scan(sc_bmi_Range, 1, ";"), best.);
			sc_bmi_max = input(scan(sc_bmi_range, 2, ";"), best.);
		end;
		else if index(sc_bmi_range, ",")>0 then do;
			sc_bmi_min = input(scan(sc_bmi_Range, 1, ","), best.);
			sc_bmi_max = input(scan(sc_bmi_range, 2, ","), best.);
		end;
	end;

	drop i _sc_:;

	label flag_ind_diabetes = "Diabetes"
		  flag_ind_weight = "Weight"
		  flag_ind_migraine = "Migraine"
		  flag_ind_cvd = "CVD"
		  flag_ind_other1 = "Other";
	if cmiss(sc_ind_diabetes_n, sc_ind_diabetes_perc) ne 2 then flag_ind_diabetes = 1; else flag_ind_diabetes = 0;
	if cmiss(sc_ind_weight_n, sc_ind_weight_perc) ne 2 then flag_ind_weight = 1; else flag_ind_weight = 0;
	if cmiss(sc_ind_migraine_n, sc_ind_migraine_perc) ne 2 then flag_ind_migraine = 1; else flag_ind_migraine = 0;
	if cmiss(sc_ind_cvd_perc, sc_ind_cvd_n) ne 2 then flag_ind_cvd = 1; else flag_ind_cvd = 0;
	if cmiss(sc_ind_other1_perc, sc_ind_other1_n) ne 2 then flag_ind_other1 = 1; else flag_ind_other1 = 0;

run;

proc sort data = inc_Sc2 out=outdata.kq1_inc_rct_samchar (label = "Created from &progname..sas");
	by extraction_id drug_group1;
run;

proc freq data=outdata.kq1_inc_rct_samchar ;
   tables flag_ind_diabetes * flag_ind_weight
   / list missing;
run;
proc print data= outdata.kq1_inc_rct_samchar (where=(flag_ind_diabetes = 1 and flag_ind_weight = 1));
   var _all_;
run;
title3;
