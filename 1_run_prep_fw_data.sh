#!/bin/bash
set -o errexit

bids_dir=$1

pushd ${bids_dir}/sourcedata


#If you download files from the GUI Flywheel, they will be zip, so you will need this 
for i in `ls *zip`; do 
    unzip $i
    mv $i flywheel_zip_files
done
 

for i in *tar; do
    if tar -xvf "$i"; then
        mv "$i" flywheel_zip_files
    else
        echo "Error extracting $i, skipping move to flywheel_zip_files"
    fi
done


# Cleaning up unzipped files

#for zip files from GUI:
if [ -d flywheel ]; then
    for i in `ls flywheel/cohen/autismdisorder-P00034345/`; do 
        mv flywheel/cohen/autismdisorder-P00034345/$i/*/* flywheel/cohen/autismdisorder-P00034345/$i/ 
        mv flywheel/cohen/autismdisorder-P00034345/$i/ .                          
        #echo $i >> ${bids_dir}/code/dcm2bids_list.txt        #Appends to list to feed into dcm2bids 
    done
   rm -r flywheel
fi


# for tar files:
if [ -d scitran ] ; then
    for i in `ls scitran/cohen/autismdisorder-P00034345/`; do 
        mv scitran/cohen/autismdisorder-P00034345/$i/*/* scitran/cohen/autismdisorder-P00034345/$i/ 
        mv scitran/cohen/autismdisorder-P00034345/$i/ .                          
        #echo $i >> ${bids_dir}/code/dcm2bids_list.txt        #Appends to list to feed into dcm2bids 
    done
  rm -r scitran
fi


# Unzipping dcm zip files 

find . -name "*.dicom.zip" -execdir unzip {} \;
find . -name "*.dicom.zip" -delete

popd 


# Run script to create a list for dcm2bids
bash ${bids_dir}/code/make_dcm2bids_list.sh ${bids_dir}