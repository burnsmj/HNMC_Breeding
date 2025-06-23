#!/bin/bash
for chr in {1..10}; do
	sbatch --export=CHR=$chr widiv_plink_pruning.sh
done
