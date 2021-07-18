function createGrids()
% function createGrids()
%
% This function creates a set of regular grid images to help visualise
% geometric transformations estimated by image registration algorithms.
%
%
% Requirements: the following two softwares are required.
%
% 1. DTI-TK
%
% 2. FSL
%
%
% Author: Gary Hui Zhang (gary.zhang@ucl.ac.uk)
%
%

%% set up DTI-TK

setupDTITK();

%% set up FSL

setupFSL();

%% set up path

% set the root folder
ROOT = '~/unix/research/matlab/MedicalImageRegistrationDemo';

% set the Data folder
DataDIR = [ROOT '/Data'];

% set the original IXI data folder
IXIoriginalDIR = [DataDIR '/IXIoriginal'];

%% set up the subject ID of the IXI data

% here we just make use of one of the provided subjects
IXIsubjID = 'IXI002-Guys-0828';

%% create the grid volumes

% the target volume for the grid volumes with full path
%
% note that unlike FSL, DTI-TK requires the suffix of the NIfTI files to
% be included
%
targetImageFilename = [IXIoriginalDIR '/' IXIsubjID '-T2.nii.gz'];

% set up the command string to create the grid volumes
cmd = ['SVtool -target ' targetImageFilename ' -grid'];

% print out the command string
disp(cmd);

% execute the command
unix(cmd);

%% match the NIfTI header info fully

% 
% DTI-TK does not duplicate the target volume's full header; we use a FSL
% tool to fix this.
%

files = {'gridx', 'gridy', 'gridz'};

for i=1:length(files)
    % set up the command string to duplicate header
    cmd = ['fslcpgeom ' targetImageFilename ' ' files{i}];
    
    % print out the command string
    disp(cmd);
    
    % execute the command
    unix(cmd);
end

%% end of function
end