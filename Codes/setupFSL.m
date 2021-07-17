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
%    optional - default to '/opt/fsl'
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

% set up FSLDIR
% 
% First, check if FSLDIR is defined as an environment variable, which can
% be retrieved with getenv
%
FSLDIR = getenv('FSLDIR');

% If not, the value of FSLDIR for the system must be provided as the first
% input argument
if isempty(FSLDIR)
    % So FSLDIR still needs to be defined
    if (nargin < 1)
        % So FSLDIR not provided as the first input argument
        fprintf('ERROR: Environment variable FSLDIR undefined!\n\n');
        fprintf('Please provide the correct FSLDIR for your system as the first input argument\n\n');
        return;
    end
    
    % Otherwise, use the provided FSLDIR
    setenv('FSLDIR', inputFSLDIR);
    FSLDIR = inputFSLDIR;
end

% set up FSLOUTPUTTYPE
if (nargin < 2)
    % So FSLOUTPUTTYPE not provided as the second input argument
    setenv('FSLOUTPUTTYPE', 'NIFTI_GZ');
else
    % Otherwise, use the provided FSLOUTPUTTYPE
    setenv('FSLOUTPUTTYPE', inputFSLOUTPUTTYPE);
end

end
