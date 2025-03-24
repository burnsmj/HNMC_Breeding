# Scripts

The scripts contained in this repository were used to generate, visualize, and analyze the data reported in this study.

* Hybrid_NMC_Breeding.Rmd
*   This is the rmarkdown file that contains the majority of code and analyses run.
* All scripts containing the term GWAS of FarmCPU were used to generate and visualize the GWAS results.
*   Generally speaking, all analyses start with a '_loop.sh' script that runs years and model types in parallel
*   The loop scripts submit batch jobs to the super computer using the '.sh' file with the same prefix
*   The shell file then runs the associated '.R' file with the same prefix.
*   The general order of operations was Numericalization > FarmCPU > Plotting
* The hapmap filtering python scripts were used to reduce the size of the files for computational efficiency.
*   Hapmap_Filtering.py was used to reduce file size based on LD analysis and was eventually not used in analysis
*   Hapmap_Filtering_for_GP.sh was used to select markers based on GWAS markers selected by Selecting_GWAS_Markers.R
* Hybrid_Hapmap_Builder.(R/sh) was used to construct the hapmap used for these analyses.
