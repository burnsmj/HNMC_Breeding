Files present here are used throughout analyses. In particular, these files are all read in by the Hybrid_NMC_Breeding.Rmd script.
Note: File Paths in the script may not algin with your file structure, so please check to make sure they align.

The original VCF is not uploadable to GitHub due to size restrictions, and the hapmaps created from it are similarly too large to upload.
Instead, please find the sequence data at BioProject PRJNA661271, Supplementary Table S1. Scripts to convert from VCF to Hapmap are provided
in the scripts folder of this repository.

Files:
- 2022_2023_field_planning_widiv_xref.csv
  - Field layout for widiv experiment - necessary for spatial correction of yield
- 2022_2023_widiv_harvest.csv
  - Grain harvest data for widiv in 2022 and 2023
- 2022_2023_widiv_stand_counts.csv
  - Stand count data for widiv in 2022 and 2023 - necessary for yield adjustments
- B73_GWAS_Based_Markers.imputed.hmp.txt
  - Markers for genomic selection (inlcuding imputed markers) that were found through GWAS of B73 hybrids
- B73_Selected_Hapmap_for_GP.txt
  - List of markers found for genomic selection from GWAS of B73 hybrids (used to create the hapmap file)
- CH_22_23_Harvest_Data.csv
  - Grain harvest data for commerical hybrids
- ERA_22_23_Harvest_Data.csv
  - Grain harvest data for historic hybrids
- Hybrid_Maize_NIR_Spectra.csv
  - NIR spectra of hybrids used in this study
- Hybrid_Maize_NIR_Spectra_hybrid_model_predictions.csv
  - Nixtamalization moisture content predictions for hybrids used in this study that were collected from CHIP-NMC
- MO17_Selected_Hapmap_for_GP.txt
  - List of markers found for genomic selection from GWAS of B73 hybrids (used to create the hapmap file)
- Mo17_GWAS_Based_Markers.imputed.hmp.txt
  - Markers for genomic selection (inlcuding imputed markers) that were found through GWAS of Mo17 hybrids
- Random_Markers.imputed.hmp.txt
  - A set of markers that evenly span each of the maize chromosomes - used to compare the performance of genomic selection by opposite pollen parent gwas results
- Random_Selected_Hapmap_for_GP.txt
  - Identity of evenly selected markers that were used to create Random_Markers.imputed.hmp.txt
- Weather_Data_Avg_Temp.xlsx
  - Average temperatures throughout the growing season in 2022 and 2023 in St. Paul MN
- Weather_Data_Precipitation.xlsx
  - Precipitation throughout the growing season in 2022 and 2023 in St. Paul MN
- WiDiv_Inbred_22_23_NIR_Data.csv
  - NIR spectra of inbreds used in this study
- WiDiv_Inbred_22_23_NIR_Data_inbred_model_predictions.csv
  - Nixtamalization moisture content predictions for inbreds used in this study that were collected from CHIP-NMC
- WiDiv_Inbred_Hybrid_NIR_Data_2022_2023.csv
  - Combined NIR data of inbreds and hybrids used in this study.
- inbreds_used_to_generate_hybrids.csv
  - List of inbreds used to generate hybrid genotypes
- widiv_heterotic_groups.csv
  - List of heterotic groups for each inbred present in WiDiv
- widiv_inbred_hybrid_trials_2022_2023_field_plan.csv
  - Field plan and layout of 2022 and 2023 field experiements for both inbred and hybrid WiDiv panels
