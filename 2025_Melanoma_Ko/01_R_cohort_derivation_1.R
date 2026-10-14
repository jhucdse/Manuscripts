
# ============================================================================
# Purpose: Derive SEER Advanced Melanoma Cohort (Skin Primary)
# Date Created: 10/20/25 
# Author: Sophia Ko
# ============================================================================
#---------------------------------------
#load, prep, explore data
library(tidyverse)
library(haven)
getwd()
#data can take up to ~5 minutes to load
skin <- readRDS("m_cohort_derivation") 
##this file is equivalent to the "seer_skin.sas7bdat" file, just saved as RDS for faster loading.
length(unique(skin$PATIENT_ID)) #249,415 participants with a melanoma cancer diagnosis between 2013-2019
#adjusting data format
str(skin)
# Numeric conversions
skin <- skin %>%
  mutate(
    AGERECODEWITHSINGLEAGES_AND_100 = as.numeric(AGERECODEWITHSINGLEAGES_AND_100),
    YEAR_OF_DIAGNOSIS = as.numeric(YEAR_OF_DIAGNOSIS),
    HISTOLOGIC_TYPE_ICD_O_3 = as.numeric(HISTOLOGIC_TYPE_ICD_O_3)
  )
str(skin$PRIMARY_SITE)
# Factor conversions with labels
skin <- skin %>%
  mutate(
    SEX = factor(SEX, levels = c("1", "2"), 
                 labels = c("Male", "Female")),
    BEHAVIOR_RECODE_FOR_ANALYSIS = factor(BEHAVIOR_RECODE_FOR_ANALYSIS, levels = c(1:7), 
                  labels = c("Benign",
                  "Borderline malignancy",
                  "In situ",
                  "Malignant",
                  "Only malignant in ICD-O-3",
                  "No longer reportable in ICD-O-3",
                  "Only malignant 2010")),
    SEQUENCE_NUMBER = factor(SEQUENCE_NUMBER)
  )
table(skin$BEHAVIOR_RECODE_FOR_ANALYSIS)
table(skin$BEHAVIOR_CODE_ICD_O_3)
table(skin$YEAR_OF_DIAGNOSIS)
table(skin$PRIMARY_SITE)
# --------------------------------------
# Step 1: Identify Initial Melanoma Cases
site_skin <- paste0("C", 440:449)
melanoma_step1 <- skin %>%
  filter(
    PRIMARY_SITE %in% site_skin,  # Skin sites only
    YEAR_OF_DIAGNOSIS >= 2013 & YEAR_OF_DIAGNOSIS <= 2019 # 2013-2019
  )

n_step1 <- length(unique(melanoma_step1$PATIENT_ID))
#Step 1 - All skin cases 2013-2019: N = 249415 

#same as original cohort, assuming because there were additional non primary site cases but for the same people??

# --------------------------------------
# Step 2: Confirm Melanoma Histology
#combine melanoma histology codes:
melanoma_hist <- c(8720:8723, 8730, 8740:8746, 8761, 8770:8774)
melanoma_step2 <- melanoma_step1 %>%
  filter(HISTOLOGIC_TYPE_ICD_O_3 %in% melanoma_hist)

n_step2 <- length(unique(melanoma_step2$PATIENT_ID))
n_excluded_step2 <- n_step1 - n_step2
#Step 2 - Confirmed melanoma histology: N = 235622 (excluded: 13,793 )
## QUESTION: Melanoma is malignant by definition, so what are these ~14,000 cases of non-malignant melanoma??

# --------------------------------------
# Step 3: Confirm Malignant Primary Site
class(skin$BEHAVIOR_RECODE_FOR_ANALYSIS)
class(skin$BEHAVIOR_CODE_ICD_O_3)
unique(skin$BEHAVIOR_RECODE_FOR_ANALYSIS)
unique(skin$BEHAVIOR_CODE_ICD_O_3)

###QUESTION: If I use behavior_recode instead of behavior_0_3, 
###         the number of malignant cases significantly drops (238,553 --> 1256).
###         Thinking there is a data recode issue, so proceeding with the original _0_3 variable.

