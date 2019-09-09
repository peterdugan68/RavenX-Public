function [outputArg1,outputArg2] = getProcPlanStats(inputArg1,inputArg2)
%
%

ChanMode = HpcAppManage.ChanMode;

% Step-A
% specify input sound folder, highest level and build sound plan, save if 
% it does not exist.
projPath = '\\hpcnas\rx_store\project_data\ravenx_data\Proj_2017_HDR_GoMex_80670\Proj_80670GOMEX02';
sndPath = uigetdir(projPath, 'Pick a directory that contains sound files');

[~,nme, ~] = fileparts(sndPath);



% Step-B
% specify output folder, this will be the actual hours recorded from the
% run.
dataPath = '\\hpcnas\rx_store\project_data\ravenx_data\Proj_2017_HDR_GoMex_80670\Proj_80670GOMEX02\output\PSDhann_1s1hz';


% create difference stats by comapring A vs B

% build soundPlan
% find sounds
if exist(fullfile(projPath,filesep,'input'));
    input_path =  fullfile(projPath,filesep,'input');
else
    input_path = projPath;
end

RxProjAppObj.plan_path = fullfile(projPath,'SoundPlan');
if ~exist(RxProjAppObj.plan_path)
    mkdir(RxProjAppObj.plan_path);
end

RxProjAppObj.preset_name = ['preset_' nme];





% get the raw SoundPlan withot Sensor data
ChanMode = ChanMode.findSoundsAndChanMode(sndPath, input_path);

SndObjTble = ChanMode.JobSndTbl;

% construct sound plan with array package object.
SoundPlanTblObj = HpcAppManage.SoundPlan(ChanMode.ArrayPkgObj);

% open existing table, create if does not exist
SoundPlanTblObj = SoundPlanTblObj.OpenCreateSoundPlan(RxProjAppObj.plan_path, RxProjAppObj.preset_name);

% build the sound plan table and save each plan entry
for h = 1:size(SndObjTble.SoundSet,1);
    
    SoundPlanTblObj.SoundSet = SndObjTble.SoundSet(h);
    SoundPlanTblObj.ArrayPkgObj = SndObjTble.SnsrTbl{h};
    
    % get sounds from plan
    [SoundPlanTblObj, err] = SoundPlanTblObj.GetSoundList(SndObjTble.soundFiles(h));
    
    if ~isempty(err)
        return;
    end
    
end



end

