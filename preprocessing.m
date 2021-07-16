% Preprocessing

%% set up FSL
% get FSLDIR
FSLDIR=getenv('FSLDIR');

% set up FSLOUTPUTTYPE
setenv('FSLOUTPUTTYPE', 'NIFTI_GZ');

%% reorient to standard orientation
command=[FSLDIR '/bin/fslreorient2std'];
unix([command ' IXIoriginal/IXI002-Guys-0828-T1.nii.gz IXI002-T1.nii.gz']);
unix([command ' IXIoriginal/IXI025-Guys-0852-T1.nii.gz IXI025-T1.nii.gz']);
