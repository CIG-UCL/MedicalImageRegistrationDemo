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

%% set up path

% set the root folder
ROOT = '~/unix/research/matlab/MedicalImageRegistrationDemo';

% set the Data folder
DataDIR = [ROOT '/Data'];

% set the original IXI data folder
IXIoriginalDIR = [DataDIR '/IXIoriginal'];

% set the preprocessed IXI data folder
IXIpreprocessedDIR = [DataDIR '/IXIpreprocessed'];

%% set up the subject ID of the IXI data

IXIsubjIDs = {'IXI002-Guys-0828', 'IXI025-Guys-0852'};

%% reorient the T1 data to the standard (MNI) orientation

% for each subject ID
for i = 1:length(IXIsubjIDs)
    % input file name with full path
    inputFilename = [IXIoriginalDIR '/' IXIsubjIDs{i} '-T1'];
    
    % output file name with full path
    outputFilename = [IXIpreprocessedDIR '/' IXIsubjIDs{i} '-T1'];
    
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
    inputFilename = [IXIpreprocessedDIR '/' IXIsubjIDs{i} '-T1'];
    
    % output file name with full path
    outputFilename = [IXIpreprocessedDIR '/' IXIsubjIDs{i} '-T1'];
    
    % set up the command string to execute the reorientation
    cmd = ['fslroi ' inputFilename ' ' outputFilename ' ' options{i}];
    
    % print out the command string
    disp(cmd);
    
    % execute the command
    unix(cmd);
end

%% end of function
end
