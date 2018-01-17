function ravenx_setpath_src(mode)
%  Routine:
%       SetPath_src
%
%  Inputs:
%       mode
%  Outputs:
%       none, but paths for ASE_Sedna are set up
%  Description:
%       SetPath_src, routine establishes paths for the PRBA libraries.
%
% History
%   PDugan       January 2009       Ver 1.0    January 2009
%   JZollweg     March 2011         Ver 1.1    Make usable on non-PCs
%   PDugan       March 2011         Ver 1.2    Added mode variable for
%                                              developers
%   JZollweg     December 2011      Ver 1.3    Made mode variable an input
%  CPopescu 2/4/2013 Reverted back
%   JZollweg     August 2014        Ver 2.0    Add batch mode

if ~any(strcmp(mode, {'batch', 'detect', 'display', 'noise'}))
    mode = 'src';
end

% create the RavenX project folder
 hdir = fileparts(mfilename('fullpath'));

% add submodules 
submodule_dir = [hdir filesep 'extern'];

path([submodule_dir, filesep, 'silbido'], path);
path([submodule_dir, filesep, 'gpl', filesep, 'code'], path);
path([submodule_dir, filesep, 'vlfeat' filesep, 'toolbox'], path); vl_setup;
path([submodule_dir, filesep, 'horiharm'], path);
path([submodule_dir, filesep, 'dtp1d'], path);
path([submodule_dir, filesep, 'dtp1d' filesep, 'parameter files'], path);
path([submodule_dir, filesep, 'asr'], path);
path([submodule_dir, filesep, 'asrpt'], path);



% paths for acoustat
path([hdir, filesep, 'auto_detect'], path);
path([hdir, filesep, 'utilapps'], path);
path([hdir, filesep, 'utilapps' filesep, 'Acoustat'], path);


if exist('RXutils', 'dir')
    path([hdir, filesep, 'RXutils'], path)
    import utils.*;
else
    disp('RXutils not found');
    exit
end



if  strcmp(mode, 'batch')
    path([hdir, filesep, 'AENA', filesep, 'NoiseAnalyzer'], path)
    path([hdir, filesep, 'DCL', filesep, 'DeLMA'], path)
%     path([hdir, filesep, 'DCL', filesep, 'AlgClasses'], path)
    
    path([hdir, filesep, 'DCL'], path)    
    return
end

utils.BrpInit(hdir, mode)
