function endTime = add2date(startTime, sampleRate, numFrames)
% 
%  Routine: 
%     endTime = add2date(startTime, sampleRate, numFrames) 
% 
% 
%  Description 
%     add2date adds the time elapsed from reading numFrames at sampleRate,
%     by adding this value to the startTime and returning the resulting
%     datetime value endTime.  
%  
% Copyright 2013-2019 
%   PDugan Oct 2019
% 

DurationSecs = dntime.ShapeAsCol(numFrames) ./ sampleRate;
endTime = startTime + DurationSecs ./ 86400;



end

