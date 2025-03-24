### Preparation of GWAS HapMap
### Michael Burns
### 12/17/24

# Libraries
library(tidyverse)

# Read in Data
hapmap = read_delim('~/HNMC_Breeding/Data/widiv_snps.Qiu-et-al.gwas_subset.hmp.txt')
hybrids = read_csv('~/HNMC_Breeding/Data/widiv_b_m_hybrids.csv')

# Change the hapmap names to be all caps to match the phenotype lists
colnames(hapmap)[12:ncol(hapmap)] = toupper(colnames(hapmap)[12:ncol(hapmap)])

# Create a list of acceptable genotypes - not sure if we will use this yet, but we did when making the genomic prediction set
possible_combos = expand.grid(c('A', 'C', 'T', 'G', 'N'), c('A', 'C', 'T', 'G', 'N')) %>%
  as_tibble() %>%
  mutate(combos = paste0(Var1, Var2))

# Steal the site names and hapmap specific columns from the hapmap
hybrid_hapmap = hapmap[,1:11]

# Initiate a tracker to monitor progress of loop
tracker = 0
for(hybrid in hybrids$Genotype){
  # Display progress
  tracker = tracker + 1
  if(tracker %% 50 == 0){
    print(paste('Working on line', tracker, 'out of', length(hybrids$Genotype)))
  }
  # Figure out the parents
  parents = str_split(hybrid, ' X ', simplify = T)
  # Pull out the egg parent name
  egg = parents[[1]]
  # Pull out the pollen parent name
  pollen = parents[[2]]
  # Skip if egg parent doesn't exist (pollen parent will always exist since it is only B73 or Mo17)
  if(!egg %in% colnames(hapmap)[12:ncol(hapmap)]){
    next
  }
  # Pull out the first letter of the egg and pollen parent genotypes for each site - they should be the same at this point, so it shouldn't matter
  egg_genotype = substr(hapmap[,egg][[1]], 1, 1)
  pollen_genotype = substr(hapmap[,pollen][[1]], 1, 1)
  # Combine the egg and pollen parent genotypes to create the hybrid
  hybrid_genotype = paste0(egg_genotype, pollen_genotype)
  # Save this to the hybrid hapmap dataset
  hybrid_hapmap[,hybrid] = hybrid_genotype
}

# Check the dimensions of the dataset - remember, it won't be exactly what you expect because there are some missing genotypes
dim(hybrid_hapmap)

# Write the file
write_delim(hybrid_hapmap, '~/HNMC_Breeding/Data/widiv_hybrids.hmp.txt', delim = '\t')

# Remove big, old data to reduce RAM usage
rm(hapmap)
rm(hybrids)

# Create a dataset to fill
#hybrid_hapmap_filtered = tibble()

# Initiate a tracker to monitor progress
tracker = 0

# Initiate the file to append to
write(colnames(hybrid_hapmap),
      '~/HNMC_Breeding/Data/widiv_hybrids_maf_filtered.hmp.txt',
      sep = '\t',
      ncolumns = length(colnames(hybrid_hapmap)))

# Check the allele frequency at each site

# Debugging - check times
# tracker_timer = c()
# info_timer = c()
# allelefreq_timer = c()
# write_timer = c()

for(row in 1:nrow(hybrid_hapmap)){
  # Start timer
  # start_time = Sys.time()
  # Display progress
  tracker = tracker + 1
  if(tracker %% 10000 == 0){
    print(paste('Working on line', tracker, 'out of', nrow(hybrid_hapmap)))
  }
  # Check time
  # tracker_timer = c(tracker_timer, Sys.time() - start_time)
  # Start timer
  # start_time = Sys.time()
  # Extract site information
  site_info = hybrid_hapmap[row,]
  # Split the allele states
  alleles = str_split(site_info[2], '/', simplify = T)
  # Check time
  # info_timer = c(info_timer, Sys.time() - start_time)
  # Start timer
  # start_time = Sys.time()
  # Determine the allele frequencies
  allele_freqs = c()
  for(allele in alleles){
    allele_freqs = c(allele_freqs,
                     sum(str_count(site_info[12:ncol(site_info)],
                                   pattern = allele)) / (2 * ncol(site_info[12:ncol(site_info)])))
  }
  # Check time
  # allelefreq_timer = c(allelefreq_timer, Sys.time() - start_time)
  # Start timer
  # start_time = Sys.time()
  if(min(allele_freqs) > 0.05){
    write(unlist(site_info[1,]),
          '~/HNMC_Breeding/Data/widiv_hybrids_maf_filtered.hmp.txt',
          sep = '\t',
          append = T,
          ncolumns = length(site_info))
    #hybrid_hapmap_filtered = bind_rows(hybrid_hapmap_filtered, site_info)
  }
  # Check time
  # write_timer = c(write_timer, Sys.time() - start_time)
  # Debugging - stop early
  # if(tracker >= 10000){
  #   break
  # }
}

#dim(hybrid_hapmap_filtered)

# Write the filtered file
#write_delim(hybrid_hapmap, '~/HNMC_Breeding/Data/widiv_hybrids_maf_filtered.hmp.txt', delim = '\t')

# Debugging - show time over iterations
# plot(seq(1,10000,1), tracker_timer)
# plot(seq(1,10000,1), info_timer)
# plot(seq(1,10000,1), allelefreq_timer)
# plot(seq(1,10000,1), write_timer)
# 
# mean((tracker_timer + info_timer + allelefreq_timer + write_timer))
