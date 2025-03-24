#!/usr/bin/env python3
### Hapmap Filtering for GWAS
### Michael Burns
### 12/17/24

# This will be a python script to filter a hapmap dataset (line-by-line) for minor allele frequency, heterozygosity, and missing dataset
# This script will also subset the genotypes included to only include those that are in the WiDiv Hybrid trials

# Read in the list of inbreds used to generate the hybrid population
# Read in the first line of the hapmap dataset (header)
# Initiate a counter to keep track of the number of lines
# Read in the hapmap file line by line(skip the header this time)
# For each line, filter for genotypes present in the experiment and then check the following:
#	1) Heterozygosity
#	2) Missing data
# Heterozygous calls should be converted to NN (missing)
# Sites that have missing (and now heteroygous) levels above 0.15 should be removed

# Libraries
import csv

# Read in list of inbreds
inbreds_list = []
with open('/users/8/burns756/HNMC_Breeding/Data/inbreds_used_to_generate_hybrids.csv') as inbreds:
    inbreds_csv = csv.reader(inbreds, delimiter = ',')
    for row in inbreds_csv:
        inbreds_list += row
        
inbreds_list = inbreds_list[1:]
inbreds.close()

# Read in first row of hapmap
hapmap_header = []
with open('/users/8/burns756/HNMC_Breeding/Data/widiv_snps.Qiu-et-al.corrected_header.hmp.txt') as hapmap:
    hapmap_lines = csv.reader(hapmap, delimiter = '\t')
    for row in hapmap_lines:
        for item in row:
            hapmap_header += [item.upper()]
        break

indices = list(range(11))
indices += [hapmap_header.index(x) for x in inbreds_list if x in hapmap_header]
hapmap.close()

tracker = 0

# Open connection to output file to write to
with open("/users/8/burns756/HNMC_Breeding/Data/widiv_snps.Qiu-et-al.gwas_subset.hmp.txt", "w") as output_file:  
    # Open connection to file to read in
    with open("/users/8/burns756/HNMC_Breeding/Data/widiv_snps.Qiu-et-al.corrected_header.hmp.txt", "r") as hapmap_file:
        # Read in the file line by line
        for line in hapmap_file:
            #print(line) # Debugging
            # Add to the tracker with each line
            tracker += 1
            # Print the tracker to the screen if it is divisible by 50000
            if tracker % 50000 == 0:
                print('Working on line: ' + str(tracker))
            # Write the header to the output file
            if line.startswith("rs"):
                line_split = line.strip('\n').split('\t')
                line = [line_split[i] for i in indices]
                line_new = '\t'.join(line) + '\n'
                output_file.write(line_new)
                continue
            # Select only the columns of interest
            line_split = line.strip('\n').split('\t')
            line = [line_split[i] for i in indices]
            # Split line and extract only the genotype values
            genotypes = line[11:]
            # Determine Missing/Heterozygous Frequency (values that are not AA, TT, GG, or CC)
            if sum([1 for genotype in genotypes if genotype not in ['AA', 'TT', 'GG', 'CC']]) / len(genotypes) > 0.05:
                continue
            # Create the new line to write out
            line_new = '\t'.join(line) + '\n'
            # Write the line to the output file
            output_file.write(line_new)

# Close the connection to the files
hapmap_file.close()
output_file.close()

