%%%%%%%%%%%%%%%%%%%%%%%%
%%   RavenX Version   %%
%%%%%%%%%%%%%%%%%%%%%%%%
fp = fileparts(pwd);
bs = fileparts(fp);
Rxver = fp(length(bs)+2:end);
%%%%%%%%%%%%%%%%%%%%%%%%

% setup parms
pth = pwd;
sc_nme = [Rxver 'ravenx-ad'];
exe = ['cd ' pth ';' 'Launch_Main(''detect'');'];

% install shortcuts (Note: any stale shortcuts will cause this to error) 
com.mathworks.mlwidgets.shortcuts.ShortcutUtils.addShortcutToBottom(sc_nme, exe, './checkout.gif', 'ravenx', 'true');
ff = com.mathworks.mlservices.MatlabDesktopServices.getDesktop().getQuickAccessConfiguration();
pth = com.mathworks.toolstrip.factory.TSToolPath('shortcuts','tmp');
pth = pth.appendTool(sc_name,'matlab_shortcut_toolset');
ff.insertTool(0,pth)
ff.setLabelVisible(pth,true);