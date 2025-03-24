### Selecting Markers for Genomic Prediction
### Michael Burns
### 2025-03-20

# Libraries
library(tidyverse)

# Data
files = list.files('~/HNMC_Breeding/Analysis/', pattern = 'GWAS.Results.csv', recursive = T)

# Create a storage table for each trait
top_markers = tibble()

# Create a loop to read in data and add it to the storage tables
for(file in files){
  year = paste0('20', str_remove(str_split(file, '[_/]')[[1]][1], 'YCH'))
  model = str_split(file, '[_/]')[[1]][2]
  print(paste0('---', year, ' ', model, '---'))
  gwas_data = suppressMessages(read_csv(paste0('~/HNMC_Breeding/Analysis/', file)))
  
  # Filter for the 50 most significant markers from each chromosome
  for(chr in 1:10){
    top_25 = c()
    
    gwas_sub = gwas_data %>%
      filter(Chromosome == chr)
    
    for(i in 1:25){
      top = gwas_sub %>%
        arrange(P.value) %>%
        slice(1) %>%
        select(SNP, Position)
      
      gwas_sub = gwas_sub %>%
        filter((Position > top$Position+500000) | (Position < top$Position-500000))
      
      top_25 = c(top_25, top$SNP)
    }
    
    top_markers = top_markers %>%
      bind_rows(tibble(Chromosome = chr,
                       SNP = top_25,
                       Year = year,
                       Model = model))
  }
}

# Assess Spread of Data
top_markers %>%
  separate(SNP, into = c('CHR', 'POS'), sep = '_') %>%
  mutate(POS = as.numeric(POS)) %>%
  ggplot(aes(x = POS, y = Chromosome))+
  geom_point()+
  facet_grid(Year ~ Model)
# The marker spread seems pretty reasonable. There is definitely some clustering, but nothing too crazy.

# Write out the markers list
write_csv(top_markers, '~/HNMC_Breeding/Data/Markers_for_GP.csv')

# Check for duplicates
top_markers %>%
  group_by(SNP) %>%
  filter(n() > 1)

# Write a file without duplicated SNPs for grepping
top_markers %>%
  select(Chromosome, SNP) %>%
  distinct(SNP, .keep_all = T) %>%
  write_csv('~/HNMC_Breeding/Data/Markers_for_GP_Unique.csv')








