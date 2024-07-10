# Prep_Data_for_fMRIprep notes:
K23 BIDSdir: /lab-share/Neuro-Cohen-e2/Groups/ASD_FP_IRB34345/original_data_bids

## 0_fw_download.sh: 
downloads dicoms from fw as .tar here:
/lab-share/Neuro-Cohen-e2/Groups/ASD_FP_IRB34345/original_data_bids/sourcedata/[MRN].tar
    
## 1_run_prep_fw_data.sh: 
extracts files, creates dcm2bids subject list

## 2_run_dcm2bids.sh: 
**conda activate dcm2bids**

input:/lab-share/Neuro-Cohen-e2/Groups/ASD_FP_IRB34345/original_data_bids/sourcedata
runs dcm2niix, puts those outputs here:
/lab-share/Neuro-Cohen-e2/Groups/ASD_FP_IRB34345/original_data_bids/code/tmp_dcm2nii/[MRN]
runs check_nifit.sh, moves excluded scans here:
/lab-share/Neuro-Cohen-e2/Groups/ASD_FP_IRB34345/original_data_bids/sourcedata/excluded_scans/
runs dcm2bids, puts those outputs here:
/lab-share/Neuro-Cohen-e2/Groups/ASD_FP_IRB34345/original_data_bids/[sub-ID]
creates fmriprep subject list
    
## 2b_edit_json.sh:
edits Intendedfor field in json files, as current BIDS format is not compatible with this verison of fmriprep
    
## 3_run_fmriprep.sh:
*needs a version of singularity 3.7 or higher (should load singularity-ce/3.8.3 in the script)*

input:/lab-share/Neuro-Cohen-e2/Groups/ASD_FP_IRB34345/original_data_bids
runs fmriprep, put those outputs here:
/lab-share/Neuro-Cohen-e2/Groups/ASD_FP_IRB34345/original_data_bids/derivatives/fmriprep
 
