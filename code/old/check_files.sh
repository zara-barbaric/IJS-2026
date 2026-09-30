#!/bin/bash

for dir in */; do
    file="$dir/SubProcesses/results.dat"

    if [ -f "$file" ]; then
        first=$(head -n 1 "$file" | awk '{print $1}')

        if [ "$first" = "0" ]; then
            echo "$dir: first number is 0 !!!!!!!"
        else
            echo "$dir: first number is $first"
        fi
    else
        echo "$dir: FILE MISSING"
    fi
done