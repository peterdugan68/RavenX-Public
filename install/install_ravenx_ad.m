%%%%%%%%%%%%%%%%%%%%%%%%
%%   RavenX setup     %%
%%
%% Initial creation pdugan 2018
%%
%%%%%%%%%%%%%%%%%%%%%%%%

addpath(pwd,'-end');
cd ..

% establish a version based on the parent path
fp = fileparts(pwd);
bs = fileparts(fp);
Rxver = fp(length(bs)+2:end);
%%%%%%%%%%%%%%%%%%%%%%%%

% setup parms
pth = pwd;
sc_cat = [Rxver];
line1 = ['cd (''' pth ''');'];
line2 = ['Launch_Main(''detect'');'];
% exe = [line1; line2];

v = version('-release');

Nme = ['Auto Detect'];
FavCat = [sc_cat '\RavenX-AD'];
Nme = [FavCat '   (' Nme ')'];
switch(v)
    
    case {'2017a','2017b'}
        % install shortcuts (Note: any stale shortcuts will cause this to error)
        % com.mathworks.mlwidgets.shortcuts.ShortcutUtils.addShortcutToBottom(sc_cat, exe, './checkout.gif', 'ravenx', 'true');
        com.mathworks.mlwidgets.shortcuts.ShortcutUtils.addShortcutToBottom(Nme, [line1 line2], './checkout.gif', FavCat, 'true');
        ff = com.mathworks.mlservices.MatlabDesktopServices.getDesktop().getQuickAccessConfiguration();
        pth = com.mathworks.toolstrip.factory.TSToolPath('shortcuts','tmp');
        pth = pth.appendTool(sc_cat,'matlab_shortcut_toolset');
        ff.insertTool(0,pth)
        ff.setLabelVisible(pth,true);
        
    case {'2018a', '2018b'}
        
         favorites = com.mathworks.mlwidgets.favoritecommands.FavoriteCommands.getInstance;
         favorites.waitUntilReady;
         fv = com.mathworks.mlwidgets.favoritecommands.FavoriteCommandProperties;
         fv.setLabel(Nme); %name of favorite
         fv.setCategoryLabel(FavCat); %name of folder in favorites
         %fv.setIconName('Community_16.png'); %icon if desired
         %fv.setIconPath('path to icons'); %path to icon file if desired
         fv.setCode(['% Invoke RavenX APP' 10 line1 10 line2]); %code to be run
%          fv.setCode(['% Display two lines' 10 'disp(''Hello World 1'')' 10 'disp(''Hello World 2'')']); %code to be run
         favorites.addCommand(fv); %add to favorites
        
    otherwise
        
        
        
end


% install noise analyzer package
install_ravenx_na(FavCat);

% install DAT packages;
install_DATpkg(FavCat);

% install Util packages;
install_acoustat(FavCat);
install_detEval(FavCat);
install_MakeCallcount(FavCat);
install_MakeListfile(FavCat);
install_MigrateTriton(FavCat);
install_RavenSoundSpeedCalculator(FavCat);
install_SelectionTableApp(FavCat);




