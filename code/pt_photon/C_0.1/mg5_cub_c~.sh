#!/bin/bash
wils="uB"
index=79
C=0.1
main="/scratch/barbariczara/2026"

mkdir -p "${main}/mg5/C_${wils}/pp_c~a/pt/C_${C}"

for pt in $(seq 20 5 500); do
	if [[ -d "${main}/mg5/C_${wils}/pp_c~a/pt/C_${C}/pt_${pt}" ]]; then
		rm -r "${main}/mg5/C_${wils}/pp_c~a/pt/C_${C}/pt_${pt}"
	fi
/home/barbariczara/python3/bin/python3.7 /home/barbariczara/tools/mg5_amc/bin/mg5_aMC <<EOF
import model SMEFTsim_general_MwScheme_UFO
generate p p > c~ a NP==1
output ${main}/mg5/C_${wils}/pp_c~a/pt/C_${C}/pt_${pt}     
launch
0
set param_card smeft ${index} ${C}
set run_card ptj ${pt}      
EOF
done
