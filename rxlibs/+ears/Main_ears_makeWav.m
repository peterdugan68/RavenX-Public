function Main_ears_makeWav
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
d = d(find([d.isdir]==0));

% % inDir = '\\hpcnas\DEV\test_data\ravenx_data\test0041-EARS\input\AMAR430';
% % outDir = '\\hpcnas\dev\test_data\ravenx_data\test0041-EARS\input\AMAR430_rename';
% % Fs.fileType = 'wav';
% % d = dir(fullfile(inDir, '*.wav'));

% parpool(6);

% if ~exist(outPath)
%     mkdir(outPath);
% end


d = d(~[d.isdir]);

% go through each
% parpool(64);
% for ii = 1:length(d)
for ii = 1:length(d)
    Fs = utils.FileSignal();
    
    Fs.fileType = 'EARS';
    
    %         Fs = utils.FileSignal(d(ii));
    Fs.fileName{1} = fullfile(d(ii).folder, d(ii).name);
    [~,nme, ext] = fileparts(Fs.fileName{1});
    Fs.GMTime = 1;
    Fs.startChan = 1;
    Fs = ears.earsheader2018(Fs);
    
    if ~isempty(Fs) && ~isempty(Fs.endTime)
        
        T1 = Fs.startTime;
        [pcm] = +ears.earsread2018(Fs.fileName);

        if length(pcm) == Fs.numFrames;
            
            outDir = gooDir;
            
        else
            
            outDir = badDir;
        end
        
        
            ofname = fullfile(outDir, [datestr(T1,'yyyymmdd_THHMMSS') '_' nme '.wav'] );
        
            fs = Fs.sampleRate;
            audiowrite(ofname,pcm, fs);
            
            
            
            
            %         tvec = 1/fs:1/fs:(numel(pcm))/fs;
            %         [~, nme, ext] = fileparts(ofname);
            %         figure; plot(tvec, pcm); title([strrep(nme, '_', '-') ext]);
            
            
            %         s = Fs.MapFile;
            %         cSig = utils.ConcatenatedSignal(s);
            %         newnme = utils.soundFileName(outPath, cSig, 86400*(s.startTime - cSig.realtime));
            %         [~, ~, oldext] = fileparts(newnme);
            %         newnme = strrep(newnme, oldext, ext);
            %         cSig.writeFile(newnme, 0, s.numFrames);
    else
        
        ouDir = badDir;
        
        ifname = d(ii).name;
        badDir = [inDir '_badfiles'];
        if ~exist(badDir)
            mkdir(badDir);
        end
        ofname = fullfile(badDir, ifname);
        dos(['copy ' Fs.fileName{1} ' ' ofname]);
    
    end
    
end % for

% delete(gcp);
disp('*****************************************');
disp(sprintf('*** EARS CONVERION DONE ***'));
disp('*****************************************');
disp(sprintf('EARS SET = %s', inDir));
disp(sprintf('OUTPUT SET = %s', outDir));


end
