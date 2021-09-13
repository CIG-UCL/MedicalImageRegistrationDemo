function preprocessing()
% function preprocessing()
%
% This function logs all the steps used to preprocess the IXI example
% data used for this demo.
%
%
% Author: Gary Hui Zhang (gary.zhang@ucl.ac.uk)
%
%

%% set up FSL

setupFSL();

%% change to the demo's Data folder and set up the data path

% remember the current folder
originalDIR = pwd();

% change to the Data folder
toDataDIR();

% set the original IXI data folder
IXIoriginalDIR = 'IXIoriginal';

% set the preprocessed IXI data folder
IXIpreprocessedDIR = 'IXIpreprocessed';

%% set up the subject ID of the IXI data

IXIsubjIDs = {'IXI002-Guys-0828', 'IXI025-Guys-0852'};

%% reorient the T1 data to the standard (MNI) orientation

% for each subject ID
for i = 1:length(IXIsubjIDs)
    % input file name with full path
    inputFilename = fullfile(IXIoriginalDIR, [IXIsubjIDs{i} '-T1']);
    
    % output file name with full path
    outputFilename = fullfile(IXIpreprocessedDIR, [IXIsubjIDs{i} '-T1']);
    
    % set up the command string to execute the reorientation
    cmd = ['fslreorient2std ' inputFilename ' ' outputFilename];
    
    % print out the command string
    disp(cmd);
    
    % execute the command
    unix(cmd);
end

%% extract brain regions

% extract command options: all x slices, all y slices, part of z slices
options = {'0 156 0 256 59 180', '0 156 0 256 81 180'};

% for each subject ID
for i = 1:length(IXIsubjIDs)
    % input file name with full path
    inputFilename = fullfile(IXIpreprocessedDIR, [IXIsubjIDs{i} '-T1']);
    
    % output file name with full path
    outputFilename = fullfile(IXIpreprocessedDIR, [IXIsubjIDs{i} '-T1']);
    
    % set up the command string to execute the reorientation
    cmd = ['fslroi ' inputFilename ' ' outputFilename ' ' options{i}];
    
    % print out the command string
    disp(cmd);
    
    % execute the command
    unix(cmd);
end

%% merge the first 16 3-D DWI volumes into a single 4-D DWI volume

% for each subject ID
for i=1:length(IXIsubjIDs)
    % input 3-D DWI's prefix with full path
    inputPrefix = fullfile(IXIoriginalDIR, [IXIsubjIDs{i} '-DTI-']);
    
    % output 4-D DWI file name with full path
    outputFilename = fullfile(IXIpreprocessedDIR, [IXIsubjIDs{i} '-DWI']);
    
    % set up the command string to execute the merging
    cmd = ['fslmerge -t ' outputFilename ' ' inputPrefix '0* ' inputPrefix '1[0-5]*'];
    
    % print out the command string
    disp(cmd);
    
    % execute the command
    unix(cmd);
end

%% extract brain regions from b=0 DWI

% for each subject ID
for i=1:length(IXIsubjIDs)
    % input b=0 DWI file name with full path
    inputFilename = fullfile(IXIoriginalDIR, [IXIsubjIDs{i} '-DTI-00']);
    
    % output brain mask prefix with full path
    outputPrefix = fullfile(IXIpreprocessedDIR, [IXIsubjIDs{i} '-DWI']);
    
    % set up the command string to execute brain extraction
    cmd = ['bet ' inputFilename ' ' outputPrefix ' -m -n -f 0.3'];
    
    % print out the command string
    disp(cmd);
    
    % execute the command
    unix(cmd);
end

%% estimate DTI from DWI

% for each subject ID
for i=1:length(IXIsubjIDs)
    % input 4-D DWI file name with full path
    inputDWIfilename = fullfile(IXIpreprocessedDIR, [IXIsubjIDs{i} '-DWI']);
    
    % input b=0 brain mask
    inputMaskFilename = fullfile(IXIpreprocessedDIR, [IXIsubjIDs{i} '-DWI_mask']);
    
    % input bval file name
    inputBvalFilename = fullfile(IXIoriginalDIR, 'bvals.txt');
    
    % input bvec file name
    inputBvecFilename = fullfile(IXIoriginalDIR, 'bvecs.txt');
    
    % output prefix
    outputPrefix = fullfile(IXIpreprocessedDIR, [IXIsubjIDs{i} '-DTI']);
    
    % set up the command string to execute DTI estimation
    cmd = ['dtifit -k ' inputDWIfilename ' -m ' inputMaskFilename ' -r ' inputBvecFilename ' -b ' inputBvalFilename ' -o ' outputPrefix];
    
    % print out the command string
    disp(cmd);
    
    % execute the command
    unix(cmd);
end

%% back to the original folder

cd(originalDIR);

%% end of function
end
