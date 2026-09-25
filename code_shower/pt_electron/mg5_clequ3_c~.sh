#!/bin/bash
wils="lequ3"
index=1273
main="/scratch/barbariczara/2026"

mkdir -p "${main}/mg5_shower/C_${wils}/pp_c~ee/pt"

for pt in $(seq 50 5 300); do
	if [[ -d "${main}/mg5_shower/C_${wils}/pp_c~ee/pt/pt_${pt}" ]]; then
		rm -r "${main}/mg5_shower/C_${wils}/pp_c~ee/pt/pt_${pt}"
	fi
/home/barbariczara/python3/bin/python3.7 /home/barbariczara/tools/mg5_amc/bin/mg5_aMC <<EOF
import model SMEFTsim_general_MwScheme_UFO
define p = g u d s u~ d~ s~
generate p p > c~ e+ e- NP==1 / h a z h1 z1 c
output ${main}/mg5_shower/C_${wils}/pp_c~ee/pt/pt_${pt}     
launch
1
2
0
set param_card smeft ${index} 0.0270081
set run_card ptj ${pt}                    
EOF

done
