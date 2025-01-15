#Recentering and rewrapping coordinates of the trajectory files

#STEP 1: group ligand and receptor
gmx make_ndx -f md.gro -o index.ndx -n index.ndx -quiet << EOL
1|13|14
splitch 1
22|13
23|14
q
EOL

#STEP 2: makes broken protein whole
gmx trjconv -s md.tpr -f md.xtc -o md_noPBC_whole.xtc -pbc whole -quiet -n index.ndx << EOL
0
EOL

#STEP 3: eliminates jumps from one side to the other side of the box
gmx trjconv -s md.tpr -f  md_noPBC_whole.xtc -pbc nojump -o md_noPBC_whole_nojump.xtc -quiet -n index.ndx << EOL
0
EOL

#STEP 4: center protein in box
gmx trjconv -s md.tpr -f md_noPBC_whole_nojump.xtc -o md_noPBC_whole_nojump_center.xtc -center -quiet -n index.ndx << EOL
Protein
0
EOL

#STEP 5: center all molecules in box and put all atoms at the closest distance from center of the box
gmx trjconv -s md.tpr -f md_noPBC_whole_nojump_center.xtc -o md_noPBC_whole_nojump_center_mol_com.xtc -pbc mol -ur compact -quiet -n index.ndx << EOL
0
EOL

#STEP 6: fit the system to reference in structure file
gmx trjconv -s md.tpr -f md_noPBC_whole_nojump_center_mol_com.xtc -o md_noPBC_whole_nojump_center_mol_com_fit.xtc -fit rot+trans -quiet -n index.ndx << EOL
Backbone
0
EOL

rm md_noPBC_whole.xtc md_noPBC_whole_nojump.xtc md_noPBC_whole_nojump_center.xtc md_noPBC_whole_nojump_center_mol_com.xtc

#STEP 7: output a .pdb file that contains the exact particles as the trajectory at t=0, so other programs know how to interpret the numbers in the trajectory
gmx trjconv -s md.tpr -f md.xtc -o md.pdb -pbc mol -ur compact -dump 0 -quiet -n index.ndx << EOL
0
EOL

#STEP 8: output. pdb and .xtc file for clustering
gmx trjconv -s md.tpr -f md_noPBC_whole_nojump_center_mol_com_fit.xtc -o md_protein_ligand_only.pdb -pbc mol -ur compact -dump 0 -quiet -n index.ndx << EOL
21
EOL

gmx trjconv -s md.tpr -f md_noPBC_whole_nojump_center_mol_com_fit.xtc -o md_protein_ligand_only.xtc -quiet -n index.ndx << EOL
21
EOL

gmx trjconv -s md.tpr -f md_noPBC_whole_nojump_center_mol_com_fit.xtc -o md_monomer_1.pdb -pbc mol -ur compact -dump 0 -quiet -n index.ndx << EOL
24
EOL

gmx trjconv -s md.tpr -f md_noPBC_whole_nojump_center_mol_com_fit.xtc -o md_monomer_1.xtc -quiet -n index.ndx << EOL
24
EOL

gmx trjconv -s md.tpr -f md_noPBC_whole_nojump_center_mol_com_fit.xtc -o md_monomer_2.pdb -pbc mol -ur compact -dump 0 -quiet -n index.ndx << EOL
25
EOL

gmx trjconv -s md.tpr -f md_noPBC_whole_nojump_center_mol_com_fit.xtc -o md_monomer_2.xtc -quiet -n index.ndx << EOL
25
EOL

#STEP 9: Analysis of deuterium order parameters with DMPC lipids; value of -S(CD) should be between 0.15-0.2 around the plateau (https://livecomsjournal.org/index.php/livecoms/article/view/v1i1e5068/933 and https://www.researchgate.net/publication/12023657_Molecular_dynamics_simulation_studies_of_lipid_bilayer_systems/figures?lo=1)
gmx make_ndx -f md.tpr -o sn1.ndx -quiet << EOL
a C31
a C32
a C33
a C34
a C35
a C36
a C37
a C38
a C39
a C310
a C311
a C312
a C313
a C314
del 0-18
q
EOL

gmx make_ndx -f md.tpr -o sn2.ndx -quiet << EOL
a C21
a C22
a C23
a C24
a C25
a C26
a C27
a C28
a C29
a C210
a C211
a C212
a C213
a C214
del 0-18
q
EOL

