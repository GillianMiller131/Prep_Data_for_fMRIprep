#!/bin/bash 

bidsdir=$1
mrn=$2

#Do you want to receive a list of scnas with >1 runs to manually check or do you just want to take the last scan acquired (after removing scans that did not finish running)?

#check_type="manual"
check_type="automatic"

echo " "
echo " " 
echo "*** Checking length of NIFTI files ***"

#Check dim4 of functional scans and move cut-off scans 

for file in ${bidsdir}/code/tmp_dcm2nii/${mrn}/*nii.gz; do
    dim4=`fslinfo $file | grep dim4 | grep -v pix | cut -f3`
    filename=`basename ${file}`
    json=`remove_ext $file`
    #json="${filename%.nii.gz}.json" 
        
    if [[ "$filename" == *"rest"* ]] && [[ "$filename" != *"fmap"* ]]; then
            if [ $dim4 != 283 ]; then
                echo "$filename is cut-off, moving to sourcedata/excluded_scans/"
                mv $file ${json}.json ${bidsdir}/sourcedata/excluded_scans/
            fi
    
    elif [[ "$filename" == *"face"* ]] && [[ "$filename" != *"fmap"* ]]; then
            if [ $dim4 != 221 ]; then
                echo "$filename is cut-off, moving to sourcedata/excluded_scans/" 
                mv $file ${json}.json ${bidsdir}/sourcedata/excluded_scans/
            fi
            
    elif [[ "$filename" == *"movie1"* ]] && [[ "$filename" != *"fmap"* ]]; then
            if [ $dim4 != 306 ]; then
                echo "$filename is cut-off, moving to sourcedata/excluded_scans/" 
                mv $file ${json}.json ${bidsdir}/sourcedata/excluded_scans/
            fi
            
    elif [[ "$filename" == *"movie2"* ]] && [[ "$filename" != *"fmap"* ]]; then
            if [ $dim4 != 396 ]; then
                echo "$filename is cut-off, moving to sourcedata/excluded_scans/" 
                mv $file ${json}.json ${bidsdir}/sourcedata/excluded_scans/
            fi
    fi
        
done

echo "***Checking to exclude ND scans***"

#move ND anat scans to excluded

for file in "${bidsdir}/code/tmp_dcm2nii/${mrn}"/*nii.gz; do
    filename=$(basename "${file}")
    json=$(remove_ext "${file}")
    
    if [[ "${filename}" == *"anat"* ]]; then
        series_description=$(jq .SeriesDescription "${json}.json")
        if [[ "${series_description}" == *"ND"* ]]; then
            echo "${filename} is ND, moving to sourcedata/excluded_scans/"
            mv "${file}" "${json}.json" "${bidsdir}/sourcedata/excluded_scans/"
        fi
    fi
done
 
#echo " "
#echo " " 
echo "*** Multiple Runs Checking Type is $check_type ***"

# Deal with Mulitple Runs of a Scan
if [ "$check_type" = "manual" ]; then
    
    echo "Making code/run_check.txt for Review" 

    ls ${bidsdir}/code/tmp_dcm2nii/${mrn}/*nii.gz | grep -v fmap| grep run >> ${bidsdir}/code/temp.txt

    for i in `cat temp.txt`; do 
        file_base=`remove_ext $i`
        filename=`basename ${i}`
        task=`echo $filename | cut -d '_' -f2` 
        num_task=`cat temp.txt | grep $task | grep nii.gz | wc -l`
        if [[ $num_task == 1 ]]; then
            echo "Only 1 run of $task"
        else
            echo $i >> ${bidsdir}/code/run_check.txt
        fi
    done

    echo " " >> ${bidsdir}/code/run_check.txt


elif [ "$check_type" = "automatic" ]; then
    
    for i in `ls ${bidsdir}/code/tmp_dcm2nii/${mrn}/*nii.gz | grep -v fmap| grep -v head`; do
        filename=`basename ${i}` 
        
        type=`echo $filename | cut -d '_' -f2 | cut -d '-' -f1` 
        if [[ $type == func ]] ; then
            task=`echo $filename | cut -d '_' -f3 | cut -d '-' -f2`  
        elif [[ $type = anat ]]; then
            task=`echo $filename | cut -d '_' -f2 | cut -d '-' -f2`
        fi
        
        num_task=`ls ${bidsdir}/code/tmp_dcm2nii/${mrn}/*nii.gz | grep -v fmap| grep -v head | grep $task | grep nii.gz | wc -l`

        if [[ $num_task == 1 ]]; then
            echo "Only 1 run of $task"
        else
            move=`ls ${bidsdir}/code/tmp_dcm2nii/${mrn}/*nii.gz | grep -v fmap| grep -v head | grep $task | head -n -1`
            keep=`ls ${bidsdir}/code/tmp_dcm2nii/${mrn}/*nii.gz | grep -v fmap| grep -v head | grep $task | tail -1`
            
            keep_b=`basename $keep`
            echo "Keeping $keep_b"
            
            for j in $move; do 
                name=`basename $j`
                echo "Moving $name"
                file_base=`remove_ext $j` 
                mv $j ${bidsdir}/sourcedata/excluded_scans 
                mv ${file_base}.json ${bidsdir}/sourcedata/excluded_scans 
            done
        fi
    done
fi

