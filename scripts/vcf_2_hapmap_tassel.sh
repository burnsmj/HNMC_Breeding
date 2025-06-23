#!/bin/bash

#SBATCH --time=00:30:00
#SBATCH --ntasks=8
#SBATCH --mem=120g
#SBATCH --mail-type=ALL
#SBATCH --mail-user=burns756@umn.edu
#SBATCH -o /home/hirschc1/burns756/Hybrid_NMC/%j.out
#SBATCH -e /home/hirschc1/burns756/Hybrid_NMC/%j.err

run_pipeline.pl -Xmx100g -importGuess /home/hirschc1/cnhirsch/WiDiv508_B73v4_allchr_SNPS_maxmiss0.10.recode.vcf.gz \
                -export widiv_snps.Qiu-et-al.no-B73.hmp.txt \
                -exportType HapmapDiploid
