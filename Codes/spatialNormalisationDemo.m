function spatialNormalisationDemo()
% function spatialNormalisationDemo()
%
% This function provides the Spatial Normalisation Demo.
%
% Spatial normalisation is the task of placing brain scans of different 
% subjects into a common space.  This process involves between-subject
% image registration.  The common space typically chosen is the Montreal 
% Neurological Institute (MNI) space.
% 
% In this demonstration, the T1-weighted (T1w) scans of two subjects are 
% being spatially normalised to the MNI space.
% 
% Under this scenario, the set up of the corresponding registration task
% consists of:
%
% 1. Designating the fixed and moving images
%
%    fixed image <- the MNI152_T1_2mm (shipped with FSL)
%
%    moving image <- the T1w image of a subject
%
% 2. Choosing the appropriate class of geometric transformations
%
%    For the purpose of spatially aligning images from different subjects, 
%    non-linear transformations are usually necessary.
%
%    A common strategy is to first find the best linear tranformation to
%    align different subjects at the global level, then follow with 
%    finding the best non-linear transformation to align them at the local 
%    level. this will be the strategy we use in this demo.
%
% 3. Choosing the appropriate similarity measure
%
%    For the purpose of aligning two images with the same contrast, it is 
%    possible to use simple intensity-based similarity measures, such as 
%    the sum-of-squared-difference (SSD).
%
%
% This demo makes use of the linear and non-linear image registration tools
% FLIRT and FNIRT shipped with FSL.
%
%
% Author: Gary Hui Zhang (gary.zhang@ucl.ac.uk)
%
%

%% set up FSL

FSLDIR = setupFSL();

%% change to the demo's Data folder and set up the data path

% remember the current folder
originalDIR = pwd();

% change to the Data folder
toDataDIR();

% set the preprocessed IXI data folder
IXIpreprocessedDIR = 'IXIpreprocessed';

%% set up the directory for this demo
spatialNormalisationDIR = 'spatialNormalisation';

%% set up the subject ID of the IXI data

IXIsubjIDs = {'IXI002-Guys-0828', 'IXI025-Guys-0852'};

%% set up the common fixed image

% designate the fixed image
% the low-resolution version of the template is used for registration
fixedImage = 'MNI152_T1_2mm';
% the high-resolution version of the template is used for resampling
fixedImageHighRes = 'MNI152_T1_1mm';

% the fixed image with full path
fixedImageFilename = [FSLDIR '/data/standard/' fixedImage];
fixedImageHighResFilename = [FSLDIR '/data/standard/' fixedImageHighRes];

%% reslice the moving image in the same voxel space as the fixed image
%
% this is to allow the mis-alignment between the two images, before the
% registration, to be visualised; this is otherwise not possible, because 
% the two images have different voxel spaces (different voxel sizes and 
% dimensions).
%
% this is achieved by applying the identity transformation, which is
% provided in the format compatible with FLIRT. in FLIRT, linear 
% transformations are represented as 4-by-4 matrix and saved as a text
% file, with an optional suffix 'mat', which should not to be confused
% with the mat file used by Matlab.
%
% Also in FLIRT, fixed image is referred to as the reference image, with 
% moving image as the input image.
%

% file name for the identity transformation
identityFilename = [FSLDIR '/etc/flirtsch/' 'ident.mat'];

% for each subject
for i = 1:length(IXIsubjIDs)
    % designate the moving image
    movingImage = [IXIsubjIDs{i} '-T1'];
    
    % the moving image with full path
    movingImageFilename = [IXIpreprocessedDIR '/' movingImage];
    
    % file name for the resliced moving image
    outputImageFilename = [spatialNormalisationDIR '/' movingImage];
    
    % set up the command string to apply the identity transformation to
    % the moving image
    cmd = ['flirt -in ' movingImageFilename ' -ref ' fixedImageHighResFilename ' -applyxfm -init ' identityFilename ' -out ' outputImageFilename ' -v '];
    
    % print out the command string
    disp(cmd);
    
    % execute the command
    unix(cmd);
end

%% estimate the linear transformation to align the moving image with the fixed
%
% we use FLIRT to estimate the linear transformation with a degree of 
% freedom of 12.  as this is the default choice in FLIRT, no need
% to provide an input to the '-dof' option.
%

