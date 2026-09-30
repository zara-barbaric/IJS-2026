#!/bin/bash

values=(0.44919 0.50993 0.57889 0.65716 0.74603)

for n in "${values[@]}"; do
/home/barbariczara/python3/bin/python3.7 /home/barbariczara/tools/mg5_amc/bin/mg5_aMC <<EOF
import model SMEFTsim_general_MwScheme_UFO
define p = g u d s u~ d~ s~
generate p p > c~ e+ e- NP==1 / h a z h1 z1 c
output /scratch/barbariczara/2026/mg5/C_lequ3/pp_c~ee/C=${n}     
launch
0
set param_card smeft 1273 ${n}                     
EOF

done
