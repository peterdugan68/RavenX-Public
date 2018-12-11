function install_ravenx
%%%%%%%%%%%%%%%%%%%%%%%%
%%   RavenX setup     %%
%%
%% Initial creation pdugan 2018
%%
%%%%%%%%%%%%%%%%%%%%%%%%

install_path = fullfile(pwd,'install');

if ~exist(install_path)
   return; 
end

addpath(install_path,'-end');

% establish a version based on the parent path
[a,b,~] = fileparts(pwd);
[c,d,~] = fileparts(a);
FavCat = fullfile(d,b);
%%%%%%%%%%%%%%%%%%%%%%%%

ipath = fileparts(which('install_ravenx_ad'));
while ~strcmp(ipath, install_path)
    rmpath(ipath);
    ipath = fileparts(which('install_ravenx_ad'));
end

% install auto-detector package
install_ravenx_ad(FavCat);


% install noise analyzer package
% install_ravenx_na(FavCat);
% 
% % install DAT packages;
% install_DATpkg(FavCat);
% 
% % install Util packages;
% install_acoustat(FavCat);
% install_detEval(FavCat);
% install_MakeCallcount(FavCat);
% install_MakeListfile(FavCat);
% install_MigrateTriton(FavCat);
% install_RavenSoundSpeedCalculator(FavCat);
% install_SelectionTableApp(FavCat);
% 
% 
% 
% 