%
% in FLIRT, the similarity measures are known as the cost. the default 
% choice is correlation ratio (corratio), which is suitable for registering
% two images of the same contrast. so no need to provide any inputs to the
% '-cost' and '-searchcost' options.
%

% for each subject
for i = 1:length(IXIsubjIDs)
    % designate the moving image
    movingImage = [IXIsubjIDs{i} '-T1'];
    
    % the moving image with full path
    movingImageFilename = [IXIpreprocessedDIR '/' movingImage];
    
    % file name for the estimated linear transformation
    transformFilename = [spatialNormalisationDIR '/' movingImage 'to' fixedImage '.mat'];
    
    % set up the command string to execute the registration
    cmd = ['flirt -in ' movingImageFilename ' -ref ' fixedImageFilename ' -omat ' transformFilename ' -v '];
    
    % print out the command string
    disp(cmd);
    
    % execute the command
    unix(cmd);
end

%% transform the moving image with the estimated linear transformation
%
% the resulting moving image should now be aligned with the fixed image,
% achieving spatial alignment, i.e., each voxel now corresponds to some 
% common anatomical location between the two images.
%

% for each subject
for i = 1:length(IXIsubjIDs)
    % designate the moving image
    movingImage = [IXIsubjIDs{i} '-T1'];
    
    % the moving image with full path
    movingImageFilename = [IXIpreprocessedDIR '/' movingImage];
    
    % file name for the estimated linear transformation
    transformFilename = [spatialNormalisationDIR '/' movingImage 'to' fixedImage '.mat'];

    % file name for the transformed moving image
    outputFilename = [spatialNormalisationDIR '/' movingImage 'to' fixedImageHighRes '-linear'];
    
    % set up the command string to transform the moving image
    cmd = ['flirt -in ' movingImageFilename ' -ref ' fixedImageHighResFilename ' -applyxfm -init ' transformFilename ' -out ' outputFilename];
    
    % print out the command string
    disp(cmd);
    
    % execute the command
    unix(cmd);
end

%% visualise the estimated linear transformation with grid volumes
%
% grid volumes can be used to visualise the characteristic of geometric
% transformations.  it works by creating grid volumes that match the voxel
% space of the moving image and transform the grid volumes with the
% transformation estimated to align the moving image to the fixed.
%
% in this demo, we will use it to visualise the linear transformation 
% estimated to align the IXI subject - IXI002-Guys-0828.
%

% designate the moving image
movingImage = [IXIsubjIDs{1} '-T1'];

% the moving image with full path
movingImageFilename = [IXIpreprocessedDIR '/' movingImage];

% create the grid volumes that match the voxel space of the moving image
createGrids(movingImageFilename);

% there are three grid volumes - one for visualising the effect of a
% transformation along one of the three orthogonal planes:
%
%   1. ${prefix}-gridx.nii.gz - sagittal plane
%   
%   2. ${prefix}-gridy.nii.gz - coronal plane
%   
%   3. ${prefix}-gridz.nii.gz - axial plane
%
% in this demo, as an example, we will look along the sagittal plane, which
% turns out to be the most interesting for this subject
%
gridImageFilename = ['grids/' movingImage '-gridx'];

% file name for the transformed moving image
outputFilename = [spatialNormalisationDIR '/' movingImage 'to' fixedImageHighRes '-linear'];

% file name for the transformed moving image
outputFilename = [outputFilename '-gridx'];

% file name for the estimated linear transformation
transformFilename = [spatialNormalisationDIR '/' movingImage 'to' fixedImage '.mat'];

% set up the command string to transform the moving image
cmd = ['flirt -in ' gridImageFilename ' -ref ' fixedImageHighResFilename ' -applyxfm -init ' transformFilename ' -out ' outputFilename];

% print out the command string
disp(cmd);

% execute the command
unix(cmd);

