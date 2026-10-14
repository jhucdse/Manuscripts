*******************************************************************************;
* Program name      :	seer_read-in
* Author            :	Jamie Heyward
* Date created      :	2023 May 03
* Study             : 	SEER Medicare Analysis of ICI Risk-Benefit Tradeoffs
* Purpose           :	Read in the SEER Medicare datafiles into SAS 
* Inputs            :	
* Program completed : 	
* Updated by        : 
*********************************************************************************;

/* Create a library on the S-drive to store the data; must be on S-drive due to storage considerations */ 

LIBNAME seer 'S:\JamieHeyward\Dissertation Aim 2 SEER Medicare Cohort Study\SEERMed_IRAE\SEER Medicare irAE 2013-2019';


/* CCFlag27 File */

filename CCflag27 'S:\JamieHeyward\Dissertation Aim 2 SEER Medicare Cohort Study\SEERMed_IRAE\SEER Medicare irAE 2013-2019\mbsf.cc.summary.*.txt';                   /* reading in an un-zipped file */
*filename CCflag27 pipe 'gunzip -c /directory/mbsf.cc.summary.2019.txt.gz'; /* reading in a zipped file */
*filename CCflag27 pipe 'gunzip -c S:\JamieHeyward\SEERMed_IRAE\SEER Medicare irAE 2013-2019\mbsf.cc.summary.*.txt.gz';  /* using wildcard to match multiple files */

options nocenter validvarname=upcase;

data seer.CCflag27;
  infile CCflag27 lrecl=292 missover pad;
  input
        @001 patient_id                       $char15. /* Patient ID (for either Cancer or Non-Cancer Patients) */
        @016 BENE_ENROLLMT_REF_YR             4.
        @020 ENRL_SRC                         $char3.
        @023 AMI                              1.
        @024 AMI_MID                          1.
        @025 AMI_EVER                         $char8.  /*  YYMMDD8  */
        @033 ALZH                             1.
        @034 ALZH_MID                         1.
        @035 ALZH_EVER                        $char8.  /*  YYMMDD8  */
        @043 ALZH_DEMEN                       1.
        @044 ALZH_DEMEN_MID                   1.
        @045 ALZH_DEMEN_EVER                  $char8.  /*  YYMMDD8  */
        @053 ATRIAL_FIB                       1.
        @054 ATRIAL_FIB_MID                   1.
        @055 ATRIAL_FIB_EVER                  $char8.  /*  YYMMDD8  */
        @063 CATARACT                         1.
        @064 CATARACT_MID                     1.
        @065 CATARACT_EVER                    $char8.  /*  YYMMDD8  */
        @073 CHRONICKIDNEY                    1.
        @074 CHRONICKIDNEY_MID                1.
        @075 CHRONICKIDNEY_EVER               $char8.  /*  YYMMDD8  */
        @083 COPD                             1.
        @084 COPD_MID                         1.
        @085 COPD_EVER                        $char8.  /*  YYMMDD8  */
        @093 CHF                              1.
        @094 CHF_MID                          1.
        @095 CHF_EVER                         $char8.  /*  YYMMDD8  */
        @103 DIABETES                         1.
        @104 DIABETES_MID                     1.
        @105 DIABETES_EVER                    $char8.  /*  YYMMDD8  */
        @113 GLAUCOMA                         1.
        @114 GLAUCOMA_MID                     1.
        @115 GLAUCOMA_EVER                    $char8.  /*  YYMMDD8  */
        @123 HIP_FRACTURE                     1.
        @124 HIP_FRACTURE_MID                 1.
        @125 HIP_FRACTURE_EVER                $char8.  /*  YYMMDD8  */
        @133 ISCHEMICHEART                    1.
        @134 ISCHEMICHEART_MID                1.
        @135 ISCHEMICHEART_EVER               $char8.  /*  YYMMDD8  */
        @143 DEPRESSION                       1.
        @144 DEPRESSION_MID                   1.
        @145 DEPRESSION_EVER                  $char8.  /*  YYMMDD8  */
        @153 OSTEOPOROSIS                     1.
        @154 OSTEOPOROSIS_MID                 1.
        @155 OSTEOPOROSIS_EVER                $char8.  /*  YYMMDD8  */
        @163 RA_OA                            1.
        @164 RA_OA_MID                        1.
        @165 RA_OA_EVER                       $char8.  /*  YYMMDD8  */
        @173 STROKE_TIA                       1.
        @174 STROKE_TIA_MID                   1.
        @175 STROKE_TIA_EVER                  $char8.  /*  YYMMDD8  */
        @183 CANCER_BREAST                    1.
        @184 CANCER_BREAST_MID                1.
        @185 CANCER_BREAST_EVER               $char8.  /*  YYMMDD8  */
        @193 CANCER_COLORECTAL                1.
        @194 CANCER_COLORECTAL_MID            1.
        @195 CANCER_COLORECTAL_EVER           $char8.  /*  YYMMDD8  */
        @203 CANCER_PROSTATE                  1.
        @204 CANCER_PROSTATE_MID              1.
        @205 CANCER_PROSTATE_EVER             $char8.  /*  YYMMDD8  */
        @213 CANCER_LUNG                      1.
        @214 CANCER_LUNG_MID                  1.
        @215 CANCER_LUNG_EVER                 $char8.  /*  YYMMDD8  */
        @223 CANCER_ENDOMETRIAL               1.
        @224 CANCER_ENDOMETRIAL_MID           1.
        @225 CANCER_ENDOMETRIAL_EVER          $char8.  /*  YYMMDD8  */
        @233 ANEMIA                           1.
        @234 ANEMIA_MID                       1.
        @235 ANEMIA_EVER                      $char8.  /*  YYMMDD8  */
        @243 ASTHMA                           1.
        @244 ASTHMA_MID                       1.
        @245 ASTHMA_EVER                      $char8.  /*  YYMMDD8  */
        @253 HYPERL                           1.
        @254 HYPERL_MID                       1.
        @255 HYPERL_EVER                      $char8.  /*  YYMMDD8  */
        @263 HYPERP                           1.
        @264 HYPERP_MID                       1.
        @265 HYPERP_EVER                      $char8.  /*  YYMMDD8  */
        @273 HYPERT                           1.
        @274 HYPERT_MID                       1.
        @275 HYPERT_EVER                      $char8.  /*  YYMMDD8  */
        @283 HYPOTH                           1.
        @284 HYPOTH_MID                       1.
        @285 HYPOTH_EVER                      $char8.  /*  YYMMDD8  */
    ;

  label
        BENE_ENROLLMT_REF_YR             = "Beneficiary Enrollment Reference Year"
        ENRL_SRC                         = "Enrollment Source"
        AMI                              = "Acute Myocardial Infarction End-of-Year Flag"
        AMI_MID                          = "Acute Myocardial Infarction Mid-Year Flag"
        AMI_EVER                         = "First Occurrence of Acute Myocardial Infarction"
        ALZH                             = "Alzheimer's Disease End-of-Year Flag"
        ALZH_MID                         = "Alzheimer's Disease Mid-Year Flag"
        ALZH_EVER                        = "First Occurrence of Alzheimer's Disease"
        ALZH_DEMEN                       = "Alzheimer's Disease and Rltd Disorders or Senile Dementia EOY Flag"
        ALZH_DEMEN_MID                   = "Alzheimer's Disease and Rltd Disorders or Senile Dementia Mid-Year Flag"
        ALZH_DEMEN_EVER                  = "1st Occrrnce of Alzheimer's Dsease and Rltd Disorders or Senile Dementia"
        ATRIAL_FIB                       = "Atrial Fibrillation End-of-Year Flag"
        ATRIAL_FIB_MID                   = "Atrial Fibrillation Mid-Year Flag"
        ATRIAL_FIB_EVER                  = "First Occurrence of Atrial Fibrillation"
        CATARACT                         = "Cataract End-of-Year Flag"
        CATARACT_MID                     = "Cataract Mid-Year Flag"
        CATARACT_EVER                    = "First Occurrence of Cataract"
        CHRONICKIDNEY                    = "Chronic Kidney Disease End-of-Year Flag"
        CHRONICKIDNEY_MID                = "Chronic Kidney Disease Mid-Year Flag"
        CHRONICKIDNEY_EVER               = "First Occurrence of Chronic Kidney Disease"
        COPD                             = "Chronic Obstructive Pulmonary Disease End-of-Year Flag"
        COPD_MID                         = "Chronic Obstructive Pulmonary Disease Mid-Year Flag"
        COPD_EVER                        = "First Occurrence of Chronic Obstructive Pulmonary Disease"
        CHF                              = "Heart Failure End-of-Year Flag"
        CHF_MID                          = "Heart Failure Mid-Year Flag"
        CHF_EVER                         = "First Occurrence of Heart Failure"
        DIABETES                         = "Diabetes End-of-Year Flag"
        DIABETES_MID                     = "Diabetes Mid-Year Flag"
        DIABETES_EVER                    = "First Occurrence of Diabetes"
        GLAUCOMA                         = "Glaucoma End-of-Year Flag"
        GLAUCOMA_MID                     = "Glaucoma Mid-Year Flag"
        GLAUCOMA_EVER                    = "First Occurrence of Glaucoma"
        HIP_FRACTURE                     = "Hip/Pelvic Fracture End-of-Year Flag"
        HIP_FRACTURE_MID                 = "Hip/Pelvic Fracture Mid-Year Flag"
        HIP_FRACTURE_EVER                = "First Occurrence of Hip/Pelvic Fracture"
        ISCHEMICHEART                    = "Ischemic Heart Disease End-of-Year Flag"
        ISCHEMICHEART_MID                = "Ischemic Heart Disease Mid-Year Flag"
        ISCHEMICHEART_EVER               = "First Occurrence of Ischemic Heart Disease"
        DEPRESSION                       = "Depression End-of-Year Flag"
        DEPRESSION_MID                   = "Depression Mid-Year Flag"
        DEPRESSION_EVER                  = "First Occurrence of Depression"
        OSTEOPOROSIS                     = "Osteoporosis End-of-Year Flag"
        OSTEOPOROSIS_MID                 = "Osteoporosis Mid-Year Flag"
        OSTEOPOROSIS_EVER                = "First Occurrence of Osteoporosis"
        RA_OA                            = "Rheumatoid Arthritis / Osteoarthritis End-of-Year Flag"
        RA_OA_MID                        = "Rheumatoid Arthritis / Osteoarthritis Mid-Year Flag"
        RA_OA_EVER                       = "First Occurrence of Rheumatoid Arthritis / Osteoarthritis"
        STROKE_TIA                       = "Stroke / Transient Ischemic Attack End-of-Year Flag"
        STROKE_TIA_MID                   = "Stroke / Transient Ischemic Attack Mid-Year Flag"
        STROKE_TIA_EVER                  = "First Occurrence of Stroke / Transient Ischemic Attack"
        CANCER_BREAST                    = "Breast Cancer End-of-Year Flag"
        CANCER_BREAST_MID                = "Breast Cancer Mid-Year Flag"
        CANCER_BREAST_EVER               = "First Occurrence of Breast Cancer"
        CANCER_COLORECTAL                = "Colorectal Cancer End-of-Year Flag"
        CANCER_COLORECTAL_MID            = "Colorectal Cancer Mid-Year Flag"
        CANCER_COLORECTAL_EVER           = "First Occurrence of Colorectal Cancer"
        CANCER_PROSTATE                  = "Prostate Cancer End-of-Year Flag"
        CANCER_PROSTATE_MID              = "Prostate Cancer Mid-Year Flag"
        CANCER_PROSTATE_EVER             = "First Occurrence of Prostate Cancer"
        CANCER_LUNG                      = "Lung Cancer End-of-Year Flag"
        CANCER_LUNG_MID                  = "Lung Cancer Mid-Year Flag"
        CANCER_LUNG_EVER                 = "First Occurrence of Lung Cancer"
        CANCER_ENDOMETRIAL               = "Endometrial Cancer End-of-Year Flag"
        CANCER_ENDOMETRIAL_MID           = "Endometrial Cancer Mid-Year Flag"
        CANCER_ENDOMETRIAL_EVER          = "First Occurrence of Endometrial Cancer"
        ANEMIA                           = "Anemia End Year Flag"
        ANEMIA_MID                       = "Anemia Mid Year Flag"
        ANEMIA_EVER                      = "Anemia First Ever Occurrence Date"
        ASTHMA                           = "Asthma End Year Flag"
        ASTHMA_MID                       = "Asthma Mid Year Flag"
        ASTHMA_EVER                      = "Asthma First Ever Occurrence Date"
        HYPERL                           = "Hyperlipidemia End Year Flag"
        HYPERL_MID                       = "Hyperlipidemia Mid Year Flag"
        HYPERL_EVER                      = "Hyperlipidemia First Ever Occurrence Date"
        HYPERP                           = "Benign Prostatic Hyperplasia End Year Flag"
        HYPERP_MID                       = "Benign Prostatic Hyperplasia Mid Year Flag"
        HYPERP_EVER                      = "Benign Prostatic Hyperplasia First Ever Occurrence Date"
        HYPERT                           = "Hypertension End Year Flag"
        HYPERT_MID                       = "Hypertension Mid Year Flag"
        HYPERT_EVER                      = "Hypertension First Ever Occurrence Date"
        HYPOTH                           = "Acquired Hypothyroidism End Year Flag"
        HYPOTH_MID                       = "Acquired Hypothyroidism Mid Year Flag"
        HYPOTH_EVER                      = "Acquired Hypothyroidism First Ever Occurrence Date"
    ;

run;

proc contents data=seer.CCflag27 position;
run;




/* MBSF.AB datafile */


filename mbsf_ab 'S:\JamieHeyward\Dissertation Aim 2 SEER Medicare Cohort Study\SEERMed_IRAE\SEER Medicare irAE 2013-2019\mbsf.ab.summary.*.txt';                   /* reading in an un-zipped file */
*filename mbsf_ab pipe 'gunzip -c /directory/mbsf.ab.summary.2005.txt.gz'; /* reading in a zipped file */
*filename mbsf_ab pipe 'gunzip -c /directory/mbsf.ab.summary.*.txt.gz';  /* using wildcard to match multiple files */

options nocenter validvarname=upcase;

data seer.mbsf_ab;
  infile mbsf_ab lrecl=114 missover pad;
  input
        @00001 patient_id                $char15. /* Patient ID (for either Cancer or Non-Cancer Patients) */
        @00016 BENE_ENROLLMT_REF_YR             4.
        @00020 ENRL_SRC                         $3.
        @00023 FIVE_PERCENT_FLAG                $1.
/* SUMSTAT variable is used for the Non cancer patients to indicate if patient ever had cancer*/
/* SUMSTAT = 1 (No known cancer) or 2 (has cancer)*/
/*      @00023 SUMSTAT                          $1. */ /*This variable takes the place of the five percent flag*/
        @00024 ENHANCED_FIVE_PERCENT_FLAG       $1.
        @00025 COVSTART                         $char8.  /*  YYMMDD8  */
        @00033 CRNT_BIC_CD                      $2.
        @00035 STATE_CODE                       $2.
        @00037 BENE_COUNTY_CD                   $3.
        @00040 BENE_ZIP_CD                      $9.      /*  Encrypted  */
        @00049 BENE_AGE_AT_END_REF_YR           3.
        @00052 BENE_BIRTH_DT                    $char8.  /*  YYMMDD8  */
        @00060 BENE_VALID_DEATH_DT_SW           $1.
        @00061 BENE_DEATH_DT                    $char8.  /*  YYMMDD8  */
        @00069 BENE_SEX_IDENT_CD                $1.
        @00070 BENE_RACE_CD                     $1.
        @00071 RTI_RACE_CD                      $1.
        @00072 BENE_ENTLMT_RSN_ORIG             $1.
        @00073 BENE_ENTLMT_RSN_CURR             $1.
        @00074 BENE_ESRD_IND                    $1.
        @00075 BENE_MDCR_STATUS_CD              $2.
        @00077 BENE_PTA_TRMNTN_CD               $1.
        @00078 BENE_PTB_TRMNTN_CD               $1.
        @00079 BENE_HI_CVRAGE_TOT_MONS          3.
        @00082 BENE_SMI_CVRAGE_TOT_MONS         3.
        @00085 BENE_STATE_BUYIN_TOT_MONS        3.
        @00088 BENE_HMO_CVRAGE_TOT_MONS         3.
        @00091 BENE_MDCR_ENTLMT_BUYIN_IND_01    $1.
        @00092 BENE_MDCR_ENTLMT_BUYIN_IND_02    $1.
        @00093 BENE_MDCR_ENTLMT_BUYIN_IND_03    $1.
        @00094 BENE_MDCR_ENTLMT_BUYIN_IND_04    $1.
        @00095 BENE_MDCR_ENTLMT_BUYIN_IND_05    $1.
        @00096 BENE_MDCR_ENTLMT_BUYIN_IND_06    $1.
        @00097 BENE_MDCR_ENTLMT_BUYIN_IND_07    $1.
        @00098 BENE_MDCR_ENTLMT_BUYIN_IND_08    $1.
        @00099 BENE_MDCR_ENTLMT_BUYIN_IND_09    $1.
        @00100 BENE_MDCR_ENTLMT_BUYIN_IND_10    $1.
        @00101 BENE_MDCR_ENTLMT_BUYIN_IND_11    $1.
        @00102 BENE_MDCR_ENTLMT_BUYIN_IND_12    $1.
        @00103 BENE_HMO_IND_01                  $1.
        @00104 BENE_HMO_IND_02                  $1.
        @00105 BENE_HMO_IND_03                  $1.
        @00106 BENE_HMO_IND_04                  $1.
        @00107 BENE_HMO_IND_05                  $1.
        @00108 BENE_HMO_IND_06                  $1.
        @00109 BENE_HMO_IND_07                  $1.
        @00110 BENE_HMO_IND_08                  $1.
        @00111 BENE_HMO_IND_09                  $1.
        @00112 BENE_HMO_IND_10                  $1.
        @00113 BENE_HMO_IND_11                  $1.
        @00114 BENE_HMO_IND_12                  $1.
    ;

  label
        PATIENT_ID                       = "Patient ID"
        BENE_ENROLLMT_REF_YR             = "Beneficiary Enrollment Reference Year"
        ENRL_SRC                         = "Enrollment Source"
        FIVE_PERCENT_FLAG                = "Strict 5% Flag"
        ENHANCED_FIVE_PERCENT_FLAG       = "Enhanced 5% Flag"
        COVSTART                         = "Medicare Coverage Start Date"
        CRNT_BIC_CD                      = "Beneficiary Identification Code"
        STATE_CODE                       = "State Code (SSA coding)"
        BENE_COUNTY_CD                   = "County Code (SSA coding)"
        BENE_ZIP_CD                      = "Zip Code of Residence"
        BENE_AGE_AT_END_REF_YR           = "Age at End of Reference Year"
        BENE_BIRTH_DT                    = "Date of Birth"
        BENE_VALID_DEATH_DT_SW           = "Valid Date of Death Switch"
        BENE_DEATH_DT                    = "Date of Death"
        BENE_SEX_IDENT_CD                = "Sex"
        BENE_RACE_CD                     = "Beneficiary Race Code"
        RTI_RACE_CD                      = "Research Triangle Institute (RTI) Race Code"
        BENE_ENTLMT_RSN_ORIG             = "Original Reason for Entitlement Code"
        BENE_ENTLMT_RSN_CURR             = "Current Reason for Entitlement Code"
        BENE_ESRD_IND                    = "ESRD Indicator"
        BENE_MDCR_STATUS_CD              = "Medicare Status Code"
        BENE_PTA_TRMNTN_CD               = "Part A Termination Code"
        BENE_PTB_TRMNTN_CD               = "Part B Termination Code"
        BENE_HI_CVRAGE_TOT_MONS          = "HI Coverage Count"
        BENE_SMI_CVRAGE_TOT_MONS         = "SMI Coverage Count"
        BENE_STATE_BUYIN_TOT_MONS        = "State Buy-In Coverage Count"
        BENE_HMO_CVRAGE_TOT_MONS         = "HMO Coverage Count"
        BENE_MDCR_ENTLMT_BUYIN_IND_01    = "Medicare Entitlement/Buy-In Indicator I"
        BENE_MDCR_ENTLMT_BUYIN_IND_02    = "Medicare Entitlement/Buy-In Indicator II"
        BENE_MDCR_ENTLMT_BUYIN_IND_03    = "Medicare Entitlement/Buy-In Indicator III"
        BENE_MDCR_ENTLMT_BUYIN_IND_04    = "Medicare Entitlement/Buy-In Indicator IV"
        BENE_MDCR_ENTLMT_BUYIN_IND_05    = "Medicare Entitlement/Buy-In Indicator V"
        BENE_MDCR_ENTLMT_BUYIN_IND_06    = "Medicare Entitlement/Buy-In Indicator VI"
        BENE_MDCR_ENTLMT_BUYIN_IND_07    = "Medicare Entitlement/Buy-In Indicator VII"
        BENE_MDCR_ENTLMT_BUYIN_IND_08    = "Medicare Entitlement/Buy-In Indicator VIII"
        BENE_MDCR_ENTLMT_BUYIN_IND_09    = "Medicare Entitlement/Buy-In Indicator IX"
        BENE_MDCR_ENTLMT_BUYIN_IND_10    = "Medicare Entitlement/Buy-In Indicator X"
        BENE_MDCR_ENTLMT_BUYIN_IND_11    = "Medicare Entitlement/Buy-In Indicator XI"
        BENE_MDCR_ENTLMT_BUYIN_IND_12    = "Medicare Entitlement/Buy-In Indicator XII"
        BENE_HMO_IND_01                  = "HMO Indicator I"
        BENE_HMO_IND_02                  = "HMO Indicator II"
        BENE_HMO_IND_03                  = "HMO Indicator III"
        BENE_HMO_IND_04                  = "HMO Indicator IV"
        BENE_HMO_IND_05                  = "HMO Indicator V"
        BENE_HMO_IND_06                  = "HMO Indicator VI"
        BENE_HMO_IND_07                  = "HMO Indicator VII"
        BENE_HMO_IND_08                  = "HMO Indicator VIII"
        BENE_HMO_IND_09                  = "HMO Indicator IX"
        BENE_HMO_IND_10                  = "HMO Indicator X"
        BENE_HMO_IND_11                  = "HMO Indicator XI"
        BENE_HMO_IND_12                  = "HMO Indicator XII"
    ;

run;

proc contents data= seer.mbsf_ab position;
run;


/* MBSF.ABCD File */


filename mbsfabcd 'S:\JamieHeyward\Dissertation Aim 2 SEER Medicare Cohort Study\SEERMed_IRAE\SEER Medicare irAE 2013-2019\mbsf.abcd.summary.*.txt';                   /* reading in an un-zipped file */
*filename mbsfabcd pipe 'gunzip -c /directory/mbsf.abcd.summary.2019.txt.gz'; /* reading in a zipped file */
*filename mbsfabcd pipe 'gunzip -c /directory/mbsf.abcd.summary.*.txt.gz';  /* using wildcard to match multiple files */

options nocenter validvarname=upcase;

data seer.mbsfabcd;
  infile mbsfabcd lrecl=526 missover pad;
  input
        @00001 patient_id                $char15. /* Patient ID (for either Cancer or Non-Cancer Patients) */
        @00016 BENE_ENROLLMT_REF_YR             4.
        @00020 ENRL_SRC                         $3.
        @00023 SAMPLE_GROUP                     $2.
/* SUMSTAT variable is used for the Non cancer patients to indicate if patient ever had cancer*/
/* SUMSTAT = 01 (No known cancer) or 02 (has cancer)*/
/*      @00023 SUMSTAT                          $2. */ /*This variable takes the place of the sample group*/
        @00025 ENHANCED_FIVE_PERCENT_FLAG       $1.
        @00026 CRNT_BIC_CD                      $2.
        @00028 STATE_CODE                       $2.
        @00030 COUNTY_CD                        $3.
        @00033 ZIP_CD                           $5.      /*  Encrypted  */
        @00038 STATE_CNTY_FIPS_CD_01            $5.
        @00043 STATE_CNTY_FIPS_CD_02            $5.
        @00048 STATE_CNTY_FIPS_CD_03            $5.
        @00053 STATE_CNTY_FIPS_CD_04            $5.
        @00058 STATE_CNTY_FIPS_CD_05            $5.
        @00063 STATE_CNTY_FIPS_CD_06            $5.
        @00068 STATE_CNTY_FIPS_CD_07            $5.
        @00073 STATE_CNTY_FIPS_CD_08            $5.
        @00078 STATE_CNTY_FIPS_CD_09            $5.
        @00083 STATE_CNTY_FIPS_CD_10            $5.
        @00088 STATE_CNTY_FIPS_CD_11            $5.
        @00093 STATE_CNTY_FIPS_CD_12            $5.
        @00098 AGE_AT_END_REF_YR                3.
        @00101 BENE_BIRTH_DT                    $char8.  /*  YYMMDD8  */
        @00109 VALID_DEATH_DT_SW                $1.
        @00110 BENE_DEATH_DT                    $char8.  /*  YYMMDD8  */
        @00118 SEX_IDENT_CD                     $1.
        @00119 BENE_RACE_CD                     $1.
        @00120 RTI_RACE_CD                      $1.
        @00121 COVSTART                         $char8.  /*  YYMMDD8  */
        @00129 ENTLMT_RSN_ORIG                  $1.
        @00130 ENTLMT_RSN_CURR                  $1.
        @00131 ESRD_IND                         $1.
        @00132 MDCR_STATUS_CODE_01              $2.
        @00134 MDCR_STATUS_CODE_02              $2.
        @00136 MDCR_STATUS_CODE_03              $2.
        @00138 MDCR_STATUS_CODE_04              $2.
        @00140 MDCR_STATUS_CODE_05              $2.
        @00142 MDCR_STATUS_CODE_06              $2.
        @00144 MDCR_STATUS_CODE_07              $2.
        @00146 MDCR_STATUS_CODE_08              $2.
        @00148 MDCR_STATUS_CODE_09              $2.
        @00150 MDCR_STATUS_CODE_10              $2.
        @00152 MDCR_STATUS_CODE_11              $2.
        @00154 MDCR_STATUS_CODE_12              $2.
        @00156 BENE_PTA_TRMNTN_CD               $1.
        @00157 BENE_PTB_TRMNTN_CD               $1.
        @00158 BENE_HI_CVRAGE_TOT_MONS          3.
        @00161 BENE_SMI_CVRAGE_TOT_MONS         3.
        @00164 BENE_STATE_BUYIN_TOT_MONS        3.
        @00167 BENE_HMO_CVRAGE_TOT_MONS         3.
        @00170 PTD_PLAN_CVRG_MONS               3.
        @00173 RDS_CVRG_MONS                    3.
        @00176 DUAL_ELGBL_MONS                  3.
        @00179 MDCR_ENTLMT_BUYIN_IND_01         $1.
        @00180 MDCR_ENTLMT_BUYIN_IND_02         $1.
        @00181 MDCR_ENTLMT_BUYIN_IND_03         $1.
        @00182 MDCR_ENTLMT_BUYIN_IND_04         $1.
        @00183 MDCR_ENTLMT_BUYIN_IND_05         $1.
        @00184 MDCR_ENTLMT_BUYIN_IND_06         $1.
        @00185 MDCR_ENTLMT_BUYIN_IND_07         $1.
        @00186 MDCR_ENTLMT_BUYIN_IND_08         $1.
        @00187 MDCR_ENTLMT_BUYIN_IND_09         $1.
        @00188 MDCR_ENTLMT_BUYIN_IND_10         $1.
        @00189 MDCR_ENTLMT_BUYIN_IND_11         $1.
        @00190 MDCR_ENTLMT_BUYIN_IND_12         $1.
        @00191 HMO_IND_01                       $1.
        @00192 HMO_IND_02                       $1.
        @00193 HMO_IND_03                       $1.
        @00194 HMO_IND_04                       $1.
        @00195 HMO_IND_05                       $1.
        @00196 HMO_IND_06                       $1.
        @00197 HMO_IND_07                       $1.
        @00198 HMO_IND_08                       $1.
        @00199 HMO_IND_09                       $1.
        @00200 HMO_IND_10                       $1.
        @00201 HMO_IND_11                       $1.
        @00202 HMO_IND_12                       $1.
        @00203 PTC_CNTRCT_ID_01                 $5.
        @00208 PTC_CNTRCT_ID_02                 $5.
        @00213 PTC_CNTRCT_ID_03                 $5.
        @00218 PTC_CNTRCT_ID_04                 $5.
        @00223 PTC_CNTRCT_ID_05                 $5.
        @00228 PTC_CNTRCT_ID_06                 $5.
        @00233 PTC_CNTRCT_ID_07                 $5.
        @00238 PTC_CNTRCT_ID_08                 $5.
        @00243 PTC_CNTRCT_ID_09                 $5.
        @00248 PTC_CNTRCT_ID_10                 $5.
        @00253 PTC_CNTRCT_ID_11                 $5.
        @00258 PTC_CNTRCT_ID_12                 $5.
        @00263 PTC_PBP_ID_01                    $3.
        @00266 PTC_PBP_ID_02                    $3.
        @00269 PTC_PBP_ID_03                    $3.
        @00272 PTC_PBP_ID_04                    $3.
        @00275 PTC_PBP_ID_05                    $3.
        @00278 PTC_PBP_ID_06                    $3.
        @00281 PTC_PBP_ID_07                    $3.
        @00284 PTC_PBP_ID_08                    $3.
        @00287 PTC_PBP_ID_09                    $3.
        @00290 PTC_PBP_ID_10                    $3.
        @00293 PTC_PBP_ID_11                    $3.
        @00296 PTC_PBP_ID_12                    $3.
        @00299 PTC_PLAN_TYPE_CD_01              $3.
        @00302 PTC_PLAN_TYPE_CD_02              $3.
        @00305 PTC_PLAN_TYPE_CD_03              $3.
        @00308 PTC_PLAN_TYPE_CD_04              $3.
        @00311 PTC_PLAN_TYPE_CD_05              $3.
        @00314 PTC_PLAN_TYPE_CD_06              $3.
        @00317 PTC_PLAN_TYPE_CD_07              $3.
        @00320 PTC_PLAN_TYPE_CD_08              $3.
        @00323 PTC_PLAN_TYPE_CD_09              $3.
        @00326 PTC_PLAN_TYPE_CD_10              $3.
        @00329 PTC_PLAN_TYPE_CD_11              $3.
        @00332 PTC_PLAN_TYPE_CD_12              $3.
        @00335 PTD_CNTRCT_ID_01                 $5.
        @00340 PTD_CNTRCT_ID_02                 $5.
        @00345 PTD_CNTRCT_ID_03                 $5.
        @00350 PTD_CNTRCT_ID_04                 $5.
        @00355 PTD_CNTRCT_ID_05                 $5.
        @00360 PTD_CNTRCT_ID_06                 $5.
        @00365 PTD_CNTRCT_ID_07                 $5.
        @00370 PTD_CNTRCT_ID_08                 $5.
        @00375 PTD_CNTRCT_ID_09                 $5.
        @00380 PTD_CNTRCT_ID_10                 $5.
        @00385 PTD_CNTRCT_ID_11                 $5.
        @00390 PTD_CNTRCT_ID_12                 $5.
        @00395 PTD_PBP_ID_01                    $3.
        @00398 PTD_PBP_ID_02                    $3.
        @00401 PTD_PBP_ID_03                    $3.
        @00404 PTD_PBP_ID_04                    $3.
        @00407 PTD_PBP_ID_05                    $3.
        @00410 PTD_PBP_ID_06                    $3.
        @00413 PTD_PBP_ID_07                    $3.
        @00416 PTD_PBP_ID_08                    $3.
        @00419 PTD_PBP_ID_09                    $3.
        @00422 PTD_PBP_ID_10                    $3.
        @00425 PTD_PBP_ID_11                    $3.
        @00428 PTD_PBP_ID_12                    $3.
        @00431 PTD_SGMT_ID_01                   $3.
        @00434 PTD_SGMT_ID_02                   $3.
        @00437 PTD_SGMT_ID_03                   $3.
        @00440 PTD_SGMT_ID_04                   $3.
        @00443 PTD_SGMT_ID_05                   $3.
        @00446 PTD_SGMT_ID_06                   $3.
        @00449 PTD_SGMT_ID_07                   $3.
        @00452 PTD_SGMT_ID_08                   $3.
        @00455 PTD_SGMT_ID_09                   $3.
        @00458 PTD_SGMT_ID_10                   $3.
        @00461 PTD_SGMT_ID_11                   $3.
        @00464 PTD_SGMT_ID_12                   $3.
        @00467 RDS_IND_01                       $1.
        @00468 RDS_IND_02                       $1.
        @00469 RDS_IND_03                       $1.
        @00470 RDS_IND_04                       $1.
        @00471 RDS_IND_05                       $1.
        @00472 RDS_IND_06                       $1.
        @00473 RDS_IND_07                       $1.
        @00474 RDS_IND_08                       $1.
        @00475 RDS_IND_09                       $1.
        @00476 RDS_IND_10                       $1.
        @00477 RDS_IND_11                       $1.
        @00478 RDS_IND_12                       $1.
        @00479 DUAL_STUS_CD_01                  $2.
        @00481 DUAL_STUS_CD_02                  $2.
        @00483 DUAL_STUS_CD_03                  $2.
        @00485 DUAL_STUS_CD_04                  $2.
        @00487 DUAL_STUS_CD_05                  $2.
        @00489 DUAL_STUS_CD_06                  $2.
        @00491 DUAL_STUS_CD_07                  $2.
        @00493 DUAL_STUS_CD_08                  $2.
        @00495 DUAL_STUS_CD_09                  $2.
        @00497 DUAL_STUS_CD_10                  $2.
        @00499 DUAL_STUS_CD_11                  $2.
        @00501 DUAL_STUS_CD_12                  $2.
        @00503 CST_SHR_GRP_CD_01                $2.
        @00505 CST_SHR_GRP_CD_02                $2.
        @00507 CST_SHR_GRP_CD_03                $2.
        @00509 CST_SHR_GRP_CD_04                $2.
        @00511 CST_SHR_GRP_CD_05                $2.
        @00513 CST_SHR_GRP_CD_06                $2.
        @00515 CST_SHR_GRP_CD_07                $2.
        @00517 CST_SHR_GRP_CD_08                $2.
        @00519 CST_SHR_GRP_CD_09                $2.
        @00521 CST_SHR_GRP_CD_10                $2.
        @00523 CST_SHR_GRP_CD_11                $2.
        @00525 CST_SHR_GRP_CD_12                $2.
    ;

  label
        PATIENT_ID                       = "Patient ID"
        BENE_ENROLLMT_REF_YR             = "Beneficiary Enrollment Reference Year"
        ENRL_SRC                         = "Enrollment Source"
        SAMPLE_GROUP                     = "Medicare 1, 5, or 20% Strict Sample Group Indicator"
        ENHANCED_FIVE_PERCENT_FLAG       = "Medicare Enhanced 5% Sample Indicator"
        CRNT_BIC_CD                      = "Current Beneficiary Identification Code"
        STATE_CODE                       = "SSA State Code"
        COUNTY_CD                        = "SSA County Code"
        ZIP_CD                           = "5-digit ZIP Code"
        STATE_CNTY_FIPS_CD_01            = "FIPS State-County Code: January"
        STATE_CNTY_FIPS_CD_02            = "FIPS State-County Code: February"
        STATE_CNTY_FIPS_CD_03            = "FIPS State-County Code: March"
        STATE_CNTY_FIPS_CD_04            = "FIPS State-County Code: April"
        STATE_CNTY_FIPS_CD_05            = "FIPS State-County Code: May"
        STATE_CNTY_FIPS_CD_06            = "FIPS State-County Code: June"
        STATE_CNTY_FIPS_CD_07            = "FIPS State-County Code: July"
        STATE_CNTY_FIPS_CD_08            = "FIPS State-County Code: August"
        STATE_CNTY_FIPS_CD_09            = "FIPS State-County Code: September"
        STATE_CNTY_FIPS_CD_10            = "FIPS State-County Code: October"
        STATE_CNTY_FIPS_CD_11            = "FIPS State-County Code: November"
        STATE_CNTY_FIPS_CD_12            = "FIPS State-County Code: December"
        AGE_AT_END_REF_YR                = "Age at the End of the Reference Year"
        BENE_BIRTH_DT                    = "Beneficiary Date of Birth"
        VALID_DEATH_DT_SW                = "Valid Date of Death Switch"
        BENE_DEATH_DT                    = "Beneficiary Date of Death"
        SEX_IDENT_CD                     = "Sex"
        BENE_RACE_CD                     = "Beneficiary Race Code"
        RTI_RACE_CD                      = "Research Triangle Institute (RTI) Race Code"
        COVSTART                         = "Medicare Coverage Start Date"
        ENTLMT_RSN_ORIG                  = "Original Reason for Entitlement Code"
        ENTLMT_RSN_CURR                  = "Current Reason for Entitlement Code"
        ESRD_IND                         = "End-Stage Renal Disease (ESRD) Indicator"
        MDCR_STATUS_CODE_01              = "Medicare Status Code: January"
        MDCR_STATUS_CODE_02              = "Medicare Status Code: February"
        MDCR_STATUS_CODE_03              = "Medicare Status Code: March"
        MDCR_STATUS_CODE_04              = "Medicare Status Code: April"
        MDCR_STATUS_CODE_05              = "Medicare Status Code: May"
        MDCR_STATUS_CODE_06              = "Medicare Status Code: June"
        MDCR_STATUS_CODE_07              = "Medicare Status Code: July"
        MDCR_STATUS_CODE_08              = "Medicare Status Code: August"
        MDCR_STATUS_CODE_09              = "Medicare Status Code: September"
        MDCR_STATUS_CODE_10              = "Medicare Status Code: October"
        MDCR_STATUS_CODE_11              = "Medicare Status Code: November"
        MDCR_STATUS_CODE_12              = "Medicare Status Code: December"
        BENE_PTA_TRMNTN_CD               = "Part A Termination Code"
        BENE_PTB_TRMNTN_CD               = "Part B Termination Code"
        BENE_HI_CVRAGE_TOT_MONS          = "Hospital Insurance (HI) Coverage Months Count"
        BENE_SMI_CVRAGE_TOT_MONS         = "Supplemental Medical Insurance (SMI) Coverage Months Count"
        BENE_STATE_BUYIN_TOT_MONS        = "State Buy-In (SBI) Coverage Months"
        BENE_HMO_CVRAGE_TOT_MONS         = "Health Maintenance Organization (HMO) Coverage Months"
        PTD_PLAN_CVRG_MONS               = "Part D Contract Plan Coverage Months"
        RDS_CVRG_MONS                    = "Retiree Drug Subsidy (RDS) Coverage Months"
        DUAL_ELGBL_MONS                  = "Medicaid Dual Eligible Months"
        MDCR_ENTLMT_BUYIN_IND_01         = "Medicare Entitlement/ Buy-In Indicator: January"
        MDCR_ENTLMT_BUYIN_IND_02         = "Medicare Entitlement/ Buy-In Indicator: February"
        MDCR_ENTLMT_BUYIN_IND_03         = "Medicare Entitlement/ Buy-In Indicator: March"
        MDCR_ENTLMT_BUYIN_IND_04         = "Medicare Entitlement/ Buy-In Indicator: April"
        MDCR_ENTLMT_BUYIN_IND_05         = "Medicare Entitlement/ Buy-In Indicator: May"
        MDCR_ENTLMT_BUYIN_IND_06         = "Medicare Entitlement/ Buy-In Indicator: June"
        MDCR_ENTLMT_BUYIN_IND_07         = "Medicare Entitlement/ Buy-In Indicator: July"
        MDCR_ENTLMT_BUYIN_IND_08         = "Medicare Entitlement/ Buy-In Indicator: August"
        MDCR_ENTLMT_BUYIN_IND_09         = "Medicare Entitlement/ Buy-In Indicator: September"
        MDCR_ENTLMT_BUYIN_IND_10         = "Medicare Entitlement/ Buy-In Indicator: October"
        MDCR_ENTLMT_BUYIN_IND_11         = "Medicare Entitlement/ Buy-In Indicator: November"
        MDCR_ENTLMT_BUYIN_IND_12         = "Medicare Entitlement/ Buy-In Indicator: December"
        HMO_IND_01                       = "HMO Indicator: January"
        HMO_IND_02                       = "HMO Indicator: February"
        HMO_IND_03                       = "HMO Indicator: March"
        HMO_IND_04                       = "HMO Indicator: April"
        HMO_IND_05                       = "HMO Indicator: May"
        HMO_IND_06                       = "HMO Indicator: June"
        HMO_IND_07                       = "HMO Indicator: July"
        HMO_IND_08                       = "HMO Indicator: August"
        HMO_IND_09                       = "HMO Indicator: September"
        HMO_IND_10                       = "HMO Indicator: October"
        HMO_IND_11                       = "HMO Indicator: November"
        HMO_IND_12                       = "HMO Indicator: December"
        PTC_CNTRCT_ID_01                 = "Part C Contract ID: January"
        PTC_CNTRCT_ID_02                 = "Part C Contract ID: February"
        PTC_CNTRCT_ID_03                 = "Part C Contract ID: March"
        PTC_CNTRCT_ID_04                 = "Part C Contract ID: April"
        PTC_CNTRCT_ID_05                 = "Part C Contract ID: May"
        PTC_CNTRCT_ID_06                 = "Part C Contract ID: June"
        PTC_CNTRCT_ID_07                 = "Part C Contract ID: July"
        PTC_CNTRCT_ID_08                 = "Part C Contract ID: August"
        PTC_CNTRCT_ID_09                 = "Part C Contract ID: September"
        PTC_CNTRCT_ID_10                 = "Part C Contract ID: October"
        PTC_CNTRCT_ID_11                 = "Part C Contract ID: November"
        PTC_CNTRCT_ID_12                 = "Part C Contract ID: December"
        PTC_PBP_ID_01                    = "Part C Plan Benefit Package ID: January"
        PTC_PBP_ID_02                    = "Part C Plan Benefit Package ID: February"
        PTC_PBP_ID_03                    = "Part C Plan Benefit Package ID: March"
        PTC_PBP_ID_04                    = "Part C Plan Benefit Package ID: April"
        PTC_PBP_ID_05                    = "Part C Plan Benefit Package ID: May"
        PTC_PBP_ID_06                    = "Part C Plan Benefit Package ID: June"
        PTC_PBP_ID_07                    = "Part C Plan Benefit Package ID: July"
        PTC_PBP_ID_08                    = "Part C Plan Benefit Package ID: August"
        PTC_PBP_ID_09                    = "Part C Plan Benefit Package ID: September"
        PTC_PBP_ID_10                    = "Part C Plan Benefit Package ID: October"
        PTC_PBP_ID_11                    = "Part C Plan Benefit Package ID: November"
        PTC_PBP_ID_12                    = "Part C Plan Benefit Package ID: December"
        PTC_PLAN_TYPE_CD_01              = "Part C Plan Type Code: January"
        PTC_PLAN_TYPE_CD_02              = "Part C Plan Type Code: February"
        PTC_PLAN_TYPE_CD_03              = "Part C Plan Type Code: March"
        PTC_PLAN_TYPE_CD_04              = "Part C Plan Type Code: April"
        PTC_PLAN_TYPE_CD_05              = "Part C Plan Type Code: May"
        PTC_PLAN_TYPE_CD_06              = "Part C Plan Type Code: June"
        PTC_PLAN_TYPE_CD_07              = "Part C Plan Type Code: July"
        PTC_PLAN_TYPE_CD_08              = "Part C Plan Type Code: August"
        PTC_PLAN_TYPE_CD_09              = "Part C Plan Type Code: September"
        PTC_PLAN_TYPE_CD_10              = "Part C Plan Type Code: October"
        PTC_PLAN_TYPE_CD_11              = "Part C Plan Type Code: November"
        PTC_PLAN_TYPE_CD_12              = "Part C Plan Type Code: December"
        PTD_CNTRCT_ID_01                 = "Part D Contract ID: January"
        PTD_CNTRCT_ID_02                 = "Part D Contract ID: February"
        PTD_CNTRCT_ID_03                 = "Part D Contract ID: March"
        PTD_CNTRCT_ID_04                 = "Part D Contract ID: April"
        PTD_CNTRCT_ID_05                 = "Part D Contract ID: May"
        PTD_CNTRCT_ID_06                 = "Part D Contract ID: June"
        PTD_CNTRCT_ID_07                 = "Part D Contract ID: July"
        PTD_CNTRCT_ID_08                 = "Part D Contract ID: August"
        PTD_CNTRCT_ID_09                 = "Part D Contract ID: September"
        PTD_CNTRCT_ID_10                 = "Part D Contract ID: October"
        PTD_CNTRCT_ID_11                 = "Part D Contract ID: November"
        PTD_CNTRCT_ID_12                 = "Part D Contract ID: December"
        PTD_PBP_ID_01                    = "Part D Plan Benefit Package ID: January"
        PTD_PBP_ID_02                    = "Part D Plan Benefit Package ID: February"
        PTD_PBP_ID_03                    = "Part D Plan Benefit Package ID: March"
        PTD_PBP_ID_04                    = "Part D Plan Benefit Package ID: April"
        PTD_PBP_ID_05                    = "Part D Plan Benefit Package ID: May"
        PTD_PBP_ID_06                    = "Part D Plan Benefit Package ID: June"
        PTD_PBP_ID_07                    = "Part D Plan Benefit Package ID: July"
        PTD_PBP_ID_08                    = "Part D Plan Benefit Package ID: August"
        PTD_PBP_ID_09                    = "Part D Plan Benefit Package ID: September"
        PTD_PBP_ID_10                    = "Part D Plan Benefit Package ID: October"
        PTD_PBP_ID_11                    = "Part D Plan Benefit Package ID: November"
        PTD_PBP_ID_12                    = "Part D Plan Benefit Package ID: December"
        PTD_SGMT_ID_01                   = "Part D Segment ID: January"
        PTD_SGMT_ID_02                   = "Part D Segment ID: February"
        PTD_SGMT_ID_03                   = "Part D Segment ID: March"
        PTD_SGMT_ID_04                   = "Part D Segment ID: April"
        PTD_SGMT_ID_05                   = "Part D Segment ID: May"
        PTD_SGMT_ID_06                   = "Part D Segment ID: June"
        PTD_SGMT_ID_07                   = "Part D Segment ID: July"
        PTD_SGMT_ID_08                   = "Part D Segment ID: August"
        PTD_SGMT_ID_09                   = "Part D Segment ID: September"
        PTD_SGMT_ID_10                   = "Part D Segment ID: October"
        PTD_SGMT_ID_11                   = "Part D Segment ID: November"
        PTD_SGMT_ID_12                   = "Part D Segment ID: December"
        RDS_IND_01                       = "Retiree Drug Subsidy Indicators: January"
        RDS_IND_02                       = "Retiree Drug Subsidy Indicators: February"
        RDS_IND_03                       = "Retiree Drug Subsidy Indicators: March"
        RDS_IND_04                       = "Retiree Drug Subsidy Indicators: April"
        RDS_IND_05                       = "Retiree Drug Subsidy Indicators: May"
        RDS_IND_06                       = "Retiree Drug Subsidy Indicators: June"
        RDS_IND_07                       = "Retiree Drug Subsidy Indicators: July"
        RDS_IND_08                       = "Retiree Drug Subsidy Indicators: August"
        RDS_IND_09                       = "Retiree Drug Subsidy Indicators: September"
        RDS_IND_10                       = "Retiree Drug Subsidy Indicators: October"
        RDS_IND_11                       = "Retiree Drug Subsidy Indicators: November"
        RDS_IND_12                       = "Retiree Drug Subsidy Indicators: December"
        DUAL_STUS_CD_01                  = "State Reported Dual Eligible Status Code: January"
        DUAL_STUS_CD_02                  = "State Reported Dual Eligible Status Code: February"
        DUAL_STUS_CD_03                  = "State Reported Dual Eligible Status Code: March"
        DUAL_STUS_CD_04                  = "State Reported Dual Eligible Status Code: April"
        DUAL_STUS_CD_05                  = "State Reported Dual Eligible Status Code: May"
        DUAL_STUS_CD_06                  = "State Reported Dual Eligible Status Code: June"
        DUAL_STUS_CD_07                  = "State Reported Dual Eligible Status Code: July"
        DUAL_STUS_CD_08                  = "State Reported Dual Eligible Status Code: August"
        DUAL_STUS_CD_09                  = "State Reported Dual Eligible Status Code: September"
        DUAL_STUS_CD_10                  = "State Reported Dual Eligible Status Code: October"
        DUAL_STUS_CD_11                  = "State Reported Dual Eligible Status Code: November"
        DUAL_STUS_CD_12                  = "State Reported Dual Eligible Status Code: December"
        CST_SHR_GRP_CD_01                = "Cost Share Group Code: January"
        CST_SHR_GRP_CD_02                = "Cost Share Group Code: February"
        CST_SHR_GRP_CD_03                = "Cost Share Group Code: March"
        CST_SHR_GRP_CD_04                = "Cost Share Group Code: April"
        CST_SHR_GRP_CD_05                = "Cost Share Group Code: May"
        CST_SHR_GRP_CD_06                = "Cost Share Group Code: June"
        CST_SHR_GRP_CD_07                = "Cost Share Group Code: July"
        CST_SHR_GRP_CD_08                = "Cost Share Group Code: August"
        CST_SHR_GRP_CD_09                = "Cost Share Group Code: September"
        CST_SHR_GRP_CD_10                = "Cost Share Group Code: October"
        CST_SHR_GRP_CD_11                = "Cost Share Group Code: November"
        CST_SHR_GRP_CD_12                = "Cost Share Group Code: December"
    ;

run;

proc contents data=seer.mbsfabcd position;
run;


/* MedPAR File */ 


filename medpar 'S:\JamieHeyward\Dissertation Aim 2 SEER Medicare Cohort Study\SEERMed_IRAE\SEER Medicare irAE 2013-2019\medpar*.txt';                   /* reading in an un-zipped file */
*filename medpar pipe 'gunzip -c /directory/medpar2019.txt.gz'; /* reading in a zipped file */
*filename medpar pipe 'gunzip -c /directory/medpar*.txt.gz';  /* using wildcard to match multiple files */

options nocenter validvarname=upcase;

DATA seer.MEDPAR;
  INFILE medpar lrecl=2248 missover pad;
  INPUT
    @00001 PATIENT_ID                       $char15.  /*  Patient ID (for either Cancer or Non-Cancer Patients) */
    @00016 MEDPAR_ID                        $CHAR15.  /*  Encrypted  */
    @00031 MEDPAR_YR_NUM                    $CHAR4.
    @00035 NCH_CLM_TYPE_CD                  $CHAR2.
    @00037 BENE_IDENT_CD                    $CHAR2.
    @00039 EQTBL_BIC_CD                     $CHAR2.
    @00041 BENE_AGE_CNT                     4.
    @00045 BENE_SEX_CD                      $CHAR1.
    @00046 BENE_RACE_CD                     $CHAR1.
    @00047 BENE_MDCR_STUS_CD                $CHAR2.
    @00049 BENE_RSDNC_SSA_STATE_CD          $CHAR2.
    @00051 BENE_RSDNC_SSA_CNTY_CD           $CHAR3.
    @00054 BENE_MLG_CNTCT_ZIP_CD            $CHAR5.   /*  Encrypted  */
    @00059 BENE_DSCHRG_STUS_CD              $CHAR1.
    @00060 FICARR_IDENT_NUM                 $CHAR5.
    @00065 WRNG_IND_CD                      $CHAR18.
    @00083 GHO_PD_CD                        $CHAR1.
    @00084 PPS_IND_CD                       $CHAR1.
    @00085 ORG_NPI_NUM                      $CHAR10.  /*  Encrypted  */
    @00095 PRVDR_NUM                        $CHAR6.   /*  Encrypted  */
    @00105 PRVDR_NUM_SPCL_UNIT_CD           $CHAR1.
    @00106 SS_LS_SNF_IND_CD                 $CHAR1.
    @00107 ACTV_XREF_IND                    $CHAR1.
    @00108 SLCT_RSN_CD                      $CHAR1.
    @00109 STAY_FINL_ACTN_CLM_CNT           5.
    @00114 LTST_CLM_ACRTN_DT                $char8.  /*  YYMMDD8  */
    @00122 BENE_MDCR_BNFT_EXHST_DT          $char8.  /*  YYMMDD8  */
    @00130 SNF_QUALN_FROM_DT                $char8.  /*  YYMMDD8  */
    @00138 SNF_QUALN_THRU_DT                $char8.  /*  YYMMDD8  */
    @00146 SRC_IP_ADMSN_CD                  $CHAR1.
    @00147 IP_ADMSN_TYPE_CD                 $CHAR1.
    @00148 ADMSN_DAY_CD                     $CHAR1.
    @00149 ADMSN_DT                         $char8.  /*  YYMMDD8  */
    @00157 DSCHRG_DT                        $char8.  /*  YYMMDD8  */
    @00165 DSCHRG_DSTNTN_CD                 $CHAR2.
    @00167 CVRD_LVL_CARE_THRU_DT            $char8.  /*  YYMMDD8  */
    @00175 BENE_DEATH_DT                    $char8.  /*  YYMMDD8  */
    @00183 BENE_DEATH_DT_VRFY_CD            $CHAR1.
    @00184 ADMSN_DEATH_DAY_CNT              7.
    @00191 INTRNL_USE_SSI_IND_CD            $CHAR1.
    @00192 INTRNL_USE_SSI_DAY_CNT           7.
    @00199 INTRNL_USE_SSI_DATA              $CHAR1.
    @00200 INTRNL_USE_IPSB_CD               $CHAR3.
    @00203 INTRNL_USE_FIL_DT_CD             $CHAR1.
    @00204 INTRNL_USE_SMPL_SIZE_CD          $CHAR1.
    @00205 LOS_DAY_CNT                      7.
    @00212 OUTLIER_DAY_CNT                  5.
    @00217 UTLZTN_DAY_CNT                   7.
    @00224 TOT_COINSRNC_DAY_CNT             5.
    @00229 BENE_LRD_USE_CNT                 5.
    @00234 BENE_PTA_COINSRNC_AMT            10.
    @00244 BENE_IP_DDCTBL_AMT               10.
    @00254 BENE_BLOOD_DDCTBL_AMT            10.
    @00264 BENE_PRMRY_PYR_CD                $CHAR1.
    @00265 BENE_PRMRY_PYR_AMT               10.
    @00275 DRG_CD                           $CHAR4.
    @00279 DRG_OUTLIER_STAY_CD              $CHAR1.
    @00280 DRG_OUTLIER_PMT_AMT              10.
    @00290 DRG_PRICE_AMT                    10.
    @00300 IP_DSPRPRTNT_SHR_AMT             10.
    @00310 IME_AMT                          10.
    @00320 PASS_THRU_AMT                    10.
    @00330 TOT_PPS_CPTL_AMT                 10.
    @00340 IP_LOW_VOL_PYMT_AMT              10.
    @00350 TOT_CHRG_AMT                     10.
    @00360 TOT_CVR_CHRG_AMT                 10.
    @00370 MDCR_PMT_AMT                     10.
    @00380 ACMDTNS_TOT_CHRG_AMT             10.
    @00390 DPRTMNTL_TOT_CHRG_AMT            10.
    @00400 PRVT_ROOM_DAY_CNT                5.
    @00405 SEMIPRVT_ROOM_DAY_CNT            5.
    @00410 WARD_DAY_CNT                     5.
    @00415 INTNSV_CARE_DAY_CNT              5.
    @00420 CRNRY_CARE_DAY_CNT               5.
    @00425 PRVT_ROOM_CHRG_AMT               10.
    @00435 SEMIPRVT_ROOM_CHRG_AMT           10.
    @00445 WARD_CHRG_AMT                    10.
    @00455 INTNSV_CARE_CHRG_AMT             10.
    @00465 CRNRY_CARE_CHRG_AMT              10.
    @00475 OTHR_SRVC_CHRG_AMT               10.
    @00485 PHRMCY_CHRG_AMT                  10.
    @00495 MDCL_SUPLY_CHRG_AMT              10.
    @00505 DME_CHRG_AMT                     10.
    @00515 USED_DME_CHRG_AMT                10.
    @00525 PHYS_THRPY_CHRG_AMT              10.
    @00535 OCPTNL_THRPY_CHRG_AMT            10.
    @00545 SPCH_PTHLGY_CHRG_AMT             10.
    @00555 INHLTN_THRPY_CHRG_AMT            10.
    @00565 BLOOD_CHRG_AMT                   10.
    @00575 BLOOD_ADMIN_CHRG_AMT             10.
    @00585 BLOOD_PT_FRNSH_QTY               5.
    @00590 OPRTG_ROOM_CHRG_AMT              10.
    @00600 LTHTRPSY_CHRG_AMT                10.
    @00610 CRDLGY_CHRG_AMT                  10.
    @00620 ANSTHSA_CHRG_AMT                 10.
    @00630 LAB_CHRG_AMT                     10.
    @00640 RDLGY_CHRG_AMT                   10.
    @00650 MRI_CHRG_AMT                     10.
    @00660 OP_SRVC_CHRG_AMT                 10.
    @00670 ER_CHRG_AMT                      10.
    @00680 AMBLNC_CHRG_AMT                  10.
    @00690 PROFNL_FEES_CHRG_AMT             10.
    @00700 ORGN_ACQSTN_CHRG_AMT             10.
    @00710 ESRD_REV_SETG_CHRG_AMT           10.
    @00720 CLNC_VISIT_CHRG_AMT              10.
    @00730 ICU_IND_CD                       $CHAR1.
    @00731 CRNRY_CARE_IND_CD                $CHAR1.
    @00732 PHRMCY_IND_CD                    $CHAR1.
    @00733 TRNSPLNT_IND_CD                  $CHAR1.
    @00734 RDLGY_ONCLGY_IND_SW              $CHAR1.
    @00735 RDLGY_DGNSTC_IND_SW              $CHAR1.
    @00736 RDLGY_THRPTC_IND_SW              $CHAR1.
    @00737 RDLGY_NUCLR_MDCN_IND_SW          $CHAR1.
    @00738 RDLGY_CT_SCAN_IND_SW             $CHAR1.
    @00739 RDLGY_OTHR_IMGNG_IND_SW          $CHAR1.
    @00740 OP_SRVC_IND_CD                   $CHAR1.
    @00741 ORGN_ACQSTN_IND_CD               $CHAR2.
    @00743 ESRD_COND_CD                     $CHAR2.
    @00745 ESRD_SETG_IND_1_CD               $CHAR2.
    @00747 ESRD_SETG_IND_2_CD               $CHAR2.
    @00749 ESRD_SETG_IND_3_CD               $CHAR2.
    @00751 ESRD_SETG_IND_4_CD               $CHAR2.
    @00753 ESRD_SETG_IND_5_CD               $CHAR2.
    @00755 ADMTG_DGNS_CD                    $CHAR7.
    @00762 ADMTG_DGNS_VRSN_CD               $CHAR1.
    @00763 DGNS_CD_CNT                      3.
    @00766 DGNS_VRSN_CD                     $CHAR1.
    @00767 DGNS_VRSN_CD_1                   $CHAR1.
    @00768 DGNS_VRSN_CD_2                   $CHAR1.
    @00769 DGNS_VRSN_CD_3                   $CHAR1.
    @00770 DGNS_VRSN_CD_4                   $CHAR1.
    @00771 DGNS_VRSN_CD_5                   $CHAR1.
    @00772 DGNS_VRSN_CD_6                   $CHAR1.
    @00773 DGNS_VRSN_CD_7                   $CHAR1.
    @00774 DGNS_VRSN_CD_8                   $CHAR1.
    @00775 DGNS_VRSN_CD_9                   $CHAR1.
    @00776 DGNS_VRSN_CD_10                  $CHAR1.
    @00777 DGNS_VRSN_CD_11                  $CHAR1.
    @00778 DGNS_VRSN_CD_12                  $CHAR1.
    @00779 DGNS_VRSN_CD_13                  $CHAR1.
    @00780 DGNS_VRSN_CD_14                  $CHAR1.
    @00781 DGNS_VRSN_CD_15                  $CHAR1.
    @00782 DGNS_VRSN_CD_16                  $CHAR1.
    @00783 DGNS_VRSN_CD_17                  $CHAR1.
    @00784 DGNS_VRSN_CD_18                  $CHAR1.
    @00785 DGNS_VRSN_CD_19                  $CHAR1.
    @00786 DGNS_VRSN_CD_20                  $CHAR1.
    @00787 DGNS_VRSN_CD_21                  $CHAR1.
    @00788 DGNS_VRSN_CD_22                  $CHAR1.
    @00789 DGNS_VRSN_CD_23                  $CHAR1.
    @00790 DGNS_VRSN_CD_24                  $CHAR1.
    @00791 DGNS_VRSN_CD_25                  $CHAR1.
    @00792 DGNS_1_CD                        $CHAR7.
    @00799 DGNS_2_CD                        $CHAR7.
    @00806 DGNS_3_CD                        $CHAR7.
    @00813 DGNS_4_CD                        $CHAR7.
    @00820 DGNS_5_CD                        $CHAR7.
    @00827 DGNS_6_CD                        $CHAR7.
    @00834 DGNS_7_CD                        $CHAR7.
    @00841 DGNS_8_CD                        $CHAR7.
    @00848 DGNS_9_CD                        $CHAR7.
    @00855 DGNS_10_CD                       $CHAR7.
    @00862 DGNS_11_CD                       $CHAR7.
    @00869 DGNS_12_CD                       $CHAR7.
    @00876 DGNS_13_CD                       $CHAR7.
    @00883 DGNS_14_CD                       $CHAR7.
    @00890 DGNS_15_CD                       $CHAR7.
    @00897 DGNS_16_CD                       $CHAR7.
    @00904 DGNS_17_CD                       $CHAR7.
    @00911 DGNS_18_CD                       $CHAR7.
    @00918 DGNS_19_CD                       $CHAR7.
    @00925 DGNS_20_CD                       $CHAR7.
    @00932 DGNS_21_CD                       $CHAR7.
    @00939 DGNS_22_CD                       $CHAR7.
    @00946 DGNS_23_CD                       $CHAR7.
    @00953 DGNS_24_CD                       $CHAR7.
    @00960 DGNS_25_CD                       $CHAR7.
    @00967 DGNS_POA_CD                      $CHAR10.
    @00977 POA_DGNS_CD_CNT                  3.
    @00980 POA_DGNS_1_IND_CD                $CHAR1.
    @00981 POA_DGNS_2_IND_CD                $CHAR1.
    @00982 POA_DGNS_3_IND_CD                $CHAR1.
    @00983 POA_DGNS_4_IND_CD                $CHAR1.
    @00984 POA_DGNS_5_IND_CD                $CHAR1.
    @00985 POA_DGNS_6_IND_CD                $CHAR1.
    @00986 POA_DGNS_7_IND_CD                $CHAR1.
    @00987 POA_DGNS_8_IND_CD                $CHAR1.
    @00988 POA_DGNS_9_IND_CD                $CHAR1.
    @00989 POA_DGNS_10_IND_CD               $CHAR1.
    @00990 POA_DGNS_11_IND_CD               $CHAR1.
    @00991 POA_DGNS_12_IND_CD               $CHAR1.
    @00992 POA_DGNS_13_IND_CD               $CHAR1.
    @00993 POA_DGNS_14_IND_CD               $CHAR1.
    @00994 POA_DGNS_15_IND_CD               $CHAR1.
    @00995 POA_DGNS_16_IND_CD               $CHAR1.
    @00996 POA_DGNS_17_IND_CD               $CHAR1.
    @00997 POA_DGNS_18_IND_CD               $CHAR1.
    @00998 POA_DGNS_19_IND_CD               $CHAR1.
    @00999 POA_DGNS_20_IND_CD               $CHAR1.
    @01000 POA_DGNS_21_IND_CD               $CHAR1.
    @01001 POA_DGNS_22_IND_CD               $CHAR1.
    @01002 POA_DGNS_23_IND_CD               $CHAR1.
    @01003 POA_DGNS_24_IND_CD               $CHAR1.
    @01004 POA_DGNS_25_IND_CD               $CHAR1.
    @01005 DGNS_E_CD_CNT                    3.
    @01008 DGNS_E_VRSN_CD                   $CHAR1.
    @01009 DGNS_E_VRSN_CD_1                 $CHAR1.
    @01010 DGNS_E_VRSN_CD_2                 $CHAR1.
    @01011 DGNS_E_VRSN_CD_3                 $CHAR1.
    @01012 DGNS_E_VRSN_CD_4                 $CHAR1.
    @01013 DGNS_E_VRSN_CD_5                 $CHAR1.
    @01014 DGNS_E_VRSN_CD_6                 $CHAR1.
    @01015 DGNS_E_VRSN_CD_7                 $CHAR1.
    @01016 DGNS_E_VRSN_CD_8                 $CHAR1.
    @01017 DGNS_E_VRSN_CD_9                 $CHAR1.
    @01018 DGNS_E_VRSN_CD_10                $CHAR1.
    @01019 DGNS_E_VRSN_CD_11                $CHAR1.
    @01020 DGNS_E_VRSN_CD_12                $CHAR1.
    @01021 DGNS_E_1_CD                      $CHAR7.
    @01028 DGNS_E_2_CD                      $CHAR7.
    @01035 DGNS_E_3_CD                      $CHAR7.
    @01042 DGNS_E_4_CD                      $CHAR7.
    @01049 DGNS_E_5_CD                      $CHAR7.
    @01056 DGNS_E_6_CD                      $CHAR7.
    @01063 DGNS_E_7_CD                      $CHAR7.
    @01070 DGNS_E_8_CD                      $CHAR7.
    @01077 DGNS_E_9_CD                      $CHAR7.
    @01084 DGNS_E_10_CD                     $CHAR7.
    @01091 DGNS_E_11_CD                     $CHAR7.
    @01098 DGNS_E_12_CD                     $CHAR7.
    @01105 POA_DGNS_E_CD_CNT                3.
    @01108 POA_DGNS_E_1_IND_CD              $CHAR1.
    @01109 POA_DGNS_E_2_IND_CD              $CHAR1.
    @01110 POA_DGNS_E_3_IND_CD              $CHAR1.
    @01111 POA_DGNS_E_4_IND_CD              $CHAR1.
    @01112 POA_DGNS_E_5_IND_CD              $CHAR1.
    @01113 POA_DGNS_E_6_IND_CD              $CHAR1.
    @01114 POA_DGNS_E_7_IND_CD              $CHAR1.
    @01115 POA_DGNS_E_8_IND_CD              $CHAR1.
    @01116 POA_DGNS_E_9_IND_CD              $CHAR1.
    @01117 POA_DGNS_E_10_IND_CD             $CHAR1.
    @01118 POA_DGNS_E_11_IND_CD             $CHAR1.
    @01119 POA_DGNS_E_12_IND_CD             $CHAR1.
    @01120 SRGCL_PRCDR_IND_SW               $CHAR1.
    @01121 SRGCL_PRCDR_CD_CNT               3.
    @01124 SRGCL_PRCDR_VRSN_CD              $CHAR1.
    @01125 SRGCL_PRCDR_VRSN_CD_1            $CHAR1.
    @01126 SRGCL_PRCDR_VRSN_CD_2            $CHAR1.
    @01127 SRGCL_PRCDR_VRSN_CD_3            $CHAR1.
    @01128 SRGCL_PRCDR_VRSN_CD_4            $CHAR1.
    @01129 SRGCL_PRCDR_VRSN_CD_5            $CHAR1.
    @01130 SRGCL_PRCDR_VRSN_CD_6            $CHAR1.
    @01131 SRGCL_PRCDR_VRSN_CD_7            $CHAR1.
    @01132 SRGCL_PRCDR_VRSN_CD_8            $CHAR1.
    @01133 SRGCL_PRCDR_VRSN_CD_9            $CHAR1.
    @01134 SRGCL_PRCDR_VRSN_CD_10           $CHAR1.
    @01135 SRGCL_PRCDR_VRSN_CD_11           $CHAR1.
    @01136 SRGCL_PRCDR_VRSN_CD_12           $CHAR1.
    @01137 SRGCL_PRCDR_VRSN_CD_13           $CHAR1.
    @01138 SRGCL_PRCDR_VRSN_CD_14           $CHAR1.
    @01139 SRGCL_PRCDR_VRSN_CD_15           $CHAR1.
    @01140 SRGCL_PRCDR_VRSN_CD_16           $CHAR1.
    @01141 SRGCL_PRCDR_VRSN_CD_17           $CHAR1.
    @01142 SRGCL_PRCDR_VRSN_CD_18           $CHAR1.
    @01143 SRGCL_PRCDR_VRSN_CD_19           $CHAR1.
    @01144 SRGCL_PRCDR_VRSN_CD_20           $CHAR1.
    @01145 SRGCL_PRCDR_VRSN_CD_21           $CHAR1.
    @01146 SRGCL_PRCDR_VRSN_CD_22           $CHAR1.
    @01147 SRGCL_PRCDR_VRSN_CD_23           $CHAR1.
    @01148 SRGCL_PRCDR_VRSN_CD_24           $CHAR1.
    @01149 SRGCL_PRCDR_VRSN_CD_25           $CHAR1.
    @01150 SRGCL_PRCDR_1_CD                 $CHAR7.
    @01157 SRGCL_PRCDR_2_CD                 $CHAR7.
    @01164 SRGCL_PRCDR_3_CD                 $CHAR7.
    @01171 SRGCL_PRCDR_4_CD                 $CHAR7.
    @01178 SRGCL_PRCDR_5_CD                 $CHAR7.
    @01185 SRGCL_PRCDR_6_CD                 $CHAR7.
    @01192 SRGCL_PRCDR_7_CD                 $CHAR7.
    @01199 SRGCL_PRCDR_8_CD                 $CHAR7.
    @01206 SRGCL_PRCDR_9_CD                 $CHAR7.
    @01213 SRGCL_PRCDR_10_CD                $CHAR7.
    @01220 SRGCL_PRCDR_11_CD                $CHAR7.
    @01227 SRGCL_PRCDR_12_CD                $CHAR7.
    @01234 SRGCL_PRCDR_13_CD                $CHAR7.
    @01241 SRGCL_PRCDR_14_CD                $CHAR7.
    @01248 SRGCL_PRCDR_15_CD                $CHAR7.
    @01255 SRGCL_PRCDR_16_CD                $CHAR7.
    @01262 SRGCL_PRCDR_17_CD                $CHAR7.
    @01269 SRGCL_PRCDR_18_CD                $CHAR7.
    @01276 SRGCL_PRCDR_19_CD                $CHAR7.
    @01283 SRGCL_PRCDR_20_CD                $CHAR7.
    @01290 SRGCL_PRCDR_21_CD                $CHAR7.
    @01297 SRGCL_PRCDR_22_CD                $CHAR7.
    @01304 SRGCL_PRCDR_23_CD                $CHAR7.
    @01311 SRGCL_PRCDR_24_CD                $CHAR7.
    @01318 SRGCL_PRCDR_25_CD                $CHAR7.
    @01325 SRGCL_PRCDR_DT_CNT               3.
    @01328 SRGCL_PRCDR_PRFRM_1_DT           $char8.  /*  YYMMDD8  */
    @01336 SRGCL_PRCDR_PRFRM_2_DT           $char8.  /*  YYMMDD8  */
    @01344 SRGCL_PRCDR_PRFRM_3_DT           $char8.  /*  YYMMDD8  */
    @01352 SRGCL_PRCDR_PRFRM_4_DT           $char8.  /*  YYMMDD8  */
    @01360 SRGCL_PRCDR_PRFRM_5_DT           $char8.  /*  YYMMDD8  */
    @01368 SRGCL_PRCDR_PRFRM_6_DT           $char8.  /*  YYMMDD8  */
    @01376 SRGCL_PRCDR_PRFRM_7_DT           $char8.  /*  YYMMDD8  */
    @01384 SRGCL_PRCDR_PRFRM_8_DT           $char8.  /*  YYMMDD8  */
    @01392 SRGCL_PRCDR_PRFRM_9_DT           $char8.  /*  YYMMDD8  */
    @01400 SRGCL_PRCDR_PRFRM_10_DT          $char8.  /*  YYMMDD8  */
    @01408 SRGCL_PRCDR_PRFRM_11_DT          $char8.  /*  YYMMDD8  */
    @01416 SRGCL_PRCDR_PRFRM_12_DT          $char8.  /*  YYMMDD8  */
    @01424 SRGCL_PRCDR_PRFRM_13_DT          $char8.  /*  YYMMDD8  */
    @01432 SRGCL_PRCDR_PRFRM_14_DT          $char8.  /*  YYMMDD8  */
    @01440 SRGCL_PRCDR_PRFRM_15_DT          $char8.  /*  YYMMDD8  */
    @01448 SRGCL_PRCDR_PRFRM_16_DT          $char8.  /*  YYMMDD8  */
    @01456 SRGCL_PRCDR_PRFRM_17_DT          $char8.  /*  YYMMDD8  */
    @01464 SRGCL_PRCDR_PRFRM_18_DT          $char8.  /*  YYMMDD8  */
    @01472 SRGCL_PRCDR_PRFRM_19_DT          $char8.  /*  YYMMDD8  */
    @01480 SRGCL_PRCDR_PRFRM_20_DT          $char8.  /*  YYMMDD8  */
    @01488 SRGCL_PRCDR_PRFRM_21_DT          $char8.  /*  YYMMDD8  */
    @01496 SRGCL_PRCDR_PRFRM_22_DT          $char8.  /*  YYMMDD8  */
    @01504 SRGCL_PRCDR_PRFRM_23_DT          $char8.  /*  YYMMDD8  */
    @01512 SRGCL_PRCDR_PRFRM_24_DT          $char8.  /*  YYMMDD8  */
    @01520 SRGCL_PRCDR_PRFRM_25_DT          $char8.  /*  YYMMDD8  */
    @01528 CLM_PTNT_RLTNSHP_CD              $CHAR2.
    @01530 CARE_IMPRVMT_MODEL_1_CD          $CHAR2.
    @01532 CARE_IMPRVMT_MODEL_2_CD          $CHAR2.
    @01534 CARE_IMPRVMT_MODEL_3_CD          $CHAR2.
    @01536 CARE_IMPRVMT_MODEL_4_CD          $CHAR2.
    @01538 VBP_PRTCPNT_IND_CD               $CHAR1.
    @01539 HRR_PRTCPNT_IND_CD               $CHAR1.
    @01540 BNDLD_MODEL_DSCNT_PCT            7.4
    @01547 VBP_ADJSTMT_PCT                  15.12
    @01562 HRR_ADJSTMT_PCT                  8.5
    @01570 INFRMTL_ENCTR_IND_SW             $CHAR1.
    @01571 MA_TCHNG_IND_SW                  $CHAR1.
    @01572 PROD_RPLCMT_LIFECYC_SW           $CHAR1.
    @01573 PROD_RPLCMT_RCLL_SW              $CHAR1.
    @01574 CRED_RCVD_RPLCD_DVC_SW           $CHAR1.
    @01575 OBSRVTN_SW                       $CHAR1.
    @01576 NEW_TCHNLGY_ADD_ON_AMT           10.
    @01586 BASE_OPRTG_DRG_AMT               10.
    @01596 OPRTG_HSP_AMT                    10.
    @01606 MDCL_SRGCL_GNRL_AMT              10.
    @01616 MDCL_SRGCL_NSTRL_AMT             10.
    @01626 MDCL_SRGCL_STRL_AMT              10.
    @01636 TAKE_HOME_AMT                    10.
    @01646 PRSTHTC_ORTHTC_AMT               10.
    @01656 MDCL_SRGCL_PCMKR_AMT             10.
    @01666 INTRAOCULAR_LENS_AMT             10.
    @01676 OXYGN_TAKE_HOME_AMT              10.
    @01686 OTHR_IMPLANTS_AMT                10.
    @01696 OTHR_SUPLIES_DVC_AMT             10.
    @01706 INCDNT_RDLGY_AMT                 10.
    @01716 INCDNT_DGNSTC_SRVCS_AMT          10.
    @01726 MDCL_SRGCL_DRSNG_AMT             10.
    @01736 INVSTGTNL_DVC_AMT                10.
    @01746 MDCL_SRGCL_MISC_AMT              10.
    @01756 RDLGY_ONCOLOGY_AMT               10.
    @01766 RDLGY_DGNSTC_AMT                 10.
    @01776 RDLGY_THRPTC_AMT                 10.
    @01786 RDLGY_NUCLR_MDCN_AMT             10.
    @01796 RDLGY_CT_SCAN_AMT                10.
    @01806 RDLGY_OTHR_IMGNG_AMT             10.
    @01816 OPRTG_ROOM_AMT                   10.
    @01826 OR_LABOR_DLVRY_AMT               10.
    @01836 CRDC_CATHRZTN_AMT                10.
    @01846 SQSTRTN_RDCTN_AMT                10.
    @01856 UNCOMPD_CARE_PYMT_AMT            10.
    @01866 BNDLD_ADJSTMT_AMT                10.
    @01876 VBP_ADJSTMT_AMT                  10.
    @01886 HRR_ADJSTMT_AMT                  10.
    @01896 EHR_PYMT_ADJSTMT_AMT             10.
    @01906 PPS_STD_VAL_PYMT_AMT             10.
    @01916 FINL_STD_AMT                     10.
    @01926 HAC_RDCTN_PMT_AMT                10.
    @01936 IPPS_FLEX_PYMT_7_AMT             10.
    @01946 PTNT_ADD_ON_PYMT_AMT             10.
    @01956 HAC_PGM_RDCTN_IND_SW             $CHAR1.
    @01957 PGM_RDCTN_IND_SW                 $CHAR1.
    @01958 PA_IND_CD                        $CHAR4.
    @01962 UNIQ_TRKNG_NUM                   $CHAR14.  /*  Encrypted  */
    @01976 STAY_2_IND_SW                    $CHAR1.
    @01977 CLM_SITE_NTRL_PYMT_CST_AMT       10.
    @01987 CLM_SITE_NTRL_PYMT_IPPS_AMT      10.
    @01997 CLM_FULL_STD_PYMT_AMT            10.
    @02007 CLM_SS_OUTLIER_STD_PYMT_AMT      10.
    @02017 CLM_NGACO_IND_1_CD               $CHAR1.
    @02018 CLM_NGACO_IND_2_CD               $CHAR1.
    @02019 CLM_NGACO_IND_3_CD               $CHAR1.
    @02020 CLM_NGACO_IND_4_CD               $CHAR1.
    @02021 CLM_NGACO_IND_5_CD               $CHAR1.
    @02022 CLM_RSDL_PYMT_IND_CD             $CHAR1.
    @02023 CLM_RP_IND_CD                    $CHAR1.
    @02024 RC_RP_IND_CD                     $CHAR1.
    @02025 ACO_ID_NUM                       $CHAR10.  /*  Encrypted  */
    @02035 RC_ALLOGENEIC_STEM_CELL_AMT      10.
    @02045 ISLET_ADD_ON_PYMT_AMT            10.
    @02055 CLM_IP_INITL_MS_DRG_CD           $CHAR4.
    @02059 VAL_CD_Q1_PYMT_RDCTN_AMT         10.
    @02069 CLM_MODEL_REIMBRSMT_AMT          10.
    @02079 RC_MODEL_REIMBRSMT_AMT           10.
    @02089 VAL_CD_QB_OCM_PYMT_ADJSTMT_AMT   10.
    @02099 CELL_GENE_THRPY_PRCDRS_TOT_AMT   10.
    @02109 CELL_THRPY_DRUGS_TOT_AMT         10.
    @02119 GENE_THRPY_DRUGS_TOT_AMT         10.
    @02129 LTCH_DPP_ADJSTMT_AMT             10.
    @02139 RC_NDC_1_CD                      $CHAR11.
    @02150 RC_NDC_2_CD                      $CHAR11.
    @02161 RC_NDC_3_CD                      $CHAR11.
    @02172 RC_NDC_4_CD                      $CHAR11.
    @02183 RC_NDC_5_CD                      $CHAR11.
    @02194 RC_NDC_6_CD                      $CHAR11.
    @02205 RC_NDC_7_CD                      $CHAR11.
    @02216 RC_NDC_8_CD                      $CHAR11.
    @02227 RC_NDC_9_CD                      $CHAR11.
    @02238 RC_NDC_10_CD                     $CHAR11.
  ;

  LABEL
        PATIENT_ID                       = "Patient ID"
        MEDPAR_ID                        = "Unique Key for CCW MedPAR Table"
        MEDPAR_YR_NUM                    = "Year of MedPAR Record"
        NCH_CLM_TYPE_CD                  = "NCH Claim Type Code"
        BENE_IDENT_CD                    = "BIC reported on first claim included in stay"
        EQTBL_BIC_CD                     = "Equated BIC"
        BENE_AGE_CNT                     = "Age as of Date of Admission."
        BENE_SEX_CD                      = "Sex of Beneficiary"
        BENE_RACE_CD                     = "Race of Beneficiary"
        BENE_MDCR_STUS_CD                = "Reason for entitlement to Medicare benefits as of CLM_THRU_DT"
        BENE_RSDNC_SSA_STATE_CD          = "SSA standard state code of a beneficiarys residence."
        BENE_RSDNC_SSA_CNTY_CD           = "SSA standard county code of a beneficiarys residence."
        BENE_MLG_CNTCT_ZIP_CD            = "Zip code of the mailing address where the beneficiary may be contacted."
        BENE_DSCHRG_STUS_CD              = "Code identifying status of patient as of CLM_THRU_DT"
        FICARR_IDENT_NUM                 = "Intermediary processor identification"
        WRNG_IND_CD                      = "Warn ind spcfyng dtld billing info obtnd frm clms analyzd for stay prcss"
        GHO_PD_CD                        = "Code indicating whether or not GHO has paid provider for claim(s)"
        PPS_IND_CD                       = "Code indicating whether or not facility is being paid under PPS"
        ORG_NPI_NUM                      = "Organization NPI Number"
        PRVDR_NUM                        = "MEDPAR Provider Number"
        PRVDR_NUM_SPCL_UNIT_CD           = "Special num system code for hosp units that are PPS/SNF SB dsgntn excl."
        SS_LS_SNF_IND_CD                 = "Code indicating whether stay is short stay, long stay, or SNF"
        ACTV_XREF_IND                    = "Active Cross-Refference Indicator"
        SLCT_RSN_CD                      = "Specifies whether this record is a case or control record."
        STAY_FINL_ACTN_CLM_CNT           = "Claims (final action) included in stay"
        LTST_CLM_ACRTN_DT                = "Date latest claim incl in stay accreted to bene mstr rec at the CWF host"
        BENE_MDCR_BNFT_EXHST_DT          = "Last date beneficiary had Medicare coverage"
        SNF_QUALN_FROM_DT                = "Beginning date of beneficiarys qualifying stay"
        SNF_QUALN_THRU_DT                = "Ending date of beneficiarys qualifying stay"
        SRC_IP_ADMSN_CD                  = "Admssn to an Inp facility or, for newborn admssn, type of delivery code"
        IP_ADMSN_TYPE_CD                 = "Type and priority of benes admission to facility for Inp hosp stay code"
        ADMSN_DAY_CD                     = "Code indicating day of week beneficiary was admitted to facility."
        ADMSN_DT                         = "Date beneficiary admitted for Inpatient care or date care started"
        DSCHRG_DT                        = "Date beneficiary was discharged or died"
        DSCHRG_DSTNTN_CD                 = "Destination upon discharge from facility code"
        CVRD_LVL_CARE_THRU_DT            = "Date covered level of care ended in a SNF"
        BENE_DEATH_DT                    = "Date beneficiary died"
        BENE_DEATH_DT_VRFY_CD            = "Death Date Verification Code"
        ADMSN_DEATH_DAY_CNT              = "Days from date admitted to facility to date of death"
        INTRNL_USE_SSI_IND_CD            = "MEDPAR Internal Use SSI Indicator Code"
        INTRNL_USE_SSI_DAY_CNT           = "MEDPAR Internal Use SSI Day Count"
        INTRNL_USE_SSI_DATA              = "Internal Use SSI Data"
        INTRNL_USE_IPSB_CD               = "For internal Use Only. IPSB Code"
        INTRNL_USE_FIL_DT_CD             = "For internal use only. Fiscal year/calendar year segments."
        INTRNL_USE_SMPL_SIZE_CD          = "For internal use. MEDPAR sample size."
        LOS_DAY_CNT                      = "Days of beneficiarys stay in a hospital/SNF"
        OUTLIER_DAY_CNT                  = "Days paid as outliers (either day or cost) under PPS beyond DRG threshld"
        UTLZTN_DAY_CNT                   = "Covered days of care chargeable to Medicare utilization for stay"
        TOT_COINSRNC_DAY_CNT             = "MEDPAR Beneficiary Total Coinsurance Day Count"
        BENE_LRD_USE_CNT                 = "Lifetime reserve days (LRD) used by beneficiary for stay"
        BENE_PTA_COINSRNC_AMT            = "Beneficiarys liability for part A coinsurance for stay ($)"
        BENE_IP_DDCTBL_AMT               = "Beneficiarys liability for stay ($)"
        BENE_BLOOD_DDCTBL_AMT            = "Beneficiarys liability for blood deductible for stay ($)"
        BENE_PRMRY_PYR_CD                = "Primary payer responsibility code"
        BENE_PRMRY_PYR_AMT               = "Primry payer other than Medicare for covered Medicare chrgs for stay ($)"
        DRG_CD                           = "DRG Code"
        DRG_OUTLIER_STAY_CD              = "Cost or Day Outlier code"
        DRG_OUTLIER_PMT_AMT              = "Addtnl approved due to outlier situation over DRG allowance for stay ($)"
        DRG_PRICE_AMT                    = "Wld hv bn pd if no dedctbls,coinsrnc,prmry payrs,otlrs were invlvd ($)"
        IP_DSPRPRTNT_SHR_AMT             = "Over the DRG amount for disproportionate share hospital for stay ($)"
        IME_AMT                          = "Additional payment made to teaching hospitals for IME for stay ($)"
        PASS_THRU_AMT                    = "Total of all claim pass thru for stay ($)"
        TOT_PPS_CPTL_AMT                 = "Total payable for capital PPS ($)"
        IP_LOW_VOL_PYMT_AMT              = "Inpatient Low Volume Payment Amount."
        TOT_CHRG_AMT                     = "Total all charges for all srvcs provided to beneficiary for stay ($)"
        TOT_CVR_CHRG_AMT                 = "Portion of total charges covered by Medicare for stay ($)"
        MDCR_PMT_AMT                     = "Amt of payment from Medicare trust fund for srvcs covered by claim ($)"
        ACMDTNS_TOT_CHRG_AMT             = "Total charge for all accommodations related to beneficiarys stay ($)"
        DPRTMNTL_TOT_CHRG_AMT            = "Total charge for all ancillary depts related to beneficiarys stay ($)"
        PRVT_ROOM_DAY_CNT                = "Private room days used by beneficiary for stay"
        SEMIPRVT_ROOM_DAY_CNT            = "Semi-private room days used by beneficiary for stay"
        WARD_DAY_CNT                     = "Ward days used by beneficiary for stay"
        INTNSV_CARE_DAY_CNT              = "Intensive care days used by beneficiary for stay"
        CRNRY_CARE_DAY_CNT               = "Coronary care days used by beneficiary for stay"
        PRVT_ROOM_CHRG_AMT               = "Private room accommodations related to beneficiarys stay ($)"
        SEMIPRVT_ROOM_CHRG_AMT           = "Semi-private room accommodations related to beneficiarys stay ($)"
        WARD_CHRG_AMT                    = "Ward accommodations related to beneficiarys stay ($)"
        INTNSV_CARE_CHRG_AMT             = "Intensive care accommodations related to beneficiarys stay ($)"
        CRNRY_CARE_CHRG_AMT              = "Coronary care accommodations related to beneficiarys stay ($)"
        OTHR_SRVC_CHRG_AMT               = "Other services related to beneficiarys stay ($)"
        PHRMCY_CHRG_AMT                  = "Pharmaceutical costs related to beneficiarys stay ($)"
        MDCL_SUPLY_CHRG_AMT              = "Medical/surgical supplies related to beneficiarys stay ($)"
        DME_CHRG_AMT                     = "DME related to beneficiarys stay ($)"
        USED_DME_CHRG_AMT                = "Used DME related to beneficiarys stay ($)"
        PHYS_THRPY_CHRG_AMT              = "Physical therapy services provided during beneficiarys stay ($)"
        OCPTNL_THRPY_CHRG_AMT            = "Occupational therapy services provided during beneficiarys stay ($)"
        SPCH_PTHLGY_CHRG_AMT             = "Speech pathology services provided during beneficiarys stay ($)"
        INHLTN_THRPY_CHRG_AMT            = "Inhalation therapy services provided during beneficiarys stay ($)"
        BLOOD_CHRG_AMT                   = "Blood provided during beneficiarys stay ($)"
        BLOOD_ADMIN_CHRG_AMT             = "Blood storage and processing related to beneficiarys stay ($)"
        BLOOD_PT_FRNSH_QTY               = "Quantity of blood (whole pints) furnished to beneficiary during stay"
        OPRTG_ROOM_CHRG_AMT              = "OR, recovery rm, and labor rm delivery used by bene during stay ($)"
        LTHTRPSY_CHRG_AMT                = "Lithotripsy services provided during beneficiarys stay ($)"
        CRDLGY_CHRG_AMT                  = "Cardiology services and ECG(s) provided during beneficiarys stay ($)"
        ANSTHSA_CHRG_AMT                 = "Anesthesia services provided during beneficiarys stay ($)"
        LAB_CHRG_AMT                     = "Laboratory costs related to beneficiarys stay ($)"
        RDLGY_CHRG_AMT                   = "Radiology costs (excluding MRI) related to a beneficiarys stay ($)"
        MRI_CHRG_AMT                     = "MRI services provided during beneficiarys stay ($)"
        OP_SRVC_CHRG_AMT                 = "Outpatient services provided during beneficiarys stay ($)"
        ER_CHRG_AMT                      = "Emergency room services provided during beneficiarys stay ($)"
        AMBLNC_CHRG_AMT                  = "Ambulance services related to beneficiarys stay ($)"
        PROFNL_FEES_CHRG_AMT             = "Professional fees related to beneficiarys stay ($)"
        ORGN_ACQSTN_CHRG_AMT             = "Organ acquisition or oth donor bank srvcs related to benes stay ($)"
        ESRD_REV_SETG_CHRG_AMT           = "ESRD services related to beneficiarys stay ($)"
        CLNC_VISIT_CHRG_AMT              = "Clinic visits related to beneficiarys stay ($)"
        ICU_IND_CD                       = "ICU type code"
        CRNRY_CARE_IND_CD                = "Coronary care unit type code"
        PHRMCY_IND_CD                    = "Drugs type code"
        TRNSPLNT_IND_CD                  = "Organ transplant code"
        RDLGY_ONCLGY_IND_SW              = "Radiology oncology services indicator"
        RDLGY_DGNSTC_IND_SW              = "Radiology diagnostic services indicator"
        RDLGY_THRPTC_IND_SW              = "Radiology therapeutic services indicator"
        RDLGY_NUCLR_MDCN_IND_SW          = "Radiology nuclear medicine services indicator"
        RDLGY_CT_SCAN_IND_SW             = "Radiology computed tomographic (CT) scan services indicator"
        RDLGY_OTHR_IMGNG_IND_SW          = "Radiology other imaging services indicator"
        OP_SRVC_IND_CD                   = "Outpatient services/ambulatory surgical care code"
        ORGN_ACQSTN_IND_CD               = "Organ acquisition type code"
        ESRD_COND_CD                     = "ESRD condition code"
        ESRD_SETG_IND_1_CD               = "Dialysis type code I"
        ESRD_SETG_IND_2_CD               = "Dialysis type code II"
        ESRD_SETG_IND_3_CD               = "Dialysis type code III"
        ESRD_SETG_IND_4_CD               = "Dialysis type code IV"
        ESRD_SETG_IND_5_CD               = "Dialysis type code V"
        ADMTG_DGNS_CD                    = "Initial diagnosis at time of admission"
        ADMTG_DGNS_VRSN_CD               = "MEDPAR Admitting Diagnosis Version Code"
        DGNS_CD_CNT                      = "Diagnosis codes included in stay"
        DGNS_VRSN_CD                     = "Version Code - Indicate if diagnosis code is ICD-9 or ICD-10 (Earlier Version)"
        DGNS_VRSN_CD_1                   = "Version Code 01 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_2                   = "Version Code 02 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_3                   = "Version Code 03 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_4                   = "Version Code 04 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_5                   = "Version Code 05 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_6                   = "Version Code 06 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_7                   = "Version Code 07 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_8                   = "Version Code 08 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_9                   = "Version Code 09 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_10                  = "Version Code 10 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_11                  = "Version Code 11 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_12                  = "Version Code 12 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_13                  = "Version Code 13 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_14                  = "Version Code 14 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_15                  = "Version Code 15 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_16                  = "Version Code 16 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_17                  = "Version Code 17 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_18                  = "Version Code 18 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_19                  = "Version Code 19 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_20                  = "Version Code 20 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_21                  = "Version Code 21 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_22                  = "Version Code 22 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_23                  = "Version Code 23 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_24                  = "Version Code 24 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_VRSN_CD_25                  = "Version Code 25 - Indicate if diagnosis code is ICD-9 or ICD-10."
        DGNS_1_CD                        = "Primary ICD-9-CM code"
        DGNS_2_CD                        = "ICD-9-CM Diagnosis code II"
        DGNS_3_CD                        = "ICD-9-CM Diagnosis code III"
        DGNS_4_CD                        = "ICD-9-CM Diagnosis code IV"
        DGNS_5_CD                        = "ICD-9-CM Diagnosis code V"
        DGNS_6_CD                        = "ICD-9-CM Diagnosis code VI"
        DGNS_7_CD                        = "ICD-9-CM Diagnosis code VII"
        DGNS_8_CD                        = "ICD-9-CM Diagnosis code VIII"
        DGNS_9_CD                        = "ICD-9-CM Diagnosis code IX"
        DGNS_10_CD                       = "ICD-9-CM Diagnosis code X"
        DGNS_11_CD                       = "ICD-9-CM Diagnosis code XI"
        DGNS_12_CD                       = "ICD-9-CM Diagnosis code XII"
        DGNS_13_CD                       = "ICD-9-CM Diagnosis code XIII"
        DGNS_14_CD                       = "ICD-9-CM Diagnosis code XIV"
        DGNS_15_CD                       = "ICD-9-CM Diagnosis code XV"
        DGNS_16_CD                       = "ICD-9-CM Diagnosis code XVI"
        DGNS_17_CD                       = "ICD-9-CM Diagnosis code XVII"
        DGNS_18_CD                       = "ICD-9-CM Diagnosis code XVIII"
        DGNS_19_CD                       = "ICD-9-CM Diagnosis code XIX"
        DGNS_20_CD                       = "ICD-9-CM Diagnosis code XX"
        DGNS_21_CD                       = "ICD-9-CM Diagnosis code XXI"
        DGNS_22_CD                       = "ICD-9-CM Diagnosis code XXII"
        DGNS_23_CD                       = "ICD-9-CM Diagnosis code XXIII"
        DGNS_24_CD                       = "ICD-9-CM Diagnosis code XXIV"
        DGNS_25_CD                       = "ICD-9-CM Diagnosis code XXV"
        DGNS_POA_CD                      = "Diagnosis Code POA Array"
        POA_DGNS_CD_CNT                  = "MEDPAR Claim Present on Admission Diagnosis Code Count"
        POA_DGNS_1_IND_CD                = "Diagnosis Present on Admission Indicator 1"
        POA_DGNS_2_IND_CD                = "Diagnosis Present on Admission Indicator 2"
        POA_DGNS_3_IND_CD                = "Diagnosis Present on Admission Indicator 3"
        POA_DGNS_4_IND_CD                = "Diagnosis Present on Admission Indicator 4"
        POA_DGNS_5_IND_CD                = "Diagnosis Present on Admission Indicator 5"
        POA_DGNS_6_IND_CD                = "Diagnosis Present on Admission Indicator 6"
        POA_DGNS_7_IND_CD                = "Diagnosis Present on Admission Indicator 7"
        POA_DGNS_8_IND_CD                = "Diagnosis Present on Admission Indicator 8"
        POA_DGNS_9_IND_CD                = "Diagnosis Present on Admission Indicator 9"
        POA_DGNS_10_IND_CD               = "Diagnosis Present on Admission Indicator 10"
        POA_DGNS_11_IND_CD               = "Diagnosis Present on Admission Indicator 11"
        POA_DGNS_12_IND_CD               = "Diagnosis Present on Admission Indicator 12"
        POA_DGNS_13_IND_CD               = "Diagnosis Present on Admission Indicator 13"
        POA_DGNS_14_IND_CD               = "Diagnosis Present on Admission Indicator 14"
        POA_DGNS_15_IND_CD               = "Diagnosis Present on Admission Indicator 15"
        POA_DGNS_16_IND_CD               = "Diagnosis Present on Admission Indicator 16"
        POA_DGNS_17_IND_CD               = "Diagnosis Present on Admission Indicator 17"
        POA_DGNS_18_IND_CD               = "Diagnosis Present on Admission Indicator 18"
        POA_DGNS_19_IND_CD               = "Diagnosis Present on Admission Indicator 19"
        POA_DGNS_20_IND_CD               = "Diagnosis Present on Admission Indicator 20"
        POA_DGNS_21_IND_CD               = "Diagnosis Present on Admission Indicator 21"
        POA_DGNS_22_IND_CD               = "Diagnosis Present on Admission Indicator 22"
        POA_DGNS_23_IND_CD               = "Diagnosis Present on Admission Indicator 23"
        POA_DGNS_24_IND_CD               = "Diagnosis Present on Admission Indicator 24"
        POA_DGNS_25_IND_CD               = "Diagnosis Present on Admission Indicator 25"
        DGNS_E_CD_CNT                    = "MEDPAR Diagnosis E Code Count"
        DGNS_E_VRSN_CD                   = "MEDPAR Diagnosis E Version Code (Earlier Version)"
        DGNS_E_VRSN_CD_1                 = "MEDPAR Diagnosis E Version Code 01"
        DGNS_E_VRSN_CD_2                 = "MEDPAR Diagnosis E Version Code 02"
        DGNS_E_VRSN_CD_3                 = "MEDPAR Diagnosis E Version Code 03"
        DGNS_E_VRSN_CD_4                 = "MEDPAR Diagnosis E Version Code 04"
        DGNS_E_VRSN_CD_5                 = "MEDPAR Diagnosis E Version Code 05"
        DGNS_E_VRSN_CD_6                 = "MEDPAR Diagnosis E Version Code 06"
        DGNS_E_VRSN_CD_7                 = "MEDPAR Diagnosis E Version Code 07"
        DGNS_E_VRSN_CD_8                 = "MEDPAR Diagnosis E Version Code 08"
        DGNS_E_VRSN_CD_9                 = "MEDPAR Diagnosis E Version Code 09"
        DGNS_E_VRSN_CD_10                = "MEDPAR Diagnosis E Version Code 10"
        DGNS_E_VRSN_CD_11                = "MEDPAR Diagnosis E Version Code 11"
        DGNS_E_VRSN_CD_12                = "MEDPAR Diagnosis E Version Code 12"
        DGNS_E_1_CD                      = "E Diagnosis Code 1 - Extrnl cause of injury, poisoning, or oth adverse effect"
        DGNS_E_2_CD                      = "E Diagnosis Code 2 - Extrnl cause of injury, poisoning, or oth adverse effect"
        DGNS_E_3_CD                      = "E Diagnosis Code 3 - Extrnl cause of injury, poisoning, or oth adverse effect"
        DGNS_E_4_CD                      = "E Diagnosis Code 4 - Extrnl cause of injury, poisoning, or oth adverse effect"
        DGNS_E_5_CD                      = "E Diagnosis Code 5 - Extrnl cause of injury, poisoning, or oth adverse effect"
        DGNS_E_6_CD                      = "E Diagnosis Code 6 - Extrnl cause of injury, poisoning, or oth adverse effect"
        DGNS_E_7_CD                      = "E Diagnosis Code 7 - Extrnl cause of injury, poisoning, or oth adverse effect"
        DGNS_E_8_CD                      = "E Diagnosis Code 8 - Extrnl cause of injury, poisoning, or oth adverse effect"
        DGNS_E_9_CD                      = "E Diagnosis Code 9 - Extrnl cause of injury, poisoning, or oth adverse effect"
        DGNS_E_10_CD                     = "E Diagnosis Code 10 - Extrnl cause of injury, poisoning, or oth adverse effect"
        DGNS_E_11_CD                     = "E Diagnosis Code 11 - Extrnl cause of injury, poisoning, or oth adverse effect"
        DGNS_E_12_CD                     = "E Diagnosis Code 12 - Extrnl cause of injury, poisoning, or oth adverse effect"
        POA_DGNS_E_CD_CNT                = "MEDPAR Claim Present on Admission Diagnosis E Code Count"
        POA_DGNS_E_1_IND_CD              = "Diagnosis E Code Present on Admission Indicator 1"
        POA_DGNS_E_2_IND_CD              = "Diagnosis E Code Present on Admission Indicator 2"
        POA_DGNS_E_3_IND_CD              = "Diagnosis E Code Present on Admission Indicator 3"
        POA_DGNS_E_4_IND_CD              = "Diagnosis E Code Present on Admission Indicator 4"
        POA_DGNS_E_5_IND_CD              = "Diagnosis E Code Present on Admission Indicator 5"
        POA_DGNS_E_6_IND_CD              = "Diagnosis E Code Present on Admission Indicator 6"
        POA_DGNS_E_7_IND_CD              = "Diagnosis E Code Present on Admission Indicator 7"
        POA_DGNS_E_8_IND_CD              = "Diagnosis E Code Present on Admission Indicator 8"
        POA_DGNS_E_9_IND_CD              = "Diagnosis E Code Present on Admission Indicator 9"
        POA_DGNS_E_10_IND_CD             = "Diagnosis E Code Present on Admission Indicator 10"
        POA_DGNS_E_11_IND_CD             = "Diagnosis E Code Present on Admission Indicator 11"
        POA_DGNS_E_12_IND_CD             = "Diagnosis E Code Present on Admission Indicator 12"
        SRGCL_PRCDR_IND_SW               = "Surgical procedures indicator"
        SRGCL_PRCDR_CD_CNT               = "Surgical procedure codes included in stay"
        SRGCL_PRCDR_VRSN_CD              = "MEDPAR Surgical Procedure Version Code (Earlier Version)"
        SRGCL_PRCDR_VRSN_CD_1            = "MEDPAR Surgical Procedure Version Code 01"
        SRGCL_PRCDR_VRSN_CD_2            = "MEDPAR Surgical Procedure Version Code 02"
        SRGCL_PRCDR_VRSN_CD_3            = "MEDPAR Surgical Procedure Version Code 03"
        SRGCL_PRCDR_VRSN_CD_4            = "MEDPAR Surgical Procedure Version Code 04"
        SRGCL_PRCDR_VRSN_CD_5            = "MEDPAR Surgical Procedure Version Code 05"
        SRGCL_PRCDR_VRSN_CD_6            = "MEDPAR Surgical Procedure Version Code 06"
        SRGCL_PRCDR_VRSN_CD_7            = "MEDPAR Surgical Procedure Version Code 07"
        SRGCL_PRCDR_VRSN_CD_8            = "MEDPAR Surgical Procedure Version Code 08"
        SRGCL_PRCDR_VRSN_CD_9            = "MEDPAR Surgical Procedure Version Code 09"
        SRGCL_PRCDR_VRSN_CD_10           = "MEDPAR Surgical Procedure Version Code 10"
        SRGCL_PRCDR_VRSN_CD_11           = "MEDPAR Surgical Procedure Version Code 11"
        SRGCL_PRCDR_VRSN_CD_12           = "MEDPAR Surgical Procedure Version Code 12"
        SRGCL_PRCDR_VRSN_CD_13           = "MEDPAR Surgical Procedure Version Code 13"
        SRGCL_PRCDR_VRSN_CD_14           = "MEDPAR Surgical Procedure Version Code 14"
        SRGCL_PRCDR_VRSN_CD_15           = "MEDPAR Surgical Procedure Version Code 15"
        SRGCL_PRCDR_VRSN_CD_16           = "MEDPAR Surgical Procedure Version Code 16"
        SRGCL_PRCDR_VRSN_CD_17           = "MEDPAR Surgical Procedure Version Code 17"
        SRGCL_PRCDR_VRSN_CD_18           = "MEDPAR Surgical Procedure Version Code 18"
        SRGCL_PRCDR_VRSN_CD_19           = "MEDPAR Surgical Procedure Version Code 19"
        SRGCL_PRCDR_VRSN_CD_20           = "MEDPAR Surgical Procedure Version Code 20"
        SRGCL_PRCDR_VRSN_CD_21           = "MEDPAR Surgical Procedure Version Code 21"
        SRGCL_PRCDR_VRSN_CD_22           = "MEDPAR Surgical Procedure Version Code 22"
        SRGCL_PRCDR_VRSN_CD_23           = "MEDPAR Surgical Procedure Version Code 23"
        SRGCL_PRCDR_VRSN_CD_24           = "MEDPAR Surgical Procedure Version Code 24"
        SRGCL_PRCDR_VRSN_CD_25           = "MEDPAR Surgical Procedure Version Code 25"
        SRGCL_PRCDR_1_CD                 = "Principal Procedure code"
        SRGCL_PRCDR_2_CD                 = "Procedure Code II"
        SRGCL_PRCDR_3_CD                 = "Procedure Code III"
        SRGCL_PRCDR_4_CD                 = "Procedure Code IV"
        SRGCL_PRCDR_5_CD                 = "Procedure Code V"
        SRGCL_PRCDR_6_CD                 = "Procedure Code VI"
        SRGCL_PRCDR_7_CD                 = "Procedure Code VII"
        SRGCL_PRCDR_8_CD                 = "Procedure Code VIII"
        SRGCL_PRCDR_9_CD                 = "Procedure Code IX"
        SRGCL_PRCDR_10_CD                = "Procedure Code X"
        SRGCL_PRCDR_11_CD                = "Procedure Code XI"
        SRGCL_PRCDR_12_CD                = "Procedure Code XII"
        SRGCL_PRCDR_13_CD                = "Procedure Code XIII"
        SRGCL_PRCDR_14_CD                = "Procedure Code XIV"
        SRGCL_PRCDR_15_CD                = "Procedure Code XV"
        SRGCL_PRCDR_16_CD                = "Procedure Code XVI"
        SRGCL_PRCDR_17_CD                = "Procedure Code XVII"
        SRGCL_PRCDR_18_CD                = "Procedure Code XVIII"
        SRGCL_PRCDR_19_CD                = "Procedure Code XIX"
        SRGCL_PRCDR_20_CD                = "Procedure Code XX"
        SRGCL_PRCDR_21_CD                = "Procedure Code XXI"
        SRGCL_PRCDR_22_CD                = "Procedure Code XXII"
        SRGCL_PRCDR_23_CD                = "Procedure Code XXIII"
        SRGCL_PRCDR_24_CD                = "Procedure Code XXIV"
        SRGCL_PRCDR_25_CD                = "Procedure Code XXV"
        SRGCL_PRCDR_DT_CNT               = "Dates associated with surgical procedures included in stay"
        SRGCL_PRCDR_PRFRM_1_DT           = "Principal Procedure Date"
        SRGCL_PRCDR_PRFRM_2_DT           = "Procedure Date II"
        SRGCL_PRCDR_PRFRM_3_DT           = "Procedure Date III"
        SRGCL_PRCDR_PRFRM_4_DT           = "Procedure Date IV"
        SRGCL_PRCDR_PRFRM_5_DT           = "Procedure Date V"
        SRGCL_PRCDR_PRFRM_6_DT           = "Procedure Date VI"
        SRGCL_PRCDR_PRFRM_7_DT           = "Procedure Date VII"
        SRGCL_PRCDR_PRFRM_8_DT           = "Procedure Date VIII"
        SRGCL_PRCDR_PRFRM_9_DT           = "Procedure Date IX"
        SRGCL_PRCDR_PRFRM_10_DT          = "Procedure Date X"
        SRGCL_PRCDR_PRFRM_11_DT          = "Procedure Date XI"
        SRGCL_PRCDR_PRFRM_12_DT          = "Procedure Date XII"
        SRGCL_PRCDR_PRFRM_13_DT          = "Procedure Date XIII"
        SRGCL_PRCDR_PRFRM_14_DT          = "Procedure Date XIV"
        SRGCL_PRCDR_PRFRM_15_DT          = "Procedure Date XV"
        SRGCL_PRCDR_PRFRM_16_DT          = "Procedure Date XVI"
        SRGCL_PRCDR_PRFRM_17_DT          = "Procedure Date XVII"
        SRGCL_PRCDR_PRFRM_18_DT          = "Procedure Date XVIII"
        SRGCL_PRCDR_PRFRM_19_DT          = "Procedure Date XIX"
        SRGCL_PRCDR_PRFRM_20_DT          = "Procedure Date XX"
        SRGCL_PRCDR_PRFRM_21_DT          = "Procedure Date XXI"
        SRGCL_PRCDR_PRFRM_22_DT          = "Procedure Date XXII"
        SRGCL_PRCDR_PRFRM_23_DT          = "Procedure Date XXIII"
        SRGCL_PRCDR_PRFRM_24_DT          = "Procedure Date XXIV"
        SRGCL_PRCDR_PRFRM_25_DT          = "Procedure Date XXV"
        CLM_PTNT_RLTNSHP_CD              = "Claim Patient Relationship Code"
        CARE_IMPRVMT_MODEL_1_CD          = "Care Improvement Model 1 Code"
        CARE_IMPRVMT_MODEL_2_CD          = "Care Improvement Model 2 Code"
        CARE_IMPRVMT_MODEL_3_CD          = "Care Improvement Model 3 Code"
        CARE_IMPRVMT_MODEL_4_CD          = "Care Improvement Model 4 Code"
        VBP_PRTCPNT_IND_CD               = "VBP Participant Indicator Code"
        HRR_PRTCPNT_IND_CD               = "HRR Participant Indicator Code"
        BNDLD_MODEL_DSCNT_PCT            = "Bundled Model Discount Percent"
        VBP_ADJSTMT_PCT                  = "VBP Adjustment Percent"
        HRR_ADJSTMT_PCT                  = "HRR Adjustment Percent"
        INFRMTL_ENCTR_IND_SW             = "Informational Encounter Indicator Switch"
        MA_TCHNG_IND_SW                  = "MA Teaching Indicator Switch"
        PROD_RPLCMT_LIFECYC_SW           = "Prod Replacement Lifecycle Switch"
        PROD_RPLCMT_RCLL_SW              = "Prod Replacement Recall Switch"
        CRED_RCVD_RPLCD_DVC_SW           = "Credit Received Replaced Device Switch"
        OBSRVTN_SW                       = "Observation Switch"
        NEW_TCHNLGY_ADD_ON_AMT           = "New Technology Add-On Amount"
        BASE_OPRTG_DRG_AMT               = "Base Operating DRG Amount"
        OPRTG_HSP_AMT                    = "Operating Hospital Amount"
        MDCL_SRGCL_GNRL_AMT              = "Medical/Surgical General Amount"
        MDCL_SRGCL_NSTRL_AMT             = "Medical/Surgical Non-Sterile Amount"
        MDCL_SRGCL_STRL_AMT              = "Medical/Surgical Sterile Amount"
        TAKE_HOME_AMT                    = "Take Home Amount"
        PRSTHTC_ORTHTC_AMT               = "Prosthetic Orthotic Amount"
        MDCL_SRGCL_PCMKR_AMT             = "Medical/Surgical Pacemaker Amount"
        INTRAOCULAR_LENS_AMT             = "Intraocular Lens Amount"
        OXYGN_TAKE_HOME_AMT              = "Oxygen Take Home Amount"
        OTHR_IMPLANTS_AMT                = "Other Implants Amount"
        OTHR_SUPLIES_DVC_AMT             = "Other Supplies Device Amount"
        INCDNT_RDLGY_AMT                 = "Incident Radiology Amount"
        INCDNT_DGNSTC_SRVCS_AMT          = "Incident Diagnostic Services Amount"
        MDCL_SRGCL_DRSNG_AMT             = "Medical/Surgical Dressing Amount"
        INVSTGTNL_DVC_AMT                = "Investigational Device Amount"
        MDCL_SRGCL_MISC_AMT              = "Medical/Surgical Miscellaneous Amount"
        RDLGY_ONCOLOGY_AMT               = "Radiology/Oncology Amount"
        RDLGY_DGNSTC_AMT                 = "Radiology Diagnostic Amount"
        RDLGY_THRPTC_AMT                 = "Radiology Therapeutic Amount"
        RDLGY_NUCLR_MDCN_AMT             = "Radiology Nuclear Medicine Amount"
        RDLGY_CT_SCAN_AMT                = "Radiology CT Scan Amount"
        RDLGY_OTHR_IMGNG_AMT             = "Radiology Other Imaging Amount"
        OPRTG_ROOM_AMT                   = "Operating Room Amount"
        OR_LABOR_DLVRY_AMT               = "O/R Labor Delivery Amount"
        CRDC_CATHRZTN_AMT                = "Cardiac Catheterization Amount"
        SQSTRTN_RDCTN_AMT                = "Sequestration Reduction Amount"
        UNCOMPD_CARE_PYMT_AMT            = "Uncompensated Care Payment Amount"
        BNDLD_ADJSTMT_AMT                = "Bundled Adjustment Amount"
        VBP_ADJSTMT_AMT                  = "Hospital Value Based Purchasing (VBP) Amount"
        HRR_ADJSTMT_AMT                  = "Hospital Readmission Reduction (HRR) Adjustment Amount"
        EHR_PYMT_ADJSTMT_AMT             = "Electronic Health Record (EHR) Payment Adjustment Amount"
        PPS_STD_VAL_PYMT_AMT             = "Claim PPS Standard Value Payment Amount"
        FINL_STD_AMT                     = "Claim Final Standard Amount"
        HAC_RDCTN_PMT_AMT                = "Hospital Acquired Conditions Reduction Payment Amount (IPPS_FLEX_PYMT_6_AMT)"
        IPPS_FLEX_PYMT_7_AMT             = "IPPS Flexible Payment Amount II"
        PTNT_ADD_ON_PYMT_AMT             = "Revenue Center Patient/Initial Visit Add-On Amount"
        HAC_PGM_RDCTN_IND_SW             = "Hospital Acquired Conditions (HAC) Program Reduction Indicator Switch"
        PGM_RDCTN_IND_SW                 = "Electronic Health Records (EHR) Program Reduction Indicator Switch"
        PA_IND_CD                        = "Claim Prior Authorization Indicator Code"
        UNIQ_TRKNG_NUM                   = "Claim Unique Tracking Number"
        STAY_2_IND_SW                    = "Stay 2 Indicator Switch"
        CLM_SITE_NTRL_PYMT_CST_AMT       = "Claim Site Neutral Payment Based on Cost Amount"
        CLM_SITE_NTRL_PYMT_IPPS_AMT      = "Claim Site Neutral Payment Based on IPPS Amount"
        CLM_FULL_STD_PYMT_AMT            = "Claim Full Standard Payment Amount"
        CLM_SS_OUTLIER_STD_PYMT_AMT      = "Claim Short Stay Outlier (SSO) Standard Payment Amount"
        CLM_NGACO_IND_1_CD               = "Claim Next Generation (NG) Accountable Care Organization (ACO) Indicator Code 1"
        CLM_NGACO_IND_2_CD               = "Claim Next Generation (NG) Accountable Care Organization (ACO) Indicator Code 2"
        CLM_NGACO_IND_3_CD               = "Claim Next Generation (NG) Accountable Care Organization (ACO) Indicator Code 3"
        CLM_NGACO_IND_4_CD               = "Claim Next Generation (NG) Accountable Care Organization (ACO) Indicator Code 4"
        CLM_NGACO_IND_5_CD               = "Claim Next Generation (NG) Accountable Care Organization (ACO) Indicator Code 5"
        CLM_RSDL_PYMT_IND_CD             = "Claim Residual Payment Indicator Code"
        CLM_RP_IND_CD                    = "Claim Representative Payee (RP) Indicator Code"
        RC_RP_IND_CD                     = "Revenue Center Representative Payee (RP) Indicator Code"
        ACO_ID_NUM                       = "Accountable Care Organization (ACO) Identification Number"
        RC_ALLOGENEIC_STEM_CELL_AMT      = "Revenue Center Allogeneic Stem Cell Acquisition/Donor Services Amount"
        ISLET_ADD_ON_PYMT_AMT            = "Islet Add-On Payment Amount"
        CLM_IP_INITL_MS_DRG_CD           = "Claim Inpatient Initial MS-DRG Code"
        VAL_CD_Q1_PYMT_RDCTN_AMT         = "Value Code Q1 Payment Reduction Amount"
        CLM_MODEL_REIMBRSMT_AMT          = "Claim Model Reimbursement Amount"
        RC_MODEL_REIMBRSMT_AMT           = "Revenue Center Model Reimbursement Amount"
        VAL_CD_QB_OCM_PYMT_ADJSTMT_AMT   = "Value Code QB OCM + Payment Adjustment Amount"
        CELL_GENE_THRPY_PRCDRS_TOT_AMT   = "Cell/Gene Therapy Procedures Total Charge Amount"
        CELL_THRPY_DRUGS_TOT_AMT         = "Cell Therapy Drugs Total Charge Amount"
        GENE_THRPY_DRUGS_TOT_AMT         = "Gene Therapy Drugs Total Charge Amount"
        LTCH_DPP_ADJSTMT_AMT             = "Long Term Care Hospital Discharge Payment Percentage Adjustment Amount"
        RC_NDC_1_CD                      = "Revenue Center National Drug Code (NDC) 1"
        RC_NDC_2_CD                      = "Revenue Center National Drug Code (NDC) 2"
        RC_NDC_3_CD                      = "Revenue Center National Drug Code (NDC) 3"
        RC_NDC_4_CD                      = "Revenue Center National Drug Code (NDC) 4"
        RC_NDC_5_CD                      = "Revenue Center National Drug Code (NDC) 5"
        RC_NDC_6_CD                      = "Revenue Center National Drug Code (NDC) 6"
        RC_NDC_7_CD                      = "Revenue Center National Drug Code (NDC) 7"
        RC_NDC_8_CD                      = "Revenue Center National Drug Code (NDC) 8"
        RC_NDC_9_CD                      = "Revenue Center National Drug Code (NDC) 9"
        RC_NDC_10_CD                     = "Revenue Center National Drug Code (NDC) 10"
    ;
run;

proc contents data=seer.medpar position;
run;




/* NCH Files */

filename nchbase  'S:\JamieHeyward\Dissertation Aim 2 SEER Medicare Cohort Study\SEERMed_IRAE\SEER Medicare irAE 2013-2019\nch*.base.txt';                   /*reading in an un-zipped file*/
*filename nchbase pipe 'gunzip -c /directory/nch2019.base.txt.gz';  /*reading in a zipped file*/
*filename nchbase pipe 'gunzip -c /directory/nch*.base.txt.gz';     /*using wildcard to match multiple files */
options nocenter validvarname=upcase;

data seer.nchbase;
  infile nchbase lrecl=395 missover pad;
  INPUT
     @001  PATIENT_ID                       $char15. /* Patient ID (for either Cancer or Non-Cancer Patients) */
     @016  CLM_ID                           $char15.  /*  Encrypted  */
     @031  NCH_NEAR_LINE_REC_IDENT_CD       $char1.
     @032  NCH_CLM_TYPE_CD                  $char2.
     @034  CLM_FROM_DT                      $char8.  /*  YYMMDD8  */
     @042  CLM_THRU_DT                      $char8.  /*  YYMMDD8  */
     @050  NCH_WKLY_PROC_DT                 $char8.  /*  YYMMDD8  */
     @058  CARR_CLM_ENTRY_CD                $char1.
     @059  CLM_DISP_CD                      $char2.
     @061  CARR_NUM                         $char5.
     @066  CARR_CLM_PMT_DNL_CD              $char2.
     @068  CLM_PMT_AMT                      12.2
     @080  CARR_CLM_PRMRY_PYR_PD_AMT        12.2
     @092  RFR_PHYSN_UPIN                   $char6.   /*  Encrypted  */
     @104  RFR_PHYSN_NPI                    $char10.  /*  Encrypted  */
     @116  CARR_CLM_PRVDR_ASGNMT_IND_SW     $char1.
     @117  NCH_CLM_PRVDR_PMT_AMT            12.2
     @129  NCH_CLM_BENE_PMT_AMT             12.2
     @141  NCH_CARR_CLM_SBMTD_CHRG_AMT      12.2
     @153  NCH_CARR_CLM_ALOWD_AMT           12.2
     @165  CARR_CLM_CASH_DDCTBL_APLD_AMT    12.2
     @177  CARR_CLM_HCPCS_YR_CD             $char1.
     @178  CARR_CLM_RFRNG_PIN_NUM           $char10.  /*  Encrypted  */
     @192  PRNCPAL_DGNS_CD                  $char7.
     @199  PRNCPAL_DGNS_VRSN_CD             $char1.
     @200  ICD_DGNS_CD1                     $char7.
     @207  ICD_DGNS_VRSN_CD1                $char1.
     @208  ICD_DGNS_CD2                     $char7.
     @215  ICD_DGNS_VRSN_CD2                $char1.
     @216  ICD_DGNS_CD3                     $char7.
     @223  ICD_DGNS_VRSN_CD3                $char1.
     @224  ICD_DGNS_CD4                     $char7.
     @231  ICD_DGNS_VRSN_CD4                $char1.
     @232  ICD_DGNS_CD5                     $char7.
     @239  ICD_DGNS_VRSN_CD5                $char1.
     @240  ICD_DGNS_CD6                     $char7.
     @247  ICD_DGNS_VRSN_CD6                $char1.
     @248  ICD_DGNS_CD7                     $char7.
     @255  ICD_DGNS_VRSN_CD7                $char1.
     @256  ICD_DGNS_CD8                     $char7.
     @263  ICD_DGNS_VRSN_CD8                $char1.
     @264  ICD_DGNS_CD9                     $char7.
     @271  ICD_DGNS_VRSN_CD9                $char1.
     @272  ICD_DGNS_CD10                    $char7.
     @279  ICD_DGNS_VRSN_CD10               $char1.
     @280  ICD_DGNS_CD11                    $char7.
     @287  ICD_DGNS_VRSN_CD11               $char1.
     @288  ICD_DGNS_CD12                    $char7.
     @295  ICD_DGNS_VRSN_CD12               $char1.
     @296  CLM_CLNCL_TRIL_NUM               $char8.
     @304  DOB_YEAR                         $char4.
     @312  GNDR_CD                          $char1.
     @313  BENE_RACE_CD                     $char1.
     @314  BENE_CNTY_CD                     $char3.
     @317  BENE_STATE_CD                    $char2.
     @319  BENE_MLG_CNTCT_ZIP_CD            $char9.   /*  Encrypted  */
     @328  CLM_BENE_PD_AMT                  12.2
     @340  CPO_PRVDR_NUM                    $CHAR12.
     @352  CPO_ORG_NPI_NUM                  $CHAR10.  /*  Encrypted  */
     @362  CARR_CLM_BLG_NPI_NUM             $CHAR10.  /*  Encrypted  */
     @372  ACO_ID_NUM                       $CHAR10.  /*  Encrypted  */
     @382  CARR_CLM_SOS_NPI_NUM             $CHAR10.  /*  Encrypted  */
     @392  CLM_BENE_ID_TYPE_CD              $CHAR1.
     @393  CLM_RSDL_PYMT_IND_CD             $CHAR1.
     @394  PRVDR_VLDTN_TYPE_CD              $CHAR2.
    ;

  label
     patient_id = "Patient ID"
     CLM_ID                           = "Encrypted Claim ID"
     NCH_NEAR_LINE_REC_IDENT_CD       = "NCH Near Line Record Identification Code"
     NCH_CLM_TYPE_CD                  = "NCH Claim Type Code"
     CLM_FROM_DT                      = "Claim From Date"
     CLM_THRU_DT                      = "Claim Through Date (Determines Year of Claim)"
     NCH_WKLY_PROC_DT                 = "NCH Weekly Claim Processing Date"
     CARR_CLM_ENTRY_CD                = "Carrier Claim Entry Code"
     CLM_DISP_CD                      = "Claim Disposition Code"
     CARR_NUM                         = "Carrier Number"
     CARR_CLM_PMT_DNL_CD              = "Carrier Claim Payment Denial Code"
     CLM_PMT_AMT                      = "Claim Payment Amount"
     CARR_CLM_PRMRY_PYR_PD_AMT        = "Carrier Claim Primary Payer Paid Amount"
     RFR_PHYSN_UPIN                   = "Carrier Claim Referring Physician UPIN Number"
     RFR_PHYSN_NPI                    = "Carrier Claim Referring Physician NPI Number"
     CARR_CLM_PRVDR_ASGNMT_IND_SW     = "Carrier Claim Provider Assignment Indicator Switch"
     NCH_CLM_PRVDR_PMT_AMT            = "NCH Claim Provider Payment Amount"
     NCH_CLM_BENE_PMT_AMT             = "NCH Claim Beneficiary Payment Amount"
     NCH_CARR_CLM_SBMTD_CHRG_AMT      = "NCH Carrier Claim Submitted Charge Amount"
     NCH_CARR_CLM_ALOWD_AMT           = "NCH Carrier Claim Allowed Charge Amount"
     CARR_CLM_CASH_DDCTBL_APLD_AMT    = "Carrier Claim Cash Deductible Applied Amount"
     CARR_CLM_HCPCS_YR_CD             = "Carrier Claim HCPCS Year Code"
     CARR_CLM_RFRNG_PIN_NUM           = "Carrier Claim Referring PIN Number"
     PRNCPAL_DGNS_CD                  = "Primary Claim Diagnosis Code"
     PRNCPAL_DGNS_VRSN_CD             = "Primary Claim Diagnosis Code Diagnosis Version Code (ICD-9 or ICD-10)"
     ICD_DGNS_CD1                     = "Claim Diagnosis Code I"
     ICD_DGNS_VRSN_CD1                = "Claim Diagnosis Code I Diagnosis Version Code (ICD-9 or ICD-10)"
     ICD_DGNS_CD2                     = "Claim Diagnosis Code II"
     ICD_DGNS_VRSN_CD2                = "Claim Diagnosis Code II Diagnosis Version Code (ICD-9 or ICD-10)"
     ICD_DGNS_CD3                     = "Claim Diagnosis Code III"
     ICD_DGNS_VRSN_CD3                = "Claim Diagnosis Code III Diagnosis Version Code (ICD-9 or ICD-10)"
     ICD_DGNS_CD4                     = "Claim Diagnosis Code IV"
     ICD_DGNS_VRSN_CD4                = "Claim Diagnosis Code IV Diagnosis Version Code (ICD-9 or ICD-10)"
     ICD_DGNS_CD5                     = "Claim Diagnosis Code V"
     ICD_DGNS_VRSN_CD5                = "Claim Diagnosis Code V Diagnosis Version Code (ICD-9 or ICD-10)"
     ICD_DGNS_CD6                     = "Claim Diagnosis Code VI"
     ICD_DGNS_VRSN_CD6                = "Claim Diagnosis Code VI Diagnosis Version Code (ICD-9 or ICD-10)"
     ICD_DGNS_CD7                     = "Claim Diagnosis Code VII"
     ICD_DGNS_VRSN_CD7                = "Claim Diagnosis Code VII Diagnosis Version Code (ICD-9 or ICD-10)"
     ICD_DGNS_CD8                     = "Claim Diagnosis Code VIII"
     ICD_DGNS_VRSN_CD8                = "Claim Diagnosis Code VIII Diagnosis Version Code (ICD-9 or ICD-10)"
     ICD_DGNS_CD9                     = "Claim Diagnosis Code IX"
     ICD_DGNS_VRSN_CD9                = "Claim Diagnosis Code IX Diagnosis Version Code (ICD-9 or ICD-10)"
     ICD_DGNS_CD10                    = "Claim Diagnosis Code X"
     ICD_DGNS_VRSN_CD10               = "Claim Diagnosis Code X Diagnosis Version Code (ICD-9 or ICD-10)"
     ICD_DGNS_CD11                    = "Claim Diagnosis Code XI"
     ICD_DGNS_VRSN_CD11               = "Claim Diagnosis Code XI Diagnosis Version Code (ICD-9 or ICD-10)"
     ICD_DGNS_CD12                    = "Claim Diagnosis Code XII"
     ICD_DGNS_VRSN_CD12               = "Claim Diagnosis Code XII Diagnosis Version Code (ICD-9 or ICD-10)"
     CLM_CLNCL_TRIL_NUM               = "Clinical Trial Number"
     DOB_YEAR                         = "Year of Birth from Claim (Date)"
     GNDR_CD                          = "Gender Code from Claim"
     BENE_RACE_CD                     = "Race Code from Claim"
     BENE_CNTY_CD                     = "County Code from Claim (SSA)"
     BENE_STATE_CD                    = "State Code from Claim (SSA)"
     BENE_MLG_CNTCT_ZIP_CD            = "Zip Code of Residence from Claim"
     CLM_BENE_PD_AMT                  = "Carrier Claim Beneficiary Paid Amount"
     CPO_PRVDR_NUM                    = "Care Plan Oversight (CPO) Provider Number"
     CPO_ORG_NPI_NUM                  = "CPO Organization NPI Number"
     CARR_CLM_BLG_NPI_NUM             = "Carrier Claim Billing NPI Number"
     ACO_ID_NUM                       = "Claim Accountable Care Organization (ACO) Identification Number"
     CARR_CLM_SOS_NPI_NUM             = "Carrier Claim Site of Service NPI Number"
     CLM_BENE_ID_TYPE_CD              = "For CMS Internal Use Only"
     CLM_RSDL_PYMT_IND_CD             = "Claim Residual Payment Indicator Code"
     PRVDR_VLDTN_TYPE_CD              = "Provider Validation Type Code"
    ;
run;

proc contents data=seer.nchbase position;
Title 'proc contents, NCH (Carrier) Dase file';
run;



filename nchline  'S:\JamieHeyward\Dissertation Aim 2 SEER Medicare Cohort Study\SEERMed_IRAE\SEER Medicare irAE 2013-2019\nch*.line.txt';                   /*reading in an un-zipped file*/
*filename nchline pipe 'gunzip -c /directory/nch2019.line.txt.gz';  /*reading in a zipped file*/
*filename nchline pipe 'gunzip -c /directory/nch*.line.txt.gz';     /*using wildcard to match multiple files */
options nocenter validvarname=upcase;

data seer.nchline;
  infile nchline lrecl=519 missover pad;
  INPUT
     @001  PATIENT_ID                       $char15. /* Patient ID (for either Cancer or Non-Cancer Patients) */
     @016  CLM_ID                           $char15.  /*  Encrypted  */
     @031  LINE_NUM                         $char13.
     @044  NCH_CLM_TYPE_CD                  $char2.
     @046  CLM_THRU_DT                      $char8.  /*  YYMMDD8  */
     @054  CARR_PRFRNG_PIN_NUM              $char10.  /*  Encrypted  */
     @069  PRF_PHYSN_UPIN                   $char6.   /*  Encrypted  */
     @081  PRF_PHYSN_NPI                    $char10.  /*  Encrypted  */
     @093  ORG_NPI_NUM                      $char10.  /*  Encrypted  */
     @103  CARR_LINE_PRVDR_TYPE_CD          $char1.
     @104  TAX_NUM                          $char10.  /*  Encrypted  */
     @114  PRVDR_STATE_CD                   $char2.
     @116  PRVDR_ZIP                        $char9.   /*  Encrypted  */
     @125  PRVDR_SPCLTY                     $char3.
     @128  PRTCPTNG_IND_CD                  $char1.
     @129  CARR_LINE_RDCD_PMT_PHYS_ASTN_C   $char1.
     @130  LINE_SRVC_CNT                    11.3
     @141  LINE_CMS_TYPE_SRVC_CD            $char1.
     @142  LINE_PLACE_OF_SRVC_CD            $char2.
     @144  CARR_LINE_PRCNG_LCLTY_CD         $char2.
     @146  LINE_1ST_EXPNS_DT                $char8.  /*  YYMMDD8  */
     @154  LINE_LAST_EXPNS_DT               $char8.  /*  YYMMDD8  */
     @162  HCPCS_CD                         $char5.
     @167  HCPCS_1ST_MDFR_CD                $char5.
     @172  HCPCS_2ND_MDFR_CD                $char5.
     @177  BETOS_CD                         $char3.
     @180  LINE_NCH_PMT_AMT                 12.2
     @192  LINE_BENE_PMT_AMT                12.2
     @204  LINE_PRVDR_PMT_AMT               12.2
     @216  LINE_BENE_PTB_DDCTBL_AMT         12.2
     @228  LINE_BENE_PRMRY_PYR_CD           $char1.
     @229  LINE_BENE_PRMRY_PYR_PD_AMT       12.2
     @241  LINE_COINSRNC_AMT                12.2
     @253  LINE_SBMTD_CHRG_AMT              12.2
     @265  LINE_ALOWD_CHRG_AMT              12.2
     @277  LINE_PRCSG_IND_CD                $char2.
     @279  LINE_PMT_80_100_CD               $char1.
     @280  LINE_SERVICE_DEDUCTIBLE          $char1.
     @281  CARR_LINE_MTUS_CNT               11.3
     @292  CARR_LINE_MTUS_CD                $char1.
     @293  LINE_ICD_DGNS_CD                 $char7.
     @300  LINE_ICD_DGNS_VRSN_CD            $char1.
     @301  HPSA_SCRCTY_IND_CD               $char1.
     @302  CARR_LINE_RX_NUM                 $char30.  /*  Encrypted  */
     @332  LINE_HCT_HGB_RSLT_NUM            4.1
     @336  LINE_HCT_HGB_TYPE_CD             $char2.
     @338  LINE_NDC_CD                      $char11.
     @349  CARR_LINE_CLIA_LAB_NUM           $char10.
     @359  CARR_LINE_ANSTHSA_UNIT_CNT       11.3
     @370  CARR_LINE_CL_CHRG_AMT            12.2
     @382  PHYSN_ZIP_CD                     $CHAR15.  /*  Encrypted  */
     @397  LINE_OTHR_APLD_IND_CD1           $CHAR2.
     @399  LINE_OTHR_APLD_IND_CD2           $CHAR2.
     @401  LINE_OTHR_APLD_IND_CD3           $CHAR2.
     @403  LINE_OTHR_APLD_IND_CD4           $CHAR2.
     @405  LINE_OTHR_APLD_IND_CD5           $CHAR2.
     @407  LINE_OTHR_APLD_IND_CD6           $CHAR2.
     @409  LINE_OTHR_APLD_IND_CD7           $CHAR2.
     @411  LINE_OTHR_APLD_AMT1              12.2
     @423  LINE_OTHR_APLD_AMT2              12.2
     @435  LINE_OTHR_APLD_AMT3              12.2
     @447  LINE_OTHR_APLD_AMT4              12.2
     @459  LINE_OTHR_APLD_AMT5              12.2
     @471  LINE_OTHR_APLD_AMT6              12.2
     @483  LINE_OTHR_APLD_AMT7              12.2
     @495  THRPY_CAP_IND_CD1                $CHAR1.
     @496  THRPY_CAP_IND_CD2                $CHAR1.
     @497  THRPY_CAP_IND_CD3                $CHAR1.
     @498  THRPY_CAP_IND_CD4                $CHAR1.
     @499  THRPY_CAP_IND_CD5                $CHAR1.
     @500  CLM_NEXT_GNRTN_ACO_IND_CD1       $CHAR1.
     @501  CLM_NEXT_GNRTN_ACO_IND_CD2       $CHAR1.
     @502  CLM_NEXT_GNRTN_ACO_IND_CD3       $CHAR1.
     @503  CLM_NEXT_GNRTN_ACO_IND_CD4       $CHAR1.
     @504  CLM_NEXT_GNRTN_ACO_IND_CD5       $CHAR1.
     @505  CARR_LINE_MDPP_NPI_NUM           $CHAR10.  /*  Encrypted  */
     @515  LINE_RSDL_PYMT_IND_CD            $CHAR1.
     @516  LINE_RP_IND_CD                   $CHAR1.
     @517  LINE_PRVDR_VLDTN_TYPE_CD         $CHAR2.
     @519  LINE_VLNTRY_SRVC_IND_CD          $CHAR1.
    ;

  label
      patient_id                       = "Patient ID"
      CLM_ID                           = "Encrypted Claim ID"
      LINE_NUM                         = "Claim Line Number"
      NCH_CLM_TYPE_CD                  = "NCH Claim Type Code"
      CLM_THRU_DT                      = "Claim Through Date (Determines Year of Claim)"
      CARR_PRFRNG_PIN_NUM              = "Carrier Line Claim Performing PIN Number"
      PRF_PHYSN_UPIN                   = "Carrier Line Performing UPIN Number"
      PRF_PHYSN_NPI                    = "Carrier Line Performing NPI Number"
      ORG_NPI_NUM                      = "Carrier Line Performing Group NPI Number"
      CARR_LINE_PRVDR_TYPE_CD          = "Carrier Line Provider Type Code"
      TAX_NUM                          = "Line Provider Tax Number"
      PRVDR_STATE_CD                   = "Line NCH Provider State Code"
      PRVDR_ZIP                        = "Carrier Line Performing Provider ZIP Code"
      PRVDR_SPCLTY                     = "Line HCFA Provider Specialty Code"
      PRTCPTNG_IND_CD                  = "Line Provider Participating Indicator Code"
      CARR_LINE_RDCD_PMT_PHYS_ASTN_C   = "Carrier Line Reduced Payment Physician Assistant Code"
      LINE_SRVC_CNT                    = "Line Service Count"
      LINE_CMS_TYPE_SRVC_CD            = "Line HCFA Type Service Code"
      LINE_PLACE_OF_SRVC_CD            = "Line Place Of Service Code"
      CARR_LINE_PRCNG_LCLTY_CD         = "Carrier Line Pricing Locality Code"
      LINE_1ST_EXPNS_DT                = "Line First Expense Date"
      LINE_LAST_EXPNS_DT               = "Line Last Expense Date"
      HCPCS_CD                         = "Line Healthcare Common Procedure Coding System"
      HCPCS_1ST_MDFR_CD                = "Line HCPCS Initial Modifier Code"
      HCPCS_2ND_MDFR_CD                = "Line HCPCS Second Modifier Code"
      BETOS_CD                         = "Line NCH BETOS Code"
      LINE_NCH_PMT_AMT                 = "Line NCH Payment Amount"
      LINE_BENE_PMT_AMT                = "Line Beneficiary Payment Amount"
      LINE_PRVDR_PMT_AMT               = "Line Provider Payment Amount"
      LINE_BENE_PTB_DDCTBL_AMT         = "Line Beneficiary Part B Deductible Amount"
      LINE_BENE_PRMRY_PYR_CD           = "Line Beneficiary Primary Payer Code"
      LINE_BENE_PRMRY_PYR_PD_AMT       = "Line Beneficiary Primary Payer Paid Amount"
      LINE_COINSRNC_AMT                = "Line Coinsurance Amount"
      LINE_SBMTD_CHRG_AMT              = "Line Submitted Charge Amount"
      LINE_ALOWD_CHRG_AMT              = "Line Allowed Charge Amount"
      LINE_PRCSG_IND_CD                = "Line Processing Indicator Code"
      LINE_PMT_80_100_CD               = "Line Payment 80%/100% Code"
      LINE_SERVICE_DEDUCTIBLE          = "Line Service Deductible Indicator Switch"
      CARR_LINE_MTUS_CNT               = "Carrier Line Miles/Time/Units/Services Count"
      CARR_LINE_MTUS_CD                = "Carrier Line Miles/Time/Units/Services Indicator Code"
      LINE_ICD_DGNS_CD                 = "Line Diagnosis Code Code"
      LINE_ICD_DGNS_VRSN_CD            = "Line Diagnosis Code Diagnosis Version Code (ICD-9 or ICD-10)"
      HPSA_SCRCTY_IND_CD               = "Carrier Line HPSA/Scarcity Indicator Code"
      CARR_LINE_RX_NUM                 = "Carrier Line RX Number"
      LINE_HCT_HGB_RSLT_NUM            = "Hematocrit/Hemoglobin Test Results"
      LINE_HCT_HGB_TYPE_CD             = "Hematocrit/Hemoglobin Test Type code"
      LINE_NDC_CD                      = "Line National Drug Code"
      CARR_LINE_CLIA_LAB_NUM           = "Clinical Laboratory Improvement Amendments monitored laboratory number"
      CARR_LINE_ANSTHSA_UNIT_CNT       = "Carrier Line Anesthesia Unit Count"
      CARR_LINE_CL_CHRG_AMT            = "Carrier Line Clinical Lab Charge Amount"
      PHYSN_ZIP_CD                     = "Line Place Of Service (POS) Physician Zip Code"
      LINE_OTHR_APLD_IND_CD1           = "Line Other Applied Indicator Code 1"
      LINE_OTHR_APLD_IND_CD2           = "Line Other Applied Indicator Code 2"
      LINE_OTHR_APLD_IND_CD3           = "Line Other Applied Indicator Code 3"
      LINE_OTHR_APLD_IND_CD4           = "Line Other Applied Indicator Code 4"
      LINE_OTHR_APLD_IND_CD5           = "Line Other Applied Indicator Code 5"
      LINE_OTHR_APLD_IND_CD6           = "Line Other Applied Indicator Code 6"
      LINE_OTHR_APLD_IND_CD7           = "Line Other Applied Indicator Code 7"
      LINE_OTHR_APLD_AMT1              = "Line Other Applied Amount 1"
      LINE_OTHR_APLD_AMT2              = "Line Other Applied Amount 2"
      LINE_OTHR_APLD_AMT3              = "Line Other Applied Amount 3"
      LINE_OTHR_APLD_AMT4              = "Line Other Applied Amount 4"
      LINE_OTHR_APLD_AMT5              = "Line Other Applied Amount 5"
      LINE_OTHR_APLD_AMT6              = "Line Other Applied Amount 6"
      LINE_OTHR_APLD_AMT7              = "Line Other Applied Amount 7"
      THRPY_CAP_IND_CD1                = "Line Therapy Cap Indicator Code 1"
      THRPY_CAP_IND_CD2                = "Line Therapy Cap Indicator Code 2"
      THRPY_CAP_IND_CD3                = "Line Therapy Cap Indicator Code 3"
      THRPY_CAP_IND_CD4                = "Line Therapy Cap Indicator Code 4"
      THRPY_CAP_IND_CD5                = "Line Therapy Cap Indicator Code 5"
      CLM_NEXT_GNRTN_ACO_IND_CD1       = "Claim Next Generation Accountable Care Organization Indicator Code 1"
      CLM_NEXT_GNRTN_ACO_IND_CD2       = "Claim Next Generation Accountable Care Organization Indicator Code 2"
      CLM_NEXT_GNRTN_ACO_IND_CD3       = "Claim Next Generation Accountable Care Organization Indicator Code 3"
      CLM_NEXT_GNRTN_ACO_IND_CD4       = "Claim Next Generation Accountable Care Organization Indicator Code 4"
      CLM_NEXT_GNRTN_ACO_IND_CD5       = "Claim Next Generation Accountable Care Organization Indicator Code 5"
      CARR_LINE_MDPP_NPI_NUM           = "Carrier Line Medicare Diabetes Prevention Program (MDPP) NPI Number"
      LINE_RSDL_PYMT_IND_CD            = "Line Residual Payment Indicator Code"
      LINE_RP_IND_CD                   = "Line Representative Payee (RP) Indicator Code"
      LINE_PRVDR_VLDTN_TYPE_CD         = "Line Provider Validation Type Code"
      LINE_VLNTRY_SRVC_IND_CD          = "Line Voluntary Service Indicator Code"
    ;
run;

proc contents data=seer.nchline position;
Title 'proc contents, NCH (Carrier) Line file';
run;

filename nchdemo  'S:\JamieHeyward\Dissertation Aim 2 SEER Medicare Cohort Study\SEERMed_IRAE\SEER Medicare irAE 2013-2019\nch*.demo.txt';                   /*reading in an un-zipped file*/
*filename nchdemo pipe 'gunzip -c /directory/nch2019.demo.txt.gz';  /*reading in a zipped file*/
*filename nchdemo pipe 'gunzip -c /directory/nch*.demo.txt.gz';     /*using wildcard to match multiple files */

data seer.nchdemo;
  infile nchdemo lrecl=52 missover pad;
  input
     @001 PATIENT_ID                $char15.  /*  Patient ID (for either Cancer or Non-Cancer Patients) */
     @016 CLM_ID                    $char15.  /*  Encrypted  */
     @031 NCH_CLM_TYPE_CD           $char2.
     @033 DEMO_ID_SQNC_NUM          3.
     @036 DEMO_ID_NUM               $char2.
     @038 DEMO_INFO_TXT             $char15.
   ;

  label
    PATIENT_ID                  = "Patient ID"
    CLM_ID                      = "Encrypted Claim ID"
    NCH_CLM_TYPE_CD             = "NCH Claim Type Code"
    DEMO_ID_SQNC_NUM            = "Claim Demonstration Sequence"
    DEMO_ID_NUM                 = "Claim Demonstration Identification Number"
    DEMO_INFO_TXT               = "Claim Demonstration Information Text"
  ;
run;

proc contents data=seer.nchdemo position;
Title 'proc contents, NCH (Carrier) Demonstration/Innovation file';
run;





/* Other CCW File */


filename oth_cc 'S:\JamieHeyward\SEERMed_IRAE\SEER Medicare irAE 2013-2019\mbsf.oth.cc.summary.*.txt';                   /* reading in an un-zipped file */
*filename oth_cc pipe 'gunzip -c /directory/mbsf.oth.cc.summary.2019.txt.gz'; /* reading in a zipped file */
*filename oth_cc pipe 'gunzip -c /directory/mbsf.oth.cc.summary.*.txt.gz';  /* using wildcard to match multiple files */

options nocenter validvarname=upcase;

data seer.oth_cc;
  infile oth_cc lrecl=382 missover pad;
  input
        @00001 patient_id            $char15. /* Patient ID (for either Cancer or Non-Cancer Patients) */
        @00016 RFRNC_YR                         4.         /* BENE_ENROLLMT_REF_YR             */
        @00020 ENRL_SRC                         $3.        /* ENRL_SRC                         */
        @00023 ACP_MEDICARE                     1.
        @00024 ACP_MEDICARE_EVER                $char8.  /*  YYMMDD8  */
        @00032 ALCO_MEDICARE                    1.
        @00033 ALCO_MEDICARE_EVER               $char8.  /*  YYMMDD8  */
        @00041 ANXI_MEDICARE                    1.
        @00042 ANXI_MEDICARE_EVER               $char8.  /*  YYMMDD8  */
        @00050 AUTISM_MEDICARE                  1.
        @00051 AUTISM_MEDICARE_EVER             $char8.  /*  YYMMDD8  */
        @00059 BIPL_MEDICARE                    1.
        @00060 BIPL_MEDICARE_EVER               $char8.  /*  YYMMDD8  */
        @00068 BRAINJ_MEDICARE                  1.
        @00069 BRAINJ_MEDICARE_EVER             $char8.  /*  YYMMDD8  */
        @00077 CERPAL_MEDICARE                  1.
        @00078 CERPAL_MEDICARE_EVER             $char8.  /*  YYMMDD8  */
        @00086 CYSFIB_MEDICARE                  1.
        @00087 CYSFIB_MEDICARE_EVER             $char8.  /*  YYMMDD8  */
        @00095 DEPSN_MEDICARE                   1.
        @00096 DEPSN_MEDICARE_EVER              $char8.  /*  YYMMDD8  */
        @00104 DRUG_MEDICARE                    1.
        @00105 DRUG_MEDICARE_EVER               $char8.  /*  YYMMDD8  */
        @00113 EPILEP_MEDICARE                  1.
        @00114 EPILEP_MEDICARE_EVER             $char8.  /*  YYMMDD8  */
        @00122 FIBRO_MEDICARE                   1.
        @00123 FIBRO_MEDICARE_EVER              $char8.  /*  YYMMDD8  */
        @00131 HEARIM_MEDICARE                  1.
        @00132 HEARIM_MEDICARE_EVER             $char8.  /*  YYMMDD8  */
        @00140 HEPVIRAL_MEDICARE                1.
        @00141 HEPVIRAL_MEDICARE_EVER           $char8.  /*  YYMMDD8  */
        @00149 HIVAIDS_MEDICARE                 1.
        @00150 HIVAIDS_MEDICARE_EVER            $char8.  /*  YYMMDD8  */
        @00158 INTDIS_MEDICARE                  1.
        @00159 INTDIS_MEDICARE_EVER             $char8.  /*  YYMMDD8  */
        @00167 LEADIS_MEDICARE                  1.
        @00168 LEADIS_MEDICARE_EVER             $char8.  /*  YYMMDD8  */
        @00176 LEUKLYMPH_MEDICARE               1.
        @00177 LEUKLYMPH_MEDICARE_EVER          $char8.  /*  YYMMDD8  */
        @00185 LIVER_MEDICARE                   1.
        @00186 LIVER_MEDICARE_EVER              $char8.  /*  YYMMDD8  */
        @00194 MIGRAINE_MEDICARE                1.
        @00195 MIGRAINE_MEDICARE_EVER           $char8.  /*  YYMMDD8  */
        @00203 MOBIMP_MEDICARE                  1.
        @00204 MOBIMP_MEDICARE_EVER             $char8.  /*  YYMMDD8  */
        @00212 MULSCL_MEDICARE                  1.
        @00213 MULSCL_MEDICARE_EVER             $char8.  /*  YYMMDD8  */
        @00221 MUSDYS_MEDICARE                  1.
        @00222 MUSDYS_MEDICARE_EVER             $char8.  /*  YYMMDD8  */
        @00230 OBESITY_MEDICARE                 1.
        @00231 OBESITY_MEDICARE_EVER            $char8.  /*  YYMMDD8  */
        @00239 OTHDEL_MEDICARE                  1.
        @00240 OTHDEL_MEDICARE_EVER             $char8.  /*  YYMMDD8  */
        @00248 OUD_ANY_MEDICARE                 1.
        @00249 OUD_ANY_MEDICARE_EVER            $char8.  /*  YYMMDD8  */
        @00257 OUD_DX_MEDICARE                  1.
        @00258 OUD_DX_MEDICARE_EVER             $char8.  /*  YYMMDD8  */
        @00266 OUD_HOSP_MEDICARE                1.
        @00267 OUD_HOSP_MEDICARE_EVER           $char8.  /*  YYMMDD8  */
        @00275 OUD_MAT_MEDICARE                 1.
        @00276 OUD_MAT_MEDICARE_EVER            $char8.  /*  YYMMDD8  */
        @00284 PSDS_MEDICARE                    1.
        @00285 PSDS_MEDICARE_EVER               $char8.  /*  YYMMDD8  */
        @00293 PTRA_MEDICARE                    1.
        @00294 PTRA_MEDICARE_EVER               $char8.  /*  YYMMDD8  */
        @00302 PVD_MEDICARE                     1.
        @00303 PVD_MEDICARE_EVER                $char8.  /*  YYMMDD8  */
        @00311 SCD_MEDICARE                     1.
        @00312 SCD_MEDICARE_EVER                $char8.  /*  YYMMDD8  */
        @00320 SCHI_MEDICARE                    1.
        @00321 SCHI_MEDICARE_EVER               $char8.  /*  YYMMDD8  */
        @00329 SCHIOT_MEDICARE                  1.
        @00330 SCHIOT_MEDICARE_EVER             $char8.  /*  YYMMDD8  */
        @00338 SPIBIF_MEDICARE                  1.
        @00339 SPIBIF_MEDICARE_EVER             $char8.  /*  YYMMDD8  */
        @00347 SPIINJ_MEDICARE                  1.
        @00348 SPIINJ_MEDICARE_EVER             $char8.  /*  YYMMDD8  */
        @00356 TOBA_MEDICARE                    1.
        @00357 TOBA_MEDICARE_EVER               $char8.  /*  YYMMDD8  */
        @00365 ULCERS_MEDICARE                  1.
        @00366 ULCERS_MEDICARE_EVER             $char8.  /*  YYMMDD8  */
        @00374 VISUAL_MEDICARE                  1.
        @00375 VISUAL_MEDICARE_EVER             $char8.  /*  YYMMDD8  */
    ;

  label
        PATIENT_ID                       = "Patient ID"
        RFRNC_YR                         = "Beneficiary Enrollment Reference Year"
        ENRL_SRC                         = "Enrollment Source"
        ACP_MEDICARE                     = "ADHD and Other Conduct Disorders"
        ACP_MEDICARE_EVER                = "ADHD and Other Conduct Disorders First Ever Occurrence Date"
        ALCO_MEDICARE                    = "Alcohol Use Disorders"
        ALCO_MEDICARE_EVER               = "Alcohol Use Disorders First Ever Occurrence Date"
        ANXI_MEDICARE                    = "Anxiety Disorders"
        ANXI_MEDICARE_EVER               = "Anxiety Disorders First Ever Occurrence Date"
        AUTISM_MEDICARE                  = "Autism Spectrum Disorders"
        AUTISM_MEDICARE_EVER             = "Autism Spectrum Disorders First Ever Occurrence Date"
        BIPL_MEDICARE                    = "Bipolar Disorder"
        BIPL_MEDICARE_EVER               = "Bipolar Disorder First Ever Occurrence Date"
        BRAINJ_MEDICARE                  = "Traumatic Brain Injury and Nonpsychotic Mental Disorders due to Brain Damage"
        BRAINJ_MEDICARE_EVER             = "TBI & Nonpsychotic Mental Disorders due to Brain Damage 1st Ever Occurrence Date"
        CERPAL_MEDICARE                  = "Cerebral Palsy"
        CERPAL_MEDICARE_EVER             = "Cerebral Palsy First Ever Occurrence Date"
        CYSFIB_MEDICARE                  = "Cystic Fibrosis and Other Metabolic Developmental Disorders"
        CYSFIB_MEDICARE_EVER             = "Cystic Fibrosis & Oth Metabolic Developmental Disorders 1st Ever Occurrence Date"
        DEPSN_MEDICARE                   = "TO10 Depression"
        DEPSN_MEDICARE_EVER              = "TO10 Depression First Ever Occurrence Date"
        DRUG_MEDICARE                    = "Drug Use"
        DRUG_MEDICARE_EVER               = "Drug Use First Ever Occurrence Date"
        EPILEP_MEDICARE                  = "Epilepsy"
        EPILEP_MEDICARE_EVER             = "Epilepsy First Ever Occurrence Date"
        FIBRO_MEDICARE                   = "Chronic Pain Fatigue and Fibromyalgia"
        FIBRO_MEDICARE_EVER              = "Chronic Pain Fatigue and Fibromyalgia First Ever Occurrence Date"
        HEARIM_MEDICARE                  = "Sensory - Deafness and Hearing Impairment"
        HEARIM_MEDICARE_EVER             = "Sensory - Deafness and Hearing Impairment First Ever Occurrence Date"
        HEPVIRAL_MEDICARE                = "Viral Hepatitis (General)"
        HEPVIRAL_MEDICARE_EVER           = "Viral Hepatitis (General) First Ever Occurrence Date"
        HIVAIDS_MEDICARE                 = "HIV/AIDS"
        HIVAIDS_MEDICARE_EVER            = "HIV/AIDS First Ever Occurrence Date"
        INTDIS_MEDICARE                  = "Intellectual Disabilities and Related Conditions"
        INTDIS_MEDICARE_EVER             = "Intellectual Disabilities and Related Conditions First Ever Occurrence Date"
        LEADIS_MEDICARE                  = "Learning Disabilities"
        LEADIS_MEDICARE_EVER             = "Learning Disabilities First Ever Occurrence Date"
        LEUKLYMPH_MEDICARE               = "Leukemias and Lymphomas"
        LEUKLYMPH_MEDICARE_EVER          = "Leukemias and Lymphomas First Ever Occurrence Date"
        LIVER_MEDICARE                   = "Liver Disease Cirrhosis & Oth Liver Cond (excl Hepatitis)"
        LIVER_MEDICARE_EVER              = "Liver Disease Cirrhosis & Oth Liver Cond (excl Hepatitis) 1st Ever Occur Date"
        MIGRAINE_MEDICARE                = "Migraine and other Chronic Headache"
        MIGRAINE_MEDICARE_EVER           = "Migraine and other Chronic Headache First Ever Occurrence Date"
        MOBIMP_MEDICARE                  = "Mobility Impairments"
        MOBIMP_MEDICARE_EVER             = "Mobility Impairments First Ever Occurrence Date"
        MULSCL_MEDICARE                  = "Multiple Sclerosis and Transverse Myelitis"
        MULSCL_MEDICARE_EVER             = "Multiple Sclerosis and Transverse Myelitis First Ever Occurrence Date"
        MUSDYS_MEDICARE                  = "Muscular Dystrophy"
        MUSDYS_MEDICARE_EVER             = "Muscular Dystrophy First Ever Occurrence Date"
        OBESITY_MEDICARE                 = "Obesity"
        OBESITY_MEDICARE_EVER            = "Obesity First Ever Occurrence Date"
        OTHDEL_MEDICARE                  = "Other Developmental Delays"
        OTHDEL_MEDICARE_EVER             = "Other Developmental Delays First Ever Occurrence Date"
        OUD_ANY_MEDICARE                 = "Overarching OUD Disorder (Any of the Three Sub-Indicators) - Medicare Only Claim"
        OUD_ANY_MEDICARE_EVER            = "Overarching OUD Disorder (Any of the Three Sub-Indicators) - First Ever Occurren"
        OUD_DX_MEDICARE                  = "Diagnosis and Procedure Basis for OUD - Medicare Only Claims"
        OUD_DX_MEDICARE_EVER             = "Diagnosis and Procedure Basis for OUD First Ever Occurrence Date - Medicare Only"
        OUD_HOSP_MEDICARE                = "Opioid-Related Hospitalization or ED - Medicare Only Claims"
        OUD_HOSP_MEDICARE_EVER           = "Opioid-Related Hospitalization or ED First Ever Occurrence Date - Medicare Only"
        OUD_MAT_MEDICARE                 = "Use of Medication-Assisted Treatment (MAT) - Medicare Only Claims"
        OUD_MAT_MEDICARE_EVER            = "Use of Medication-Assisted Treatment (MAT) First Ever Occurrence Date - Medicare"
        PSDS_MEDICARE                    = "Personality Disorders"
        PSDS_MEDICARE_EVER               = "Personality Disorders First Ever Occurrence Date"
        PTRA_MEDICARE                    = "Post-Traumatic Stress Disorder"
        PTRA_MEDICARE_EVER               = "Post-Traumatic Stress Disorder First Ever Occurrence Date"
        PVD_MEDICARE                     = "Peripheral Vascular Disease"
        PVD_MEDICARE_EVER                = "Peripheral Vascular Disease First Ever Occurrence Date"
        SCD_MEDICARE                     = "Sickle Cell Disease - Medicare Only Claims"
        SCD_MEDICARE_EVER                = "Sickle Cell Disease First Ever Occurrence Date - Medicare Only Claims"
        SCHI_MEDICARE                    = "Schizophrenia"
        SCHI_MEDICARE_EVER               = "Schizophrenia First Ever Occurrence Date"
        SCHIOT_MEDICARE                  = "Schizophrenia and Other Psychotic Disorders"
        SCHIOT_MEDICARE_EVER             = "Schizophrenia and Other Psychotic Disorders First Ever Occurrence Date"
        SPIBIF_MEDICARE                  = "Spina Bifida & Oth Congenital Anomalies Nervous Sys"
        SPIBIF_MEDICARE_EVER             = "Spina Bifida & Oth Congenital Anomalies Nervous Sys 1st Ever Occurrence Date"
        SPIINJ_MEDICARE                  = "Spinal Cord Injury"
        SPIINJ_MEDICARE_EVER             = "Spinal Cord Injury First Ever Occurrence Date"
        TOBA_MEDICARE                    = "Tobacco Use Disorders"
        TOBA_MEDICARE_EVER               = "Tobacco Use Disorders First Ever Occurrence Date"
        ULCERS_MEDICARE                  = "Pressure Ulcers and Chronic Ulcers"
        ULCERS_MEDICARE_EVER             = "Pressure Ulcers and Chronic Ulcers First Ever Occurrence Date"
        VISUAL_MEDICARE                  = "Sensory - Blindness and Visual Impairment"
        VISUAL_MEDICARE_EVER             = "Sensory - Blindness and Visual Impairment First Ever Occurrence Date"
    ;

run;

proc contents data=seer.oth_cc position;
run;



/* Outpat File */


filename outbase 'S:\JamieHeyward\Dissertation Aim 2 SEER Medicare Cohort Study\SEERMed_IRAE\SEER Medicare irAE 2013-2019\outpat*.base.txt';                    /* reading in an un-zipped file* /
*filename outbase pipe 'gunzip -c /directory/outpat2019.base.txt.gz';  /* reading in a zipped file */
*filename outbase pipe 'gunzip -c /directory/outpat*.base.txt.gz';   /* using wildcard to match multiple files */

options nocenter validvarname=upcase;

data seer.outbase;
  infile outbase lrecl=1115 missover pad;
  input
     @001   patient_id                        $char15.  /*  Patient ID (for either Cancer or Non-Cancer Patients) */
     @016   CLM_ID                            $char15.  /*  Encrypted  */
     @031   NCH_NEAR_LINE_REC_IDENT_CD        $char1.
     @032   NCH_CLM_TYPE_CD                   $char2.
     @034   CLM_FROM_DT                       $char8.  /*  YYMMDD8  */
     @042   CLM_THRU_DT                       $char8.  /*  YYMMDD8  */
     @050   NCH_WKLY_PROC_DT                  $char8.  /*  YYMMDD8  */
     @058   FI_CLM_PROC_DT                    $char8.  /*  YYMMDD8  */
     @066   CLAIM_QUERY_CODE                  $char1.
     @067   PRVDR_NUM                         $char6.   /*  Encrypted  */
     @077   CLM_FAC_TYPE_CD                   $char1.
     @078   CLM_SRVC_CLSFCTN_TYPE_CD          $char1.
     @079   CLM_FREQ_CD                       $char1.
     @080   FI_NUM                            $char5.
     @085   CLM_MDCR_NON_PMT_RSN_CD           $char2.
     @087   CLM_PMT_AMT                       12.2
     @099   NCH_PRMRY_PYR_CLM_PD_AMT          12.2
     @111   NCH_PRMRY_PYR_CD                  $char1.
     @112   PRVDR_STATE_CD                    $char2.
     @114   ORG_NPI_NUM                       $char10.  /*  Encrypted  */
     @124   SRVC_LOC_NPI_NUM                  $char10.  /*  Encrypted  */
     @146   AT_PHYSN_UPIN                     $char6.   /*  Encrypted  */
     @158   AT_PHYSN_NPI                      $char10.  /*  Encrypted  */
     @170   AT_PHYSN_SPCLTY_CD                $char2.
     @172   OP_PHYSN_UPIN                     $char6.   /*  Encrypted  */
     @184   OP_PHYSN_NPI                      $char10.  /*  Encrypted  */
     @196   OP_PHYSN_SPCLTY_CD                $char2.
     @198   OT_PHYSN_UPIN                     $char6.   /*  Encrypted  */
     @210   OT_PHYSN_NPI                      $char10.  /*  Encrypted  */
     @222   OT_PHYSN_SPCLTY_CD                $char2.
     @224   RNDRNG_PHYSN_NPI                  $char10.  /*  Encrypted  */
     @236   RNDRNG_PHYSN_SPCLTY_CD            $char2.
     @238   RFR_PHYSN_NPI                     $char10.  /*  Encrypted  */
     @250   RFR_PHYSN_SPCLTY_CD               $char2.
     @252   CLM_MCO_PD_SW                     $char1.
     @253   PTNT_DSCHRG_STUS_CD               $char2.
     @255   CLM_TOT_CHRG_AMT                  12.2
     @267   NCH_BENE_BLOOD_DDCTBL_LBLTY_AM    12.2
     @279   NCH_PROFNL_CMPNT_CHRG_AMT         12.2
     @291   PRNCPAL_DGNS_CD                   $char7.
     @298   ICD_DGNS_CD1                      $char7.
     @305   ICD_DGNS_CD2                      $char7.
     @312   ICD_DGNS_CD3                      $char7.
     @319   ICD_DGNS_CD4                      $char7.
     @326   ICD_DGNS_CD5                      $char7.
     @333   ICD_DGNS_CD6                      $char7.
     @340   ICD_DGNS_CD7                      $char7.
     @347   ICD_DGNS_CD8                      $char7.
     @354   ICD_DGNS_CD9                      $char7.
     @361   ICD_DGNS_CD10                     $char7.
     @368   ICD_DGNS_CD11                     $char7.
     @375   ICD_DGNS_CD12                     $char7.
     @382   ICD_DGNS_CD13                     $char7.
     @389   ICD_DGNS_CD14                     $char7.
     @396   ICD_DGNS_CD15                     $char7.
     @403   ICD_DGNS_CD16                     $char7.
     @410   ICD_DGNS_CD17                     $char7.
     @417   ICD_DGNS_CD18                     $char7.
     @424   ICD_DGNS_CD19                     $char7.
     @431   ICD_DGNS_CD20                     $char7.
     @438   ICD_DGNS_CD21                     $char7.
     @445   ICD_DGNS_CD22                     $char7.
     @452   ICD_DGNS_CD23                     $char7.
     @459   ICD_DGNS_CD24                     $char7.
     @466   ICD_DGNS_CD25                     $char7.
     @473   FST_DGNS_E_CD                     $char7.
     @480   ICD_DGNS_E_CD1                    $char7.
     @487   ICD_DGNS_E_CD2                    $char7.
     @494   ICD_DGNS_E_CD3                    $char7.
     @501   ICD_DGNS_E_CD4                    $char7.
     @508   ICD_DGNS_E_CD5                    $char7.
     @515   ICD_DGNS_E_CD6                    $char7.
     @522   ICD_DGNS_E_CD7                    $char7.
     @529   ICD_DGNS_E_CD8                    $char7.
     @536   ICD_DGNS_E_CD9                    $char7.
     @543   ICD_DGNS_E_CD10                   $char7.
     @550   ICD_DGNS_E_CD11                   $char7.
     @557   ICD_DGNS_E_CD12                   $char7.
     @564   ICD_PRCDR_CD1                     $char7.
     @571   PRCDR_DT1                         $char8.  /*  YYMMDD8  */
     @579   ICD_PRCDR_CD2                     $char7.
     @586   PRCDR_DT2                         $char8.  /*  YYMMDD8  */
     @594   ICD_PRCDR_CD3                     $char7.
     @601   PRCDR_DT3                         $char8.  /*  YYMMDD8  */
     @609   ICD_PRCDR_CD4                     $char7.
     @616   PRCDR_DT4                         $char8.  /*  YYMMDD8  */
     @624   ICD_PRCDR_CD5                     $char7.
     @631   PRCDR_DT5                         $char8.  /*  YYMMDD8  */
     @639   ICD_PRCDR_CD6                     $char7.
     @646   PRCDR_DT6                         $char8.  /*  YYMMDD8  */
     @654   ICD_PRCDR_CD7                     $char7.
     @661   PRCDR_DT7                         $char8.  /*  YYMMDD8  */
     @669   ICD_PRCDR_CD8                     $char7.
     @676   PRCDR_DT8                         $char8.  /*  YYMMDD8  */
     @684   ICD_PRCDR_CD9                     $char7.
     @691   PRCDR_DT9                         $char8.  /*  YYMMDD8  */
     @699   ICD_PRCDR_CD10                    $char7.
     @706   PRCDR_DT10                        $char8.  /*  YYMMDD8  */
     @714   ICD_PRCDR_CD11                    $char7.
     @721   PRCDR_DT11                        $char8.  /*  YYMMDD8  */
     @729   ICD_PRCDR_CD12                    $char7.
     @736   PRCDR_DT12                        $char8.  /*  YYMMDD8  */
     @744   ICD_PRCDR_CD13                    $char7.
     @751   PRCDR_DT13                        $char8.  /*  YYMMDD8  */
     @759   ICD_PRCDR_CD14                    $char7.
     @766   PRCDR_DT14                        $char8.  /*  YYMMDD8  */
     @774   ICD_PRCDR_CD15                    $char7.
     @781   PRCDR_DT15                        $char8.  /*  YYMMDD8  */
     @789   ICD_PRCDR_CD16                    $char7.
     @796   PRCDR_DT16                        $char8.  /*  YYMMDD8  */
     @804   ICD_PRCDR_CD17                    $char7.
     @811   PRCDR_DT17                        $char8.  /*  YYMMDD8  */
     @819   ICD_PRCDR_CD18                    $char7.
     @826   PRCDR_DT18                        $char8.  /*  YYMMDD8  */
     @834   ICD_PRCDR_CD19                    $char7.
     @841   PRCDR_DT19                        $char8.  /*  YYMMDD8  */
     @849   ICD_PRCDR_CD20                    $char7.
     @856   PRCDR_DT20                        $char8.  /*  YYMMDD8  */
     @864   ICD_PRCDR_CD21                    $char7.
     @871   PRCDR_DT21                        $char8.  /*  YYMMDD8  */
     @879   ICD_PRCDR_CD22                    $char7.
     @886   PRCDR_DT22                        $char8.  /*  YYMMDD8  */
     @894   ICD_PRCDR_CD23                    $char7.
     @901   PRCDR_DT23                        $char8.  /*  YYMMDD8  */
     @909   ICD_PRCDR_CD24                    $char7.
     @916   PRCDR_DT24                        $char8.  /*  YYMMDD8  */
     @924   ICD_PRCDR_CD25                    $char7.
     @931   PRCDR_DT25                        $char8.  /*  YYMMDD8  */
     @939   RSN_VISIT_CD1                     $char7.
     @946   RSN_VISIT_CD2                     $char7.
     @953   RSN_VISIT_CD3                     $char7.
     @960   NCH_BENE_PTB_DDCTBL_AMT           12.2
     @972   NCH_BENE_PTB_COINSRNC_AMT         12.2
     @984   CLM_OP_PRVDR_PMT_AMT              12.2
     @996   CLM_OP_BENE_PMT_AMT               12.2
     @1008  DOB_YEAR                          $char4.
     @1016  GNDR_CD                           $char1.
     @1017  BENE_RACE_CD                      $char1.
     @1018  BENE_CNTY_CD                      $char3.
     @1021  BENE_STATE_CD                     $char2.
     @1023  BENE_MLG_CNTCT_ZIP_CD             $char9.   /*  Encrypted  */
     @1032  CLM_MDCL_REC                      $char17.  /*  Encrypted  */
     @1049  FI_CLM_ACTN_CD                    $char1.
     @1050  NCH_BLOOD_PNTS_FRNSHD_QTY         3.
     @1053  CLM_TRTMT_AUTHRZTN_NUM            $char18.  /*  Encrypted  */
     @1071  CLM_PRCR_RTRN_CD                  $char2.
     @1073  CLM_SRVC_FAC_ZIP_CD               $char9.   /*  Encrypted  */
     @1082  CLM_OP_TRANS_TYPE_CD              $char1.
     @1083  CLM_OP_ESRD_MTHD_CD               $char1.
     @1084  CLM_NEXT_GNRTN_ACO_IND_CD1        $char1.
     @1085  CLM_NEXT_GNRTN_ACO_IND_CD2        $char1.
     @1086  CLM_NEXT_GNRTN_ACO_IND_CD3        $char1.
     @1087  CLM_NEXT_GNRTN_ACO_IND_CD4        $char1.
     @1088  CLM_NEXT_GNRTN_ACO_IND_CD5        $char1.
     @1089  ACO_ID_NUM                        $char10.  /*  Encrypted  */
     @1099  CLM_BENE_ID_TYPE_CD               $char1.
     @1100  CLM_RSDL_PYMT_IND_CD              $char1.
     @1101  PRVDR_VLDTN_TYPE_CD               $char2.
     @1103  RR_BRD_EXCLSN_IND_SW              $char1.
     @1104  CLM_MODEL_REIMBRSMT_AMT           12.2
      ;

  label
     patient_id                      = "Patient ID"
     CLM_ID                          = "Encrypted Claim ID"
     NCH_NEAR_LINE_REC_IDENT_CD      = "NCH Near Line Record Identification Code"
     NCH_CLM_TYPE_CD                 = "NCH Claim Type Code"
     CLM_FROM_DT                     = "Claim From Date"
     CLM_THRU_DT                     = "Claim Through Date (Determines Year of Claim)"
     NCH_WKLY_PROC_DT                = "NCH Weekly Claim Processing Date"
     FI_CLM_PROC_DT                  = "FI Claim Process Date"
     CLAIM_QUERY_CODE                = "Claim Query Code"
     PRVDR_NUM                       = "Provider Number"
     CLM_FAC_TYPE_CD                 = "Claim Facility Type Code"
     CLM_SRVC_CLSFCTN_TYPE_CD        = "Claim Service classification Type Code"
     CLM_FREQ_CD                     = "Claim Frequency Code"
     FI_NUM                          = "FI Number"
     CLM_MDCR_NON_PMT_RSN_CD         = "Claim Medicare Non Payment Reason Code"
     CLM_PMT_AMT                     = "Claim Payment Amount"
     NCH_PRMRY_PYR_CLM_PD_AMT        = "NCH Primary Payer Claim Paid Amount"
     NCH_PRMRY_PYR_CD                = "NCH Primary Payer Code"
     PRVDR_STATE_CD                  = "NCH Provider State Code"
     ORG_NPI_NUM                     = "Organization NPI Number"
     SRVC_LOC_NPI_NUM                = "Claim Service Location NPI Number"
     AT_PHYSN_UPIN                   = "Claim Attending Physician UPIN Number"
     AT_PHYSN_NPI                    = "Claim Attending Physician NPI Number"
     AT_PHYSN_SPCLTY_CD              = "Claim Attending Physician Specialty Code"
     OP_PHYSN_UPIN                   = "Claim Operating Physician UPIN Number"
     OP_PHYSN_NPI                    = "Claim Operating Physician NPI Number"
     OP_PHYSN_SPCLTY_CD              = "Claim Operating Physician Specialty Code"
     OT_PHYSN_UPIN                   = "Claim Other Physician UPIN Number"
     OT_PHYSN_NPI                    = "Claim Other Physician NPI Number"
     OT_PHYSN_SPCLTY_CD              = "Claim Other Physician Specialty Code"
     RNDRNG_PHYSN_NPI                = "Claim Rendering Physician NPI"
     RNDRNG_PHYSN_SPCLTY_CD          = "Claim Rendering Physician Specialty Code"
     RFR_PHYSN_NPI                   = "Claim Referring Physician NPI"
     RFR_PHYSN_SPCLTY_CD             = "Claim Referring Physician Specialty Code"
     CLM_MCO_PD_SW                   = "Claim MCO Paid Switch"
     PTNT_DSCHRG_STUS_CD             = "Patient Discharge Status Code"
     CLM_TOT_CHRG_AMT                = "Claim Total Charge Amount"
     NCH_BENE_BLOOD_DDCTBL_LBLTY_AM  = "NCH Beneficiary Blood Deductible Liability Amount"
     NCH_PROFNL_CMPNT_CHRG_AMT       = "NCH Professional Component Charge"
     PRNCPAL_DGNS_CD                 = "Primary Claim Diagnosis Code"
     ICD_DGNS_CD1                    = "Claim Diagnosis Code I"
     ICD_DGNS_CD2                    = "Claim Diagnosis Code II"
     ICD_DGNS_CD3                    = "Claim Diagnosis Code III"
     ICD_DGNS_CD4                    = "Claim Diagnosis Code IV"
     ICD_DGNS_CD5                    = "Claim Diagnosis Code V"
     ICD_DGNS_CD6                    = "Claim Diagnosis Code VI"
     ICD_DGNS_CD7                    = "Claim Diagnosis Code VII"
     ICD_DGNS_CD8                    = "Claim Diagnosis Code VIII"
     ICD_DGNS_CD9                    = "Claim Diagnosis Code IX"
     ICD_DGNS_CD10                   = "Claim Diagnosis Code X"
     ICD_DGNS_CD11                   = "Claim Diagnosis Code XI"
     ICD_DGNS_CD12                   = "Claim Diagnosis Code XII"
     ICD_DGNS_CD13                   = "Claim Diagnosis Code XIII"
     ICD_DGNS_CD14                   = "Claim Diagnosis Code XIV"
     ICD_DGNS_CD15                   = "Claim Diagnosis Code XV"
     ICD_DGNS_CD16                   = "Claim Diagnosis Code XVI"
     ICD_DGNS_CD17                   = "Claim Diagnosis Code XVII"
     ICD_DGNS_CD18                   = "Claim Diagnosis Code XVIII"
     ICD_DGNS_CD19                   = "Claim Diagnosis Code XIX"
     ICD_DGNS_CD20                   = "Claim Diagnosis Code XX"
     ICD_DGNS_CD21                   = "Claim Diagnosis Code XXI"
     ICD_DGNS_CD22                   = "Claim Diagnosis Code XXII"
     ICD_DGNS_CD23                   = "Claim Diagnosis Code XXIII"
     ICD_DGNS_CD24                   = "Claim Diagnosis Code XXIV"
     ICD_DGNS_CD25                   = "Claim Diagnosis Code XXV"
     FST_DGNS_E_CD                   = "First Claim Diagnosis E Code"
     ICD_DGNS_E_CD1                  = "Claim Diagnosis E Code I"
     ICD_DGNS_E_CD2                  = "Claim Diagnosis E Code II"
     ICD_DGNS_E_CD3                  = "Claim Diagnosis E Code III"
     ICD_DGNS_E_CD4                  = "Claim Diagnosis E Code IV"
     ICD_DGNS_E_CD5                  = "Claim Diagnosis E Code V"
     ICD_DGNS_E_CD6                  = "Claim Diagnosis E Code VI"
     ICD_DGNS_E_CD7                  = "Claim Diagnosis E Code VII"
     ICD_DGNS_E_CD8                  = "Claim Diagnosis E Code VIII"
     ICD_DGNS_E_CD9                  = "Claim Diagnosis E Code IX"
     ICD_DGNS_E_CD10                 = "Claim Diagnosis E Code X"
     ICD_DGNS_E_CD11                 = "Claim Diagnosis E Code XI"
     ICD_DGNS_E_CD12                 = "Claim Diagnosis E Code XII"
     ICD_PRCDR_CD1                   = "Claim Procedure Code I"
     PRCDR_DT1                       = "Claim Procedure Code I Date"
     ICD_PRCDR_CD2                   = "Claim Procedure Code II"
     PRCDR_DT2                       = "Claim Procedure Code II Date"
     ICD_PRCDR_CD3                   = "Claim Procedure Code III"
     PRCDR_DT3                       = "Claim Procedure Code III Date"
     ICD_PRCDR_CD4                   = "Claim Procedure Code IV"
     PRCDR_DT4                       = "Claim Procedure Code IV Date"
     ICD_PRCDR_CD5                   = "Claim Procedure Code V"
     PRCDR_DT5                       = "Claim Procedure Code V Date"
     ICD_PRCDR_CD6                   = "Claim Procedure Code VI"
     PRCDR_DT6                       = "Claim Procedure Code VI Date"
     ICD_PRCDR_CD7                   = "Claim Procedure Code VII"
     PRCDR_DT7                       = "Claim Procedure Code VII Date"
     ICD_PRCDR_CD8                   = "Claim Procedure Code VIII"
     PRCDR_DT8                       = "Claim Procedure Code VIII Date"
     ICD_PRCDR_CD9                   = "Claim Procedure Code IX"
     PRCDR_DT9                       = "Claim Procedure Code IX Date"
     ICD_PRCDR_CD10                  = "Claim Procedure Code X"
     PRCDR_DT10                      = "Claim Procedure Code X Date"
     ICD_PRCDR_CD11                  = "Claim Procedure Code XI"
     PRCDR_DT11                      = "Claim Procedure Code XI Date"
     ICD_PRCDR_CD12                  = "Claim Procedure Code XII"
     PRCDR_DT12                      = "Claim Procedure Code XII Date"
     ICD_PRCDR_CD13                  = "Claim Procedure Code XIII"
     PRCDR_DT13                      = "Claim Procedure Code XIII Date"
     ICD_PRCDR_CD14                  = "Claim Procedure Code XIV"
     PRCDR_DT14                      = "Claim Procedure Code XIV Date"
     ICD_PRCDR_CD15                  = "Claim Procedure Code XV"
     PRCDR_DT15                      = "Claim Procedure Code XV Date"
     ICD_PRCDR_CD16                  = "Claim Procedure Code XVI"
     PRCDR_DT16                      = "Claim Procedure Code XVI Date"
     ICD_PRCDR_CD17                  = "Claim Procedure Code XVII"
     PRCDR_DT17                      = "Claim Procedure Code XVII Date"
     ICD_PRCDR_CD18                  = "Claim Procedure Code XVIII"
     PRCDR_DT18                      = "Claim Procedure Code XVIII Date"
     ICD_PRCDR_CD19                  = "Claim Procedure Code XIX"
     PRCDR_DT19                      = "Claim Procedure Code XIX Date"
     ICD_PRCDR_CD20                  = "Claim Procedure Code XX"
     PRCDR_DT20                      = "Claim Procedure Code XX Date"
     ICD_PRCDR_CD21                  = "Claim Procedure Code XXI"
     PRCDR_DT21                      = "Claim Procedure Code XXI Date"
     ICD_PRCDR_CD22                  = "Claim Procedure Code XXII"
     PRCDR_DT22                      = "Claim Procedure Code XXII Date"
     ICD_PRCDR_CD23                  = "Claim Procedure Code XXIII"
     PRCDR_DT23                      = "Claim Procedure Code XXIII Date"
     ICD_PRCDR_CD24                  = "Claim Procedure Code XXIV"
     PRCDR_DT24                      = "Claim Procedure Code XXIV Date"
     ICD_PRCDR_CD25                  = "Claim Procedure Code XXV"
     PRCDR_DT25                      = "Claim Procedure Code XXV Date"
     RSN_VISIT_CD1                   = "Reason for Visit Diagnosis Code I"
     RSN_VISIT_CD2                   = "Reason for Visit Diagnosis Code II"
     RSN_VISIT_CD3                   = "Reason for Visit Diagnosis Code III"
     NCH_BENE_PTB_DDCTBL_AMT         = "NCH Beneficiary Part B Deductible Amount"
     NCH_BENE_PTB_COINSRNC_AMT       = "NCH Beneficiary Part B Coinsurance Amount"
     CLM_OP_PRVDR_PMT_AMT            = "Claim Outpatient Provider Payment Amount"
     CLM_OP_BENE_PMT_AMT             = "Claim Outpatient Beneficiary Payment Amount"
     DOB_YEAR                        = "Year of Birth from Claim (Date)"
     GNDR_CD                         = "Gender Code from Claim"
     BENE_RACE_CD                    = "Race Code from Claim"
     BENE_CNTY_CD                    = "County Code from Claim (SSA)"
     BENE_STATE_CD                   = "State Code from Claim (SSA)"
     BENE_MLG_CNTCT_ZIP_CD           = "Zip Code of Residence from Claim"
     CLM_MDCL_REC                    = "Claim Medical Record Number"
     FI_CLM_ACTN_CD                  = "FI Claim Action Code"
     NCH_BLOOD_PNTS_FRNSHD_QTY       = "NCH Blood Pints Furnished Quantity"
     CLM_TRTMT_AUTHRZTN_NUM          = "Claim Treatment Authorization Number"
     CLM_PRCR_RTRN_CD                = "Claim Pricer Return Code"
     CLM_SRVC_FAC_ZIP_CD             = "Claim Service Facility ZIP Code"
     CLM_OP_TRANS_TYPE_CD            = "Claim Outpatient Transaction Type Code"
     CLM_OP_ESRD_MTHD_CD             = "Claim Outpatient ESRD Method Of Reimbursement Code"
     CLM_NEXT_GNRTN_ACO_IND_CD1      = "Claim Next Generation Accountable Care Organization Indicator Code 1"
     CLM_NEXT_GNRTN_ACO_IND_CD2      = "Claim Next Generation Accountable Care Organization Indicator Code 2"
     CLM_NEXT_GNRTN_ACO_IND_CD3      = "Claim Next Generation Accountable Care Organization Indicator Code 3"
     CLM_NEXT_GNRTN_ACO_IND_CD4      = "Claim Next Generation Accountable Care Organization Indicator Code 4"
     CLM_NEXT_GNRTN_ACO_IND_CD5      = "Claim Next Generation Accountable Care Organization Indicator Code 5"
     ACO_ID_NUM                      = "Claim Accountable Care Organization (ACO) Identification Number"
     CLM_BENE_ID_TYPE_CD             = "For CMS Internal Use Only"
     CLM_RSDL_PYMT_IND_CD            = "Claim Residual Payment Indicator Code"
     PRVDR_VLDTN_TYPE_CD             = "Provider Validation Type Code"
     RR_BRD_EXCLSN_IND_SW            = "Railroad Board Exclusion Indicator Switch"
     CLM_MODEL_REIMBRSMT_AMT         = "Claim Model Reimbursement Amount"
    ;

run;

proc contents data=seer.outbase position;
run;

filename outrev 'S:\JamieHeyward\Dissertation Aim 2 SEER Medicare Cohort Study\SEERMed_IRAE\SEER Medicare irAE 2013-2019\outpat*.revenue.txt';                    /* reading in an un-zipped file* /
*filename outrev pipe 'gunzip -c /directory/outpat2019.revenue.txt.gz';  /* reading in a zipped file */
*filename outrev pipe 'gunzip -c /directory/outpat*.revenue.txt.gz';   /* using wildcard to match multiple files */

options nocenter validvarname=upcase;

data seer.outrevenue;
  infile outrev lrecl=404 missover pad;
  input
     @001  patient_id                      $char15.  /*  Patient ID (for either Cancer or Non-Cancer Patients) */
     @016  CLM_ID                          $char15.  /*  Encrypted  */
     @031  CLM_THRU_DT                     $char8.  /*  YYMMDD8  */
     @039  CLM_LINE_NUM                    $char13.
     @052  NCH_CLM_TYPE_CD                 $char2.
     @054  REV_CNTR                        $char4.
     @058  REV_CNTR_DT                     $char8.  /*  YYMMDD8  */
     @066  REV_CNTR_1ST_ANSI_CD            $char5.
     @071  REV_CNTR_2ND_ANSI_CD            $char5.
     @076  REV_CNTR_3RD_ANSI_CD            $char5.
     @081  REV_CNTR_4TH_ANSI_CD            $char5.
     @086  REV_CNTR_APC_HIPPS_CD           $char5.
     @091  HCPCS_CD                        $char5.
     @096  HCPCS_1ST_MDFR_CD               $char5.
     @101  HCPCS_2ND_MDFR_CD               $char5.
     @106  HCPCS_3RD_MDFR_CD               $char5.
     @111  HCPCS_4TH_MDFR_CD               $char5.
     @116  REV_CNTR_PMT_MTHD_IND_CD        $char2.
     @118  REV_CNTR_DSCNT_IND_CD           $char1.
     @119  REV_CNTR_PACKG_IND_CD           $char1.
     @120  REV_CNTR_OTAF_PMT_CD            $char1.
     @121  REV_CNTR_IDE_NDC_UPC_NUM        $char24.
     @145  REV_CNTR_UNIT_CNT               $char8.
     @153  REV_CNTR_RATE_AMT               12.2
     @165  REV_CNTR_BLOOD_DDCTBL_AMT       12.2
     @177  REV_CNTR_CASH_DDCTBL_AMT        12.2
     @189  REV_CNTR_COINSRNC_WGE_ADJSTD_C  12.2
     @201  REV_CNTR_RDCD_COINSRNC_AMT      12.2
     @213  REV_CNTR_1ST_MSP_PD_AMT         12.2
     @225  REV_CNTR_2ND_MSP_PD_AMT         12.2
     @237  REV_CNTR_PRVDR_PMT_AMT          12.2
     @249  REV_CNTR_BENE_PMT_AMT           12.2
     @261  REV_CNTR_PTNT_RSPNSBLTY_PMT     12.2
     @273  REV_CNTR_PMT_AMT_AMT            12.2
     @285  REV_CNTR_TOT_CHRG_AMT           12.2
     @297  REV_CNTR_NCVRD_CHRG_AMT         12.2
     @309  REV_CNTR_STUS_IND_CD            $char2.
     @311  REV_CNTR_NDC_QTY                10.3
     @321  REV_CNTR_NDC_QTY_QLFR_CD        $char2.
     @323  RNDRNG_PHYSN_UPIN               $char6.   /*  Encrypted  */
     @335  RNDRNG_PHYSN_NPI                $char10.  /*  Encrypted  */
     @347  RNDRNG_PHYSN_SPCLTY_CD          $char2.
     @349  REV_CNTR_DDCTBL_COINSRNC_CD     $char1.
     @350  REV_CNTR_PRCNG_IND_CD           $char2.
     @352  THRPY_CAP_IND_CD1               $char1.
     @353  THRPY_CAP_IND_CD2               $char1.
     @354  RC_PTNT_ADD_ON_PYMT_AMT         12.2
     @366  TRNSTNL_DRUG_ADD_ON_PYMT_AMT    12.4
     @378  REV_CNTR_RP_IND_CD              $char1.
     @379  RC_MODEL_REIMBRSMT_AMT          12.2
     @391  RC_VLNTRY_SRVC_IND_CD           $char1.
     @392  ORDRNG_PHYSN_NPI                $char12.
      ;

  label
     patient_id                       = "Patient ID"
     CLM_ID                           = "Encrypted Claim ID"
     CLM_THRU_DT                      = "Claim Through Date (Determines Year of Claim)"
     CLM_LINE_NUM                     = "Claim Line Number"
     NCH_CLM_TYPE_CD                  = "NCH Claim Type Code"
     REV_CNTR                         = "Revenue Center Code"
     REV_CNTR_DT                      = "Revenue Center Date"
     REV_CNTR_1ST_ANSI_CD             = "Revenue Center 1st ANSI Code"
     REV_CNTR_2ND_ANSI_CD             = "Revenue Center 2nd ANSI Code"
     REV_CNTR_3RD_ANSI_CD             = "Revenue Center 3rd ANSI Code"
     REV_CNTR_4TH_ANSI_CD             = "Revenue Center 4th ANSI Code"
     REV_CNTR_APC_HIPPS_CD            = "Revenue Center APC/HIPPS"
     HCPCS_CD                         = "Revenue Center Healthcare Common Procedure Coding System"
     HCPCS_1ST_MDFR_CD                = "Revenue Center HCPCS Initial Modifier Code"
     HCPCS_2ND_MDFR_CD                = "Revenue Center HCPCS Second Modifier Code"
     HCPCS_3RD_MDFR_CD                = "Revenue Center HCPCS Third Modifier Code"
     HCPCS_4TH_MDFR_CD                = "Revenue Center HCPCS Fourth Modifier Code"
     REV_CNTR_PMT_MTHD_IND_CD         = "Revenue Center Payment Method Indicator Code"
     REV_CNTR_DSCNT_IND_CD            = "Revenue Center Discount Indicator Code"
     REV_CNTR_PACKG_IND_CD            = "Revenue Center Packaging Indicator Code"
     REV_CNTR_OTAF_PMT_CD             = "Revenue Center Obligation to Accept As Full (OTAF) Payment Code"
     REV_CNTR_IDE_NDC_UPC_NUM         = "Revenue Center IDE, NDC, UPC Number"
     REV_CNTR_UNIT_CNT                = "Revenue Center Unit Count"
     REV_CNTR_RATE_AMT                = "Revenue Center Rate Amount"
     REV_CNTR_BLOOD_DDCTBL_AMT        = "Revenue Center Blood Deductible Amount"
     REV_CNTR_CASH_DDCTBL_AMT         = "Revenue Center Cash Deductible Amount"
     REV_CNTR_COINSRNC_WGE_ADJSTD_C   = "Revenue Center Coinsurance/Wage Adjusted Coinsurance Amount"
     REV_CNTR_RDCD_COINSRNC_AMT       = "Revenue Center Reduced Coinsurance Amount"
     REV_CNTR_1ST_MSP_PD_AMT          = "Revenue Center 1st Medicare Secondary Payer Paid Amount"
     REV_CNTR_2ND_MSP_PD_AMT          = "Revenue Center 2nd Medicare Secondary Payer Paid Amount"
     REV_CNTR_PRVDR_PMT_AMT           = "Revenue Center Provider Payment Amount"
     REV_CNTR_BENE_PMT_AMT            = "Revenue Center Beneficiary Payment Amount"
     REV_CNTR_PTNT_RSPNSBLTY_PMT      = "Revenue Center Patient Responsibility Payment"
     REV_CNTR_PMT_AMT_AMT             = "Revenue Center Payment Amount Amount"
     REV_CNTR_TOT_CHRG_AMT            = "Revenue Center Total Charge Amount"
     REV_CNTR_NCVRD_CHRG_AMT          = "Revenue Center Non-Covered Charge Amount"
     REV_CNTR_STUS_IND_CD             = "Revenue Center Status Indicator Code"
     REV_CNTR_NDC_QTY                 = "Revenue Center NDC Quantity"
     REV_CNTR_NDC_QTY_QLFR_CD         = "Revenue Center NDC Quantity Qualifier Code"
     RNDRNG_PHYSN_UPIN                = "Revenue Center Rendering Physician UPIN"
     RNDRNG_PHYSN_NPI                 = "Revenue Center Rendering Physician NPI"
     RNDRNG_PHYSN_SPCLTY_CD           = "Revenue Center Rendering Physician Specialty Code"
     REV_CNTR_DDCTBL_COINSRNC_CD      = "Revenue Center Deductible Coinsurance Code"
     REV_CNTR_PRCNG_IND_CD            = "Revenue Center Pricing Indicator Code"
     THRPY_CAP_IND_CD1                = "Revenue Center Therapy Cap Indicator Code 1"
     THRPY_CAP_IND_CD2                = "Revenue Center Therapy Cap Indicator Code 2"
     RC_PTNT_ADD_ON_PYMT_AMT          = "Revenue Center Patient/Initial Visit Add-On Payment Amount"
     TRNSTNL_DRUG_ADD_ON_PYMT_AMT     = "Transitional Drug Add-On Payment Amount"
     REV_CNTR_RP_IND_CD               = "Revenue Center Representative Payee (RP) Indicator Code"
     RC_MODEL_REIMBRSMT_AMT           = "Revenue Center Model Reimbursement Amount"
     RC_VLNTRY_SRVC_IND_CD            = "Revenue Center Voluntary Service Indicator Code"
     ORDRNG_PHYSN_NPI                 = "Revenue Center Ordering Physician NPI"
   ;

run;

proc contents data=seer.outrevenue position;
run;

filename outcond 'S:\JamieHeyward\SEERMed_IRAE\SEER Medicare irAE 2013-2019\outpat*.condition.txt';                    /* reading in an un-zipped file* /
*filename outcond pipe 'gunzip -c /directory/outpat2019.condition.txt.gz';  /* reading in a zipped file */
*filename outcond pipe 'gunzip -c /directory/outpat*.condition.txt.gz';   /* using wildcard to match multiple files */

options nocenter validvarname=upcase;

data seer.outcondition;
  infile outcond lrecl=36 missover pad;
  input
     @01  patient_id               $char15.  /*  Patient ID (for either Cancer or Non-Cancer Patients) */
     @16  CLM_ID                   $char15.  /*  Encrypted  */
     @31  NCH_CLM_TYPE_CD          $char2.
     @33  RLT_COND_CD_SEQ          $char2.
     @35  CLM_RLT_COND_CD          $char2.
   ;

  label
     patient_id              = "Patient ID"
     CLM_ID                  = "Encrypted Claim ID"
     NCH_CLM_TYPE_CD         = "NCH Claim Type Code"
     RLT_COND_CD_SEQ         = "Claim Related Condition Code Sequence"
     CLM_RLT_COND_CD         = "Claim Related Condition Code"
   ;

run;

proc contents data=seer.outcondition position;
run;



filename outoccur 'S:\JamieHeyward\SEERMed_IRAE\SEER Medicare irAE 2013-2019\outpat*.occurrence.txt';                    /* reading in an un-zipped file* /
*filename outoccur pipe 'gunzip -c /directory/outpat2019.occurrence.txt.gz';  /* reading in a zipped file */
*filename outoccur pipe 'gunzip -c /directory/outpat*.occurrence.txt.gz';   /* using wildcard to match multiple files */

options nocenter validvarname=upcase;

data seer.outoccurrence;
  infile outoccur lrecl=44 missover pad;
  input
     @01  patient_id               $char15.  /*  Patient ID (for either Cancer or Non-Cancer Patients) */
     @16  CLM_ID                   $char15.  /*  Encrypted  */
     @31  NCH_CLM_TYPE_CD          $char2.
     @33  RLT_OCRNC_CD_SEQ         $char2.
     @35  CLM_RLT_OCRNC_CD         $char2.
     @37  CLM_RLT_OCRNC_DT         $char8.  /*  YYMMDD8  */
      ;

  label
     patient_id                    = "Patient ID"
     CLM_ID                        = "Encrypted Claim ID"
     NCH_CLM_TYPE_CD               = "NCH Claim Type Code"
     RLT_OCRNC_CD_SEQ              = "Claim Related Occurrence Code Sequence"
     CLM_RLT_OCRNC_CD              = "Claim Related Occurrence Code"
     CLM_RLT_OCRNC_DT              = "Claim Related Occurrence Date"
   ;

run;

proc contents data=seer.outoccurrence position;
run;

filename outspan 'S:\JamieHeyward\SEERMed_IRAE\SEER Medicare irAE 2013-2019\outpat*.span.txt';                    /* reading in an un-zipped file* /
*filename outspan pipe 'gunzip -c /directory/outpat2019.span.txt.gz';  /* reading in a zipped file */
*filename outspan pipe 'gunzip -c /directory/outpat*.span.txt.gz';   /* using wildcard to match multiple files */

options nocenter validvarname=upcase;

data seer.outspan;
  infile outspan lrecl=52 missover pad;
  input
     @01  patient_id               $char15.  /*  Patient ID (for either Cancer or Non-Cancer Patients) */
     @16  CLM_ID                   $char15.  /*  Encrypted  */
     @31  NCH_CLM_TYPE_CD          $char2.
     @33  RLT_SPAN_CD_SEQ          $char2.
     @35  CLM_SPAN_CD              $char2.
     @37  CLM_SPAN_FROM_DT         $char8.  /*  YYMMDD8  */
     @45  CLM_SPAN_THRU_DT         $char8.  /*  YYMMDD8  */
      ;

  label
     patient_id                    = "Patient ID"
     CLM_ID                        = "Encrypted Claim ID"
     NCH_CLM_TYPE_CD               = "NCH Claim Type Code"
     RLT_SPAN_CD_SEQ               = "Claim Related Span Code Sequence"
     CLM_SPAN_CD                   = "Claim Occurrence Span Code"
     CLM_SPAN_FROM_DT              = "Claim Occurrence Span From Date"
     CLM_SPAN_THRU_DT              = "Claim Occurrence Span Through Date"
   ;

run;

proc contents data=seer.outspan position;
run;

filename outvalue 'S:\JamieHeyward\SEERMed_IRAE\SEER Medicare irAE 2013-2019\outpat*.value.txt';                    /* reading in an un-zipped file* /
*filename outvalue pipe 'gunzip -c /directory/outpat2019.value.txt.gz';  /* reading in a zipped file */
*filename outvalue pipe 'gunzip -c /directory/outpat*.value.txt.gz';   /* using wildcard to match multiple files */

options nocenter validvarname=upcase;

data seer.outvalue;
  infile outvalue lrecl=48 missover pad;
  input
     @01  patient_id               $char15.  /*  Patient ID (for either Cancer or Non-Cancer Patients) */
     @16  CLM_ID                   $char15.  /*  Encrypted  */
     @31  NCH_CLM_TYPE_CD          $char2.
     @33  RLT_VAL_CD_SEQ           $char2.
     @35  CLM_VAL_CD               $char2.
     @37  CLM_VAL_AMT              12.2
      ;

  label
     patient_id                    = "Patient ID"
     CLM_ID                        = "Encrypted Claim ID"
     NCH_CLM_TYPE_CD               = "NCH Claim Type Code"
     RLT_VAL_CD_SEQ                = "Claim Related Value Code Sequence"
     CLM_VAL_CD                    = "Claim Value Code"
     CLM_VAL_AMT                   = "Claim Value Amount"
   ;

run;

proc contents data=seer.outvalue position;
run;

filename outdemo 'S:\JamieHeyward\SEERMed_IRAE\SEER Medicare irAE 2013-2019\outpat*.demo.txt';                    /* reading in an un-zipped file* /
*filename outdemo pipe 'gunzip -c /directory/outpat2019.demo.txt.gz';  /* reading in a zipped file */
*filename outdemo pipe 'gunzip -c /directory/outpat*.demo.txt.gz';   /* using wildcard to match multiple files */

options nocenter validvarname=upcase;

data seer.outdemo;
  infile outdemo lrecl=52 missover pad;
  input
       @01  patient_id                       $char15.  /*  Patient ID (for either Cancer or Non-Cancer Patients) */
       @16  CLM_ID                           $char15.  /*  Encrypted  */
       @31  NCH_CLM_TYPE_CD                  $char2.
       @33  DEMO_ID_SQNC_NUM                 3.
       @36  DEMO_ID_NUM                      $char2.
       @38  DEMO_INFO_TXT                    $char15.
     ;

  label
     patient_id            = "Patient ID"
     CLM_ID                = "Encrypted Claim ID"
     NCH_CLM_TYPE_CD       = "NCH Claim Type Code"
     DEMO_ID_SQNC_NUM      = "Claim Demonstration Sequence"
     DEMO_ID_NUM           = "Claim Demonstration Identification Number"
     DEMO_INFO_TXT         = "Claim Demonstration Information Text";
    ;
run;
proc contents data=seer.outdemo position;
Title 'proc contents, Outpatient Demonstration/Innovation file';
run;



/* PDESAF File */


/* PDE Event claims file for 2012-2013 */

filename pdein12 'S:\JamieHeyward\SEERMed_IRAE\SEER Medicare irAE 2013-2019\pdesaf1213*.txt';                      /*reading in an un-zipped file*/
*filename pdein pipe 'gunzip -c /directory/pdesaf2013.txt.gz';     /*reading in a zipped file*/
*filename pdein pipe 'gunzip -c /directory/pdesaf*.txt.gz';     /*using wildcard to match multiple files */

options nocenter validvarname=upcase;

data seer.pdesaf1213;
  infile pdein12 lrecl=361 missover pad;
  input @00001 PDE_ID                           $char15.  /*  Encrypted  */
        @00016 patient_id                       $CHAR15.  /*  Patient ID (for either Cancer or Non-Cancer Patients) */
        @00031 SRVC_DT                          $char8.  /*  YYMMDD8  */
        @00039 PD_DT                            $char8.  /*  YYMMDD8  */
        @00047 PROD_SRVC_ID                     $char19.
        @00066 PLAN_CNTRCT_REC_ID               $char5.
        @00071 PLAN_PBP_REC_NUM                 $char3.
        @00074 CMPND_CD                         2.
        @00076 DAW_PROD_SLCTN_CD                $char1.
        @00077 QTY_DSPNSD_NUM                   12.3
        @00089 DAYS_SUPLY_NUM                   3.
        @00092 FILL_NUM                         3.
        @00095 DSPNSNG_STUS_CD                  $char1.
        @00096 DRUG_CVRG_STUS_CD                $char1.
        @00097 PRCNG_EXCPTN_CD                  $char1.
        @00098 CTSTRPHC_CVRG_CD                 $char1.
        @00099 GDC_BLW_OOPT_AMT                 10.2
        @00109 GDC_ABV_OOPT_AMT                 10.2
        @00119 PTNT_PAY_AMT                     10.2
        @00129 OTHR_TROOP_AMT                   10.2
        @00139 LICS_AMT                         10.2
        @00149 PLRO_AMT                         10.2
        @00159 CVRD_D_PLAN_PD_AMT               10.2
        @00169 NCVRD_PLAN_PD_AMT                10.2
        @00179 TOT_RX_CST_AMT                   10.2
        @00189 BN                               $char30.
        @00219 GCDF                             $char2.
        @00221 GCDF_DESC                        $char40.
        @00261 STR                              $char10.
        @00271 GNN                              $char30.
        @00301 BENEFIT_PHASE                    $char2.
        @00303 CCW_PHARMACY_ID                  12.
        @00315 CCW_PRSCRBR_ID                   12.
        @00327 PDE_PRSCRBR_ID_FRMT_CD           $char1.
        @00328 FORMULARY_ID                     $char8.
        @00336 FRMLRY_RX_ID                     $char8.
        @00344 RX_ORGN_CD                       $char1.
        @00345 RPTD_GAP_DSCNT_NUM               10.2
        @00355 BRND_GNRC_CD                     $char1.
        @00356 PHRMCY_SRVC_TYPE_CD              $char2.
        @00358 PTNT_RSDNC_CD                    $char2.
        @00360 SUBMSN_CLR_CD                    $char2.
         ;

  label PDE_ID                           = "Encrypted 723 PDE ID"
        patient_id                       = "Patient ID"
        SRVC_DT                          = "RX Service Date (DOS)"
        PD_DT                            = "Paid Date"
        PROD_SRVC_ID                     = "Product Service ID"
        PLAN_CNTRCT_REC_ID               = "Plan Contract Record ID"
        PLAN_PBP_REC_NUM                 = "Plan PBP Record Number"
        CMPND_CD                         = "Compound Code"
        DAW_PROD_SLCTN_CD                = "Dispense as Written (DAW) Product Selection Code"
        QTY_DSPNSD_NUM                   = "Quantity Dispensed"
        DAYS_SUPLY_NUM                   = "Days Supply"
        FILL_NUM                         = "Fill Number"
        DSPNSNG_STUS_CD                  = "Dispensing Status Code"
        DRUG_CVRG_STUS_CD                = "Drug Coverage Status Code"
        PRCNG_EXCPTN_CD                  = "Pricing Exception Code"
        CTSTRPHC_CVRG_CD                 = "Catastrophic Coverage Code"
        GDC_BLW_OOPT_AMT                 = "Gross Drug Cost Below Out-of-Pocket Threshold (GDCB)"
        GDC_ABV_OOPT_AMT                 = "Gross Drug Cost Above Out-of-Pocket Threshold (GDCA)"
        PTNT_PAY_AMT                     = "Patient Pay Amount"
        OTHR_TROOP_AMT                   = "Other TrOOP Amount"
        LICS_AMT                         = "Low Income Cost Sharing Subsidy Amount (LICS)"
        PLRO_AMT                         = "Patient Liability Reduction Due to Other Payer Amount (PLRO)"
        CVRD_D_PLAN_PD_AMT               = "Covered D Plan Paid Amount (CPP)"
        NCVRD_PLAN_PD_AMT                = "Non-Covered Plan Paid Amount (NPP)"
        TOT_RX_CST_AMT                   = "Gross Drug Cost"
        BN                               = "Brand Name"
        GCDF                             = "Dosage Form Code"
        GCDF_DESC                        = "Dosage Form Code Description"
        STR                              = "Drug Strength Description"
        GNN                              = "Generic Name - Short Version"
        BENEFIT_PHASE                    = "The benefit phase of the Part D Event"
        CCW_PHARMACY_ID                  = "CCW Pharmacy ID from Pharmacy Characteristics File"
        CCW_PRSCRBR_ID                   = "CCW Prescriber ID from Prescriber Characteristics File"
        PDE_PRSCRBR_ID_FRMT_CD           = "PDE Prescriber ID Format Code"
        FORMULARY_ID                     = "Formulary ID. First Column of Composite Foreign Key to Formulary File"
        FRMLRY_RX_ID                     = "Formulary Rx ID. Second Column of Composite Foreign Key to Formulary File"
        RX_ORGN_CD                       = "Prescription Origin Code"
        RPTD_GAP_DSCNT_NUM               = "Gap Discount Amount reported by the Submitting Plan"
        BRND_GNRC_CD                     = "The Brand-Generic Code reported by the submitting plan"
        PHRMCY_SRVC_TYPE_CD              = "Pharmacy Service Type Code"
        PTNT_RSDNC_CD                    = "Patient Residence Code"
        SUBMSN_CLR_CD                    = "Submission Clarification Code"
        ;
run;

proc contents data=seer.pdesaf1213 position;
run;



/* PDE Event claims file for 2014-2019 */


filename pdein14 'S:\JamieHeyward\SEERMed_IRAE\SEER Medicare irAE 2013-2019\pdesaf1419*.txt';                      /*reading in an un-zipped file*/
*filename pdein pipe 'gunzip -c /directory/pdesaf2018.txt.gz';     /*reading in a zipped file*/
*filename pdein pipe 'gunzip -c /directory/pdesaf*.txt.gz';     /*using wildcard to match multiple files */

options nocenter validvarname=upcase;

data seer.pdesaf1419;
  infile pdein14 lrecl=361 missover pad;
  input @00001 PDE_ID                           $char15.    /*  Encrypted  */
        @00016 patient_id                       $CHAR15.  /*  Patient ID (for either Cancer or Non-Cancer Patients) */
        @00031 SRVC_DT                          $char8.  /*  YYMMDD8  */
        @00039 PD_DT                            $char8.  /*  YYMMDD8  */
        @00047 PRSCRBR_ID_QLFYR_CD              $char2.
        @00049 PRSCRBR_ID                       $char15.
        @00064 PROD_SRVC_ID                     $char19.
        @00083 PLAN_CNTRCT_REC_ID               $char5.
        @00088 PLAN_PBP_REC_NUM                 $char3.
        @00091 CMPND_CD                         2.
        @00093 DAW_PROD_SLCTN_CD                $char1.
        @00094 QTY_DSPNSD_NUM                   12.3
        @00106 DAYS_SUPLY_NUM                   3.
        @00109 FILL_NUM                         3.
        @00112 DSPNSNG_STUS_CD                  $char1.
        @00113 DRUG_CVRG_STUS_CD                $char1.
        @00114 PRCNG_EXCPTN_CD                  $char1.
        @00115 CTSTRPHC_CVRG_CD                 $char1.
        @00116 GDC_BLW_OOPT_AMT                 10.2
        @00126 GDC_ABV_OOPT_AMT                 10.2
        @00136 PTNT_PAY_AMT                     10.2
        @00146 OTHR_TROOP_AMT                   10.2
        @00156 LICS_AMT                         10.2
        @00166 PLRO_AMT                         10.2
        @00176 CVRD_D_PLAN_PD_AMT               10.2
        @00186 NCVRD_PLAN_PD_AMT                10.2
        @00196 TOT_RX_CST_AMT                   10.2
        @00206 BN                               $char30.
        @00236 GCDF                             $char2.
        @00238 GCDF_DESC                        $char40.
        @00278 STR                              $char10.
        @00288 GNN                              $char30.
        @00318 BENEFIT_PHASE                    $char2.
        @00320 PDE_PRSCRBR_ID_FRMT_CD           $char1.
        @00321 FORMULARY_ID                     $char8.
        @00329 FRMLRY_RX_ID                     $char8.
        @00337 NCPDP_ID                         $char7.
        @00344 RX_ORGN_CD                       $char1.
        @00345 RPTD_GAP_DSCNT_NUM               10.2
        @00355 BRND_GNRC_CD                     $char1.
        @00356 PHRMCY_SRVC_TYPE_CD              $char2.
        @00358 PTNT_RSDNC_CD                    $char2.
        @00360 SUBMSN_CLR_CD                    $char2.
    ;

  label PDE_ID                           = "Encrypted 723 PDE ID"
        patient_id                       = "Patient ID"
        SRVC_DT                          = "RX Service Date (DOS)"
        PD_DT                            = "Paid Date"
        PRSCRBR_ID_QLFYR_CD              = "Prescriber ID Qualifier Code"
        PRSCRBR_ID                       = "Prescriber ID"
        PROD_SRVC_ID                     = "Product Service ID"
        PLAN_CNTRCT_REC_ID               = "Plan Contract Record ID"
        PLAN_PBP_REC_NUM                 = "Plan PBP Record Number"
        CMPND_CD                         = "Compound Code"
        DAW_PROD_SLCTN_CD                = "Dispense as Written (DAW) Product Selection Code"
        QTY_DSPNSD_NUM                   = "Quantity Dispensed"
        DAYS_SUPLY_NUM                   = "Days Supply"
        FILL_NUM                         = "Fill Number"
        DSPNSNG_STUS_CD                  = "Dispensing Status Code"
        DRUG_CVRG_STUS_CD                = "Drug Coverage Status Code"
        PRCNG_EXCPTN_CD                  = "Pricing Exception Code"
        CTSTRPHC_CVRG_CD                 = "Catastrophic Coverage Code"
        GDC_BLW_OOPT_AMT                 = "Gross Drug Cost Below Out-of-Pocket Threshold (GDCB)"
        GDC_ABV_OOPT_AMT                 = "Gross Drug Cost Above Out-of-Pocket Threshold (GDCA)"
        PTNT_PAY_AMT                     = "Patient Pay Amount"
        OTHR_TROOP_AMT                   = "Other TrOOP Amount"
        LICS_AMT                         = "Low Income Cost Sharing Subsidy Amount (LICS)"
        PLRO_AMT                         = "Patient Liability Reduction Due to Other Payer Amount (PLRO)"
        CVRD_D_PLAN_PD_AMT               = "Covered D Plan Paid Amount (CPP)"
        NCVRD_PLAN_PD_AMT                = "Non-Covered Plan Paid Amount (NPP)"
        TOT_RX_CST_AMT                   = "Gross Drug Cost"
        BN                               = "Brand Name"
        GCDF                             = "Dosage Form Code"
        GCDF_DESC                        = "Dosage Form Code Description"
        STR                              = "Drug Strength Description"
        GNN                              = "Generic Name - Short Version"
        BENEFIT_PHASE                    = "The benefit phase of the Part D Event"
        PDE_PRSCRBR_ID_FRMT_CD           = "PDE Prescriber ID Format Code"
        FORMULARY_ID                     = "Formulary ID. First Column of Composite Foreign Key to Formulary File"
        FRMLRY_RX_ID                     = "Formulary Rx ID. Second Column of Composite Foreign Key to Formulary File"
        NCPDP_ID                         = "NCPDP Proprietary Pharmacy Identifier"
        RX_ORGN_CD                       = "Prescription Origin Code"
        RPTD_GAP_DSCNT_NUM               = "Gap Discount Amount reported by the Submitting Plan"
        BRND_GNRC_CD                     = "The Brand-Generic Code reported by the submitting plan"
        PHRMCY_SRVC_TYPE_CD              = "Pharmacy Service Type Code"
        PTNT_RSDNC_CD                    = "Patient Residence Code"
        SUBMSN_CLR_CD                    = "Submission Clarification Code"
        ;

run;

proc contents data=seer.pdesaf1419 position;
run;



/* SEER Files */


filename SEER_in 'S:\JamieHeyward\SEERMed_IRAE\SEER Medicare irAE 2013-2019\SEER.*.cancer.txt';                   /* reading in an un-zipped file */
*filename SEER_in pipe 'gunzip -c /directory/SEER.cancer.txt.gz'; /* reading in a zipped file */

options nocenter validvarname=upcase;

data seer.SEER_in;
  infile SEER_in lrecl=771 missover pad;
  input
      @001 patient_id                        $char15. /* Patient ID (for either Cancer or Non-Cancer Patients) */
      @016 SEER_registry                     $char2. /*Registry*/
      @018 SEERregistrywithCAandGAaswholes   $char2. /*Registry with CA and GA as whole states*/
      @020 Louisiana20051stvs2ndhalfofyear   $char1. /*Louisiana 2005 1st vs 2nd half of the year*/
      @021 Marital_status_at_diagnosis       $char1. /*Marital Status               (Not available for NY, MA, ID and TX)*/
      @022 Race_ethnicity                    $char2. /*Race ethnicity*/
      @024 sex                               $char1. /*Sex*/
      @025 Agerecodewithsingleages_and_100   $char3. /*Age recode with single ages and 100+*/
      @028 agerecodewithsingle_ages_and_85   $char3. /*Age recode with single ages and 85+*/
      @031 Sequence_number                   $char2. /*Sequence Number*/
      @033 Month_of_diagnosis                $char2. /*Month of Diagnosis, Not month diagnosis recode*/
      @035 Year_of_diagnosis                 $char4. /*Year of Diagnosis*/
      @039 Coc_Accredited_Flag_2018          $char1. /*Coc Accredited Flag 2018+*/
      @040 Month_of_diagnosis_recode         $char2. /*Month of Diagnosis Recode*/
      @042 Primary_Site                      $char4. /*Primary Site*/
      @046 Laterality                        $char1. /*Laterality*/
      @047 Histology_ICD_O_2                 $char4. /*Histology ICD-0-2  (Not available for NY, MA, ID and TX)*/
      @051 Behavior_code_ICD_O_2             $char1. /*Behavior ICD-0-2   (Not available for NY, MA, ID and TX)*/
      @052 Histologic_Type_ICD_O_3           $char4. /*Histologic type ICD-0-3*/
      @056 Behavior_code_ICD_O_3             $char1. /*Behavior code ICD-0-3*/
      @067 Grade_thru_2017                   $char1. /*Grade thru 2017*/
      @068 Schema_ID_2018                    $char5. /*Schema ID (2018+)*/
      @073 Grade_Clinical_2018               $char1. /*Grade Clinical (2018+)*/
      @074 Grade_Pathological_2018           $char1. /*Grade Pathological (2018+)*/
      @075 Diagnostic_Confirmation           $char1. /*Diagnostic Confirmation*/
      @076 Type_of_Reporting_Source          $char1. /*Type of Reporting Source*/
      @077 EOD_10_size_1988_2003             $char3. /*EOD 10 - SIZE (1998-2003)     (Not available for NY, MA, ID and TX)*/
      @080 EOD_10_extent_1988_2003           $char2. /*EOD 10 - EXTENT (1998-2003)   (Not available for NY, MA, ID and TX)*/
      @082 EOD10Prostatepath_ext_1995_2003   $char2. /*EOD 10 - Prostate path ext (1995-2003)    (Not available for NY, MA, ID and TX)*/
      @084 EOD_10_nodes_1988_2003            $char1. /*EOD 10 - Nodes (1995-2003)                (Not available for NY, MA, ID and TX)*/
      @085 Regional_nodes_positive_1988      $char2. /*EOD 10 - Regional Nodes positive (1988+)  (limited to diagnosis years 2000-2003 for NY, MA, ID and TX)*/
      @087 Regional_nodes_examined_1988      $char2. /*EOD 10 - Regional Nodes examined (1988+)  (Not available for NY, MA, ID and TX)*/
      @089 Expanded_EOD_1_CP53_1973_1982     $char1. /*EOD - expanded 1-13                       (Not available for NY, MA, ID and TX)*/
      @090 Expanded_EOD_2_CP54_1973_1982     $char1.
      @091 Expanded_EOD_3_CP55_1973_1982     $char1.
      @092 Expanded_EOD_4_CP56_1973_1982     $char1.
      @093 Expanded_EOD_5_CP57_1973_1982     $char1.
      @094 Expanded_EOD_6_CP58_1973_1982     $char1.
      @095 Expanded_EOD_7_CP59_1973_1982     $char1.
      @096 Expanded_EOD_8_CP60_1973_1982     $char1.
      @097 Expanded_EOD_9_CP61_1973_1982     $char1.
      @098 Expanded_EOD_10_CP62_1973_1982    $char1.
      @099 Expanded_EOD_11_CP63_1973_1982    $char1.
      @100 Expanded_EOD_12_CP64_1973_1982    $char1.
      @101 Expanded_EOD_13_CP65_1973_1982    $char1.
      @106 EOD_4_size_1983_1987              $char2. /*EOD 4 - Size (1983-1987)       (Not available for NY, MA, ID and TX)  */
      @108 EOD_4_extent_1983_1987            $char1. /*EOD 4 - Extent (1983-1987)     (Not available for NY, MA, ID and TX)  */
      @109 EOD_4_nodes_1983_1987             $char1. /*EOD 4 - Nodes (1983-1987)      (Not available for NY, MA, ID and TX)  */
      @110 Coding_system_EOD_1973_2003       $char1. /*EOD Coding System (1973-2003)  (Not available for NY, MA, ID and TX)  */
      @111 Tumor_marker_1_1990_2003          $char1. /*Tumor marker 1 (1990-2003)     (Not available for NY, MA, ID and TX)  */
      @112 Tumor_marker_2_1990_2003          $char1. /*Tumor marker 2 (1990-2003)     (Not available for NY, MA, ID and TX)  */
      @113 Tumor_marker_3_1998_2003          $char1. /*Tumor marker 3 (1998-2003      (Not available for NY, MA, ID and TX)  */
      @114 CS_tumor_size_2004_2015           $char3. /*CS Tumor size (2004-2015)      (Not available for NY, MA, ID and TX)  */
      @117 CS_extension_2004_2015            $char3. /*CS extension (2004-2015)       (Not available for NY, MA, ID and TX)  */
      @120 CS_lymph_nodes_2004_2015          $char3. /*CS Lymph nodes (2004-2015)     (Not available for NY, MA, ID and TX)  */
      @123 CS_mets_at_dx_2004_2015           $char2. /*CS Mets at dx (2004-2015)      (Not available for NY, MA, ID and TX)  */
      @125 CSsitespecificfactor120042017va   $char3. /*CS Site-specific factor 1(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @128 CSsitespecificfactor220042017va   $char3. /*CS Site-specific factor 2(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @131 CSsitespecificfactor320042017va   $char3. /*CS Site-specific factor 3(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @134 CSsitespecificfactor420042017va   $char3. /*CS Site-specific factor 4(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @137 CSsitespecificfactor520042017va   $char3. /*CS Site-specific factor 5(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @140 CSsitespecificfactor620042017va   $char3. /*CS Site-specific factor 6(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @143 CSsitespecificfactor720042017va   $char3. /*CS Site-specific factor 7(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @146 CSsitespecificfactor820042017va   $char3. /*CS Site-specific factor 8(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @149 CSsitespecificfactor920042017va   $char3. /*CS Site-specific factor 9(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @152 CSsitespecificfactor1020042017v   $char3. /*CS Site-specific factor 10(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @155 CSsitespecificfactor1120042017v   $char3. /*CS Site-specific factor 11(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @158 CSsitespecificfactor1220042017v   $char3. /*CS Site-specific factor 12(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @161 CSsitespecificfactor1320042017v   $char3. /*CS Site-specific factor 13(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @164 CSsitespecificfactor1520042017v   $char3. /*CS Site-specific factor 15(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @167 CSsitespecificfactor1620042017v   $char3. /*CS Site-specific factor 16(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @170 CSsitespecificfactor2520042017v   $char3. /*CS Site-specific factor 25(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @173 Derived_AJCC_T_6th_ed_2004_2015   $char2. /*Derived AJCC T 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @175 Derived_AJCC_N_6th_ed_2004_2015   $char2. /*Derived AJCC N 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @177 Derived_AJCC_M_6th_ed_2004_2015   $char2. /*Derived AJCC M 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @179 DerivedAJCCStageGroup6thed20042   $char2. /*Derived AJCC STAGE Group 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @181 SEERcombinedSummaryStage2000200   $char1. /*SEER Combined Summary Stage 2000 (2004-2017) */
      @182 Combined_Summary_Stage_2004       $char1. /*Combined Summary Stage 2000 (2004+) */
      @183 CSversioninputoriginal2004_2015   $char6. /*CS Version Input (2004-2015)	       (Not available for NY, MA, ID and TX)*/
      @189 CS_version_derived_2004_2015      $char6. /*CS Version Derived (2004-2015)      (Not available for NY, MA, ID and TX)*/
      @195 CSversioninputcurrent_2004_2015   $char6. /*CS Version Current (2004-2015)      (Not available for NY, MA, ID and TX)*/
      @201 RX_Summ_Surg_Prim_Site_1998       $char2. /*RX Summ-Surg Prim site 1998+        (Not available for NY, MA, ID and TX)*/
      @203 RX_Summ_Scope_Reg_LN_Sur_2003     $char1. /*RX Summ-Scope Reg LN Sur (2003+)    (Not available for NY, MA, ID and TX)*/
      @204 RX_Summ_Surg_Oth_Reg_Dis_2003     $char1. /*RX Summ-Surg Oth reg/dis (2003+)    (Not available for NY, MA, ID and TX)*/
      @205 RXSummReg_LN_Examined_1998_2002   $char2. /*RX Summ-Reg LN examined (1998-2002) (Not available for NY, MA, ID and TX)*/
      @207 RX_Summ_Systemic_Surg_Seq         $char1. /*RX Summ--Systemic Surg Seq          (Not available for NY, MA, ID and TX)*/
      @208 RX_Summ_Surg_Rad_Seq              $char1. /*Radiation Sequence with Surgery     (Not available for NY, MA, ID and TX)*/
      @209 Reasonnocancer_directed_surgery   $char1. /*Reason No Cancer-Directed Surgery   (Not available for NY, MA, ID and TX)*/
      @210 Radiation_recode                  $char1. /*Radiation Recode (0 and 9 combined) - created         (Not available for NY, MA, ID and TX)*/
      @211 Chemotherapy_recode_yes_no_unk    $char1. /*CHEMOTHERAPY Recode, yes(1)/no/unknown(0) - created   (Not available for NY, MA, ID and TX)*/
      @212 Sitespecificsurgery19731997vary   $char2. /*Site Specific Surgery (1973-1997)         (Not available for NY, MA, ID and TX)*/
      @214 Scopeofreglymphndsurg_1998_2002   $char1. /*Scope of Reg Lymph ND Surg (1998-2002)    (Not available for NY, MA, ID and TX)*/
      @215 Surgeryofothregdissites19982002   $char1. /*Surgery of Oth Reg/Dis sites (1998-2002)  (Not available for NY, MA, ID and TX)*/
      @216 Record_number_recode              $char2. /*Record Number Recode             */
      @218 Age_recode_with_1_year_olds       $char2. /*Age Recode with <1 Year Olds     */
      @220 Site_recode_ICD_O_3_WHO_2008      $char5. /*Site Recode ICD-O-3/WHO 2008)    */
      @230 Site_recode_rare_tumors           $char5. /*Site Recode - rare tumor*/
      @240 Behavior_recode_for_analysis      $char1. /*Behavior Recode for Analysis*/
      @241 Histologyrecode_broad_groupings   $char2. /*Histology Recode - Broad Groupings*/
      @243 Histologyrecode_Brain_groupings   $char2. /*Histology Recode - Brain Groupings*/
      @245 ICCCsiterecodeextended3rdeditio   $char3. /*ICCC Site Recode Extended 3rd Edition/IARC 2017*/
      @248 TNM_7_CS_v0204_Schema_thru_2017   $char3. /*TNM 7/CS v0204+ Schema (thru 2017)  (Not available for NY, MA, ID and TX)*/
      @251 TNM_7_CS_v0204_Schema_recode      $char3. /*TNM 7/CS v0204+ Schema Recode       (Not available for NY, MA, ID and TX)*/
      @254 Race_recode_White_Black_Other     $char1. /*Race Recode (White, Black, Other)*/
      @255 Race_recode_W_B_AI_API            $char1. /*Race Recode (W, B, AI, API)*/
      @256 OriginrecodeNHIAHispanicNonHisp   $char1. /*Origin Recode NHIA (Hispanic, Non-Hispanic)*/
      @257 RaceandoriginrecodeNHWNHBNHAIAN   $char1. /*Race and origin recode (NHW, NHB, NHAIAN, NHAPI, Hispanic)*/
      @258 SEER_historic_stage_A_1973_2015   $char1. /*SEER Historic Stage A (1973-2015)     (Not available for NY, MA, ID and TX)*/
      @259 AJCCstage_3rd_edition_1988_2003   $char2. /*AJCC Stage 3rd Edition (1988-2003)    (Not available for NY, MA, ID and TX)*/
      @261 SEERmodifiedAJCCstage3rd1988200   $char2. /*SEER Modified AJCC Stage 3rd Edition (1988-2003)   (Not available for NY, MA, ID and TX)*/
      @263 Firstmalignantprimary_indicator   $char1. /*First Malignant Primary Indicator*/
      @264 state                             $char2. /*FIPS State*/
      @266 county                            $char3. /*FIPS County*/
      @274 Medianhouseholdincomeinflationa   $char2. /*Median Household Income Inflation adj to 2019*/
      @276 Rural_Urban_Continuum_Code        $char2. /*Rural-Urban Continuum Code*/
      @278 PRCDA_2017	                     $char1. /*PRCDA - 2017*/
      @279 PRCDA_Region	                     $char1. /*PRCDA - Region*/
      @280 COD_to_site_recode                $char5. /*COD to Site Recode        (Not available for NY, MA, ID and TX)*/
      @285 COD_to_site_rec_KM                $char5. /*COD to Site Recode KM     (Not available for NY, MA, ID and TX)*/
      @290 Vitalstatusrecodestudycutoffuse   $char1. /*Vital Status Recode (Study Cutoff Used) (Not available for NY, MA, ID and TX)*/
      @291 IHS_Link                          $char1. /*IHS LINK*/
      @292 Summary_stage_2000_1998_2017      $char1. /*Summary Stage 2000 (1998-2017) (Not available for NY, MA, ID and TX)*/
      @293 AYA_site_recode_WHO_2008          $char2. /*AYA Site Recode/WHO 2008*/
      @295 AYA_site_recode_2020_Revision     $char3. /*AYA Site Recode 2020 Revision*/
      @298 Lymphoidneoplasmrecode2021Revis   $char2. /*Lymphoid neoplasm recode 2021 Revision*/
      @302 LymphomasubtyperecodeWHO2008thr   $char2. /*Lymphoma Subtype Recode/WHO 2008 (thru 2017)*/
      @304 SEER_Brain_and_CNS_Recode         $char2. /*SEER Brain and CNS Recode*/
      @306 ICCCsiterecode3rdeditionIARC201   $char3. /*ICCC Site Recode 3rd Edition/IARC 2017*/
      @309 SEERcausespecificdeathclassific   $char1. /*SEER Cause-Specific Death Classification (Not available for NY, MA, ID and TX)*/
      @310 SEERothercauseofdeathclassifica   $char1. /*SEER Other Cause of Death Classification (Not available for NY, MA, ID and TX)*/
      @311 CSTumor_Size_Ext_Eval_2004_2015   $char1. /*CS Tumor Size/Ext Eval (2004-2015)  (Not available for NY, MA, ID and TX)*/
      @312 CS_Reg_Node_Eval_2004_2015        $char1. /*CS Reg Node Eval (2004-2015)        (Not available for NY, MA, ID and TX)*/
      @313 CS_Mets_Eval_2004_2015            $char1. /*CS Mets Eval (2004-2015)            (Not available for NY, MA, ID and TX)*/
      @314 Primary_by_international_rules    $char1. /*Primary by International Rules*/
      @315 ERStatusRecodeBreastCancer_1990   $char1. /*ER Status Recode Breast Cancer (1990+) (Not available for NY, MA, ID and TX)*/
      @316 PRStatusRecodeBreastCancer_1990   $char1. /*PR Status Recode Breast Cancer (1990+) (Not available for NY, MA, ID and TX)*/
      @317 CS_Schema_AJCC_6th_Edition        $char2. /*CS Schema--AJCC 6th Edition            (Not available for NY, MA, ID and TX)*/
      @319 LymphvascularInvasion2004varyin   $char1. /*Lymph Vascular Invasion (2004+ Varying by Schema) (Not available for NY, MA, ID and TX)*/
      @320 Survival_months                   $char4. /*Survival Months                    (Not available for NY, MA, ID and TX)*/
      @324 Survival_months_flag              $char1. /*Survival Months Flag               (Not available for NY, MA, ID and TX)*/
      @325 Derived_AJCC_T_7th_ed_2010_2015   $char3. /*Derived AJCC T, 7th Ed 2010-2015)  (Not available for NY, MA, ID and TX)*/
      @328 Derived_AJCC_N_7th_ed_2010_2015   $char3. /*Derived AJCC N, 7th Ed 2010-2015)  (Not available for NY, MA, ID and TX)*/
      @331 Derived_AJCC_M_7th_ed_2010_2015   $char3. /*Derived AJCC M, 7th Ed 2010-2015)  (Not available for NY, MA, ID and TX)*/
      @334 DerivedAJCCStageGroup7thed20102   $char3. /*Derived AJCC Stage Group, 7th Ed 2010-2015) (Not available for NY, MA, ID and TX)*/
      @337 BreastAdjustedAJCC6thT1988_2015   $char2. /*Breast--Adjusted AJCC 6th T (1988-2015)  (Not available for NY, MA, ID and TX)*/
      @339 BreastAdjustedAJCC6thN1988_2015   $char2. /*Breast--Adjusted AJCC 6th N (1988-2015)  (Not available for NY, MA, ID and TX)*/
      @341 BreastAdjustedAJCC6thM1988_2015   $char2. /*Breast--Adjusted AJCC 6th M (1988-2015)  (Not available for NY, MA, ID and TX)*/
      @343 BreastAdjustedAJCC6thStage19882   $char2. /*Breast--Adjusted AJCC 6th Stage (1988-2015) (Not available for NY, MA, ID and TX)*/
      @345 Derived_HER2_Recode_2010          $char1. /*Derived HER2 Recode (2010+)              (Not available for NY, MA, ID and TX)*/
      @346 Breast_Subtype_2010               $char1. /*Breast Subtype (2010+)*/
      @347 LymphomaAnnArborStage_1983_2015   $char1. /*Lymphomas: Ann Arbor Staging (1983-2015) (Not available for NY, MA, ID and TX)*/
      @348 SEERCombinedMetsat_DX_bone_2010   $char1. /*SEER Combined Mets at Dx-Bone (2010+)    (Not available for NY, MA, ID and TX)*/
      @349 SEERCombinedMetsatDX_brain_2010   $char1. /*SEER Combined Mets at Dx-Brain (2010+)   (Not available for NY, MA, ID and TX)*/
      @350 SEERCombinedMetsatDX_liver_2010   $char1. /*SEER Combined Mets at Dx-Liver (2010+)   (Not available for NY, MA, ID and TX)*/
      @351 SEERCombinedMetsat_DX_lung_2010   $char1. /*SEER Combined Mets at Dx-Lung (2010+)    (Not available for NY, MA, ID and TX)*/
      @352 TvaluebasedonAJCC_3rd_1988_2003   $char2. /*T Value - Based on AJCC 3rd (1988-2003)  (Not available for NY, MA, ID and TX)*/
      @354 NvaluebasedonAJCC_3rd_1988_2003   $char2. /*N Value - Based on AJCC 3rd (1988-2003)  (Not available for NY, MA, ID and TX)*/
      @356 MvaluebasedonAJCC_3rd_1988_2003   $char2. /*M Value - Based on AJCC 3rd (1988-2003)  (Not available for NY, MA, ID and TX)*/
      @358 Totalnumberofinsitumalignanttum   $char2. /*Total Number of In Situ/Malignant Tumors for Patient (Not available for NY, MA, ID and TX)*/
      @360 Totalnumberofbenignborderlinetu   $char2. /*Total Number of Benign/Borderline Tumors for Patient (Not available for NY, MA, ID and TX)*/
      @362 RadiationtoBrainorCNSRecode1988   $char1. /*Radiation to Brain or CNS Recode (1988-1997) (Not available for NY, MA, ID and TX)*/
      @363 Tumor_Size_Summary_2016	     $char3. /*Tumor Size Summary (2016+)              (Not available for NY, MA, ID and TX)*/
      @366 DerivedSEERCmbStg_Grp_2016_2017   $char5. /*Derived SEER Combined STG GRP (2016+)   (Not available for NY, MA, ID and TX)*/
      @371 DerivedSEERCombined_T_2016_2017   $char5. /*Derived SEER Combined T (2016+)         (Not available for NY, MA, ID and TX)*/
      @376 DerivedSEERCombined_N_2016_2017   $char5. /*Derived SEER Combined N (2016+)         (Not available for NY, MA, ID and TX)*/
      @381 DerivedSEERCombined_M_2016_2017   $char5. /*Derived SEER Combined M (2016+)         (Not available for NY, MA, ID and TX)*/
      @386 DerivedSEERCombinedTSrc20162017   $char1. /*Derived SEER Combined T SRC (2016+)     (Not available for NY, MA, ID and TX)*/
      @387 DerivedSEERCombinedNSrc20162017   $char1. /*Derived SEER Combined N SRC (2016+)     (Not available for NY, MA, ID and TX)*/
      @388 DerivedSEERCombinedMSrc20162017   $char1. /*Derived SEER Combined M SRC (2016+)     (Not available for NY, MA, ID and TX)*/
      @389 TNM_Edition_Number_2016_2017	     $char2. /*TNM Edition Number (2016-2017)          (Not available for NY, MA, ID and TX)*/
      @391 Mets_at_DX_Distant_LN_2016	     $char1. /*Mets at Dx-Distant LN (2016+)           (Not available for NY, MA, ID and TX)*/
      @392 Mets_at_DX_Other_2016	     $char1. /*Mets at DX--Other (2016+)               (Not available for NY, MA, ID and TX)*/
      @393 AJCC_ID_2018                      $char4. /*AJCC ID (2018+)*/
      @397 EOD_Schema_ID_Recode_2010         $char3. /*EOD Schema ID Recode (2010+)*/
      @400 Derived_EOD_2018_T_2018           $char15. /*Derived EOD 2018 T (2018+)             (Not available for NY, MA, ID and TX)*/
      @415 Derived_EOD_2018_N_2018           $char15. /*Derived EOD 2018 N (2018+)             (Not available for NY, MA, ID and TX)*/
      @430 Derived_EOD_2018_M_2018           $char15. /*Derived EOD 2018 M (2018+)             (Not available for NY, MA, ID and TX)*/
      @445 DerivedEOD2018_Stage_Group_2018   $char15. /*Derived EOD 2018 Stage Group (2018+)   (Not available for NY, MA, ID and TX)*/
      @460 EOD_Primary_Tumor_2018            $char3.  /*EOD Primary Tumor (2018+)              (Not available for NY, MA, ID and TX)*/
      @463 EOD_Regional_Nodes_2018           $char3.  /*EOD Regional Nodes (2018+)             (Not available for NY, MA, ID and TX)*/
      @466 EOD_Mets_2018                     $char2.  /*EOD Mets (2018+)                       (Not available for NY, MA, ID and TX)*/
      @468 Monthsfromdiagnosisto_treatment   $char3.  /*Months from diagnosis to treatment     (Not available for NY, MA, ID and TX)*/

   /*Not Public but released*/
      @471 Census_Tract_1990                 $char6. /*Census Track 1990, encrypted*/
      @477 Census_Tract_2000                 $char6. /*Census Track 2000, encrypted*/
      @483 Census_Tract_2010                 $char6. /*Census Track 2010, encrypted*/
      @489 Census_Coding_System	             $char1. /*Coding System for Census Track 1970/80/90*/
      @490 Census_Tract_Certainty_1990	     $char1. /*Census Tract Certainty 1970/1980/1990*/
      @491 Census_Tract_Certainty_2000	     $char1. /*Census Tract Certainty 2000*/
      @492 Census_Tract_Certainty_2010	     $char1. /*Census Tract Certainty 2010*/
      @493 Rural_Urban_Continuum_Code_1993   $char2. /*Rural-Urban Continuum Code 1993 - From SEER*Stat*/
      @495 Rural_Urban_Continuum_Code_2003   $char2. /*Rural-Urban Continuum Code 2003 - From SEER*Stat*/
      @497 Rural_Urban_Continuum_Code_2013   $char2. /*Rural-Urban Continuum Code 2013 - From SEER*Stat*/
      @499 Health_Service_Area               $char4. /*Health Service Area - From SEER*Stat*/
      @503 HealthService_Area_NCI_Modified   $char4. /*Health Service Area NCI Modified - From SEER*Stat*/
      @507 County_at_DX_Geocode_1990         $char3. /*County at DX Geocode 1990*/
      @510 County_at_DX_Geocode_2000	     $char3. /*County at DX Geocode 2000*/
      @513 County_at_DX_Geocode_2010         $char3. /*County at DX Geocode 2010*/
      @516 Derived_SS1977_flag               $char1. /*Derived SS1977 - Flag (2004+)         (Not available for NY, MA, ID and TX)*/
      @517 Derived_SS2000_flag               $char1. /*Derived SS2000 - Flag (2004+)         (Not available for NY, MA, ID and TX)*/
      @518 Radiation                         $char1. /*Radiation                             (Not available for NY, MA, ID and TX)*/
      @519 RadiationtoBrainorCNS_1988_1997   $char1. /*Radiation to Brain or CNS (1988-1997) (Not available for NY, MA, ID and TX)*/
      @520 SEER_DateofDeath_Month            $char2. /*Death Month based on Stat_rec         (Not available for NY, MA, ID and TX)*/
      @522 SEER_DateofDeath_Year             $char4. /*Death Year based on Stat_rec          (Not available for NY, MA, ID and TX)*/
      @526 Month_of_last_follow_up_recode    $char2. /*Month of Follow-up Recode, study cutoff used (Not available for NY, MA, ID and TX)*/
      @528 Year_of_last_follow_up_recode     $char4. /*Year of Follow-up Recode, study cutoff used  (Not available for NY, MA, ID and TX)*/
      @533 Year_of_birth                     $char4. /*Year of Birth*/
      @537 Date_of_diagnosis_flag            $char2. /*Date of Diagnosis Flag*/
      @539 Date_therapy_started_flag         $char2. /*Date of Therapy Started Flag*/
      @541 Date_of_birth_flag                $char2. /*Date of Birth flag*/
      @543 Date_of_last_follow_up_flag       $char2. /*Date of Last Follow-up Flag*/
      @545 Month_therapy_started             $char2. /*Month Therapy Started*/
      @547 Year_therapy_started              $char4. /*Year Therapy Started*/
      @551 Other_cancer_directed_therapy     $char1. /*Other Cancer-Directed Therapy*/
      @552 Derived_AJCC_flag                 $char1. /*Derived AJCC - Flag (2004+)        (Not available for NY, MA, ID and TX)*/
      @553 Derived_SS1977                    $char1. /*Derived SS1977 (2004-2015)         (Not available for NY, MA, ID and TX)*/
      @554 Derived_SS2000                    $char1. /*Derived SS2000 (2004+)             (Not available for NY, MA, ID and TX)*/
      @555 SEER_Summary_stage_1977_9500	     $char1. /*SEER summary stage 1977(1995-2000) (Not available for NY, MA, ID and TX)*/
      @556 SEER_Summary_stage_2000_0103	     $char1. /*SEER summary stage 2000(2001-2003) (Not available for NY, MA, ID and TX)*/

      @558 Primary_Payer_at_DX               $char2. /*Primary Payer at DX                 (Not available for NY, MA, ID and TX)*/
      @569 Recode_ICD_0_2_to_9               $char4. /*Recode ICD-O-2 to 9                 (Not available for NY, MA, ID and TX)*/
      @573 Recode_ICD_0_2_to_10              $char4. /*Recode ICD-O-2 to 10                (Not available for NY, MA, ID and TX)*/
      @577 NHIA_Derived_Hisp_Origin          $char1. /*NHIA Dervied Hispanic Origin        (Not available for NY, MA, ID and TX)*/
      @578 Age_site_edit_override            $char1. /*Age-site edit override              (Not available for NY, MA, ID and TX)*/
      @579 Sequencenumber_dx_conf_override   $char1. /*Sequence number-dx conf override    (Not available for NY, MA, ID and TX)*/
      @580 Site_type_lat_seq_override        $char1. /*Site-type-lat-seq override          (Not available for NY, MA, ID and TX)*/
      @581 Surgerydiagnostic_conf_override   $char1. /*Surgery-diagnostic conf override    (Not available for NY, MA, ID and TX)*/
      @582 Site_type_edit_override           $char1. /*Site-type edit override             (Not available for NY, MA, ID and TX)*/
      @583 Histology_edit_override           $char1. /*Histology edit override             (Not available for NY, MA, ID and TX)*/
      @584 Report_source_sequence_override   $char1. /*Report source sequence override     (Not available for NY, MA, ID and TX)*/
      @585 Seq_ill_defined_site_override     $char1. /*Seq-ill-defined site override       (Not available for NY, MA, ID and TX)*/
      @586 LeukLymphdxconfirmationoverride   $char1. /*Leuk-Lymph dx confirmation override (Not available for NY, MA, ID and TX)*/
      @587 Site_behavior_override            $char1. /*Site-behavior override              (Not available for NY, MA, ID and TX)*/
      @588 Site_EOD_dx_date_override         $char1. /*Site-EOD-dx date override           (Not available for NY, MA, ID and TX)*/
      @589 Site_laterality_EOD_override      $char1. /*Site-laterality-EOD override        (Not available for NY, MA, ID and TX)*/
      @590 Site_laterality_morph_override    $char1. /*Site-laterality-morph override      (Not available for NY, MA, ID and TX)*/

      @591 SEER_Summary_Stage_2000newonly    $char1. /*Summary Stage 2000 (NAACCR Item-759)   Only available for NY, MA, ID and TX for dx years 2001-2003*/

      @592 Insurance_Recode_2007             1. /*Insurance Recode (2007+)                 (Not available for NY, MA, ID and TX)*/
      @593 Yost_ACS_2006_2010                5. /*Yost Index (ACS 2006-2010)*/
      @598 Yost_ACS_2010_2014                5. /*Yost Index (ACS 2010-2014)*/
      @603 Yost_ACS_2013_2017                5. /*Yost Index (ACS 2013-2017)*/
      @608 Yost_ACS_2006_2010_State_based    5. /*Yost Index (ACS 2006-2010) - State based*/
      @613 Yost_ACS_2010_2014_State_based    5. /*Yost Index (ACS 2010-2014) - State based*/
      @618 Yost_ACS_2013_2017_State_based    5. /*Yost Index (ACS 2013-2017) - State based*/
      @623 Yost_ACS_2006_2010_quintile       $char1. /*Yost Index Quintile (ACS 2006-2010)*/
      @624 Yost_ACS_2010_2014_quintile       $char1. /*Yost Index Quintile (ACS 2010-2014)*/
      @625 Yost_ACS_2013_2017_quintile       $char1. /*Yost Index Quintile (ACS 2013-2017)*/
      @626 YostACS20062010quintileStatebas   $char1. /*Yost Index Quintile (ACS 2006-2010) - State based*/
      @627 YostACS20102014quintileStatebas   $char1. /*Yost Index Quintile (ACS 2010-2014) - State based*/
      @628 YostACS20132017quintileStatebas   $char1. /*Yost Index Quintile (ACS 2013-2017) - State based*/
      @629 Brain_Molecular_Markers_2018	     $char3. /*Brain Molecular Markers (2018+)                    (Not available for NY, MA, ID and TX)*/
      @632 AFPPostOrchiectomyLabValueRecod   $char3. /*AFP Post-Orchiectomy Lab Value Recode (2010+)      (Not available for NY, MA, ID and TX)*/
      @635 AFPPretreatmentInterpretationRe   $char2. /*AFP Pretreatment Interpretation Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @637 B_Symptoms_Recode_2010	     $char2. /*B Symptoms Recode (2010+)                          (Not available for NY, MA, ID and TX)*/
      @639 Breslow_Thickness_Recode_2010     $char5. /*Breslow Thickness Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @644 CA125PretreatmentInterpretation   $char2. /*CA-125 Pretreatment Interpretation Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @646 CEAPretreatmentInterpretationRe   $char2. /*CEA Pretreatment Interpretation Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @648 Chromosome19qLossofHeterozygosi   $char2. /*Chromosome 19q: Loss of Heterozygosity (LOH) Recode (2010+) (Not available for NY, MA, ID and TX)*/
      @650 Chromosome1pLossofHeterozygosit   $char2. /*Chromosome 1p: Loss of Heterozygosity (LOH) Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @652 Fibrosis_Score_Recode_2010	     $char2. /*Fibrosis Score Recode (2010+)                           (Not available for NY, MA, ID and TX)*/
      @654 GestationalTrophoblasticPrognos   $char2. /*Gestational Trophoblastic Prognostic Scoring Index Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @656 GleasonPatternsClinicalRecode20   $char3. /*Gleason Patterns Clinical Recode (2010+)                (Not available for NY, MA, ID and TX)*/
      @659 GleasonPatternsPathologicalReco   $char3. /*Gleason Patterns Pathological Recode (2010+)            (Not available for NY, MA, ID and TX)*/
      @662 GleasonScoreClinicalRecode_2010   $char2. /*Gleason Score Clinical Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @664 GleasonScorePathologicalRecode2   $char2. /*Gleason Score Pathological Recode (2010+)               (Not available for NY, MA, ID and TX)*/
      @666 hCGPostOrchiectomyRangeRecode20   $char2. /*hCG Post-Orchiectomy Range Recode (2010+)               (Not available for NY, MA, ID and TX)*/
      @668 InvasionBeyondCapsuleRecode2010   $char2. /*Invasion Beyond Capsule Recode (2010+)                  (Not available for NY, MA, ID and TX)*/
      @670 IpsilateralAdrenalGlandInvolvem   $char2. /*Ipsilateral Adrenal Gland Involvement Recode (2010+)    (Not available for NY, MA, ID and TX)*/
      @672 LDHPostOrchiectomyRangeRecode20   $char2. /*LDH Post-Orchiectomy Range Recode (2010+)               (Not available for NY, MA, ID and TX)*/
      @674 LDHPretreatmentLevelRecode_2010   $char2. /*LDH Pretreatment Level Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @676 LNHeadandNeckLevelsIIIIRecode20   $char2. /*LN Head and Neck Levels I-III Recode (2010+)            (Not available for NY, MA, ID and TX)*/
      @678 LNHeadandNeckLevelsIVVRecode201   $char2. /*LN Head and Neck Levels IV-V Recode (2010+)             (Not available for NY, MA, ID and TX)*/
      @680 LNHeadandNeckLevelsVIVIIRecode2   $char2. /*LN Head and Neck Levels VI-VII Recode (2010+)           (Not available for NY, MA, ID and TX)*/
      @682 LNHeadandNeck_Other_Recode_2010   $char2. /*LN Head and Neck Other Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @684 LNPositiveAxillaryLevelIIIRecod   $char3. /*LN Positive Axillary Level I-II Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @687 Lymph_Node_Size_Recode_2010	     $char3. /*Lymph Node Size Recode (2010+)                          (Not available for NY, MA, ID and TX)*/
      @690 MajorVeinInvolvementRecode_2010   $char2. /*Major Vein Involvement Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @692 MeasuredBasalDiameterRecode2010   $char5. /*Measured Basal Diameter Recode (2010+)                  (Not available for NY, MA, ID and TX)*/
      @697 Measured_Thickness_Recode_2010    $char5. /*Measured Thickness Recode (2010+)                       (Not available for NY, MA, ID and TX)*/
      @704 MitoticRateMelanoma_Recode_2010   $char3. /*Mitotic Rate Melanoma Recode (2010+)                    (Not available for NY, MA, ID and TX)*/
      @707 NumberofCoresPositiveRecode2010   $char3. /*Number of Cores Positive Recode (2010+)                 (Not available for NY, MA, ID and TX)*/
      @710 NumberofCoresExaminedRecode2010   $char3. /*Number of Cores Examined Recode (2010+)                 (Not available for NY, MA, ID and TX)*/
      @713 NumberofExaminedParaAorticNodes   $char3. /*Number of Examined Para-Aortic Nodes Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @716 NumberofExaminedPelvicNodesReco   $char3. /*Number of Examined Pelvic Nodes Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @719 NumberofPositiveParaAorticNodes   $char3. /*Number of Positive Para-Aortic Nodes Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @722 NumberofPositivePelvicNodesReco   $char3. /*Number of Positive Pelvic Nodes Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @725 Perineural_Invasion_Recode_2010   $char2. /*Perineural Invasion Recode (2010+)                      (Not available for NY, MA, ID and TX)*/
      @727 PeripheralBloodInvolvementRecod   $char2. /*Peripheral Blood Involvement Recode (2010+)             (Not available for NY, MA, ID and TX)*/
      @729 Peritoneal_Cytology_Recode_2010   $char2. /*Peritoneal Cytology Recode (2010+)                      (Not available for NY, MA, ID and TX)*/
      @731 Pleural_Effusion_Recode_2010	     $char2. /*Pleural Effusion Recode (2010+)                         (Not available for NY, MA, ID and TX)*/
      @733 PSA_Lab_Value_Recode_2010	     $char5. /*PSA Lab Value Recode (2010+)                            (Not available for NY, MA, ID and TX)*/
      @738 ResidualTumorVolumePostCytoredu   $char3. /*Residual Tumor Volume Post Cytoreduction Recode (2010+) (Not available for NY, MA, ID and TX)*/
      @741 ResponsetoNeoadjuvantTherapyRec   $char2. /*Response to Neoadjuvant Therapy Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @743 SarcomatoidFeatures_Recode_2010   $char2. /*Sarcomatoid Features Recode (2010+)                     (Not available for NY, MA, ID and TX)*/
      @745 SeparateTumorNodulesIpsilateral   $char2. /*Separate Tumor Nodules Ipsilateral Lung Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @747 Tumor_Deposits_Recode_2010	     $char3. /*Tumor Deposits Recode (2010+)                           (Not available for NY, MA, ID and TX)*/
      @750 Ulceration_Recode_2010	     $char2. /*Ulceration Recode (2010+)                               (Not available for NY, MA, ID and TX)*/
      @752 VisceralandParietalPleuralInvas   $char2. /*Visceral and Parietal Pleural Invasion Recode (2010+)   (Not available for NY, MA, ID and TX)*/
      @754 ENHANCED_FIVE_PERCENT_FLAG        $char1. /*Five Percent Flag from MBSF*/
      @755 Date_of_Death_Flag_created        $char1. /*Date of Death Flag (SEER vs Medicare)                   (Not available for NY, MA, ID and TX)*/
      @756 Date_of_Birth_Flag_created        $char1. /*Date of Birth Flag (SEER vs Medicare)*/

      @757 OncotypeDXBreastRecurrenceScore   3. /*Oncotype DX Breast Recurrence Score  -- Needs special permission  (Not available for MA and TX)*/
      @760 OncotypeDXRSgroupRS18RS1830RS30   1. /*Oncotype DX RS group (RS < 18, RS 18-30, RS > 30) -- Needs special permission  (Not available for MA and TX)*/
      @761 OncotypeDXreasonno_score_linked   1. /*Oncotype DX reason no score linked -- Needs special permission    (Not available for MA and TX)*/
      @762 Oncotype_DX_year_of_test_report   4. /*Oncotype DX year of test report -- Needs special permission       (Not available for MA and TX)*/
      @766 OncotypeDX_month_of_test_report   2. /*Oncotype DX month of test report -- Needs special permission      (Not available for MA and TX)*/
      @768 OncotypeDXmonthssince_diagnosis   3. /*Oncotype DX months since diagnosis -- Needs special permission    (Not available for MA and TX)*/
      ;


  label
     PATIENT_ID                        = "Patient ID"
     SEER_registry                     = "Registry"
     SEERregistrywithCAandGAaswholes   = "Registry with CA and GA as whole states"
     Louisiana20051stvs2ndhalfofyear   = "Louisiana 2005 1st vs 2nd half of the year"
     Marital_status_at_diagnosis       = "Marital Status"
     Race_ethnicity                    = "Race ethnicity"
     sex                               = "Sex"
     Agerecodewithsingleages_and_100   = "Age recode with single ages and 100+"
     agerecodewithsingle_ages_and_85   = "Age recode with single ages and 85+"
     Sequence_number                   = "Sequence Number"
     Month_of_diagnosis                = "Month of Diagnosis, Not month diagnosis recode"
     Year_of_diagnosis                 = "Year of Diagnosis"
     CoC_Accredited_Flag_2018          = "CoC Accredited Flag (2018+)"
     Month_of_diagnosis_recode         = "Month of Diagnosis Recode"
     Primary_Site                      = "Primary Site"
     Laterality                        = "Laterality"
     Histology_ICD_O_2                 = "Histology ICD-0-2"
     Behavior_code_ICD_O_2             = "Behavior ICD-0-2"
     Histologic_Type_ICD_O_3           = "Histologic type ICD-0-3"
     Behavior_code_ICD_O_3             = "Behavior code ICD-0-3"
     Grade_thru_2017                   = "Grade (thru 2017)"
     Schema_ID_2018                    = "Schema ID (2018+)"
     Grade_Clinical_2018               = "Grade Clinical (2018+)"
     Grade_Pathological_2018           = "Grade Pathological (2018+)"
     Diagnostic_Confirmation           = "Diagnostic Confirmation"
     Type_of_Reporting_Source          = "Type of Reporting Source"
     EOD_10_size_1988_2003             = "EOD 10 - SIZE (1998-2003)"
     EOD_10_extent_1988_2003           = "EOD 10 - EXTENT (1998-2003)"
     EOD10Prostatepath_ext_1995_2003   = "EOD 10 - Prostate path ext (1995-2003)"
     EOD_10_nodes_1988_2003            = "EOD 10 - Nodes (1995-2003)"
     Regional_nodes_positive_1988      = "EOD 10 - Regional Nodes positive (1988+)"
     Regional_nodes_examined_1988      = "EOD 10 - Regional Nodes examined (1988+)"
     Expanded_EOD_1_CP53_1973_1982     = "EOD - expanded 1st digit"
     Expanded_EOD_2_CP54_1973_1982     = "EOD - expanded 2nd digit"
     Expanded_EOD_3_CP55_1973_1982     = "EOD - expanded 3rd digit"
     Expanded_EOD_4_CP56_1973_1982     = "EOD - expanded 4th digit"
     Expanded_EOD_5_CP57_1973_1982     = "EOD - expanded 5th digit"
     Expanded_EOD_6_CP58_1973_1982     = "EOD - expanded 6th digit"
     Expanded_EOD_7_CP59_1973_1982     = "EOD - expanded 7th digit"
     Expanded_EOD_8_CP60_1973_1982     = "EOD - expanded 8th digit"
     Expanded_EOD_9_CP61_1973_1982     = "EOD - expanded 9th digit"
     Expanded_EOD_10_CP62_1973_1982    = "EOD - expanded 10th digit"
     Expanded_EOD_11_CP63_1973_1982    = "EOD - expanded 11th digit"
     Expanded_EOD_12_CP64_1973_1982    = "EOD - expanded 12th digit"
     Expanded_EOD_13_CP65_1973_1982    = "EOD - expanded 13th digit"
     EOD_4_size_1983_1987              = "EOD 4 - Size (1983-1987)         "
     EOD_4_extent_1983_1987            = "EOD 4 - Extent (1983-1987)       "
     EOD_4_nodes_1983_1987             = "EOD 4 - Nodes (1983-1987)        "
     Coding_system_EOD_1973_2003       = "EOD Coding System (1973-2003)    "
     Tumor_marker_1_1990_2003          = "Tumor marker 1 (1990-2003)       "
     Tumor_marker_2_1990_2003          = "Tumor marker 2 (1990-2003)       "
     Tumor_marker_3_1998_2003          = "Tumor marker 3 (1990-2003        "
     CS_tumor_size_2004_2015           = "CS Tumor size (2004-2015)        "
     CS_extension_2004_2015            = "CS extension (2004-2015)         "
     CS_lymph_nodes_2004_2015          = "CS Lymph nodes (2004-2015)       "
     CS_mets_at_dx_2004_2015           = "CS Mets at dx                    "
     CSsitespecificfactor120042017va   = "CS site-specific factor 1 (2004-2017 varying by schema)"
     CSsitespecificfactor220042017va   = "CS site-specific factor 2 (2004-2017 varying by schema)"
     CSsitespecificfactor320042017va   = "CS site-specific factor 3 (2004-2017 varying by schema)"
     CSsitespecificfactor420042017va   = "CS site-specific factor 4 (2004-2017 varying by schema)"
     CSsitespecificfactor520042017va   = "CS site-specific factor 5 (2004-2017 varying by schema)"
     CSsitespecificfactor620042017va   = "CS site-specific factor 6 (2004-2017 varying by schema)"
     CSsitespecificfactor720042017va   = "CS site-specific factor 7 (2004-2017 varying by schema)"
     CSsitespecificfactor820042017va   = "CS site-specific factor 8 (2004-2017 varying by schema)"
     CSsitespecificfactor920042017va   = "CS site-specific factor 9 (2004-2017 varying by schema)"
     CSsitespecificfactor1020042017v   = "CS site-specific factor 10 (2004-2017 varying by schema)"
     CSsitespecificfactor1120042017v   = "CS site-specific factor 11 (2004-2017 varying by schema)"
     CSsitespecificfactor1220042017v   = "CS site-specific factor 12 (2004-2017 varying by schema)"
     CSsitespecificfactor1320042017v   = "CS site-specific factor 13 (2004-2017 varying by schema)"
     CSsitespecificfactor1520042017v   = "CS site-specific factor 15 (2004-2017 varying by schema)"
     CSsitespecificfactor1620042017v   = "CS site-specific factor 16 (2004-2017 varying by schema)"
     CSsitespecificfactor2520042017v   = "CS site-specific factor 25 (2004-2017 varying by schema)"
     Derived_AJCC_T_6th_ed_2004_2015   = "Derived AJCC T 6th ed (2004-2015)"
     Derived_AJCC_N_6th_ed_2004_2015   = "Derived AJCC N 6th ed (2004-2015)"
     Derived_AJCC_M_6th_ed_2004_2015   = "Derived AJCC M 6th ed (2004-2015)"
     DerivedAJCCStageGroup6thed20042   = "Derived AJCC STAGE Group 6th ed (2004-2015)"
     SEERCombinedSummaryStage2000200   = "SEER Combined Summary Stage 2000 (2004+)"
     Combined_Summary_Stage_2004       = "Combined Summary Stage (2004+)"
     CSversioninputoriginal2004_2015   = "CS version input original (2004-2015)"
     CS_version_derived_2004_2015      = "CS version derived (2004-2015)"
     CSversioninputcurrent_2004_2015   = "CS version input current (2004-2015)"
     RX_Summ_Surg_Prim_Site_1998       = "RX Summ-Surg Prim site 1998+     "
     RX_Summ_Scope_Reg_LN_Sur_2003     = "RX Summ-Scope Reg LN Sur (2003+) "
     RX_Summ_Surg_Oth_Reg_Dis_2003     = "RX Summ-Surg Oth reg/dis (2003+) "
     RXSummReg_LN_Examined_1998_2002   = "RX Summ-Reg LN examined (1998-2002)"
     RX_Summ_Systemic_Surg_Seq         = "RX Summ--Systemic Surg Seq"
     RX_Summ_Surg_Rad_Seq              = "Radiation Sequence with Surgery"
     Reasonnocancer_directed_surgery   = "Reason No Cancer-Directed Surgery"
     Radiation_recode                  = "Radiation Recode (0 and 9 combined) - created"
     Chemotherapy_recode_yes_no_unk    = "CHEMOTHERAPY Recode, yes(1)/no/unknown(0) - created"
     Sitespecificsurgery19731997vary   = "Site Specific Surgery (1973-1997)"
     Scopeofreglymphndsurg_1998_2002   = "Scope of Reg Lymph ND Surg (1998-2002)"
     Surgeryofothregdissites19982002   = "Surgery of Oth Reg/Dis sites (1998-2002)"
     Record_number_recode              = "Record Number Recode             "
     Age_recode_with_1_year_olds       = "Age Recode with <1 Year Olds     "
     Site_recode_ICD_O_3_WHO_2008      = "Site Recode ICD-O-3/WHO 2008)    "
     Site_recode_rare_tumors           = "Site recode - rare tumors"
     Behavior_recode_for_analysis      = "Behavior Recode for Analysis"
     Histologyrecode_broad_groupings   = "Histology Recode - Broad Groupings"
     Histologyrecode_Brain_groupings   = "Histology Recode - Brain Groupings"
     ICCCsiterecodeextended3rdeditio   = "ICCC Site Recode Extended 3rd Edition/IARC 2017"
     TNM_7_CS_v0204_Schema_thru_2017   = "TNM 7/CS v0204+ Schema (thru 2017)"
     TNM_7_CS_v0204_Schema_recode      = "TNM 7/CS v0204+ Schema recode"
     Race_recode_White_Black_Other     = "Race Recode (White, Black, Other)"
     Race_recode_W_B_AI_API            = "Race Recode (W, B, AI, API)"
     OriginrecodeNHIAHispanicNonHisp   = "Origin Recode NHIA (Hispanic, Non-Hispanic)"
     RaceandoriginrecodeNHWNHBNHAIAN   = "Race and origin recode (NHW, NHB, NHAIAN, NHAPI, Hispanic)"
     SEER_historic_stage_A_1973_2015   = "SEER Historic Stage A (1973-2015)"
     AJCCstage_3rd_edition_1988_2003   = "AJCC Stage 3rd Edition (1988-2003)"
     SEERmodifiedAJCCstage3rd1988200   = "SEER Modified AJCC Stage 3rd Edition (1988-2003)"
     Firstmalignantprimary_indicator   = "First Malignant Primary Indicator"
     state                             = "FIPS State"
     county                            = "FIPS County"
     Medianhouseholdincomeinflationa   = "County Attributes - Time Dependent Income"
     Rural_Urban_Continuum_Code        = "County Attributes - Time Dependent Rurality"
     PRCDA_2017	                       = "PRCDA - 2017"
     PRCDA_Region	             = "PRCDA - Region"
     COD_to_site_recode                = "COD to Site Recode"
     COD_to_site_rec_KM                = "COD to Site Recode KM"
     Vitalstatusrecodestudycutoffuse   = "Vital Status Recode (Study Cutoff Used)"
     IHS_Link                          = "IHS LINK"
     Summary_stage_2000_1998_2017      = "Summary stage 2000 (1998-2017)"
     AYA_site_recode_WHO_2008          = "AYA site recode/WHO 2008"
     AYA_site_recode_2020_Revision     = "AYA site recode 2020 Revision"
     Lymphoidneoplasmrecode2021Revis   = "Lymphoid neoplasm recode 2021 Revision"
     LymphomasubtyperecodeWHO2008thr   = "Lymphoma subtype recode/WHO 2008 (thru 2017)"
     SEER_Brain_and_CNS_Recode         = "SEER Brain and CNS Recode"
     ICCCsiterecode3rdeditionIARC201   = "ICCC Site Recode 3rd Edition/IARC 2017"
     SEERcausespecificdeathclassific   = "SEER Cause-Specific Death Classification"
     SEERothercauseofdeathclassifica   = "SEER Other Cause of Death Classification"
     CSTumor_Size_Ext_Eval_2004_2015   = "CS Tumor Size/Ext Eval (2004-2015) "
     CS_Reg_Node_Eval_2004_2015        = "CS Reg Node Eval (2004-2015)"
     CS_Mets_Eval_2004_2015            = "CS Mets Eval (2004-2015)"
     Primary_by_international_rules    = "Primary by International Rules"
     ERStatusRecodeBreastCancer_1990   = "ER Status Recode Breast Cancer (1990+)"
     PRStatusRecodeBreastCancer_1990   = "PR Status Recode Breast Cancer (1990+)"
     CS_Schema_AJCC_6th_Edition        = "CS Schema--AJCC 6th Edition"
     LymphvascularInvasion2004varyin   = "Lymph Vascular Invasion (2004+ Varying by Schema)"
     Survival_months                   = "Survival Months"
     Survival_months_flag              = "Survival Months Flag"
     Derived_AJCC_T_7th_ed_2010_2015   = "Derived AJCC T, 7th Ed 2010-2015)"
     Derived_AJCC_N_7th_ed_2010_2015   = "Derived AJCC N, 7th Ed 2010-2015)"
     Derived_AJCC_M_7th_ed_2010_2015   = "Derived AJCC M, 7th Ed 2010-2015)"
     DerivedAJCCStageGroup7thed20102   = "Derived AJCC Stage Group, 7th Ed 2010-2015)"
     BreastAdjustedAJCC6thT1988_2015   = "Breast--Adjusted AJCC 6th T (1988-2015)"
     BreastAdjustedAJCC6thN1988_2015   = "Breast--Adjusted AJCC 6th N (1988-2015)"
     BreastAdjustedAJCC6thM1988_2015   = "Breast--Adjusted AJCC 6th M (1988-2015)"
     BreastAdjustedAJCC6thStage19882   = "Breast--Adjusted AJCC 6th Stage (1988-2015)"
     Derived_HER2_Recode_2010          = "Derived HER2 Recode (2010+)"
     Breast_Subtype_2010               = "Breast Subtype (2010+)"
     LymphomaAnnArborStage_1983_2015   = "Lymphomas: Ann Arbor Staging (1983-2015)"
     SEERCombinedMetsat_DX_bone_2010   = "SEER Combined Mets at Dx-Bone (2010+)"
     SEERCombinedMetsatDX_brain_2010   = "SEER Combined Mets at Dx-Brain (2010+)"
     SEERCombinedMetsatDX_liver_2010   = "SEER Combined Mets at Dx-Liver (2010+)"
     SEERCombinedMetsat_DX_lung_2010   = "SEER Combined Mets at Dx-Lung (2010+)"
     TvaluebasedonAJCC_3rd_1988_2003   = "T Value - Based on AJCC 3rd (1988-2003)"
     NvaluebasedonAJCC_3rd_1988_2003   = "N Value - Based on AJCC 3rd (1988-2003)"
     MvaluebasedonAJCC_3rd_1988_2003   = "M Value - Based on AJCC 3rd (1988-2003)"
     Totalnumberofinsitumalignanttum   = "Total Number of In Situ/Malignant Tumors for Patient"
     Totalnumberofbenignborderlinetu   = "Total Number of Benign/Borderline Tumors for Patient"
     RadiationtoBrainorCNSRecode1988   = "Radiation to Brain or CNS Recode (1988-1997)"
     Tumor_Size_Summary_2016	       = "Tumor Size Summary (2016+)"
     DerivedSEERCmbStg_Grp_2016_2017   = "Derived SEER Combined STG GRP (2016+)"
     DerivedSEERCombined_T_2016_2017   = "Derived SEER Combined T (2016+)"
     DerivedSEERCombined_N_2016_2017   = "Derived SEER Combined N (2016+)"
     DerivedSEERCombined_M_2016_2017   = "Derived SEER Combined M (2016+)"
     DerivedSEERCombinedTSrc20162017   = "Derived SEER Combined T SRC (2016+)"
     DerivedSEERCombinedNSrc20162017   = "Derived SEER Combined N SRC (2016+)"
     DerivedSEERCombinedMSrc20162017   = "Derived SEER Combined M SRC (2016+)"
     TNM_Edition_Number_2016_2017      = "TNM Edition Number (2016-2017)"
     Mets_at_DX_Distant_LN_2016	       = "Mets at Dx-Distant LN (2016+)"
     Mets_at_DX_Other_2016	       = "Mets at DX--Other (2016+)"
     AJCC_ID_2018                      = "AJCC ID (2018+)"
     EOD_Schema_ID_Recode_2010         = "EOD Schema ID Recode (2010+)"
     Derived_EOD_2018_T_2018           = "Derived EOD 2018 T (2018+)"
     Derived_EOD_2018_N_2018           = "Derived EOD 2018 N (2018+)"
     Derived_EOD_2018_M_2018           = "Derived EOD 2018 M (2018+)"
     DerivedEOD2018_Stage_Group_2018   = "Derived EOD 2018 Stage Group (2018+)"
     EOD_Primary_Tumor_2018            = "EOD Primary Tumor (2018+)"
     EOD_Regional_Nodes_2018           = "EOD Regional Nodes (2018+)"
     EOD_Mets_2018                     = "EOD Mets (2018+)"
     Monthsfromdiagnosisto_treatment   = "Months from diagnosis to treatment"
     Census_Tract_1990                 = "Census Track 1990"
     Census_Tract_2000                 = "Census Track 2000"
     Census_Tract_2010                 = "Census Track 2010"
     Census_Coding_System	       = "Coding System for Census Track 1970/80/90"
     Census_Tract_Certainty_1990       = "Census Tract Certainty 1970/1980/1990"
     Census_Tract_Certainty_2000       = "Census Tract Certainty 2000"
     Census_Tract_Certainty_2010       = "Census Tract Certainty 2010"
     Rural_Urban_Continuum_Code_1993   = "Rural-Urban Continuum Code 1993 - From SEER*Stat"
     Rural_Urban_Continuum_Code_2003   = "Rural-Urban Continuum Code 2003 - From SEER*Stat"
     Rural_Urban_Continuum_Code_2013   = "Rural-Urban Continuum Code 2013 - From SEER*Stat"
     Health_Service_Area               = "Health Service Area - From SEER*Stat"
     HealthService_Area_NCI_Modified   = "Health Service Area NCI Modified - From SEER*Stat"
     County_at_DX_Geocode_1990         = "County at DX Geocode 1990"
     County_at_DX_Geocode_2000	       = "County at DX Geocode 2000"
     County_at_DX_Geocode_2010         = "County at DX Geocode 2010"
     Derived_SS1977_flag               = "Derived SS1977 - Flag (2004+)"
     Derived_SS2000_flag               = "Derived SS2000 - Flag (2004+)"
     Radiation                         = "Radiation"
     RadiationtoBrainorCNS_1988_1997   = "Radiation to Brain or CNS (1988-1997)"
     SEER_DateofDeath_Month            = "Death Month based on Stat_rec"
     SEER_DateofDeath_Year             = "Death Year based on Stat_rec"
     Month_of_last_follow_up_recode    = "Month of Follow-up recode, study cutoff used"
     Year_of_last_follow_up_recode     = "Year of Follow-up recode, study cutoff used"
     Year_of_birth                     = "Year of Birth"
     Date_of_diagnosis_flag            = "Date of Diagnosis Flag"
     Date_therapy_started_flag         = "Date of Therapy Started Flag"
     Date_of_birth_flag                = "Date of Birth flag"
     Date_of_last_follow_up_flag       = "Date of Last Follow-up Flag"
     Month_therapy_started             = "Month Therapy Started"
     Year_therapy_started              = "Year Therapy Started"
     Other_cancer_directed_therapy     = "Other Cancer-Directed Therapy"
     Derived_AJCC_flag                 = "Derived AJCC - Flag (2004+)"
     Derived_SS1977                    = "Derived SS1977 (2004-2015)"
     Derived_SS2000                    = "Derived SS2000 (2004+)"
     SEER_Summary_stage_1977_9500      = "SEER summary stage 1977(1995-2000)"
     SEER_Summary_stage_2000_0103      = "SEER summary stage 2000(2001-2003)"
     Primary_Payer_at_DX               = "Primary Payer at DX"
     Recode_ICD_0_2_to_9               = "Recode ICD-O-2 to 9"
     Recode_ICD_0_2_to_10              = "Recode ICD-O-2 to 10"
     NHIA_Derived_Hisp_Origin          = "NHIA Dervied Hispanic Origin"
     Age_site_edit_override            = "Age-site edit override"
     Sequencenumber_dx_conf_override   = "Sequence number-dx conf override"
     Site_type_lat_seq_override        = "Site-type-lat-seq override"
     Surgerydiagnostic_conf_override   = "Surgery-diagnostic conf override"
     Site_type_edit_override           = "Site-type edit override"
     Histology_edit_override           = "Histology edit override"
     Report_source_sequence_override   = "Report source sequence override"
     Seq_ill_defined_site_override     = "Seq-ill-defined site override"
     LeukLymphdxconfirmationoverride   = "Leuk-Lymph dx confirmation override"
     Site_behavior_override            = "Site-behavior override"
     Site_EOD_dx_date_override         = "Site-EOD-dx date override"
     Site_laterality_EOD_override      = "Site-laterality-EOD override"
     Site_laterality_morph_override    = "Site-laterality-morph override"
     SEER_Summary_Stage_2000newonly    = "Summary Stage 2000 (NAACCR Item-759) (Only to be available for new registries for diagnosis years 2000-2003)"
     Insurance_Recode_2007             = "Insurance Recode (2007+)"
     Yost_ACS_2006_2010                = "Yost Index (ACS 2006-2010)"
     Yost_ACS_2010_2014                = "Yost Index (ACS 2010-2014)"
     Yost_ACS_2013_2017                = "Yost Index (ACS 2013-2017)"
     Yost_ACS_2006_2010_State_based    = "Yost Index (ACS 2006-2010) - State Based"
     Yost_ACS_2010_2014_State_based    = "Yost Index (ACS 2010-2014) - State Based"
     Yost_ACS_2013_2017_State_based    = "Yost Index (ACS 2013-2017) - State Based"
     Yost_ACS_2006_2010_quintile       = "Yost Index Quintile (ACS 2006-2010)"
     Yost_ACS_2010_2014_quintile       = "Yost Index Quintile (ACS 2010-2014)"
     Yost_ACS_2013_2017_quintile       = "Yost Index Quintile (ACS 2013-2017)"
     YostACS20062010quintileStatebas   = "Yost Index Quintile (ACS 2006-2010) - State Based"
     YostACS20102014quintileStatebas   = "Yost Index Quintile (ACS 2010-2014) - State Based"
     YostACS20132017quintileStatebas   = "Yost Index Quintile (ACS 2013-2017) - State Based"
     Brain_Molecular_Markers_2018      = "Brain Molecular Markers (2018+)"
     AFPPostOrchiectomyLabValueRecod   = "AFP Post-Orchiectomy Lab Value Recode (2010+)"
     AFPPretreatmentInterpretationRe   = "AFP Pretreatment Interpretation Recode (2010+)"
     B_Symptoms_Recode_2010            = "B Symptoms Recode (2010+)"
     Breslow_Thickness_Recode_2010     = "Breslow Thickness Recode (2010+)"
     CA125PretreatmentInterpretation   = "CA-125 Pretreatment Interpretation Recode (2010+)"
     CEAPretreatmentInterpretationRe   = "CEA Pretreatment Interpretation Recode (2010+)"
     Chromosome19qLossofHeterozygosi   = "Chromosome 19q: Loss of Heterozygosity (LOH) Recode (2010+)"
     Chromosome1pLossofHeterozygosit   = "Chromosome 1p: Loss of Heterozygosity (LOH) Recode (2010+)"
     Fibrosis_Score_Recode_2010        = "Fibrosis Score Recode (2010+)"
     GestationalTrophoblasticPrognos   = "Gestational Trophoblastic Prognostic Scoring Index Recode (2010+)"
     GleasonPatternsClinicalRecode20   = "Gleason Patterns Clinical Recode (2010+)"
     GleasonPatternsPathologicalReco   = "Gleason Patterns Pathological Recode (2010+)"
     GleasonScoreClinicalRecode_2010   = "Gleason Score Clinical Recode (2010+)"
     GleasonScorePathologicalRecode2   = "Gleason Score Pathological Recode (2010+)"
     hCGPostOrchiectomyRangeRecode20   = "hCG Post-Orchiectomy Range Recode (2010+)"
     InvasionBeyondCapsuleRecode2010   = "Invasion Beyond Capsule Recode (2010+)"
     IpsilateralAdrenalGlandInvolvem   = "Ipsilateral Adrenal Gland Involvement Recode (2010+)"
     LDHPostOrchiectomyRangeRecode20   = "LDH Post-Orchiectomy Range Recode (2010+)"
     LDHPretreatmentLevelRecode_2010   = "LDH Pretreatment Level Recode (2010+)"
     LNHeadandNeckLevelsIIIIRecode20   = "LN Head and Neck Levels I-III Recode (2010+)"
     LNHeadandNeckLevelsIVVRecode201   = "LN Head and Neck Levels IV-V Recode (2010+)"
     LNHeadandNeckLevelsVIVIIRecode2   = "LN Head and Neck Levels VI-VII Recode (2010+)"
     LNHeadandNeck_Other_Recode_2010   = "LN Head and Neck Other Recode (2010+)"
     LNPositiveAxillaryLevelIIIRecod   = "LN Positive Axillary Level I-II Recode (2010+)"
     Lymph_Node_Size_Recode_2010       = "Lymph Node Size Recode (2010+)"
     MajorVeinInvolvementRecode_2010   = "Major Vein Involvement Recode (2010+)"
     MeasuredBasalDiameterRecode2010   = "Measured Basal Diameter Recode (2010+)"
     Measured_Thickness_Recode_2010    = "Measured Thickness Recode (2010+)"
     MitoticRateMelanoma_Recode_2010   = "Mitotic Rate Melanoma Recode (2010+)"
     NumberofCoresPositiveRecode2010   = "Number of Cores Positive Recode (2010+)"
     NumberofCoresExaminedRecode2010   = "Number of Cores Examined Recode (2010+)"
     NumberofExaminedParaAorticNodes   = "Number of Examined Para-Aortic Nodes Recode (2010+)"
     NumberofExaminedPelvicNodesReco   = "Number of Examined Pelvic Nodes Recode (2010+)"
     NumberofPositiveParaAorticNodes   = "Number of Positive Para-Aortic Nodes Recode (2010+)"
     NumberofPositivePelvicNodesReco   = "Number of Positive Pelvic Nodes Recode (2010+)"
     Perineural_Invasion_Recode_2010   = "Perineural Invasion Recode (2010+)"
     PeripheralBloodInvolvementRecod   = "Peripheral Blood Involvement Recode (2010+)"
     Peritoneal_Cytology_Recode_2010   = "Peritoneal Cytology Recode (2010+)"
     Pleural_Effusion_Recode_2010      = "Pleural Effusion Recode (2010+)"
     PSA_Lab_Value_Recode_2010         = "PSA Lab Value Recode (2010+)"
     ResidualTumorVolumePostCytoredu   = "Residual Tumor Volume Post Cytoreduction Recode (2010+)"
     ResponsetoNeoadjuvantTherapyRec   = "Response to Neoadjuvant Therapy Recode (2010+)"
     SarcomatoidFeatures_Recode_2010   = "Sarcomatoid Features Recode (2010+)"
     SeparateTumorNodulesIpsilateral   = "Separate Tumor Nodules Ipsilateral Lung Recode (2010+)"
     Tumor_Deposits_Recode_2010        = "Tumor Deposits Recode (2010+)"
     Ulceration_Recode_2010            = "Ulceration Recode (2010+)"
     VisceralandParietalPleuralInvas   = "Visceral and Parietal Pleural Invasion Recode (2010+)"
     ENHANCED_FIVE_PERCENT_FLAG        = "Five Percent Flag from MBSF"
     Date_of_Death_Flag_created        = "Date of Death Flag (SEER vs Medicare)"
     Date_of_Birth_Flag_created        = "Date of Birth Flag (SEER vs Medicare)"
     OncotypeDXBreastRecurrenceScore   = "Oncotype DX Breast Recurrence Score  -- Needs special permission"
     OncotypeDXRSgroupRS18RS1830RS30   = "Oncotype DX RS group (RS < 18, RS 18-30, RS > 30) -- Needs special permission"
     OncotypeDXreasonno_score_linked   = "Oncotype DX reason no score linked -- Needs special permission"
     Oncotype_DX_year_of_test_report   = "Oncotype DX year of test report -- Needs special permission"
     OncotypeDX_month_of_test_report   = "Oncotype DX month of test report -- Needs special permission"
     OncotypeDXmonthssince_diagnosis   = "Oncotype DX months since diagnosis -- Needs special permission"
      ;

run;

proc contents data=seer.SEER_in position;
run;


/* Lung cancer alone */ 


filename SEER_l 'S:\JamieHeyward\Dissertation Aim 2 SEER Medicare Cohort Study\SEERMed_IRAE\SEER Medicare irAE 2013-2019\SEER.lung.cancer.txt';                   /* reading in an un-zipped file */
*filename SEER_in pipe 'gunzip -c /directory/SEER.cancer.txt.gz'; /* reading in a zipped file */

options nocenter validvarname=upcase;

data seer.SEER_lung;
  infile SEER_l lrecl=771 missover pad;
  input
      @001 patient_id                        $char15. /* Patient ID (for either Cancer or Non-Cancer Patients) */
      @016 SEER_registry                     $char2. /*Registry*/
      @018 SEERregistrywithCAandGAaswholes   $char2. /*Registry with CA and GA as whole states*/
      @020 Louisiana20051stvs2ndhalfofyear   $char1. /*Louisiana 2005 1st vs 2nd half of the year*/
      @021 Marital_status_at_diagnosis       $char1. /*Marital Status               (Not available for NY, MA, ID and TX)*/
      @022 Race_ethnicity                    $char2. /*Race ethnicity*/
      @024 sex                               $char1. /*Sex*/
      @025 Agerecodewithsingleages_and_100   $char3. /*Age recode with single ages and 100+*/
      @028 agerecodewithsingle_ages_and_85   $char3. /*Age recode with single ages and 85+*/
      @031 Sequence_number                   $char2. /*Sequence Number*/
      @033 Month_of_diagnosis                $char2. /*Month of Diagnosis, Not month diagnosis recode*/
      @035 Year_of_diagnosis                 $char4. /*Year of Diagnosis*/
      @039 Coc_Accredited_Flag_2018          $char1. /*Coc Accredited Flag 2018+*/
      @040 Month_of_diagnosis_recode         $char2. /*Month of Diagnosis Recode*/
      @042 Primary_Site                      $char4. /*Primary Site*/
      @046 Laterality                        $char1. /*Laterality*/
      @047 Histology_ICD_O_2                 $char4. /*Histology ICD-0-2  (Not available for NY, MA, ID and TX)*/
      @051 Behavior_code_ICD_O_2             $char1. /*Behavior ICD-0-2   (Not available for NY, MA, ID and TX)*/
      @052 Histologic_Type_ICD_O_3           $char4. /*Histologic type ICD-0-3*/
      @056 Behavior_code_ICD_O_3             $char1. /*Behavior code ICD-0-3*/
      @067 Grade_thru_2017                   $char1. /*Grade thru 2017*/
      @068 Schema_ID_2018                    $char5. /*Schema ID (2018+)*/
      @073 Grade_Clinical_2018               $char1. /*Grade Clinical (2018+)*/
      @074 Grade_Pathological_2018           $char1. /*Grade Pathological (2018+)*/
      @075 Diagnostic_Confirmation           $char1. /*Diagnostic Confirmation*/
      @076 Type_of_Reporting_Source          $char1. /*Type of Reporting Source*/
      @077 EOD_10_size_1988_2003             $char3. /*EOD 10 - SIZE (1998-2003)     (Not available for NY, MA, ID and TX)*/
      @080 EOD_10_extent_1988_2003           $char2. /*EOD 10 - EXTENT (1998-2003)   (Not available for NY, MA, ID and TX)*/
      @082 EOD10Prostatepath_ext_1995_2003   $char2. /*EOD 10 - Prostate path ext (1995-2003)    (Not available for NY, MA, ID and TX)*/
      @084 EOD_10_nodes_1988_2003            $char1. /*EOD 10 - Nodes (1995-2003)                (Not available for NY, MA, ID and TX)*/
      @085 Regional_nodes_positive_1988      $char2. /*EOD 10 - Regional Nodes positive (1988+)  (limited to diagnosis years 2000-2003 for NY, MA, ID and TX)*/
      @087 Regional_nodes_examined_1988      $char2. /*EOD 10 - Regional Nodes examined (1988+)  (Not available for NY, MA, ID and TX)*/
      @089 Expanded_EOD_1_CP53_1973_1982     $char1. /*EOD - expanded 1-13                       (Not available for NY, MA, ID and TX)*/
      @090 Expanded_EOD_2_CP54_1973_1982     $char1.
      @091 Expanded_EOD_3_CP55_1973_1982     $char1.
      @092 Expanded_EOD_4_CP56_1973_1982     $char1.
      @093 Expanded_EOD_5_CP57_1973_1982     $char1.
      @094 Expanded_EOD_6_CP58_1973_1982     $char1.
      @095 Expanded_EOD_7_CP59_1973_1982     $char1.
      @096 Expanded_EOD_8_CP60_1973_1982     $char1.
      @097 Expanded_EOD_9_CP61_1973_1982     $char1.
      @098 Expanded_EOD_10_CP62_1973_1982    $char1.
      @099 Expanded_EOD_11_CP63_1973_1982    $char1.
      @100 Expanded_EOD_12_CP64_1973_1982    $char1.
      @101 Expanded_EOD_13_CP65_1973_1982    $char1.
      @106 EOD_4_size_1983_1987              $char2. /*EOD 4 - Size (1983-1987)       (Not available for NY, MA, ID and TX)  */
      @108 EOD_4_extent_1983_1987            $char1. /*EOD 4 - Extent (1983-1987)     (Not available for NY, MA, ID and TX)  */
      @109 EOD_4_nodes_1983_1987             $char1. /*EOD 4 - Nodes (1983-1987)      (Not available for NY, MA, ID and TX)  */
      @110 Coding_system_EOD_1973_2003       $char1. /*EOD Coding System (1973-2003)  (Not available for NY, MA, ID and TX)  */
      @111 Tumor_marker_1_1990_2003          $char1. /*Tumor marker 1 (1990-2003)     (Not available for NY, MA, ID and TX)  */
      @112 Tumor_marker_2_1990_2003          $char1. /*Tumor marker 2 (1990-2003)     (Not available for NY, MA, ID and TX)  */
      @113 Tumor_marker_3_1998_2003          $char1. /*Tumor marker 3 (1998-2003      (Not available for NY, MA, ID and TX)  */
      @114 CS_tumor_size_2004_2015           $char3. /*CS Tumor size (2004-2015)      (Not available for NY, MA, ID and TX)  */
      @117 CS_extension_2004_2015            $char3. /*CS extension (2004-2015)       (Not available for NY, MA, ID and TX)  */
      @120 CS_lymph_nodes_2004_2015          $char3. /*CS Lymph nodes (2004-2015)     (Not available for NY, MA, ID and TX)  */
      @123 CS_mets_at_dx_2004_2015           $char2. /*CS Mets at dx (2004-2015)      (Not available for NY, MA, ID and TX)  */
      @125 CSsitespecificfactor120042017va   $char3. /*CS Site-specific factor 1(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @128 CSsitespecificfactor220042017va   $char3. /*CS Site-specific factor 2(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @131 CSsitespecificfactor320042017va   $char3. /*CS Site-specific factor 3(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @134 CSsitespecificfactor420042017va   $char3. /*CS Site-specific factor 4(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @137 CSsitespecificfactor520042017va   $char3. /*CS Site-specific factor 5(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @140 CSsitespecificfactor620042017va   $char3. /*CS Site-specific factor 6(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @143 CSsitespecificfactor720042017va   $char3. /*CS Site-specific factor 7(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @146 CSsitespecificfactor820042017va   $char3. /*CS Site-specific factor 8(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @149 CSsitespecificfactor920042017va   $char3. /*CS Site-specific factor 9(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @152 CSsitespecificfactor1020042017v   $char3. /*CS Site-specific factor 10(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @155 CSsitespecificfactor1120042017v   $char3. /*CS Site-specific factor 11(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @158 CSsitespecificfactor1220042017v   $char3. /*CS Site-specific factor 12(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @161 CSsitespecificfactor1320042017v   $char3. /*CS Site-specific factor 13(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @164 CSsitespecificfactor1520042017v   $char3. /*CS Site-specific factor 15(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @167 CSsitespecificfactor1620042017v   $char3. /*CS Site-specific factor 16(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @170 CSsitespecificfactor2520042017v   $char3. /*CS Site-specific factor 25(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @173 Derived_AJCC_T_6th_ed_2004_2015   $char2. /*Derived AJCC T 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @175 Derived_AJCC_N_6th_ed_2004_2015   $char2. /*Derived AJCC N 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @177 Derived_AJCC_M_6th_ed_2004_2015   $char2. /*Derived AJCC M 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @179 DerivedAJCCStageGroup6thed20042   $char2. /*Derived AJCC STAGE Group 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @181 SEERcombinedSummaryStage2000200   $char1. /*SEER Combined Summary Stage 2000 (2004-2017) */
      @182 Combined_Summary_Stage_2004       $char1. /*Combined Summary Stage 2000 (2004+) */
      @183 CSversioninputoriginal2004_2015   $char6. /*CS Version Input (2004-2015)	       (Not available for NY, MA, ID and TX)*/
      @189 CS_version_derived_2004_2015      $char6. /*CS Version Derived (2004-2015)      (Not available for NY, MA, ID and TX)*/
      @195 CSversioninputcurrent_2004_2015   $char6. /*CS Version Current (2004-2015)      (Not available for NY, MA, ID and TX)*/
      @201 RX_Summ_Surg_Prim_Site_1998       $char2. /*RX Summ-Surg Prim site 1998+        (Not available for NY, MA, ID and TX)*/
      @203 RX_Summ_Scope_Reg_LN_Sur_2003     $char1. /*RX Summ-Scope Reg LN Sur (2003+)    (Not available for NY, MA, ID and TX)*/
      @204 RX_Summ_Surg_Oth_Reg_Dis_2003     $char1. /*RX Summ-Surg Oth reg/dis (2003+)    (Not available for NY, MA, ID and TX)*/
      @205 RXSummReg_LN_Examined_1998_2002   $char2. /*RX Summ-Reg LN examined (1998-2002) (Not available for NY, MA, ID and TX)*/
      @207 RX_Summ_Systemic_Surg_Seq         $char1. /*RX Summ--Systemic Surg Seq          (Not available for NY, MA, ID and TX)*/
      @208 RX_Summ_Surg_Rad_Seq              $char1. /*Radiation Sequence with Surgery     (Not available for NY, MA, ID and TX)*/
      @209 Reasonnocancer_directed_surgery   $char1. /*Reason No Cancer-Directed Surgery   (Not available for NY, MA, ID and TX)*/
      @210 Radiation_recode                  $char1. /*Radiation Recode (0 and 9 combined) - created         (Not available for NY, MA, ID and TX)*/
      @211 Chemotherapy_recode_yes_no_unk    $char1. /*CHEMOTHERAPY Recode, yes(1)/no/unknown(0) - created   (Not available for NY, MA, ID and TX)*/
      @212 Sitespecificsurgery19731997vary   $char2. /*Site Specific Surgery (1973-1997)         (Not available for NY, MA, ID and TX)*/
      @214 Scopeofreglymphndsurg_1998_2002   $char1. /*Scope of Reg Lymph ND Surg (1998-2002)    (Not available for NY, MA, ID and TX)*/
      @215 Surgeryofothregdissites19982002   $char1. /*Surgery of Oth Reg/Dis sites (1998-2002)  (Not available for NY, MA, ID and TX)*/
      @216 Record_number_recode              $char2. /*Record Number Recode             */
      @218 Age_recode_with_1_year_olds       $char2. /*Age Recode with <1 Year Olds     */
      @220 Site_recode_ICD_O_3_WHO_2008      $char5. /*Site Recode ICD-O-3/WHO 2008)    */
      @230 Site_recode_rare_tumors           $char5. /*Site Recode - rare tumor*/
      @240 Behavior_recode_for_analysis      $char1. /*Behavior Recode for Analysis*/
      @241 Histologyrecode_broad_groupings   $char2. /*Histology Recode - Broad Groupings*/
      @243 Histologyrecode_Brain_groupings   $char2. /*Histology Recode - Brain Groupings*/
      @245 ICCCsiterecodeextended3rdeditio   $char3. /*ICCC Site Recode Extended 3rd Edition/IARC 2017*/
      @248 TNM_7_CS_v0204_Schema_thru_2017   $char3. /*TNM 7/CS v0204+ Schema (thru 2017)  (Not available for NY, MA, ID and TX)*/
      @251 TNM_7_CS_v0204_Schema_recode      $char3. /*TNM 7/CS v0204+ Schema Recode       (Not available for NY, MA, ID and TX)*/
      @254 Race_recode_White_Black_Other     $char1. /*Race Recode (White, Black, Other)*/
      @255 Race_recode_W_B_AI_API            $char1. /*Race Recode (W, B, AI, API)*/
      @256 OriginrecodeNHIAHispanicNonHisp   $char1. /*Origin Recode NHIA (Hispanic, Non-Hispanic)*/
      @257 RaceandoriginrecodeNHWNHBNHAIAN   $char1. /*Race and origin recode (NHW, NHB, NHAIAN, NHAPI, Hispanic)*/
      @258 SEER_historic_stage_A_1973_2015   $char1. /*SEER Historic Stage A (1973-2015)     (Not available for NY, MA, ID and TX)*/
      @259 AJCCstage_3rd_edition_1988_2003   $char2. /*AJCC Stage 3rd Edition (1988-2003)    (Not available for NY, MA, ID and TX)*/
      @261 SEERmodifiedAJCCstage3rd1988200   $char2. /*SEER Modified AJCC Stage 3rd Edition (1988-2003)   (Not available for NY, MA, ID and TX)*/
      @263 Firstmalignantprimary_indicator   $char1. /*First Malignant Primary Indicator*/
      @264 state                             $char2. /*FIPS State*/
      @266 county                            $char3. /*FIPS County*/
      @274 Medianhouseholdincomeinflationa   $char2. /*Median Household Income Inflation adj to 2019*/
      @276 Rural_Urban_Continuum_Code        $char2. /*Rural-Urban Continuum Code*/
      @278 PRCDA_2017	                     $char1. /*PRCDA - 2017*/
      @279 PRCDA_Region	                     $char1. /*PRCDA - Region*/
      @280 COD_to_site_recode                $char5. /*COD to Site Recode        (Not available for NY, MA, ID and TX)*/
      @285 COD_to_site_rec_KM                $char5. /*COD to Site Recode KM     (Not available for NY, MA, ID and TX)*/
      @290 Vitalstatusrecodestudycutoffuse   $char1. /*Vital Status Recode (Study Cutoff Used) (Not available for NY, MA, ID and TX)*/
      @291 IHS_Link                          $char1. /*IHS LINK*/
      @292 Summary_stage_2000_1998_2017      $char1. /*Summary Stage 2000 (1998-2017) (Not available for NY, MA, ID and TX)*/
      @293 AYA_site_recode_WHO_2008          $char2. /*AYA Site Recode/WHO 2008*/
      @295 AYA_site_recode_2020_Revision     $char3. /*AYA Site Recode 2020 Revision*/
      @298 Lymphoidneoplasmrecode2021Revis   $char2. /*Lymphoid neoplasm recode 2021 Revision*/
      @302 LymphomasubtyperecodeWHO2008thr   $char2. /*Lymphoma Subtype Recode/WHO 2008 (thru 2017)*/
      @304 SEER_Brain_and_CNS_Recode         $char2. /*SEER Brain and CNS Recode*/
      @306 ICCCsiterecode3rdeditionIARC201   $char3. /*ICCC Site Recode 3rd Edition/IARC 2017*/
      @309 SEERcausespecificdeathclassific   $char1. /*SEER Cause-Specific Death Classification (Not available for NY, MA, ID and TX)*/
      @310 SEERothercauseofdeathclassifica   $char1. /*SEER Other Cause of Death Classification (Not available for NY, MA, ID and TX)*/
      @311 CSTumor_Size_Ext_Eval_2004_2015   $char1. /*CS Tumor Size/Ext Eval (2004-2015)  (Not available for NY, MA, ID and TX)*/
      @312 CS_Reg_Node_Eval_2004_2015        $char1. /*CS Reg Node Eval (2004-2015)        (Not available for NY, MA, ID and TX)*/
      @313 CS_Mets_Eval_2004_2015            $char1. /*CS Mets Eval (2004-2015)            (Not available for NY, MA, ID and TX)*/
      @314 Primary_by_international_rules    $char1. /*Primary by International Rules*/
      @315 ERStatusRecodeBreastCancer_1990   $char1. /*ER Status Recode Breast Cancer (1990+) (Not available for NY, MA, ID and TX)*/
      @316 PRStatusRecodeBreastCancer_1990   $char1. /*PR Status Recode Breast Cancer (1990+) (Not available for NY, MA, ID and TX)*/
      @317 CS_Schema_AJCC_6th_Edition        $char2. /*CS Schema--AJCC 6th Edition            (Not available for NY, MA, ID and TX)*/
      @319 LymphvascularInvasion2004varyin   $char1. /*Lymph Vascular Invasion (2004+ Varying by Schema) (Not available for NY, MA, ID and TX)*/
      @320 Survival_months                   $char4. /*Survival Months                    (Not available for NY, MA, ID and TX)*/
      @324 Survival_months_flag              $char1. /*Survival Months Flag               (Not available for NY, MA, ID and TX)*/
      @325 Derived_AJCC_T_7th_ed_2010_2015   $char3. /*Derived AJCC T, 7th Ed 2010-2015)  (Not available for NY, MA, ID and TX)*/
      @328 Derived_AJCC_N_7th_ed_2010_2015   $char3. /*Derived AJCC N, 7th Ed 2010-2015)  (Not available for NY, MA, ID and TX)*/
      @331 Derived_AJCC_M_7th_ed_2010_2015   $char3. /*Derived AJCC M, 7th Ed 2010-2015)  (Not available for NY, MA, ID and TX)*/
      @334 DerivedAJCCStageGroup7thed20102   $char3. /*Derived AJCC Stage Group, 7th Ed 2010-2015) (Not available for NY, MA, ID and TX)*/
      @337 BreastAdjustedAJCC6thT1988_2015   $char2. /*Breast--Adjusted AJCC 6th T (1988-2015)  (Not available for NY, MA, ID and TX)*/
      @339 BreastAdjustedAJCC6thN1988_2015   $char2. /*Breast--Adjusted AJCC 6th N (1988-2015)  (Not available for NY, MA, ID and TX)*/
      @341 BreastAdjustedAJCC6thM1988_2015   $char2. /*Breast--Adjusted AJCC 6th M (1988-2015)  (Not available for NY, MA, ID and TX)*/
      @343 BreastAdjustedAJCC6thStage19882   $char2. /*Breast--Adjusted AJCC 6th Stage (1988-2015) (Not available for NY, MA, ID and TX)*/
      @345 Derived_HER2_Recode_2010          $char1. /*Derived HER2 Recode (2010+)              (Not available for NY, MA, ID and TX)*/
      @346 Breast_Subtype_2010               $char1. /*Breast Subtype (2010+)*/
      @347 LymphomaAnnArborStage_1983_2015   $char1. /*Lymphomas: Ann Arbor Staging (1983-2015) (Not available for NY, MA, ID and TX)*/
      @348 SEERCombinedMetsat_DX_bone_2010   $char1. /*SEER Combined Mets at Dx-Bone (2010+)    (Not available for NY, MA, ID and TX)*/
      @349 SEERCombinedMetsatDX_brain_2010   $char1. /*SEER Combined Mets at Dx-Brain (2010+)   (Not available for NY, MA, ID and TX)*/
      @350 SEERCombinedMetsatDX_liver_2010   $char1. /*SEER Combined Mets at Dx-Liver (2010+)   (Not available for NY, MA, ID and TX)*/
      @351 SEERCombinedMetsat_DX_lung_2010   $char1. /*SEER Combined Mets at Dx-Lung (2010+)    (Not available for NY, MA, ID and TX)*/
      @352 TvaluebasedonAJCC_3rd_1988_2003   $char2. /*T Value - Based on AJCC 3rd (1988-2003)  (Not available for NY, MA, ID and TX)*/
      @354 NvaluebasedonAJCC_3rd_1988_2003   $char2. /*N Value - Based on AJCC 3rd (1988-2003)  (Not available for NY, MA, ID and TX)*/
      @356 MvaluebasedonAJCC_3rd_1988_2003   $char2. /*M Value - Based on AJCC 3rd (1988-2003)  (Not available for NY, MA, ID and TX)*/
      @358 Totalnumberofinsitumalignanttum   $char2. /*Total Number of In Situ/Malignant Tumors for Patient (Not available for NY, MA, ID and TX)*/
      @360 Totalnumberofbenignborderlinetu   $char2. /*Total Number of Benign/Borderline Tumors for Patient (Not available for NY, MA, ID and TX)*/
      @362 RadiationtoBrainorCNSRecode1988   $char1. /*Radiation to Brain or CNS Recode (1988-1997) (Not available for NY, MA, ID and TX)*/
      @363 Tumor_Size_Summary_2016	     $char3. /*Tumor Size Summary (2016+)              (Not available for NY, MA, ID and TX)*/
      @366 DerivedSEERCmbStg_Grp_2016_2017   $char5. /*Derived SEER Combined STG GRP (2016+)   (Not available for NY, MA, ID and TX)*/
      @371 DerivedSEERCombined_T_2016_2017   $char5. /*Derived SEER Combined T (2016+)         (Not available for NY, MA, ID and TX)*/
      @376 DerivedSEERCombined_N_2016_2017   $char5. /*Derived SEER Combined N (2016+)         (Not available for NY, MA, ID and TX)*/
      @381 DerivedSEERCombined_M_2016_2017   $char5. /*Derived SEER Combined M (2016+)         (Not available for NY, MA, ID and TX)*/
      @386 DerivedSEERCombinedTSrc20162017   $char1. /*Derived SEER Combined T SRC (2016+)     (Not available for NY, MA, ID and TX)*/
      @387 DerivedSEERCombinedNSrc20162017   $char1. /*Derived SEER Combined N SRC (2016+)     (Not available for NY, MA, ID and TX)*/
      @388 DerivedSEERCombinedMSrc20162017   $char1. /*Derived SEER Combined M SRC (2016+)     (Not available for NY, MA, ID and TX)*/
      @389 TNM_Edition_Number_2016_2017	     $char2. /*TNM Edition Number (2016-2017)          (Not available for NY, MA, ID and TX)*/
      @391 Mets_at_DX_Distant_LN_2016	     $char1. /*Mets at Dx-Distant LN (2016+)           (Not available for NY, MA, ID and TX)*/
      @392 Mets_at_DX_Other_2016	     $char1. /*Mets at DX--Other (2016+)               (Not available for NY, MA, ID and TX)*/
      @393 AJCC_ID_2018                      $char4. /*AJCC ID (2018+)*/
      @397 EOD_Schema_ID_Recode_2010         $char3. /*EOD Schema ID Recode (2010+)*/
      @400 Derived_EOD_2018_T_2018           $char15. /*Derived EOD 2018 T (2018+)             (Not available for NY, MA, ID and TX)*/
      @415 Derived_EOD_2018_N_2018           $char15. /*Derived EOD 2018 N (2018+)             (Not available for NY, MA, ID and TX)*/
      @430 Derived_EOD_2018_M_2018           $char15. /*Derived EOD 2018 M (2018+)             (Not available for NY, MA, ID and TX)*/
      @445 DerivedEOD2018_Stage_Group_2018   $char15. /*Derived EOD 2018 Stage Group (2018+)   (Not available for NY, MA, ID and TX)*/
      @460 EOD_Primary_Tumor_2018            $char3.  /*EOD Primary Tumor (2018+)              (Not available for NY, MA, ID and TX)*/
      @463 EOD_Regional_Nodes_2018           $char3.  /*EOD Regional Nodes (2018+)             (Not available for NY, MA, ID and TX)*/
      @466 EOD_Mets_2018                     $char2.  /*EOD Mets (2018+)                       (Not available for NY, MA, ID and TX)*/
      @468 Monthsfromdiagnosisto_treatment   $char3.  /*Months from diagnosis to treatment     (Not available for NY, MA, ID and TX)*/

   /*Not Public but released*/
      @471 Census_Tract_1990                 $char6. /*Census Track 1990, encrypted*/
      @477 Census_Tract_2000                 $char6. /*Census Track 2000, encrypted*/
      @483 Census_Tract_2010                 $char6. /*Census Track 2010, encrypted*/
      @489 Census_Coding_System	             $char1. /*Coding System for Census Track 1970/80/90*/
      @490 Census_Tract_Certainty_1990	     $char1. /*Census Tract Certainty 1970/1980/1990*/
      @491 Census_Tract_Certainty_2000	     $char1. /*Census Tract Certainty 2000*/
      @492 Census_Tract_Certainty_2010	     $char1. /*Census Tract Certainty 2010*/
      @493 Rural_Urban_Continuum_Code_1993   $char2. /*Rural-Urban Continuum Code 1993 - From SEER*Stat*/
      @495 Rural_Urban_Continuum_Code_2003   $char2. /*Rural-Urban Continuum Code 2003 - From SEER*Stat*/
      @497 Rural_Urban_Continuum_Code_2013   $char2. /*Rural-Urban Continuum Code 2013 - From SEER*Stat*/
      @499 Health_Service_Area               $char4. /*Health Service Area - From SEER*Stat*/
      @503 HealthService_Area_NCI_Modified   $char4. /*Health Service Area NCI Modified - From SEER*Stat*/
      @507 County_at_DX_Geocode_1990         $char3. /*County at DX Geocode 1990*/
      @510 County_at_DX_Geocode_2000	     $char3. /*County at DX Geocode 2000*/
      @513 County_at_DX_Geocode_2010         $char3. /*County at DX Geocode 2010*/
      @516 Derived_SS1977_flag               $char1. /*Derived SS1977 - Flag (2004+)         (Not available for NY, MA, ID and TX)*/
      @517 Derived_SS2000_flag               $char1. /*Derived SS2000 - Flag (2004+)         (Not available for NY, MA, ID and TX)*/
      @518 Radiation                         $char1. /*Radiation                             (Not available for NY, MA, ID and TX)*/
      @519 RadiationtoBrainorCNS_1988_1997   $char1. /*Radiation to Brain or CNS (1988-1997) (Not available for NY, MA, ID and TX)*/
      @520 SEER_DateofDeath_Month            $char2. /*Death Month based on Stat_rec         (Not available for NY, MA, ID and TX)*/
      @522 SEER_DateofDeath_Year             $char4. /*Death Year based on Stat_rec          (Not available for NY, MA, ID and TX)*/
      @526 Month_of_last_follow_up_recode    $char2. /*Month of Follow-up Recode, study cutoff used (Not available for NY, MA, ID and TX)*/
      @528 Year_of_last_follow_up_recode     $char4. /*Year of Follow-up Recode, study cutoff used  (Not available for NY, MA, ID and TX)*/
      @533 Year_of_birth                     $char4. /*Year of Birth*/
      @537 Date_of_diagnosis_flag            $char2. /*Date of Diagnosis Flag*/
      @539 Date_therapy_started_flag         $char2. /*Date of Therapy Started Flag*/
      @541 Date_of_birth_flag                $char2. /*Date of Birth flag*/
      @543 Date_of_last_follow_up_flag       $char2. /*Date of Last Follow-up Flag*/
      @545 Month_therapy_started             $char2. /*Month Therapy Started*/
      @547 Year_therapy_started              $char4. /*Year Therapy Started*/
      @551 Other_cancer_directed_therapy     $char1. /*Other Cancer-Directed Therapy*/
      @552 Derived_AJCC_flag                 $char1. /*Derived AJCC - Flag (2004+)        (Not available for NY, MA, ID and TX)*/
      @553 Derived_SS1977                    $char1. /*Derived SS1977 (2004-2015)         (Not available for NY, MA, ID and TX)*/
      @554 Derived_SS2000                    $char1. /*Derived SS2000 (2004+)             (Not available for NY, MA, ID and TX)*/
      @555 SEER_Summary_stage_1977_9500	     $char1. /*SEER summary stage 1977(1995-2000) (Not available for NY, MA, ID and TX)*/
      @556 SEER_Summary_stage_2000_0103	     $char1. /*SEER summary stage 2000(2001-2003) (Not available for NY, MA, ID and TX)*/

      @558 Primary_Payer_at_DX               $char2. /*Primary Payer at DX                 (Not available for NY, MA, ID and TX)*/
      @569 Recode_ICD_0_2_to_9               $char4. /*Recode ICD-O-2 to 9                 (Not available for NY, MA, ID and TX)*/
      @573 Recode_ICD_0_2_to_10              $char4. /*Recode ICD-O-2 to 10                (Not available for NY, MA, ID and TX)*/
      @577 NHIA_Derived_Hisp_Origin          $char1. /*NHIA Dervied Hispanic Origin        (Not available for NY, MA, ID and TX)*/
      @578 Age_site_edit_override            $char1. /*Age-site edit override              (Not available for NY, MA, ID and TX)*/
      @579 Sequencenumber_dx_conf_override   $char1. /*Sequence number-dx conf override    (Not available for NY, MA, ID and TX)*/
      @580 Site_type_lat_seq_override        $char1. /*Site-type-lat-seq override          (Not available for NY, MA, ID and TX)*/
      @581 Surgerydiagnostic_conf_override   $char1. /*Surgery-diagnostic conf override    (Not available for NY, MA, ID and TX)*/
      @582 Site_type_edit_override           $char1. /*Site-type edit override             (Not available for NY, MA, ID and TX)*/
      @583 Histology_edit_override           $char1. /*Histology edit override             (Not available for NY, MA, ID and TX)*/
      @584 Report_source_sequence_override   $char1. /*Report source sequence override     (Not available for NY, MA, ID and TX)*/
      @585 Seq_ill_defined_site_override     $char1. /*Seq-ill-defined site override       (Not available for NY, MA, ID and TX)*/
      @586 LeukLymphdxconfirmationoverride   $char1. /*Leuk-Lymph dx confirmation override (Not available for NY, MA, ID and TX)*/
      @587 Site_behavior_override            $char1. /*Site-behavior override              (Not available for NY, MA, ID and TX)*/
      @588 Site_EOD_dx_date_override         $char1. /*Site-EOD-dx date override           (Not available for NY, MA, ID and TX)*/
      @589 Site_laterality_EOD_override      $char1. /*Site-laterality-EOD override        (Not available for NY, MA, ID and TX)*/
      @590 Site_laterality_morph_override    $char1. /*Site-laterality-morph override      (Not available for NY, MA, ID and TX)*/

      @591 SEER_Summary_Stage_2000newonly    $char1. /*Summary Stage 2000 (NAACCR Item-759)   Only available for NY, MA, ID and TX for dx years 2001-2003*/

      @592 Insurance_Recode_2007             1. /*Insurance Recode (2007+)                 (Not available for NY, MA, ID and TX)*/
      @593 Yost_ACS_2006_2010                5. /*Yost Index (ACS 2006-2010)*/
      @598 Yost_ACS_2010_2014                5. /*Yost Index (ACS 2010-2014)*/
      @603 Yost_ACS_2013_2017                5. /*Yost Index (ACS 2013-2017)*/
      @608 Yost_ACS_2006_2010_State_based    5. /*Yost Index (ACS 2006-2010) - State based*/
      @613 Yost_ACS_2010_2014_State_based    5. /*Yost Index (ACS 2010-2014) - State based*/
      @618 Yost_ACS_2013_2017_State_based    5. /*Yost Index (ACS 2013-2017) - State based*/
      @623 Yost_ACS_2006_2010_quintile       $char1. /*Yost Index Quintile (ACS 2006-2010)*/
      @624 Yost_ACS_2010_2014_quintile       $char1. /*Yost Index Quintile (ACS 2010-2014)*/
      @625 Yost_ACS_2013_2017_quintile       $char1. /*Yost Index Quintile (ACS 2013-2017)*/
      @626 YostACS20062010quintileStatebas   $char1. /*Yost Index Quintile (ACS 2006-2010) - State based*/
      @627 YostACS20102014quintileStatebas   $char1. /*Yost Index Quintile (ACS 2010-2014) - State based*/
      @628 YostACS20132017quintileStatebas   $char1. /*Yost Index Quintile (ACS 2013-2017) - State based*/
      @629 Brain_Molecular_Markers_2018	     $char3. /*Brain Molecular Markers (2018+)                    (Not available for NY, MA, ID and TX)*/
      @632 AFPPostOrchiectomyLabValueRecod   $char3. /*AFP Post-Orchiectomy Lab Value Recode (2010+)      (Not available for NY, MA, ID and TX)*/
      @635 AFPPretreatmentInterpretationRe   $char2. /*AFP Pretreatment Interpretation Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @637 B_Symptoms_Recode_2010	     $char2. /*B Symptoms Recode (2010+)                          (Not available for NY, MA, ID and TX)*/
      @639 Breslow_Thickness_Recode_2010     $char5. /*Breslow Thickness Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @644 CA125PretreatmentInterpretation   $char2. /*CA-125 Pretreatment Interpretation Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @646 CEAPretreatmentInterpretationRe   $char2. /*CEA Pretreatment Interpretation Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @648 Chromosome19qLossofHeterozygosi   $char2. /*Chromosome 19q: Loss of Heterozygosity (LOH) Recode (2010+) (Not available for NY, MA, ID and TX)*/
      @650 Chromosome1pLossofHeterozygosit   $char2. /*Chromosome 1p: Loss of Heterozygosity (LOH) Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @652 Fibrosis_Score_Recode_2010	     $char2. /*Fibrosis Score Recode (2010+)                           (Not available for NY, MA, ID and TX)*/
      @654 GestationalTrophoblasticPrognos   $char2. /*Gestational Trophoblastic Prognostic Scoring Index Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @656 GleasonPatternsClinicalRecode20   $char3. /*Gleason Patterns Clinical Recode (2010+)                (Not available for NY, MA, ID and TX)*/
      @659 GleasonPatternsPathologicalReco   $char3. /*Gleason Patterns Pathological Recode (2010+)            (Not available for NY, MA, ID and TX)*/
      @662 GleasonScoreClinicalRecode_2010   $char2. /*Gleason Score Clinical Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @664 GleasonScorePathologicalRecode2   $char2. /*Gleason Score Pathological Recode (2010+)               (Not available for NY, MA, ID and TX)*/
      @666 hCGPostOrchiectomyRangeRecode20   $char2. /*hCG Post-Orchiectomy Range Recode (2010+)               (Not available for NY, MA, ID and TX)*/
      @668 InvasionBeyondCapsuleRecode2010   $char2. /*Invasion Beyond Capsule Recode (2010+)                  (Not available for NY, MA, ID and TX)*/
      @670 IpsilateralAdrenalGlandInvolvem   $char2. /*Ipsilateral Adrenal Gland Involvement Recode (2010+)    (Not available for NY, MA, ID and TX)*/
      @672 LDHPostOrchiectomyRangeRecode20   $char2. /*LDH Post-Orchiectomy Range Recode (2010+)               (Not available for NY, MA, ID and TX)*/
      @674 LDHPretreatmentLevelRecode_2010   $char2. /*LDH Pretreatment Level Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @676 LNHeadandNeckLevelsIIIIRecode20   $char2. /*LN Head and Neck Levels I-III Recode (2010+)            (Not available for NY, MA, ID and TX)*/
      @678 LNHeadandNeckLevelsIVVRecode201   $char2. /*LN Head and Neck Levels IV-V Recode (2010+)             (Not available for NY, MA, ID and TX)*/
      @680 LNHeadandNeckLevelsVIVIIRecode2   $char2. /*LN Head and Neck Levels VI-VII Recode (2010+)           (Not available for NY, MA, ID and TX)*/
      @682 LNHeadandNeck_Other_Recode_2010   $char2. /*LN Head and Neck Other Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @684 LNPositiveAxillaryLevelIIIRecod   $char3. /*LN Positive Axillary Level I-II Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @687 Lymph_Node_Size_Recode_2010	     $char3. /*Lymph Node Size Recode (2010+)                          (Not available for NY, MA, ID and TX)*/
      @690 MajorVeinInvolvementRecode_2010   $char2. /*Major Vein Involvement Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @692 MeasuredBasalDiameterRecode2010   $char5. /*Measured Basal Diameter Recode (2010+)                  (Not available for NY, MA, ID and TX)*/
      @697 Measured_Thickness_Recode_2010    $char5. /*Measured Thickness Recode (2010+)                       (Not available for NY, MA, ID and TX)*/
      @704 MitoticRateMelanoma_Recode_2010   $char3. /*Mitotic Rate Melanoma Recode (2010+)                    (Not available for NY, MA, ID and TX)*/
      @707 NumberofCoresPositiveRecode2010   $char3. /*Number of Cores Positive Recode (2010+)                 (Not available for NY, MA, ID and TX)*/
      @710 NumberofCoresExaminedRecode2010   $char3. /*Number of Cores Examined Recode (2010+)                 (Not available for NY, MA, ID and TX)*/
      @713 NumberofExaminedParaAorticNodes   $char3. /*Number of Examined Para-Aortic Nodes Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @716 NumberofExaminedPelvicNodesReco   $char3. /*Number of Examined Pelvic Nodes Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @719 NumberofPositiveParaAorticNodes   $char3. /*Number of Positive Para-Aortic Nodes Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @722 NumberofPositivePelvicNodesReco   $char3. /*Number of Positive Pelvic Nodes Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @725 Perineural_Invasion_Recode_2010   $char2. /*Perineural Invasion Recode (2010+)                      (Not available for NY, MA, ID and TX)*/
      @727 PeripheralBloodInvolvementRecod   $char2. /*Peripheral Blood Involvement Recode (2010+)             (Not available for NY, MA, ID and TX)*/
      @729 Peritoneal_Cytology_Recode_2010   $char2. /*Peritoneal Cytology Recode (2010+)                      (Not available for NY, MA, ID and TX)*/
      @731 Pleural_Effusion_Recode_2010	     $char2. /*Pleural Effusion Recode (2010+)                         (Not available for NY, MA, ID and TX)*/
      @733 PSA_Lab_Value_Recode_2010	     $char5. /*PSA Lab Value Recode (2010+)                            (Not available for NY, MA, ID and TX)*/
      @738 ResidualTumorVolumePostCytoredu   $char3. /*Residual Tumor Volume Post Cytoreduction Recode (2010+) (Not available for NY, MA, ID and TX)*/
      @741 ResponsetoNeoadjuvantTherapyRec   $char2. /*Response to Neoadjuvant Therapy Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @743 SarcomatoidFeatures_Recode_2010   $char2. /*Sarcomatoid Features Recode (2010+)                     (Not available for NY, MA, ID and TX)*/
      @745 SeparateTumorNodulesIpsilateral   $char2. /*Separate Tumor Nodules Ipsilateral Lung Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @747 Tumor_Deposits_Recode_2010	     $char3. /*Tumor Deposits Recode (2010+)                           (Not available for NY, MA, ID and TX)*/
      @750 Ulceration_Recode_2010	     $char2. /*Ulceration Recode (2010+)                               (Not available for NY, MA, ID and TX)*/
      @752 VisceralandParietalPleuralInvas   $char2. /*Visceral and Parietal Pleural Invasion Recode (2010+)   (Not available for NY, MA, ID and TX)*/
      @754 ENHANCED_FIVE_PERCENT_FLAG        $char1. /*Five Percent Flag from MBSF*/
      @755 Date_of_Death_Flag_created        $char1. /*Date of Death Flag (SEER vs Medicare)                   (Not available for NY, MA, ID and TX)*/
      @756 Date_of_Birth_Flag_created        $char1. /*Date of Birth Flag (SEER vs Medicare)*/

      @757 OncotypeDXBreastRecurrenceScore   3. /*Oncotype DX Breast Recurrence Score  -- Needs special permission  (Not available for MA and TX)*/
      @760 OncotypeDXRSgroupRS18RS1830RS30   1. /*Oncotype DX RS group (RS < 18, RS 18-30, RS > 30) -- Needs special permission  (Not available for MA and TX)*/
      @761 OncotypeDXreasonno_score_linked   1. /*Oncotype DX reason no score linked -- Needs special permission    (Not available for MA and TX)*/
      @762 Oncotype_DX_year_of_test_report   4. /*Oncotype DX year of test report -- Needs special permission       (Not available for MA and TX)*/
      @766 OncotypeDX_month_of_test_report   2. /*Oncotype DX month of test report -- Needs special permission      (Not available for MA and TX)*/
      @768 OncotypeDXmonthssince_diagnosis   3. /*Oncotype DX months since diagnosis -- Needs special permission    (Not available for MA and TX)*/
      ;


  label
     PATIENT_ID                        = "Patient ID"
     SEER_registry                     = "Registry"
     SEERregistrywithCAandGAaswholes   = "Registry with CA and GA as whole states"
     Louisiana20051stvs2ndhalfofyear   = "Louisiana 2005 1st vs 2nd half of the year"
     Marital_status_at_diagnosis       = "Marital Status"
     Race_ethnicity                    = "Race ethnicity"
     sex                               = "Sex"
     Agerecodewithsingleages_and_100   = "Age recode with single ages and 100+"
     agerecodewithsingle_ages_and_85   = "Age recode with single ages and 85+"
     Sequence_number                   = "Sequence Number"
     Month_of_diagnosis                = "Month of Diagnosis, Not month diagnosis recode"
     Year_of_diagnosis                 = "Year of Diagnosis"
     CoC_Accredited_Flag_2018          = "CoC Accredited Flag (2018+)"
     Month_of_diagnosis_recode         = "Month of Diagnosis Recode"
     Primary_Site                      = "Primary Site"
     Laterality                        = "Laterality"
     Histology_ICD_O_2                 = "Histology ICD-0-2"
     Behavior_code_ICD_O_2             = "Behavior ICD-0-2"
     Histologic_Type_ICD_O_3           = "Histologic type ICD-0-3"
     Behavior_code_ICD_O_3             = "Behavior code ICD-0-3"
     Grade_thru_2017                   = "Grade (thru 2017)"
     Schema_ID_2018                    = "Schema ID (2018+)"
     Grade_Clinical_2018               = "Grade Clinical (2018+)"
     Grade_Pathological_2018           = "Grade Pathological (2018+)"
     Diagnostic_Confirmation           = "Diagnostic Confirmation"
     Type_of_Reporting_Source          = "Type of Reporting Source"
     EOD_10_size_1988_2003             = "EOD 10 - SIZE (1998-2003)"
     EOD_10_extent_1988_2003           = "EOD 10 - EXTENT (1998-2003)"
     EOD10Prostatepath_ext_1995_2003   = "EOD 10 - Prostate path ext (1995-2003)"
     EOD_10_nodes_1988_2003            = "EOD 10 - Nodes (1995-2003)"
     Regional_nodes_positive_1988      = "EOD 10 - Regional Nodes positive (1988+)"
     Regional_nodes_examined_1988      = "EOD 10 - Regional Nodes examined (1988+)"
     Expanded_EOD_1_CP53_1973_1982     = "EOD - expanded 1st digit"
     Expanded_EOD_2_CP54_1973_1982     = "EOD - expanded 2nd digit"
     Expanded_EOD_3_CP55_1973_1982     = "EOD - expanded 3rd digit"
     Expanded_EOD_4_CP56_1973_1982     = "EOD - expanded 4th digit"
     Expanded_EOD_5_CP57_1973_1982     = "EOD - expanded 5th digit"
     Expanded_EOD_6_CP58_1973_1982     = "EOD - expanded 6th digit"
     Expanded_EOD_7_CP59_1973_1982     = "EOD - expanded 7th digit"
     Expanded_EOD_8_CP60_1973_1982     = "EOD - expanded 8th digit"
     Expanded_EOD_9_CP61_1973_1982     = "EOD - expanded 9th digit"
     Expanded_EOD_10_CP62_1973_1982    = "EOD - expanded 10th digit"
     Expanded_EOD_11_CP63_1973_1982    = "EOD - expanded 11th digit"
     Expanded_EOD_12_CP64_1973_1982    = "EOD - expanded 12th digit"
     Expanded_EOD_13_CP65_1973_1982    = "EOD - expanded 13th digit"
     EOD_4_size_1983_1987              = "EOD 4 - Size (1983-1987)         "
     EOD_4_extent_1983_1987            = "EOD 4 - Extent (1983-1987)       "
     EOD_4_nodes_1983_1987             = "EOD 4 - Nodes (1983-1987)        "
     Coding_system_EOD_1973_2003       = "EOD Coding System (1973-2003)    "
     Tumor_marker_1_1990_2003          = "Tumor marker 1 (1990-2003)       "
     Tumor_marker_2_1990_2003          = "Tumor marker 2 (1990-2003)       "
     Tumor_marker_3_1998_2003          = "Tumor marker 3 (1990-2003        "
     CS_tumor_size_2004_2015           = "CS Tumor size (2004-2015)        "
     CS_extension_2004_2015            = "CS extension (2004-2015)         "
     CS_lymph_nodes_2004_2015          = "CS Lymph nodes (2004-2015)       "
     CS_mets_at_dx_2004_2015           = "CS Mets at dx                    "
     CSsitespecificfactor120042017va   = "CS site-specific factor 1 (2004-2017 varying by schema)"
     CSsitespecificfactor220042017va   = "CS site-specific factor 2 (2004-2017 varying by schema)"
     CSsitespecificfactor320042017va   = "CS site-specific factor 3 (2004-2017 varying by schema)"
     CSsitespecificfactor420042017va   = "CS site-specific factor 4 (2004-2017 varying by schema)"
     CSsitespecificfactor520042017va   = "CS site-specific factor 5 (2004-2017 varying by schema)"
     CSsitespecificfactor620042017va   = "CS site-specific factor 6 (2004-2017 varying by schema)"
     CSsitespecificfactor720042017va   = "CS site-specific factor 7 (2004-2017 varying by schema)"
     CSsitespecificfactor820042017va   = "CS site-specific factor 8 (2004-2017 varying by schema)"
     CSsitespecificfactor920042017va   = "CS site-specific factor 9 (2004-2017 varying by schema)"
     CSsitespecificfactor1020042017v   = "CS site-specific factor 10 (2004-2017 varying by schema)"
     CSsitespecificfactor1120042017v   = "CS site-specific factor 11 (2004-2017 varying by schema)"
     CSsitespecificfactor1220042017v   = "CS site-specific factor 12 (2004-2017 varying by schema)"
     CSsitespecificfactor1320042017v   = "CS site-specific factor 13 (2004-2017 varying by schema)"
     CSsitespecificfactor1520042017v   = "CS site-specific factor 15 (2004-2017 varying by schema)"
     CSsitespecificfactor1620042017v   = "CS site-specific factor 16 (2004-2017 varying by schema)"
     CSsitespecificfactor2520042017v   = "CS site-specific factor 25 (2004-2017 varying by schema)"
     Derived_AJCC_T_6th_ed_2004_2015   = "Derived AJCC T 6th ed (2004-2015)"
     Derived_AJCC_N_6th_ed_2004_2015   = "Derived AJCC N 6th ed (2004-2015)"
     Derived_AJCC_M_6th_ed_2004_2015   = "Derived AJCC M 6th ed (2004-2015)"
     DerivedAJCCStageGroup6thed20042   = "Derived AJCC STAGE Group 6th ed (2004-2015)"
     SEERCombinedSummaryStage2000200   = "SEER Combined Summary Stage 2000 (2004+)"
     Combined_Summary_Stage_2004       = "Combined Summary Stage (2004+)"
     CSversioninputoriginal2004_2015   = "CS version input original (2004-2015)"
     CS_version_derived_2004_2015      = "CS version derived (2004-2015)"
     CSversioninputcurrent_2004_2015   = "CS version input current (2004-2015)"
     RX_Summ_Surg_Prim_Site_1998       = "RX Summ-Surg Prim site 1998+     "
     RX_Summ_Scope_Reg_LN_Sur_2003     = "RX Summ-Scope Reg LN Sur (2003+) "
     RX_Summ_Surg_Oth_Reg_Dis_2003     = "RX Summ-Surg Oth reg/dis (2003+) "
     RXSummReg_LN_Examined_1998_2002   = "RX Summ-Reg LN examined (1998-2002)"
     RX_Summ_Systemic_Surg_Seq         = "RX Summ--Systemic Surg Seq"
     RX_Summ_Surg_Rad_Seq              = "Radiation Sequence with Surgery"
     Reasonnocancer_directed_surgery   = "Reason No Cancer-Directed Surgery"
     Radiation_recode                  = "Radiation Recode (0 and 9 combined) - created"
     Chemotherapy_recode_yes_no_unk    = "CHEMOTHERAPY Recode, yes(1)/no/unknown(0) - created"
     Sitespecificsurgery19731997vary   = "Site Specific Surgery (1973-1997)"
     Scopeofreglymphndsurg_1998_2002   = "Scope of Reg Lymph ND Surg (1998-2002)"
     Surgeryofothregdissites19982002   = "Surgery of Oth Reg/Dis sites (1998-2002)"
     Record_number_recode              = "Record Number Recode             "
     Age_recode_with_1_year_olds       = "Age Recode with <1 Year Olds     "
     Site_recode_ICD_O_3_WHO_2008      = "Site Recode ICD-O-3/WHO 2008)    "
     Site_recode_rare_tumors           = "Site recode - rare tumors"
     Behavior_recode_for_analysis      = "Behavior Recode for Analysis"
     Histologyrecode_broad_groupings   = "Histology Recode - Broad Groupings"
     Histologyrecode_Brain_groupings   = "Histology Recode - Brain Groupings"
     ICCCsiterecodeextended3rdeditio   = "ICCC Site Recode Extended 3rd Edition/IARC 2017"
     TNM_7_CS_v0204_Schema_thru_2017   = "TNM 7/CS v0204+ Schema (thru 2017)"
     TNM_7_CS_v0204_Schema_recode      = "TNM 7/CS v0204+ Schema recode"
     Race_recode_White_Black_Other     = "Race Recode (White, Black, Other)"
     Race_recode_W_B_AI_API            = "Race Recode (W, B, AI, API)"
     OriginrecodeNHIAHispanicNonHisp   = "Origin Recode NHIA (Hispanic, Non-Hispanic)"
     RaceandoriginrecodeNHWNHBNHAIAN   = "Race and origin recode (NHW, NHB, NHAIAN, NHAPI, Hispanic)"
     SEER_historic_stage_A_1973_2015   = "SEER Historic Stage A (1973-2015)"
     AJCCstage_3rd_edition_1988_2003   = "AJCC Stage 3rd Edition (1988-2003)"
     SEERmodifiedAJCCstage3rd1988200   = "SEER Modified AJCC Stage 3rd Edition (1988-2003)"
     Firstmalignantprimary_indicator   = "First Malignant Primary Indicator"
     state                             = "FIPS State"
     county                            = "FIPS County"
     Medianhouseholdincomeinflationa   = "County Attributes - Time Dependent Income"
     Rural_Urban_Continuum_Code        = "County Attributes - Time Dependent Rurality"
     PRCDA_2017	                       = "PRCDA - 2017"
     PRCDA_Region	             = "PRCDA - Region"
     COD_to_site_recode                = "COD to Site Recode"
     COD_to_site_rec_KM                = "COD to Site Recode KM"
     Vitalstatusrecodestudycutoffuse   = "Vital Status Recode (Study Cutoff Used)"
     IHS_Link                          = "IHS LINK"
     Summary_stage_2000_1998_2017      = "Summary stage 2000 (1998-2017)"
     AYA_site_recode_WHO_2008          = "AYA site recode/WHO 2008"
     AYA_site_recode_2020_Revision     = "AYA site recode 2020 Revision"
     Lymphoidneoplasmrecode2021Revis   = "Lymphoid neoplasm recode 2021 Revision"
     LymphomasubtyperecodeWHO2008thr   = "Lymphoma subtype recode/WHO 2008 (thru 2017)"
     SEER_Brain_and_CNS_Recode         = "SEER Brain and CNS Recode"
     ICCCsiterecode3rdeditionIARC201   = "ICCC Site Recode 3rd Edition/IARC 2017"
     SEERcausespecificdeathclassific   = "SEER Cause-Specific Death Classification"
     SEERothercauseofdeathclassifica   = "SEER Other Cause of Death Classification"
     CSTumor_Size_Ext_Eval_2004_2015   = "CS Tumor Size/Ext Eval (2004-2015) "
     CS_Reg_Node_Eval_2004_2015        = "CS Reg Node Eval (2004-2015)"
     CS_Mets_Eval_2004_2015            = "CS Mets Eval (2004-2015)"
     Primary_by_international_rules    = "Primary by International Rules"
     ERStatusRecodeBreastCancer_1990   = "ER Status Recode Breast Cancer (1990+)"
     PRStatusRecodeBreastCancer_1990   = "PR Status Recode Breast Cancer (1990+)"
     CS_Schema_AJCC_6th_Edition        = "CS Schema--AJCC 6th Edition"
     LymphvascularInvasion2004varyin   = "Lymph Vascular Invasion (2004+ Varying by Schema)"
     Survival_months                   = "Survival Months"
     Survival_months_flag              = "Survival Months Flag"
     Derived_AJCC_T_7th_ed_2010_2015   = "Derived AJCC T, 7th Ed 2010-2015)"
     Derived_AJCC_N_7th_ed_2010_2015   = "Derived AJCC N, 7th Ed 2010-2015)"
     Derived_AJCC_M_7th_ed_2010_2015   = "Derived AJCC M, 7th Ed 2010-2015)"
     DerivedAJCCStageGroup7thed20102   = "Derived AJCC Stage Group, 7th Ed 2010-2015)"
     BreastAdjustedAJCC6thT1988_2015   = "Breast--Adjusted AJCC 6th T (1988-2015)"
     BreastAdjustedAJCC6thN1988_2015   = "Breast--Adjusted AJCC 6th N (1988-2015)"
     BreastAdjustedAJCC6thM1988_2015   = "Breast--Adjusted AJCC 6th M (1988-2015)"
     BreastAdjustedAJCC6thStage19882   = "Breast--Adjusted AJCC 6th Stage (1988-2015)"
     Derived_HER2_Recode_2010          = "Derived HER2 Recode (2010+)"
     Breast_Subtype_2010               = "Breast Subtype (2010+)"
     LymphomaAnnArborStage_1983_2015   = "Lymphomas: Ann Arbor Staging (1983-2015)"
     SEERCombinedMetsat_DX_bone_2010   = "SEER Combined Mets at Dx-Bone (2010+)"
     SEERCombinedMetsatDX_brain_2010   = "SEER Combined Mets at Dx-Brain (2010+)"
     SEERCombinedMetsatDX_liver_2010   = "SEER Combined Mets at Dx-Liver (2010+)"
     SEERCombinedMetsat_DX_lung_2010   = "SEER Combined Mets at Dx-Lung (2010+)"
     TvaluebasedonAJCC_3rd_1988_2003   = "T Value - Based on AJCC 3rd (1988-2003)"
     NvaluebasedonAJCC_3rd_1988_2003   = "N Value - Based on AJCC 3rd (1988-2003)"
     MvaluebasedonAJCC_3rd_1988_2003   = "M Value - Based on AJCC 3rd (1988-2003)"
     Totalnumberofinsitumalignanttum   = "Total Number of In Situ/Malignant Tumors for Patient"
     Totalnumberofbenignborderlinetu   = "Total Number of Benign/Borderline Tumors for Patient"
     RadiationtoBrainorCNSRecode1988   = "Radiation to Brain or CNS Recode (1988-1997)"
     Tumor_Size_Summary_2016	       = "Tumor Size Summary (2016+)"
     DerivedSEERCmbStg_Grp_2016_2017   = "Derived SEER Combined STG GRP (2016+)"
     DerivedSEERCombined_T_2016_2017   = "Derived SEER Combined T (2016+)"
     DerivedSEERCombined_N_2016_2017   = "Derived SEER Combined N (2016+)"
     DerivedSEERCombined_M_2016_2017   = "Derived SEER Combined M (2016+)"
     DerivedSEERCombinedTSrc20162017   = "Derived SEER Combined T SRC (2016+)"
     DerivedSEERCombinedNSrc20162017   = "Derived SEER Combined N SRC (2016+)"
     DerivedSEERCombinedMSrc20162017   = "Derived SEER Combined M SRC (2016+)"
     TNM_Edition_Number_2016_2017      = "TNM Edition Number (2016-2017)"
     Mets_at_DX_Distant_LN_2016	       = "Mets at Dx-Distant LN (2016+)"
     Mets_at_DX_Other_2016	       = "Mets at DX--Other (2016+)"
     AJCC_ID_2018                      = "AJCC ID (2018+)"
     EOD_Schema_ID_Recode_2010         = "EOD Schema ID Recode (2010+)"
     Derived_EOD_2018_T_2018           = "Derived EOD 2018 T (2018+)"
     Derived_EOD_2018_N_2018           = "Derived EOD 2018 N (2018+)"
     Derived_EOD_2018_M_2018           = "Derived EOD 2018 M (2018+)"
     DerivedEOD2018_Stage_Group_2018   = "Derived EOD 2018 Stage Group (2018+)"
     EOD_Primary_Tumor_2018            = "EOD Primary Tumor (2018+)"
     EOD_Regional_Nodes_2018           = "EOD Regional Nodes (2018+)"
     EOD_Mets_2018                     = "EOD Mets (2018+)"
     Monthsfromdiagnosisto_treatment   = "Months from diagnosis to treatment"
     Census_Tract_1990                 = "Census Track 1990"
     Census_Tract_2000                 = "Census Track 2000"
     Census_Tract_2010                 = "Census Track 2010"
     Census_Coding_System	       = "Coding System for Census Track 1970/80/90"
     Census_Tract_Certainty_1990       = "Census Tract Certainty 1970/1980/1990"
     Census_Tract_Certainty_2000       = "Census Tract Certainty 2000"
     Census_Tract_Certainty_2010       = "Census Tract Certainty 2010"
     Rural_Urban_Continuum_Code_1993   = "Rural-Urban Continuum Code 1993 - From SEER*Stat"
     Rural_Urban_Continuum_Code_2003   = "Rural-Urban Continuum Code 2003 - From SEER*Stat"
     Rural_Urban_Continuum_Code_2013   = "Rural-Urban Continuum Code 2013 - From SEER*Stat"
     Health_Service_Area               = "Health Service Area - From SEER*Stat"
     HealthService_Area_NCI_Modified   = "Health Service Area NCI Modified - From SEER*Stat"
     County_at_DX_Geocode_1990         = "County at DX Geocode 1990"
     County_at_DX_Geocode_2000	       = "County at DX Geocode 2000"
     County_at_DX_Geocode_2010         = "County at DX Geocode 2010"
     Derived_SS1977_flag               = "Derived SS1977 - Flag (2004+)"
     Derived_SS2000_flag               = "Derived SS2000 - Flag (2004+)"
     Radiation                         = "Radiation"
     RadiationtoBrainorCNS_1988_1997   = "Radiation to Brain or CNS (1988-1997)"
     SEER_DateofDeath_Month            = "Death Month based on Stat_rec"
     SEER_DateofDeath_Year             = "Death Year based on Stat_rec"
     Month_of_last_follow_up_recode    = "Month of Follow-up recode, study cutoff used"
     Year_of_last_follow_up_recode     = "Year of Follow-up recode, study cutoff used"
     Year_of_birth                     = "Year of Birth"
     Date_of_diagnosis_flag            = "Date of Diagnosis Flag"
     Date_therapy_started_flag         = "Date of Therapy Started Flag"
     Date_of_birth_flag                = "Date of Birth flag"
     Date_of_last_follow_up_flag       = "Date of Last Follow-up Flag"
     Month_therapy_started             = "Month Therapy Started"
     Year_therapy_started              = "Year Therapy Started"
     Other_cancer_directed_therapy     = "Other Cancer-Directed Therapy"
     Derived_AJCC_flag                 = "Derived AJCC - Flag (2004+)"
     Derived_SS1977                    = "Derived SS1977 (2004-2015)"
     Derived_SS2000                    = "Derived SS2000 (2004+)"
     SEER_Summary_stage_1977_9500      = "SEER summary stage 1977(1995-2000)"
     SEER_Summary_stage_2000_0103      = "SEER summary stage 2000(2001-2003)"
     Primary_Payer_at_DX               = "Primary Payer at DX"
     Recode_ICD_0_2_to_9               = "Recode ICD-O-2 to 9"
     Recode_ICD_0_2_to_10              = "Recode ICD-O-2 to 10"
     NHIA_Derived_Hisp_Origin          = "NHIA Dervied Hispanic Origin"
     Age_site_edit_override            = "Age-site edit override"
     Sequencenumber_dx_conf_override   = "Sequence number-dx conf override"
     Site_type_lat_seq_override        = "Site-type-lat-seq override"
     Surgerydiagnostic_conf_override   = "Surgery-diagnostic conf override"
     Site_type_edit_override           = "Site-type edit override"
     Histology_edit_override           = "Histology edit override"
     Report_source_sequence_override   = "Report source sequence override"
     Seq_ill_defined_site_override     = "Seq-ill-defined site override"
     LeukLymphdxconfirmationoverride   = "Leuk-Lymph dx confirmation override"
     Site_behavior_override            = "Site-behavior override"
     Site_EOD_dx_date_override         = "Site-EOD-dx date override"
     Site_laterality_EOD_override      = "Site-laterality-EOD override"
     Site_laterality_morph_override    = "Site-laterality-morph override"
     SEER_Summary_Stage_2000newonly    = "Summary Stage 2000 (NAACCR Item-759) (Only to be available for new registries for diagnosis years 2000-2003)"
     Insurance_Recode_2007             = "Insurance Recode (2007+)"
     Yost_ACS_2006_2010                = "Yost Index (ACS 2006-2010)"
     Yost_ACS_2010_2014                = "Yost Index (ACS 2010-2014)"
     Yost_ACS_2013_2017                = "Yost Index (ACS 2013-2017)"
     Yost_ACS_2006_2010_State_based    = "Yost Index (ACS 2006-2010) - State Based"
     Yost_ACS_2010_2014_State_based    = "Yost Index (ACS 2010-2014) - State Based"
     Yost_ACS_2013_2017_State_based    = "Yost Index (ACS 2013-2017) - State Based"
     Yost_ACS_2006_2010_quintile       = "Yost Index Quintile (ACS 2006-2010)"
     Yost_ACS_2010_2014_quintile       = "Yost Index Quintile (ACS 2010-2014)"
     Yost_ACS_2013_2017_quintile       = "Yost Index Quintile (ACS 2013-2017)"
     YostACS20062010quintileStatebas   = "Yost Index Quintile (ACS 2006-2010) - State Based"
     YostACS20102014quintileStatebas   = "Yost Index Quintile (ACS 2010-2014) - State Based"
     YostACS20132017quintileStatebas   = "Yost Index Quintile (ACS 2013-2017) - State Based"
     Brain_Molecular_Markers_2018      = "Brain Molecular Markers (2018+)"
     AFPPostOrchiectomyLabValueRecod   = "AFP Post-Orchiectomy Lab Value Recode (2010+)"
     AFPPretreatmentInterpretationRe   = "AFP Pretreatment Interpretation Recode (2010+)"
     B_Symptoms_Recode_2010            = "B Symptoms Recode (2010+)"
     Breslow_Thickness_Recode_2010     = "Breslow Thickness Recode (2010+)"
     CA125PretreatmentInterpretation   = "CA-125 Pretreatment Interpretation Recode (2010+)"
     CEAPretreatmentInterpretationRe   = "CEA Pretreatment Interpretation Recode (2010+)"
     Chromosome19qLossofHeterozygosi   = "Chromosome 19q: Loss of Heterozygosity (LOH) Recode (2010+)"
     Chromosome1pLossofHeterozygosit   = "Chromosome 1p: Loss of Heterozygosity (LOH) Recode (2010+)"
     Fibrosis_Score_Recode_2010        = "Fibrosis Score Recode (2010+)"
     GestationalTrophoblasticPrognos   = "Gestational Trophoblastic Prognostic Scoring Index Recode (2010+)"
     GleasonPatternsClinicalRecode20   = "Gleason Patterns Clinical Recode (2010+)"
     GleasonPatternsPathologicalReco   = "Gleason Patterns Pathological Recode (2010+)"
     GleasonScoreClinicalRecode_2010   = "Gleason Score Clinical Recode (2010+)"
     GleasonScorePathologicalRecode2   = "Gleason Score Pathological Recode (2010+)"
     hCGPostOrchiectomyRangeRecode20   = "hCG Post-Orchiectomy Range Recode (2010+)"
     InvasionBeyondCapsuleRecode2010   = "Invasion Beyond Capsule Recode (2010+)"
     IpsilateralAdrenalGlandInvolvem   = "Ipsilateral Adrenal Gland Involvement Recode (2010+)"
     LDHPostOrchiectomyRangeRecode20   = "LDH Post-Orchiectomy Range Recode (2010+)"
     LDHPretreatmentLevelRecode_2010   = "LDH Pretreatment Level Recode (2010+)"
     LNHeadandNeckLevelsIIIIRecode20   = "LN Head and Neck Levels I-III Recode (2010+)"
     LNHeadandNeckLevelsIVVRecode201   = "LN Head and Neck Levels IV-V Recode (2010+)"
     LNHeadandNeckLevelsVIVIIRecode2   = "LN Head and Neck Levels VI-VII Recode (2010+)"
     LNHeadandNeck_Other_Recode_2010   = "LN Head and Neck Other Recode (2010+)"
     LNPositiveAxillaryLevelIIIRecod   = "LN Positive Axillary Level I-II Recode (2010+)"
     Lymph_Node_Size_Recode_2010       = "Lymph Node Size Recode (2010+)"
     MajorVeinInvolvementRecode_2010   = "Major Vein Involvement Recode (2010+)"
     MeasuredBasalDiameterRecode2010   = "Measured Basal Diameter Recode (2010+)"
     Measured_Thickness_Recode_2010    = "Measured Thickness Recode (2010+)"
     MitoticRateMelanoma_Recode_2010   = "Mitotic Rate Melanoma Recode (2010+)"
     NumberofCoresPositiveRecode2010   = "Number of Cores Positive Recode (2010+)"
     NumberofCoresExaminedRecode2010   = "Number of Cores Examined Recode (2010+)"
     NumberofExaminedParaAorticNodes   = "Number of Examined Para-Aortic Nodes Recode (2010+)"
     NumberofExaminedPelvicNodesReco   = "Number of Examined Pelvic Nodes Recode (2010+)"
     NumberofPositiveParaAorticNodes   = "Number of Positive Para-Aortic Nodes Recode (2010+)"
     NumberofPositivePelvicNodesReco   = "Number of Positive Pelvic Nodes Recode (2010+)"
     Perineural_Invasion_Recode_2010   = "Perineural Invasion Recode (2010+)"
     PeripheralBloodInvolvementRecod   = "Peripheral Blood Involvement Recode (2010+)"
     Peritoneal_Cytology_Recode_2010   = "Peritoneal Cytology Recode (2010+)"
     Pleural_Effusion_Recode_2010      = "Pleural Effusion Recode (2010+)"
     PSA_Lab_Value_Recode_2010         = "PSA Lab Value Recode (2010+)"
     ResidualTumorVolumePostCytoredu   = "Residual Tumor Volume Post Cytoreduction Recode (2010+)"
     ResponsetoNeoadjuvantTherapyRec   = "Response to Neoadjuvant Therapy Recode (2010+)"
     SarcomatoidFeatures_Recode_2010   = "Sarcomatoid Features Recode (2010+)"
     SeparateTumorNodulesIpsilateral   = "Separate Tumor Nodules Ipsilateral Lung Recode (2010+)"
     Tumor_Deposits_Recode_2010        = "Tumor Deposits Recode (2010+)"
     Ulceration_Recode_2010            = "Ulceration Recode (2010+)"
     VisceralandParietalPleuralInvas   = "Visceral and Parietal Pleural Invasion Recode (2010+)"
     ENHANCED_FIVE_PERCENT_FLAG        = "Five Percent Flag from MBSF"
     Date_of_Death_Flag_created        = "Date of Death Flag (SEER vs Medicare)"
     Date_of_Birth_Flag_created        = "Date of Birth Flag (SEER vs Medicare)"
     OncotypeDXBreastRecurrenceScore   = "Oncotype DX Breast Recurrence Score  -- Needs special permission"
     OncotypeDXRSgroupRS18RS1830RS30   = "Oncotype DX RS group (RS < 18, RS 18-30, RS > 30) -- Needs special permission"
     OncotypeDXreasonno_score_linked   = "Oncotype DX reason no score linked -- Needs special permission"
     Oncotype_DX_year_of_test_report   = "Oncotype DX year of test report -- Needs special permission"
     OncotypeDX_month_of_test_report   = "Oncotype DX month of test report -- Needs special permission"
     OncotypeDXmonthssince_diagnosis   = "Oncotype DX months since diagnosis -- Needs special permission"
      ;

run;

proc contents data=seer.SEER_lung position;
run;


/* esophageal cancer alone */


filename SEER_e 'S:\JamieHeyward\Dissertation Aim 2 SEER Medicare Cohort Study\SEERMed_IRAE\SEER Medicare irAE 2013-2019\SEER.esophagus.cancer.txt';                   /* reading in an un-zipped file */
*filename SEER_in pipe 'gunzip -c /directory/SEER.cancer.txt.gz'; /* reading in a zipped file */

options nocenter validvarname=upcase;

data seer.SEER_esoph;
  infile SEER_e lrecl=771 missover pad;
  input
      @001 patient_id                        $char15. /* Patient ID (for either Cancer or Non-Cancer Patients) */
      @016 SEER_registry                     $char2. /*Registry*/
      @018 SEERregistrywithCAandGAaswholes   $char2. /*Registry with CA and GA as whole states*/
      @020 Louisiana20051stvs2ndhalfofyear   $char1. /*Louisiana 2005 1st vs 2nd half of the year*/
      @021 Marital_status_at_diagnosis       $char1. /*Marital Status               (Not available for NY, MA, ID and TX)*/
      @022 Race_ethnicity                    $char2. /*Race ethnicity*/
      @024 sex                               $char1. /*Sex*/
      @025 Agerecodewithsingleages_and_100   $char3. /*Age recode with single ages and 100+*/
      @028 agerecodewithsingle_ages_and_85   $char3. /*Age recode with single ages and 85+*/
      @031 Sequence_number                   $char2. /*Sequence Number*/
      @033 Month_of_diagnosis                $char2. /*Month of Diagnosis, Not month diagnosis recode*/
      @035 Year_of_diagnosis                 $char4. /*Year of Diagnosis*/
      @039 Coc_Accredited_Flag_2018          $char1. /*Coc Accredited Flag 2018+*/
      @040 Month_of_diagnosis_recode         $char2. /*Month of Diagnosis Recode*/
      @042 Primary_Site                      $char4. /*Primary Site*/
      @046 Laterality                        $char1. /*Laterality*/
      @047 Histology_ICD_O_2                 $char4. /*Histology ICD-0-2  (Not available for NY, MA, ID and TX)*/
      @051 Behavior_code_ICD_O_2             $char1. /*Behavior ICD-0-2   (Not available for NY, MA, ID and TX)*/
      @052 Histologic_Type_ICD_O_3           $char4. /*Histologic type ICD-0-3*/
      @056 Behavior_code_ICD_O_3             $char1. /*Behavior code ICD-0-3*/
      @067 Grade_thru_2017                   $char1. /*Grade thru 2017*/
      @068 Schema_ID_2018                    $char5. /*Schema ID (2018+)*/
      @073 Grade_Clinical_2018               $char1. /*Grade Clinical (2018+)*/
      @074 Grade_Pathological_2018           $char1. /*Grade Pathological (2018+)*/
      @075 Diagnostic_Confirmation           $char1. /*Diagnostic Confirmation*/
      @076 Type_of_Reporting_Source          $char1. /*Type of Reporting Source*/
      @077 EOD_10_size_1988_2003             $char3. /*EOD 10 - SIZE (1998-2003)     (Not available for NY, MA, ID and TX)*/
      @080 EOD_10_extent_1988_2003           $char2. /*EOD 10 - EXTENT (1998-2003)   (Not available for NY, MA, ID and TX)*/
      @082 EOD10Prostatepath_ext_1995_2003   $char2. /*EOD 10 - Prostate path ext (1995-2003)    (Not available for NY, MA, ID and TX)*/
      @084 EOD_10_nodes_1988_2003            $char1. /*EOD 10 - Nodes (1995-2003)                (Not available for NY, MA, ID and TX)*/
      @085 Regional_nodes_positive_1988      $char2. /*EOD 10 - Regional Nodes positive (1988+)  (limited to diagnosis years 2000-2003 for NY, MA, ID and TX)*/
      @087 Regional_nodes_examined_1988      $char2. /*EOD 10 - Regional Nodes examined (1988+)  (Not available for NY, MA, ID and TX)*/
      @089 Expanded_EOD_1_CP53_1973_1982     $char1. /*EOD - expanded 1-13                       (Not available for NY, MA, ID and TX)*/
      @090 Expanded_EOD_2_CP54_1973_1982     $char1.
      @091 Expanded_EOD_3_CP55_1973_1982     $char1.
      @092 Expanded_EOD_4_CP56_1973_1982     $char1.
      @093 Expanded_EOD_5_CP57_1973_1982     $char1.
      @094 Expanded_EOD_6_CP58_1973_1982     $char1.
      @095 Expanded_EOD_7_CP59_1973_1982     $char1.
      @096 Expanded_EOD_8_CP60_1973_1982     $char1.
      @097 Expanded_EOD_9_CP61_1973_1982     $char1.
      @098 Expanded_EOD_10_CP62_1973_1982    $char1.
      @099 Expanded_EOD_11_CP63_1973_1982    $char1.
      @100 Expanded_EOD_12_CP64_1973_1982    $char1.
      @101 Expanded_EOD_13_CP65_1973_1982    $char1.
      @106 EOD_4_size_1983_1987              $char2. /*EOD 4 - Size (1983-1987)       (Not available for NY, MA, ID and TX)  */
      @108 EOD_4_extent_1983_1987            $char1. /*EOD 4 - Extent (1983-1987)     (Not available for NY, MA, ID and TX)  */
      @109 EOD_4_nodes_1983_1987             $char1. /*EOD 4 - Nodes (1983-1987)      (Not available for NY, MA, ID and TX)  */
      @110 Coding_system_EOD_1973_2003       $char1. /*EOD Coding System (1973-2003)  (Not available for NY, MA, ID and TX)  */
      @111 Tumor_marker_1_1990_2003          $char1. /*Tumor marker 1 (1990-2003)     (Not available for NY, MA, ID and TX)  */
      @112 Tumor_marker_2_1990_2003          $char1. /*Tumor marker 2 (1990-2003)     (Not available for NY, MA, ID and TX)  */
      @113 Tumor_marker_3_1998_2003          $char1. /*Tumor marker 3 (1998-2003      (Not available for NY, MA, ID and TX)  */
      @114 CS_tumor_size_2004_2015           $char3. /*CS Tumor size (2004-2015)      (Not available for NY, MA, ID and TX)  */
      @117 CS_extension_2004_2015            $char3. /*CS extension (2004-2015)       (Not available for NY, MA, ID and TX)  */
      @120 CS_lymph_nodes_2004_2015          $char3. /*CS Lymph nodes (2004-2015)     (Not available for NY, MA, ID and TX)  */
      @123 CS_mets_at_dx_2004_2015           $char2. /*CS Mets at dx (2004-2015)      (Not available for NY, MA, ID and TX)  */
      @125 CSsitespecificfactor120042017va   $char3. /*CS Site-specific factor 1(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @128 CSsitespecificfactor220042017va   $char3. /*CS Site-specific factor 2(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @131 CSsitespecificfactor320042017va   $char3. /*CS Site-specific factor 3(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @134 CSsitespecificfactor420042017va   $char3. /*CS Site-specific factor 4(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @137 CSsitespecificfactor520042017va   $char3. /*CS Site-specific factor 5(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @140 CSsitespecificfactor620042017va   $char3. /*CS Site-specific factor 6(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @143 CSsitespecificfactor720042017va   $char3. /*CS Site-specific factor 7(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @146 CSsitespecificfactor820042017va   $char3. /*CS Site-specific factor 8(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @149 CSsitespecificfactor920042017va   $char3. /*CS Site-specific factor 9(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @152 CSsitespecificfactor1020042017v   $char3. /*CS Site-specific factor 10(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @155 CSsitespecificfactor1120042017v   $char3. /*CS Site-specific factor 11(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @158 CSsitespecificfactor1220042017v   $char3. /*CS Site-specific factor 12(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @161 CSsitespecificfactor1320042017v   $char3. /*CS Site-specific factor 13(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @164 CSsitespecificfactor1520042017v   $char3. /*CS Site-specific factor 15(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @167 CSsitespecificfactor1620042017v   $char3. /*CS Site-specific factor 16(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @170 CSsitespecificfactor2520042017v   $char3. /*CS Site-specific factor 25(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @173 Derived_AJCC_T_6th_ed_2004_2015   $char2. /*Derived AJCC T 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @175 Derived_AJCC_N_6th_ed_2004_2015   $char2. /*Derived AJCC N 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @177 Derived_AJCC_M_6th_ed_2004_2015   $char2. /*Derived AJCC M 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @179 DerivedAJCCStageGroup6thed20042   $char2. /*Derived AJCC STAGE Group 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @181 SEERcombinedSummaryStage2000200   $char1. /*SEER Combined Summary Stage 2000 (2004-2017) */
      @182 Combined_Summary_Stage_2004       $char1. /*Combined Summary Stage 2000 (2004+) */
      @183 CSversioninputoriginal2004_2015   $char6. /*CS Version Input (2004-2015)	       (Not available for NY, MA, ID and TX)*/
      @189 CS_version_derived_2004_2015      $char6. /*CS Version Derived (2004-2015)      (Not available for NY, MA, ID and TX)*/
      @195 CSversioninputcurrent_2004_2015   $char6. /*CS Version Current (2004-2015)      (Not available for NY, MA, ID and TX)*/
      @201 RX_Summ_Surg_Prim_Site_1998       $char2. /*RX Summ-Surg Prim site 1998+        (Not available for NY, MA, ID and TX)*/
      @203 RX_Summ_Scope_Reg_LN_Sur_2003     $char1. /*RX Summ-Scope Reg LN Sur (2003+)    (Not available for NY, MA, ID and TX)*/
      @204 RX_Summ_Surg_Oth_Reg_Dis_2003     $char1. /*RX Summ-Surg Oth reg/dis (2003+)    (Not available for NY, MA, ID and TX)*/
      @205 RXSummReg_LN_Examined_1998_2002   $char2. /*RX Summ-Reg LN examined (1998-2002) (Not available for NY, MA, ID and TX)*/
      @207 RX_Summ_Systemic_Surg_Seq         $char1. /*RX Summ--Systemic Surg Seq          (Not available for NY, MA, ID and TX)*/
      @208 RX_Summ_Surg_Rad_Seq              $char1. /*Radiation Sequence with Surgery     (Not available for NY, MA, ID and TX)*/
      @209 Reasonnocancer_directed_surgery   $char1. /*Reason No Cancer-Directed Surgery   (Not available for NY, MA, ID and TX)*/
      @210 Radiation_recode                  $char1. /*Radiation Recode (0 and 9 combined) - created         (Not available for NY, MA, ID and TX)*/
      @211 Chemotherapy_recode_yes_no_unk    $char1. /*CHEMOTHERAPY Recode, yes(1)/no/unknown(0) - created   (Not available for NY, MA, ID and TX)*/
      @212 Sitespecificsurgery19731997vary   $char2. /*Site Specific Surgery (1973-1997)         (Not available for NY, MA, ID and TX)*/
      @214 Scopeofreglymphndsurg_1998_2002   $char1. /*Scope of Reg Lymph ND Surg (1998-2002)    (Not available for NY, MA, ID and TX)*/
      @215 Surgeryofothregdissites19982002   $char1. /*Surgery of Oth Reg/Dis sites (1998-2002)  (Not available for NY, MA, ID and TX)*/
      @216 Record_number_recode              $char2. /*Record Number Recode             */
      @218 Age_recode_with_1_year_olds       $char2. /*Age Recode with <1 Year Olds     */
      @220 Site_recode_ICD_O_3_WHO_2008      $char5. /*Site Recode ICD-O-3/WHO 2008)    */
      @230 Site_recode_rare_tumors           $char5. /*Site Recode - rare tumor*/
      @240 Behavior_recode_for_analysis      $char1. /*Behavior Recode for Analysis*/
      @241 Histologyrecode_broad_groupings   $char2. /*Histology Recode - Broad Groupings*/
      @243 Histologyrecode_Brain_groupings   $char2. /*Histology Recode - Brain Groupings*/
      @245 ICCCsiterecodeextended3rdeditio   $char3. /*ICCC Site Recode Extended 3rd Edition/IARC 2017*/
      @248 TNM_7_CS_v0204_Schema_thru_2017   $char3. /*TNM 7/CS v0204+ Schema (thru 2017)  (Not available for NY, MA, ID and TX)*/
      @251 TNM_7_CS_v0204_Schema_recode      $char3. /*TNM 7/CS v0204+ Schema Recode       (Not available for NY, MA, ID and TX)*/
      @254 Race_recode_White_Black_Other     $char1. /*Race Recode (White, Black, Other)*/
      @255 Race_recode_W_B_AI_API            $char1. /*Race Recode (W, B, AI, API)*/
      @256 OriginrecodeNHIAHispanicNonHisp   $char1. /*Origin Recode NHIA (Hispanic, Non-Hispanic)*/
      @257 RaceandoriginrecodeNHWNHBNHAIAN   $char1. /*Race and origin recode (NHW, NHB, NHAIAN, NHAPI, Hispanic)*/
      @258 SEER_historic_stage_A_1973_2015   $char1. /*SEER Historic Stage A (1973-2015)     (Not available for NY, MA, ID and TX)*/
      @259 AJCCstage_3rd_edition_1988_2003   $char2. /*AJCC Stage 3rd Edition (1988-2003)    (Not available for NY, MA, ID and TX)*/
      @261 SEERmodifiedAJCCstage3rd1988200   $char2. /*SEER Modified AJCC Stage 3rd Edition (1988-2003)   (Not available for NY, MA, ID and TX)*/
      @263 Firstmalignantprimary_indicator   $char1. /*First Malignant Primary Indicator*/
      @264 state                             $char2. /*FIPS State*/
      @266 county                            $char3. /*FIPS County*/
      @274 Medianhouseholdincomeinflationa   $char2. /*Median Household Income Inflation adj to 2019*/
      @276 Rural_Urban_Continuum_Code        $char2. /*Rural-Urban Continuum Code*/
      @278 PRCDA_2017	                     $char1. /*PRCDA - 2017*/
      @279 PRCDA_Region	                     $char1. /*PRCDA - Region*/
      @280 COD_to_site_recode                $char5. /*COD to Site Recode        (Not available for NY, MA, ID and TX)*/
      @285 COD_to_site_rec_KM                $char5. /*COD to Site Recode KM     (Not available for NY, MA, ID and TX)*/
      @290 Vitalstatusrecodestudycutoffuse   $char1. /*Vital Status Recode (Study Cutoff Used) (Not available for NY, MA, ID and TX)*/
      @291 IHS_Link                          $char1. /*IHS LINK*/
      @292 Summary_stage_2000_1998_2017      $char1. /*Summary Stage 2000 (1998-2017) (Not available for NY, MA, ID and TX)*/
      @293 AYA_site_recode_WHO_2008          $char2. /*AYA Site Recode/WHO 2008*/
      @295 AYA_site_recode_2020_Revision     $char3. /*AYA Site Recode 2020 Revision*/
      @298 Lymphoidneoplasmrecode2021Revis   $char2. /*Lymphoid neoplasm recode 2021 Revision*/
      @302 LymphomasubtyperecodeWHO2008thr   $char2. /*Lymphoma Subtype Recode/WHO 2008 (thru 2017)*/
      @304 SEER_Brain_and_CNS_Recode         $char2. /*SEER Brain and CNS Recode*/
      @306 ICCCsiterecode3rdeditionIARC201   $char3. /*ICCC Site Recode 3rd Edition/IARC 2017*/
      @309 SEERcausespecificdeathclassific   $char1. /*SEER Cause-Specific Death Classification (Not available for NY, MA, ID and TX)*/
      @310 SEERothercauseofdeathclassifica   $char1. /*SEER Other Cause of Death Classification (Not available for NY, MA, ID and TX)*/
      @311 CSTumor_Size_Ext_Eval_2004_2015   $char1. /*CS Tumor Size/Ext Eval (2004-2015)  (Not available for NY, MA, ID and TX)*/
      @312 CS_Reg_Node_Eval_2004_2015        $char1. /*CS Reg Node Eval (2004-2015)        (Not available for NY, MA, ID and TX)*/
      @313 CS_Mets_Eval_2004_2015            $char1. /*CS Mets Eval (2004-2015)            (Not available for NY, MA, ID and TX)*/
      @314 Primary_by_international_rules    $char1. /*Primary by International Rules*/
      @315 ERStatusRecodeBreastCancer_1990   $char1. /*ER Status Recode Breast Cancer (1990+) (Not available for NY, MA, ID and TX)*/
      @316 PRStatusRecodeBreastCancer_1990   $char1. /*PR Status Recode Breast Cancer (1990+) (Not available for NY, MA, ID and TX)*/
      @317 CS_Schema_AJCC_6th_Edition        $char2. /*CS Schema--AJCC 6th Edition            (Not available for NY, MA, ID and TX)*/
      @319 LymphvascularInvasion2004varyin   $char1. /*Lymph Vascular Invasion (2004+ Varying by Schema) (Not available for NY, MA, ID and TX)*/
      @320 Survival_months                   $char4. /*Survival Months                    (Not available for NY, MA, ID and TX)*/
      @324 Survival_months_flag              $char1. /*Survival Months Flag               (Not available for NY, MA, ID and TX)*/
      @325 Derived_AJCC_T_7th_ed_2010_2015   $char3. /*Derived AJCC T, 7th Ed 2010-2015)  (Not available for NY, MA, ID and TX)*/
      @328 Derived_AJCC_N_7th_ed_2010_2015   $char3. /*Derived AJCC N, 7th Ed 2010-2015)  (Not available for NY, MA, ID and TX)*/
      @331 Derived_AJCC_M_7th_ed_2010_2015   $char3. /*Derived AJCC M, 7th Ed 2010-2015)  (Not available for NY, MA, ID and TX)*/
      @334 DerivedAJCCStageGroup7thed20102   $char3. /*Derived AJCC Stage Group, 7th Ed 2010-2015) (Not available for NY, MA, ID and TX)*/
      @337 BreastAdjustedAJCC6thT1988_2015   $char2. /*Breast--Adjusted AJCC 6th T (1988-2015)  (Not available for NY, MA, ID and TX)*/
      @339 BreastAdjustedAJCC6thN1988_2015   $char2. /*Breast--Adjusted AJCC 6th N (1988-2015)  (Not available for NY, MA, ID and TX)*/
      @341 BreastAdjustedAJCC6thM1988_2015   $char2. /*Breast--Adjusted AJCC 6th M (1988-2015)  (Not available for NY, MA, ID and TX)*/
      @343 BreastAdjustedAJCC6thStage19882   $char2. /*Breast--Adjusted AJCC 6th Stage (1988-2015) (Not available for NY, MA, ID and TX)*/
      @345 Derived_HER2_Recode_2010          $char1. /*Derived HER2 Recode (2010+)              (Not available for NY, MA, ID and TX)*/
      @346 Breast_Subtype_2010               $char1. /*Breast Subtype (2010+)*/
      @347 LymphomaAnnArborStage_1983_2015   $char1. /*Lymphomas: Ann Arbor Staging (1983-2015) (Not available for NY, MA, ID and TX)*/
      @348 SEERCombinedMetsat_DX_bone_2010   $char1. /*SEER Combined Mets at Dx-Bone (2010+)    (Not available for NY, MA, ID and TX)*/
      @349 SEERCombinedMetsatDX_brain_2010   $char1. /*SEER Combined Mets at Dx-Brain (2010+)   (Not available for NY, MA, ID and TX)*/
      @350 SEERCombinedMetsatDX_liver_2010   $char1. /*SEER Combined Mets at Dx-Liver (2010+)   (Not available for NY, MA, ID and TX)*/
      @351 SEERCombinedMetsat_DX_lung_2010   $char1. /*SEER Combined Mets at Dx-Lung (2010+)    (Not available for NY, MA, ID and TX)*/
      @352 TvaluebasedonAJCC_3rd_1988_2003   $char2. /*T Value - Based on AJCC 3rd (1988-2003)  (Not available for NY, MA, ID and TX)*/
      @354 NvaluebasedonAJCC_3rd_1988_2003   $char2. /*N Value - Based on AJCC 3rd (1988-2003)  (Not available for NY, MA, ID and TX)*/
      @356 MvaluebasedonAJCC_3rd_1988_2003   $char2. /*M Value - Based on AJCC 3rd (1988-2003)  (Not available for NY, MA, ID and TX)*/
      @358 Totalnumberofinsitumalignanttum   $char2. /*Total Number of In Situ/Malignant Tumors for Patient (Not available for NY, MA, ID and TX)*/
      @360 Totalnumberofbenignborderlinetu   $char2. /*Total Number of Benign/Borderline Tumors for Patient (Not available for NY, MA, ID and TX)*/
      @362 RadiationtoBrainorCNSRecode1988   $char1. /*Radiation to Brain or CNS Recode (1988-1997) (Not available for NY, MA, ID and TX)*/
      @363 Tumor_Size_Summary_2016	     $char3. /*Tumor Size Summary (2016+)              (Not available for NY, MA, ID and TX)*/
      @366 DerivedSEERCmbStg_Grp_2016_2017   $char5. /*Derived SEER Combined STG GRP (2016+)   (Not available for NY, MA, ID and TX)*/
      @371 DerivedSEERCombined_T_2016_2017   $char5. /*Derived SEER Combined T (2016+)         (Not available for NY, MA, ID and TX)*/
      @376 DerivedSEERCombined_N_2016_2017   $char5. /*Derived SEER Combined N (2016+)         (Not available for NY, MA, ID and TX)*/
      @381 DerivedSEERCombined_M_2016_2017   $char5. /*Derived SEER Combined M (2016+)         (Not available for NY, MA, ID and TX)*/
      @386 DerivedSEERCombinedTSrc20162017   $char1. /*Derived SEER Combined T SRC (2016+)     (Not available for NY, MA, ID and TX)*/
      @387 DerivedSEERCombinedNSrc20162017   $char1. /*Derived SEER Combined N SRC (2016+)     (Not available for NY, MA, ID and TX)*/
      @388 DerivedSEERCombinedMSrc20162017   $char1. /*Derived SEER Combined M SRC (2016+)     (Not available for NY, MA, ID and TX)*/
      @389 TNM_Edition_Number_2016_2017	     $char2. /*TNM Edition Number (2016-2017)          (Not available for NY, MA, ID and TX)*/
      @391 Mets_at_DX_Distant_LN_2016	     $char1. /*Mets at Dx-Distant LN (2016+)           (Not available for NY, MA, ID and TX)*/
      @392 Mets_at_DX_Other_2016	     $char1. /*Mets at DX--Other (2016+)               (Not available for NY, MA, ID and TX)*/
      @393 AJCC_ID_2018                      $char4. /*AJCC ID (2018+)*/
      @397 EOD_Schema_ID_Recode_2010         $char3. /*EOD Schema ID Recode (2010+)*/
      @400 Derived_EOD_2018_T_2018           $char15. /*Derived EOD 2018 T (2018+)             (Not available for NY, MA, ID and TX)*/
      @415 Derived_EOD_2018_N_2018           $char15. /*Derived EOD 2018 N (2018+)             (Not available for NY, MA, ID and TX)*/
      @430 Derived_EOD_2018_M_2018           $char15. /*Derived EOD 2018 M (2018+)             (Not available for NY, MA, ID and TX)*/
      @445 DerivedEOD2018_Stage_Group_2018   $char15. /*Derived EOD 2018 Stage Group (2018+)   (Not available for NY, MA, ID and TX)*/
      @460 EOD_Primary_Tumor_2018            $char3.  /*EOD Primary Tumor (2018+)              (Not available for NY, MA, ID and TX)*/
      @463 EOD_Regional_Nodes_2018           $char3.  /*EOD Regional Nodes (2018+)             (Not available for NY, MA, ID and TX)*/
      @466 EOD_Mets_2018                     $char2.  /*EOD Mets (2018+)                       (Not available for NY, MA, ID and TX)*/
      @468 Monthsfromdiagnosisto_treatment   $char3.  /*Months from diagnosis to treatment     (Not available for NY, MA, ID and TX)*/

   /*Not Public but released*/
      @471 Census_Tract_1990                 $char6. /*Census Track 1990, encrypted*/
      @477 Census_Tract_2000                 $char6. /*Census Track 2000, encrypted*/
      @483 Census_Tract_2010                 $char6. /*Census Track 2010, encrypted*/
      @489 Census_Coding_System	             $char1. /*Coding System for Census Track 1970/80/90*/
      @490 Census_Tract_Certainty_1990	     $char1. /*Census Tract Certainty 1970/1980/1990*/
      @491 Census_Tract_Certainty_2000	     $char1. /*Census Tract Certainty 2000*/
      @492 Census_Tract_Certainty_2010	     $char1. /*Census Tract Certainty 2010*/
      @493 Rural_Urban_Continuum_Code_1993   $char2. /*Rural-Urban Continuum Code 1993 - From SEER*Stat*/
      @495 Rural_Urban_Continuum_Code_2003   $char2. /*Rural-Urban Continuum Code 2003 - From SEER*Stat*/
      @497 Rural_Urban_Continuum_Code_2013   $char2. /*Rural-Urban Continuum Code 2013 - From SEER*Stat*/
      @499 Health_Service_Area               $char4. /*Health Service Area - From SEER*Stat*/
      @503 HealthService_Area_NCI_Modified   $char4. /*Health Service Area NCI Modified - From SEER*Stat*/
      @507 County_at_DX_Geocode_1990         $char3. /*County at DX Geocode 1990*/
      @510 County_at_DX_Geocode_2000	     $char3. /*County at DX Geocode 2000*/
      @513 County_at_DX_Geocode_2010         $char3. /*County at DX Geocode 2010*/
      @516 Derived_SS1977_flag               $char1. /*Derived SS1977 - Flag (2004+)         (Not available for NY, MA, ID and TX)*/
      @517 Derived_SS2000_flag               $char1. /*Derived SS2000 - Flag (2004+)         (Not available for NY, MA, ID and TX)*/
      @518 Radiation                         $char1. /*Radiation                             (Not available for NY, MA, ID and TX)*/
      @519 RadiationtoBrainorCNS_1988_1997   $char1. /*Radiation to Brain or CNS (1988-1997) (Not available for NY, MA, ID and TX)*/
      @520 SEER_DateofDeath_Month            $char2. /*Death Month based on Stat_rec         (Not available for NY, MA, ID and TX)*/
      @522 SEER_DateofDeath_Year             $char4. /*Death Year based on Stat_rec          (Not available for NY, MA, ID and TX)*/
      @526 Month_of_last_follow_up_recode    $char2. /*Month of Follow-up Recode, study cutoff used (Not available for NY, MA, ID and TX)*/
      @528 Year_of_last_follow_up_recode     $char4. /*Year of Follow-up Recode, study cutoff used  (Not available for NY, MA, ID and TX)*/
      @533 Year_of_birth                     $char4. /*Year of Birth*/
      @537 Date_of_diagnosis_flag            $char2. /*Date of Diagnosis Flag*/
      @539 Date_therapy_started_flag         $char2. /*Date of Therapy Started Flag*/
      @541 Date_of_birth_flag                $char2. /*Date of Birth flag*/
      @543 Date_of_last_follow_up_flag       $char2. /*Date of Last Follow-up Flag*/
      @545 Month_therapy_started             $char2. /*Month Therapy Started*/
      @547 Year_therapy_started              $char4. /*Year Therapy Started*/
      @551 Other_cancer_directed_therapy     $char1. /*Other Cancer-Directed Therapy*/
      @552 Derived_AJCC_flag                 $char1. /*Derived AJCC - Flag (2004+)        (Not available for NY, MA, ID and TX)*/
      @553 Derived_SS1977                    $char1. /*Derived SS1977 (2004-2015)         (Not available for NY, MA, ID and TX)*/
      @554 Derived_SS2000                    $char1. /*Derived SS2000 (2004+)             (Not available for NY, MA, ID and TX)*/
      @555 SEER_Summary_stage_1977_9500	     $char1. /*SEER summary stage 1977(1995-2000) (Not available for NY, MA, ID and TX)*/
      @556 SEER_Summary_stage_2000_0103	     $char1. /*SEER summary stage 2000(2001-2003) (Not available for NY, MA, ID and TX)*/

      @558 Primary_Payer_at_DX               $char2. /*Primary Payer at DX                 (Not available for NY, MA, ID and TX)*/
      @569 Recode_ICD_0_2_to_9               $char4. /*Recode ICD-O-2 to 9                 (Not available for NY, MA, ID and TX)*/
      @573 Recode_ICD_0_2_to_10              $char4. /*Recode ICD-O-2 to 10                (Not available for NY, MA, ID and TX)*/
      @577 NHIA_Derived_Hisp_Origin          $char1. /*NHIA Dervied Hispanic Origin        (Not available for NY, MA, ID and TX)*/
      @578 Age_site_edit_override            $char1. /*Age-site edit override              (Not available for NY, MA, ID and TX)*/
      @579 Sequencenumber_dx_conf_override   $char1. /*Sequence number-dx conf override    (Not available for NY, MA, ID and TX)*/
      @580 Site_type_lat_seq_override        $char1. /*Site-type-lat-seq override          (Not available for NY, MA, ID and TX)*/
      @581 Surgerydiagnostic_conf_override   $char1. /*Surgery-diagnostic conf override    (Not available for NY, MA, ID and TX)*/
      @582 Site_type_edit_override           $char1. /*Site-type edit override             (Not available for NY, MA, ID and TX)*/
      @583 Histology_edit_override           $char1. /*Histology edit override             (Not available for NY, MA, ID and TX)*/
      @584 Report_source_sequence_override   $char1. /*Report source sequence override     (Not available for NY, MA, ID and TX)*/
      @585 Seq_ill_defined_site_override     $char1. /*Seq-ill-defined site override       (Not available for NY, MA, ID and TX)*/
      @586 LeukLymphdxconfirmationoverride   $char1. /*Leuk-Lymph dx confirmation override (Not available for NY, MA, ID and TX)*/
      @587 Site_behavior_override            $char1. /*Site-behavior override              (Not available for NY, MA, ID and TX)*/
      @588 Site_EOD_dx_date_override         $char1. /*Site-EOD-dx date override           (Not available for NY, MA, ID and TX)*/
      @589 Site_laterality_EOD_override      $char1. /*Site-laterality-EOD override        (Not available for NY, MA, ID and TX)*/
      @590 Site_laterality_morph_override    $char1. /*Site-laterality-morph override      (Not available for NY, MA, ID and TX)*/

      @591 SEER_Summary_Stage_2000newonly    $char1. /*Summary Stage 2000 (NAACCR Item-759)   Only available for NY, MA, ID and TX for dx years 2001-2003*/

      @592 Insurance_Recode_2007             1. /*Insurance Recode (2007+)                 (Not available for NY, MA, ID and TX)*/
      @593 Yost_ACS_2006_2010                5. /*Yost Index (ACS 2006-2010)*/
      @598 Yost_ACS_2010_2014                5. /*Yost Index (ACS 2010-2014)*/
      @603 Yost_ACS_2013_2017                5. /*Yost Index (ACS 2013-2017)*/
      @608 Yost_ACS_2006_2010_State_based    5. /*Yost Index (ACS 2006-2010) - State based*/
      @613 Yost_ACS_2010_2014_State_based    5. /*Yost Index (ACS 2010-2014) - State based*/
      @618 Yost_ACS_2013_2017_State_based    5. /*Yost Index (ACS 2013-2017) - State based*/
      @623 Yost_ACS_2006_2010_quintile       $char1. /*Yost Index Quintile (ACS 2006-2010)*/
      @624 Yost_ACS_2010_2014_quintile       $char1. /*Yost Index Quintile (ACS 2010-2014)*/
      @625 Yost_ACS_2013_2017_quintile       $char1. /*Yost Index Quintile (ACS 2013-2017)*/
      @626 YostACS20062010quintileStatebas   $char1. /*Yost Index Quintile (ACS 2006-2010) - State based*/
      @627 YostACS20102014quintileStatebas   $char1. /*Yost Index Quintile (ACS 2010-2014) - State based*/
      @628 YostACS20132017quintileStatebas   $char1. /*Yost Index Quintile (ACS 2013-2017) - State based*/
      @629 Brain_Molecular_Markers_2018	     $char3. /*Brain Molecular Markers (2018+)                    (Not available for NY, MA, ID and TX)*/
      @632 AFPPostOrchiectomyLabValueRecod   $char3. /*AFP Post-Orchiectomy Lab Value Recode (2010+)      (Not available for NY, MA, ID and TX)*/
      @635 AFPPretreatmentInterpretationRe   $char2. /*AFP Pretreatment Interpretation Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @637 B_Symptoms_Recode_2010	     $char2. /*B Symptoms Recode (2010+)                          (Not available for NY, MA, ID and TX)*/
      @639 Breslow_Thickness_Recode_2010     $char5. /*Breslow Thickness Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @644 CA125PretreatmentInterpretation   $char2. /*CA-125 Pretreatment Interpretation Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @646 CEAPretreatmentInterpretationRe   $char2. /*CEA Pretreatment Interpretation Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @648 Chromosome19qLossofHeterozygosi   $char2. /*Chromosome 19q: Loss of Heterozygosity (LOH) Recode (2010+) (Not available for NY, MA, ID and TX)*/
      @650 Chromosome1pLossofHeterozygosit   $char2. /*Chromosome 1p: Loss of Heterozygosity (LOH) Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @652 Fibrosis_Score_Recode_2010	     $char2. /*Fibrosis Score Recode (2010+)                           (Not available for NY, MA, ID and TX)*/
      @654 GestationalTrophoblasticPrognos   $char2. /*Gestational Trophoblastic Prognostic Scoring Index Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @656 GleasonPatternsClinicalRecode20   $char3. /*Gleason Patterns Clinical Recode (2010+)                (Not available for NY, MA, ID and TX)*/
      @659 GleasonPatternsPathologicalReco   $char3. /*Gleason Patterns Pathological Recode (2010+)            (Not available for NY, MA, ID and TX)*/
      @662 GleasonScoreClinicalRecode_2010   $char2. /*Gleason Score Clinical Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @664 GleasonScorePathologicalRecode2   $char2. /*Gleason Score Pathological Recode (2010+)               (Not available for NY, MA, ID and TX)*/
      @666 hCGPostOrchiectomyRangeRecode20   $char2. /*hCG Post-Orchiectomy Range Recode (2010+)               (Not available for NY, MA, ID and TX)*/
      @668 InvasionBeyondCapsuleRecode2010   $char2. /*Invasion Beyond Capsule Recode (2010+)                  (Not available for NY, MA, ID and TX)*/
      @670 IpsilateralAdrenalGlandInvolvem   $char2. /*Ipsilateral Adrenal Gland Involvement Recode (2010+)    (Not available for NY, MA, ID and TX)*/
      @672 LDHPostOrchiectomyRangeRecode20   $char2. /*LDH Post-Orchiectomy Range Recode (2010+)               (Not available for NY, MA, ID and TX)*/
      @674 LDHPretreatmentLevelRecode_2010   $char2. /*LDH Pretreatment Level Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @676 LNHeadandNeckLevelsIIIIRecode20   $char2. /*LN Head and Neck Levels I-III Recode (2010+)            (Not available for NY, MA, ID and TX)*/
      @678 LNHeadandNeckLevelsIVVRecode201   $char2. /*LN Head and Neck Levels IV-V Recode (2010+)             (Not available for NY, MA, ID and TX)*/
      @680 LNHeadandNeckLevelsVIVIIRecode2   $char2. /*LN Head and Neck Levels VI-VII Recode (2010+)           (Not available for NY, MA, ID and TX)*/
      @682 LNHeadandNeck_Other_Recode_2010   $char2. /*LN Head and Neck Other Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @684 LNPositiveAxillaryLevelIIIRecod   $char3. /*LN Positive Axillary Level I-II Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @687 Lymph_Node_Size_Recode_2010	     $char3. /*Lymph Node Size Recode (2010+)                          (Not available for NY, MA, ID and TX)*/
      @690 MajorVeinInvolvementRecode_2010   $char2. /*Major Vein Involvement Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @692 MeasuredBasalDiameterRecode2010   $char5. /*Measured Basal Diameter Recode (2010+)                  (Not available for NY, MA, ID and TX)*/
      @697 Measured_Thickness_Recode_2010    $char5. /*Measured Thickness Recode (2010+)                       (Not available for NY, MA, ID and TX)*/
      @704 MitoticRateMelanoma_Recode_2010   $char3. /*Mitotic Rate Melanoma Recode (2010+)                    (Not available for NY, MA, ID and TX)*/
      @707 NumberofCoresPositiveRecode2010   $char3. /*Number of Cores Positive Recode (2010+)                 (Not available for NY, MA, ID and TX)*/
      @710 NumberofCoresExaminedRecode2010   $char3. /*Number of Cores Examined Recode (2010+)                 (Not available for NY, MA, ID and TX)*/
      @713 NumberofExaminedParaAorticNodes   $char3. /*Number of Examined Para-Aortic Nodes Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @716 NumberofExaminedPelvicNodesReco   $char3. /*Number of Examined Pelvic Nodes Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @719 NumberofPositiveParaAorticNodes   $char3. /*Number of Positive Para-Aortic Nodes Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @722 NumberofPositivePelvicNodesReco   $char3. /*Number of Positive Pelvic Nodes Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @725 Perineural_Invasion_Recode_2010   $char2. /*Perineural Invasion Recode (2010+)                      (Not available for NY, MA, ID and TX)*/
      @727 PeripheralBloodInvolvementRecod   $char2. /*Peripheral Blood Involvement Recode (2010+)             (Not available for NY, MA, ID and TX)*/
      @729 Peritoneal_Cytology_Recode_2010   $char2. /*Peritoneal Cytology Recode (2010+)                      (Not available for NY, MA, ID and TX)*/
      @731 Pleural_Effusion_Recode_2010	     $char2. /*Pleural Effusion Recode (2010+)                         (Not available for NY, MA, ID and TX)*/
      @733 PSA_Lab_Value_Recode_2010	     $char5. /*PSA Lab Value Recode (2010+)                            (Not available for NY, MA, ID and TX)*/
      @738 ResidualTumorVolumePostCytoredu   $char3. /*Residual Tumor Volume Post Cytoreduction Recode (2010+) (Not available for NY, MA, ID and TX)*/
      @741 ResponsetoNeoadjuvantTherapyRec   $char2. /*Response to Neoadjuvant Therapy Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @743 SarcomatoidFeatures_Recode_2010   $char2. /*Sarcomatoid Features Recode (2010+)                     (Not available for NY, MA, ID and TX)*/
      @745 SeparateTumorNodulesIpsilateral   $char2. /*Separate Tumor Nodules Ipsilateral Lung Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @747 Tumor_Deposits_Recode_2010	     $char3. /*Tumor Deposits Recode (2010+)                           (Not available for NY, MA, ID and TX)*/
      @750 Ulceration_Recode_2010	     $char2. /*Ulceration Recode (2010+)                               (Not available for NY, MA, ID and TX)*/
      @752 VisceralandParietalPleuralInvas   $char2. /*Visceral and Parietal Pleural Invasion Recode (2010+)   (Not available for NY, MA, ID and TX)*/
      @754 ENHANCED_FIVE_PERCENT_FLAG        $char1. /*Five Percent Flag from MBSF*/
      @755 Date_of_Death_Flag_created        $char1. /*Date of Death Flag (SEER vs Medicare)                   (Not available for NY, MA, ID and TX)*/
      @756 Date_of_Birth_Flag_created        $char1. /*Date of Birth Flag (SEER vs Medicare)*/

      @757 OncotypeDXBreastRecurrenceScore   3. /*Oncotype DX Breast Recurrence Score  -- Needs special permission  (Not available for MA and TX)*/
      @760 OncotypeDXRSgroupRS18RS1830RS30   1. /*Oncotype DX RS group (RS < 18, RS 18-30, RS > 30) -- Needs special permission  (Not available for MA and TX)*/
      @761 OncotypeDXreasonno_score_linked   1. /*Oncotype DX reason no score linked -- Needs special permission    (Not available for MA and TX)*/
      @762 Oncotype_DX_year_of_test_report   4. /*Oncotype DX year of test report -- Needs special permission       (Not available for MA and TX)*/
      @766 OncotypeDX_month_of_test_report   2. /*Oncotype DX month of test report -- Needs special permission      (Not available for MA and TX)*/
      @768 OncotypeDXmonthssince_diagnosis   3. /*Oncotype DX months since diagnosis -- Needs special permission    (Not available for MA and TX)*/
      ;


  label
     PATIENT_ID                        = "Patient ID"
     SEER_registry                     = "Registry"
     SEERregistrywithCAandGAaswholes   = "Registry with CA and GA as whole states"
     Louisiana20051stvs2ndhalfofyear   = "Louisiana 2005 1st vs 2nd half of the year"
     Marital_status_at_diagnosis       = "Marital Status"
     Race_ethnicity                    = "Race ethnicity"
     sex                               = "Sex"
     Agerecodewithsingleages_and_100   = "Age recode with single ages and 100+"
     agerecodewithsingle_ages_and_85   = "Age recode with single ages and 85+"
     Sequence_number                   = "Sequence Number"
     Month_of_diagnosis                = "Month of Diagnosis, Not month diagnosis recode"
     Year_of_diagnosis                 = "Year of Diagnosis"
     CoC_Accredited_Flag_2018          = "CoC Accredited Flag (2018+)"
     Month_of_diagnosis_recode         = "Month of Diagnosis Recode"
     Primary_Site                      = "Primary Site"
     Laterality                        = "Laterality"
     Histology_ICD_O_2                 = "Histology ICD-0-2"
     Behavior_code_ICD_O_2             = "Behavior ICD-0-2"
     Histologic_Type_ICD_O_3           = "Histologic type ICD-0-3"
     Behavior_code_ICD_O_3             = "Behavior code ICD-0-3"
     Grade_thru_2017                   = "Grade (thru 2017)"
     Schema_ID_2018                    = "Schema ID (2018+)"
     Grade_Clinical_2018               = "Grade Clinical (2018+)"
     Grade_Pathological_2018           = "Grade Pathological (2018+)"
     Diagnostic_Confirmation           = "Diagnostic Confirmation"
     Type_of_Reporting_Source          = "Type of Reporting Source"
     EOD_10_size_1988_2003             = "EOD 10 - SIZE (1998-2003)"
     EOD_10_extent_1988_2003           = "EOD 10 - EXTENT (1998-2003)"
     EOD10Prostatepath_ext_1995_2003   = "EOD 10 - Prostate path ext (1995-2003)"
     EOD_10_nodes_1988_2003            = "EOD 10 - Nodes (1995-2003)"
     Regional_nodes_positive_1988      = "EOD 10 - Regional Nodes positive (1988+)"
     Regional_nodes_examined_1988      = "EOD 10 - Regional Nodes examined (1988+)"
     Expanded_EOD_1_CP53_1973_1982     = "EOD - expanded 1st digit"
     Expanded_EOD_2_CP54_1973_1982     = "EOD - expanded 2nd digit"
     Expanded_EOD_3_CP55_1973_1982     = "EOD - expanded 3rd digit"
     Expanded_EOD_4_CP56_1973_1982     = "EOD - expanded 4th digit"
     Expanded_EOD_5_CP57_1973_1982     = "EOD - expanded 5th digit"
     Expanded_EOD_6_CP58_1973_1982     = "EOD - expanded 6th digit"
     Expanded_EOD_7_CP59_1973_1982     = "EOD - expanded 7th digit"
     Expanded_EOD_8_CP60_1973_1982     = "EOD - expanded 8th digit"
     Expanded_EOD_9_CP61_1973_1982     = "EOD - expanded 9th digit"
     Expanded_EOD_10_CP62_1973_1982    = "EOD - expanded 10th digit"
     Expanded_EOD_11_CP63_1973_1982    = "EOD - expanded 11th digit"
     Expanded_EOD_12_CP64_1973_1982    = "EOD - expanded 12th digit"
     Expanded_EOD_13_CP65_1973_1982    = "EOD - expanded 13th digit"
     EOD_4_size_1983_1987              = "EOD 4 - Size (1983-1987)         "
     EOD_4_extent_1983_1987            = "EOD 4 - Extent (1983-1987)       "
     EOD_4_nodes_1983_1987             = "EOD 4 - Nodes (1983-1987)        "
     Coding_system_EOD_1973_2003       = "EOD Coding System (1973-2003)    "
     Tumor_marker_1_1990_2003          = "Tumor marker 1 (1990-2003)       "
     Tumor_marker_2_1990_2003          = "Tumor marker 2 (1990-2003)       "
     Tumor_marker_3_1998_2003          = "Tumor marker 3 (1990-2003        "
     CS_tumor_size_2004_2015           = "CS Tumor size (2004-2015)        "
     CS_extension_2004_2015            = "CS extension (2004-2015)         "
     CS_lymph_nodes_2004_2015          = "CS Lymph nodes (2004-2015)       "
     CS_mets_at_dx_2004_2015           = "CS Mets at dx                    "
     CSsitespecificfactor120042017va   = "CS site-specific factor 1 (2004-2017 varying by schema)"
     CSsitespecificfactor220042017va   = "CS site-specific factor 2 (2004-2017 varying by schema)"
     CSsitespecificfactor320042017va   = "CS site-specific factor 3 (2004-2017 varying by schema)"
     CSsitespecificfactor420042017va   = "CS site-specific factor 4 (2004-2017 varying by schema)"
     CSsitespecificfactor520042017va   = "CS site-specific factor 5 (2004-2017 varying by schema)"
     CSsitespecificfactor620042017va   = "CS site-specific factor 6 (2004-2017 varying by schema)"
     CSsitespecificfactor720042017va   = "CS site-specific factor 7 (2004-2017 varying by schema)"
     CSsitespecificfactor820042017va   = "CS site-specific factor 8 (2004-2017 varying by schema)"
     CSsitespecificfactor920042017va   = "CS site-specific factor 9 (2004-2017 varying by schema)"
     CSsitespecificfactor1020042017v   = "CS site-specific factor 10 (2004-2017 varying by schema)"
     CSsitespecificfactor1120042017v   = "CS site-specific factor 11 (2004-2017 varying by schema)"
     CSsitespecificfactor1220042017v   = "CS site-specific factor 12 (2004-2017 varying by schema)"
     CSsitespecificfactor1320042017v   = "CS site-specific factor 13 (2004-2017 varying by schema)"
     CSsitespecificfactor1520042017v   = "CS site-specific factor 15 (2004-2017 varying by schema)"
     CSsitespecificfactor1620042017v   = "CS site-specific factor 16 (2004-2017 varying by schema)"
     CSsitespecificfactor2520042017v   = "CS site-specific factor 25 (2004-2017 varying by schema)"
     Derived_AJCC_T_6th_ed_2004_2015   = "Derived AJCC T 6th ed (2004-2015)"
     Derived_AJCC_N_6th_ed_2004_2015   = "Derived AJCC N 6th ed (2004-2015)"
     Derived_AJCC_M_6th_ed_2004_2015   = "Derived AJCC M 6th ed (2004-2015)"
     DerivedAJCCStageGroup6thed20042   = "Derived AJCC STAGE Group 6th ed (2004-2015)"
     SEERCombinedSummaryStage2000200   = "SEER Combined Summary Stage 2000 (2004+)"
     Combined_Summary_Stage_2004       = "Combined Summary Stage (2004+)"
     CSversioninputoriginal2004_2015   = "CS version input original (2004-2015)"
     CS_version_derived_2004_2015      = "CS version derived (2004-2015)"
     CSversioninputcurrent_2004_2015   = "CS version input current (2004-2015)"
     RX_Summ_Surg_Prim_Site_1998       = "RX Summ-Surg Prim site 1998+     "
     RX_Summ_Scope_Reg_LN_Sur_2003     = "RX Summ-Scope Reg LN Sur (2003+) "
     RX_Summ_Surg_Oth_Reg_Dis_2003     = "RX Summ-Surg Oth reg/dis (2003+) "
     RXSummReg_LN_Examined_1998_2002   = "RX Summ-Reg LN examined (1998-2002)"
     RX_Summ_Systemic_Surg_Seq         = "RX Summ--Systemic Surg Seq"
     RX_Summ_Surg_Rad_Seq              = "Radiation Sequence with Surgery"
     Reasonnocancer_directed_surgery   = "Reason No Cancer-Directed Surgery"
     Radiation_recode                  = "Radiation Recode (0 and 9 combined) - created"
     Chemotherapy_recode_yes_no_unk    = "CHEMOTHERAPY Recode, yes(1)/no/unknown(0) - created"
     Sitespecificsurgery19731997vary   = "Site Specific Surgery (1973-1997)"
     Scopeofreglymphndsurg_1998_2002   = "Scope of Reg Lymph ND Surg (1998-2002)"
     Surgeryofothregdissites19982002   = "Surgery of Oth Reg/Dis sites (1998-2002)"
     Record_number_recode              = "Record Number Recode             "
     Age_recode_with_1_year_olds       = "Age Recode with <1 Year Olds     "
     Site_recode_ICD_O_3_WHO_2008      = "Site Recode ICD-O-3/WHO 2008)    "
     Site_recode_rare_tumors           = "Site recode - rare tumors"
     Behavior_recode_for_analysis      = "Behavior Recode for Analysis"
     Histologyrecode_broad_groupings   = "Histology Recode - Broad Groupings"
     Histologyrecode_Brain_groupings   = "Histology Recode - Brain Groupings"
     ICCCsiterecodeextended3rdeditio   = "ICCC Site Recode Extended 3rd Edition/IARC 2017"
     TNM_7_CS_v0204_Schema_thru_2017   = "TNM 7/CS v0204+ Schema (thru 2017)"
     TNM_7_CS_v0204_Schema_recode      = "TNM 7/CS v0204+ Schema recode"
     Race_recode_White_Black_Other     = "Race Recode (White, Black, Other)"
     Race_recode_W_B_AI_API            = "Race Recode (W, B, AI, API)"
     OriginrecodeNHIAHispanicNonHisp   = "Origin Recode NHIA (Hispanic, Non-Hispanic)"
     RaceandoriginrecodeNHWNHBNHAIAN   = "Race and origin recode (NHW, NHB, NHAIAN, NHAPI, Hispanic)"
     SEER_historic_stage_A_1973_2015   = "SEER Historic Stage A (1973-2015)"
     AJCCstage_3rd_edition_1988_2003   = "AJCC Stage 3rd Edition (1988-2003)"
     SEERmodifiedAJCCstage3rd1988200   = "SEER Modified AJCC Stage 3rd Edition (1988-2003)"
     Firstmalignantprimary_indicator   = "First Malignant Primary Indicator"
     state                             = "FIPS State"
     county                            = "FIPS County"
     Medianhouseholdincomeinflationa   = "County Attributes - Time Dependent Income"
     Rural_Urban_Continuum_Code        = "County Attributes - Time Dependent Rurality"
     PRCDA_2017	                       = "PRCDA - 2017"
     PRCDA_Region	             = "PRCDA - Region"
     COD_to_site_recode                = "COD to Site Recode"
     COD_to_site_rec_KM                = "COD to Site Recode KM"
     Vitalstatusrecodestudycutoffuse   = "Vital Status Recode (Study Cutoff Used)"
     IHS_Link                          = "IHS LINK"
     Summary_stage_2000_1998_2017      = "Summary stage 2000 (1998-2017)"
     AYA_site_recode_WHO_2008          = "AYA site recode/WHO 2008"
     AYA_site_recode_2020_Revision     = "AYA site recode 2020 Revision"
     Lymphoidneoplasmrecode2021Revis   = "Lymphoid neoplasm recode 2021 Revision"
     LymphomasubtyperecodeWHO2008thr   = "Lymphoma subtype recode/WHO 2008 (thru 2017)"
     SEER_Brain_and_CNS_Recode         = "SEER Brain and CNS Recode"
     ICCCsiterecode3rdeditionIARC201   = "ICCC Site Recode 3rd Edition/IARC 2017"
     SEERcausespecificdeathclassific   = "SEER Cause-Specific Death Classification"
     SEERothercauseofdeathclassifica   = "SEER Other Cause of Death Classification"
     CSTumor_Size_Ext_Eval_2004_2015   = "CS Tumor Size/Ext Eval (2004-2015) "
     CS_Reg_Node_Eval_2004_2015        = "CS Reg Node Eval (2004-2015)"
     CS_Mets_Eval_2004_2015            = "CS Mets Eval (2004-2015)"
     Primary_by_international_rules    = "Primary by International Rules"
     ERStatusRecodeBreastCancer_1990   = "ER Status Recode Breast Cancer (1990+)"
     PRStatusRecodeBreastCancer_1990   = "PR Status Recode Breast Cancer (1990+)"
     CS_Schema_AJCC_6th_Edition        = "CS Schema--AJCC 6th Edition"
     LymphvascularInvasion2004varyin   = "Lymph Vascular Invasion (2004+ Varying by Schema)"
     Survival_months                   = "Survival Months"
     Survival_months_flag              = "Survival Months Flag"
     Derived_AJCC_T_7th_ed_2010_2015   = "Derived AJCC T, 7th Ed 2010-2015)"
     Derived_AJCC_N_7th_ed_2010_2015   = "Derived AJCC N, 7th Ed 2010-2015)"
     Derived_AJCC_M_7th_ed_2010_2015   = "Derived AJCC M, 7th Ed 2010-2015)"
     DerivedAJCCStageGroup7thed20102   = "Derived AJCC Stage Group, 7th Ed 2010-2015)"
     BreastAdjustedAJCC6thT1988_2015   = "Breast--Adjusted AJCC 6th T (1988-2015)"
     BreastAdjustedAJCC6thN1988_2015   = "Breast--Adjusted AJCC 6th N (1988-2015)"
     BreastAdjustedAJCC6thM1988_2015   = "Breast--Adjusted AJCC 6th M (1988-2015)"
     BreastAdjustedAJCC6thStage19882   = "Breast--Adjusted AJCC 6th Stage (1988-2015)"
     Derived_HER2_Recode_2010          = "Derived HER2 Recode (2010+)"
     Breast_Subtype_2010               = "Breast Subtype (2010+)"
     LymphomaAnnArborStage_1983_2015   = "Lymphomas: Ann Arbor Staging (1983-2015)"
     SEERCombinedMetsat_DX_bone_2010   = "SEER Combined Mets at Dx-Bone (2010+)"
     SEERCombinedMetsatDX_brain_2010   = "SEER Combined Mets at Dx-Brain (2010+)"
     SEERCombinedMetsatDX_liver_2010   = "SEER Combined Mets at Dx-Liver (2010+)"
     SEERCombinedMetsat_DX_lung_2010   = "SEER Combined Mets at Dx-Lung (2010+)"
     TvaluebasedonAJCC_3rd_1988_2003   = "T Value - Based on AJCC 3rd (1988-2003)"
     NvaluebasedonAJCC_3rd_1988_2003   = "N Value - Based on AJCC 3rd (1988-2003)"
     MvaluebasedonAJCC_3rd_1988_2003   = "M Value - Based on AJCC 3rd (1988-2003)"
     Totalnumberofinsitumalignanttum   = "Total Number of In Situ/Malignant Tumors for Patient"
     Totalnumberofbenignborderlinetu   = "Total Number of Benign/Borderline Tumors for Patient"
     RadiationtoBrainorCNSRecode1988   = "Radiation to Brain or CNS Recode (1988-1997)"
     Tumor_Size_Summary_2016	       = "Tumor Size Summary (2016+)"
     DerivedSEERCmbStg_Grp_2016_2017   = "Derived SEER Combined STG GRP (2016+)"
     DerivedSEERCombined_T_2016_2017   = "Derived SEER Combined T (2016+)"
     DerivedSEERCombined_N_2016_2017   = "Derived SEER Combined N (2016+)"
     DerivedSEERCombined_M_2016_2017   = "Derived SEER Combined M (2016+)"
     DerivedSEERCombinedTSrc20162017   = "Derived SEER Combined T SRC (2016+)"
     DerivedSEERCombinedNSrc20162017   = "Derived SEER Combined N SRC (2016+)"
     DerivedSEERCombinedMSrc20162017   = "Derived SEER Combined M SRC (2016+)"
     TNM_Edition_Number_2016_2017      = "TNM Edition Number (2016-2017)"
     Mets_at_DX_Distant_LN_2016	       = "Mets at Dx-Distant LN (2016+)"
     Mets_at_DX_Other_2016	       = "Mets at DX--Other (2016+)"
     AJCC_ID_2018                      = "AJCC ID (2018+)"
     EOD_Schema_ID_Recode_2010         = "EOD Schema ID Recode (2010+)"
     Derived_EOD_2018_T_2018           = "Derived EOD 2018 T (2018+)"
     Derived_EOD_2018_N_2018           = "Derived EOD 2018 N (2018+)"
     Derived_EOD_2018_M_2018           = "Derived EOD 2018 M (2018+)"
     DerivedEOD2018_Stage_Group_2018   = "Derived EOD 2018 Stage Group (2018+)"
     EOD_Primary_Tumor_2018            = "EOD Primary Tumor (2018+)"
     EOD_Regional_Nodes_2018           = "EOD Regional Nodes (2018+)"
     EOD_Mets_2018                     = "EOD Mets (2018+)"
     Monthsfromdiagnosisto_treatment   = "Months from diagnosis to treatment"
     Census_Tract_1990                 = "Census Track 1990"
     Census_Tract_2000                 = "Census Track 2000"
     Census_Tract_2010                 = "Census Track 2010"
     Census_Coding_System	       = "Coding System for Census Track 1970/80/90"
     Census_Tract_Certainty_1990       = "Census Tract Certainty 1970/1980/1990"
     Census_Tract_Certainty_2000       = "Census Tract Certainty 2000"
     Census_Tract_Certainty_2010       = "Census Tract Certainty 2010"
     Rural_Urban_Continuum_Code_1993   = "Rural-Urban Continuum Code 1993 - From SEER*Stat"
     Rural_Urban_Continuum_Code_2003   = "Rural-Urban Continuum Code 2003 - From SEER*Stat"
     Rural_Urban_Continuum_Code_2013   = "Rural-Urban Continuum Code 2013 - From SEER*Stat"
     Health_Service_Area               = "Health Service Area - From SEER*Stat"
     HealthService_Area_NCI_Modified   = "Health Service Area NCI Modified - From SEER*Stat"
     County_at_DX_Geocode_1990         = "County at DX Geocode 1990"
     County_at_DX_Geocode_2000	       = "County at DX Geocode 2000"
     County_at_DX_Geocode_2010         = "County at DX Geocode 2010"
     Derived_SS1977_flag               = "Derived SS1977 - Flag (2004+)"
     Derived_SS2000_flag               = "Derived SS2000 - Flag (2004+)"
     Radiation                         = "Radiation"
     RadiationtoBrainorCNS_1988_1997   = "Radiation to Brain or CNS (1988-1997)"
     SEER_DateofDeath_Month            = "Death Month based on Stat_rec"
     SEER_DateofDeath_Year             = "Death Year based on Stat_rec"
     Month_of_last_follow_up_recode    = "Month of Follow-up recode, study cutoff used"
     Year_of_last_follow_up_recode     = "Year of Follow-up recode, study cutoff used"
     Year_of_birth                     = "Year of Birth"
     Date_of_diagnosis_flag            = "Date of Diagnosis Flag"
     Date_therapy_started_flag         = "Date of Therapy Started Flag"
     Date_of_birth_flag                = "Date of Birth flag"
     Date_of_last_follow_up_flag       = "Date of Last Follow-up Flag"
     Month_therapy_started             = "Month Therapy Started"
     Year_therapy_started              = "Year Therapy Started"
     Other_cancer_directed_therapy     = "Other Cancer-Directed Therapy"
     Derived_AJCC_flag                 = "Derived AJCC - Flag (2004+)"
     Derived_SS1977                    = "Derived SS1977 (2004-2015)"
     Derived_SS2000                    = "Derived SS2000 (2004+)"
     SEER_Summary_stage_1977_9500      = "SEER summary stage 1977(1995-2000)"
     SEER_Summary_stage_2000_0103      = "SEER summary stage 2000(2001-2003)"
     Primary_Payer_at_DX               = "Primary Payer at DX"
     Recode_ICD_0_2_to_9               = "Recode ICD-O-2 to 9"
     Recode_ICD_0_2_to_10              = "Recode ICD-O-2 to 10"
     NHIA_Derived_Hisp_Origin          = "NHIA Dervied Hispanic Origin"
     Age_site_edit_override            = "Age-site edit override"
     Sequencenumber_dx_conf_override   = "Sequence number-dx conf override"
     Site_type_lat_seq_override        = "Site-type-lat-seq override"
     Surgerydiagnostic_conf_override   = "Surgery-diagnostic conf override"
     Site_type_edit_override           = "Site-type edit override"
     Histology_edit_override           = "Histology edit override"
     Report_source_sequence_override   = "Report source sequence override"
     Seq_ill_defined_site_override     = "Seq-ill-defined site override"
     LeukLymphdxconfirmationoverride   = "Leuk-Lymph dx confirmation override"
     Site_behavior_override            = "Site-behavior override"
     Site_EOD_dx_date_override         = "Site-EOD-dx date override"
     Site_laterality_EOD_override      = "Site-laterality-EOD override"
     Site_laterality_morph_override    = "Site-laterality-morph override"
     SEER_Summary_Stage_2000newonly    = "Summary Stage 2000 (NAACCR Item-759) (Only to be available for new registries for diagnosis years 2000-2003)"
     Insurance_Recode_2007             = "Insurance Recode (2007+)"
     Yost_ACS_2006_2010                = "Yost Index (ACS 2006-2010)"
     Yost_ACS_2010_2014                = "Yost Index (ACS 2010-2014)"
     Yost_ACS_2013_2017                = "Yost Index (ACS 2013-2017)"
     Yost_ACS_2006_2010_State_based    = "Yost Index (ACS 2006-2010) - State Based"
     Yost_ACS_2010_2014_State_based    = "Yost Index (ACS 2010-2014) - State Based"
     Yost_ACS_2013_2017_State_based    = "Yost Index (ACS 2013-2017) - State Based"
     Yost_ACS_2006_2010_quintile       = "Yost Index Quintile (ACS 2006-2010)"
     Yost_ACS_2010_2014_quintile       = "Yost Index Quintile (ACS 2010-2014)"
     Yost_ACS_2013_2017_quintile       = "Yost Index Quintile (ACS 2013-2017)"
     YostACS20062010quintileStatebas   = "Yost Index Quintile (ACS 2006-2010) - State Based"
     YostACS20102014quintileStatebas   = "Yost Index Quintile (ACS 2010-2014) - State Based"
     YostACS20132017quintileStatebas   = "Yost Index Quintile (ACS 2013-2017) - State Based"
     Brain_Molecular_Markers_2018      = "Brain Molecular Markers (2018+)"
     AFPPostOrchiectomyLabValueRecod   = "AFP Post-Orchiectomy Lab Value Recode (2010+)"
     AFPPretreatmentInterpretationRe   = "AFP Pretreatment Interpretation Recode (2010+)"
     B_Symptoms_Recode_2010            = "B Symptoms Recode (2010+)"
     Breslow_Thickness_Recode_2010     = "Breslow Thickness Recode (2010+)"
     CA125PretreatmentInterpretation   = "CA-125 Pretreatment Interpretation Recode (2010+)"
     CEAPretreatmentInterpretationRe   = "CEA Pretreatment Interpretation Recode (2010+)"
     Chromosome19qLossofHeterozygosi   = "Chromosome 19q: Loss of Heterozygosity (LOH) Recode (2010+)"
     Chromosome1pLossofHeterozygosit   = "Chromosome 1p: Loss of Heterozygosity (LOH) Recode (2010+)"
     Fibrosis_Score_Recode_2010        = "Fibrosis Score Recode (2010+)"
     GestationalTrophoblasticPrognos   = "Gestational Trophoblastic Prognostic Scoring Index Recode (2010+)"
     GleasonPatternsClinicalRecode20   = "Gleason Patterns Clinical Recode (2010+)"
     GleasonPatternsPathologicalReco   = "Gleason Patterns Pathological Recode (2010+)"
     GleasonScoreClinicalRecode_2010   = "Gleason Score Clinical Recode (2010+)"
     GleasonScorePathologicalRecode2   = "Gleason Score Pathological Recode (2010+)"
     hCGPostOrchiectomyRangeRecode20   = "hCG Post-Orchiectomy Range Recode (2010+)"
     InvasionBeyondCapsuleRecode2010   = "Invasion Beyond Capsule Recode (2010+)"
     IpsilateralAdrenalGlandInvolvem   = "Ipsilateral Adrenal Gland Involvement Recode (2010+)"
     LDHPostOrchiectomyRangeRecode20   = "LDH Post-Orchiectomy Range Recode (2010+)"
     LDHPretreatmentLevelRecode_2010   = "LDH Pretreatment Level Recode (2010+)"
     LNHeadandNeckLevelsIIIIRecode20   = "LN Head and Neck Levels I-III Recode (2010+)"
     LNHeadandNeckLevelsIVVRecode201   = "LN Head and Neck Levels IV-V Recode (2010+)"
     LNHeadandNeckLevelsVIVIIRecode2   = "LN Head and Neck Levels VI-VII Recode (2010+)"
     LNHeadandNeck_Other_Recode_2010   = "LN Head and Neck Other Recode (2010+)"
     LNPositiveAxillaryLevelIIIRecod   = "LN Positive Axillary Level I-II Recode (2010+)"
     Lymph_Node_Size_Recode_2010       = "Lymph Node Size Recode (2010+)"
     MajorVeinInvolvementRecode_2010   = "Major Vein Involvement Recode (2010+)"
     MeasuredBasalDiameterRecode2010   = "Measured Basal Diameter Recode (2010+)"
     Measured_Thickness_Recode_2010    = "Measured Thickness Recode (2010+)"
     MitoticRateMelanoma_Recode_2010   = "Mitotic Rate Melanoma Recode (2010+)"
     NumberofCoresPositiveRecode2010   = "Number of Cores Positive Recode (2010+)"
     NumberofCoresExaminedRecode2010   = "Number of Cores Examined Recode (2010+)"
     NumberofExaminedParaAorticNodes   = "Number of Examined Para-Aortic Nodes Recode (2010+)"
     NumberofExaminedPelvicNodesReco   = "Number of Examined Pelvic Nodes Recode (2010+)"
     NumberofPositiveParaAorticNodes   = "Number of Positive Para-Aortic Nodes Recode (2010+)"
     NumberofPositivePelvicNodesReco   = "Number of Positive Pelvic Nodes Recode (2010+)"
     Perineural_Invasion_Recode_2010   = "Perineural Invasion Recode (2010+)"
     PeripheralBloodInvolvementRecod   = "Peripheral Blood Involvement Recode (2010+)"
     Peritoneal_Cytology_Recode_2010   = "Peritoneal Cytology Recode (2010+)"
     Pleural_Effusion_Recode_2010      = "Pleural Effusion Recode (2010+)"
     PSA_Lab_Value_Recode_2010         = "PSA Lab Value Recode (2010+)"
     ResidualTumorVolumePostCytoredu   = "Residual Tumor Volume Post Cytoreduction Recode (2010+)"
     ResponsetoNeoadjuvantTherapyRec   = "Response to Neoadjuvant Therapy Recode (2010+)"
     SarcomatoidFeatures_Recode_2010   = "Sarcomatoid Features Recode (2010+)"
     SeparateTumorNodulesIpsilateral   = "Separate Tumor Nodules Ipsilateral Lung Recode (2010+)"
     Tumor_Deposits_Recode_2010        = "Tumor Deposits Recode (2010+)"
     Ulceration_Recode_2010            = "Ulceration Recode (2010+)"
     VisceralandParietalPleuralInvas   = "Visceral and Parietal Pleural Invasion Recode (2010+)"
     ENHANCED_FIVE_PERCENT_FLAG        = "Five Percent Flag from MBSF"
     Date_of_Death_Flag_created        = "Date of Death Flag (SEER vs Medicare)"
     Date_of_Birth_Flag_created        = "Date of Birth Flag (SEER vs Medicare)"
     OncotypeDXBreastRecurrenceScore   = "Oncotype DX Breast Recurrence Score  -- Needs special permission"
     OncotypeDXRSgroupRS18RS1830RS30   = "Oncotype DX RS group (RS < 18, RS 18-30, RS > 30) -- Needs special permission"
     OncotypeDXreasonno_score_linked   = "Oncotype DX reason no score linked -- Needs special permission"
     Oncotype_DX_year_of_test_report   = "Oncotype DX year of test report -- Needs special permission"
     OncotypeDX_month_of_test_report   = "Oncotype DX month of test report -- Needs special permission"
     OncotypeDXmonthssince_diagnosis   = "Oncotype DX months since diagnosis -- Needs special permission"
      ;

run;

proc contents data=seer.SEER_esoph position;
run;



/* Skin cancer alone */


filename SEER_s 'S:\JamieHeyward\SEERMed_IRAE\SEER Medicare irAE 2013-2019\SEER.skin.cancer.txt';                   /* reading in an un-zipped file */
*filename SEER_in pipe 'gunzip -c /directory/SEER.cancer.txt.gz'; /* reading in a zipped file */

options nocenter validvarname=upcase;

data seer.SEER_skin;
  infile SEER_s lrecl=771 missover pad;
  input
      @001 patient_id                        $char15. /* Patient ID (for either Cancer or Non-Cancer Patients) */
      @016 SEER_registry                     $char2. /*Registry*/
      @018 SEERregistrywithCAandGAaswholes   $char2. /*Registry with CA and GA as whole states*/
      @020 Louisiana20051stvs2ndhalfofyear   $char1. /*Louisiana 2005 1st vs 2nd half of the year*/
      @021 Marital_status_at_diagnosis       $char1. /*Marital Status               (Not available for NY, MA, ID and TX)*/
      @022 Race_ethnicity                    $char2. /*Race ethnicity*/
      @024 sex                               $char1. /*Sex*/
      @025 Agerecodewithsingleages_and_100   $char3. /*Age recode with single ages and 100+*/
      @028 agerecodewithsingle_ages_and_85   $char3. /*Age recode with single ages and 85+*/
      @031 Sequence_number                   $char2. /*Sequence Number*/
      @033 Month_of_diagnosis                $char2. /*Month of Diagnosis, Not month diagnosis recode*/
      @035 Year_of_diagnosis                 $char4. /*Year of Diagnosis*/
      @039 Coc_Accredited_Flag_2018          $char1. /*Coc Accredited Flag 2018+*/
      @040 Month_of_diagnosis_recode         $char2. /*Month of Diagnosis Recode*/
      @042 Primary_Site                      $char4. /*Primary Site*/
      @046 Laterality                        $char1. /*Laterality*/
      @047 Histology_ICD_O_2                 $char4. /*Histology ICD-0-2  (Not available for NY, MA, ID and TX)*/
      @051 Behavior_code_ICD_O_2             $char1. /*Behavior ICD-0-2   (Not available for NY, MA, ID and TX)*/
      @052 Histologic_Type_ICD_O_3           $char4. /*Histologic type ICD-0-3*/
      @056 Behavior_code_ICD_O_3             $char1. /*Behavior code ICD-0-3*/
      @067 Grade_thru_2017                   $char1. /*Grade thru 2017*/
      @068 Schema_ID_2018                    $char5. /*Schema ID (2018+)*/
      @073 Grade_Clinical_2018               $char1. /*Grade Clinical (2018+)*/
      @074 Grade_Pathological_2018           $char1. /*Grade Pathological (2018+)*/
      @075 Diagnostic_Confirmation           $char1. /*Diagnostic Confirmation*/
      @076 Type_of_Reporting_Source          $char1. /*Type of Reporting Source*/
      @077 EOD_10_size_1988_2003             $char3. /*EOD 10 - SIZE (1998-2003)     (Not available for NY, MA, ID and TX)*/
      @080 EOD_10_extent_1988_2003           $char2. /*EOD 10 - EXTENT (1998-2003)   (Not available for NY, MA, ID and TX)*/
      @082 EOD10Prostatepath_ext_1995_2003   $char2. /*EOD 10 - Prostate path ext (1995-2003)    (Not available for NY, MA, ID and TX)*/
      @084 EOD_10_nodes_1988_2003            $char1. /*EOD 10 - Nodes (1995-2003)                (Not available for NY, MA, ID and TX)*/
      @085 Regional_nodes_positive_1988      $char2. /*EOD 10 - Regional Nodes positive (1988+)  (limited to diagnosis years 2000-2003 for NY, MA, ID and TX)*/
      @087 Regional_nodes_examined_1988      $char2. /*EOD 10 - Regional Nodes examined (1988+)  (Not available for NY, MA, ID and TX)*/
      @089 Expanded_EOD_1_CP53_1973_1982     $char1. /*EOD - expanded 1-13                       (Not available for NY, MA, ID and TX)*/
      @090 Expanded_EOD_2_CP54_1973_1982     $char1.
      @091 Expanded_EOD_3_CP55_1973_1982     $char1.
      @092 Expanded_EOD_4_CP56_1973_1982     $char1.
      @093 Expanded_EOD_5_CP57_1973_1982     $char1.
      @094 Expanded_EOD_6_CP58_1973_1982     $char1.
      @095 Expanded_EOD_7_CP59_1973_1982     $char1.
      @096 Expanded_EOD_8_CP60_1973_1982     $char1.
      @097 Expanded_EOD_9_CP61_1973_1982     $char1.
      @098 Expanded_EOD_10_CP62_1973_1982    $char1.
      @099 Expanded_EOD_11_CP63_1973_1982    $char1.
      @100 Expanded_EOD_12_CP64_1973_1982    $char1.
      @101 Expanded_EOD_13_CP65_1973_1982    $char1.
      @106 EOD_4_size_1983_1987              $char2. /*EOD 4 - Size (1983-1987)       (Not available for NY, MA, ID and TX)  */
      @108 EOD_4_extent_1983_1987            $char1. /*EOD 4 - Extent (1983-1987)     (Not available for NY, MA, ID and TX)  */
      @109 EOD_4_nodes_1983_1987             $char1. /*EOD 4 - Nodes (1983-1987)      (Not available for NY, MA, ID and TX)  */
      @110 Coding_system_EOD_1973_2003       $char1. /*EOD Coding System (1973-2003)  (Not available for NY, MA, ID and TX)  */
      @111 Tumor_marker_1_1990_2003          $char1. /*Tumor marker 1 (1990-2003)     (Not available for NY, MA, ID and TX)  */
      @112 Tumor_marker_2_1990_2003          $char1. /*Tumor marker 2 (1990-2003)     (Not available for NY, MA, ID and TX)  */
      @113 Tumor_marker_3_1998_2003          $char1. /*Tumor marker 3 (1998-2003      (Not available for NY, MA, ID and TX)  */
      @114 CS_tumor_size_2004_2015           $char3. /*CS Tumor size (2004-2015)      (Not available for NY, MA, ID and TX)  */
      @117 CS_extension_2004_2015            $char3. /*CS extension (2004-2015)       (Not available for NY, MA, ID and TX)  */
      @120 CS_lymph_nodes_2004_2015          $char3. /*CS Lymph nodes (2004-2015)     (Not available for NY, MA, ID and TX)  */
      @123 CS_mets_at_dx_2004_2015           $char2. /*CS Mets at dx (2004-2015)      (Not available for NY, MA, ID and TX)  */
      @125 CSsitespecificfactor120042017va   $char3. /*CS Site-specific factor 1(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @128 CSsitespecificfactor220042017va   $char3. /*CS Site-specific factor 2(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @131 CSsitespecificfactor320042017va   $char3. /*CS Site-specific factor 3(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @134 CSsitespecificfactor420042017va   $char3. /*CS Site-specific factor 4(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @137 CSsitespecificfactor520042017va   $char3. /*CS Site-specific factor 5(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @140 CSsitespecificfactor620042017va   $char3. /*CS Site-specific factor 6(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @143 CSsitespecificfactor720042017va   $char3. /*CS Site-specific factor 7(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @146 CSsitespecificfactor820042017va   $char3. /*CS Site-specific factor 8(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @149 CSsitespecificfactor920042017va   $char3. /*CS Site-specific factor 9(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @152 CSsitespecificfactor1020042017v   $char3. /*CS Site-specific factor 10(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @155 CSsitespecificfactor1120042017v   $char3. /*CS Site-specific factor 11(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @158 CSsitespecificfactor1220042017v   $char3. /*CS Site-specific factor 12(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @161 CSsitespecificfactor1320042017v   $char3. /*CS Site-specific factor 13(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @164 CSsitespecificfactor1520042017v   $char3. /*CS Site-specific factor 15(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @167 CSsitespecificfactor1620042017v   $char3. /*CS Site-specific factor 16(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @170 CSsitespecificfactor2520042017v   $char3. /*CS Site-specific factor 25(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @173 Derived_AJCC_T_6th_ed_2004_2015   $char2. /*Derived AJCC T 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @175 Derived_AJCC_N_6th_ed_2004_2015   $char2. /*Derived AJCC N 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @177 Derived_AJCC_M_6th_ed_2004_2015   $char2. /*Derived AJCC M 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @179 DerivedAJCCStageGroup6thed20042   $char2. /*Derived AJCC STAGE Group 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @181 SEERcombinedSummaryStage2000200   $char1. /*SEER Combined Summary Stage 2000 (2004-2017) */
      @182 Combined_Summary_Stage_2004       $char1. /*Combined Summary Stage 2000 (2004+) */
      @183 CSversioninputoriginal2004_2015   $char6. /*CS Version Input (2004-2015)	       (Not available for NY, MA, ID and TX)*/
      @189 CS_version_derived_2004_2015      $char6. /*CS Version Derived (2004-2015)      (Not available for NY, MA, ID and TX)*/
      @195 CSversioninputcurrent_2004_2015   $char6. /*CS Version Current (2004-2015)      (Not available for NY, MA, ID and TX)*/
      @201 RX_Summ_Surg_Prim_Site_1998       $char2. /*RX Summ-Surg Prim site 1998+        (Not available for NY, MA, ID and TX)*/
      @203 RX_Summ_Scope_Reg_LN_Sur_2003     $char1. /*RX Summ-Scope Reg LN Sur (2003+)    (Not available for NY, MA, ID and TX)*/
      @204 RX_Summ_Surg_Oth_Reg_Dis_2003     $char1. /*RX Summ-Surg Oth reg/dis (2003+)    (Not available for NY, MA, ID and TX)*/
      @205 RXSummReg_LN_Examined_1998_2002   $char2. /*RX Summ-Reg LN examined (1998-2002) (Not available for NY, MA, ID and TX)*/
      @207 RX_Summ_Systemic_Surg_Seq         $char1. /*RX Summ--Systemic Surg Seq          (Not available for NY, MA, ID and TX)*/
      @208 RX_Summ_Surg_Rad_Seq              $char1. /*Radiation Sequence with Surgery     (Not available for NY, MA, ID and TX)*/
      @209 Reasonnocancer_directed_surgery   $char1. /*Reason No Cancer-Directed Surgery   (Not available for NY, MA, ID and TX)*/
      @210 Radiation_recode                  $char1. /*Radiation Recode (0 and 9 combined) - created         (Not available for NY, MA, ID and TX)*/
      @211 Chemotherapy_recode_yes_no_unk    $char1. /*CHEMOTHERAPY Recode, yes(1)/no/unknown(0) - created   (Not available for NY, MA, ID and TX)*/
      @212 Sitespecificsurgery19731997vary   $char2. /*Site Specific Surgery (1973-1997)         (Not available for NY, MA, ID and TX)*/
      @214 Scopeofreglymphndsurg_1998_2002   $char1. /*Scope of Reg Lymph ND Surg (1998-2002)    (Not available for NY, MA, ID and TX)*/
      @215 Surgeryofothregdissites19982002   $char1. /*Surgery of Oth Reg/Dis sites (1998-2002)  (Not available for NY, MA, ID and TX)*/
      @216 Record_number_recode              $char2. /*Record Number Recode             */
      @218 Age_recode_with_1_year_olds       $char2. /*Age Recode with <1 Year Olds     */
      @220 Site_recode_ICD_O_3_WHO_2008      $char5. /*Site Recode ICD-O-3/WHO 2008)    */
      @230 Site_recode_rare_tumors           $char5. /*Site Recode - rare tumor*/
      @240 Behavior_recode_for_analysis      $char1. /*Behavior Recode for Analysis*/
      @241 Histologyrecode_broad_groupings   $char2. /*Histology Recode - Broad Groupings*/
      @243 Histologyrecode_Brain_groupings   $char2. /*Histology Recode - Brain Groupings*/
      @245 ICCCsiterecodeextended3rdeditio   $char3. /*ICCC Site Recode Extended 3rd Edition/IARC 2017*/
      @248 TNM_7_CS_v0204_Schema_thru_2017   $char3. /*TNM 7/CS v0204+ Schema (thru 2017)  (Not available for NY, MA, ID and TX)*/
      @251 TNM_7_CS_v0204_Schema_recode      $char3. /*TNM 7/CS v0204+ Schema Recode       (Not available for NY, MA, ID and TX)*/
      @254 Race_recode_White_Black_Other     $char1. /*Race Recode (White, Black, Other)*/
      @255 Race_recode_W_B_AI_API            $char1. /*Race Recode (W, B, AI, API)*/
      @256 OriginrecodeNHIAHispanicNonHisp   $char1. /*Origin Recode NHIA (Hispanic, Non-Hispanic)*/
      @257 RaceandoriginrecodeNHWNHBNHAIAN   $char1. /*Race and origin recode (NHW, NHB, NHAIAN, NHAPI, Hispanic)*/
      @258 SEER_historic_stage_A_1973_2015   $char1. /*SEER Historic Stage A (1973-2015)     (Not available for NY, MA, ID and TX)*/
      @259 AJCCstage_3rd_edition_1988_2003   $char2. /*AJCC Stage 3rd Edition (1988-2003)    (Not available for NY, MA, ID and TX)*/
      @261 SEERmodifiedAJCCstage3rd1988200   $char2. /*SEER Modified AJCC Stage 3rd Edition (1988-2003)   (Not available for NY, MA, ID and TX)*/
      @263 Firstmalignantprimary_indicator   $char1. /*First Malignant Primary Indicator*/
      @264 state                             $char2. /*FIPS State*/
      @266 county                            $char3. /*FIPS County*/
      @274 Medianhouseholdincomeinflationa   $char2. /*Median Household Income Inflation adj to 2019*/
      @276 Rural_Urban_Continuum_Code        $char2. /*Rural-Urban Continuum Code*/
      @278 PRCDA_2017	                     $char1. /*PRCDA - 2017*/
      @279 PRCDA_Region	                     $char1. /*PRCDA - Region*/
      @280 COD_to_site_recode                $char5. /*COD to Site Recode        (Not available for NY, MA, ID and TX)*/
      @285 COD_to_site_rec_KM                $char5. /*COD to Site Recode KM     (Not available for NY, MA, ID and TX)*/
      @290 Vitalstatusrecodestudycutoffuse   $char1. /*Vital Status Recode (Study Cutoff Used) (Not available for NY, MA, ID and TX)*/
      @291 IHS_Link                          $char1. /*IHS LINK*/
      @292 Summary_stage_2000_1998_2017      $char1. /*Summary Stage 2000 (1998-2017) (Not available for NY, MA, ID and TX)*/
      @293 AYA_site_recode_WHO_2008          $char2. /*AYA Site Recode/WHO 2008*/
      @295 AYA_site_recode_2020_Revision     $char3. /*AYA Site Recode 2020 Revision*/
      @298 Lymphoidneoplasmrecode2021Revis   $char2. /*Lymphoid neoplasm recode 2021 Revision*/
      @302 LymphomasubtyperecodeWHO2008thr   $char2. /*Lymphoma Subtype Recode/WHO 2008 (thru 2017)*/
      @304 SEER_Brain_and_CNS_Recode         $char2. /*SEER Brain and CNS Recode*/
      @306 ICCCsiterecode3rdeditionIARC201   $char3. /*ICCC Site Recode 3rd Edition/IARC 2017*/
      @309 SEERcausespecificdeathclassific   $char1. /*SEER Cause-Specific Death Classification (Not available for NY, MA, ID and TX)*/
      @310 SEERothercauseofdeathclassifica   $char1. /*SEER Other Cause of Death Classification (Not available for NY, MA, ID and TX)*/
      @311 CSTumor_Size_Ext_Eval_2004_2015   $char1. /*CS Tumor Size/Ext Eval (2004-2015)  (Not available for NY, MA, ID and TX)*/
      @312 CS_Reg_Node_Eval_2004_2015        $char1. /*CS Reg Node Eval (2004-2015)        (Not available for NY, MA, ID and TX)*/
      @313 CS_Mets_Eval_2004_2015            $char1. /*CS Mets Eval (2004-2015)            (Not available for NY, MA, ID and TX)*/
      @314 Primary_by_international_rules    $char1. /*Primary by International Rules*/
      @315 ERStatusRecodeBreastCancer_1990   $char1. /*ER Status Recode Breast Cancer (1990+) (Not available for NY, MA, ID and TX)*/
      @316 PRStatusRecodeBreastCancer_1990   $char1. /*PR Status Recode Breast Cancer (1990+) (Not available for NY, MA, ID and TX)*/
      @317 CS_Schema_AJCC_6th_Edition        $char2. /*CS Schema--AJCC 6th Edition            (Not available for NY, MA, ID and TX)*/
      @319 LymphvascularInvasion2004varyin   $char1. /*Lymph Vascular Invasion (2004+ Varying by Schema) (Not available for NY, MA, ID and TX)*/
      @320 Survival_months                   $char4. /*Survival Months                    (Not available for NY, MA, ID and TX)*/
      @324 Survival_months_flag              $char1. /*Survival Months Flag               (Not available for NY, MA, ID and TX)*/
      @325 Derived_AJCC_T_7th_ed_2010_2015   $char3. /*Derived AJCC T, 7th Ed 2010-2015)  (Not available for NY, MA, ID and TX)*/
      @328 Derived_AJCC_N_7th_ed_2010_2015   $char3. /*Derived AJCC N, 7th Ed 2010-2015)  (Not available for NY, MA, ID and TX)*/
      @331 Derived_AJCC_M_7th_ed_2010_2015   $char3. /*Derived AJCC M, 7th Ed 2010-2015)  (Not available for NY, MA, ID and TX)*/
      @334 DerivedAJCCStageGroup7thed20102   $char3. /*Derived AJCC Stage Group, 7th Ed 2010-2015) (Not available for NY, MA, ID and TX)*/
      @337 BreastAdjustedAJCC6thT1988_2015   $char2. /*Breast--Adjusted AJCC 6th T (1988-2015)  (Not available for NY, MA, ID and TX)*/
      @339 BreastAdjustedAJCC6thN1988_2015   $char2. /*Breast--Adjusted AJCC 6th N (1988-2015)  (Not available for NY, MA, ID and TX)*/
      @341 BreastAdjustedAJCC6thM1988_2015   $char2. /*Breast--Adjusted AJCC 6th M (1988-2015)  (Not available for NY, MA, ID and TX)*/
      @343 BreastAdjustedAJCC6thStage19882   $char2. /*Breast--Adjusted AJCC 6th Stage (1988-2015) (Not available for NY, MA, ID and TX)*/
      @345 Derived_HER2_Recode_2010          $char1. /*Derived HER2 Recode (2010+)              (Not available for NY, MA, ID and TX)*/
      @346 Breast_Subtype_2010               $char1. /*Breast Subtype (2010+)*/
      @347 LymphomaAnnArborStage_1983_2015   $char1. /*Lymphomas: Ann Arbor Staging (1983-2015) (Not available for NY, MA, ID and TX)*/
      @348 SEERCombinedMetsat_DX_bone_2010   $char1. /*SEER Combined Mets at Dx-Bone (2010+)    (Not available for NY, MA, ID and TX)*/
      @349 SEERCombinedMetsatDX_brain_2010   $char1. /*SEER Combined Mets at Dx-Brain (2010+)   (Not available for NY, MA, ID and TX)*/
      @350 SEERCombinedMetsatDX_liver_2010   $char1. /*SEER Combined Mets at Dx-Liver (2010+)   (Not available for NY, MA, ID and TX)*/
      @351 SEERCombinedMetsat_DX_lung_2010   $char1. /*SEER Combined Mets at Dx-Lung (2010+)    (Not available for NY, MA, ID and TX)*/
      @352 TvaluebasedonAJCC_3rd_1988_2003   $char2. /*T Value - Based on AJCC 3rd (1988-2003)  (Not available for NY, MA, ID and TX)*/
      @354 NvaluebasedonAJCC_3rd_1988_2003   $char2. /*N Value - Based on AJCC 3rd (1988-2003)  (Not available for NY, MA, ID and TX)*/
      @356 MvaluebasedonAJCC_3rd_1988_2003   $char2. /*M Value - Based on AJCC 3rd (1988-2003)  (Not available for NY, MA, ID and TX)*/
      @358 Totalnumberofinsitumalignanttum   $char2. /*Total Number of In Situ/Malignant Tumors for Patient (Not available for NY, MA, ID and TX)*/
      @360 Totalnumberofbenignborderlinetu   $char2. /*Total Number of Benign/Borderline Tumors for Patient (Not available for NY, MA, ID and TX)*/
      @362 RadiationtoBrainorCNSRecode1988   $char1. /*Radiation to Brain or CNS Recode (1988-1997) (Not available for NY, MA, ID and TX)*/
      @363 Tumor_Size_Summary_2016	     $char3. /*Tumor Size Summary (2016+)              (Not available for NY, MA, ID and TX)*/
      @366 DerivedSEERCmbStg_Grp_2016_2017   $char5. /*Derived SEER Combined STG GRP (2016+)   (Not available for NY, MA, ID and TX)*/
      @371 DerivedSEERCombined_T_2016_2017   $char5. /*Derived SEER Combined T (2016+)         (Not available for NY, MA, ID and TX)*/
      @376 DerivedSEERCombined_N_2016_2017   $char5. /*Derived SEER Combined N (2016+)         (Not available for NY, MA, ID and TX)*/
      @381 DerivedSEERCombined_M_2016_2017   $char5. /*Derived SEER Combined M (2016+)         (Not available for NY, MA, ID and TX)*/
      @386 DerivedSEERCombinedTSrc20162017   $char1. /*Derived SEER Combined T SRC (2016+)     (Not available for NY, MA, ID and TX)*/
      @387 DerivedSEERCombinedNSrc20162017   $char1. /*Derived SEER Combined N SRC (2016+)     (Not available for NY, MA, ID and TX)*/
      @388 DerivedSEERCombinedMSrc20162017   $char1. /*Derived SEER Combined M SRC (2016+)     (Not available for NY, MA, ID and TX)*/
      @389 TNM_Edition_Number_2016_2017	     $char2. /*TNM Edition Number (2016-2017)          (Not available for NY, MA, ID and TX)*/
      @391 Mets_at_DX_Distant_LN_2016	     $char1. /*Mets at Dx-Distant LN (2016+)           (Not available for NY, MA, ID and TX)*/
      @392 Mets_at_DX_Other_2016	     $char1. /*Mets at DX--Other (2016+)               (Not available for NY, MA, ID and TX)*/
      @393 AJCC_ID_2018                      $char4. /*AJCC ID (2018+)*/
      @397 EOD_Schema_ID_Recode_2010         $char3. /*EOD Schema ID Recode (2010+)*/
      @400 Derived_EOD_2018_T_2018           $char15. /*Derived EOD 2018 T (2018+)             (Not available for NY, MA, ID and TX)*/
      @415 Derived_EOD_2018_N_2018           $char15. /*Derived EOD 2018 N (2018+)             (Not available for NY, MA, ID and TX)*/
      @430 Derived_EOD_2018_M_2018           $char15. /*Derived EOD 2018 M (2018+)             (Not available for NY, MA, ID and TX)*/
      @445 DerivedEOD2018_Stage_Group_2018   $char15. /*Derived EOD 2018 Stage Group (2018+)   (Not available for NY, MA, ID and TX)*/
      @460 EOD_Primary_Tumor_2018            $char3.  /*EOD Primary Tumor (2018+)              (Not available for NY, MA, ID and TX)*/
      @463 EOD_Regional_Nodes_2018           $char3.  /*EOD Regional Nodes (2018+)             (Not available for NY, MA, ID and TX)*/
      @466 EOD_Mets_2018                     $char2.  /*EOD Mets (2018+)                       (Not available for NY, MA, ID and TX)*/
      @468 Monthsfromdiagnosisto_treatment   $char3.  /*Months from diagnosis to treatment     (Not available for NY, MA, ID and TX)*/

   /*Not Public but released*/
      @471 Census_Tract_1990                 $char6. /*Census Track 1990, encrypted*/
      @477 Census_Tract_2000                 $char6. /*Census Track 2000, encrypted*/
      @483 Census_Tract_2010                 $char6. /*Census Track 2010, encrypted*/
      @489 Census_Coding_System	             $char1. /*Coding System for Census Track 1970/80/90*/
      @490 Census_Tract_Certainty_1990	     $char1. /*Census Tract Certainty 1970/1980/1990*/
      @491 Census_Tract_Certainty_2000	     $char1. /*Census Tract Certainty 2000*/
      @492 Census_Tract_Certainty_2010	     $char1. /*Census Tract Certainty 2010*/
      @493 Rural_Urban_Continuum_Code_1993   $char2. /*Rural-Urban Continuum Code 1993 - From SEER*Stat*/
      @495 Rural_Urban_Continuum_Code_2003   $char2. /*Rural-Urban Continuum Code 2003 - From SEER*Stat*/
      @497 Rural_Urban_Continuum_Code_2013   $char2. /*Rural-Urban Continuum Code 2013 - From SEER*Stat*/
      @499 Health_Service_Area               $char4. /*Health Service Area - From SEER*Stat*/
      @503 HealthService_Area_NCI_Modified   $char4. /*Health Service Area NCI Modified - From SEER*Stat*/
      @507 County_at_DX_Geocode_1990         $char3. /*County at DX Geocode 1990*/
      @510 County_at_DX_Geocode_2000	     $char3. /*County at DX Geocode 2000*/
      @513 County_at_DX_Geocode_2010         $char3. /*County at DX Geocode 2010*/
      @516 Derived_SS1977_flag               $char1. /*Derived SS1977 - Flag (2004+)         (Not available for NY, MA, ID and TX)*/
      @517 Derived_SS2000_flag               $char1. /*Derived SS2000 - Flag (2004+)         (Not available for NY, MA, ID and TX)*/
      @518 Radiation                         $char1. /*Radiation                             (Not available for NY, MA, ID and TX)*/
      @519 RadiationtoBrainorCNS_1988_1997   $char1. /*Radiation to Brain or CNS (1988-1997) (Not available for NY, MA, ID and TX)*/
      @520 SEER_DateofDeath_Month            $char2. /*Death Month based on Stat_rec         (Not available for NY, MA, ID and TX)*/
      @522 SEER_DateofDeath_Year             $char4. /*Death Year based on Stat_rec          (Not available for NY, MA, ID and TX)*/
      @526 Month_of_last_follow_up_recode    $char2. /*Month of Follow-up Recode, study cutoff used (Not available for NY, MA, ID and TX)*/
      @528 Year_of_last_follow_up_recode     $char4. /*Year of Follow-up Recode, study cutoff used  (Not available for NY, MA, ID and TX)*/
      @533 Year_of_birth                     $char4. /*Year of Birth*/
      @537 Date_of_diagnosis_flag            $char2. /*Date of Diagnosis Flag*/
      @539 Date_therapy_started_flag         $char2. /*Date of Therapy Started Flag*/
      @541 Date_of_birth_flag                $char2. /*Date of Birth flag*/
      @543 Date_of_last_follow_up_flag       $char2. /*Date of Last Follow-up Flag*/
      @545 Month_therapy_started             $char2. /*Month Therapy Started*/
      @547 Year_therapy_started              $char4. /*Year Therapy Started*/
      @551 Other_cancer_directed_therapy     $char1. /*Other Cancer-Directed Therapy*/
      @552 Derived_AJCC_flag                 $char1. /*Derived AJCC - Flag (2004+)        (Not available for NY, MA, ID and TX)*/
      @553 Derived_SS1977                    $char1. /*Derived SS1977 (2004-2015)         (Not available for NY, MA, ID and TX)*/
      @554 Derived_SS2000                    $char1. /*Derived SS2000 (2004+)             (Not available for NY, MA, ID and TX)*/
      @555 SEER_Summary_stage_1977_9500	     $char1. /*SEER summary stage 1977(1995-2000) (Not available for NY, MA, ID and TX)*/
      @556 SEER_Summary_stage_2000_0103	     $char1. /*SEER summary stage 2000(2001-2003) (Not available for NY, MA, ID and TX)*/

      @558 Primary_Payer_at_DX               $char2. /*Primary Payer at DX                 (Not available for NY, MA, ID and TX)*/
      @569 Recode_ICD_0_2_to_9               $char4. /*Recode ICD-O-2 to 9                 (Not available for NY, MA, ID and TX)*/
      @573 Recode_ICD_0_2_to_10              $char4. /*Recode ICD-O-2 to 10                (Not available for NY, MA, ID and TX)*/
      @577 NHIA_Derived_Hisp_Origin          $char1. /*NHIA Dervied Hispanic Origin        (Not available for NY, MA, ID and TX)*/
      @578 Age_site_edit_override            $char1. /*Age-site edit override              (Not available for NY, MA, ID and TX)*/
      @579 Sequencenumber_dx_conf_override   $char1. /*Sequence number-dx conf override    (Not available for NY, MA, ID and TX)*/
      @580 Site_type_lat_seq_override        $char1. /*Site-type-lat-seq override          (Not available for NY, MA, ID and TX)*/
      @581 Surgerydiagnostic_conf_override   $char1. /*Surgery-diagnostic conf override    (Not available for NY, MA, ID and TX)*/
      @582 Site_type_edit_override           $char1. /*Site-type edit override             (Not available for NY, MA, ID and TX)*/
      @583 Histology_edit_override           $char1. /*Histology edit override             (Not available for NY, MA, ID and TX)*/
      @584 Report_source_sequence_override   $char1. /*Report source sequence override     (Not available for NY, MA, ID and TX)*/
      @585 Seq_ill_defined_site_override     $char1. /*Seq-ill-defined site override       (Not available for NY, MA, ID and TX)*/
      @586 LeukLymphdxconfirmationoverride   $char1. /*Leuk-Lymph dx confirmation override (Not available for NY, MA, ID and TX)*/
      @587 Site_behavior_override            $char1. /*Site-behavior override              (Not available for NY, MA, ID and TX)*/
      @588 Site_EOD_dx_date_override         $char1. /*Site-EOD-dx date override           (Not available for NY, MA, ID and TX)*/
      @589 Site_laterality_EOD_override      $char1. /*Site-laterality-EOD override        (Not available for NY, MA, ID and TX)*/
      @590 Site_laterality_morph_override    $char1. /*Site-laterality-morph override      (Not available for NY, MA, ID and TX)*/

      @591 SEER_Summary_Stage_2000newonly    $char1. /*Summary Stage 2000 (NAACCR Item-759)   Only available for NY, MA, ID and TX for dx years 2001-2003*/

      @592 Insurance_Recode_2007             1. /*Insurance Recode (2007+)                 (Not available for NY, MA, ID and TX)*/
      @593 Yost_ACS_2006_2010                5. /*Yost Index (ACS 2006-2010)*/
      @598 Yost_ACS_2010_2014                5. /*Yost Index (ACS 2010-2014)*/
      @603 Yost_ACS_2013_2017                5. /*Yost Index (ACS 2013-2017)*/
      @608 Yost_ACS_2006_2010_State_based    5. /*Yost Index (ACS 2006-2010) - State based*/
      @613 Yost_ACS_2010_2014_State_based    5. /*Yost Index (ACS 2010-2014) - State based*/
      @618 Yost_ACS_2013_2017_State_based    5. /*Yost Index (ACS 2013-2017) - State based*/
      @623 Yost_ACS_2006_2010_quintile       $char1. /*Yost Index Quintile (ACS 2006-2010)*/
      @624 Yost_ACS_2010_2014_quintile       $char1. /*Yost Index Quintile (ACS 2010-2014)*/
      @625 Yost_ACS_2013_2017_quintile       $char1. /*Yost Index Quintile (ACS 2013-2017)*/
      @626 YostACS20062010quintileStatebas   $char1. /*Yost Index Quintile (ACS 2006-2010) - State based*/
      @627 YostACS20102014quintileStatebas   $char1. /*Yost Index Quintile (ACS 2010-2014) - State based*/
      @628 YostACS20132017quintileStatebas   $char1. /*Yost Index Quintile (ACS 2013-2017) - State based*/
      @629 Brain_Molecular_Markers_2018	     $char3. /*Brain Molecular Markers (2018+)                    (Not available for NY, MA, ID and TX)*/
      @632 AFPPostOrchiectomyLabValueRecod   $char3. /*AFP Post-Orchiectomy Lab Value Recode (2010+)      (Not available for NY, MA, ID and TX)*/
      @635 AFPPretreatmentInterpretationRe   $char2. /*AFP Pretreatment Interpretation Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @637 B_Symptoms_Recode_2010	     $char2. /*B Symptoms Recode (2010+)                          (Not available for NY, MA, ID and TX)*/
      @639 Breslow_Thickness_Recode_2010     $char5. /*Breslow Thickness Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @644 CA125PretreatmentInterpretation   $char2. /*CA-125 Pretreatment Interpretation Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @646 CEAPretreatmentInterpretationRe   $char2. /*CEA Pretreatment Interpretation Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @648 Chromosome19qLossofHeterozygosi   $char2. /*Chromosome 19q: Loss of Heterozygosity (LOH) Recode (2010+) (Not available for NY, MA, ID and TX)*/
      @650 Chromosome1pLossofHeterozygosit   $char2. /*Chromosome 1p: Loss of Heterozygosity (LOH) Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @652 Fibrosis_Score_Recode_2010	     $char2. /*Fibrosis Score Recode (2010+)                           (Not available for NY, MA, ID and TX)*/
      @654 GestationalTrophoblasticPrognos   $char2. /*Gestational Trophoblastic Prognostic Scoring Index Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @656 GleasonPatternsClinicalRecode20   $char3. /*Gleason Patterns Clinical Recode (2010+)                (Not available for NY, MA, ID and TX)*/
      @659 GleasonPatternsPathologicalReco   $char3. /*Gleason Patterns Pathological Recode (2010+)            (Not available for NY, MA, ID and TX)*/
      @662 GleasonScoreClinicalRecode_2010   $char2. /*Gleason Score Clinical Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @664 GleasonScorePathologicalRecode2   $char2. /*Gleason Score Pathological Recode (2010+)               (Not available for NY, MA, ID and TX)*/
      @666 hCGPostOrchiectomyRangeRecode20   $char2. /*hCG Post-Orchiectomy Range Recode (2010+)               (Not available for NY, MA, ID and TX)*/
      @668 InvasionBeyondCapsuleRecode2010   $char2. /*Invasion Beyond Capsule Recode (2010+)                  (Not available for NY, MA, ID and TX)*/
      @670 IpsilateralAdrenalGlandInvolvem   $char2. /*Ipsilateral Adrenal Gland Involvement Recode (2010+)    (Not available for NY, MA, ID and TX)*/
      @672 LDHPostOrchiectomyRangeRecode20   $char2. /*LDH Post-Orchiectomy Range Recode (2010+)               (Not available for NY, MA, ID and TX)*/
      @674 LDHPretreatmentLevelRecode_2010   $char2. /*LDH Pretreatment Level Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @676 LNHeadandNeckLevelsIIIIRecode20   $char2. /*LN Head and Neck Levels I-III Recode (2010+)            (Not available for NY, MA, ID and TX)*/
      @678 LNHeadandNeckLevelsIVVRecode201   $char2. /*LN Head and Neck Levels IV-V Recode (2010+)             (Not available for NY, MA, ID and TX)*/
      @680 LNHeadandNeckLevelsVIVIIRecode2   $char2. /*LN Head and Neck Levels VI-VII Recode (2010+)           (Not available for NY, MA, ID and TX)*/
      @682 LNHeadandNeck_Other_Recode_2010   $char2. /*LN Head and Neck Other Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @684 LNPositiveAxillaryLevelIIIRecod   $char3. /*LN Positive Axillary Level I-II Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @687 Lymph_Node_Size_Recode_2010	     $char3. /*Lymph Node Size Recode (2010+)                          (Not available for NY, MA, ID and TX)*/
      @690 MajorVeinInvolvementRecode_2010   $char2. /*Major Vein Involvement Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @692 MeasuredBasalDiameterRecode2010   $char5. /*Measured Basal Diameter Recode (2010+)                  (Not available for NY, MA, ID and TX)*/
      @697 Measured_Thickness_Recode_2010    $char5. /*Measured Thickness Recode (2010+)                       (Not available for NY, MA, ID and TX)*/
      @704 MitoticRateMelanoma_Recode_2010   $char3. /*Mitotic Rate Melanoma Recode (2010+)                    (Not available for NY, MA, ID and TX)*/
      @707 NumberofCoresPositiveRecode2010   $char3. /*Number of Cores Positive Recode (2010+)                 (Not available for NY, MA, ID and TX)*/
      @710 NumberofCoresExaminedRecode2010   $char3. /*Number of Cores Examined Recode (2010+)                 (Not available for NY, MA, ID and TX)*/
      @713 NumberofExaminedParaAorticNodes   $char3. /*Number of Examined Para-Aortic Nodes Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @716 NumberofExaminedPelvicNodesReco   $char3. /*Number of Examined Pelvic Nodes Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @719 NumberofPositiveParaAorticNodes   $char3. /*Number of Positive Para-Aortic Nodes Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @722 NumberofPositivePelvicNodesReco   $char3. /*Number of Positive Pelvic Nodes Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @725 Perineural_Invasion_Recode_2010   $char2. /*Perineural Invasion Recode (2010+)                      (Not available for NY, MA, ID and TX)*/
      @727 PeripheralBloodInvolvementRecod   $char2. /*Peripheral Blood Involvement Recode (2010+)             (Not available for NY, MA, ID and TX)*/
      @729 Peritoneal_Cytology_Recode_2010   $char2. /*Peritoneal Cytology Recode (2010+)                      (Not available for NY, MA, ID and TX)*/
      @731 Pleural_Effusion_Recode_2010	     $char2. /*Pleural Effusion Recode (2010+)                         (Not available for NY, MA, ID and TX)*/
      @733 PSA_Lab_Value_Recode_2010	     $char5. /*PSA Lab Value Recode (2010+)                            (Not available for NY, MA, ID and TX)*/
      @738 ResidualTumorVolumePostCytoredu   $char3. /*Residual Tumor Volume Post Cytoreduction Recode (2010+) (Not available for NY, MA, ID and TX)*/
      @741 ResponsetoNeoadjuvantTherapyRec   $char2. /*Response to Neoadjuvant Therapy Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @743 SarcomatoidFeatures_Recode_2010   $char2. /*Sarcomatoid Features Recode (2010+)                     (Not available for NY, MA, ID and TX)*/
      @745 SeparateTumorNodulesIpsilateral   $char2. /*Separate Tumor Nodules Ipsilateral Lung Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @747 Tumor_Deposits_Recode_2010	     $char3. /*Tumor Deposits Recode (2010+)                           (Not available for NY, MA, ID and TX)*/
      @750 Ulceration_Recode_2010	     $char2. /*Ulceration Recode (2010+)                               (Not available for NY, MA, ID and TX)*/
      @752 VisceralandParietalPleuralInvas   $char2. /*Visceral and Parietal Pleural Invasion Recode (2010+)   (Not available for NY, MA, ID and TX)*/
      @754 ENHANCED_FIVE_PERCENT_FLAG        $char1. /*Five Percent Flag from MBSF*/
      @755 Date_of_Death_Flag_created        $char1. /*Date of Death Flag (SEER vs Medicare)                   (Not available for NY, MA, ID and TX)*/
      @756 Date_of_Birth_Flag_created        $char1. /*Date of Birth Flag (SEER vs Medicare)*/

      @757 OncotypeDXBreastRecurrenceScore   3. /*Oncotype DX Breast Recurrence Score  -- Needs special permission  (Not available for MA and TX)*/
      @760 OncotypeDXRSgroupRS18RS1830RS30   1. /*Oncotype DX RS group (RS < 18, RS 18-30, RS > 30) -- Needs special permission  (Not available for MA and TX)*/
      @761 OncotypeDXreasonno_score_linked   1. /*Oncotype DX reason no score linked -- Needs special permission    (Not available for MA and TX)*/
      @762 Oncotype_DX_year_of_test_report   4. /*Oncotype DX year of test report -- Needs special permission       (Not available for MA and TX)*/
      @766 OncotypeDX_month_of_test_report   2. /*Oncotype DX month of test report -- Needs special permission      (Not available for MA and TX)*/
      @768 OncotypeDXmonthssince_diagnosis   3. /*Oncotype DX months since diagnosis -- Needs special permission    (Not available for MA and TX)*/
      ;


  label
     PATIENT_ID                        = "Patient ID"
     SEER_registry                     = "Registry"
     SEERregistrywithCAandGAaswholes   = "Registry with CA and GA as whole states"
     Louisiana20051stvs2ndhalfofyear   = "Louisiana 2005 1st vs 2nd half of the year"
     Marital_status_at_diagnosis       = "Marital Status"
     Race_ethnicity                    = "Race ethnicity"
     sex                               = "Sex"
     Agerecodewithsingleages_and_100   = "Age recode with single ages and 100+"
     agerecodewithsingle_ages_and_85   = "Age recode with single ages and 85+"
     Sequence_number                   = "Sequence Number"
     Month_of_diagnosis                = "Month of Diagnosis, Not month diagnosis recode"
     Year_of_diagnosis                 = "Year of Diagnosis"
     CoC_Accredited_Flag_2018          = "CoC Accredited Flag (2018+)"
     Month_of_diagnosis_recode         = "Month of Diagnosis Recode"
     Primary_Site                      = "Primary Site"
     Laterality                        = "Laterality"
     Histology_ICD_O_2                 = "Histology ICD-0-2"
     Behavior_code_ICD_O_2             = "Behavior ICD-0-2"
     Histologic_Type_ICD_O_3           = "Histologic type ICD-0-3"
     Behavior_code_ICD_O_3             = "Behavior code ICD-0-3"
     Grade_thru_2017                   = "Grade (thru 2017)"
     Schema_ID_2018                    = "Schema ID (2018+)"
     Grade_Clinical_2018               = "Grade Clinical (2018+)"
     Grade_Pathological_2018           = "Grade Pathological (2018+)"
     Diagnostic_Confirmation           = "Diagnostic Confirmation"
     Type_of_Reporting_Source          = "Type of Reporting Source"
     EOD_10_size_1988_2003             = "EOD 10 - SIZE (1998-2003)"
     EOD_10_extent_1988_2003           = "EOD 10 - EXTENT (1998-2003)"
     EOD10Prostatepath_ext_1995_2003   = "EOD 10 - Prostate path ext (1995-2003)"
     EOD_10_nodes_1988_2003            = "EOD 10 - Nodes (1995-2003)"
     Regional_nodes_positive_1988      = "EOD 10 - Regional Nodes positive (1988+)"
     Regional_nodes_examined_1988      = "EOD 10 - Regional Nodes examined (1988+)"
     Expanded_EOD_1_CP53_1973_1982     = "EOD - expanded 1st digit"
     Expanded_EOD_2_CP54_1973_1982     = "EOD - expanded 2nd digit"
     Expanded_EOD_3_CP55_1973_1982     = "EOD - expanded 3rd digit"
     Expanded_EOD_4_CP56_1973_1982     = "EOD - expanded 4th digit"
     Expanded_EOD_5_CP57_1973_1982     = "EOD - expanded 5th digit"
     Expanded_EOD_6_CP58_1973_1982     = "EOD - expanded 6th digit"
     Expanded_EOD_7_CP59_1973_1982     = "EOD - expanded 7th digit"
     Expanded_EOD_8_CP60_1973_1982     = "EOD - expanded 8th digit"
     Expanded_EOD_9_CP61_1973_1982     = "EOD - expanded 9th digit"
     Expanded_EOD_10_CP62_1973_1982    = "EOD - expanded 10th digit"
     Expanded_EOD_11_CP63_1973_1982    = "EOD - expanded 11th digit"
     Expanded_EOD_12_CP64_1973_1982    = "EOD - expanded 12th digit"
     Expanded_EOD_13_CP65_1973_1982    = "EOD - expanded 13th digit"
     EOD_4_size_1983_1987              = "EOD 4 - Size (1983-1987)         "
     EOD_4_extent_1983_1987            = "EOD 4 - Extent (1983-1987)       "
     EOD_4_nodes_1983_1987             = "EOD 4 - Nodes (1983-1987)        "
     Coding_system_EOD_1973_2003       = "EOD Coding System (1973-2003)    "
     Tumor_marker_1_1990_2003          = "Tumor marker 1 (1990-2003)       "
     Tumor_marker_2_1990_2003          = "Tumor marker 2 (1990-2003)       "
     Tumor_marker_3_1998_2003          = "Tumor marker 3 (1990-2003        "
     CS_tumor_size_2004_2015           = "CS Tumor size (2004-2015)        "
     CS_extension_2004_2015            = "CS extension (2004-2015)         "
     CS_lymph_nodes_2004_2015          = "CS Lymph nodes (2004-2015)       "
     CS_mets_at_dx_2004_2015           = "CS Mets at dx                    "
     CSsitespecificfactor120042017va   = "CS site-specific factor 1 (2004-2017 varying by schema)"
     CSsitespecificfactor220042017va   = "CS site-specific factor 2 (2004-2017 varying by schema)"
     CSsitespecificfactor320042017va   = "CS site-specific factor 3 (2004-2017 varying by schema)"
     CSsitespecificfactor420042017va   = "CS site-specific factor 4 (2004-2017 varying by schema)"
     CSsitespecificfactor520042017va   = "CS site-specific factor 5 (2004-2017 varying by schema)"
     CSsitespecificfactor620042017va   = "CS site-specific factor 6 (2004-2017 varying by schema)"
     CSsitespecificfactor720042017va   = "CS site-specific factor 7 (2004-2017 varying by schema)"
     CSsitespecificfactor820042017va   = "CS site-specific factor 8 (2004-2017 varying by schema)"
     CSsitespecificfactor920042017va   = "CS site-specific factor 9 (2004-2017 varying by schema)"
     CSsitespecificfactor1020042017v   = "CS site-specific factor 10 (2004-2017 varying by schema)"
     CSsitespecificfactor1120042017v   = "CS site-specific factor 11 (2004-2017 varying by schema)"
     CSsitespecificfactor1220042017v   = "CS site-specific factor 12 (2004-2017 varying by schema)"
     CSsitespecificfactor1320042017v   = "CS site-specific factor 13 (2004-2017 varying by schema)"
     CSsitespecificfactor1520042017v   = "CS site-specific factor 15 (2004-2017 varying by schema)"
     CSsitespecificfactor1620042017v   = "CS site-specific factor 16 (2004-2017 varying by schema)"
     CSsitespecificfactor2520042017v   = "CS site-specific factor 25 (2004-2017 varying by schema)"
     Derived_AJCC_T_6th_ed_2004_2015   = "Derived AJCC T 6th ed (2004-2015)"
     Derived_AJCC_N_6th_ed_2004_2015   = "Derived AJCC N 6th ed (2004-2015)"
     Derived_AJCC_M_6th_ed_2004_2015   = "Derived AJCC M 6th ed (2004-2015)"
     DerivedAJCCStageGroup6thed20042   = "Derived AJCC STAGE Group 6th ed (2004-2015)"
     SEERCombinedSummaryStage2000200   = "SEER Combined Summary Stage 2000 (2004+)"
     Combined_Summary_Stage_2004       = "Combined Summary Stage (2004+)"
     CSversioninputoriginal2004_2015   = "CS version input original (2004-2015)"
     CS_version_derived_2004_2015      = "CS version derived (2004-2015)"
     CSversioninputcurrent_2004_2015   = "CS version input current (2004-2015)"
     RX_Summ_Surg_Prim_Site_1998       = "RX Summ-Surg Prim site 1998+     "
     RX_Summ_Scope_Reg_LN_Sur_2003     = "RX Summ-Scope Reg LN Sur (2003+) "
     RX_Summ_Surg_Oth_Reg_Dis_2003     = "RX Summ-Surg Oth reg/dis (2003+) "
     RXSummReg_LN_Examined_1998_2002   = "RX Summ-Reg LN examined (1998-2002)"
     RX_Summ_Systemic_Surg_Seq         = "RX Summ--Systemic Surg Seq"
     RX_Summ_Surg_Rad_Seq              = "Radiation Sequence with Surgery"
     Reasonnocancer_directed_surgery   = "Reason No Cancer-Directed Surgery"
     Radiation_recode                  = "Radiation Recode (0 and 9 combined) - created"
     Chemotherapy_recode_yes_no_unk    = "CHEMOTHERAPY Recode, yes(1)/no/unknown(0) - created"
     Sitespecificsurgery19731997vary   = "Site Specific Surgery (1973-1997)"
     Scopeofreglymphndsurg_1998_2002   = "Scope of Reg Lymph ND Surg (1998-2002)"
     Surgeryofothregdissites19982002   = "Surgery of Oth Reg/Dis sites (1998-2002)"
     Record_number_recode              = "Record Number Recode             "
     Age_recode_with_1_year_olds       = "Age Recode with <1 Year Olds     "
     Site_recode_ICD_O_3_WHO_2008      = "Site Recode ICD-O-3/WHO 2008)    "
     Site_recode_rare_tumors           = "Site recode - rare tumors"
     Behavior_recode_for_analysis      = "Behavior Recode for Analysis"
     Histologyrecode_broad_groupings   = "Histology Recode - Broad Groupings"
     Histologyrecode_Brain_groupings   = "Histology Recode - Brain Groupings"
     ICCCsiterecodeextended3rdeditio   = "ICCC Site Recode Extended 3rd Edition/IARC 2017"
     TNM_7_CS_v0204_Schema_thru_2017   = "TNM 7/CS v0204+ Schema (thru 2017)"
     TNM_7_CS_v0204_Schema_recode      = "TNM 7/CS v0204+ Schema recode"
     Race_recode_White_Black_Other     = "Race Recode (White, Black, Other)"
     Race_recode_W_B_AI_API            = "Race Recode (W, B, AI, API)"
     OriginrecodeNHIAHispanicNonHisp   = "Origin Recode NHIA (Hispanic, Non-Hispanic)"
     RaceandoriginrecodeNHWNHBNHAIAN   = "Race and origin recode (NHW, NHB, NHAIAN, NHAPI, Hispanic)"
     SEER_historic_stage_A_1973_2015   = "SEER Historic Stage A (1973-2015)"
     AJCCstage_3rd_edition_1988_2003   = "AJCC Stage 3rd Edition (1988-2003)"
     SEERmodifiedAJCCstage3rd1988200   = "SEER Modified AJCC Stage 3rd Edition (1988-2003)"
     Firstmalignantprimary_indicator   = "First Malignant Primary Indicator"
     state                             = "FIPS State"
     county                            = "FIPS County"
     Medianhouseholdincomeinflationa   = "County Attributes - Time Dependent Income"
     Rural_Urban_Continuum_Code        = "County Attributes - Time Dependent Rurality"
     PRCDA_2017	                       = "PRCDA - 2017"
     PRCDA_Region	             = "PRCDA - Region"
     COD_to_site_recode                = "COD to Site Recode"
     COD_to_site_rec_KM                = "COD to Site Recode KM"
     Vitalstatusrecodestudycutoffuse   = "Vital Status Recode (Study Cutoff Used)"
     IHS_Link                          = "IHS LINK"
     Summary_stage_2000_1998_2017      = "Summary stage 2000 (1998-2017)"
     AYA_site_recode_WHO_2008          = "AYA site recode/WHO 2008"
     AYA_site_recode_2020_Revision     = "AYA site recode 2020 Revision"
     Lymphoidneoplasmrecode2021Revis   = "Lymphoid neoplasm recode 2021 Revision"
     LymphomasubtyperecodeWHO2008thr   = "Lymphoma subtype recode/WHO 2008 (thru 2017)"
     SEER_Brain_and_CNS_Recode         = "SEER Brain and CNS Recode"
     ICCCsiterecode3rdeditionIARC201   = "ICCC Site Recode 3rd Edition/IARC 2017"
     SEERcausespecificdeathclassific   = "SEER Cause-Specific Death Classification"
     SEERothercauseofdeathclassifica   = "SEER Other Cause of Death Classification"
     CSTumor_Size_Ext_Eval_2004_2015   = "CS Tumor Size/Ext Eval (2004-2015) "
     CS_Reg_Node_Eval_2004_2015        = "CS Reg Node Eval (2004-2015)"
     CS_Mets_Eval_2004_2015            = "CS Mets Eval (2004-2015)"
     Primary_by_international_rules    = "Primary by International Rules"
     ERStatusRecodeBreastCancer_1990   = "ER Status Recode Breast Cancer (1990+)"
     PRStatusRecodeBreastCancer_1990   = "PR Status Recode Breast Cancer (1990+)"
     CS_Schema_AJCC_6th_Edition        = "CS Schema--AJCC 6th Edition"
     LymphvascularInvasion2004varyin   = "Lymph Vascular Invasion (2004+ Varying by Schema)"
     Survival_months                   = "Survival Months"
     Survival_months_flag              = "Survival Months Flag"
     Derived_AJCC_T_7th_ed_2010_2015   = "Derived AJCC T, 7th Ed 2010-2015)"
     Derived_AJCC_N_7th_ed_2010_2015   = "Derived AJCC N, 7th Ed 2010-2015)"
     Derived_AJCC_M_7th_ed_2010_2015   = "Derived AJCC M, 7th Ed 2010-2015)"
     DerivedAJCCStageGroup7thed20102   = "Derived AJCC Stage Group, 7th Ed 2010-2015)"
     BreastAdjustedAJCC6thT1988_2015   = "Breast--Adjusted AJCC 6th T (1988-2015)"
     BreastAdjustedAJCC6thN1988_2015   = "Breast--Adjusted AJCC 6th N (1988-2015)"
     BreastAdjustedAJCC6thM1988_2015   = "Breast--Adjusted AJCC 6th M (1988-2015)"
     BreastAdjustedAJCC6thStage19882   = "Breast--Adjusted AJCC 6th Stage (1988-2015)"
     Derived_HER2_Recode_2010          = "Derived HER2 Recode (2010+)"
     Breast_Subtype_2010               = "Breast Subtype (2010+)"
     LymphomaAnnArborStage_1983_2015   = "Lymphomas: Ann Arbor Staging (1983-2015)"
     SEERCombinedMetsat_DX_bone_2010   = "SEER Combined Mets at Dx-Bone (2010+)"
     SEERCombinedMetsatDX_brain_2010   = "SEER Combined Mets at Dx-Brain (2010+)"
     SEERCombinedMetsatDX_liver_2010   = "SEER Combined Mets at Dx-Liver (2010+)"
     SEERCombinedMetsat_DX_lung_2010   = "SEER Combined Mets at Dx-Lung (2010+)"
     TvaluebasedonAJCC_3rd_1988_2003   = "T Value - Based on AJCC 3rd (1988-2003)"
     NvaluebasedonAJCC_3rd_1988_2003   = "N Value - Based on AJCC 3rd (1988-2003)"
     MvaluebasedonAJCC_3rd_1988_2003   = "M Value - Based on AJCC 3rd (1988-2003)"
     Totalnumberofinsitumalignanttum   = "Total Number of In Situ/Malignant Tumors for Patient"
     Totalnumberofbenignborderlinetu   = "Total Number of Benign/Borderline Tumors for Patient"
     RadiationtoBrainorCNSRecode1988   = "Radiation to Brain or CNS Recode (1988-1997)"
     Tumor_Size_Summary_2016	       = "Tumor Size Summary (2016+)"
     DerivedSEERCmbStg_Grp_2016_2017   = "Derived SEER Combined STG GRP (2016+)"
     DerivedSEERCombined_T_2016_2017   = "Derived SEER Combined T (2016+)"
     DerivedSEERCombined_N_2016_2017   = "Derived SEER Combined N (2016+)"
     DerivedSEERCombined_M_2016_2017   = "Derived SEER Combined M (2016+)"
     DerivedSEERCombinedTSrc20162017   = "Derived SEER Combined T SRC (2016+)"
     DerivedSEERCombinedNSrc20162017   = "Derived SEER Combined N SRC (2016+)"
     DerivedSEERCombinedMSrc20162017   = "Derived SEER Combined M SRC (2016+)"
     TNM_Edition_Number_2016_2017      = "TNM Edition Number (2016-2017)"
     Mets_at_DX_Distant_LN_2016	       = "Mets at Dx-Distant LN (2016+)"
     Mets_at_DX_Other_2016	       = "Mets at DX--Other (2016+)"
     AJCC_ID_2018                      = "AJCC ID (2018+)"
     EOD_Schema_ID_Recode_2010         = "EOD Schema ID Recode (2010+)"
     Derived_EOD_2018_T_2018           = "Derived EOD 2018 T (2018+)"
     Derived_EOD_2018_N_2018           = "Derived EOD 2018 N (2018+)"
     Derived_EOD_2018_M_2018           = "Derived EOD 2018 M (2018+)"
     DerivedEOD2018_Stage_Group_2018   = "Derived EOD 2018 Stage Group (2018+)"
     EOD_Primary_Tumor_2018            = "EOD Primary Tumor (2018+)"
     EOD_Regional_Nodes_2018           = "EOD Regional Nodes (2018+)"
     EOD_Mets_2018                     = "EOD Mets (2018+)"
     Monthsfromdiagnosisto_treatment   = "Months from diagnosis to treatment"
     Census_Tract_1990                 = "Census Track 1990"
     Census_Tract_2000                 = "Census Track 2000"
     Census_Tract_2010                 = "Census Track 2010"
     Census_Coding_System	       = "Coding System for Census Track 1970/80/90"
     Census_Tract_Certainty_1990       = "Census Tract Certainty 1970/1980/1990"
     Census_Tract_Certainty_2000       = "Census Tract Certainty 2000"
     Census_Tract_Certainty_2010       = "Census Tract Certainty 2010"
     Rural_Urban_Continuum_Code_1993   = "Rural-Urban Continuum Code 1993 - From SEER*Stat"
     Rural_Urban_Continuum_Code_2003   = "Rural-Urban Continuum Code 2003 - From SEER*Stat"
     Rural_Urban_Continuum_Code_2013   = "Rural-Urban Continuum Code 2013 - From SEER*Stat"
     Health_Service_Area               = "Health Service Area - From SEER*Stat"
     HealthService_Area_NCI_Modified   = "Health Service Area NCI Modified - From SEER*Stat"
     County_at_DX_Geocode_1990         = "County at DX Geocode 1990"
     County_at_DX_Geocode_2000	       = "County at DX Geocode 2000"
     County_at_DX_Geocode_2010         = "County at DX Geocode 2010"
     Derived_SS1977_flag               = "Derived SS1977 - Flag (2004+)"
     Derived_SS2000_flag               = "Derived SS2000 - Flag (2004+)"
     Radiation                         = "Radiation"
     RadiationtoBrainorCNS_1988_1997   = "Radiation to Brain or CNS (1988-1997)"
     SEER_DateofDeath_Month            = "Death Month based on Stat_rec"
     SEER_DateofDeath_Year             = "Death Year based on Stat_rec"
     Month_of_last_follow_up_recode    = "Month of Follow-up recode, study cutoff used"
     Year_of_last_follow_up_recode     = "Year of Follow-up recode, study cutoff used"
     Year_of_birth                     = "Year of Birth"
     Date_of_diagnosis_flag            = "Date of Diagnosis Flag"
     Date_therapy_started_flag         = "Date of Therapy Started Flag"
     Date_of_birth_flag                = "Date of Birth flag"
     Date_of_last_follow_up_flag       = "Date of Last Follow-up Flag"
     Month_therapy_started             = "Month Therapy Started"
     Year_therapy_started              = "Year Therapy Started"
     Other_cancer_directed_therapy     = "Other Cancer-Directed Therapy"
     Derived_AJCC_flag                 = "Derived AJCC - Flag (2004+)"
     Derived_SS1977                    = "Derived SS1977 (2004-2015)"
     Derived_SS2000                    = "Derived SS2000 (2004+)"
     SEER_Summary_stage_1977_9500      = "SEER summary stage 1977(1995-2000)"
     SEER_Summary_stage_2000_0103      = "SEER summary stage 2000(2001-2003)"
     Primary_Payer_at_DX               = "Primary Payer at DX"
     Recode_ICD_0_2_to_9               = "Recode ICD-O-2 to 9"
     Recode_ICD_0_2_to_10              = "Recode ICD-O-2 to 10"
     NHIA_Derived_Hisp_Origin          = "NHIA Dervied Hispanic Origin"
     Age_site_edit_override            = "Age-site edit override"
     Sequencenumber_dx_conf_override   = "Sequence number-dx conf override"
     Site_type_lat_seq_override        = "Site-type-lat-seq override"
     Surgerydiagnostic_conf_override   = "Surgery-diagnostic conf override"
     Site_type_edit_override           = "Site-type edit override"
     Histology_edit_override           = "Histology edit override"
     Report_source_sequence_override   = "Report source sequence override"
     Seq_ill_defined_site_override     = "Seq-ill-defined site override"
     LeukLymphdxconfirmationoverride   = "Leuk-Lymph dx confirmation override"
     Site_behavior_override            = "Site-behavior override"
     Site_EOD_dx_date_override         = "Site-EOD-dx date override"
     Site_laterality_EOD_override      = "Site-laterality-EOD override"
     Site_laterality_morph_override    = "Site-laterality-morph override"
     SEER_Summary_Stage_2000newonly    = "Summary Stage 2000 (NAACCR Item-759) (Only to be available for new registries for diagnosis years 2000-2003)"
     Insurance_Recode_2007             = "Insurance Recode (2007+)"
     Yost_ACS_2006_2010                = "Yost Index (ACS 2006-2010)"
     Yost_ACS_2010_2014                = "Yost Index (ACS 2010-2014)"
     Yost_ACS_2013_2017                = "Yost Index (ACS 2013-2017)"
     Yost_ACS_2006_2010_State_based    = "Yost Index (ACS 2006-2010) - State Based"
     Yost_ACS_2010_2014_State_based    = "Yost Index (ACS 2010-2014) - State Based"
     Yost_ACS_2013_2017_State_based    = "Yost Index (ACS 2013-2017) - State Based"
     Yost_ACS_2006_2010_quintile       = "Yost Index Quintile (ACS 2006-2010)"
     Yost_ACS_2010_2014_quintile       = "Yost Index Quintile (ACS 2010-2014)"
     Yost_ACS_2013_2017_quintile       = "Yost Index Quintile (ACS 2013-2017)"
     YostACS20062010quintileStatebas   = "Yost Index Quintile (ACS 2006-2010) - State Based"
     YostACS20102014quintileStatebas   = "Yost Index Quintile (ACS 2010-2014) - State Based"
     YostACS20132017quintileStatebas   = "Yost Index Quintile (ACS 2013-2017) - State Based"
     Brain_Molecular_Markers_2018      = "Brain Molecular Markers (2018+)"
     AFPPostOrchiectomyLabValueRecod   = "AFP Post-Orchiectomy Lab Value Recode (2010+)"
     AFPPretreatmentInterpretationRe   = "AFP Pretreatment Interpretation Recode (2010+)"
     B_Symptoms_Recode_2010            = "B Symptoms Recode (2010+)"
     Breslow_Thickness_Recode_2010     = "Breslow Thickness Recode (2010+)"
     CA125PretreatmentInterpretation   = "CA-125 Pretreatment Interpretation Recode (2010+)"
     CEAPretreatmentInterpretationRe   = "CEA Pretreatment Interpretation Recode (2010+)"
     Chromosome19qLossofHeterozygosi   = "Chromosome 19q: Loss of Heterozygosity (LOH) Recode (2010+)"
     Chromosome1pLossofHeterozygosit   = "Chromosome 1p: Loss of Heterozygosity (LOH) Recode (2010+)"
     Fibrosis_Score_Recode_2010        = "Fibrosis Score Recode (2010+)"
     GestationalTrophoblasticPrognos   = "Gestational Trophoblastic Prognostic Scoring Index Recode (2010+)"
     GleasonPatternsClinicalRecode20   = "Gleason Patterns Clinical Recode (2010+)"
     GleasonPatternsPathologicalReco   = "Gleason Patterns Pathological Recode (2010+)"
     GleasonScoreClinicalRecode_2010   = "Gleason Score Clinical Recode (2010+)"
     GleasonScorePathologicalRecode2   = "Gleason Score Pathological Recode (2010+)"
     hCGPostOrchiectomyRangeRecode20   = "hCG Post-Orchiectomy Range Recode (2010+)"
     InvasionBeyondCapsuleRecode2010   = "Invasion Beyond Capsule Recode (2010+)"
     IpsilateralAdrenalGlandInvolvem   = "Ipsilateral Adrenal Gland Involvement Recode (2010+)"
     LDHPostOrchiectomyRangeRecode20   = "LDH Post-Orchiectomy Range Recode (2010+)"
     LDHPretreatmentLevelRecode_2010   = "LDH Pretreatment Level Recode (2010+)"
     LNHeadandNeckLevelsIIIIRecode20   = "LN Head and Neck Levels I-III Recode (2010+)"
     LNHeadandNeckLevelsIVVRecode201   = "LN Head and Neck Levels IV-V Recode (2010+)"
     LNHeadandNeckLevelsVIVIIRecode2   = "LN Head and Neck Levels VI-VII Recode (2010+)"
     LNHeadandNeck_Other_Recode_2010   = "LN Head and Neck Other Recode (2010+)"
     LNPositiveAxillaryLevelIIIRecod   = "LN Positive Axillary Level I-II Recode (2010+)"
     Lymph_Node_Size_Recode_2010       = "Lymph Node Size Recode (2010+)"
     MajorVeinInvolvementRecode_2010   = "Major Vein Involvement Recode (2010+)"
     MeasuredBasalDiameterRecode2010   = "Measured Basal Diameter Recode (2010+)"
     Measured_Thickness_Recode_2010    = "Measured Thickness Recode (2010+)"
     MitoticRateMelanoma_Recode_2010   = "Mitotic Rate Melanoma Recode (2010+)"
     NumberofCoresPositiveRecode2010   = "Number of Cores Positive Recode (2010+)"
     NumberofCoresExaminedRecode2010   = "Number of Cores Examined Recode (2010+)"
     NumberofExaminedParaAorticNodes   = "Number of Examined Para-Aortic Nodes Recode (2010+)"
     NumberofExaminedPelvicNodesReco   = "Number of Examined Pelvic Nodes Recode (2010+)"
     NumberofPositiveParaAorticNodes   = "Number of Positive Para-Aortic Nodes Recode (2010+)"
     NumberofPositivePelvicNodesReco   = "Number of Positive Pelvic Nodes Recode (2010+)"
     Perineural_Invasion_Recode_2010   = "Perineural Invasion Recode (2010+)"
     PeripheralBloodInvolvementRecod   = "Peripheral Blood Involvement Recode (2010+)"
     Peritoneal_Cytology_Recode_2010   = "Peritoneal Cytology Recode (2010+)"
     Pleural_Effusion_Recode_2010      = "Pleural Effusion Recode (2010+)"
     PSA_Lab_Value_Recode_2010         = "PSA Lab Value Recode (2010+)"
     ResidualTumorVolumePostCytoredu   = "Residual Tumor Volume Post Cytoreduction Recode (2010+)"
     ResponsetoNeoadjuvantTherapyRec   = "Response to Neoadjuvant Therapy Recode (2010+)"
     SarcomatoidFeatures_Recode_2010   = "Sarcomatoid Features Recode (2010+)"
     SeparateTumorNodulesIpsilateral   = "Separate Tumor Nodules Ipsilateral Lung Recode (2010+)"
     Tumor_Deposits_Recode_2010        = "Tumor Deposits Recode (2010+)"
     Ulceration_Recode_2010            = "Ulceration Recode (2010+)"
     VisceralandParietalPleuralInvas   = "Visceral and Parietal Pleural Invasion Recode (2010+)"
     ENHANCED_FIVE_PERCENT_FLAG        = "Five Percent Flag from MBSF"
     Date_of_Death_Flag_created        = "Date of Death Flag (SEER vs Medicare)"
     Date_of_Birth_Flag_created        = "Date of Birth Flag (SEER vs Medicare)"
     OncotypeDXBreastRecurrenceScore   = "Oncotype DX Breast Recurrence Score  -- Needs special permission"
     OncotypeDXRSgroupRS18RS1830RS30   = "Oncotype DX RS group (RS < 18, RS 18-30, RS > 30) -- Needs special permission"
     OncotypeDXreasonno_score_linked   = "Oncotype DX reason no score linked -- Needs special permission"
     Oncotype_DX_year_of_test_report   = "Oncotype DX year of test report -- Needs special permission"
     OncotypeDX_month_of_test_report   = "Oncotype DX month of test report -- Needs special permission"
     OncotypeDXmonthssince_diagnosis   = "Oncotype DX months since diagnosis -- Needs special permission"
      ;

run;

proc contents data=seer.SEER_skin position;
run;








/* Census Track File */


filename tract 'S:\JamieHeyward\SEERMed_IRAE\SEER Medicare irAE 2013-2019\tract.encr.census.file.dt030222.txt';                /*reading in an un-zipped file*/
*filename tract pipe 'gunzip -c /directory/tract.census.encrypted.file.txt.gz';   /*reading in a zipped file*/

options nocenter validvarname=upcase;

data seer.tract;
  infile tract lrecl=463 missover pad;
  input @001 filetype      $char2.
        @003 f_state       $char2.
        @005 f_county      $char3.
        @008 tract         $char6.
        @014 ctpci         10.
        @024 ctmed         10.
        @034 ctden         10.
        @044 ctwht         6.2
        @050 ctblk         6.2
        @056 cthsp         6.2
        @062 cten5         6.2
        @068 cten6         6.2
        @074 ctnon         6.2
        @080 cthso         6.2
        @086 ctscl         6.2
        @092 ctcol         6.2
        @098 whtnon        6.2
        @104 whthso        6.2
        @110 whtscl        6.2
        @116 whtcol        6.2
        @122 blknon        6.2
        @128 blkhso        6.2
        @134 blkscl        6.2
        @140 blkcol        6.2
        @146 aminon        6.2
        @152 amihso        6.2
        @158 amiscl        6.2
        @164 amicol        6.2
        @170 asinon        6.2
        @176 asihso        6.2
        @182 asiscl        6.2
        @188 asicol        6.2
        @194 othnon        6.2
        @200 othhso        6.2
        @206 othscl        6.2
        @212 othcol        6.2
        @218 hspnon        6.2
        @224 hsphso        6.2
        @230 hspscl        6.2
        @236 hspcol        6.2
        @242 natnon        6.2
        @248 nathso        6.2
        @254 natscl        6.2
        @260 natcol        6.2
        @266 pov_tot       6.2
        @272 pov_totlt65   6.2
        @278 pov_tot6574   6.2
        @284 pov_tot75     6.2
        @290 pov_wht       6.2
        @296 pov_blk       6.2
        @302 pov_ami       6.2
        @308 pov_asi       6.2
        @314 pov_nat       6.2
        @320 pov_oth       6.2
        @326 pov_hsp       6.2
        @332 pov_whtlt65   6.2
        @338 pov_wht6574   6.2
        @344 pov_wht75     6.2
        @350 pov_blklt65   6.2
        @356 pov_blk6574   6.2
        @362 pov_blk75     6.2
        @368 pov_amilt65   6.2
        @374 pov_ami6574   6.2
        @380 pov_ami75     6.2
        @386 pov_asilt65   6.2
        @392 pov_asi6574   6.2
        @398 pov_asi75     6.2
        @404 pov_natlt65   6.2
        @410 pov_nat6574   6.2
        @416 pov_nat75     6.2
        @422 pov_othlt65   6.2
        @428 pov_oth6574   6.2
        @434 pov_oth75     6.2
        @440 pov_hsplt65   6.2
        @446 pov_hsp6574   6.2
        @452 pov_hsp75     6.2
        @458 s_state       $char2.
        @460 s_county      $char3.
        ;
      ;

label
  filetype = 'File Type Source'
  f_state  = 'State Code (FIPS coding)'
  f_county = 'County Code (FIPS coding)'
  tract    = 'Census Tract'
  ctpci    = 'Census Tract PCI'
  ctmed    = 'Census Tract Median Income'
  ctden    = 'Census Tract Density'
  ctwht    = 'Census Tract Pct Whites'
  ctblk    = 'Census Tract Pct Blacks'
  cthsp    = 'Census Tract Pct Hispanics'
  cten5    = 'Census Tract Pct of HHs who do not speak English well or at all 5+'
  cten6    = 'Census Tract Pct of HHs who do not speak English well or at all 65+'
  ctnon    = 'Census Tract Pct Non High School Grads'
  cthso    = 'Census Tract Pct High School Only'
  ctscl    = 'Census Tract Pct Some College Education'
  ctcol    = 'Census Tract Pct College Education at least 4 years'
  whtnon   = 'Whites - Census Tract Pct Non High School Grads by Race'
  whthso   = 'Whites - Census Tract Pct High School Only by Race'
  whtscl   = 'Whites - Census Tract Pct Some College by Race'
  whtcol   = 'Whites - Census Tract Pct College Education at least 4 years by Race'
  blknon   = 'Blacks - Census Tract Pct Non High School Grads by Race'
  blkhso   = 'Blacks - Census Tract Pct High School Only by Race'
  blkscl   = 'Blacks - Census Tract Pct Some College by Race'
  blkcol   = 'Blacks - Census Tract Pct College Education at least 4 years by Race'
  aminon   = 'American Indian - Census Tract Pct Non High School Grads by Race'
  amihso   = 'American Indian - Census Tract Pct High School Only by Race'
  amiscl   = 'American Indian - Census Tract Pct Some College by Race'
  amicol   = 'American Indian - Census Tract Pct College Education at least 4 years by Race'
  asinon   = 'Asian - Census Tract Pct Non High School Grads by Race'
  asihso   = 'Asian - Census Tract Pct High School Only by Race'
  asiscl   = 'Asian - Census Tract Pct Some College by Race'
  asicol   = 'Asian - Census Tract Pct College Education at least 4 years by Race'
  othnon   = 'Other - Census Tract Pct Non High School Grads by Race'
  othhso   = 'Other - Census Tract Pct High School Only by Race'
  othscl   = 'Other - Census Tract Pct Some College by Race'
  othcol   = 'Other - Census Tract Pct College Education at least 4 years by Race'
  hspnon   = 'Hispanic - Census Tract Pct Non High School Grads by Race'
  hsphso   = 'Hispanic - Census Tract Pct High School Only by Race'
  hspscl   = 'Hispanic - Census Tract Pct Some College by Race'
  hspcol   = 'Hispanic - Census Tract Pct College Education at least 4 years by Race'
  natnon   = 'Native Hawaiian - Census Tract Pct Non High School Grads by Race'
  nathso   = 'Native Hawaiian - Census Tract Pct High School Only by Race'
  natscl   = 'Native Hawaiian - Census Tract Pct Some College by Race'
  natcol   = 'Native Hawaiian - Census Tract Pct College Education at least 4 years by Race'
  pov_tot      = 'Percent of residents living below poverty'
  pov_totlt65  = 'Percent of residents living below poverty less than 65'
  pov_tot6574  = 'Percent of residents living below poverty age 65-74'
  pov_tot75    = 'Percent of residents living below poverty age 75+'
  pov_wht      = 'White - Percent of residents living below poverty'
  pov_blk      = 'Black - Percent of residents living below poverty'
  pov_ami      = 'American Indian - Percent of residents living below poverty'
  pov_asi      = 'Asian - Percent of residents living below poverty'
  pov_nat      = 'Native Hawaiian - Percent of residents living below poverty'
  pov_oth      = 'Other - Percent of residents living below poverty'
  pov_hsp      = 'Hispanic - Percent of residents living below poverty'
  pov_whtlt65  = 'White - Percent of residents living below poverty less than 65'
  pov_wht6574  = 'White - Percent of residents living below poverty age 65-74'
  pov_wht75    = 'White - Percent of residents living below poverty age 75+'
  pov_blklt65  = 'Black - Percent of residents living below poverty less than 65'
  pov_blk6574  = 'Black - Percent of residents living below poverty age 65-74'
  pov_blk75    = 'Black - Percent of residents living below poverty age 75+'
  pov_amilt65  = 'American Indian - Percent of residents living below poverty less than 65'
  pov_ami6574  = 'American Indian - Percent of residents living below poverty age 65-74'
  pov_ami75    = 'American Indian - Percent of residents living below poverty age 75+'
  pov_asilt65  = 'Asian - Percent of residents living below poverty less than 65'
  pov_asi6574  = 'Asian - Percent of residents living below poverty age 65-74'
  pov_asi75    = 'Asian - Percent of residents living below poverty age 75+'
  pov_natlt65  = 'Native Hawaiian - Percent of residents living below poverty less than 65'
  pov_nat6574  = 'Native Hawaiian - Percent of residents living below poverty age 65-74'
  pov_nat75    = 'Native Hawaiian - Percent of residents living below poverty age 75+'
  pov_othlt65  = 'Other - Percent of residents living below poverty less than 65'
  pov_oth6574  = 'Other - Percent of residents living below poverty age 65-74'
  pov_oth75    = 'Other - Percent of residents living below poverty age 75+'
  pov_hsplt65  = 'Hispanic - Percent of residents living below poverty less than 65'
  pov_hsp6574  = 'Hispanic - Percent of residents living below poverty age 65-74'
  pov_hsp75    = 'Hispanic - Percent of residents living below poverty age 75+'
  s_state      = 'State Code (Census coding)'
  s_county     = 'County Code (Census coding)'
  ;

run;

proc contents data=seer.tract position;
run;
 


/* Zipcode File */


filename zipcen 'S:\JamieHeyward\SEERMed_IRAE\SEER Medicare irAE 2013-2019\zipcode.encr.census.file.dt030222.txt';                /*reading in an un-zipped file*/
*filename zipcen pipe 'gunzip -c /directory/zipcode.census.encrypted.txt.gz';   /*reading in a zipped file*/

options nocenter validvarname=upcase;

data seer.zipcen;
  infile zipcen lrecl=456 missover pad;
  input @001 filetype      $char2.
        @003 f_state       $char2.
        @005 zip5          $char5.
        @010 zppci         10.
        @020 zpmed         10.
        @030 zpden         10.
        @040 zpwht         6.2
        @046 zpblk         6.2
        @052 zphsp         6.2
        @058 zpen5         6.2
        @064 zpen6         6.2
        @070 zpnon         6.2
        @076 zphso         6.2
        @082 zpscl         6.2
        @088 zpcol         6.2
        @094 whtnon        6.2
        @100 whthso        6.2
        @106 whtscl        6.2
        @112 whtcol        6.2
        @118 blknon        6.2
        @124 blkhso        6.2
        @130 blkscl        6.2
        @136 blkcol        6.2
        @142 aminon        6.2
        @148 amihso        6.2
        @154 amiscl        6.2
        @160 amicol        6.2
        @166 asinon        6.2
        @172 asihso        6.2
        @178 asiscl        6.2
        @184 asicol        6.2
        @190 othnon        6.2
        @196 othhso        6.2
        @202 othscl        6.2
        @208 othcol        6.2
        @214 hspnon        6.2
        @220 hsphso        6.2
        @226 hspscl        6.2
        @232 hspcol        6.2
        @238 natnon        6.2
        @244 nathso        6.2
        @250 natscl        6.2
        @256 natcol        6.2
        @262 pov_tot       6.2
        @268 pov_totlt65   6.2
        @274 pov_tot6574   6.2
        @280 pov_tot75     6.2
        @286 pov_wht       6.2
        @292 pov_blk       6.2
        @298 pov_ami       6.2
        @304 pov_asi       6.2
        @310 pov_nat       6.2
        @316 pov_oth       6.2
        @322 pov_hsp       6.2
        @328 pov_whtlt65   6.2
        @334 pov_wht6574   6.2
        @340 pov_wht75     6.2
        @346 pov_blklt65   6.2
        @352 pov_blk6574   6.2
        @358 pov_blk75     6.2
        @364 pov_amilt65   6.2
        @370 pov_ami6574   6.2
        @376 pov_ami75     6.2
        @382 pov_asilt65   6.2
        @388 pov_asi6574   6.2
        @394 pov_asi75     6.2
        @400 pov_natlt65   6.2
        @406 pov_nat6574   6.2
        @412 pov_nat75     6.2
        @418 pov_othlt65   6.2
        @424 pov_oth6574   6.2
        @430 pov_oth75     6.2
        @436 pov_hsplt65   6.2
        @442 pov_hsp6574   6.2
        @448 pov_hsp75     6.2
        @454 s_state       $char2.
        ;
      ;

label
  filetype = 'File Type Source'
  f_state  = 'State Code (FIPS coding)'
  zip5     = '5 Digit Zip Code'
  zppci    = 'Zip Code PCI'
  zpmed    = 'Zip Code Median Income'
  zpden    = 'Zip Code Density'
  zpwht    = 'Zip Code Pct Whites'
  zpblk    = 'Zip Code Pct Blacks'
  zphsp    = 'Zip Code Pct Hispanics'
  zpen5    = 'Zip Code Pct of HHs who do not speak English well or at all 5+'
  zpen6    = 'Zip Code Pct of HHs who do not speak English well or at all 65+'
  zpnon    = 'Zip Code Pct Non High School Grads'
  zphso    = 'Zip Code Pct High School Only'
  zpscl    = 'Zip Code Pct Some College Education'
  zpcol    = 'Zip Code Pct College Education at least 4 years'
  whtnon   = 'Whites - Zip Code Pct Non High School Grads by Race'
  whthso   = 'Whites - Zip Code Pct High School Only by Race'
  whtscl   = 'Whites - Zip Code Pct Some College by Race'
  whtcol   = 'Whites - Zip Code Pct College Education at least 4 years by Race'
  blknon   = 'Blacks - Zip Code Pct Non High School Grads by Race'
  blkhso   = 'Blacks - Zip Code Pct High School Only by Race'
  blkscl   = 'Blacks - Zip Code Pct Some College by Race'
  blkcol   = 'Blacks - Zip Code Pct College Education at least 4 years by Race'
  aminon   = 'American Indian - Zip Code Pct Non High School Grads by Race'
  amihso   = 'American Indian - Zip Code Pct High School Only by Race'
  amiscl   = 'American Indian - Zip Code Pct Some College by Race'
  amicol   = 'American Indian - Zip Code Pct College Education at least 4 years by Race'
  asinon   = 'Asian - Zip Code Pct Non High School Grads by Race'
  asihso   = 'Asian - Zip Code Pct High School Only by Race'
  asiscl   = 'Asian - Zip Code Pct Some College by Race'
  asicol   = 'Asian - Zip Code Pct College Education at least 4 years by Race'
  othnon   = 'Other - Zip Code Pct Non High School Grads by Race'
  othhso   = 'Other - Zip Code Pct High School Only by Race'
  othscl   = 'Other - Zip Code Pct Some College by Race'
  othcol   = 'Other - Zip Code Pct College Education at least 4 years by Race'
  hspnon   = 'Hispanic - Zip Code Pct Non High School Grads by Race'
  hsphso   = 'Hispanic - Zip Code Pct High School Only by Race'
  hspscl   = 'Hispanic - Zip Code Pct Some College by Race'
  hspcol   = 'Hispanic - Zip Code Pct College Education at least 4 years by Race'
  natnon   = 'Native Hawaiian - Zip Code Pct Non High School Grads by Race'
  nathso   = 'Native Hawaiian - Zip Code Pct High School Only by Race'
  natscl   = 'Native Hawaiian - Zip Code Pct Some College by Race'
  natcol   = 'Native Hawaiian - Zip Code Pct College Education at least 4 years by Race'
  pov_tot      = 'Percent of residents living below poverty'
  pov_totlt65  = 'Percent of residents living below poverty less than 65'
  pov_tot6574  = 'Percent of residents living below poverty age 65-74'
  pov_tot75    = 'Percent of residents living below poverty age 75+'
  pov_wht      = 'White - Percent of residents living below poverty'
  pov_blk      = 'Black - Percent of residents living below poverty'
  pov_ami      = 'American Indian - Percent of residents living below poverty'
  pov_asi      = 'Asian - Percent of residents living below poverty'
  pov_nat      = 'Native Hawaiian - Percent of residents living below poverty'
  pov_oth      = 'Other - Percent of residents living below poverty'
  pov_hsp      = 'Hispanic - Percent of residents living below poverty'
  pov_whtlt65  = 'White - Percent of residents living below poverty less than 65'
  pov_wht6574  = 'White - Percent of residents living below poverty age 65-74'
  pov_wht75    = 'White - Percent of residents living below poverty age 75+'
  pov_blklt65  = 'Black - Percent of residents living below poverty less than 65'
  pov_blk6574  = 'Black - Percent of residents living below poverty age 65-74'
  pov_blk75    = 'Black - Percent of residents living below poverty age 75+'
  pov_amilt65  = 'American Indian - Percent of residents living below poverty less than 65'
  pov_ami6574  = 'American Indian - Percent of residents living below poverty age 65-74'
  pov_ami75    = 'American Indian - Percent of residents living below poverty age 75+'
  pov_asilt65  = 'Asian - Percent of residents living below poverty less than 65'
  pov_asi6574  = 'Asian - Percent of residents living below poverty age 65-74'
  pov_asi75    = 'Asian - Percent of residents living below poverty age 75+'
  pov_natlt65  = 'Native Hawaiian - Percent of residents living below poverty less than 65'
  pov_nat6574  = 'Native Hawaiian - Percent of residents living below poverty age 65-74'
  pov_nat75    = 'Native Hawaiian - Percent of residents living below poverty age 75+'
  pov_othlt65  = 'Other - Percent of residents living below poverty less than 65'
  pov_oth6574  = 'Other - Percent of residents living below poverty age 65-74'
  pov_oth75    = 'Other - Percent of residents living below poverty age 75+'
  pov_hsplt65  = 'Hispanic - Percent of residents living below poverty less than 65'
  pov_hsp6574  = 'Hispanic - Percent of residents living below poverty age 65-74'
  pov_hsp75    = 'Hispanic - Percent of residents living below poverty age 75+'
  s_state  = 'State Code (Census coding)'
  ;

run;

proc contents data=seer.zipcen position;
run;




/* Updated Lung Cancer Patient file (sent by SEER Jan 2024) */ 

/* Importing this to compare patient records to original lung cancer patient file */ 


/* Lung cancer alone */ 


filename SEER_l 'S:\JamieHeyward\Dissertation Aim 2 SEER Medicare Cohort Study\SEERMed_IRAE\SEER Medicare irAE 2013-2019\updated.SEER.lung.cancer.txt';                   /* reading in an un-zipped file */
*filename SEER_in pipe 'gunzip -c /directory/SEER.cancer.txt.gz'; /* reading in a zipped file */

options nocenter validvarname=upcase;

data seer.SEER_lung_update;
  infile SEER_l lrecl=771 missover pad;
  input
      @001 patient_id                        $char15. /* Patient ID (for either Cancer or Non-Cancer Patients) */
      @016 SEER_registry                     $char2. /*Registry*/
      @018 SEERregistrywithCAandGAaswholes   $char2. /*Registry with CA and GA as whole states*/
      @020 Louisiana20051stvs2ndhalfofyear   $char1. /*Louisiana 2005 1st vs 2nd half of the year*/
      @021 Marital_status_at_diagnosis       $char1. /*Marital Status               (Not available for NY, MA, ID and TX)*/
      @022 Race_ethnicity                    $char2. /*Race ethnicity*/
      @024 sex                               $char1. /*Sex*/
      @025 Agerecodewithsingleages_and_100   $char3. /*Age recode with single ages and 100+*/
      @028 agerecodewithsingle_ages_and_85   $char3. /*Age recode with single ages and 85+*/
      @031 Sequence_number                   $char2. /*Sequence Number*/
      @033 Month_of_diagnosis                $char2. /*Month of Diagnosis, Not month diagnosis recode*/
      @035 Year_of_diagnosis                 $char4. /*Year of Diagnosis*/
      @039 Coc_Accredited_Flag_2018          $char1. /*Coc Accredited Flag 2018+*/
      @040 Month_of_diagnosis_recode         $char2. /*Month of Diagnosis Recode*/
      @042 Primary_Site                      $char4. /*Primary Site*/
      @046 Laterality                        $char1. /*Laterality*/
      @047 Histology_ICD_O_2                 $char4. /*Histology ICD-0-2  (Not available for NY, MA, ID and TX)*/
      @051 Behavior_code_ICD_O_2             $char1. /*Behavior ICD-0-2   (Not available for NY, MA, ID and TX)*/
      @052 Histologic_Type_ICD_O_3           $char4. /*Histologic type ICD-0-3*/
      @056 Behavior_code_ICD_O_3             $char1. /*Behavior code ICD-0-3*/
      @067 Grade_thru_2017                   $char1. /*Grade thru 2017*/
      @068 Schema_ID_2018                    $char5. /*Schema ID (2018+)*/
      @073 Grade_Clinical_2018               $char1. /*Grade Clinical (2018+)*/
      @074 Grade_Pathological_2018           $char1. /*Grade Pathological (2018+)*/
      @075 Diagnostic_Confirmation           $char1. /*Diagnostic Confirmation*/
      @076 Type_of_Reporting_Source          $char1. /*Type of Reporting Source*/
      @077 EOD_10_size_1988_2003             $char3. /*EOD 10 - SIZE (1998-2003)     (Not available for NY, MA, ID and TX)*/
      @080 EOD_10_extent_1988_2003           $char2. /*EOD 10 - EXTENT (1998-2003)   (Not available for NY, MA, ID and TX)*/
      @082 EOD10Prostatepath_ext_1995_2003   $char2. /*EOD 10 - Prostate path ext (1995-2003)    (Not available for NY, MA, ID and TX)*/
      @084 EOD_10_nodes_1988_2003            $char1. /*EOD 10 - Nodes (1995-2003)                (Not available for NY, MA, ID and TX)*/
      @085 Regional_nodes_positive_1988      $char2. /*EOD 10 - Regional Nodes positive (1988+)  (limited to diagnosis years 2000-2003 for NY, MA, ID and TX)*/
      @087 Regional_nodes_examined_1988      $char2. /*EOD 10 - Regional Nodes examined (1988+)  (Not available for NY, MA, ID and TX)*/
      @089 Expanded_EOD_1_CP53_1973_1982     $char1. /*EOD - expanded 1-13                       (Not available for NY, MA, ID and TX)*/
      @090 Expanded_EOD_2_CP54_1973_1982     $char1.
      @091 Expanded_EOD_3_CP55_1973_1982     $char1.
      @092 Expanded_EOD_4_CP56_1973_1982     $char1.
      @093 Expanded_EOD_5_CP57_1973_1982     $char1.
      @094 Expanded_EOD_6_CP58_1973_1982     $char1.
      @095 Expanded_EOD_7_CP59_1973_1982     $char1.
      @096 Expanded_EOD_8_CP60_1973_1982     $char1.
      @097 Expanded_EOD_9_CP61_1973_1982     $char1.
      @098 Expanded_EOD_10_CP62_1973_1982    $char1.
      @099 Expanded_EOD_11_CP63_1973_1982    $char1.
      @100 Expanded_EOD_12_CP64_1973_1982    $char1.
      @101 Expanded_EOD_13_CP65_1973_1982    $char1.
      @106 EOD_4_size_1983_1987              $char2. /*EOD 4 - Size (1983-1987)       (Not available for NY, MA, ID and TX)  */
      @108 EOD_4_extent_1983_1987            $char1. /*EOD 4 - Extent (1983-1987)     (Not available for NY, MA, ID and TX)  */
      @109 EOD_4_nodes_1983_1987             $char1. /*EOD 4 - Nodes (1983-1987)      (Not available for NY, MA, ID and TX)  */
      @110 Coding_system_EOD_1973_2003       $char1. /*EOD Coding System (1973-2003)  (Not available for NY, MA, ID and TX)  */
      @111 Tumor_marker_1_1990_2003          $char1. /*Tumor marker 1 (1990-2003)     (Not available for NY, MA, ID and TX)  */
      @112 Tumor_marker_2_1990_2003          $char1. /*Tumor marker 2 (1990-2003)     (Not available for NY, MA, ID and TX)  */
      @113 Tumor_marker_3_1998_2003          $char1. /*Tumor marker 3 (1998-2003      (Not available for NY, MA, ID and TX)  */
      @114 CS_tumor_size_2004_2015           $char3. /*CS Tumor size (2004-2015)      (Not available for NY, MA, ID and TX)  */
      @117 CS_extension_2004_2015            $char3. /*CS extension (2004-2015)       (Not available for NY, MA, ID and TX)  */
      @120 CS_lymph_nodes_2004_2015          $char3. /*CS Lymph nodes (2004-2015)     (Not available for NY, MA, ID and TX)  */
      @123 CS_mets_at_dx_2004_2015           $char2. /*CS Mets at dx (2004-2015)      (Not available for NY, MA, ID and TX)  */
      @125 CSsitespecificfactor120042017va   $char3. /*CS Site-specific factor 1(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @128 CSsitespecificfactor220042017va   $char3. /*CS Site-specific factor 2(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @131 CSsitespecificfactor320042017va   $char3. /*CS Site-specific factor 3(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @134 CSsitespecificfactor420042017va   $char3. /*CS Site-specific factor 4(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @137 CSsitespecificfactor520042017va   $char3. /*CS Site-specific factor 5(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @140 CSsitespecificfactor620042017va   $char3. /*CS Site-specific factor 6(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @143 CSsitespecificfactor720042017va   $char3. /*CS Site-specific factor 7(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @146 CSsitespecificfactor820042017va   $char3. /*CS Site-specific factor 8(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @149 CSsitespecificfactor920042017va   $char3. /*CS Site-specific factor 9(2004-2017 varying by schema)   (Not available for NY, MA, ID and TX)*/
      @152 CSsitespecificfactor1020042017v   $char3. /*CS Site-specific factor 10(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @155 CSsitespecificfactor1120042017v   $char3. /*CS Site-specific factor 11(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @158 CSsitespecificfactor1220042017v   $char3. /*CS Site-specific factor 12(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @161 CSsitespecificfactor1320042017v   $char3. /*CS Site-specific factor 13(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @164 CSsitespecificfactor1520042017v   $char3. /*CS Site-specific factor 15(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @167 CSsitespecificfactor1620042017v   $char3. /*CS Site-specific factor 16(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @170 CSsitespecificfactor2520042017v   $char3. /*CS Site-specific factor 25(2004-2017 varying by schema)  (Not available for NY, MA, ID and TX)*/
      @173 Derived_AJCC_T_6th_ed_2004_2015   $char2. /*Derived AJCC T 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @175 Derived_AJCC_N_6th_ed_2004_2015   $char2. /*Derived AJCC N 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @177 Derived_AJCC_M_6th_ed_2004_2015   $char2. /*Derived AJCC M 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @179 DerivedAJCCStageGroup6thed20042   $char2. /*Derived AJCC STAGE Group 6th ed (2004-2015) (Not available for NY, MA, ID and TX)*/
      @181 SEERcombinedSummaryStage2000200   $char1. /*SEER Combined Summary Stage 2000 (2004-2017) */
      @182 Combined_Summary_Stage_2004       $char1. /*Combined Summary Stage 2000 (2004+) */
      @183 CSversioninputoriginal2004_2015   $char6. /*CS Version Input (2004-2015)	       (Not available for NY, MA, ID and TX)*/
      @189 CS_version_derived_2004_2015      $char6. /*CS Version Derived (2004-2015)      (Not available for NY, MA, ID and TX)*/
      @195 CSversioninputcurrent_2004_2015   $char6. /*CS Version Current (2004-2015)      (Not available for NY, MA, ID and TX)*/
      @201 RX_Summ_Surg_Prim_Site_1998       $char2. /*RX Summ-Surg Prim site 1998+        (Not available for NY, MA, ID and TX)*/
      @203 RX_Summ_Scope_Reg_LN_Sur_2003     $char1. /*RX Summ-Scope Reg LN Sur (2003+)    (Not available for NY, MA, ID and TX)*/
      @204 RX_Summ_Surg_Oth_Reg_Dis_2003     $char1. /*RX Summ-Surg Oth reg/dis (2003+)    (Not available for NY, MA, ID and TX)*/
      @205 RXSummReg_LN_Examined_1998_2002   $char2. /*RX Summ-Reg LN examined (1998-2002) (Not available for NY, MA, ID and TX)*/
      @207 RX_Summ_Systemic_Surg_Seq         $char1. /*RX Summ--Systemic Surg Seq          (Not available for NY, MA, ID and TX)*/
      @208 RX_Summ_Surg_Rad_Seq              $char1. /*Radiation Sequence with Surgery     (Not available for NY, MA, ID and TX)*/
      @209 Reasonnocancer_directed_surgery   $char1. /*Reason No Cancer-Directed Surgery   (Not available for NY, MA, ID and TX)*/
      @210 Radiation_recode                  $char1. /*Radiation Recode (0 and 9 combined) - created         (Not available for NY, MA, ID and TX)*/
      @211 Chemotherapy_recode_yes_no_unk    $char1. /*CHEMOTHERAPY Recode, yes(1)/no/unknown(0) - created   (Not available for NY, MA, ID and TX)*/
      @212 Sitespecificsurgery19731997vary   $char2. /*Site Specific Surgery (1973-1997)         (Not available for NY, MA, ID and TX)*/
      @214 Scopeofreglymphndsurg_1998_2002   $char1. /*Scope of Reg Lymph ND Surg (1998-2002)    (Not available for NY, MA, ID and TX)*/
      @215 Surgeryofothregdissites19982002   $char1. /*Surgery of Oth Reg/Dis sites (1998-2002)  (Not available for NY, MA, ID and TX)*/
      @216 Record_number_recode              $char2. /*Record Number Recode             */
      @218 Age_recode_with_1_year_olds       $char2. /*Age Recode with <1 Year Olds     */
      @220 Site_recode_ICD_O_3_WHO_2008      $char5. /*Site Recode ICD-O-3/WHO 2008)    */
      @230 Site_recode_rare_tumors           $char5. /*Site Recode - rare tumor*/
      @240 Behavior_recode_for_analysis      $char1. /*Behavior Recode for Analysis*/
      @241 Histologyrecode_broad_groupings   $char2. /*Histology Recode - Broad Groupings*/
      @243 Histologyrecode_Brain_groupings   $char2. /*Histology Recode - Brain Groupings*/
      @245 ICCCsiterecodeextended3rdeditio   $char3. /*ICCC Site Recode Extended 3rd Edition/IARC 2017*/
      @248 TNM_7_CS_v0204_Schema_thru_2017   $char3. /*TNM 7/CS v0204+ Schema (thru 2017)  (Not available for NY, MA, ID and TX)*/
      @251 TNM_7_CS_v0204_Schema_recode      $char3. /*TNM 7/CS v0204+ Schema Recode       (Not available for NY, MA, ID and TX)*/
      @254 Race_recode_White_Black_Other     $char1. /*Race Recode (White, Black, Other)*/
      @255 Race_recode_W_B_AI_API            $char1. /*Race Recode (W, B, AI, API)*/
      @256 OriginrecodeNHIAHispanicNonHisp   $char1. /*Origin Recode NHIA (Hispanic, Non-Hispanic)*/
      @257 RaceandoriginrecodeNHWNHBNHAIAN   $char1. /*Race and origin recode (NHW, NHB, NHAIAN, NHAPI, Hispanic)*/
      @258 SEER_historic_stage_A_1973_2015   $char1. /*SEER Historic Stage A (1973-2015)     (Not available for NY, MA, ID and TX)*/
      @259 AJCCstage_3rd_edition_1988_2003   $char2. /*AJCC Stage 3rd Edition (1988-2003)    (Not available for NY, MA, ID and TX)*/
      @261 SEERmodifiedAJCCstage3rd1988200   $char2. /*SEER Modified AJCC Stage 3rd Edition (1988-2003)   (Not available for NY, MA, ID and TX)*/
      @263 Firstmalignantprimary_indicator   $char1. /*First Malignant Primary Indicator*/
      @264 state                             $char2. /*FIPS State*/
      @266 county                            $char3. /*FIPS County*/
      @274 Medianhouseholdincomeinflationa   $char2. /*Median Household Income Inflation adj to 2019*/
      @276 Rural_Urban_Continuum_Code        $char2. /*Rural-Urban Continuum Code*/
      @278 PRCDA_2017	                     $char1. /*PRCDA - 2017*/
      @279 PRCDA_Region	                     $char1. /*PRCDA - Region*/
      @280 COD_to_site_recode                $char5. /*COD to Site Recode        (Not available for NY, MA, ID and TX)*/
      @285 COD_to_site_rec_KM                $char5. /*COD to Site Recode KM     (Not available for NY, MA, ID and TX)*/
      @290 Vitalstatusrecodestudycutoffuse   $char1. /*Vital Status Recode (Study Cutoff Used) (Not available for NY, MA, ID and TX)*/
      @291 IHS_Link                          $char1. /*IHS LINK*/
      @292 Summary_stage_2000_1998_2017      $char1. /*Summary Stage 2000 (1998-2017) (Not available for NY, MA, ID and TX)*/
      @293 AYA_site_recode_WHO_2008          $char2. /*AYA Site Recode/WHO 2008*/
      @295 AYA_site_recode_2020_Revision     $char3. /*AYA Site Recode 2020 Revision*/
      @298 Lymphoidneoplasmrecode2021Revis   $char2. /*Lymphoid neoplasm recode 2021 Revision*/
      @302 LymphomasubtyperecodeWHO2008thr   $char2. /*Lymphoma Subtype Recode/WHO 2008 (thru 2017)*/
      @304 SEER_Brain_and_CNS_Recode         $char2. /*SEER Brain and CNS Recode*/
      @306 ICCCsiterecode3rdeditionIARC201   $char3. /*ICCC Site Recode 3rd Edition/IARC 2017*/
      @309 SEERcausespecificdeathclassific   $char1. /*SEER Cause-Specific Death Classification (Not available for NY, MA, ID and TX)*/
      @310 SEERothercauseofdeathclassifica   $char1. /*SEER Other Cause of Death Classification (Not available for NY, MA, ID and TX)*/
      @311 CSTumor_Size_Ext_Eval_2004_2015   $char1. /*CS Tumor Size/Ext Eval (2004-2015)  (Not available for NY, MA, ID and TX)*/
      @312 CS_Reg_Node_Eval_2004_2015        $char1. /*CS Reg Node Eval (2004-2015)        (Not available for NY, MA, ID and TX)*/
      @313 CS_Mets_Eval_2004_2015            $char1. /*CS Mets Eval (2004-2015)            (Not available for NY, MA, ID and TX)*/
      @314 Primary_by_international_rules    $char1. /*Primary by International Rules*/
      @315 ERStatusRecodeBreastCancer_1990   $char1. /*ER Status Recode Breast Cancer (1990+) (Not available for NY, MA, ID and TX)*/
      @316 PRStatusRecodeBreastCancer_1990   $char1. /*PR Status Recode Breast Cancer (1990+) (Not available for NY, MA, ID and TX)*/
      @317 CS_Schema_AJCC_6th_Edition        $char2. /*CS Schema--AJCC 6th Edition            (Not available for NY, MA, ID and TX)*/
      @319 LymphvascularInvasion2004varyin   $char1. /*Lymph Vascular Invasion (2004+ Varying by Schema) (Not available for NY, MA, ID and TX)*/
      @320 Survival_months                   $char4. /*Survival Months                    (Not available for NY, MA, ID and TX)*/
      @324 Survival_months_flag              $char1. /*Survival Months Flag               (Not available for NY, MA, ID and TX)*/
      @325 Derived_AJCC_T_7th_ed_2010_2015   $char3. /*Derived AJCC T, 7th Ed 2010-2015)  (Not available for NY, MA, ID and TX)*/
      @328 Derived_AJCC_N_7th_ed_2010_2015   $char3. /*Derived AJCC N, 7th Ed 2010-2015)  (Not available for NY, MA, ID and TX)*/
      @331 Derived_AJCC_M_7th_ed_2010_2015   $char3. /*Derived AJCC M, 7th Ed 2010-2015)  (Not available for NY, MA, ID and TX)*/
      @334 DerivedAJCCStageGroup7thed20102   $char3. /*Derived AJCC Stage Group, 7th Ed 2010-2015) (Not available for NY, MA, ID and TX)*/
      @337 BreastAdjustedAJCC6thT1988_2015   $char2. /*Breast--Adjusted AJCC 6th T (1988-2015)  (Not available for NY, MA, ID and TX)*/
      @339 BreastAdjustedAJCC6thN1988_2015   $char2. /*Breast--Adjusted AJCC 6th N (1988-2015)  (Not available for NY, MA, ID and TX)*/
      @341 BreastAdjustedAJCC6thM1988_2015   $char2. /*Breast--Adjusted AJCC 6th M (1988-2015)  (Not available for NY, MA, ID and TX)*/
      @343 BreastAdjustedAJCC6thStage19882   $char2. /*Breast--Adjusted AJCC 6th Stage (1988-2015) (Not available for NY, MA, ID and TX)*/
      @345 Derived_HER2_Recode_2010          $char1. /*Derived HER2 Recode (2010+)              (Not available for NY, MA, ID and TX)*/
      @346 Breast_Subtype_2010               $char1. /*Breast Subtype (2010+)*/
      @347 LymphomaAnnArborStage_1983_2015   $char1. /*Lymphomas: Ann Arbor Staging (1983-2015) (Not available for NY, MA, ID and TX)*/
      @348 SEERCombinedMetsat_DX_bone_2010   $char1. /*SEER Combined Mets at Dx-Bone (2010+)    (Not available for NY, MA, ID and TX)*/
      @349 SEERCombinedMetsatDX_brain_2010   $char1. /*SEER Combined Mets at Dx-Brain (2010+)   (Not available for NY, MA, ID and TX)*/
      @350 SEERCombinedMetsatDX_liver_2010   $char1. /*SEER Combined Mets at Dx-Liver (2010+)   (Not available for NY, MA, ID and TX)*/
      @351 SEERCombinedMetsat_DX_lung_2010   $char1. /*SEER Combined Mets at Dx-Lung (2010+)    (Not available for NY, MA, ID and TX)*/
      @352 TvaluebasedonAJCC_3rd_1988_2003   $char2. /*T Value - Based on AJCC 3rd (1988-2003)  (Not available for NY, MA, ID and TX)*/
      @354 NvaluebasedonAJCC_3rd_1988_2003   $char2. /*N Value - Based on AJCC 3rd (1988-2003)  (Not available for NY, MA, ID and TX)*/
      @356 MvaluebasedonAJCC_3rd_1988_2003   $char2. /*M Value - Based on AJCC 3rd (1988-2003)  (Not available for NY, MA, ID and TX)*/
      @358 Totalnumberofinsitumalignanttum   $char2. /*Total Number of In Situ/Malignant Tumors for Patient (Not available for NY, MA, ID and TX)*/
      @360 Totalnumberofbenignborderlinetu   $char2. /*Total Number of Benign/Borderline Tumors for Patient (Not available for NY, MA, ID and TX)*/
      @362 RadiationtoBrainorCNSRecode1988   $char1. /*Radiation to Brain or CNS Recode (1988-1997) (Not available for NY, MA, ID and TX)*/
      @363 Tumor_Size_Summary_2016	     $char3. /*Tumor Size Summary (2016+)              (Not available for NY, MA, ID and TX)*/
      @366 DerivedSEERCmbStg_Grp_2016_2017   $char5. /*Derived SEER Combined STG GRP (2016+)   (Not available for NY, MA, ID and TX)*/
      @371 DerivedSEERCombined_T_2016_2017   $char5. /*Derived SEER Combined T (2016+)         (Not available for NY, MA, ID and TX)*/
      @376 DerivedSEERCombined_N_2016_2017   $char5. /*Derived SEER Combined N (2016+)         (Not available for NY, MA, ID and TX)*/
      @381 DerivedSEERCombined_M_2016_2017   $char5. /*Derived SEER Combined M (2016+)         (Not available for NY, MA, ID and TX)*/
      @386 DerivedSEERCombinedTSrc20162017   $char1. /*Derived SEER Combined T SRC (2016+)     (Not available for NY, MA, ID and TX)*/
      @387 DerivedSEERCombinedNSrc20162017   $char1. /*Derived SEER Combined N SRC (2016+)     (Not available for NY, MA, ID and TX)*/
      @388 DerivedSEERCombinedMSrc20162017   $char1. /*Derived SEER Combined M SRC (2016+)     (Not available for NY, MA, ID and TX)*/
      @389 TNM_Edition_Number_2016_2017	     $char2. /*TNM Edition Number (2016-2017)          (Not available for NY, MA, ID and TX)*/
      @391 Mets_at_DX_Distant_LN_2016	     $char1. /*Mets at Dx-Distant LN (2016+)           (Not available for NY, MA, ID and TX)*/
      @392 Mets_at_DX_Other_2016	     $char1. /*Mets at DX--Other (2016+)               (Not available for NY, MA, ID and TX)*/
      @393 AJCC_ID_2018                      $char4. /*AJCC ID (2018+)*/
      @397 EOD_Schema_ID_Recode_2010         $char3. /*EOD Schema ID Recode (2010+)*/
      @400 Derived_EOD_2018_T_2018           $char15. /*Derived EOD 2018 T (2018+)             (Not available for NY, MA, ID and TX)*/
      @415 Derived_EOD_2018_N_2018           $char15. /*Derived EOD 2018 N (2018+)             (Not available for NY, MA, ID and TX)*/
      @430 Derived_EOD_2018_M_2018           $char15. /*Derived EOD 2018 M (2018+)             (Not available for NY, MA, ID and TX)*/
      @445 DerivedEOD2018_Stage_Group_2018   $char15. /*Derived EOD 2018 Stage Group (2018+)   (Not available for NY, MA, ID and TX)*/
      @460 EOD_Primary_Tumor_2018            $char3.  /*EOD Primary Tumor (2018+)              (Not available for NY, MA, ID and TX)*/
      @463 EOD_Regional_Nodes_2018           $char3.  /*EOD Regional Nodes (2018+)             (Not available for NY, MA, ID and TX)*/
      @466 EOD_Mets_2018                     $char2.  /*EOD Mets (2018+)                       (Not available for NY, MA, ID and TX)*/
      @468 Monthsfromdiagnosisto_treatment   $char3.  /*Months from diagnosis to treatment     (Not available for NY, MA, ID and TX)*/

   /*Not Public but released*/
      @471 Census_Tract_1990                 $char6. /*Census Track 1990, encrypted*/
      @477 Census_Tract_2000                 $char6. /*Census Track 2000, encrypted*/
      @483 Census_Tract_2010                 $char6. /*Census Track 2010, encrypted*/
      @489 Census_Coding_System	             $char1. /*Coding System for Census Track 1970/80/90*/
      @490 Census_Tract_Certainty_1990	     $char1. /*Census Tract Certainty 1970/1980/1990*/
      @491 Census_Tract_Certainty_2000	     $char1. /*Census Tract Certainty 2000*/
      @492 Census_Tract_Certainty_2010	     $char1. /*Census Tract Certainty 2010*/
      @493 Rural_Urban_Continuum_Code_1993   $char2. /*Rural-Urban Continuum Code 1993 - From SEER*Stat*/
      @495 Rural_Urban_Continuum_Code_2003   $char2. /*Rural-Urban Continuum Code 2003 - From SEER*Stat*/
      @497 Rural_Urban_Continuum_Code_2013   $char2. /*Rural-Urban Continuum Code 2013 - From SEER*Stat*/
      @499 Health_Service_Area               $char4. /*Health Service Area - From SEER*Stat*/
      @503 HealthService_Area_NCI_Modified   $char4. /*Health Service Area NCI Modified - From SEER*Stat*/
      @507 County_at_DX_Geocode_1990         $char3. /*County at DX Geocode 1990*/
      @510 County_at_DX_Geocode_2000	     $char3. /*County at DX Geocode 2000*/
      @513 County_at_DX_Geocode_2010         $char3. /*County at DX Geocode 2010*/
      @516 Derived_SS1977_flag               $char1. /*Derived SS1977 - Flag (2004+)         (Not available for NY, MA, ID and TX)*/
      @517 Derived_SS2000_flag               $char1. /*Derived SS2000 - Flag (2004+)         (Not available for NY, MA, ID and TX)*/
      @518 Radiation                         $char1. /*Radiation                             (Not available for NY, MA, ID and TX)*/
      @519 RadiationtoBrainorCNS_1988_1997   $char1. /*Radiation to Brain or CNS (1988-1997) (Not available for NY, MA, ID and TX)*/
      @520 SEER_DateofDeath_Month            $char2. /*Death Month based on Stat_rec         (Not available for NY, MA, ID and TX)*/
      @522 SEER_DateofDeath_Year             $char4. /*Death Year based on Stat_rec          (Not available for NY, MA, ID and TX)*/
      @526 Month_of_last_follow_up_recode    $char2. /*Month of Follow-up Recode, study cutoff used (Not available for NY, MA, ID and TX)*/
      @528 Year_of_last_follow_up_recode     $char4. /*Year of Follow-up Recode, study cutoff used  (Not available for NY, MA, ID and TX)*/
      @533 Year_of_birth                     $char4. /*Year of Birth*/
      @537 Date_of_diagnosis_flag            $char2. /*Date of Diagnosis Flag*/
      @539 Date_therapy_started_flag         $char2. /*Date of Therapy Started Flag*/
      @541 Date_of_birth_flag                $char2. /*Date of Birth flag*/
      @543 Date_of_last_follow_up_flag       $char2. /*Date of Last Follow-up Flag*/
      @545 Month_therapy_started             $char2. /*Month Therapy Started*/
      @547 Year_therapy_started              $char4. /*Year Therapy Started*/
      @551 Other_cancer_directed_therapy     $char1. /*Other Cancer-Directed Therapy*/
      @552 Derived_AJCC_flag                 $char1. /*Derived AJCC - Flag (2004+)        (Not available for NY, MA, ID and TX)*/
      @553 Derived_SS1977                    $char1. /*Derived SS1977 (2004-2015)         (Not available for NY, MA, ID and TX)*/
      @554 Derived_SS2000                    $char1. /*Derived SS2000 (2004+)             (Not available for NY, MA, ID and TX)*/
      @555 SEER_Summary_stage_1977_9500	     $char1. /*SEER summary stage 1977(1995-2000) (Not available for NY, MA, ID and TX)*/
      @556 SEER_Summary_stage_2000_0103	     $char1. /*SEER summary stage 2000(2001-2003) (Not available for NY, MA, ID and TX)*/

      @558 Primary_Payer_at_DX               $char2. /*Primary Payer at DX                 (Not available for NY, MA, ID and TX)*/
      @569 Recode_ICD_0_2_to_9               $char4. /*Recode ICD-O-2 to 9                 (Not available for NY, MA, ID and TX)*/
      @573 Recode_ICD_0_2_to_10              $char4. /*Recode ICD-O-2 to 10                (Not available for NY, MA, ID and TX)*/
      @577 NHIA_Derived_Hisp_Origin          $char1. /*NHIA Dervied Hispanic Origin        (Not available for NY, MA, ID and TX)*/
      @578 Age_site_edit_override            $char1. /*Age-site edit override              (Not available for NY, MA, ID and TX)*/
      @579 Sequencenumber_dx_conf_override   $char1. /*Sequence number-dx conf override    (Not available for NY, MA, ID and TX)*/
      @580 Site_type_lat_seq_override        $char1. /*Site-type-lat-seq override          (Not available for NY, MA, ID and TX)*/
      @581 Surgerydiagnostic_conf_override   $char1. /*Surgery-diagnostic conf override    (Not available for NY, MA, ID and TX)*/
      @582 Site_type_edit_override           $char1. /*Site-type edit override             (Not available for NY, MA, ID and TX)*/
      @583 Histology_edit_override           $char1. /*Histology edit override             (Not available for NY, MA, ID and TX)*/
      @584 Report_source_sequence_override   $char1. /*Report source sequence override     (Not available for NY, MA, ID and TX)*/
      @585 Seq_ill_defined_site_override     $char1. /*Seq-ill-defined site override       (Not available for NY, MA, ID and TX)*/
      @586 LeukLymphdxconfirmationoverride   $char1. /*Leuk-Lymph dx confirmation override (Not available for NY, MA, ID and TX)*/
      @587 Site_behavior_override            $char1. /*Site-behavior override              (Not available for NY, MA, ID and TX)*/
      @588 Site_EOD_dx_date_override         $char1. /*Site-EOD-dx date override           (Not available for NY, MA, ID and TX)*/
      @589 Site_laterality_EOD_override      $char1. /*Site-laterality-EOD override        (Not available for NY, MA, ID and TX)*/
      @590 Site_laterality_morph_override    $char1. /*Site-laterality-morph override      (Not available for NY, MA, ID and TX)*/

      @591 SEER_Summary_Stage_2000newonly    $char1. /*Summary Stage 2000 (NAACCR Item-759)   Only available for NY, MA, ID and TX for dx years 2001-2003*/

      @592 Insurance_Recode_2007             1. /*Insurance Recode (2007+)                 (Not available for NY, MA, ID and TX)*/
      @593 Yost_ACS_2006_2010                5. /*Yost Index (ACS 2006-2010)*/
      @598 Yost_ACS_2010_2014                5. /*Yost Index (ACS 2010-2014)*/
      @603 Yost_ACS_2013_2017                5. /*Yost Index (ACS 2013-2017)*/
      @608 Yost_ACS_2006_2010_State_based    5. /*Yost Index (ACS 2006-2010) - State based*/
      @613 Yost_ACS_2010_2014_State_based    5. /*Yost Index (ACS 2010-2014) - State based*/
      @618 Yost_ACS_2013_2017_State_based    5. /*Yost Index (ACS 2013-2017) - State based*/
      @623 Yost_ACS_2006_2010_quintile       $char1. /*Yost Index Quintile (ACS 2006-2010)*/
      @624 Yost_ACS_2010_2014_quintile       $char1. /*Yost Index Quintile (ACS 2010-2014)*/
      @625 Yost_ACS_2013_2017_quintile       $char1. /*Yost Index Quintile (ACS 2013-2017)*/
      @626 YostACS20062010quintileStatebas   $char1. /*Yost Index Quintile (ACS 2006-2010) - State based*/
      @627 YostACS20102014quintileStatebas   $char1. /*Yost Index Quintile (ACS 2010-2014) - State based*/
      @628 YostACS20132017quintileStatebas   $char1. /*Yost Index Quintile (ACS 2013-2017) - State based*/
      @629 Brain_Molecular_Markers_2018	     $char3. /*Brain Molecular Markers (2018+)                    (Not available for NY, MA, ID and TX)*/
      @632 AFPPostOrchiectomyLabValueRecod   $char3. /*AFP Post-Orchiectomy Lab Value Recode (2010+)      (Not available for NY, MA, ID and TX)*/
      @635 AFPPretreatmentInterpretationRe   $char2. /*AFP Pretreatment Interpretation Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @637 B_Symptoms_Recode_2010	     $char2. /*B Symptoms Recode (2010+)                          (Not available for NY, MA, ID and TX)*/
      @639 Breslow_Thickness_Recode_2010     $char5. /*Breslow Thickness Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @644 CA125PretreatmentInterpretation   $char2. /*CA-125 Pretreatment Interpretation Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @646 CEAPretreatmentInterpretationRe   $char2. /*CEA Pretreatment Interpretation Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @648 Chromosome19qLossofHeterozygosi   $char2. /*Chromosome 19q: Loss of Heterozygosity (LOH) Recode (2010+) (Not available for NY, MA, ID and TX)*/
      @650 Chromosome1pLossofHeterozygosit   $char2. /*Chromosome 1p: Loss of Heterozygosity (LOH) Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @652 Fibrosis_Score_Recode_2010	     $char2. /*Fibrosis Score Recode (2010+)                           (Not available for NY, MA, ID and TX)*/
      @654 GestationalTrophoblasticPrognos   $char2. /*Gestational Trophoblastic Prognostic Scoring Index Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @656 GleasonPatternsClinicalRecode20   $char3. /*Gleason Patterns Clinical Recode (2010+)                (Not available for NY, MA, ID and TX)*/
      @659 GleasonPatternsPathologicalReco   $char3. /*Gleason Patterns Pathological Recode (2010+)            (Not available for NY, MA, ID and TX)*/
      @662 GleasonScoreClinicalRecode_2010   $char2. /*Gleason Score Clinical Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @664 GleasonScorePathologicalRecode2   $char2. /*Gleason Score Pathological Recode (2010+)               (Not available for NY, MA, ID and TX)*/
      @666 hCGPostOrchiectomyRangeRecode20   $char2. /*hCG Post-Orchiectomy Range Recode (2010+)               (Not available for NY, MA, ID and TX)*/
      @668 InvasionBeyondCapsuleRecode2010   $char2. /*Invasion Beyond Capsule Recode (2010+)                  (Not available for NY, MA, ID and TX)*/
      @670 IpsilateralAdrenalGlandInvolvem   $char2. /*Ipsilateral Adrenal Gland Involvement Recode (2010+)    (Not available for NY, MA, ID and TX)*/
      @672 LDHPostOrchiectomyRangeRecode20   $char2. /*LDH Post-Orchiectomy Range Recode (2010+)               (Not available for NY, MA, ID and TX)*/
      @674 LDHPretreatmentLevelRecode_2010   $char2. /*LDH Pretreatment Level Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @676 LNHeadandNeckLevelsIIIIRecode20   $char2. /*LN Head and Neck Levels I-III Recode (2010+)            (Not available for NY, MA, ID and TX)*/
      @678 LNHeadandNeckLevelsIVVRecode201   $char2. /*LN Head and Neck Levels IV-V Recode (2010+)             (Not available for NY, MA, ID and TX)*/
      @680 LNHeadandNeckLevelsVIVIIRecode2   $char2. /*LN Head and Neck Levels VI-VII Recode (2010+)           (Not available for NY, MA, ID and TX)*/
      @682 LNHeadandNeck_Other_Recode_2010   $char2. /*LN Head and Neck Other Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @684 LNPositiveAxillaryLevelIIIRecod   $char3. /*LN Positive Axillary Level I-II Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @687 Lymph_Node_Size_Recode_2010	     $char3. /*Lymph Node Size Recode (2010+)                          (Not available for NY, MA, ID and TX)*/
      @690 MajorVeinInvolvementRecode_2010   $char2. /*Major Vein Involvement Recode (2010+)                   (Not available for NY, MA, ID and TX)*/
      @692 MeasuredBasalDiameterRecode2010   $char5. /*Measured Basal Diameter Recode (2010+)                  (Not available for NY, MA, ID and TX)*/
      @697 Measured_Thickness_Recode_2010    $char5. /*Measured Thickness Recode (2010+)                       (Not available for NY, MA, ID and TX)*/
      @704 MitoticRateMelanoma_Recode_2010   $char3. /*Mitotic Rate Melanoma Recode (2010+)                    (Not available for NY, MA, ID and TX)*/
      @707 NumberofCoresPositiveRecode2010   $char3. /*Number of Cores Positive Recode (2010+)                 (Not available for NY, MA, ID and TX)*/
      @710 NumberofCoresExaminedRecode2010   $char3. /*Number of Cores Examined Recode (2010+)                 (Not available for NY, MA, ID and TX)*/
      @713 NumberofExaminedParaAorticNodes   $char3. /*Number of Examined Para-Aortic Nodes Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @716 NumberofExaminedPelvicNodesReco   $char3. /*Number of Examined Pelvic Nodes Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @719 NumberofPositiveParaAorticNodes   $char3. /*Number of Positive Para-Aortic Nodes Recode (2010+)     (Not available for NY, MA, ID and TX)*/
      @722 NumberofPositivePelvicNodesReco   $char3. /*Number of Positive Pelvic Nodes Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @725 Perineural_Invasion_Recode_2010   $char2. /*Perineural Invasion Recode (2010+)                      (Not available for NY, MA, ID and TX)*/
      @727 PeripheralBloodInvolvementRecod   $char2. /*Peripheral Blood Involvement Recode (2010+)             (Not available for NY, MA, ID and TX)*/
      @729 Peritoneal_Cytology_Recode_2010   $char2. /*Peritoneal Cytology Recode (2010+)                      (Not available for NY, MA, ID and TX)*/
      @731 Pleural_Effusion_Recode_2010	     $char2. /*Pleural Effusion Recode (2010+)                         (Not available for NY, MA, ID and TX)*/
      @733 PSA_Lab_Value_Recode_2010	     $char5. /*PSA Lab Value Recode (2010+)                            (Not available for NY, MA, ID and TX)*/
      @738 ResidualTumorVolumePostCytoredu   $char3. /*Residual Tumor Volume Post Cytoreduction Recode (2010+) (Not available for NY, MA, ID and TX)*/
      @741 ResponsetoNeoadjuvantTherapyRec   $char2. /*Response to Neoadjuvant Therapy Recode (2010+)          (Not available for NY, MA, ID and TX)*/
      @743 SarcomatoidFeatures_Recode_2010   $char2. /*Sarcomatoid Features Recode (2010+)                     (Not available for NY, MA, ID and TX)*/
      @745 SeparateTumorNodulesIpsilateral   $char2. /*Separate Tumor Nodules Ipsilateral Lung Recode (2010+)  (Not available for NY, MA, ID and TX)*/
      @747 Tumor_Deposits_Recode_2010	     $char3. /*Tumor Deposits Recode (2010+)                           (Not available for NY, MA, ID and TX)*/
      @750 Ulceration_Recode_2010	     $char2. /*Ulceration Recode (2010+)                               (Not available for NY, MA, ID and TX)*/
      @752 VisceralandParietalPleuralInvas   $char2. /*Visceral and Parietal Pleural Invasion Recode (2010+)   (Not available for NY, MA, ID and TX)*/
      @754 ENHANCED_FIVE_PERCENT_FLAG        $char1. /*Five Percent Flag from MBSF*/
      @755 Date_of_Death_Flag_created        $char1. /*Date of Death Flag (SEER vs Medicare)                   (Not available for NY, MA, ID and TX)*/
      @756 Date_of_Birth_Flag_created        $char1. /*Date of Birth Flag (SEER vs Medicare)*/

      @757 OncotypeDXBreastRecurrenceScore   3. /*Oncotype DX Breast Recurrence Score  -- Needs special permission  (Not available for MA and TX)*/
      @760 OncotypeDXRSgroupRS18RS1830RS30   1. /*Oncotype DX RS group (RS < 18, RS 18-30, RS > 30) -- Needs special permission  (Not available for MA and TX)*/
      @761 OncotypeDXreasonno_score_linked   1. /*Oncotype DX reason no score linked -- Needs special permission    (Not available for MA and TX)*/
      @762 Oncotype_DX_year_of_test_report   4. /*Oncotype DX year of test report -- Needs special permission       (Not available for MA and TX)*/
      @766 OncotypeDX_month_of_test_report   2. /*Oncotype DX month of test report -- Needs special permission      (Not available for MA and TX)*/
      @768 OncotypeDXmonthssince_diagnosis   3. /*Oncotype DX months since diagnosis -- Needs special permission    (Not available for MA and TX)*/
      ;


  label
     PATIENT_ID                        = "Patient ID"
     SEER_registry                     = "Registry"
     SEERregistrywithCAandGAaswholes   = "Registry with CA and GA as whole states"
     Louisiana20051stvs2ndhalfofyear   = "Louisiana 2005 1st vs 2nd half of the year"
     Marital_status_at_diagnosis       = "Marital Status"
     Race_ethnicity                    = "Race ethnicity"
     sex                               = "Sex"
     Agerecodewithsingleages_and_100   = "Age recode with single ages and 100+"
     agerecodewithsingle_ages_and_85   = "Age recode with single ages and 85+"
     Sequence_number                   = "Sequence Number"
     Month_of_diagnosis                = "Month of Diagnosis, Not month diagnosis recode"
     Year_of_diagnosis                 = "Year of Diagnosis"
     CoC_Accredited_Flag_2018          = "CoC Accredited Flag (2018+)"
     Month_of_diagnosis_recode         = "Month of Diagnosis Recode"
     Primary_Site                      = "Primary Site"
     Laterality                        = "Laterality"
     Histology_ICD_O_2                 = "Histology ICD-0-2"
     Behavior_code_ICD_O_2             = "Behavior ICD-0-2"
     Histologic_Type_ICD_O_3           = "Histologic type ICD-0-3"
     Behavior_code_ICD_O_3             = "Behavior code ICD-0-3"
     Grade_thru_2017                   = "Grade (thru 2017)"
     Schema_ID_2018                    = "Schema ID (2018+)"
     Grade_Clinical_2018               = "Grade Clinical (2018+)"
     Grade_Pathological_2018           = "Grade Pathological (2018+)"
     Diagnostic_Confirmation           = "Diagnostic Confirmation"
     Type_of_Reporting_Source          = "Type of Reporting Source"
     EOD_10_size_1988_2003             = "EOD 10 - SIZE (1998-2003)"
     EOD_10_extent_1988_2003           = "EOD 10 - EXTENT (1998-2003)"
     EOD10Prostatepath_ext_1995_2003   = "EOD 10 - Prostate path ext (1995-2003)"
     EOD_10_nodes_1988_2003            = "EOD 10 - Nodes (1995-2003)"
     Regional_nodes_positive_1988      = "EOD 10 - Regional Nodes positive (1988+)"
     Regional_nodes_examined_1988      = "EOD 10 - Regional Nodes examined (1988+)"
     Expanded_EOD_1_CP53_1973_1982     = "EOD - expanded 1st digit"
     Expanded_EOD_2_CP54_1973_1982     = "EOD - expanded 2nd digit"
     Expanded_EOD_3_CP55_1973_1982     = "EOD - expanded 3rd digit"
     Expanded_EOD_4_CP56_1973_1982     = "EOD - expanded 4th digit"
     Expanded_EOD_5_CP57_1973_1982     = "EOD - expanded 5th digit"
     Expanded_EOD_6_CP58_1973_1982     = "EOD - expanded 6th digit"
     Expanded_EOD_7_CP59_1973_1982     = "EOD - expanded 7th digit"
     Expanded_EOD_8_CP60_1973_1982     = "EOD - expanded 8th digit"
     Expanded_EOD_9_CP61_1973_1982     = "EOD - expanded 9th digit"
     Expanded_EOD_10_CP62_1973_1982    = "EOD - expanded 10th digit"
     Expanded_EOD_11_CP63_1973_1982    = "EOD - expanded 11th digit"
     Expanded_EOD_12_CP64_1973_1982    = "EOD - expanded 12th digit"
     Expanded_EOD_13_CP65_1973_1982    = "EOD - expanded 13th digit"
     EOD_4_size_1983_1987              = "EOD 4 - Size (1983-1987)         "
     EOD_4_extent_1983_1987            = "EOD 4 - Extent (1983-1987)       "
     EOD_4_nodes_1983_1987             = "EOD 4 - Nodes (1983-1987)        "
     Coding_system_EOD_1973_2003       = "EOD Coding System (1973-2003)    "
     Tumor_marker_1_1990_2003          = "Tumor marker 1 (1990-2003)       "
     Tumor_marker_2_1990_2003          = "Tumor marker 2 (1990-2003)       "
     Tumor_marker_3_1998_2003          = "Tumor marker 3 (1990-2003        "
     CS_tumor_size_2004_2015           = "CS Tumor size (2004-2015)        "
     CS_extension_2004_2015            = "CS extension (2004-2015)         "
     CS_lymph_nodes_2004_2015          = "CS Lymph nodes (2004-2015)       "
     CS_mets_at_dx_2004_2015           = "CS Mets at dx                    "
     CSsitespecificfactor120042017va   = "CS site-specific factor 1 (2004-2017 varying by schema)"
     CSsitespecificfactor220042017va   = "CS site-specific factor 2 (2004-2017 varying by schema)"
     CSsitespecificfactor320042017va   = "CS site-specific factor 3 (2004-2017 varying by schema)"
     CSsitespecificfactor420042017va   = "CS site-specific factor 4 (2004-2017 varying by schema)"
     CSsitespecificfactor520042017va   = "CS site-specific factor 5 (2004-2017 varying by schema)"
     CSsitespecificfactor620042017va   = "CS site-specific factor 6 (2004-2017 varying by schema)"
     CSsitespecificfactor720042017va   = "CS site-specific factor 7 (2004-2017 varying by schema)"
     CSsitespecificfactor820042017va   = "CS site-specific factor 8 (2004-2017 varying by schema)"
     CSsitespecificfactor920042017va   = "CS site-specific factor 9 (2004-2017 varying by schema)"
     CSsitespecificfactor1020042017v   = "CS site-specific factor 10 (2004-2017 varying by schema)"
     CSsitespecificfactor1120042017v   = "CS site-specific factor 11 (2004-2017 varying by schema)"
     CSsitespecificfactor1220042017v   = "CS site-specific factor 12 (2004-2017 varying by schema)"
     CSsitespecificfactor1320042017v   = "CS site-specific factor 13 (2004-2017 varying by schema)"
     CSsitespecificfactor1520042017v   = "CS site-specific factor 15 (2004-2017 varying by schema)"
     CSsitespecificfactor1620042017v   = "CS site-specific factor 16 (2004-2017 varying by schema)"
     CSsitespecificfactor2520042017v   = "CS site-specific factor 25 (2004-2017 varying by schema)"
     Derived_AJCC_T_6th_ed_2004_2015   = "Derived AJCC T 6th ed (2004-2015)"
     Derived_AJCC_N_6th_ed_2004_2015   = "Derived AJCC N 6th ed (2004-2015)"
     Derived_AJCC_M_6th_ed_2004_2015   = "Derived AJCC M 6th ed (2004-2015)"
     DerivedAJCCStageGroup6thed20042   = "Derived AJCC STAGE Group 6th ed (2004-2015)"
     SEERCombinedSummaryStage2000200   = "SEER Combined Summary Stage 2000 (2004+)"
     Combined_Summary_Stage_2004       = "Combined Summary Stage (2004+)"
     CSversioninputoriginal2004_2015   = "CS version input original (2004-2015)"
     CS_version_derived_2004_2015      = "CS version derived (2004-2015)"
     CSversioninputcurrent_2004_2015   = "CS version input current (2004-2015)"
     RX_Summ_Surg_Prim_Site_1998       = "RX Summ-Surg Prim site 1998+     "
     RX_Summ_Scope_Reg_LN_Sur_2003     = "RX Summ-Scope Reg LN Sur (2003+) "
     RX_Summ_Surg_Oth_Reg_Dis_2003     = "RX Summ-Surg Oth reg/dis (2003+) "
     RXSummReg_LN_Examined_1998_2002   = "RX Summ-Reg LN examined (1998-2002)"
     RX_Summ_Systemic_Surg_Seq         = "RX Summ--Systemic Surg Seq"
     RX_Summ_Surg_Rad_Seq              = "Radiation Sequence with Surgery"
     Reasonnocancer_directed_surgery   = "Reason No Cancer-Directed Surgery"
     Radiation_recode                  = "Radiation Recode (0 and 9 combined) - created"
     Chemotherapy_recode_yes_no_unk    = "CHEMOTHERAPY Recode, yes(1)/no/unknown(0) - created"
     Sitespecificsurgery19731997vary   = "Site Specific Surgery (1973-1997)"
     Scopeofreglymphndsurg_1998_2002   = "Scope of Reg Lymph ND Surg (1998-2002)"
     Surgeryofothregdissites19982002   = "Surgery of Oth Reg/Dis sites (1998-2002)"
     Record_number_recode              = "Record Number Recode             "
     Age_recode_with_1_year_olds       = "Age Recode with <1 Year Olds     "
     Site_recode_ICD_O_3_WHO_2008      = "Site Recode ICD-O-3/WHO 2008)    "
     Site_recode_rare_tumors           = "Site recode - rare tumors"
     Behavior_recode_for_analysis      = "Behavior Recode for Analysis"
     Histologyrecode_broad_groupings   = "Histology Recode - Broad Groupings"
     Histologyrecode_Brain_groupings   = "Histology Recode - Brain Groupings"
     ICCCsiterecodeextended3rdeditio   = "ICCC Site Recode Extended 3rd Edition/IARC 2017"
     TNM_7_CS_v0204_Schema_thru_2017   = "TNM 7/CS v0204+ Schema (thru 2017)"
     TNM_7_CS_v0204_Schema_recode      = "TNM 7/CS v0204+ Schema recode"
     Race_recode_White_Black_Other     = "Race Recode (White, Black, Other)"
     Race_recode_W_B_AI_API            = "Race Recode (W, B, AI, API)"
     OriginrecodeNHIAHispanicNonHisp   = "Origin Recode NHIA (Hispanic, Non-Hispanic)"
     RaceandoriginrecodeNHWNHBNHAIAN   = "Race and origin recode (NHW, NHB, NHAIAN, NHAPI, Hispanic)"
     SEER_historic_stage_A_1973_2015   = "SEER Historic Stage A (1973-2015)"
     AJCCstage_3rd_edition_1988_2003   = "AJCC Stage 3rd Edition (1988-2003)"
     SEERmodifiedAJCCstage3rd1988200   = "SEER Modified AJCC Stage 3rd Edition (1988-2003)"
     Firstmalignantprimary_indicator   = "First Malignant Primary Indicator"
     state                             = "FIPS State"
     county                            = "FIPS County"
     Medianhouseholdincomeinflationa   = "County Attributes - Time Dependent Income"
     Rural_Urban_Continuum_Code        = "County Attributes - Time Dependent Rurality"
     PRCDA_2017	                       = "PRCDA - 2017"
     PRCDA_Region	             = "PRCDA - Region"
     COD_to_site_recode                = "COD to Site Recode"
     COD_to_site_rec_KM                = "COD to Site Recode KM"
     Vitalstatusrecodestudycutoffuse   = "Vital Status Recode (Study Cutoff Used)"
     IHS_Link                          = "IHS LINK"
     Summary_stage_2000_1998_2017      = "Summary stage 2000 (1998-2017)"
     AYA_site_recode_WHO_2008          = "AYA site recode/WHO 2008"
     AYA_site_recode_2020_Revision     = "AYA site recode 2020 Revision"
     Lymphoidneoplasmrecode2021Revis   = "Lymphoid neoplasm recode 2021 Revision"
     LymphomasubtyperecodeWHO2008thr   = "Lymphoma subtype recode/WHO 2008 (thru 2017)"
     SEER_Brain_and_CNS_Recode         = "SEER Brain and CNS Recode"
     ICCCsiterecode3rdeditionIARC201   = "ICCC Site Recode 3rd Edition/IARC 2017"
     SEERcausespecificdeathclassific   = "SEER Cause-Specific Death Classification"
     SEERothercauseofdeathclassifica   = "SEER Other Cause of Death Classification"
     CSTumor_Size_Ext_Eval_2004_2015   = "CS Tumor Size/Ext Eval (2004-2015) "
     CS_Reg_Node_Eval_2004_2015        = "CS Reg Node Eval (2004-2015)"
     CS_Mets_Eval_2004_2015            = "CS Mets Eval (2004-2015)"
     Primary_by_international_rules    = "Primary by International Rules"
     ERStatusRecodeBreastCancer_1990   = "ER Status Recode Breast Cancer (1990+)"
     PRStatusRecodeBreastCancer_1990   = "PR Status Recode Breast Cancer (1990+)"
     CS_Schema_AJCC_6th_Edition        = "CS Schema--AJCC 6th Edition"
     LymphvascularInvasion2004varyin   = "Lymph Vascular Invasion (2004+ Varying by Schema)"
     Survival_months                   = "Survival Months"
     Survival_months_flag              = "Survival Months Flag"
     Derived_AJCC_T_7th_ed_2010_2015   = "Derived AJCC T, 7th Ed 2010-2015)"
     Derived_AJCC_N_7th_ed_2010_2015   = "Derived AJCC N, 7th Ed 2010-2015)"
     Derived_AJCC_M_7th_ed_2010_2015   = "Derived AJCC M, 7th Ed 2010-2015)"
     DerivedAJCCStageGroup7thed20102   = "Derived AJCC Stage Group, 7th Ed 2010-2015)"
     BreastAdjustedAJCC6thT1988_2015   = "Breast--Adjusted AJCC 6th T (1988-2015)"
     BreastAdjustedAJCC6thN1988_2015   = "Breast--Adjusted AJCC 6th N (1988-2015)"
     BreastAdjustedAJCC6thM1988_2015   = "Breast--Adjusted AJCC 6th M (1988-2015)"
     BreastAdjustedAJCC6thStage19882   = "Breast--Adjusted AJCC 6th Stage (1988-2015)"
     Derived_HER2_Recode_2010          = "Derived HER2 Recode (2010+)"
     Breast_Subtype_2010               = "Breast Subtype (2010+)"
     LymphomaAnnArborStage_1983_2015   = "Lymphomas: Ann Arbor Staging (1983-2015)"
     SEERCombinedMetsat_DX_bone_2010   = "SEER Combined Mets at Dx-Bone (2010+)"
     SEERCombinedMetsatDX_brain_2010   = "SEER Combined Mets at Dx-Brain (2010+)"
     SEERCombinedMetsatDX_liver_2010   = "SEER Combined Mets at Dx-Liver (2010+)"
     SEERCombinedMetsat_DX_lung_2010   = "SEER Combined Mets at Dx-Lung (2010+)"
     TvaluebasedonAJCC_3rd_1988_2003   = "T Value - Based on AJCC 3rd (1988-2003)"
     NvaluebasedonAJCC_3rd_1988_2003   = "N Value - Based on AJCC 3rd (1988-2003)"
     MvaluebasedonAJCC_3rd_1988_2003   = "M Value - Based on AJCC 3rd (1988-2003)"
     Totalnumberofinsitumalignanttum   = "Total Number of In Situ/Malignant Tumors for Patient"
     Totalnumberofbenignborderlinetu   = "Total Number of Benign/Borderline Tumors for Patient"
     RadiationtoBrainorCNSRecode1988   = "Radiation to Brain or CNS Recode (1988-1997)"
     Tumor_Size_Summary_2016	       = "Tumor Size Summary (2016+)"
     DerivedSEERCmbStg_Grp_2016_2017   = "Derived SEER Combined STG GRP (2016+)"
     DerivedSEERCombined_T_2016_2017   = "Derived SEER Combined T (2016+)"
     DerivedSEERCombined_N_2016_2017   = "Derived SEER Combined N (2016+)"
     DerivedSEERCombined_M_2016_2017   = "Derived SEER Combined M (2016+)"
     DerivedSEERCombinedTSrc20162017   = "Derived SEER Combined T SRC (2016+)"
     DerivedSEERCombinedNSrc20162017   = "Derived SEER Combined N SRC (2016+)"
     DerivedSEERCombinedMSrc20162017   = "Derived SEER Combined M SRC (2016+)"
     TNM_Edition_Number_2016_2017      = "TNM Edition Number (2016-2017)"
     Mets_at_DX_Distant_LN_2016	       = "Mets at Dx-Distant LN (2016+)"
     Mets_at_DX_Other_2016	       = "Mets at DX--Other (2016+)"
     AJCC_ID_2018                      = "AJCC ID (2018+)"
     EOD_Schema_ID_Recode_2010         = "EOD Schema ID Recode (2010+)"
     Derived_EOD_2018_T_2018           = "Derived EOD 2018 T (2018+)"
     Derived_EOD_2018_N_2018           = "Derived EOD 2018 N (2018+)"
     Derived_EOD_2018_M_2018           = "Derived EOD 2018 M (2018+)"
     DerivedEOD2018_Stage_Group_2018   = "Derived EOD 2018 Stage Group (2018+)"
     EOD_Primary_Tumor_2018            = "EOD Primary Tumor (2018+)"
     EOD_Regional_Nodes_2018           = "EOD Regional Nodes (2018+)"
     EOD_Mets_2018                     = "EOD Mets (2018+)"
     Monthsfromdiagnosisto_treatment   = "Months from diagnosis to treatment"
     Census_Tract_1990                 = "Census Track 1990"
     Census_Tract_2000                 = "Census Track 2000"
     Census_Tract_2010                 = "Census Track 2010"
     Census_Coding_System	       = "Coding System for Census Track 1970/80/90"
     Census_Tract_Certainty_1990       = "Census Tract Certainty 1970/1980/1990"
     Census_Tract_Certainty_2000       = "Census Tract Certainty 2000"
     Census_Tract_Certainty_2010       = "Census Tract Certainty 2010"
     Rural_Urban_Continuum_Code_1993   = "Rural-Urban Continuum Code 1993 - From SEER*Stat"
     Rural_Urban_Continuum_Code_2003   = "Rural-Urban Continuum Code 2003 - From SEER*Stat"
     Rural_Urban_Continuum_Code_2013   = "Rural-Urban Continuum Code 2013 - From SEER*Stat"
     Health_Service_Area               = "Health Service Area - From SEER*Stat"
     HealthService_Area_NCI_Modified   = "Health Service Area NCI Modified - From SEER*Stat"
     County_at_DX_Geocode_1990         = "County at DX Geocode 1990"
     County_at_DX_Geocode_2000	       = "County at DX Geocode 2000"
     County_at_DX_Geocode_2010         = "County at DX Geocode 2010"
     Derived_SS1977_flag               = "Derived SS1977 - Flag (2004+)"
     Derived_SS2000_flag               = "Derived SS2000 - Flag (2004+)"
     Radiation                         = "Radiation"
     RadiationtoBrainorCNS_1988_1997   = "Radiation to Brain or CNS (1988-1997)"
     SEER_DateofDeath_Month            = "Death Month based on Stat_rec"
     SEER_DateofDeath_Year             = "Death Year based on Stat_rec"
     Month_of_last_follow_up_recode    = "Month of Follow-up recode, study cutoff used"
     Year_of_last_follow_up_recode     = "Year of Follow-up recode, study cutoff used"
     Year_of_birth                     = "Year of Birth"
     Date_of_diagnosis_flag            = "Date of Diagnosis Flag"
     Date_therapy_started_flag         = "Date of Therapy Started Flag"
     Date_of_birth_flag                = "Date of Birth flag"
     Date_of_last_follow_up_flag       = "Date of Last Follow-up Flag"
     Month_therapy_started             = "Month Therapy Started"
     Year_therapy_started              = "Year Therapy Started"
     Other_cancer_directed_therapy     = "Other Cancer-Directed Therapy"
     Derived_AJCC_flag                 = "Derived AJCC - Flag (2004+)"
     Derived_SS1977                    = "Derived SS1977 (2004-2015)"
     Derived_SS2000                    = "Derived SS2000 (2004+)"
     SEER_Summary_stage_1977_9500      = "SEER summary stage 1977(1995-2000)"
     SEER_Summary_stage_2000_0103      = "SEER summary stage 2000(2001-2003)"
     Primary_Payer_at_DX               = "Primary Payer at DX"
     Recode_ICD_0_2_to_9               = "Recode ICD-O-2 to 9"
     Recode_ICD_0_2_to_10              = "Recode ICD-O-2 to 10"
     NHIA_Derived_Hisp_Origin          = "NHIA Dervied Hispanic Origin"
     Age_site_edit_override            = "Age-site edit override"
     Sequencenumber_dx_conf_override   = "Sequence number-dx conf override"
     Site_type_lat_seq_override        = "Site-type-lat-seq override"
     Surgerydiagnostic_conf_override   = "Surgery-diagnostic conf override"
     Site_type_edit_override           = "Site-type edit override"
     Histology_edit_override           = "Histology edit override"
     Report_source_sequence_override   = "Report source sequence override"
     Seq_ill_defined_site_override     = "Seq-ill-defined site override"
     LeukLymphdxconfirmationoverride   = "Leuk-Lymph dx confirmation override"
     Site_behavior_override            = "Site-behavior override"
     Site_EOD_dx_date_override         = "Site-EOD-dx date override"
     Site_laterality_EOD_override      = "Site-laterality-EOD override"
     Site_laterality_morph_override    = "Site-laterality-morph override"
     SEER_Summary_Stage_2000newonly    = "Summary Stage 2000 (NAACCR Item-759) (Only to be available for new registries for diagnosis years 2000-2003)"
     Insurance_Recode_2007             = "Insurance Recode (2007+)"
     Yost_ACS_2006_2010                = "Yost Index (ACS 2006-2010)"
     Yost_ACS_2010_2014                = "Yost Index (ACS 2010-2014)"
     Yost_ACS_2013_2017                = "Yost Index (ACS 2013-2017)"
     Yost_ACS_2006_2010_State_based    = "Yost Index (ACS 2006-2010) - State Based"
     Yost_ACS_2010_2014_State_based    = "Yost Index (ACS 2010-2014) - State Based"
     Yost_ACS_2013_2017_State_based    = "Yost Index (ACS 2013-2017) - State Based"
     Yost_ACS_2006_2010_quintile       = "Yost Index Quintile (ACS 2006-2010)"
     Yost_ACS_2010_2014_quintile       = "Yost Index Quintile (ACS 2010-2014)"
     Yost_ACS_2013_2017_quintile       = "Yost Index Quintile (ACS 2013-2017)"
     YostACS20062010quintileStatebas   = "Yost Index Quintile (ACS 2006-2010) - State Based"
     YostACS20102014quintileStatebas   = "Yost Index Quintile (ACS 2010-2014) - State Based"
     YostACS20132017quintileStatebas   = "Yost Index Quintile (ACS 2013-2017) - State Based"
     Brain_Molecular_Markers_2018      = "Brain Molecular Markers (2018+)"
     AFPPostOrchiectomyLabValueRecod   = "AFP Post-Orchiectomy Lab Value Recode (2010+)"
     AFPPretreatmentInterpretationRe   = "AFP Pretreatment Interpretation Recode (2010+)"
     B_Symptoms_Recode_2010            = "B Symptoms Recode (2010+)"
     Breslow_Thickness_Recode_2010     = "Breslow Thickness Recode (2010+)"
     CA125PretreatmentInterpretation   = "CA-125 Pretreatment Interpretation Recode (2010+)"
     CEAPretreatmentInterpretationRe   = "CEA Pretreatment Interpretation Recode (2010+)"
     Chromosome19qLossofHeterozygosi   = "Chromosome 19q: Loss of Heterozygosity (LOH) Recode (2010+)"
     Chromosome1pLossofHeterozygosit   = "Chromosome 1p: Loss of Heterozygosity (LOH) Recode (2010+)"
     Fibrosis_Score_Recode_2010        = "Fibrosis Score Recode (2010+)"
     GestationalTrophoblasticPrognos   = "Gestational Trophoblastic Prognostic Scoring Index Recode (2010+)"
     GleasonPatternsClinicalRecode20   = "Gleason Patterns Clinical Recode (2010+)"
     GleasonPatternsPathologicalReco   = "Gleason Patterns Pathological Recode (2010+)"
     GleasonScoreClinicalRecode_2010   = "Gleason Score Clinical Recode (2010+)"
     GleasonScorePathologicalRecode2   = "Gleason Score Pathological Recode (2010+)"
     hCGPostOrchiectomyRangeRecode20   = "hCG Post-Orchiectomy Range Recode (2010+)"
     InvasionBeyondCapsuleRecode2010   = "Invasion Beyond Capsule Recode (2010+)"
     IpsilateralAdrenalGlandInvolvem   = "Ipsilateral Adrenal Gland Involvement Recode (2010+)"
     LDHPostOrchiectomyRangeRecode20   = "LDH Post-Orchiectomy Range Recode (2010+)"
     LDHPretreatmentLevelRecode_2010   = "LDH Pretreatment Level Recode (2010+)"
     LNHeadandNeckLevelsIIIIRecode20   = "LN Head and Neck Levels I-III Recode (2010+)"
     LNHeadandNeckLevelsIVVRecode201   = "LN Head and Neck Levels IV-V Recode (2010+)"
     LNHeadandNeckLevelsVIVIIRecode2   = "LN Head and Neck Levels VI-VII Recode (2010+)"
     LNHeadandNeck_Other_Recode_2010   = "LN Head and Neck Other Recode (2010+)"
     LNPositiveAxillaryLevelIIIRecod   = "LN Positive Axillary Level I-II Recode (2010+)"
     Lymph_Node_Size_Recode_2010       = "Lymph Node Size Recode (2010+)"
     MajorVeinInvolvementRecode_2010   = "Major Vein Involvement Recode (2010+)"
     MeasuredBasalDiameterRecode2010   = "Measured Basal Diameter Recode (2010+)"
     Measured_Thickness_Recode_2010    = "Measured Thickness Recode (2010+)"
     MitoticRateMelanoma_Recode_2010   = "Mitotic Rate Melanoma Recode (2010+)"
     NumberofCoresPositiveRecode2010   = "Number of Cores Positive Recode (2010+)"
     NumberofCoresExaminedRecode2010   = "Number of Cores Examined Recode (2010+)"
     NumberofExaminedParaAorticNodes   = "Number of Examined Para-Aortic Nodes Recode (2010+)"
     NumberofExaminedPelvicNodesReco   = "Number of Examined Pelvic Nodes Recode (2010+)"
     NumberofPositiveParaAorticNodes   = "Number of Positive Para-Aortic Nodes Recode (2010+)"
     NumberofPositivePelvicNodesReco   = "Number of Positive Pelvic Nodes Recode (2010+)"
     Perineural_Invasion_Recode_2010   = "Perineural Invasion Recode (2010+)"
     PeripheralBloodInvolvementRecod   = "Peripheral Blood Involvement Recode (2010+)"
     Peritoneal_Cytology_Recode_2010   = "Peritoneal Cytology Recode (2010+)"
     Pleural_Effusion_Recode_2010      = "Pleural Effusion Recode (2010+)"
     PSA_Lab_Value_Recode_2010         = "PSA Lab Value Recode (2010+)"
     ResidualTumorVolumePostCytoredu   = "Residual Tumor Volume Post Cytoreduction Recode (2010+)"
     ResponsetoNeoadjuvantTherapyRec   = "Response to Neoadjuvant Therapy Recode (2010+)"
     SarcomatoidFeatures_Recode_2010   = "Sarcomatoid Features Recode (2010+)"
     SeparateTumorNodulesIpsilateral   = "Separate Tumor Nodules Ipsilateral Lung Recode (2010+)"
     Tumor_Deposits_Recode_2010        = "Tumor Deposits Recode (2010+)"
     Ulceration_Recode_2010            = "Ulceration Recode (2010+)"
     VisceralandParietalPleuralInvas   = "Visceral and Parietal Pleural Invasion Recode (2010+)"
     ENHANCED_FIVE_PERCENT_FLAG        = "Five Percent Flag from MBSF"
     Date_of_Death_Flag_created        = "Date of Death Flag (SEER vs Medicare)"
     Date_of_Birth_Flag_created        = "Date of Birth Flag (SEER vs Medicare)"
     OncotypeDXBreastRecurrenceScore   = "Oncotype DX Breast Recurrence Score  -- Needs special permission"
     OncotypeDXRSgroupRS18RS1830RS30   = "Oncotype DX RS group (RS < 18, RS 18-30, RS > 30) -- Needs special permission"
     OncotypeDXreasonno_score_linked   = "Oncotype DX reason no score linked -- Needs special permission"
     Oncotype_DX_year_of_test_report   = "Oncotype DX year of test report -- Needs special permission"
     OncotypeDX_month_of_test_report   = "Oncotype DX month of test report -- Needs special permission"
     OncotypeDXmonthssince_diagnosis   = "Oncotype DX months since diagnosis -- Needs special permission"
      ;

run;

proc contents data=seer.SEER_lung_update position;
run;
