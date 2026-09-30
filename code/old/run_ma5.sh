#!/bin/bash
for Wils in eu; do #lu qe lq1 lq3 lequ1 lequ3; do

python3.12 /home/zara/Tools/madanalysis5/bin/ma5 <<EOF
set main.graphic_render = matplotlib
import /home/zara/Documents/mg5/C_${Wils}/pp_cee/meja/Events/run_01/unweighted_events.lhe.gz as cee
plot PT(c) 50 20 500 [logY]
submit /home/zara/Documents/ma5/C_${Wils}/pp_cee/meja
remove selection[1]
remove cee
import /home/zara/Documents/mg5/C_${Wils}/pp_c~ee/meja/Events/run_01/unweighted_events.lhe.gz as cee
plot PT(c~) 50 20 500 [logY]
submit /home/zara/Documents/ma5/C_${Wils}/pp_c~ee/meja
remove selection[1]
remove cee
EOF

done