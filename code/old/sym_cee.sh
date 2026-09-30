#!/bin/bash

for c in $(seq 20.5 0.5 30); do

    if [ "$c" = "0.0" ]; then
        c=0.01
    fi

python3.12 /home/zara/Tools/MG5_aMC_v3.7.2/MG5_aMC_v3_7_2/bin/mg5_aMC <<EOF
import model SMEFTsim_general_MwScheme_UFO
define p = g u d s u~ d~ s~
generate p p > c e+ e- NP==1 / h a z h1 z1 c~
output ~/Documents/mg5/C_lequ1/pp_cee/C=${c}     
launch
0
set param_card smeft 1192 ${c}          
EOF

done

for c in $(seq 0 0.5 30); do

    if [ "$c" = "0.0" ]; then
        c=0.01
    fi

python3.12 /home/zara/Tools/MG5_aMC_v3.7.2/MG5_aMC_v3_7_2/bin/mg5_aMC <<EOF
import model SMEFTsim_general_MwScheme_UFO
define p = g u d s u~ d~ s~
generate p p > c e+ e- NP==1 / h a z h1 z1 c~
output ~/Documents/mg5/C_lequ3/pp_cee/C=${c}     
launch
0
set param_card smeft 1273 ${c}          
EOF

done