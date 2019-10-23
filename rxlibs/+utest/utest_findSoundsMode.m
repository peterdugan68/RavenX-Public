function sounds = utest_findSoundsMode()


mode = 2;


% large set for timing.
inDir = '\\159nas\W\projects\2017_HDR_GoMex_80670\80670_GOMEX01\80670_GOMEX01_FLAC';
% uDir1 = HpcAppManage.findSoundUniqueFolder(inDir);
% sounds0 = arrayfun(@(x) HpcAppManage.findSounds(x{:}, mode), uDir1, 'UniformOutput', 0);
sounds0 = HpcAppManage.findProjSounds(inDir, mode);

inDir = '\\hpcnas\dev\test_data\ravenx_data\ForNA-Workshop\test0054-Rockhopper(one day)\input';
% uDir1 = HpcAppManage.findSoundUniqueFolder(inDir);
% sounds1 = arrayfun(@(x) HpcAppManage.findSounds(x{:}, mode), uDir1, 'UniformOutput', 0);
sounds1 = HpcAppManage,findProjSounds(inDir, mode);

inDir = '\\hpcnas\dev\test_data\ravenx_data\ForNA-Workshop\test0052b-RH-Dep02_CAL\input\80670_GOMEX02_FLAC';
% uDir2 = HpcAppManage.findSoundUniqueFolder(inDir);
% sounds2 = arrayfun(@(x) HpcAppManage.findSounds(x{:}, mode), uDir2, 'UniformOutput', 0);
sounds2 = HpcAppManage.findProjSounds(inDir, mode);


inDir = '\\hpcnas\dev\test_data\ravenx_data\ForNA-Workshop\test0054-Rockhopper(one day)\input\80670GOMEX02_S01_RH404';
% uDir3 = HpcAppManage.findSoundUniqueFolder(inDir);
% sounds3 = arrayfun(@(x) HpcAppManage.findSounds(x{:}, mode), uDir3, 'UniformOutput', 0);
sounds3 = HpcAppManage.findProjSounds(inDir, mode);


mode = 1; % quick return
chmode = 4; % single chan multi-units

% ts1 = tic;
% sounds = utils.findSounds(inDir, mode);
% te1 = toc(ts1)

% ts2 = tic;
% sounds = HpcAppManage.findSoudsMode(inDir, mode, chmode);
% te2 = toc(ts2)

disp('stop');

end

