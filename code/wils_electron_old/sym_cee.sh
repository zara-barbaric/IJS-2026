#!/bin/bash

for c in $(seq 20.5 0.5 30); do

    if [ "$c" = "0.0" ]; then
        c=0.01
    fi

/home/barbariczara/python3/bin/python3.7 /home/barbariczara/tools/mg5_amc/bin/mg5_aMC <<EOF
import model SMEFTsim_general_MwScheme_UFO
define p = g u d s u~ d~ s~
generate p p > c e+ e- NP==1 / h a z h1 z1 c~
output /scratch/barbariczara/2026/mg5/C_qe/pp_cee/C=${c}     
launch
0
set param_card smeft 727 ${c}          
EOF

done
