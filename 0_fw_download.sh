#!/bin/bash

bidsdir=$1

folder_directory="${bidsdir}/sourcedata/"

file_path="${bidsdir}/code/mrn_id.txt"

# File needs to end with a newline character for last subject in list to be read
echo >> "$file_path"

#clear existing parallel file
> ${bidsdir}/code/fw_download_commands.txt

while read -r subject _; do
    if [[ $subject =~ ^[0-9]{7}$ ]]; then
        folder=`ls $folder_directory | grep $subject | grep -v tar`
        tar_file=`ls $folder_directory | grep $subject | grep tar`
        if [ -z "$folder" ] && [ -z "$tar_file" ] ; then
            k_id=`cat "${bidsdir}/code/mrn_id.txt" | grep "$subject" | cut -d ' ' -f2`
            echo "Downloading Subject $k_id (MRN: $subject) from Flywheel"
            echo fw download -i dicom -o "${bidsdir}/sourcedata/${subject}.tar" -y "cohen/autismdisorder-P00034345/${subject}" >> ${bidsdir}/code/fw_download_commands.txt
        elif [ -z "$folder" ] && [ ! -z "$tar_file" ]; then
            k_id=`cat "${bidsdir}/code/mrn_id.txt" | grep "$subject" | cut -d ' ' -f2`
            echo "Subject $k_id (MRN: $subject) already downloaded, but 1_prep_fw_data needs to be run"
        fi
    fi
done < "$file_path"

parallel --eta --jobs 3 < ${bidsdir}/code/fw_download_commands.txt


# while read -r subject _; do
#     if [[ $subject =~ ^[0-9]{7}$ ]]; then
#         echo $subject
#         if [ ! -e "$folder_directory/${subject}"* ] && [ ! -e "$folder_directory/${subject}.tar" ]; then
#             k_id=`cat "${bidsdir}/code/mrn_id.txt" | grep "$subject" | cut -d ' ' -f2`
#             echo "Subject $k_id (MRN: $subject) Downloading from FlyWheel"
#             #fw download -i dicom -o "${bidsdir}/sourcedata/${subject}.tar" -y "cohen/autismdisorder-P00034345/${subject}"
#         elif [ ! -e "$folder_directory/${subject}"* ] && [ -e "$folder_directory/${subject}.tar" ]; then
#             k_id=`cat "${bidsdir}/code/mrn_id.txt" | grep "$subject" | cut -d ' ' -f2`
#             echo "Subject $k_id (MRN: $subject) has been downloaded from flywheel but not prepped"
#         fi
#     fi
# done < "$file_path" #"${bidsdir}/code/mrn_id.txt"



#list=$2 #list of MRNs to pull from flywheel
#for i in `cat $list`; do
#    fw download -i dicom -o ${bidsdir}/sourcedata/${i}.tar -y cohen/autismdisorder-P00034345/${i} 
#done



#fw sync --include dicom --include-container-tags '{"subject": ["${subject}"]}' fw://cohen/autismdisorder-P00034345 ${bidsdir}/sourcedata/${subject}.tar
