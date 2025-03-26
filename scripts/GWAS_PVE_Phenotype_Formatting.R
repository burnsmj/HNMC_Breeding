### Formatting Data for GWAS PVE Analysis
### Michael Burns
### 2025/03/24

# Libraries
library(tidyverse)

# Read in and format the data
hapmap = read_delim('~/HNMC_Breeding/Data/widiv_hybrids_maf_filtered.hmp.txt', col_names = T, num_threads = 10)

# Extract and change the genotypes to not have spaces
hapmap_taxa = tibble(colnames = colnames(hapmap))
hapmap_taxa_fixed = hapmap_taxa %>%
  mutate(colnames = str_replace_all(colnames, ' ', '.'))

colnames(hapmap) = hapmap_taxa_fixed$colnames

hapmap$pos = as.integer(hapmap$pos)

# Write out a binarized (only two states allowed, none can be NN)
write_delim(hapmap[rowSums(hapmap == 'NN', na.rm = T) == 0 &
                     rowSums(hapmap == 'NA', na.rm = T) == 0 &
                     rowSums(hapmap == 'NT', na.rm = T) == 0 &
                     rowSums(hapmap == 'NC', na.rm = T) == 0 &
                     rowSums(hapmap == 'NG', na.rm = T) == 0 &
                     rowSums(hapmap == 'AN', na.rm = T) == 0 &
                     rowSums(hapmap == 'TN', na.rm = T) == 0 &
                     rowSums(hapmap == 'CN', na.rm = T) == 0 &
                     rowSums(hapmap == 'GN', na.rm = T) == 0 &
                     nchar(hapmap$alleles) == 3 &
                     rowSums(is.na(hapmap[,12:ncol(hapmap)])) == 0,],
            '~/HNMC_Breeding/Data/widiv_hybrids_maf_filtered_binarized.hmp.txt', delim = '\t', quote = 'none', num_threads = 10)

# Read in, format, and write out the data
read_csv('~/HNMC_Breeding/Data/WiDiv_2022_Phenotype_BLUEs.csv') %>%
  mutate(ID = -9,
         Genotype = str_replace_all(Genotype, ' ', '.')) %>%
  select(ID, Genotype, BLUE) %>%
  write_delim('~/HNMC_Breeding/Analysis/gcta/WiDiv_2022/WiDiv_2022.phen', col_names = F, quote = 'none', delim = '\t')

read_csv('~/HNMC_Breeding/Data/WiDiv_2023_Phenotype_BLUEs.csv') %>%
  mutate(ID = -9,
         Genotype = str_replace_all(Genotype, ' ', '.')) %>%
  select(ID, Genotype, BLUE) %>%
  write_delim('~/HNMC_Breeding/Analysis/gcta/WiDiv_2022/WiDiv_2023.phen', col_names = F, quote = 'none', delim = '\t')
