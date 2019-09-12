function [outputArg1,outputArg2] = getProcPlanStats(inputArg1,inputArg2)
%
%
% 
% 
% 
% 
% 
% 
%  pdugan 2019 

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
dataPath = '\\hpcnas\rx_store\project_data\ravenx_data\Proj_2017_HDR_GoMex_80670\Proj_80670GOMEX02\output';
algName = 'PSDhann_1s1hz';
dataPath = fullfile(dataPath, algName);
d = dir(dataPath);
fInd = find([d(1:end).isdir]);
d = d(fInd(3:end));
dTble = struct2table(d);

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
inSoundPlanTblObj = HpcAppManage.SoundPlan(ChanMode.ArrayPkgObj);

% open existing table, create if does not exist
inSoundPlanTblObj = inSoundPlanTblObj.OpenCreateSoundPlan(RxProjAppObj.plan_path, RxProjAppObj.preset_name);

SoundPlanTbl = inSoundPlanTblObj.SoundPlanTbl;

% build the sound plan table and save each plan entry
for h = 1:size(SndObjTble.SoundSet,1);
    
    inSoundPlanTblObj.SoundSet = SndObjTble.SoundSet(h)
    inSoundPlanTblObj.ArrayPkgObj = SndObjTble.SnsrTbl{h};
    
    % get sounds from plan
    [inSoundPlanTblObj, err] = inSoundPlanTblObj.GetSoundList(SndObjTble.soundFiles(h));
    
    if ~isempty(err)
        return;
    end
    
    % build the hour 
    bSigs = blockByHour(inSoundPlanTblObj.soundFiles);
    days = unique([bSigs.day]); % discover number of days to process
    bsTble = struct2table(bSigs);
    
    [~, nme, ~] = fileparts(inSoundPlanTblObj.SoundSet{1});
    fInd = find(contains(dTble.name, nme));
    oPath = fullfile(dataPath,dTble.name{fInd}); 
    od = dir(fullfile(oPath, '*.mat'));
    I = 1:length(od);
    [dy, hr] = arrayfun(@(x) (parseDateHour(od(x).name)), I', 'UniformOutput', false);
    eT = table;
    eT.outfile = {od.name}';
    eT.alg = repmat({algName}, size(eT.outfile,1) ,1);
    eT.day = [dy{:}]';    
    eT.hour = [hr{:}]';
    

    SoundPlanTbl.CompStatus{fInd} = outerjoin(eT,bsTble,'Mergekeys', true);
    nInd = find(strcmp(SoundPlanTbl.CompStatus{fInd}.outfile, ''));
    SoundPlanTbl.skipHr{fInd} = SoundPlanTbl.CompStatus{fInd}(nInd,{'day', 'hour', 'hrSigs', 'startFrame', 'endFrame'});
end

% save the Sound Plan to re-run
% SoundPlanTbl = outSoundPlanTblObj.SoundPlanTbl;
save(fullfile(inSoundPlanTblObj.planPath,[inSoundPlanTblObj.planFileName '_reRun.mat']), 'SoundPlanTbl');

end


function [dy, hr] = parseDateHour(c)

dy = datenum(c(1:8), 'yyyymmdd');
hr = str2num(c(10:11));

end