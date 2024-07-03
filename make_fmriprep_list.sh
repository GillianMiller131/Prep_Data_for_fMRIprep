#!/bin/bash

#Check whether subjects who have folders in the main BIDS dir also have a folder in derivatives/fmriprep

bidsdir=$1

if [ -f "${bidsdir}/code/fmriprep_list.txt" ]; then
    rm ${bidsdir}/code/fmriprep_list.txt
fi

for i in `ls ${bidsdir} | grep sub-`; do 
    
    fmriprep_dir=${bidsdir}/derivatives/fmriprep/${i}
    
     if [[ -d "$fmriprep_dir" ]]; then
         echo "$i has an FMRIPREP folder: YES"
     else 
         echo "$i has an FMRIPREP folder: NO"
         echo $i | cut -d '-' -f2 >> ${bidsdir}/code/fmriprep_list.txt
     fi
done