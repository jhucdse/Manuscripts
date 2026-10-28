# Respiratory adverse events of weight-loss drugs

SAS and R programs accompanying **Respiratory Adverse Events of Weight-Loss Drugs: A Systematic Review and Meta-Analysis**.

**Publication:** Zeng L, Zinmon-Htet C, Hundie T, et al. *Annals of the American Thoracic Society*. 2026. [Read the paper](https://doi.org/10.1093/annalsats/aaoag177).

## About the study

This systematic review evaluated respiratory adverse events associated with weight-loss medications in general populations and among people with asthma. The review included 123 studies and used random-effects meta-analyses to compare respiratory risks with placebo. Evidence was reassuring for several medications, while asthma-specific evidence and comparisons for some drugs remained limited. See the publication for the full methods, findings, and limitations.

## What is in this study directory?

This study directory is prepared for inclusion in the [Johns Hopkins Center for Drug Safety and Effectiveness  repository](https://github.com/jhucdse).

These programs document workbook import, study selection, treatment-arm and outcome harmonization, sample characteristics, meta-analyses of proportions and risk differences, and selected tables and figures. The supplied workflow primarily supports the general-population question (KQ1).

## Code availability

This directory shares the SAS and R analysis programs accompanying the paper for transparency and reference. **Data are not included.** Running the programs requires the original extraction workbook and relevant intermediate datasets, along with appropriate software and local path configuration.


## Programs and execution order

Program numbers indicate stages; they do not fully determine execution order.

| Stage | Programs, in order | Purpose |
| --- | --- | --- |
| Configure | [00_utility.sas](prog/00_utility.sas) | Set SAS libraries and paths |
| Import | [01_import.sas](prog/01_import.sas) | Read the extraction workbook |
| Select | [02_include.sas](prog/02_include.sas) | Apply study inclusion flags |
| Treatment arms | [02_inc_arm.sas](prog/02_inc_arm.sas), then [02_inc_arm_pbo.sas](prog/02_inc_arm_pbo.sas) | Harmonize active and placebo arms |
| Outcomes | [02_inc_outcome.sas](prog/02_inc_outcome.sas) | Harmonize terms, counts, and follow-up |
| Characteristics | [02_inc_samchar.sas](prog/02_inc_samchar.sas) | Prepare sample characteristics and indication flags |
| Comparative inputs | [03_riskdiff.sas](prog/03_riskdiff.sas) | Create drug-versus-placebo count datasets |
| Meta-analysis in R | [03_percMA_wSumm.Rmd](prog/03_percMA_wSumm.Rmd), [03_percMA_rd.Rmd](prog/03_percMA_rd.Rmd) | Proportions and risk differences; these two analyses are separate branches |
| SAS tables | [03_tbl_outcome.sas](prog/03_tbl_outcome.sas), [03_tbl_rd.sas](prog/03_tbl_rd.sas), [03_tbl_rob.sas](prog/03_tbl_rob.sas) | Outcome, risk-difference, and risk-of-bias tables; RoB table does not require R meta-analysis |
| R summaries and figures | [03_Table1.Rmd](prog/03_Table1.Rmd), [03_forest_rd.Rmd](prog/03_forest_rd.Rmd), [03_forest_rd_glp1.Rmd](prog/03_forest_rd_glp1.Rmd), [03_rob.Rmd](prog/03_rob.Rmd) | Table 1; forest plots after RD analysis; RoB plots after missing input preparation is recovered |


## Interpretation notes

- Risk differences are active drug minus placebo. Multiplying a risk difference by 100 expresses it in **percentage points**, although the retained historical figure/table labels use `%`.
- Proportion analyses use arm-level records. Counts of arms/comparisons are not necessarily counts of independent studies.
- `glp` includes liraglutide, semaglutide, and tirzepatide; `glp_v2` includes liraglutide and semaglutide.
- Study-specific exceptions and extraction IDs are retained to document the original data handling. The programs are tailored to this extraction schema.

## Citation

Please cite the [paper](https://doi.org/10.1093/annalsats/aaoag177) when using this work. [CITATION.cff](CITATION.cff) provides publication metadata. When referencing the code itself, identify the study directory and the commit or release used.

## License

The original analysis code and associated documentation in this study directory are licensed under the **MIT License**. See [LICENSE](LICENSE) for the full terms.

Copyright (c) 2026 Lijuan Zeng.

MIT permits use, modification, and redistribution, including commercial use, provided the copyright notice and license are retained. The code is provided without warranty. This license does not grant rights to datasets, the published article, or separately licensed third-party software. Please cite the paper when using this work in research; the citation request is separate from the MIT license conditions.

