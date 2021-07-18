function imageFusionDemo()
% function imageFusionDemo()
%
% This function provides the Image Fusion Demo.
%
% Image fusion is achieved with within-subject image registration.  In
% this demonstration, the T1-weighted (T1w) scan of a subject is being
% fused with the corresponding T2-weighted (T2w) image.  
% 
% Under this scenario, the set up of the corresponding registration task
% consists of:
%
% 1. Designating the fixed and moving images
%
%    fixed image <- the T2w image
%
%    moving image <- the T1w image
%
% 2. Choosing the appropriate class of geometric transformations
%
%    For the purpose of fusing two images from the same image, linear
%    transformations are often adequate.
%
% 3. Choosing the appropriate similarity measure
%
%    For the purpose of fusing two images with different contrasts, such 
%    as T1w and T2w, information-theoretic measures, such as mutual 
%    information, is typically superior to similarity measures that 
%    compare image intensities directly, such as the sum-of-squared-
%    difference (SSD).
%
% This demo makes use of the linear image registration tool FLIRT
% shipped with FSL.
%
%
% Author: Gary Hui Zhang (gary.zhang@ucl.ac.uk)
%
%

%% set up FSL

% basic set up
FSLDIR = setupFSL();

% set up the command name with full path
%
% the command for linear registration tool FLIRT
flirt = [FSLDIR '/bin/flirt'];

%% set up path

% set the root folder
ROOT = '~/unix/research/matlab/MedicalImageRegistrationDemo';

% set the Data folder
DataDIR = [ROOT '/Data'];

% set the original IXI data folder
IXIoriginalDIR = [DataDIR '/IXIoriginal'];

% set the preprocessed IXI data folder
IXIpreprocessedDIR = [DataDIR '/IXIpreprocessed'];

%% set up the directory for this demo
imageFusionDIR = [DataDIR '/imageFusion'];

%% set up the subject ID of the IXI data

IXIsubjIDs = {'IXI002-Guys-0828', 'IXI025-Guys-0852'};

%% reslice the T1w image in the same voxel space as the T2w image
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

% for each subject
for i = 1:length(IXIsubjIDs)
    % fixed image file name with full path
    fixedImageFilename = [IXIoriginalDIR '/' IXIsubjIDs{i} '-T2'];
    
    % moving image file name with full path
    movingImageFilename = [IXIpreprocessedDIR '/' IXIsubjIDs{i} '-T1'];
    
    % file name for the identity transformation
    identityFilename = [IXIpreprocessedDIR '/' 'identity.mat'];
    
    % file name for the resliced moving image
    outputImageFilename = [imageFusionDIR '/' IXIsubjIDs{i} '-T1'];
    
    % set up the command string to apply the identity transformation to
    % the moving image
    cmd = [flirt ' -in ' movingImageFilename ' -ref ' fixedImageFilename ' -applyxfm -init ' identityFilename ' -out ' outputImageFilename ' -v '];
    
    % print out the command string
    disp(cmd);
    
    % execute the command
    unix(cmd);
end

%% estimate the transformation that aligns the moving image to the fixed
%
% the central task of image registration is to find the geometric
% transformation that best aligns the moving image to the fixed image, as
% deemed by some choice similarity measure chosen to assess the quality of
% alignment.
%
% in this demo, we will consider first the rigid transformations, which has
% a degree of freedom (d.o.f.) 6.
%
% in FLIRT, this is specified by specifying the d.o.f.
dof = '6';

%
% in FLIRT, the similarity measures are known as the cost.  The
% default choice is correlation ratio (corratio).
%
% For this demo, we will make use of mutual information.
similarity = 'mutualinfo';

% for each subject
for i = 1:length(IXIsubjIDs)
    % fixed image file name with full path
    fixedImageFilename = [IXIoriginalDIR '/' IXIsubjIDs{i} '-T2'];
    
    % moving image file name with full path
    movingImageFilename = [IXIpreprocessedDIR '/' IXIsubjIDs{i} '-T1'];
    
    % file name for the estimated linear transformation
    transformFilename = [imageFusionDIR '/' IXIsubjIDs{i} '-T1toT2.mat'];
    
    % set up the command string to execute the registration
    cmd = [flirt ' -in ' movingImageFilename ' -ref ' fixedImageFilename ' -cost ' similarity ' -searchcost ' similarity ' -dof ' dof ' -omat ' transformFilename ' -v '];

    % print out the command string
    disp(cmd);
    
    % execute the command
    unix(cmd);
end

%% transform the moving image with the estimated transformation
%
% the resulting moving image should now be aligned with the fixed image,
% achieving image fusion, i.e., at each voxel, representing some anatomical
% location, the corresponding T1w and T2w intensity values can be found.
%

for i = 1:length(IXIsubjIDs)
    % fixed image file name with full path
    fixedImageFilename = [IXIoriginalDIR '/' IXIsubjIDs{i} '-T2'];
    
    % moving image file name with full path
    movingImageFilename = [IXIpreprocessedDIR '/' IXIsubjIDs{i} '-T1'];
    
    % file name for the estimated linear transformation
    transformFilename = [imageFusionDIR '/' IXIsubjIDs{i} '-T1toT2.mat'];

    % file name for the transformed moving image
    outputFilename = [imageFusionDIR '/' IXIsubjIDs{i} '-T1toT2'];
    
    % set up the command string to transform the moving image
    cmd = [flirt ' -in ' movingImageFilename ' -ref ' fixedImageFilename ' -applyxfm -init ' transformFilename ' -out ' outputFilename];
    
    % print out the command string
    disp(cmd);
    
    % execute the command
    unix(cmd);
end

%% end of function
end