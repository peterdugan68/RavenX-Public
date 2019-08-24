function Main_ears_utest
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

Fs = utils.FileSignal();

%NOTE - this code is dumb, make sure the path below points to a folder with EARS data!
inDir = '\\hpcnas\DEV\test_data\ravenx_data\test0041-EARS\input\Buoy_short_300'
% outDir = '\\hpcnas\dev\test_data\ravenx_data\test0041-EARS\input\Buoy_short_300_wav'
% inDir = '\\hpcnas\DEV\test_data\ravenx_data\test0041-EARS\input\Buoy300'
% inDir = '\\hpcnas\dev\test_data\ravenx_data\test0041-EARS\input\Buoy_300_20180518';
% inDir = '\\hpcnas\dev\test_data\ravenx_data\ForNA-Workshop\test0046b-Sensor-CAL\input\EARS\Buoy_300_20180518';
% inDir= '\\hpcnas\dev\test_data\ravenx_data\test0041-EARS\input\Buoy_300_20180715';
outDir= [inDir '_wav']; 

Fs.fileType = 'EARS';
d = dir(fullfile(inDir, '*.*'));

% % inDir = '\\hpcnas\DEV\test_data\ravenx_data\test0041-EARS\input\AMAR430';
% % outDir = '\\hpcnas\dev\test_data\ravenx_data\test0041-EARS\input\AMAR430_rename';
% % Fs.fileType = 'wav';
% % d = dir(fullfile(inDir, '*.wav'));

% parpool(12);

if ~exist(outDir)
    mkdir(outDir);
end

d = d(~[d.isdir]);

% go through each
for i = 1:length(d)
    
%         Fs = utils.FileSignal(d(i));
        Fs.fileName{1} = fullfile(d(i).folder, d(i).name);
        Fs.fileType = 'EARS';
        Fs.GMTime = 1;
        Fs.startChan = 1;
        Fs = ears.earsheader2018(Fs);
    
    if ~isempty(Fs)
        T1 = Fs.startTime;                
        [pcm] = +ears.earsread2018(Fs.fileName);
        fname = fullfile(outDir, [datestr(T1,'yyyymmdd_HHMMSS') '_' d(i).name '.wav']);
        fs = Fs.sampleRate;
        audiowrite(fname,pcm, fs);
        figure; plot(pcm);
    end
end % for

% delete(gcp);
disp('*****************************************');
disp(sprintf('*** EARS CONVERION DONE ***'));
disp('*****************************************');
disp(sprintf('EARS SET = %s', inDir));
disp(sprintf('OUTPUT SET = %s', outDir));


end
