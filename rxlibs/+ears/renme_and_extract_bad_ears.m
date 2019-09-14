function renme_and_extract_bad_ears
%
%  function to convert a collection of EARS files into a standard format
%  with the file name containing the date-time and original file HEX
%  string.
%
%  This is intended ONLY for a limited use, to create sound sets that can
%  be read by ordinary tools RavenPro for testing and validating the EARS
%  codec that will exist in Raven-X
%
%  pjd initial

% specify input sound folder, highest level and build sound plan, save if
projPath = '\\hpcnas\rx_store\project_data\ravenx_data\Proj_2017_HDR_GoMex_80670\Proj_EARS_GOMEX01';
inDir = uigetdir(projPath, 'Pick a directory that contains sound files');

%NOTE - this code is dumb, make sure the path below points to a folder with EARS data!
% inDir = '\\hpcnas\DEV\test_data\ravenx_data\test0041-EARS\input\Buoy_short_300'
% inDir = '\\hpcnas\dev\test_data\ravenx_data\test0041-EARS\input\Buoy37_short\Buoy37_rawdata_rename';
% inDir = '\\hpcnas\dev\test_data\ravenx_data\test0041-EARS\input\Buoy37_long\Buoy37_bin';
% inDir = '\\hpcnas\dev\test_data\ravenx_data\test0041-EARS\input\Buoy37_long\Buoy37_bin_renamed';
% outDir = '\\hpcnas\dev\test_data\ravenx_data\test0041-EARS\input\Buoy_short_300_wav'
% inDir = '\\hpcnas\DEV\test_data\ravenx_data\test0041-EARS\input\Buoy300'
% inDir = '\\hpcnas\dev\test_data\ravenx_data\test0041-EARS\input\Buoy_300_20180518';
% inDir = '\\hpcnas\dev\test_data\ravenx_data\ForNA-Workshop\test0046b-Sensor-CAL\input\EARS\Buoy_300_20180518';
% inDir= '\\hpcnas\dev\test_data\ravenx_data\test0041-EARS\input\Buoy_300_20180715';
goodDir= [inDir '_rename'];
badDir = [inDir '_rename_bad'];
% outPath= [inDir '_RxWAVmmap'];

if ~exist(goodDir)
    mkdir(goodDir);
end

if ~exist(badDir)
    mkdir(badDir);
end


d = dir(fullfile(inDir, '**/*.*'));
d = d(~[d.isdir]);
S = table;

    s.index = 0;
    s.datetime = [];    
    s.ears_name = [];    
    s.indxGoodPCM = 0;
    s.indxBadPCMData = 0;
    s.indxNoEndTime = 0;
    s.indxNoStartTime = 0;
    s.indxUnreadHdr = 0;    
    s.ears_name = [];


% go through each
p = parpool('HPC', 64);
% for ii = 1:length(d)
parfor ii = 1:length(d)
    
%     s.index = ii;
%     s.ears_name = {d(ii).name};

    Fs = utils.FileSignal();
    Fs.fileType = 'EARS';
    
    Fs.fileName{1} = fullfile(d(ii).folder, d(ii).name);
    [~,nme, ext] = fileparts(Fs.fileName{1});
    Fs.GMTime = 1;
    Fs.startChan = 1;
    Fs = ears.earsheader2018(Fs);
    
    if isempty(Fs)
%         s.indxUnreadHdr = ii;
        outDir = badDir;
        ofname = d(ii).name;
    else
        if ~isempty(Fs.startTime)
            T1 = Fs.startTime;
%             s.datetime = {datestr(T1,'yyyymmdd_THHMMSS')};
            ofname = [datestr(T1,'yyyymmdd_THHMMSS') '_' d(ii).name];
            if ~isempty(Fs.endTime)
                [pcm] = +ears.earsread2018(Fs.fileName);
                if length(pcm) == Fs.numFrames;
                    outDir = goodDir;
%                     s.indxGoodPCM = ii;
                else
                    outDir = badDir;
%                     s.indxBadPCMData = ii;
                end
            else % corrupt heaeder
%                 s.indxNoEndTime = ii;
                outDir = badDir;
            end
        else % corrupt hedaer
%             s.indxNoStartTime = ii;
            ofname = d(ii).name;
            outDir = badDir;
        end
        
    end
    ofname = fullfile(outDir, ofname);
    dos(['copy ' Fs.fileName{1} ' ' ofname]);
%     S = [S; struct2table(s)];
    
end % for

bd = dir(badDir); bd = bd(~[bd.isdir]);
gd = dir(goodDir); gd = gd(~[gd.isdir]);


% delete(gcp);
disp('*****************************************');
disp(sprintf('*** EARS CONVERION DONE ***'));
disp('*****************************************');
disp(sprintf('ORIGINAL EARS SET = %s', inDir));
disp(sprintf('PATH TO GOOD (re-named) EARS Files) = %s', goodDir));
disp(sprintf('PATH TO BAD EARS FILES  = %s', badDir));
disp('*****************************************');
disp(sprintf('Total GOOD EARS Files = %u', length(gd)));
disp(sprintf('Total Corrupt EARS Files = %u', length(bd)));
disp(sprintf('Total ORIGINAL EARS Files = %u', length(d)));

% S


end
