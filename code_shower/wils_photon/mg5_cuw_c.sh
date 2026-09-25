#!/bin/bash
wils=uW
index=70
main="/scratch/barbariczara/2026"

mkdir -p "${main}/mg5_shower/C_${wils}/pp_ca/wils"

pt=75
if [ "$C" = "0.0" ]; then
		C=0.01
fi
if [[ -d "${main}/mg5_shower/C_${wils}/pp_ca/wils/C_${C}" ]]; then
	rm -r "${main}/mg5_shower/C_${wils}/pp_ca/wils/C_${C}"
fi

/home/barbariczara/python3/bin/python3.7 /home/barbariczara/tools/mg5_amc/bin/mg5_aMC <<EOF
import model SMEFTsim_general_MwScheme_UFO
generate p p > c a NP==1
output ${main}/mg5_shower/C_${wils}/pp_ca/wils/C_${C}     
launch
1
2
0
set run_card ptamax 40
set param_card smeft ${index} ${C}          
EOF
done