gmx order -s md.tpr -f md_noPBC_whole_nojump_center_mol_com_fit.xtc -n sn1.ndx -d z -od deuter_sn1.xvg -quiet
gmx order -s md.tpr -f md_noPBC_whole_nojump_center_mol_com_fit.xtc -n sn2.ndx -d z -od deuter_sn2.xvg -quiet
gnuplot << EOL 
set terminal png size 1000, 800 enhanced font "Helvetica,14"
set output 'sn12.png'
set title 'Deuterium order parameters'
set ylabel '-S (CD)'
set xlabel 'Atom'
set grid
set key top right
plot 'deuter_sn1.xvg' u 1:2 w lines lw 2 lc rgb 'black' title 'sn-1 chain', \
     'deuter_sn2.xvg' u 1:2 w lines lw 2 lc rgb 'red' title 'sn-2 chain'
quit
EOL

#STEP 10: Analysis of density of the membrane with DMPC lipids (https://livecomsjournal.org/index.php/livecoms/article/view/v1i1e5068/933 and https://www.researchgate.net/publication/12023657_Molecular_dynamics_simulation_studies_of_lipid_bilayer_systems/figures?lo=1)
gmx make_ndx -f md.tpr -o density_groups.ndx -quiet << EOL
15 & a C11|a C12|a C13|a C14|a N|a P|a O11|a O12|a O13|a O14
name 19 Headgroups
15 & a C1|a C2|a C3|a O31|a O32|a C31|a O21|a O22|a C21
name 20 Glycerol_esters
15 & ! 19 & !20
name 21 Acyl_chains
name 18 Water
q
EOL

gmx density -s md.tpr -f md_noPBC_whole_nojump_center_mol_com_fit.xtc -n density_groups.ndx -o dens_headgroups.xvg -d Z << EOL
19
EOL
gmx density -s md.tpr -f md_noPBC_whole_nojump_center_mol_com_fit.xtc -n density_groups.ndx -o dens_glycerol_esters.xvg -d Z << EOL
20
EOL
gmx density -s md.tpr -f md_noPBC_whole_nojump_center_mol_com_fit.xtc -n density_groups.ndx -o dens_acyl_chains.xvg -d Z << EOL
21
EOL
gmx density -s md.tpr -f md_noPBC_whole_nojump_center_mol_com_fit.xtc -n density_groups.ndx -o dens_waters.xvg -d Z << EOL
18
EOL

gnuplot << EOL 
set terminal png size 1000, 800 enhanced font "Helvetica,14"
set output 'membrane_density.png'
set title 'Membrane density'
set ylabel 'Density (kg/m3)'
set xlabel 'Z-coordinate (nm)'
set grid
set key top right
plot 'dens_headgroups.xvg' using 1:2 smooth csplines w lines lw 2 lc rgb 'black' title 'Headgroups', \
     'dens_glycerol_esters.xvg' using 1:2 smooth csplines w lines lw 2 lc rgb 'red' title 'Glycerol esters', \
     'dens_acyl_chains.xvg' using 1:2 smooth csplines w lines lw 2 lc rgb 'green' title 'Acyl chains',  \
     'dens_waters.xvg' using 1:2 smooth csplines w lines lw 2 lc rgb 'blue' title 'Water'
quit
EOL

#STEP 11: Analysis of lateral diffusion of lipids (noe fucking clue what this does; https://pmc.ncbi.nlm.nih.gov/articles/PMC6365552/)
gmx make_ndx -f md.tpr -o lateral_diffusion.ndx << EOL
15 & a P
quit
EOL

gmx msd -s md.tpr -f md_noPBC_whole_nojump_center_mol_com_fit.xtc -n lateral_diffusion.ndx -lateral z -o lateral_diffusion.xvg -trestart 150 -quiet<< EOL
19
EOL

gnuplot << EOL 
set terminal png size 1000, 800 enhanced font "Helvetica,14"
set output 'lateral_diffusion.png'
set title 'Lateral diffusion'
set ylabel 'MSD (nm2)'
set xlabel 'Time (ps)'
set grid
unset key
plot 'lateral_diffusion.xvg' using 1:2 smooth csplines w lines lw 2 lc rgb 'black'
quit
EOL
