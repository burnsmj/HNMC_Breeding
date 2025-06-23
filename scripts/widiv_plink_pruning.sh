#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --mem=100gb
#SBATCH --time=01:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=burns756@umn.edu
#SBATCH -o /home/hirschc1/burns756/Hybrid_NMC/%j.out
#SBATCH -e /home/hirschc1/burns756/Hybrid_NMC/%j.err

# print the chromosome this is for
echo ${CHR}

# Load Plink module
module load plink

echo "###################"
echo "Loaded Plink Module"
echo "###################"

# hapmap file to filter
HMP=widiv_snps.Qiu-et-al.Chr_${CHR}.hmp.txt

# prunning parameters
GENOMISS=0.25
VARCOUNT=1
BACKLD=0.034
WINSIZE=5000

# folder to save files
FOLDER=analysis/ld_pruning
mkdir -p ${FOLDER}

echo "#############################"
echo "Starting Plink Transformation"
echo "#############################"

# transform hmp to plk
PLK=$(basename ${HMP} .hmp.txt)
run_pipeline.pl -Xmx100g \
                -importGuess ${HMP} \
                -export ${FOLDER}/${PLK} \
                -exportType Plink

echo "#############################"
echo "Finished Plink Transformation"
echo "#############################"

# output name
OUT=${FOLDER}/inbreds_geno_pruned_Chr_${CHR}.hmp.txt

# set intermediate filename
PRUNNED=$(echo ${PLK}.marker-ids)

echo "######################"
echo "Starting Plink Pruning"
echo "######################"

# prune plink file by ld
plink --file ${FOLDER}/${PLK}.plk \
      --indep-pairwise ${WINSIZE} ${VARCOUNT} ${BACKLD} \
      --geno ${GENOMISS} \
      --out ${FOLDER}/${PRUNNED} \
      --allow-extra-chr \
      --make-founders

echo "######################"
echo "Finished Plink Pruning"
echo "######################"

# filter hapmap
run_pipeline.pl -Xmx100g \
                -importGuess ${HMP} \
                -includeSiteNamesInFile ${FOLDER}/${PRUNNED}.prune.in \
                -export ${OUT} \
                -exportType HapmapDiploid

echo "#########################"
echo "Finished Hapmap Filtering"
echo "#########################"

# remove extra files
rm ${FOLDER}/*.log
rm ${FOLDER}/*.nosex

# count how many markers were left after prunning
#wc -l ${FOLDER}/inbreds_geno_pruned_Chr_*.hmp.txt
