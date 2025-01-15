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
]" -exit
