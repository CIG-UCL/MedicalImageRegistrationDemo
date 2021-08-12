function toDataDIR()
% function toDataDIR()
%
% This function changes the working directory to the Data folder of the
% demo.
%
%
% Author: Gary Hui Zhang (gary.zhang@ucl.ac.uk)
%
%

% get this function's full path
thisFunctionFullPath = mfilename('fullpath');

% get the name of the directory where this function is
CodesDIR = fileparts(thisFunctionFullPath);

% change to the Codes folder
cd(CodesDIR)

% change to the Data folder
cd(fullfile('..','Data'));

%% end of function
end
