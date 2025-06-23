#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --mem=1900gb
#SBATCH --time=96:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=burns756@umn.edu
#SBATCH -p ag2tb
#SBATCH -o /home/hirschc1/burns756/Hybrid_NMC/%j.out
#SBATCH -e /home/hirschc1/burns756/Hybrid_NMC/%j.err

echo "Starting Chromosome ${CHR}"

# Load PLINK
module load plink/1.90b6.10

# Perform analyses by chromosome
# create directory to store results
FOLDER=analysis/ld_decay
mkdir -p ${FOLDER}

# hapmap file to calculate ld decay
HMP=widiv_snps.Qiu-et-al.Chr_${CHR}.hmp.txt

# convert hapmap to plink format chr by chr using only markers from SNP chip
echo "\nConverting ${HMP} to PLINK file set\n"
PLK=${FOLDER}/inbreds_geno_Chr_${CHR}
run_pipeline.pl -Xmx10g -importGuess ${HMP} \
                -export ${PLK} \
                -exportType Plink

# calculate LD
echo "\nCalculating LD decay\n"
WINDOW=5000
plink --file ${PLK}.plk \
      --make-founders \
      --r2 gz dprime with-freqs \
      --ld-window-r2 0 \
      --ld-window ${WINDOW}000 \
      --ld-window-kb ${WINDOW} \
      --geno 0.25 \
      --out ${FOLDER}/inbreds_geno_Chr_${CHR}

# plot decay
echo "\nPlotting LD decay\n"
module load R/4.0.4
BACKLD=0.0396159
for type in raw bins average; do
    echo "Plotting ${type} LD decay"
    Rscript plot_ld_decay.R ${FOLDER}/inbreds_geno_Chr_${CHR}.ld.gz \
                            ${FOLDER}/ld_decay_Chr_${CHR}.${type}.png \
                            --decay-plot=${type} \
                            --background-ld=${BACKLD}
done

echo "\n\nCompleted Chromosome ${CHR}"
