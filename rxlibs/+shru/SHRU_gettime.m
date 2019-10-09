function [TM] = SHRU_gettime(drhs)
% -----------------------------------------------------------
%  SHRU2Chn_gettime
%
%   [TM] = SHRU_gettime(drhs);
%
%   returns time from an array of shru headers
%
%
%                              newhall  8/8/2006
% ----------------------------------------------------------

if (nargin == 0)
    error('  No argument in function call.\n');
    return
end

nrecs  = length(drhs);      % number of records

if (nrecs == 1)
     
  yd = drhs.date(2);               %  yearday  (integer)
  minute = drhs.time(1);           %  hours*60+minutes
  millisec = drhs.time(2);         %  seconds*1000 + milliseconds
  microsec = drhs.microsec;        %  millisec = microsecs/1000
  
  tot_ms  = millisec + microsec/1000;
  tot_sec = tot_ms/1000;
  tot_min = minute + tot_sec/60;
  
  TM.yday = yd + tot_min/(60*24);         % days from Jan 1st (yearday)
  TM.ymin = yd*24*60 + tot_min;              % min from Jan 1st
  
  TM.day = yd;                            % day number
  TM.hr  = floor(tot_min/60);             % hour
  TM.min = floor((tot_min/60-TM.hr)*60);  % minute
  TM.sec = ((tot_min/60-TM.hr)*60-TM.min)*60;  % second
  
  TM.org_micros = microsec;               % original microsecs
  TM.org_millis  = millisec;              % original millisecs
  TM.org_min = minute;                    % original minutes
  TM.yr  = drhs.date(1);
  
  % This length is to the end of the record (16 secs for shark...)
  TM.tlen_min = drhs.npts/drhs.rhfs/60;
  TM.tlen_sec = drhs.npts/drhs.rhfs; 
  
    [DATE,MON,DAY] = jd2date(floor(TM.yday),TM.yr);
  
    TM.date = DATE;
    TM.mon  = MON;
    TM.day = floor(DAY); 
  
  
else     % for multiple headers...   addon... 
         % Probably don't need an if!!

  % fs     = drhs(1).rhfs;      % freq
  % nchan  = drhs(1).ch;        % number of channels
  % reclen = drhs(1).reclen;    % record length + header (1251024)
  % nscans = drhs(1).npts;      % bytes per scan
  nrecs  = length(drhs);      % number of records

  for rec=1:nrecs
      
    yd = drhs(rec).date(2);               %  yearday  (integer)
    minute = drhs(rec).time(1);           %  hours*60+minutes
    millisec = drhs(rec).time(2);         %  seconds*1000 + milliseconds
    microsec = drhs(rec).microsec;        %  millisec = microsecs/1000
  
    tot_ms  = millisec + microsec/1000;
    tot_sec = tot_ms/1000;
    tot_min = minute + tot_sec/60;
  
    TM(rec).yday = yd + tot_min/(60*24);      % days from Jan 1st (yearday)
    TM(rec).ymin = yd*24*60 + tot_min;           % min from Jan 1st
  
    TM(rec).day = yd;                            % day number
    TM(rec).hr  = floor(tot_min/60);             % hour
    TM(rec).min = floor((tot_min/60-TM(rec).hr)*60);  % minute
    TM(rec).sec = ((tot_min/60-TM(rec).hr)*60-TM(rec).min)*60;  % second
  
    TM(rec).org_micros = microsec;               % original microsecs
    TM(rec).org_millis  = millisec;              % original millisecs
    TM(rec).org_min = minute;                    % original minutes
    TM(rec).yr  = drhs(rec).date(1);
  
  
     % duration to this point
  
    yd_begin = drhs(1).date(2);
    t_begin = drhs(1).time(1)   + drhs(1).time(2)/(60*1000);  % mins
    d_begin = yd_begin + t_begin/(60*24);
    m_begin = yd_begin*24*60 + t_begin;
  
    %  end time in rec is beginning of data rec, not when finished
    %  add another 16 secs for shark??????   Na..
    
    yd_end = drhs(rec).date(2);
    tm_end = drhs(rec).time(1)   + drhs(rec).time(2)/(60*1000);
    d_end = yd_end + tm_end/(60*24);
    m_end = yd_end*24*60 + tm_end;
  
    TM(rec).tlen_min = m_end - m_begin + drhs(1).npts/drhs(1).rhfs/60;
    TM(rec).tlen_sec = m_end - m_begin + drhs(1).npts/drhs(1).rhfs;
    
    [DATE,MON,DAY] = jd2date(floor(TM(rec).yday),TM(rec).yr);
  
    TM(rec).date = DATE;
    TM(rec).mon  = MON;
    TM(rec).day = floor(DAY);
    
  end 
  