melanoma_step3 <- melanoma_step2 %>%
  filter(BEHAVIOR_CODE_ICD_O_3 == "3")
n_step3 <- length(unique(melanoma_step3$PATIENT_ID))
n_excluded_step3 <- n_step2 - n_step3

# Step 3 - Malignant behavior: N = 127959 (excluded: 107663 )
# --------------------------------------
# Step 4: First or only primary melanoma
###QUESTION: Since I am using sequence after already filtering for melanoma cases, then this 
###         should only return 00 = this melanoma their first and only cancer ever, or 
###          01 = this melanoma is their  first cancer, but they had another cancer later
###         So, this step is excluding pts with a prior non-melanoma cancer.
melanoma_step4 <- melanoma_step3 %>%
  filter(SEQUENCE_NUMBER %in% c("00", "01"))

n_step4 <- length(unique(melanoma_step4$PATIENT_ID))
n_excluded_step4 <- n_step3 - n_step4
cat("Step 4 - First/only primary: N =", n_step4, 
    "(excluded:", n_excluded_step4, ")\n")

# Step 4 - First/only primary: N = 86126 (excluded: 41833 )

# --------------------------------------
# Step 5: Advanced melanoma (Stage III/IV)
# NOTE: considered using SEER summary staging, but since ICI eligibility aligned with the AJCC 
#       definitions, using the time-specific staging definitions to avoid missclassification.
#       This requires use of:
#       1. 2013-2015: DerivedAJCCStageGroup7thed20102, official AJCC 7th edition staging guidelines used by clinicians from 2010-2015 
#       2. 2016-2017: DERIVEDSEERCMBSTG_GRP_2016_2017, transition period, new AJCC staging published in 2016, but integrated until 2018, so this cleaned variables cleans for some institutions that used 7th and some that used 8th AJCC editions.
#       3. 2018-2019: DERIVEDEOD2018_STAGE_GROUP_2018, official AJCC 8th edition, SEER cleans as extent of disease using AJCC 8th edition

# First, check what values these variables contain
table(skin$DERIVEDAJCCSTAGEGROUP7THED20102, useNA = "always") #Stage 3 or 4 variables: 500:700
table(skin$DERIVEDSEERCMBSTG_GRP_2016_2017, useNA = "always") #Stage 3 or 4 variables: 3, 3A, 3B, 3C, 3c1, 3c2, 4, 4A, 4B, 4C
table(skin$DERIVEDEOD2018_STAGE_GROUP_2018, useNA = "always") #Stage 3 or 4 variables: 3, 3A, 3A1, 3A2, 3B, 3C,3C1, 3C2, 3D, 4, 4A, 4B, 4C

# Define Stage III/IV codes for each staging system
stage_3_4_ajcc7 <- as.character(500:740)  # Stage III and IV for AJCC 7th

stage_3_4_seer <- c("3", "3A", "3B", "3C", "3C1", "3C2", 
                    "4", "4A", "4B", "4C")  # 2016-2017

stage_3_4_eod <- c("3", "3A", "3A1", "3A2", "3B", "3C", "3C1", "3C2", "3D",
                   "4", "4A", "4B", "4C")  # 2018-2019

# Filter for Stage III/IV
melanoma_step5 <- melanoma_step4 %>%
  filter(
    # 2013-2015: AJCC 7th edition (numeric codes 500-740)
    (YEAR_OF_DIAGNOSIS >= 2013 & YEAR_OF_DIAGNOSIS <= 2015 & 
       DERIVEDAJCCSTAGEGROUP7THED20102 %in% stage_3_4_ajcc7) |
      # 2016-2017: SEER Combined Stage
      (YEAR_OF_DIAGNOSIS >= 2016 & YEAR_OF_DIAGNOSIS <= 2017 & 
         DERIVEDSEERCMBSTG_GRP_2016_2017 %in% stage_3_4_seer) |
      # 2018-2019: EOD 2018 Stage
      (YEAR_OF_DIAGNOSIS >= 2018 & YEAR_OF_DIAGNOSIS <= 2019 & 
         DERIVEDEOD2018_STAGE_GROUP_2018 %in% stage_3_4_eod)
  )

