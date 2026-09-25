#!/bin/bash
main="/scratch/barbariczara/2026"

mkdir -p "${main}/mg5_shower/SM/pt_electron"

for pt in $(seq 50 5 300); do
	if [[ -d "${main}/mg5_shower/SM/pt_electron/pt_${pt}" ]]; then
		rm -r "${main}/mg5_shower/SM/pt_electron/pt_${pt}"
	fi
/home/barbariczara/python3/bin/python3.7 /home/barbariczara/tools/mg5_amc/bin/mg5_aMC <<EOF
generate p p > c e+ e-
output ${main}/mg5_shower/SM/pt_electron/pt_${pt}     
launch
1
2
0
set run_card ptj ${pt}      
EOF
done
