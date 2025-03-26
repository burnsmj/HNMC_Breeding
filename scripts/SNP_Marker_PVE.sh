# cd ~/software
# # GCTA installation
# wget https://yanglab.westlake.edu.cn/software/gcta/bin/gcta_v1.94.0Beta_linux_kernel_2_x86_64.zip
# unzip gcta_v1.94.0Beta_linux_kernel_2_x86_64.zip
# # create a symbolic link to make it easier to write code
# cd ~/software/gcta_v1.94.0Beta_linux_kernel_2_x86_64
# ln -s gcta_v1.94.0Beta_linux_kernel_2_x86_64_static gcta
# # added gcta to PATH in ~/.bashrc to launch it anywhere in the command line

cd ~/HNMC_Breeding

# create folder to keep files from GCTA analysis
mkdir -p Analysis/gcta

# adjust phenotype files to gcta format
module load R/4.3.0-openblas-rocky8
Rscript Scripts/GWAS_PVE_Phenotype_Formatting.R

# calculate pve explained by all markers
HMP=Data/widiv_hybrids_maf_filtered_binarized.hmp.txt
FOLDER=Analysis/gcta

echo "Creating binary ped (.bed) file"

# set plink file name
PLK=$(basename ${HMP} .hmp.txt)

# transform hmp to plk
run_pipeline.pl -Xmx50g -importGuess ${HMP} \
                -export ${FOLDER}/${PLK} \
                -filterAlign \
                -filterAlignRemMinor \
                -exportType Plink

# Load plink
module load plink/1.07

# create bed file (binary ped)
plink --file ${FOLDER}/${PLK}.plk \
      --noweb \
      --missing-genotype N \
      --make-bed \
      --out ${FOLDER}/${PLK}

echo "Calculating genetic relationship matrices"

cd gcta_v1.94.0Beta_linux_kernel_2_x86_64/

# calculate additive genetic relationship matrix
./gcta --bfile ../${FOLDER}/${PLK} \
     --make-grm \
     --thread-num 10 \
     --out ../${FOLDER}/${PLK}

echo "Estimating variance explained by markers for different traits"

for trait in WiDiv_2022 WiDiv_2023; do
  echo "  ${trait}"
  # set variables
  PHENO=../${FOLDER}/${trait}/${trait}.phen
  OUT=../${FOLDER}/${trait}/pve_all-markers.${trait}
  # estimate variance explained by additive markers
  gcta --grm ../${FOLDER}/${PLK} \
       --pheno ${PHENO} \
       --reml \
       --out ${OUT}.add \
       --thread-num 10
done
