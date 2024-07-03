#!/bin/bash

#Check if subjects who have a zip file in sourcedata also have a folder in the main BIDS dir

bidsdir=$1

if [ -f "${bidsdir}/code/dcm2bids_list.txt" ]; then
    rm ${bidsdir}/code/dcm2bids_list.txt
    echo "Removing old list"
fi

for i in `ls ${bidsdir}/sourcedata/flywheel_zip_files/`; do 

     mrn_file=`echo $i | cut -d '.' -f1`
     
     sub_list=`cat ${bidsdir}/code/mrn_id.txt | grep $mrn_file | cut -d ' ' -f2`
     if [[ -z "$sub_list" ]]; then
        echo "$mrn study ID not in mrn_id.txt in code directory" 1>&2
     fi

     sub=`cat ${bidsdir}/code/mrn_id.txt | grep $mrn_file | cut -d ' ' -f2`
     sub_dir=${bidsdir}/sub-$sub
     
     if [[ -d "$sub_dir" ]]; then
         echo "$mrn_file has a BIDS folder: $sub_dir"
     else 
         echo "$mrn_file has NO BIDS folder: $sub_dir"
         echo $mrn_file >> ${bidsdir}/code/dcm2bids_list.txt
     fi
done