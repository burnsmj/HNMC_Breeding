#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --mem=100gb
#SBATCH --time=00:30:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=burns756@umn.edu
#SBATCH -o /home/hirschc1/burns756/Hybrid_NMC/%j.out
#SBATCH -e /home/hirschc1/burns756/Hybrid_NMC/%j.err

# Load R
module load R/4.0.4

# Run R script
Rscript add_B73_alleles_to_hmp.R \
        widiv_snps.Qiu-et-al.no-B73.hmp.txt \
        widiv_snps.B73-alleles-only.txt \
        widiv_snps.Qiu-et-al.hmp.txt
