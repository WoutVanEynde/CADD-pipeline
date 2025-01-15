#!/bin/bash

### Make sure to select right ligand in md_analysis.py and adjust system variables below; change python file as well

source ~/.anaconda/etc/profile.d/conda.sh
conda activate mdanalysis

for dir in */; do
    cd $dir
    echo "$dir"
    mkdir Interaction_percentages_results
    for run_dir in 2_run 2_run_second 2_run_third; do
	cd "$run_dir"
	echo "$run_dir"    
    
	python3 md_analysis.py "md_mmpbsa.pdb" "md_mmpbsa.xtc" &
	pid=$!
	wait $pid
	dirname=$(basename `pwd`)
	cp interaction_percentages.csv interaction_percentages_$dirname.csv
	cp interaction_percentages_*.csv ../Interaction_percentages_results
	
    	cd ..
    done
    cd ..
done
