% function [out] = CreateTcTble(fSig)
%
%
% 
% 

s = overload.rxuigetfile('select the sound plan');

fSig = SoundPlanTbl.soundFiles{1};

T = table;

% [fSig.fileName]
% [fSig.dateVector]

T1 =  [fSig.startTime]';
[y,mo,dy, hr, mn, s] = datevec(T1);
Tsec1 = hr*3600+mn*60+s;
Date_Start = datestr(T1, 'yyyy-mmm-dd');

T2 =  [fSig.endTime]';
[y,mo,dy, hr, mn, s] = datevec(T2);
Tsec2 = hr*3600+mn*60+s;
Date_Stop = datestr(T2, 'yyyy-mmm-dd');



T.fileName = [fSig.fileName]';
T.NumSamples = [fSig.numFrames]';
T.Date_Start = string([Date_Start]);
T.Tsec1 = Tsec1;
T.Tsec2 = Tsec2;
T.dtSec = (Tsec2 - Tsec1);
% T.Tend_HrMinSec = 
dt2 = [0; Tsec2];
dt1 = [Tsec1; 0];
gapSec = dt1-dt2;
T.gapSec = [gapSec(2:end)];



