# Create a for loop that greps for the SNP ID from the first dataset to select lines from the second dataset
# The first dataset is a comma separeted file with the SNP ID in the second column
# The second dataset is a tab separated file with the SNP ID in the first column
# The first row of the second dataset needs to be save to the file that the second dataset's rows are written to
# The output is a tab separated file with the first row from the second dataset and the rows that contain the SNP ID from the first dataset
# For loop to grep for SNP ID from the first dataset to select lines from the second dataset

# Usage: bash Hapmap_Filter_for_GP.sh <first dataset> <second dataset> <output file>
markers=$(cut -d "," -f 2 Data/Markers_for_GP_Unique.csv)

head -n 1  Data/widiv_snps.Qiu-et-al.gwas_subset.hmp.txt > Data/Hapmap_for_GP.txt
count=0
for marker in $markers; do
    # Count the number of iterations that pass and print it out every 10th iteration
    count=$((count+1))
    if [ $((count%10)) -eq 0 ]; then
        echo $count
    fi
    # Make sure the grep doesn't return an partial matches
    grep -w $marker Data/widiv_snps.Qiu-et-al.gwas_subset.hmp.txt >> Data/Hapmap_for_GP.txt;
done

wc -l Data/Hapmap_for_GP.txt