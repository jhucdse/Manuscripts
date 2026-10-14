*******************************************************************************;
* Program name      :	xx_primary_analysis_incidence_rates
* Author            :	Jamie Heyward
* Date created      :	December 6 2023
* Study             : 	
* Purpose           :	Calculate incidence rates and incidence rate difference for cancer-specific and all-cause mortality comparing treatment arms
* Inputs            :	
* Program completed : 	
* Updated by        :   Xinyi Sun March 21 2025
*********************************************************************************;
LIBNAME seer 'S:\Pharmacoepi0216\Thesis';
LIBNAME thesis 'S:\Pharmacoepi0216\Thesis_new';
/***************** Primary outcome: Cancer-specific death ********************/
/* Calculate incidence rates */
data thesis.cohort_psweighted_fg_trimmed; 
set thesis.cohort_psweighted_fg_trimmed; 
log_fu = log(years_to_end_fu); 
numeric_cancer_death = input(cancer_death, comma9.);
run; 

proc freq data = thesis.cohort_psweighted_fg_trimmed; 
table numeric_cancer_death * Met_1px;
run;

proc freq data = thesis.cohort_psweighted_fg_trimmed; 
table censor_flag1 * Met_1px;
run;

proc means data=thesis.cohort_psweighted_fg_trimmed sum;
    class Met_1px;
    var years_to_end_fu;
    output out=total_person_time sum=total_person_time;
run;

*Unadjusted IR;
proc genmod data=thesis.cohort_psweighted_fg_trimmed; 
    class Met_1px (ref='0');
    model censor_flag1 (event = '1') = Met_1px / dist=poisson link=log offset=log_fu;
	*weight sipew_t;
    lsmeans Met_1px / ilink cl;

    /* Store the results in an output dataset */
    ods output lsmeans = lsmeans_output0;
	run;
/* Calculate cIR difference and 95% CI */ 
	data lsmean_met_0; 
	set lsmeans_output0; 
	if Met_1px = 0;
	ir_met0 = Mu; 
	sterr_met0 = StdErrMu;
	Met_1px=1; output;
	Met_1px=0; output;
	run;

	data lsmean_met_1; 
	set lsmeans_output0; 
	if Met_1px = 1;
	ir_met1 = Mu; 
	sterr_met1 = StdErrMu;
	Met_1px=1; output;
	Met_1px=0; output;
	run;

	/* Merge in, calculate IR differences */ 
	data ir_differences; 
	merge lsmeans_output0 lsmean_met_0 (keep = Met_1px ir_met0 sterr_met0); 
	run; 

	data ir_differences; 
	merge ir_differences lsmean_met_1 (keep = Met_1px ir_met1 sterr_met1); 
	run; 

	/* cIR differences and 95% CIs, Met 1 vs 0*/
	data ir_differences; 
	set ir_differences;

	/* Calculate incidence rate difference */
	ir_diff = ir_met1 - ir_met0; 
	
	    /* Calculate standard error of the difference */
	    sterr_ird = sqrt(sterr_met0**2 + sterr_met1**2); 
		
	    /* Calculate 95% confidence interval for the difference in incidence rates */
	    critical_value = 1.96; /* For a 95% confidence interval */
	    lower_ci = ir_diff - critical_value * sterr_ird;
	    upper_ci = ir_diff + critical_value * sterr_ird;
	run;
 /* cIRD = -0.0324, 95% CI:(-0.1790,0.1142) */


*Adjusted IR;
proc genmod data=thesis.cohort_psweighted_fg_trimmed; 
    class Met_1px (ref='0');
    model censor_flag1 (event = '1') = Met_1px / dist=poisson link=log offset=log_fu;
	weight sipew_t;
    lsmeans Met_1px / ilink cl;

    /* Store the results in an output dataset */
    ods output lsmeans = lsmeans_output1;
	run;

	/* Calculate IR difference and 95% CI */ 
	data lsmean_met_0; 
	set lsmeans_output1; 
	if Met_1px = 0;
	ir_met0 = Mu; 
	sterr_met0 = StdErrMu;
	Met_1px=1; output;
	Met_1px=0; output;
	run;

	data lsmean_met_1; 
	set lsmeans_output1; 
	if Met_1px = 1;
	ir_met1 = Mu; 
	sterr_met1 = StdErrMu;
	Met_1px=1; output;
	Met_1px=0; output;
	run;

	/* Merge in, calculate IR differences */ 
	data ir_differences; 
	merge lsmeans_output1 lsmean_met_0 (keep = Met_1px ir_met0 sterr_met0); 
	run; 

	data ir_differences; 
	merge ir_differences lsmean_met_1 (keep = Met_1px ir_met1 sterr_met1); 
	run; 

	/* aIR differences and 95% CIs, Met 1 vs 0*/
	data ir_differences; 
	set ir_differences;

	/* Calculate incidence rate difference */
	ir_diff = ir_met1 - ir_met0; 
	
	    /* Calculate standard error of the difference */
	    sterr_ird = sqrt(sterr_met0**2 + sterr_met1**2); 
		
	    /* Calculate 95% confidence interval for the difference in incidence rates */
	    critical_value = 1.96; /* For a 95% confidence interval */
	    lower_ci = ir_diff - critical_value * sterr_ird;
	    upper_ci = ir_diff + critical_value * sterr_ird;
	run;
 /* aIR = 0.0107, 95% CI:(-0.1347,0.1562) */


