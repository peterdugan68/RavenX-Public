function install_MigrateTriton(Rxver)
%%%%%%%%%%%%%%%%%%%%%%%%
%%   RavenX setup     %%
%%
%% Initial creation pdugan 2018
%%
%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 1
    
    % establish a version based on the parent path
    fp = fileparts(pwd);
    bs = fileparts(fp);
    Rxver = fp(length(bs)+2:end);
    %%%%%%%%%%%%%%%%%%%%%%%%
end

sc_cat = [Rxver];

Nme = 'MigrateTriton';
Nme = [Rxver '   (' Nme ')'];

% setup parms
pth = fullfile(pwd, 'utilapps');
pth = fullfile(pth, 'MigrateTriton');

% command
line1 = ['cd (''' pth ''');' 'MigrateTriton;'];


v = version('-release');

switch(v)
    
    case {'2017a','2017b'}
        
                
        % install shortcuts (Note: any stale shortcuts will cause this to error)
        com.mathworks.mlwidgets.shortcuts.ShortcutUtils.addShortcutToBottom(Nme, line1, './checkout.gif', sc_cat, 'true');
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
        fv.setCategoryLabel(sc_cat); %name of folder in favorites
        %fv.setIconName('Community_16.png'); %icon if desired
        %fv.setIconPath('path to icons'); %path to icon file if desired
        fv.setCode(['% Invoke RavenX APP' 10 line1]); %code to be run
        %          fv.setCode(['% Display two lines' 10 'disp(''Hello World 1'')' 10 'disp(''Hello World 2'')']); %code to be run
        favorites.addCommand(fv); %add to favorites
        
    otherwise
        
        
        
end


