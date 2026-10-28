# thesis-SAS-code

11/29/2023
overlap_period_final_comb has 131912 unique individual's concomitant use periods with day0, combination, interacting, switching indicator, switching date
analytical_cohort has 131912 unique individual (one person per row). it has enrolid, day0, gender, discontinuation date (overlap end), age.

Order:
1)getting all doac and statin claims 2011 - 2019
2)find common enrolid and create common_stain and common_doac
3)add drug name to common_stain and common_doac
4)add end date for each drug dispensing
5)delete those with daysupply = 0
6)find overlap periods
7)create unique_enrolid_day0, this is a first list of unique enrolid with corresponding day0, should have 147852 enrolid
8)determine which drug started first (taken before day0), stored in unique_enrolid_day0_4
9)exclude multiple statin/doac on index date
10)get all enrollment with unique_enrolid_day0
11)get dobyr and calculate age, exclude those <18
12)exclude those without continuous enrollment 12 months prior to index date
13)...
