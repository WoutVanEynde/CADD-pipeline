# Script to automate gmx

for dir in */; do
    cd $dir
    echo "$dir"
    for run_dir in 2_run; do
	cd "$run_dir"
	echo "$run_dir"
	
/opt/gromacs/gromacs_2024/bin/gmx trjconv -s md.tpr -f md.xtc -o md_noPBC_whole.xtc -pbc whole -quiet -n index.ndx << EOL
19
EOL

/opt/gromacs/gromacs_2024/bin/gmx trjconv -s md.tpr -f  md_noPBC_whole.xtc -pbc nojump -o md_noPBC_whole_nojump.xtc -quiet -n index.ndx << EOL
19
EOL

/opt/gromacs/gromacs_2024/bin/gmx trjconv -s md.tpr -f md_noPBC_whole_nojump.xtc -o md_noPBC_whole_nojump_center.xtc -center -quiet -n index.ndx << EOL
Protein
19
EOL

/opt/gromacs/gromacs_2024/bin/gmx trjconv -s md.tpr -f md_noPBC_whole_nojump_center.xtc -o md_noPBC_whole_nojump_center_mol_com.xtc -pbc mol -ur compact -quiet -n index.ndx << EOL
19
EOL

/opt/gromacs/gromacs_2024/bin/gmx trjconv -s md.tpr -f md_noPBC_whole_nojump_center_mol_com.xtc -o md_mmpbsa.xtc -fit rot+trans -quiet -n index.ndx << EOL
Backbone
19
EOL

rm md_noPBC_whole.xtc md_noPBC_whole_nojump.xtc md_noPBC_whole_nojump_center.xtc md_noPBC_whole_nojump_center_mol_com.xtc

/opt/gromacs/gromacs_2024/bin/gmx trjconv -s md.tpr -f md_mmpbsa.xtc -o md_mmpbsa.pdb -pbc mol -ur compact -dump 0 -quiet -n index.ndx << EOL
19
EOL

rm -f \#*\#

    	cd ..
    done
    cd ..
done

echo "The automated calculation has finished"
