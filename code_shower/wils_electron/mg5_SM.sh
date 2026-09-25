#!/bin/bash
main="/scratch/barbariczara/2026"

/home/barbariczara/python3/bin/python3.7 /home/barbariczara/tools/mg5_amc/bin/mg5_aMC <<EOF
generate p p > c e+ e-
output ${main}/mg5_shower/SM/wils_electron     
launch
1
2
0
EOF
