#!/bin/bash
for CHR in {1..10}; do
    echo ${CHR}
    sbatch --export=CHR=${CHR} ld_decay_calc.sh
done
