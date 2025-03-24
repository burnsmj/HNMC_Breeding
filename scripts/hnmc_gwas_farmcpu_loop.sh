#!/bin/bash

# Define arrays of years and snp_effect values
years=(2022 2023)
snp_effects=("Add" "Dom")

# Loop through years and snp_effect values
for year in "${years[@]}"; do
  for snp_effect in "${snp_effects[@]}"; do
    # Submit the job
    sbatch --export=YEAR=$year,SNP_EFFECT=$snp_effect Scripts/hnmc_gwas_farmcpu.sh
  done
done
