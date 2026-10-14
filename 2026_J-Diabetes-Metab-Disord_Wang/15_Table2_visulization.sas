/* in 1- year follow up */
proc sql;
    create table drug_use_with_ad as
    select
        "Insulin" as Drug_Class, sum(insulin_user) as Users_with_AD, sum(insulin_user) / 3999 * 100 as Pct_with_AD format=8.1 from ad.drug_user_with_ad
    union all select
        "Metformin", sum(metformin_user), sum(metformin_user) / 3999 * 100 from ad.drug_user_with_ad
    union all select
        "Dipeptidyl Peptidase-4 Inhibitors", sum(dpp4_user), sum(dpp4_user) / 3999 * 100 from ad.drug_user_with_ad
    union all select
        "GLP-1 and Dual GLP-1/GIP Agonists", sum(glp1_user), sum(glp1_user) / 3999 * 100 from ad.drug_user_with_ad
    union all select
        "SGLT2 Inhibitors", sum(sglt2_user), sum(sglt2_user) / 3999 * 100 from ad.drug_user_with_ad
    union all select
        "Sulfonylureas", sum(sulf_user), sum(sulf_user) / 3999 * 100 from ad.drug_user_with_ad
    union all select
        "Thiazolidinediones", sum(tzd_user), sum(tzd_user) / 3999 * 100 from ad.drug_user_with_ad
    union all select
        "Alpha-glucosidase Inhibitors", sum(alpha_user), sum(alpha_user) / 3999 * 100 from ad.drug_user_with_ad;
quit;

 proc sql;
     create table drug_use_without_ad as
     select
         "Insulin" as Drug_Class, sum(insulin_user) as Users_without_AD, sum(insulin_user) / 244115 * 100 as Pct_without_AD format=8.1 from ad.drug_user_without_ad
     union all select
         "Metformin", sum(metformin_user), sum(metformin_user) / 244115 * 100 from ad.drug_user_without_ad
     union all select
         "Dipeptidyl Peptidase-4 Inhibitors", sum(dpp4_user), sum(dpp4_user) / 244115 * 100 from ad.drug_user_without_ad
     union all select
         "GLP-1 and Dual GLP-1/GIP Agonists", sum(glp1_user), sum(glp1_user) / 244115 * 100 from ad.drug_user_without_ad
     union all select
         "SGLT2 Inhibitors", sum(sglt2_user), sum(sglt2_user) / 244115 * 100 from ad.drug_user_without_ad
     union all select
         "Sulfonylureas", sum(sulf_user), sum(sulf_user) / 244115 * 100 from ad.drug_user_without_ad
     union all select
         "Thiazolidinediones", sum(tzd_user), sum(tzd_user) / 244115 * 100 from ad.drug_user_without_ad
     union all select
         "Alpha-glucosidase Inhibitors", sum(alpha_user), sum(alpha_user) / 244115 * 100 from ad.drug_user_without_ad;
 quit;

proc sql;
    create table drug_summary as
    select a.Drug_Class,
           a.Users_with_AD, a.Pct_with_AD,
           b.Users_without_AD, b.Pct_without_AD
    from drug_use_with_ad as a
    full join drug_use_without_ad as b
    on a.Drug_Class = b.Drug_Class;
quit;

data drug_users_long;
    set drug_summary;
    /* Create two rows per drug class: one for AD, one for non-AD */
    Group = "With AD";  Users = Users_with_AD;  output;
    Group = "Without AD"; Users = Users_without_AD; output;
    drop Users_with_AD Pct_with_AD Users_without_AD Pct_without_AD;
run;

data drug_users_long_pct;
    set drug_summary;
    /* Create two rows per drug class: one for AD, one for non-AD */
    Group = "With AD";  Users = Pct_with_AD;  output;
    Group = "Without AD"; Users = Pct_without_AD; output;
    drop Users_with_AD Pct_with_AD Users_without_AD Pct_without_AD;
run;

ods graphics / width=1200px height=600px;  /* High-resolution output */

proc sgplot data=drug_users_long_pct;
    title bold "Percentage of Antidiabetic Drug Users Among T2DM Patients with and without AD in 1 Year after Diagnosis";

    /* Side-by-side clustered bars with horizontal labels */
    vbar Drug_Class / response=Users
                     group=Group
                     groupdisplay=cluster
                     datalabel
                     datalabelattrs=(size=10 weight=bold) /* Smaller font */
                     dataskin=gloss; /* Enhances bar visuals */

    /* Improve x-axis formatting */
    xaxis label="Antidiabetic Drug Class"
          labelattrs=(size=12 weight=bold)  /* X-axis label font size */
          valueattrs=(size=10)              /* X-axis tick label font size */
          discreteorder=data
          fitpolicy=split; /* Wraps long text instead of rotating */

    /* Improve y-axis */
    yaxis label="Percentage of Users (%)"
          labelattrs=(size=12 weight=bold)
          valueattrs=(size=10);

    /* Format data labels: Two decimal places */
    format Users 8.1;

    /* Adjust legend position */
    keylegend / position=topright
                location=inside
                across=1
                title="Group"
                valueattrs=(size=10);
run;





