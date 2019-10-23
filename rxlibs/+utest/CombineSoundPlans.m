function CombineSoundPlan




RUNPAR = 0;

BsePth = '\\hpcnas\rx_store\project_data\ravenx_data\Proj_2017_HDR_GoMex_80670\Proj_EARS_GOMEX01\SoundPlan'

infiles = {fullfile(BsePth, 'SoundPlan_preset_B30_Data.mat');...
    fullfile(BsePth, 'SoundPlan_preset_B31_Data.mat'); ...
    fullfile(BsePth, 'SoundPlan_preset_B32_Data.mat'); ...
    fullfile(BsePth, 'SoundPlan_preset_B33_Data.mat'); ...
    fullfile(BsePth, 'SoundPlan_preset_B34_Data.mat')};

    numFiles = length(infiles);


if RUNPAR

    p = gcp();
    p.IdleTimeout = p.IdleTimeout*10;
    h = waitbar(0, 'Workers Loading Sound Plans...');
    for idx = 1:numFiles
        f(idx) = parfeval(p, @load, 1, infiles{idx});
    end
    
    % pre-allocate
    SP = cell(1,numFiles);
    
    for idx = 1:numFiles
        [completedIdx,value] = fetchNext(f);
        SP{completedIdx} = value;
        waitbar(idx/numFiles,h, sprintf('%u of %u complete', idx, numFiles));
    end
    waitbar(idx/numFiles,h, sprintf('%u Plans Loaded - COMPLETE', numFiles));

else

    SoundPlanTbl = table;
    for idx = 1:numFiles
        sp = load(infiles{idx});
        SoundPlanTbl = [SoundPlanTbl; sp.SoundPlanTbl];
    end
       
end

save(fullfile(BsePth,'SoundPlan_EARS_DEP01.mat'), 'SoundPlanTbl');
disp('COMBINED Sound Plan Table Saved');

end % function



%                 p = gcp();
%                 p.IdleTimeout = p.IdleTimeout*10;
%                 h = waitbar(0, 'Workers Scanning File Headers...');
%                 numFiles = length(infiles);
%                 for idx = 1:numFiles
%                     f(idx) = parfeval(p, @utils.FileSignal, 1, infiles{idx});
%                 end
%                 soundFiles = cell(1,numFiles);
%                 for idx = 1:numFiles
%                     [completedIdx,value] = fetchNext(f);
%                     soundFiles{completedIdx} = value;
%                     
%                     if ~mod(idx, 50)
%                         waitbar(idx/numFiles,h, sprintf('%u of %u complete', idx, numFiles));
%                     end
% %                     maxFuture = afterEach(f, @max, 1);
% %                     updateWaitbarFuture = afterEach(f, @(~) waitbar(sum(strcmp('finished', {f.State}))/numel(f), h), 1);
%                 end
%                 waitbar(idx/numFiles,h, sprintf('%u headers scanned - COMPLETE', numFiles));
