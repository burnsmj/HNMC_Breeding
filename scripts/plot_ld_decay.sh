#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --mem=100gb
#SBATCH --time=03:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=burns756@umn.edu
#SBATCH -o /home/hirschc1/burns756/Hybrid_NMC/%j.out
#SBATCH -e /home/hirschc1/burns756/Hybrid_NMC/%j.err

echo "\nPlotting LD decay\n"

FOLDER=analysis/ld_decay

module load R/4.0.4

BACKLD=0.0396159

for type in raw bins average; do
    echo "Plotting ${type} LD decay"
    Rscript plot_ld_decay.R ${FOLDER}/inbreds_geno_sample.ld \
                            ${FOLDER}/ld_decay_sample.${type}.png \
                            --decay-plot=${type} \
                            --background-ld=${BACKLD}
done
