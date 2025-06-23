#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --mem=100gb
#SBATCH --time=02:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=burns756@umn.edu
#SBATCH -o /home/hirschc1/burns756/Hybrid_NMC/%j.out
#SBATCH -e /home/hirschc1/burns756/Hybrid_NMC/%j.err

# Load PLINK
module load plink/1.90b6.10

# Show the working directory
pwd

# create folder to save results
FOLDER=analysis/background_ld
mkdir -p ${FOLDER}

# hapmap file to calculate background ld
HMP=widiv_snps.Qiu-et-al.filtered.hmp.txt

# create file to store results
BACKLD=${FOLDER}/average_background_ld.txt
echo -n "" > ${BACKLD}

echo "Files created"

# define function to sample different seeds
get_seeded_random()
{
  seed="$1"
  openssl enc -aes-256-ctr -pass pass:"$seed" -nosalt < /dev/zero 2> /dev/null
}
# define initial seed
SEED=27423

echo "Starting Loops"

# bootstrap random sampling many times
for iter in {1..10}; do
  
  echo "Currently in iter: ${iter}"

  # create folder for iteration
  mkdir -p ${FOLDER}/iter${iter}

  # randomly select 50 markers per chr
  for chr in {1..10}; do
    echo "Currently on chromosome ${chr}"
    # sample markers
    shuf -n 50 --random-source=<(get_seeded_random ${SEED}) <(awk -v chr="$chr" '$3 == chr' ${HMP} | cut -f 1) > ${FOLDER}/iter${iter}/markers_chr${chr}.txt
    # change seed
    SEED=($(shuf -i 1-100000 -n 1 --random-source=<(get_seeded_random ${SEED})))
  done

  # create file to store results
  BACKLDITER=${FOLDER}/iter${iter}/background_ld.txt
  echo -n "" > ${BACKLDITER}

  echo "Calculating background LD across chromosomes"

  # calculate ld for all markers that are in different chromosomes
  for chr in {1..10}; do
    echo "iter${iter} - chr${chr}"
    # hmp2plk
    PLK=${FOLDER}/iter${iter}/inbreds_geno
    #echo "QC data going into TASSEL"
    #wc -l ${HMP}
    #head -3 ${HMP}
    #wc -l <(cat ${FOLDER}/iter${iter}/markers_chr*.txt)
    #head -3 <(cat ${FOLDER}/iter${iter}/markers_chr*.txt)
    #echo ${PLK}
 
    run_pipeline.pl -Xmx100g -importGuess ${HMP} \
                            -includeSiteNamesInFile <(cat ${FOLDER}/iter${iter}/markers_chr*.txt) \
                            -export ${PLK} \
                            -exportType Plink > /dev/null
    # calculate LD
    plink --file ${PLK}.plk \
          --make-founders \
          --r2 gz dprime with-freqs inter-chr \
          --ld-window-r2 0 \
          --geno 0.25 \
          --ld-snp-list ${FOLDER}/iter${iter}/markers_chr${chr}.txt \
          --out ${FOLDER}/iter${iter}/markers_chr${chr} > /dev/null
    # add R2 values into file
    zcat ${FOLDER}/iter${iter}/markers_chr${chr}.ld.gz | sed 's/^ *//' | tr -s " " | tr " " "\t" | awk -v chr=${chr} '$5 != chr' | cut -f 9 | sed 1d >> ${BACKLDITER}
  done

  # remove extra files
  rm ${FOLDER}/iter${iter}/*.log
  rm ${FOLDER}/iter${iter}/*.nosex

  # background ld as 95% of all these pairwise correlations

  echo "Determining 95th percentile of pairwise correlations"

  # note the number of values in the sample (K)
  K=$(wc -l ${BACKLDITER} | cut -d " " -f 1)
  # calculate N. N = K x 0.95.
  N=$(printf "%.0f" $(echo "${K} * 0.95" | bc))
  # sort the samples in ascending order
  # the Nth value in the sorted list will be the 95th percentile value
  sort -g ${BACKLDITER} | head -n ${N} | tail -n 1 >> ${BACKLD}

  # https://www.manageengine.com/network-monitoring/faq/95th-percentile-calculation.html

done

echo "Average 95th Pecentile LD +/- SE"

# get average (and std error) 95th percentile across all iterations
awk '{s+=$1; ss+=$1^2} END{print m=s/NR, sqrt(ss/NR-m^2)/sqrt(NR)}' ${BACKLD}
