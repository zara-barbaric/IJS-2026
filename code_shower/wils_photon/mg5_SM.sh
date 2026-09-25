#!/bin/bash
main="/scratch/barbariczara/2026"

mkdir -p "${main}/mg5_shower/SM"
if [[ -d "${main}/mg5_shower/SM/wils_photon" ]]; then
	rm -r "${main}/mg5_shower/SM/wils_photon"
fi

/home/barbariczara/python3/bin/python3.7 /home/barbariczara/tools/mg5_amc/bin/mg5_aMC <<EOF
generate p p > c a 
output ${main}/mg5_shower/SM/wils_photon    
launch
1
2
0
set run_card ptamax 40 
EOF
