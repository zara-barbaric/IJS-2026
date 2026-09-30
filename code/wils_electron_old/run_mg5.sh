#!/bin/bash

python3.12 /home/zara/Tools/MG5_aMC_v3.7.2/MG5_aMC_v3_7_2/bin/mg5_aMC <<EOF
import model SMEFTsim_general_MwScheme_UFO
define p = g u d s u~ d~ s~
generate p p > c e+ e- NP==1 / h a z h1 z1 c
output ~/Documents/mg5/C_lu/pp_cee/C=15.5
launch
0
set param_card smeft 632 15.5
EOF

