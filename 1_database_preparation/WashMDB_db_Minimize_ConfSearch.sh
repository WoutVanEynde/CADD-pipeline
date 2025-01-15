/opt/moe2024/bin/moebatch -mpu 6 -exec "WashMDB [
    '/home/wout/Enamine_Essential_Fragment_Library_320cmpds_20231002.mdb',
    'mol',
    '/home/wout/Enamine_Essential_Fragment_Library_320cmpds_20231002_washed.mdb',
    [
        esel        : 0
    ,   opendbv     : 0
    ,   destfield   : 'mol_washed'
    ,   namefrom    : 'src'
    ,   namefield   : 'Catalog ID'
    ,   onecomp     : 1
    ,   salts       : 1
    ,   fragsave    : 0
    ,   fragfield   : 'salt'
    ,   neutralize  : 0
    ,   hydrogens   : 'add'
    ,   protomers   : 1
    ,   dominantProt: 1
    ,   pH          : 7
    ,   original    : 0
    ,   enumsize    : 1
    ,   enumdup     : 0
    ,   minPctC     : 0
    ,   seqfld      : 'pseq'
    ,   depict      : 0
    ,   scale       : 0
    ,   verbose     : 1
    ]
];

db_Minimize [
'/home/wout/Enamine_Essential_Fragment_Library_320cmpds_20231002_washed.mdb',
'mol_washed',
	[
	esel				: 0, 
	dst_field			: 'mol_EM',
	gtest				: 0.1,  
	rebuild				: 'Rebuild3D',
	keep_chirality			: 1,  
	add_h				: 1,
	pot_charge			: 1
	]
];

ConfSearch [
       infile         : '/home/wout/Enamine_Essential_Fragment_Library_320cmpds_20231002_washed.mdb',
       infile_data    : 1,               
       infile_esel    : 0,              
       infield        : 'mol_EM',        
       outfile        : '/home/wout/Enamine_Essential_Fragment_Library_320cmpds_20231002_washed_EM_conformers.mdb',      
       dbview         : 0,              
       dbappend       : 0,              
       method         : 'Stochastic',     
       cutoff         : 7,            
       cutoff_chi     : 1,              
       maxconf        : 10000,              
       maxfail        : 100,               
       maxit          : 1000,                
       gtest          : 0.005,                
       mm_maxit       : 500,               
       rmsd           : 0.25,               
       rmsd_H         : 0,           
       rmsd_HOH       : 0,              
       rmsd_ion       : 0,             
       free_shape     : 0,               
       pot_charge     : 1,             
       invert_sp3     : 0,               
       rot_amide      : 0,             
       rot_double     : 0,               
       chair_only     : 1,              
       verbose        : 1,               
       useQM          : 0,   
       hmr            : 0
]" -exit
