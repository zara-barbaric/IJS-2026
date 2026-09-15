#!/bin/bash
main="/scratch/barbariczara/2026"

mkdir -p "{main}/mg5/SM/pt_photon"

for pt in $(seq 20 5 500); do
	if [[ -d "{main}/mg5/SM/pt_photon/pt_${pt}" ]]; then
		rm -r "{main}/mg5/SM/pt_photon/pt_${pt}"
	fi
/home/barbariczara/python3/bin/python3.7 /home/barbariczara/tools/mg5_amc/bin/mg5_aMC <<EOF
generate p p > c a
output {main}/mg5/SM/pt_photon/pt_${pt}     
launch
0 
set run_card ptj ${pt}      
EOF
done
