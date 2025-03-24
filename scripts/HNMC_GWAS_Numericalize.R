### Hybrid NMC GWAS Numericalization
### Michael Burns
### 12/20/24

# Libraries
source('http://zzlab.net/GAPIT/gapit_functions.txt')

# Get CLI inputs
cli_arg = commandArgs(trailingOnly = T)
year = as.character(cli_arg[1])
snp_effect = as.character(cli_arg[2])

print(year)
print(snp_effect)

# Data
pheno = read.csv('~/HNMC_Breeding/Data/widiv_hybrid_phenotype.csv', header = T)
geno = read.delim('~/HNMC_Breeding/Data/widiv_hybrids_maf_filtered.hmp.txt', header = F)

# Filtering
# Remove genotype sites with more than 2 alleles (7,094 out of 1,387,452)
geno = geno[c(T,nchar(geno[2:nrow(geno), 2]) == 3),]

# Create a dataset for the given year
pheno_sub = pheno[pheno$Year == year,]

# Filter phenotype files for those genotypes found in the hapmap
pheno_sub = pheno_sub[pheno_sub$Genotype %in% geno[1,],]

# Filter genotype file for those with phenotypes in 2022 and 2023 separately
geno_sub = geno[,c(rep(T,11), geno[1,12:ncol(geno)] %in% pheno_sub$Genotype)]

# Check to make sure that they match order! If they don't reorder the phenotype files
if(sum(pheno_sub$Genotype == geno_sub[1,12:ncol(geno_sub)]) != nrow(pheno_sub) |
   sum(pheno_sub$Genotype == geno_sub[1,12:ncol(geno_sub)]) != ncol(geno_sub[1,12:ncol(geno_sub)])){
  pheno_sub[match(pheno_sub$Genotype, geno_sub[1,12:ncol(geno_sub)]),]
}

# Check that everything matches
sum(pheno_sub$Genotype == geno_sub[1,12:ncol(geno_sub)]) == nrow(pheno_sub)
sum(pheno_sub$Genotype == geno_sub[1,12:ncol(geno_sub)]) == ncol(geno_sub[1,12:ncol(geno_sub)])

# Save the phenotype files
write.csv(pheno_sub, paste0('~/HNMC_Breeding/Data/WiDiv_', year, '_Phenotype_BLUEs.csv'))

# Remove unnecessary files
rm(geno)
rm(pheno)

# Numericalize the hapmap
setwd(paste0('~/HNMC_Breeding/Analysis/YCH', sub('..', '', year), '/', snp_effect, '/')) # Set working directory to output is placed in the analysis folder
GWAS = GAPIT(G = geno_sub, # 2022 genotype data
             PCA.total = 5, # 5 PCs as pop structure covariates (found this in inbreds - need to validate in hybrids)
             output.numerical =T, # Output the Numerical and Map files needed for FarmCPU
             SNP.effect = snp_effect) # Set the snp effect to either additive or dominance based

