function Launch_Main(mode)
%
%  Routine:
%       Launch_Main
%
%  Inputs:
%       A string to select path options
%
%  Outputs:
%       Sedna GUI, DeLMA GUI, or batch job
%
%  Description:
%       SetPath_src, routine establishes paths for the PRBA libraries.
%
% History
%   PDugan   Jan 2009
%
%   msp2  9 Oct 2010
%     User options for which copy of XBAT to use.
%
%   msp2 12 Nov 2010
%     Moves XBAT paths to end of PATHDEF
%     Option to SVN update ASE Triton and all modules
%     Option to SVN checkout XBAT in c:\XBAT_R5
%     Help menu with About, Create JIRA issue, known bugs, change password
%     Version number displayed in splash screen and in Help > About
%     Transaction log in GUI
%
%   PDugan   Apr 2011
%     Cleaned up merge and added code to save a configuraiton variable
%     which saves the path of the local XBAT copy. This will be helpful to
%     make sure RA machines stay in sync.
%
%   PDugan   Apr 2011
%     Cleaned up merge and added code to save a configuraiton variable
%     which saves the path of the local XBAT copy. This will be helpful to
%     make sure RA machines stay in sync.
%
%   JZollweg Dec 2011
%     Added 'mode' argument to allow different invocations without editing
%     a file.
%
%   JZollweg August 2014
%     Removed reference to XBAT and revised to allow running in batch
%
%   PDugan Sept 2018
%     Added ALL case to launch all the matlab components in raven-x
%
%   PDugan Apr 2019
%     Added code to paint window title-bar for MATLAB MAIN screen
%      
%  Examples
%     Launch_Main - starts ASE_Sedna with the default paths
%     Launch_Main('src') - same as above
%     Launch_Main('detect') - adds detector paths and starts DeLMA
%     Launch_Main('*.mat') - runs a NoiseAnalysis or Detection in batch mode
%     Launch_Main(<anything else>) - same as 'src'

% change desktop name, to keep things straight
[pth, nme, ~] = fileparts(pwd);
mDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
mFrame = mDesktop.get('MainFrame');
mFrame.setTitle(fullfile(pth, nme)); % replace 'MyTitle' with your desired title

% Move this to the startup script
% % first restore default path, this might be a pain for other apps, but we
% % need to make VERY certain that RavenX is alone in this MATLAB session!
% disp('Restoring MATLAB Default path');
% restoredefaultpath;


if nargin == 0
    mode = 'src';
end

if contains(mode, '.mat')
    ravenx_setpath_src('batch')
    batchjobs = who('-file', mode);
    load(mode);
    for b = batchjobs
        if eval(['isa(' b{:} ', ''NoiseAnalyzer'')'])
            analysis = NoiseAnalyzer.NoiseAnalysis(eval(b{:}));
            run(analysis);
        end
        if eval(['isa(' b{:} ', ''DeLMA'')'])
            detection = DeLMA.Detection(eval(b{:}));
            do_detect2(detection);
        end
    end
    return
end

ravenx_setpath_src(mode);

% launch NoiseAnalyzer
if strcmpi(mode, 'noise')
    RavenX_NoiseTools_MainGUI;
    return
end

% launch DeLMA
if strcmpi(mode, 'detect')
    
    
    v = ver('matlab');
    switch(v.Release)
    
        case {'(R2017a)','(R2017b)','(R2018a)'} 
            DeLMA_App_R2017a;    
            
        case {'(R2018b)'}
            DeLMA_App_R2018b;
            
        otherwise
            DeLMA_App_R2019a;
    end
    
end

if strcmpi(mode, 'SoundAndRateConverter')

    import SoundAndRateConverter.*
    SoundAndRateConverter;
    
end
    