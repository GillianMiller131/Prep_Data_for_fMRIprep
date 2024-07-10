#!/bin/bash

#use this to modify the Intendedfor field in the field map json files as the current BIDS compliant format is not compatible with this version of fmriprep

bids_dir=$1

for file in "$bids_dir"/sub-P*/fmap/*.json; do
    folder=$(dirname "$file")
    subject_number=$(basename "$folder" | grep -oP '(sub-P)\d+')
    echo "$subject_number"

    old_value=$(jq -r '.IntendedFor' "$file")
    echo "Original value of IntendedFor in $file: $old_value"
    new_value=$(echo "$old_value" | cut -d '/' -f 2-)
    echo "New value of IntendedFor in $file: $new_value"
    jq --arg new_value "$new_value" '.IntendedFor = $new_value' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    echo "Edited IntendedFor field in $file"
done

