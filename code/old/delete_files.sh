#!/bin/bash

for cdir in ~/Documents/mg5/C_qe/pp_cee/C=*/; do
    find "$cdir" -mindepth 1 -maxdepth 1 \
        ! -name Cards \
        ! -name Events \
        ! -name SubProcesses \
        -exec rm -rf {} +

    find "$cdir/SubProcesses" -mindepth 1 -maxdepth 1 \
        ! -name results.dat \
        -exec rm -rf {} +
done
