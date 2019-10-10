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
%   CPopescu     Feb4 2013                     Reverted back
%   JZollweg     August 2014        Ver 2.0    Add batch mode
%   JZollweg     July 2018          Ver 2.1    Customized for RavenX-NA
%   PDugan       Sept 2018                     Merged NA and AD for SPAWAR
%                                              integration.
%   PDugan       3-5-18                        Simplified path scripts
%   PDugan       10-5-19                       Phone config


if nargin < 1
    mode = 'all';
end

if ~any(strcmp(mode, {'batch', 'detect', 'display', 'noise', 'all'}))
    mode = 'src';
end

% create the RavenX project folder
hdir = fileparts(mfilename('fullpath'));

% add external components
extern_dir = [hdir filesep 'extern'];
path([extern_dir], path);
path([extern_dir, filesep, 'silbido'], path);
path([extern_dir, filesep, 'vlfeat' filesep, 'toolbox'], path); vl_setup;

% add config path
config_dir = [hdir filesep 'config'];
path([config_dir], path);

% add rxlibs path
rxlibs_dir = [hdir filesep 'rxlibs'];
path([rxlibs_dir], path);

% add rxcodec path
rxcodec_dir = [hdir filesep 'rxcodec'];
path([rxcodec_dir], path);




% path for auto detect
if exist('auto_detect', 'dir')
    path([hdir, filesep, 'auto_detect'], path);
else
    disp('auto_detect not found');
    exit
end

if exist('aena', 'dir')
    path([hdir, filesep, 'aena'], path);
else
    disp('aena not found');
    exit
end

if exist('noise_analyzer', 'dir')
    path([hdir, filesep, 'noise_analyzer'], path);
else
    disp('noise_analyzer not found');
    exit
end


% paths for utilapps and acoustat
if exist('utilapps', 'dir')
    path([hdir, filesep, 'utilapps'], path);
    path([hdir, filesep, 'utilapps' filesep, 'Acoustat'], path);
    path([hdir, filesep, 'utilapps' filesep, 'SelectionTableApp'], path);
else
    disp('utilapps not found');
    exit
end

% paths for rxutils
if exist('RXutils', 'dir')
    path([hdir, filesep, 'RXutils'], path)
    import utils.*;
else
    disp('RXutils not found');
    exit
end


if  strcmp(mode, 'batch')
    return
end

% noise pkg path
path([hdir, filesep fullfile('aena', 'NoiseReportBrowser')],path);
path([hdir, filesep fullfile('aena', 'BandAnalyzer')], path);
path([hdir, filesep fullfile('aena', 'AENA_Utils')], path);
path([hdir, filesep fullfile('aena', 'AENA_Utils', 'icons')], path);

% auto detect pkg
path([hdir, filesep fullfile('auto_detect','DCpkgs')],path);
path([hdir, filesep fullfile('auto_detect','DCL')], path);
path([hdir, filesep fullfile('auto_detect','RTUtils')], path);
path([hdir, filesep fullfile('auto_detect','RTUtils', 'FileParser')], path);
path([hdir, filesep fullfile('auto_detect','RTUtils', 'DeLMA')], path);

% run this for fun.. Displays the BRP splash screen
utils.BrpInit(hdir, mode)