#!/bin/bash

set -o errexit

#sourcedata is labeled with MRN, so need to give this script MRN not study ID
#this script will convert the MRN to the correct study ID 

#need to activate conda env to run: conda activate dcm2bids

bidsdir=$1
mrn=$2


# Run dcm2bids 
dicom_dir=${bidsdir}/sourcedata/${mrn}
sub_id=`cat mrn_id.txt | grep $mrn | cut -d ' ' -f2`

if [[ -z "$sub_id" ]]; then
    echo "$mrn study ID not in mrn_id.txt in code directory" 1>&2
    exit 1
fi

echo "Running 2_run_dcm2bids ${sub_id}, MRN: ${mrn}" 

mkdir -p ${bidsdir}/code/tmp_dcm2nii/${mrn}

dcm2niix -f %f_%p  -v n -z y -o "${bidsdir}/code/tmp_dcm2nii/${mrn}" ${dicom_dir} 

bash ${bidsdir}/code/check_nifti.sh $bidsdir $mrn

wait 

pushd ${bidsdir}

dcm2bids -d ${bidsdir}/ ${mrn} -p ${sub_id} -c ${bidsdir}/code/dcm2bids_config.json --skip_dcm2niix #Separated so IntendedFor field in fmap JSONs are correct

popd
