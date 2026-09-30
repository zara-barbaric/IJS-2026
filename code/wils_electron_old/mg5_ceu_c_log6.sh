#!/bin/bash

values=(0.23825 0.27046 0.30703 0.34855 0.39569)

for n in "${values[@]}"; do

/home/barbariczara/python3/bin/python3.7 /home/barbariczara/tools/mg5_amc/bin/mg5_aMC <<EOF
import model SMEFTsim_general_MwScheme_UFO
define p = g u d s u~ d~ s~
generate p p > c e+ e- NP==1 / h a z h1 z1 c~
output /scratch/barbariczara/2026/mg5/C_eu/pp_cee/C=${n}     
launch
0
set param_card smeft 407 ${n}          
EOF

done
