# Documentation: https://prolif.readthedocs.io/en/stable/notebooks/md-ligand-protein.html#ligand-protein-md

import MDAnalysis as mda
import prolif as plf
import sys

tpr = sys.argv[1]
xtc = sys.argv[2]
ligand = sys.argv[3]
NAD = sys.argv[4] # comment out if not needed

u = mda.Universe(tpr, xtc)
ligand_selection = u.select_atoms(ligand)
protein_selection = u.select_atoms("protein", NAD) # remove ", NAD" if not needed
ligand_selection.guess_bonds()
protein_selection.guess_bonds()
ligand_selection, protein_selection

# Calculate interactions between ligand and protein
fp = plf.Fingerprint()
fp.run(u.trajectory[:1000], ligand_selection, protein_selection)
df = fp.to_dataframe()
(df.mean().sort_values(ascending=False).to_frame(name="%").T * 100)

import pandas as pd

# Calculate percentages for each interaction type
pi_stacking = (
    df.xs("PiStacking", level="interaction", axis=1)
    .mean()
    .sort_values(ascending=False)
    .to_frame(name="PiStacking %")
    .T
    * 100
)
pi_cation = (
    df.xs("PiCation", level="interaction", axis=1)
    .mean()
    .sort_values(ascending=False)
    .to_frame(name="PiCation %")
    .T
    * 100
)
hb_acceptor = (
    df.xs("HBAcceptor", level="interaction", axis=1)
    .mean()
    .sort_values(ascending=False)
    .to_frame(name="HBAcceptor %")
    .T
    * 100
)

# Concatenate all results into one table
combined_df = pd.concat([pi_stacking, pi_cation, hb_acceptor])
combined_df
combined_df.to_csv("interaction_percentages.csv")
