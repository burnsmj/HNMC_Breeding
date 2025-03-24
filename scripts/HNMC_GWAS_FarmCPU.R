### Hybrid NMC GWAS - FarmCPU
### Michael Burns
### 1/10/25

# Libraries
library(GAPIT)
library(bigmemory)
source("http://zzlab.net/GAPIT/emma.txt")
source("http://zzlab.net/GAPIT/gapit_functions.txt")
source("~/HNMC_Breeding/Scripts/FarmCPU_functions.txt") 

# Get CLI inputs
cli_arg = commandArgs(trailingOnly = T)
year = as.character(cli_arg[1])
snp_effect = as.character(cli_arg[2])

print(year)
print(snp_effect)

# Data
pheno = read.csv(paste0('~/HNMC_Breeding/Data/WiDiv_', year, '_Phenotype_BLUEs.csv'), header = T)
geno_num = data.table::fread(paste0('/users/8/burns756/HNMC_Breeding/Analysis/YCH', sub('..', '', year), '/', snp_effect, '/GAPIT.Genotype.Numerical.txt'), sep = '\t', header = T) # big memory apparently requires an absolute path to find and read in data
geno_map = read.delim(paste0('~/HNMC_Breeding/Analysis/YCH', sub('..', '', year), '/', snp_effect, '/GAPIT.Genotype.map.txt'), header = T)
pca_cv = read.csv(paste0('~/HNMC_Breeding/Analysis/YCH', sub('..', '', year), '/', snp_effect, '/GAPIT.Genotype.PCA.csv'), header = T)

# Make sure taxa are the same across files
sum(pheno$Genotype == geno_num$taxa) == nrow(pheno)
sum(pheno$Genotype == pca_cv$taxa) == nrow(pheno)

# Set working directory so each analysis goes in its own folder
setwd(paste0('~/HNMC_Breeding/Analysis/YCH', sub('..', '', year), '/', snp_effect, '/FarmCPU/'))

# Run multiple GWAS models
GWAS_Results = FarmCPU(Y=pheno[,2:3],
                       GD=geno_num,
                       GM=geno_map,
                       CV=pca_cv[,-1],
                       threshold.output=1,
                       MAF.calculate=TRUE,
                       method.bin="optimum",
                       maf.threshold=0.05,
                       maxLoop=50,
                       file.output = T,
                       memo = snp_effect) 

# Save GWAS output
#data.table::fwrite(GWAS_Results$GWAS, paste0('FarmCPU.HNMC.GWAS.Results.HNMC.', year, '.', snp_effect, '.csv'), sep = ',')
