%%%%%%%%%%%%%%%%%%%%%%%%
%%   RavenX setup     %%
%%
%% Initial creation pdugan 2018
%%
%%%%%%%%%%%%%%%%%%%%%%%%

% establish a version based on the parent path
fp = fileparts(pwd);
bs = fileparts(fp);
Rxver = fp(length(bs)+2:end);
%%%%%%%%%%%%%%%%%%%%%%%%

% setup parms
pth = pwd;
sc_cat = [Rxver];
exe = ['cd (''' pth ''');' 'Launch_Main(''detect'');'];

% install shortcuts (Note: any stale shortcuts will cause this to error) 
% com.mathworks.mlwidgets.shortcuts.ShortcutUtils.addShortcutToBottom(sc_cat, exe, './checkout.gif', 'ravenx', 'true');
com.mathworks.mlwidgets.shortcuts.ShortcutUtils.addShortcutToBottom('RavenX-AD', exe, './checkout.gif', sc_cat, 'true');
ff = com.mathworks.mlservices.MatlabDesktopServices.getDesktop().getQuickAccessConfiguration();
pth = com.mathworks.toolstrip.factory.TSToolPath('shortcuts','tmp');
pth = pth.appendTool(sc_cat,'matlab_shortcut_toolset');
ff.insertTool(0,pth)
ff.setLabelVisible(pth,true);

% install_utilapps package;
install_DATpkg(sc_cat);
install_acoustat(sc_cat);
install_detEval(sc_cat);
install_MakeCallcount(sc_cat);
install_MakeListfile(sc_cat);
install_MigrateTriton(sc_cat);
install_RavenSoundSpeedCalculator(sc_cat);
install_SelectionTableApp(sc_cat);

% install noise analyzer package
install_ravenx_na;