/************* Secondary outcome: All cause death use medicare death *******************************************/ 
/* Calculate incidence rates */
data thesis.cohort_psweighted_trimmed; 
set thesis.cohort_psweighted_trimmed; 
log_fu = log(years_to_end_fu); 
run; 

proc freq data = thesis.cohort_psweighted_trimmed; 
table censor_flag2 * Met_1px;
run;

proc means data=thesis.cohort_psweighted_trimmed sum;
    class Met_1px;
    var years_to_end_fu;
    output out=total_person_time sum=total_person_time;
run;

*Unadjusted IR;
proc genmod data=thesis.cohort_psweighted_trimmed; 
    class Met_1px (ref='0');
    model censor_flag2 (event = '1') = Met_1px / dist=poisson link=log offset=log_fu;
	*weight sipew_t;
    lsmeans Met_1px / ilink cl;

    /* Store the results in an output dataset */
    ods output lsmeans = lsmeans_output0;
	run;
/* Calculate cIR difference and 95% CI */ 
	data lsmean_met_0; 
	set lsmeans_output0; 
	if Met_1px = 0;
	ir_met0 = Mu; 
	sterr_met0 = StdErrMu;
	Met_1px=1; output;
	Met_1px=0; output;
	run;

	data lsmean_met_1; 
	set lsmeans_output0; 
	if Met_1px = 1;
	ir_met1 = Mu; 
	sterr_met1 = StdErrMu;
	Met_1px=1; output;
	Met_1px=0; output;
	run;

	/* Merge in, calculate IR differences */ 
	data ir_differences; 
	merge lsmeans_output0 lsmean_met_0 (keep = Met_1px ir_met0 sterr_met0); 
	run; 

	data ir_differences; 
	merge ir_differences lsmean_met_1 (keep = Met_1px ir_met1 sterr_met1); 
	run; 

	/* cIR differences and 95% CIs, Met 1 vs 0*/
	data ir_differences; 
	set ir_differences;

	/* Calculate incidence rate difference */
	ir_diff = ir_met1 - ir_met0; 
	
	    /* Calculate standard error of the difference */
	    sterr_ird = sqrt(sterr_met0**2 + sterr_met1**2); 
		
	    /* Calculate 95% confidence interval for the difference in incidence rates */
	    critical_value = 1.96; /* For a 95% confidence interval */
	    lower_ci = ir_diff - critical_value * sterr_ird;
	    upper_ci = ir_diff + critical_value * sterr_ird;
	run;
 /* cIRD = 0.0176, 95% CI:(-0.0891,0.1243) */


*Adjusted IR;
proc genmod data=thesis.cohort_psweighted_trimmed; 
    class Met_1px (ref='0');
    model censor_flag2 (event = '1') = Met_1px / dist=poisson link=log offset=log_fu;
	weight sipew_t;
    lsmeans Met_1px / ilink cl;

    /* Store the results in an output dataset */
    ods output lsmeans = lsmeans_output1;
	run;

	/* Calculate aIR difference and 95% CI */ 
	data lsmean_met_0; 
	set lsmeans_output1; 
	if Met_1px = 0;
	ir_met0 = Mu; 
	sterr_met0 = StdErrMu;
	Met_1px=1; output;
	Met_1px=0; output;
	run;

	data lsmean_met_1; 
	set lsmeans_output1; 
	if Met_1px = 1;
	ir_met1 = Mu; 
	sterr_met1 = StdErrMu;
	Met_1px=1; output;
	Met_1px=0; output;
	run;

	/* Merge in, calculate IR differences */ 
	data ir_differences; 
	merge lsmeans_output1 lsmean_met_0 (keep = Met_1px ir_met0 sterr_met0); 
	run; 

	data ir_differences; 
	merge ir_differences lsmean_met_1 (keep = Met_1px ir_met1 sterr_met1); 
	run; 

	/* aIR differences and 95% CIs, Met 1 vs 0*/
	data ir_differences; 
	set ir_differences;

	/* Calculate incidence rate difference */
	ir_diff = ir_met1 - ir_met0; 
	
	    /* Calculate standard error of the difference */
	    sterr_ird = sqrt(sterr_met0**2 + sterr_met1**2); 
		
	    /* Calculate 95% confidence interval for the difference in incidence rates */
	    critical_value = 1.96; /* For a 95% confidence interval */
	    lower_ci = ir_diff - critical_value * sterr_ird;
	    upper_ci = ir_diff + critical_value * sterr_ird;
	run;
 /* aIR = 0.0423, 95% CI:(-0.0647,0.1493) */
