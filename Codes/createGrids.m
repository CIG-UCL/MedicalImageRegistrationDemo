function createGrids(target)
% function createGrids(target)
%
% This function creates a set of regular grid images to help visualise
% geometric transformations estimated by image registration algorithms.
%
%
% INPUT:
%
% 1. target - a string specifying the file name of a NIfTI file; the voxel
%    space of this file will be used for the output grid volumes.
%
%    IMPORTANT: the file name should not included the suffix.
%
%
% OUTPUT: the output will be a set of three volumes in the Data/grids
%         folder
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

%% check an input is provided
if (nargin < 1)
    fprintf('Please provide the name of a target NIfTI volume\n');
    fprintf('Include full path but not the NIfTI suffix\n\n');
    return;
end

%% set up DTI-TK

setupDTITK();

%% set up FSL

setupFSL();

%% change to the demo's Data folder and set up the data path

% remember the current directory
originalDIR = pwd();

% change to the Data folder
toDataDIR();

% change to the grids folder
cd('grids');

%% create the grid volumes

% the target volume for the grid volumes with full path
%
% note that unlike FSL, DTI-TK requires the suffix of the NIfTI files to
% be included
%
targetImageFilename = fullfile(originalDIR, [target '.nii.gz']);

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

grids = {'gridx', 'gridy', 'gridz'};

for i=1:length(grids)
    % set up the command string to duplicate header
    cmd = ['fslcpgeom ' targetImageFilename ' ' grids{i}];
    
    % print out the command string
    disp(cmd);
    
    % execute the command
    unix(cmd);
end

%% rename the grid volumes
%
% rename the grid volumes to include the target name as the prefix.
%

% this bit will not rename the files but also move the files to the same
% folder as the target
for i=1:length(grids)
    % set up the command string to renaming
    cmd = ['mv ' grids{i} '.nii.gz ' fullfile(originalDIR, target) '-' grids{i} '.nii.gz'];
    
    % print out the command string
    disp(cmd);
    
    % execute the command
    unix(cmd);
end

% we now need to move them back to grids folder
for i=1:length(grids)
    % set up the command string to moving
    cmd = ['mv ' fullfile(originalDIR, target) '-' grids{i} '.nii.gz .'];
    
    % print out the command string
    disp(cmd);
    
    % execute the command
    unix(cmd);
end

%% when done, change back to the original working folder

cd(originalDIR);

%% end of function
end
