#!/bin/bash
for CHR in {1..10}; do
    echo ${CHR}

	head -n1 widiv_snps.Qiu-et-al.filtered.hmp.txt > widiv_snps.Qiu-et-al.Chr_${CHR}.hmp.txt
	grep "^S${CHR}" widiv_snps.Qiu-et-al.filtered.hmp.txt >> widiv_snps.Qiu-et-al.Chr_${CHR}.hmp.txt
done