end

return

   
function [DATE,mon,day] = jd2date(jd,year)
% -----------------------------------------------------
% function DATE = jd2date(jd,year)
%
%    jd  is julian day  (noon on Jan 1st is 1.5)
%     need year to check for leap year
% 
%    returns string that inclused month day in
%           MMDD   format
%
%                      Newhall
% -----------------------------------------------------

leap = (rem(year,4) == 0  &  (rem(year,100) ~= 0 | rem(year,400) == 0));

% brute force way....
if (leap)

  switch 1
     case (jd >=  1  & jd <= 31),      % jan
            mon = 1;  
            day = jd;
     case (jd >= 32  & jd <= 60),      % feb
             mon = 2;  
             day = jd-31;           
     case (jd >= 61  & jd <= 91),      % mar 
             mon = 3;  
            day = jd-60;    
     case (jd >= 92  & jd <= 121),     % apr
            mon = 4;  
            day = jd-91;
     case (jd >= 122  & jd <= 152),    % may
            mon = 5;  
            day = jd-121;
     case (jd >= 153  & jd <= 182),    % jun
            mon = 6;  
            day = jd-152;
     case (jd >= 183  & jd <= 213),    % jul
            mon = 7;  
            day = jd-182;
     case (jd >= 214  & jd <= 244),    % aug
            mon = 8;   
            day = jd-213;
     case (jd >= 245  & jd <= 274),    % sep
            mon = 9;  
            day = jd-244;
     case (jd >= 275  & jd <= 305),    % oct
            mon = 10;  
            day = jd-274;
     case (jd >= 306  & jd <= 335),    % nov
            mon = 11;  
            day = jd-305;
     case (jd >= 336  & jd <= 366),    % dec
            mon = 12-335;  
            day = jd;
     otherwise,
            mon = 0;
            day = 0;
   end


else

  switch 1
     case (jd >=  1  & jd <= 31),      % jan
            mon = 1;  
            day = jd;
     case (jd >= 32  & jd <= 59),      % feb
             mon = 2;  
             day = jd-31;           
     case (jd >= 60  & jd <= 90),      % mar 
             mon = 3;  
            day = jd-59;    
     case (jd >= 91  & jd <= 120),     % apr
            mon = 4;  
            day = jd-90;
     case (jd >= 121  & jd <= 151),    % may
            mon = 5;  
            day = jd-120;
     case (jd >= 152  & jd <= 181),    % jun
            mon = 6;  
            day = jd-151;
     case (jd >= 182  & jd <= 212),    % jul
            mon = 7;  
            day = jd-181;
     case (jd >= 213  & jd <= 243),    % aug
            mon = 8;   
            day = jd-212;
     case (jd >= 244  & jd <= 273),    % sep
            mon = 9;  
            day = jd-243;
     case (jd >= 274  & jd <= 304),    % oct
            mon = 10;  
            day = jd-273;
     case (jd >= 305  & jd <= 334),    % nov
            mon = 11;  
            day = jd-304;
     case (jd >= 335  & jd <= 365),    % dec
            mon = 12-334;  
            day = jd;
     otherwise,
            mon = 0;
            day = 0;
   end

end

DATE = sprintf('%02d%02d',mon,day);

return

