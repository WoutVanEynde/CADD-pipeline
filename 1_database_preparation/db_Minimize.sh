/opt/moe2024/bin/moebatch -mpu 6 -exec "db_Minimize [
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
]" -exit
