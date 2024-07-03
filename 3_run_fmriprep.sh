#!/bin/bash

#copy FS license over to code directory 

bids_dir=$1
participant=$2

#need singularity version 3.7 and above to set the umask inside the container to match the value outside.
module unload singularity/3.2.1
module load singularity-ce/3.8.3

version=$(singularity --version | grep -oP '\d+\.\d+\.\d+')

if [ "$(printf '%s\n' "3.7" "$version" | sort -V | head -n 1)" != "3.7" ]; then
    echo "Singularity version is not greater than 3.7. Exiting."
    exit 1
    else
    echo "Singularity version is ${version}"
fi

singularity run --cleanenv \
 -B ${bids_dir}:/bids_dir \
 -B ${bids_dir}/code/fmriprep_work:/work_dir \
 /lab-share/Neuro-Cohen-e2/Public/containers/fmriprep-23.1.3.simg \
    --skip_bids_validation --participant-label ${participant} -w /work_dir --nthreads 16 --fs-license-file /bids_dir/code/license.txt \
     /bids_dir /bids_dir/derivatives/fmriprep \
     participant

 
