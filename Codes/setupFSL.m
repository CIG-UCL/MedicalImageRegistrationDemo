function FSLDIR = setupFSL(inputFSLDIR, inputFSLOUTPUTTYPE)
% function FSLDIR = setupFSL(inputFSLDIR, inputFSLOUTPUTTYPE)
%
% This function sets up the environment for running FSL tools from within
% Matlab.
%
% INPUT:
%
% 1. inputFSLDIR - a string that specifies FSLDIR, the full path to the
%    root directory of your FSL installation.
%    
%    optional - if not provided, will read from the environment variable 
%    FSLDIR
%
% 2. inputFSLOUTPUTTYPE - a string that specifies FSLOUTPUTTYPE, which
%    defines the desired NIfTI file format to use.
%    
%    optional - default to 'NIFTI_GZ'
%
%
% OUTPUT:
%
% 1. FSLDIR - a string that stores the value for FSLDIR
%
%
% Author: Gary Hui Zhang (gary.zhang@ucl.ac.uk)
%
%

%% set up FSLDIR

if (nargin < 1)
    % if no input arguments given, check if FSLDIR is defined as an
    % environment variable, which can be retrieved with getenv
    FSLDIR = getenv('FSLDIR');
    
    % if not, the value of FSLDIR for the system must be provided as the 
    % first input argument
    if isempty(FSLDIR)
        % so inputFSLDIR is needed
        fprintf('ERROR: Environment variable FSLDIR undefined!\n\n');
        fprintf('Please provide the correct FSLDIR for your system as the first input argument\n\n');
        return;
    end
else
    % otherwise, use the provided FSLDIR
    setenv('FSLDIR', inputFSLDIR);
    FSLDIR = inputFSLDIR;    
end

%% update PATH to include FSL tools

% get the current PATH
currentPATH = getenv('PATH');

% append the path to FSL tools
updatedPATH = [currentPATH ':' FSLDIR '/bin'];

% update the PATH environment variable
setenv('PATH', updatedPATH);

%% set up FSLOUTPUTTYPE

if (nargin < 2)
    % so FSLOUTPUTTYPE not provided as the second input argument
    % use the default
    setenv('FSLOUTPUTTYPE', 'NIFTI_GZ');
else
    % otherwise, use the provided FSLOUTPUTTYPE
    setenv('FSLOUTPUTTYPE', inputFSLOUTPUTTYPE);
end

%% end of function
end