n_step5 <- length(unique(melanoma_step5$PATIENT_ID))
n_excluded_step5 <- n_step4 - n_step5
cat("Step 5 - Stage III/IV only: N =", n_step5, 
    "(excluded:", n_excluded_step5, ")\n")

# Step 5 - Stage III/IV only: N = 6590 (excluded: 79536 )
# --------------------------------------
# Step 6: Age 66+ at diagnosis
# using 66, not 65, to account for 1 year of continuous enrollment criterion
  melanoma_step6 <- melanoma_step5 %>%
  filter(AGERECODEWITHSINGLEAGES_AND_100 >= 66)

n_step6 <- length(unique(melanoma_step6$PATIENT_ID))
n_excluded_step6 <- n_step5 - n_step6
cat("Step 6 - Age ≥66: N =", n_step6, 
    "(excluded:", n_excluded_step6, ")\n")
# Step 6 - Age ≥66: N = 4705 (excluded: 1885)


#-------------------------Brief cohort exploration -----------------
seerfinal <- melanoma_step6
table(seerfinal$YEAR_OF_DIAGNOSIS)
table(seerfinal$AGERECODEWITHSINGLEAGES_AND_100)
hist(seerfinal$AGERECODEWITHSINGLEAGES_AND_100)

#------------------------- save SEER cohort -----------------

saveRDS(seerfinal, "seer1")
#save as SAS compatable
library(readr)
write_csv(seerfinal, "seer1.csv")


#-------------------------Next Steps -----------------
# filter cohort for continuous enrollment
# decide if we want to filter by ICI, or keep everyone who was eligible for ICI, even if they didn't receive.
#-------------------------extra code -----------------


#-------------------------Derivation #2: don't exclude by stage -----------------
# in the NSCLC cohort and similar literature using seer-medicare, they often don't exclude early stage diagnoses from seer, since these
# cases could progress in the 2013-2019 period and eventually be eligible for an ICI

#load, prep, explore data
library(tidyverse)
library(haven)
getwd()
#data can take up to ~5 minutes to load
skin <- readRDS("S:/Pharmacoepi0216/SK_ScM_Thesis25/melanoma project/melanomacohort/Data/raw/m_cohort_derivation") 
##this file is equivalent to the "seer_skin.sas7bdat" file, just saved as RDS for faster loading.
length(unique(skin$PATIENT_ID)) #249,415 participants with a melanoma cancer diagnosis between 2013-2019
#adjusting data format
str(skin)
# Numeric conversions
skin <- skin %>%
  mutate(
    AGERECODEWITHSINGLEAGES_AND_100 = as.numeric(AGERECODEWITHSINGLEAGES_AND_100),
    YEAR_OF_DIAGNOSIS = as.numeric(YEAR_OF_DIAGNOSIS),
    HISTOLOGIC_TYPE_ICD_O_3 = as.numeric(HISTOLOGIC_TYPE_ICD_O_3)
  )
str(skin$PRIMARY_SITE)
# Factor conversions with labels
skin <- skin %>%
  mutate(
    SEX = factor(SEX, levels = c("1", "2"), 
                 labels = c("Male", "Female")),
    BEHAVIOR_RECODE_FOR_ANALYSIS = factor(BEHAVIOR_RECODE_FOR_ANALYSIS, levels = c(1:7), 
                                          labels = c("Benign",
                                                     "Borderline malignancy",
                                                     "In situ",
                                                     "Malignant",
                                                     "Only malignant in ICD-O-3",
                                                     "No longer reportable in ICD-O-3",
                                                     "Only malignant 2010")),
    SEQUENCE_NUMBER = factor(SEQUENCE_NUMBER)
  )
