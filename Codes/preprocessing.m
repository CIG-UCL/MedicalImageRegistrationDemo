% Preprocessing log
%
% This logs all the steps used to preprocess the IXI example
% data used for this demo.
%
%
% Author: Gary Hui Zhang (gary.zhang@ucl.ac.uk)
%
%

%% set up FSL

% basic set up
FSLDIR = setupFSL();

% set up the command name with full path
% 1) the command to reorient the data to the standard (MNI) orientation
reorient = [FSLDIR '/bin/fslreorient2std'];

% 2) the command to extract a subset of the data
extract = [FSLDIR '/bin/fslroi'];

%% set up path

% set the root folder
ROOT = '~/unix/research/matlab/MedicalImageRegistrationDemo';

% set the Data folder
DataDIR = [ROOT '/Data'];

% set the original IXI data folder
IXIoriginalDIR = [DataDIR '/IXIoriginal'];

% set the preprocessed IXI data folder
IXIpreprocessedDIR = [DataDIR '/IXIpreprocessed'];

%% reorient the T1 data to the standard (MNI) orientation

% set up the subject ID of the IXI data
IXIsubjIDs = {'IXI002-Guys-0828', 'IXI025-Guys-0852'};

% for each subject ID
for i = 1:length(IXIsubjIDs)
    % input file name with full path
    inputFilename = [IXIoriginalDIR '/' IXIsubjIDs{i} '-T1'];
    % output file name with full path
    outputFilename = [IXIpreprocessedDIR '/' IXIsubjIDs{i} '-T1'];
    % execute the reorientation
    disp([reorient ' ' inputFilename ' ' outputFilename]);
    unix([reorient ' ' inputFilename ' ' outputFilename]);
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
    % execute the extraction
    disp([extract ' ' inputFilename ' ' outputFilename ' ' options{i}]);
    unix([extract ' ' inputFilename ' ' outputFilename ' ' options{i}]);
end
