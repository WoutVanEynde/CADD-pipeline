# STEP 1: remove unnecessary files and rename
rm step5_input.pdb step5_input.psf README index.ndx step6.0_minimization.mdp step6.1_equilibration.mdp step6.2_equilibration.mdp step6.3_equilibration.mdp step6.4_equilibration.mdp step6.5_equilibration.mdp step6.6_equilibration.mdp step7_production.mdp
mv step5_input.gro protein_solv_ions.gro

#STEP 2: energy minimization and generate potential file
gmx grompp -f membrane_minim.mdp -c protein_solv_ions.gro -r protein_solv_ions.gro -p topol.top -o em.tpr -quiet -maxwarn 1
gmx mdrun -v -deffnm em -quiet -nb gpu
gmx energy -f em.edr -o potential.xvg -quiet << EOL
Potential
EOL

#STEP 3: create groups
gmx make_ndx -f em.gro -o index.ndx -quiet << EOL
1|13|14|15
16|17|18
quit
EOL

#STEP 4: first nvt equilibration
gmx grompp -f membrane_nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr -n index.ndx -quiet -maxwarn 1
gmx mdrun -v -deffnm nvt -quiet -nb gpu
gmx energy -f nvt.edr -o temperature.xvg -quiet << EOL
Temperature
EOL

#STEP 5: second nvt equilibration
gmx grompp -f membrane_nvt_2.mdp -c nvt.gro -r nvt.gro -p topol.top -o nvt_2.tpr -n index.ndx -quiet -maxwarn 1
gmx mdrun -v -deffnm nvt_2 -quiet -nb gpu
gmx energy -f nvt_2.edr -o temperature.xvg -quiet << EOL
Temperature
EOL

#STEP 6: first npt equilibration
gmx grompp -f membrane_npt.mdp -c nvt_2.gro -r nvt_2.gro -t nvt_2.cpt -p topol.top -o npt.tpr -n index.ndx -quiet -maxwarn 1
gmx mdrun -v -deffnm npt -quiet -nb gpu
gmx energy -f npt.edr -o pressure.xvg -quiet << EOL
Pressure
EOL
gmx energy -f npt.edr -o density.xvg -quiet << EOL
Density
EOL

#STEP 7: second npt equilibration
gmx grompp -f membrane_npt_2.mdp -c npt.gro -r npt.gro -t npt.cpt -p topol.top -o npt_2.tpr -n index.ndx -quiet -maxwarn 1
gmx mdrun -v -deffnm npt_2 -quiet -nb gpu
gmx energy -f npt_2.edr -o pressure.xvg -quiet << EOL
Pressure
EOL
gmx energy -f npt_2.edr -o density.xvg -quiet << EOL
Density
EOL

#STEP 8: third npt equilibration
gmx grompp -f membrane_npt_3.mdp -c npt_2.gro -r npt_2.gro -t npt_2.cpt -p topol.top -o npt_3.tpr -n index.ndx -quiet -maxwarn 1
gmx mdrun -v -deffnm npt_3 -quiet -nb gpu
gmx energy -f npt_3.edr -o pressure.xvg -quiet << EOL
Pressure
EOL
gmx energy -f npt_3.edr -o density.xvg -quiet << EOL
Density
EOL

#STEP 9: fourth npt equilibration
gmx grompp -f membrane_npt_4.mdp -c npt_3.gro -r npt_3.gro -t npt_3.cpt -p topol.top -o npt_4.tpr -n index.ndx -quiet -maxwarn 1
gmx mdrun -v -deffnm npt_4 -quiet -nb gpu
gmx energy -f npt_4.edr -o pressure.xvg -quiet << EOL
Pressure
EOL
gmx energy -f npt_4.edr -o density.xvg -quiet << EOL
Density
EOL

#STEP 10: MD run; care with the gpu tasks designation
gmx grompp -f membrane_md.mdp -c npt_4.gro -r npt_4.gro -t npt_4.cpt -p topol.top -o md.tpr -n index.ndx -quiet -maxwarn 1
gmx mdrun -v -deffnm md -quiet -gputasks 0001 -nb gpu -pme gpu -npme 1 -ntmpi 4

#STEP 11: continue MD
gmx mdrun -deffnm md -quiet -v -cpi md.cpt -append -gputasks 0001 -nb gpu -pme gpu -npme 1 -ntmpi 4

#STEP 12: append MD (picoseconds)
gmx convert-tpr -s md.tpr -extend 300000 -o md2.tpr
gmx mdrun -v -s md2.tpr -cpi md.cpt -deffnm md -quiet -gputasks 0001 -nb gpu -pme gpu -npme 1 -ntmpi 4
