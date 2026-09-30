#!/bin/bash

for cdir in ~/Documents/mg5/C_eu/pp_cee/C=*/; do
    find "$cdir" -mindepth 1 -maxdepth 1 \
        ! -name Cards \
        ! -name Events \
        ! -name SubProcesses \
        -exec echo rm -rf {} +

    find "$cdir/SubProcesses" -mindepth 1 -maxdepth 1 \
        ! -name results.dat \
        -exec echo rm -rf {} +
done
