#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --mem=100gb
#SBATCH --time=06:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=burns756@umn.edu
#SBATCH -o /home/hirschc1/burns756/Hybrid_NMC/%j.out
#SBATCH -e /home/hirschc1/burns756/Hybrid_NMC/%j.err

#echo ${CHR}

module load plink

# transform hmp to plk
run_pipeline.pl -Xmx100g -importGuess widiv_snps.Qiu-et-al.hmp.txt -export widiv_snps.Qiu-et-al -exportType Plink

# prune plink file by ld
plink --noweb --file widiv_snps.Qiu-et-al.plk --indep-pairwise 100000 1 0.95 --out widiv_snps.Qiu-et-al.prune --allow-extra-chr --make-founders

