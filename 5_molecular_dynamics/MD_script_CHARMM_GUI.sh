# STEP 1: remove unnecessary files and rename
rm step4.0_minimization.mdp step4.1_equilibration.mdp step5_production.mdp step3_input.pdb step3_input.psf README index.ndx
mv step3_input.gro protein_solv_ions.gro

#STEP 2: energy minimization and generate potential file
gmx grompp -f minim.mdp -c protein_solv_ions.gro -r protein_solv_ions.gro -p topol.top -o em.tpr -quiet -maxwarn 1
gmx mdrun -v -deffnm em -quiet -nb gpu
gmx energy -f em.edr -o potential.xvg -quiet << EOL
Potential
EOL

#STEP 3: create groups
gmx make_ndx -f em.gro -o index.ndx -quiet << EOL
1|12|13
14|15|16
quit
EOL

#STEP 4: nvt and generate temperature file
gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr -n index.ndx -quiet -maxwarn 1
gmx mdrun -v -deffnm nvt -quiet -nb gpu
gmx energy -f nvt.edr -o temperature.xvg -quiet << EOL
Temperature
EOL

#STEP 5: npt and generate pressure and density files
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr -n index.ndx -quiet -maxwarn 1
gmx mdrun -v -deffnm npt -quiet -nb gpu
gmx energy -f npt.edr -o pressure.xvg -quiet << EOL
Pressure
EOL
gmx energy -f npt.edr -o density.xvg -quiet << EOL
Density
EOL

#STEP 6: generate tpr file on computer and run MD; care with the gpu tasks designation
gmx grompp -f md.mdp -c npt.gro -r npt.gro -t npt.cpt -p topol.top -o md.tpr -n index.ndx -quiet -maxwarn 1
gmx mdrun -v -deffnm md -quiet -gputasks 0001 -nb gpu -pme gpu -npme 1 -ntmpi 4

#STEP 7: continue MD
gmx mdrun -deffnm md -quiet -v -cpi md.cpt -append -gputasks 0001 -nb gpu -pme gpu -npme 1 -ntmpi 4

#STEP 8: append MD (picoseconds)
gmx convert-tpr -s md.tpr -extend 300000 -o md2.tpr
gmx mdrun -v -quiet -gputasks 0001 -nb gpu -pme gpu -npme 1 -ntmpi 4 -s md2.tpr -cpi md.cpt -deffnm md
