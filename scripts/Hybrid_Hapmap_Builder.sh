#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --mem=100gb
#SBATCH --time=30:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=burns756@umn.edu
#SBATCH -o /users/8/burns756/HNMC_Breeding/hapmap_builder_%j.out
#SBATCH -e /users/8/burns756/HNMC_Breeding/hapmap_builder_%j.err

module load R/4.3.0-openblas-rocky8
Rscript /users/8/burns756/HNMC_Breeding/Scripts/Hybrid_Hapmap_Builder.R
