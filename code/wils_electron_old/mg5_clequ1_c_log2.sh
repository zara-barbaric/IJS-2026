#!/bin/bash

values=(0.01885 0.02140 0.02430 0.02758 0.03131)

for n in "${values[@]}"; do

/home/barbariczara/python3/bin/python3.7 /home/barbariczara/tools/mg5_amc/bin/mg5_aMC <<EOF
import model SMEFTsim_general_MwScheme_UFO
define p = g u d s u~ d~ s~
generate p p > c e+ e- NP==1 / h a z h1 z1 c~
output /scratch/barbariczara/2026/mg5/C_lequ1/pp_cee/C=${n}     
launch
0
set param_card smeft 1192 ${n}          
EOF

done