%% estimate the non-linear transformation to align the moving image with the fixed
%
% with the linear transformation estimated, which accounts for the global 
% differences between the fixed and moving images, the non-linear 
% transformation, which accounts for the local differences, can be 
% estimated, with the linear transformation providing the starting point. 
%
% This demo achieves this with FNIRT.  It initialises with the linear
% transformation estimated with FLIRT and estimates a non-linear
% transformation that incorporates the initial linear transformation.
%
% Unlike FLIRT, similarity measure is not a configurable option in FNIRT.
% FNIRT implements the sum-of-squared-difference (SSD) of intensities, 
% which is suitable for registering two images of the same contrast.
%

% specify flirt configuration file optimised for aligning to MNI template
fnirtCNF = [FSLDIR '/etc/flirtsch/T1_2_MNI152_2mm.cnf'];

% for each subject
for i = 1:length(IXIsubjIDs)
    % designate the moving image
    movingImage = [IXIsubjIDs{i} '-T1'];
    
    % the moving image with full path
    movingImageFilename = [IXIpreprocessedDIR '/' movingImage];
    
    % file name for the initial linear transformation
    initialTransformFilename = [spatialNormalisationDIR '/' movingImage 'to' fixedImage '.mat'];
    
    % file name for the estimated non-linear transformation
    transformFilename = [spatialNormalisationDIR '/' movingImage 'to' fixedImage '_warpcoef'];
    
    % file name for the fnirt log
    logFilename = [spatialNormalisationDIR '/' movingImage 'to' fixedImage '_fnirt.log'];
    
    % set up the command string to execute the registration
    cmd = ['fnirt --config=' fnirtCNF ' --in=' movingImageFilename ' --aff=' initialTransformFilename ' --cout=' transformFilename ' --logout=' logFilename ' -v '];
    
    % print out the command string
    disp(cmd);
    
    % execute the command
    unix(cmd);
end

%% transform the moving image with the estimated non-linear transformation
%
% the resulting moving image should now be aligned with the fixed image,
% achieving spatial alignment, i.e., each voxel now corresponds to some 
% common anatomical location between the two images.
%

% for each subject
for i = 1:length(IXIsubjIDs)
    % designate the moving image
    movingImage = [IXIsubjIDs{i} '-T1'];
    
    % the moving image with full path
    movingImageFilename = [IXIpreprocessedDIR '/' movingImage];
    
    % file name for the estimated non-linear transformation
    transformFilename = [spatialNormalisationDIR '/' movingImage 'to' fixedImage '_warpcoef'];
    
    % file name for the transformed moving image
    outputFilename = [spatialNormalisationDIR '/' movingImage 'to' fixedImageHighRes '-nonlinear'];
    
    % set up the command string to transform the moving image
    cmd = ['applywarp -i ' movingImageFilename ' -r ' fixedImageHighResFilename ' -w ' transformFilename ' -o ' outputFilename];
    
    % print out the command string
    disp(cmd);
    
    % execute the command
    unix(cmd);
end

%% visualise the estimated non-linear transformation with grid volumes
%
% as above for the linear transformation, we will use grid volumes to 
% visualise the non-linear transformation estimated to align the IXI
% subject - IXI002-Guys-0828.
%

% designate the moving image
movingImage = [IXIsubjIDs{1} '-T1'];

% there are three grid volumes - one for visualising the effect of a
% transformation along one of the three orthogonal planes:
%
%   1. ${prefix}-gridx.nii.gz - sagittal plane
%   
%   2. ${prefix}-gridy.nii.gz - coronal plane
%   
%   3. ${prefix}-gridz.nii.gz - axial plane
%
% in this demo, as an example, we will look along the sagittal plane, which
% turns out to be the most interesting for this subject
%
gridImageFilename = ['grids/' movingImage '-gridx'];

% file name for the estimated non-linear transformation
transformFilename = [spatialNormalisationDIR '/' movingImage 'to' fixedImage '_warpcoef'];

% file name for the transformed moving image
outputFilename = [spatialNormalisationDIR '/' movingImage 'to' fixedImageHighRes '-nonlinear'];

% file name for the transformed moving image
outputFilename = [outputFilename '-gridx'];

% set up the command string to transform the moving image
cmd = ['applywarp -i ' gridImageFilename ' -r ' fixedImageHighResFilename ' -w ' transformFilename ' -o ' outputFilename];

% print out the command string
disp(cmd);

% execute the command
unix(cmd);

%% back to the original folder

cd(originalDIR);

%% end of function
end