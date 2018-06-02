function install_detEval(Rxver)
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
sc_cat = Rxver;

sc_nme = 'DetectorEval-APP';

% setup parms
pth = fullfile(pwd, 'utilapps');
pth = fullfile(pth, 'SelectionTableApp');


% sc_nme = nme;
exe = ['cd (''' pth ''');' 'SelectionTableApp;'];

% install shortcuts (Note: any stale shortcuts will cause this to error) 
com.mathworks.mlwidgets.shortcuts.ShortcutUtils.addShortcutToBottom(sc_nme, exe, './checkout.gif', sc_cat, 'true');
ff = com.mathworks.mlservices.MatlabDesktopServices.getDesktop().getQuickAccessConfiguration();
pth = com.mathworks.toolstrip.factory.TSToolPath('shortcuts','tmp');
pth = pth.appendTool(sc_cat,'matlab_shortcut_toolset');
ff.insertTool(0,pth)
ff.setLabelVisible(pth,true);