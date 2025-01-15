#2D
/opt/moe2024/bin/moebatch -mpu 1 -exec "ph4_FingerprintMDB ['/home/wout/Screening_libraries/Fragment_libraries/Enamine_fragment_libraries_washed_EM_conformers.mdb', 'mol', 'FP:MACCS', 0]" -exit
/opt/moe2024/bin/moebatch -mpu 1 -exec "ph4_FingerprintMDB ['/home/wout/Screening_libraries/Fragment_libraries/Enamine_fragment_libraries_washed_EM_conformers.mdb', 'mol', 'FP:GpiDAPH3', 0]" -exit
#3D
/opt/moe2024/bin/moebatch -mpu 1 -exec "ph4_FingerprintMDB ['/home/wout/Screening_libraries/Fragment_libraries/Enamine_fragment_libraries_washed_EM_conformers.mdb', 'mol', 'FP:ESshape3D', 0]" -exit
/opt/moe2024/bin/moebatch -mpu 1 -exec "ph4_FingerprintMDB ['/home/wout/Screening_libraries/Fragment_libraries/Enamine_fragment_libraries_washed_EM_conformers.mdb', 'mol', 'FP:piDAPH4', 0]" -exit
