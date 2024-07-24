#!/bin/bash

#to check that fmaps were acquired correctly
#AP = -j
#PA = j

bids_dir=$1
subnum=$2

for file in "$bids_dir"/sub-P"$subnum"/fmap/*.json; do
    folder=$(dirname "$file")
    subject_number=$(basename "$folder" | grep -oP '(sub-P)\d+')
    
    name_dir=$(basename "$file" | cut -d '-' -f 3 | cut -d '_' -f 1)
    dir=$(jq -r '.PhaseEncodingDirection' "$file")
    
    if [ "$name_dir" = "AP" ]; then
        if [ "$dir" = "j-" ]; then
            echo "$file $name_dir fmap is correct ($dir)."
        else
            echo "$file $name_dir fmap is INCORRECT ($dir)."
        fi
    elif [ "$name_dir" = "PA" ]; then
        if [ "$dir" = "j" ]; then
            echo "$file $name_dir fmap is correct ($dir)."
        else
            echo "$file $name_dir fmap is INCORRECT ($dir)."
        fi
    fi
done
    
