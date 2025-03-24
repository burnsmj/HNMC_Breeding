#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --mem=100gb
#SBATCH --time=06:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=burns756@umn.edu
#SBATCH -o /users/8/burns756/HNMC_Breeding/gwas_farmcpu_%j.out
#SBATCH -e /users/8/burns756/HNMC_Breeding/gwas_farmcpu_%j.err

module load R/4.3.0-openblas-rocky8
Rscript /users/8/burns756/HNMC_Breeding/Scripts/HNMC_GWAS_FarmCPU.R ${YEAR} ${SNP_EFFECT}