table(skin$BEHAVIOR_RECODE_FOR_ANALYSIS)
table(skin$BEHAVIOR_CODE_ICD_O_3)
table(skin$YEAR_OF_DIAGNOSIS)
table(skin$PRIMARY_SITE)
# --------------------------------------
# Step 1: Identify Initial Cutaneous Melanoma Cases
site_skin <- paste0("C", 440:449)
melanoma_step1 <- skin %>%
  filter(
    PRIMARY_SITE %in% site_skin,  # Skin sites only
    YEAR_OF_DIAGNOSIS >= 2013 & YEAR_OF_DIAGNOSIS <= 2019 # 2013-2019
  )

n_step1 <- length(unique(melanoma_step1$PATIENT_ID))
#Step 1 - All skin cases 2013-2019: N = 249,415 

#same as original cohort, assuming because there were additional non primary site cases but for the same people??

# --------------------------------------
# Step 2: Confirm Melanoma Histology
#combine melanoma histology codes:
melanoma_hist <- c(8720:8723, 8730, 8740:8746, 8761, 8770:8774)
melanoma_step2 <- melanoma_step1 %>%
  filter(HISTOLOGIC_TYPE_ICD_O_3 %in% melanoma_hist)

n_step2 <- length(unique(melanoma_step2$PATIENT_ID))
n_excluded_step2 <- n_step1 - n_step2
#Step 2 - Confirmed melanoma histology: N = 235622 (excluded: 13,793 )
## QUESTION: Melanoma is malignant by definition, so what are these ~14,000 cases of non-malignant melanoma??

# --------------------------------------
# Step 3: Confirm Malignant Primary Site
class(skin$BEHAVIOR_RECODE_FOR_ANALYSIS)
class(skin$BEHAVIOR_CODE_ICD_O_3)
unique(skin$BEHAVIOR_RECODE_FOR_ANALYSIS)
unique(skin$BEHAVIOR_CODE_ICD_O_3)

###NOTE: If I use behavior_recode instead of behavior_0_3, 
###         the number of malignant cases significantly drops (238,553 --> 1256).
###         Thinking there is a data recode issue, so proceeding with the original _0_3 variable.

melanoma_step3 <- melanoma_step2 %>%
  filter(BEHAVIOR_CODE_ICD_O_3 == "3")
n_step3 <- length(unique(melanoma_step3$PATIENT_ID))
n_excluded_step3 <- n_step2 - n_step3

# Step 3 - Malignant behavior: N = 127,959 (excluded: 107663 )
# --------------------------------------
# Step 4: First or only primary melanoma
###NOTE: Since I am using sequence after already filtering for melanoma cases, then this 
###         should only return 00 = this melanoma their first and only cancer ever, or 
###          01 = this melanoma is their  first cancer, but they had another cancer later
###         So, this step is excluding pts with a prior non-melanoma cancer.
melanoma_step4 <- melanoma_step3 %>%
  filter(SEQUENCE_NUMBER %in% c("00", "01"))

n_step4 <- length(unique(melanoma_step4$PATIENT_ID))
n_excluded_step4 <- n_step3 - n_step4
cat("Step 4 - First/only primary: N =", n_step4, 
    "(excluded:", n_excluded_step4, ")\n")

# Step 4 - First/only primary: N = 86126 (excluded: 41833 )
# --------------------------------------
# Step 6: Age 66+ at diagnosis
# using 66, not 65, to account for 1 year of continuous enrollment criterion
melanoma_step5b <- melanoma_step4 %>%
  filter(AGERECODEWITHSINGLEAGES_AND_100 >= 66)

n_step5b <- length(unique(melanoma_step5b$PATIENT_ID))
n_excluded_step5b <- n_step4 - n_step5b
cat("Step 5b - Age ≥66: N =", n_step5b, 
    "(excluded:", n_excluded_step5b, ")\n")
