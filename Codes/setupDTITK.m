function DTITK_ROOT = setupDTITK(inputDTITK_ROOT)
% function DTITK_ROOT = setupDTITK(inputDTITK_ROOT)
%
% This function sets up the environment for running DTITK tools from within
% Matlab.
%
% INPUT:
%
% 1. inputDTITK_ROOT - a string that specifies DTITK_ROOT, the full path
%    to the root directory of your DTITK installation.
%    
%    optional - if not provided, will read from the environment variable 
%    DTITK_ROOT
%
%
% OUTPUT:
%
% 1. DTITK_ROOT - a string that stores the value for DTITK_ROOT
%
%
% Author: Gary Hui Zhang (gary.zhang@ucl.ac.uk)
%
%

%% set up DTITKDIR

if (nargin < 1)
    % if no input arguments given, check if DTITK_ROOT is defined as an
    % environment variable, which can be retrieved with getenv
    DTITK_ROOT = getenv('DTITK_ROOT');
    
    % if not, the value of DTITK_ROOT for the system must be provided as
    % the input argument
    if isempty(DTITK_ROOT)
        % so inputDTITK_ROOT is needed
        fprintf('ERROR: Environment variable DTITK_ROOT undefined!\n\n');
        fprintf('Please provide the correct DTITK_ROOT for your system as the input argument\n\n');
        return;
    end
else
    % otherwise, use the provided DTITK_ROOT
    setenv('DTITK_ROOT', inputDTITK_ROOT);
    DTITK_ROOT = inputDTITK_ROOT;
end

%% end of function
end