# Step 5b - Age ≥66: N = 63,882 (excluded: 22,244 )
seerfinal1b <- melanoma_step5b
# --------------------------------------
# ARCHIVING THIS CODE FOR SECOND DERIVATION
# Step 5: Advanced melanoma (Stage III/IV)
# NOTE: considered using SEER summary staging, but since ICI eligibility aligned with the AJCC 
#       definitions, using the time-specific staging definitions to avoid missclassification.
#       This requires use of:
#       1. 2013-2015: DerivedAJCCStageGroup7thed20102, official AJCC 7th edition staging guidelines used by clinicians from 2010-2015 
#       2. 2016-2017: DERIVEDSEERCMBSTG_GRP_2016_2017, transition period, new AJCC staging published in 2016, but integrated until 2018, so this cleaned variables cleans for some institutions that used 7th and some that used 8th AJCC editions.
#       3. 2018-2019: DERIVEDEOD2018_STAGE_GROUP_2018, official AJCC 8th edition, SEER cleans as extent of disease using AJCC 8th edition

# First, check what values these variables contain
#table(skin$DERIVEDAJCCSTAGEGROUP7THED20102, useNA = "always") #Stage 3 or 4 variables: 500:700
#table(skin$DERIVEDSEERCMBSTG_GRP_2016_2017, useNA = "always") #Stage 3 or 4 variables: 3, 3A, 3B, 3C, 3c1, 3c2, 4, 4A, 4B, 4C
#table(skin$DERIVEDEOD2018_STAGE_GROUP_2018, useNA = "always") #Stage 3 or 4 variables: 3, 3A, 3A1, 3A2, 3B, 3C,3C1, 3C2, 3D, 4, 4A, 4B, 4C

# Define Stage III/IV codes for each staging system
#stage_3_4_ajcc7 <- as.character(500:740)  # Stage III and IV for AJCC 7th

#stage_3_4_seer <- c("3", "3A", "3B", "3C", "3C1", "3C2", 
                    "4", "4A", "4B", "4C")  # 2016-2017

#stage_3_4_eod <- c("3", "3A", "3A1", "3A2", "3B", "3C", "3C1", "3C2", "3D",
                   "4", "4A", "4B", "4C")  # 2018-2019

# Filter for Stage III/IV
#melanoma_step5 <- melanoma_step4 %>%
 # filter(
  #  # 2013-2015: AJCC 7th edition (numeric codes 500-740)
   # (YEAR_OF_DIAGNOSIS >= 2013 & YEAR_OF_DIAGNOSIS <= 2015 & 
    #   DERIVEDAJCCSTAGEGROUP7THED20102 %in% stage_3_4_ajcc7) |
      # 2016-2017: SEER Combined Stage
     # (YEAR_OF_DIAGNOSIS >= 2016 & YEAR_OF_DIAGNOSIS <= 2017 & 
      #   DERIVEDSEERCMBSTG_GRP_2016_2017 %in% stage_3_4_seer) |
      # 2018-2019: EOD 2018 Stage
      #(YEAR_OF_DIAGNOSIS >= 2018 & YEAR_OF_DIAGNOSIS <= 2019 & 
       #  DERIVEDEOD2018_STAGE_GROUP_2018 %in% stage_3_4_eod)
#  )

#n_step5 <- length(unique(melanoma_step5$PATIENT_ID))
#n_excluded_step5 <- n_step4 - n_step5
#cat("Step 5 - Stage III/IV only: N =", n_step5, 
#    "(excluded:", n_excluded_step5, ")\n")

# Step 5 - Stage III/IV only: N = 6590 (excluded: 79536 )
# --------------------------------------


#-------------------------Brief cohort exploration -----------------
seerfinal <- melanoma_step6
table(seerfinal$YEAR_OF_DIAGNOSIS)
table(seerfinal$AGERECODEWITHSINGLEAGES_AND_100)
hist(seerfinal$AGERECODEWITHSINGLEAGES_AND_100)

#------------------------- save SEER cohort -----------------

saveRDS(seerfinal, "seer1")
#save as SAS compatable
library(readr)
write_csv(seerfinal, "seer1.csv")
write_csv(seerfinal1b, "seer1b.csv")

