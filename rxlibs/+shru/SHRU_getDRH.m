function [drh, status] = SHRU_getDRH(fid)
% ----------------------------------------------------------------
%  SHRU_getDRH
%
%    Gets the data record header starting at the current point
%       in the file, as pointed to by FID. 
%       DRH = SHRU_getDRH(FID)
%       Returns a data record header structure.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subroutine: getDRH.m  
% original author: B. Sperry
% date: 
% history:
% notes:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

status = 0;
drh = [];

% --------------------------------------------------------------------

[data_str,ct]    = fread(fid,4,'uchar');       [status] = chk_read(ct);
drh.rhkey         = sprintf('%s',char(data_str));    
  %%% drh.rhkey = sprintf('%s',char(fread(fid,4,'uchar')));   % original
  
[drh.date,ct]     = fread(fid,2,'uint16');      [status]=chk_read(ct);
[drh.time,ct]     = fread(fid,2,'uint16');      [status]=chk_read(ct);
  
[drh.microsec,ct] = fread(fid,1,'uint16');      [status]=chk_read(ct);
[drh.rec,ct]      = fread(fid,1,'uint16');      [status]=chk_read(ct);
  
[drh.ch,ct]       = fread(fid,1,'uint16');      [status]=chk_read(ct);
  
% SHRU order
drh.npts     = fread(fid,1,'int32');
drh.rhfs     = fread(fid,1,'float');
drh.unused   = fread(fid,2,'uchar');
drh.rectime  = fread(fid,1,'uint32');

% %   Shark order
% [drh.unused,ct]   = fread(fid,2,'uchar');       [status]=chk_read(ct);
% [drh.npts,ct]     = fread(fid,1,'int32');       [status]=chk_read(ct);
% [drh.rhfs,ct]     = fread(fid,1,'float');       [status]=chk_read(ct);
% [drh.rectime,ct]  = fread(fid,1,'uint32');      [status]=chk_read(ct);
  
[data_str,ct]     = fread(fid,16,'char');       [status]=chk_read(ct);
drh.rhlat         = sprintf('%s',char(data_str));
[data_str,ct]     = fread(fid,16,'char');       [status]=chk_read(ct);
drh.rhlng         = sprintf('%s',char(data_str));
  
[drh.nav120,ct]   = fread(fid,28,'uint32');      [status]=chk_read(ct);
[drh.nav115,ct]   = fread(fid,28,'uint32');      [status]=chk_read(ct);
[drh.nav110,ct]   = fread(fid,28,'uint32');      [status]=chk_read(ct);

[data_str, ct]    = fread(fid,128,'uchar');      [status]=chk_read(ct);
drh.POS           = sprintf('%s',char(data_str));
  
[drh.unused2,ct]  = fread(fid,208,'char');       [status]=chk_read(ct);
   
[drh.nav_day,ct]  = fread(fid,1,'int16');        [status]=chk_read(ct);
[drh.nav_hour,ct] = fread(fid,1,'int16');        [status]=chk_read(ct);
[drh.nav_min,ct]  = fread(fid,1,'int16');        [status]=chk_read(ct);
[drh.nav_sec,ct]  = fread(fid,1,'int16');        [status]=chk_read(ct);
[drh.lblnav_flag,ct] = fread(fid,1,'int16');     [status]=chk_read(ct);

[drh.unused3,ct]  = fread(fid,2,'char');         [status]=chk_read(ct);
[drh.reclen,ct]   = fread(fid,1,'uint32');       [status]=chk_read(ct);
   
   
[drh.acq_day,ct]     = fread(fid,1,'int16');     [status]=chk_read(ct);
[drh.acq_hour,ct]    = fread(fid,1,'int16');     [status]=chk_read(ct);
[drh.acq_min,ct]     = fread(fid,1,'int16');     [status]=chk_read(ct);
[drh.acq_sec,ct]     = fread(fid,1,'int16');     [status]=chk_read(ct);
[drh.acq_recnum,ct]  = fread(fid,1,'int16');     [status]=chk_read(ct);

[drh.ADC_tagbyte,ct] = fread(fid,1,'int16');     [status]=chk_read(ct);
[drh.glitchcode,ct]  = fread(fid,1,'int16');     [status]=chk_read(ct);
[drh.bootflag,ct]    = fread(fid,1,'int16');     [status]=chk_read(ct);

[data_str, ct]     = fread(fid,16,'uchar');      [status]=chk_read(ct);
drh.internal_temp  = sprintf('%s',char(data_str));

[data_str, ct]     = fread(fid,16,'uchar');      [status]=chk_read(ct);
drh.bat_voltage    = sprintf('%s',char(data_str));

[data_str, ct]     = fread(fid,16,'uchar');      [status]=chk_read(ct);
drh.bat_current    = sprintf('%s',char(data_str));

[data_str, ct]     = fread(fid,16,'uchar');      [status]=chk_read(ct);
drh.status         = sprintf('%s',char(data_str));

[data_str, ct]     = fread(fid,16,'uchar');      [status]=chk_read(ct);
drh.proj           = sprintf('%s',char(data_str));

[data_str, ct]     = fread(fid,16,'uchar');      [status]=chk_read(ct);
%%%  drh.aexp           = sprintf('%s',char(data_str));
drh.shru_num           = sprintf('%s',char(data_str));

[data_str, ct]     = fread(fid,16,'uchar');      [status]=chk_read(ct);
drh.vla            = sprintf('%s',char(data_str));

[data_str, ct]     = fread(fid,16,'uchar');      [status]=chk_read(ct);
drh.hla            = sprintf('%s',char(data_str));

%%%  Shark
%   and shru even though it doesnt work with these sample data files...
%   they are old...  filename should be 32 bytes
[data_str, ct]     = fread(fid,32,'uchar');      chk_read(ct);
%%%% [data_str, ct]     = fread(fid,16,'uchar');      [status]=chk_read(ct);
%%drh.filename       = sprintf('%s',char(data_str(1:12)));  %MMddhhmm.Dss
drh.filename       = sprintf('%s',char(data_str));  %MMddhhmm.Dss

[data_str, ct]     = fread(fid,16,'uchar');      [status]=chk_read(ct);
drh.record         = sprintf('%s',char(data_str));

[data_str, ct]     = fread(fid,16,'uchar');      [status]=chk_read(ct);
drh.adate          = sprintf('%s',char(data_str));

[data_str, ct]     = fread(fid,16,'uchar');      [status]=chk_read(ct);
drh.atime          = sprintf('%s',char(data_str));

 
[drh.file_length,ct]    = fread(fid,1,'uint32');    [status]=chk_read(ct);
[drh.total_records,ct]  = fread(fid,1,'uint32');    [status]=chk_read(ct);
[drh.unused4,ct]        = fread(fid,2,'char');      [status]=chk_read(ct);

[drh.adc_mode,ct]       = fread(fid,1,'int16');     [status]=chk_read(ct);
[drh.adc_clk_code,ct]   = fread(fid,1,'int16');     [status]=chk_read(ct);
[drh.unused5,ct]        = fread(fid,2,'char');      [status]=chk_read(ct);
[drh.timebase,ct]       = fread(fid,1,'int32');     [status]=chk_read(ct);
  
[drh.unused6,ct]        = fread(fid,12,'char');     [status]=chk_read(ct);
[drh.unused7,ct]        = fread(fid,12,'char');     [status]=chk_read(ct);

[data_str, ct]          = fread(fid,4,'char');      [status]=chk_read(ct);
drh.rhkeyl              = sprintf('%s',char(data_str));

if( (strcmp(drh.rhkey,'DATA') & strcmp(drh.rhkeyl,'ADAT'))),
    error('Record header keys don''t match!');
end;

% ----------------------------------------------------------------
% go back to original position, in front of data for this trailer
% fseek(fid,old_pos,'bof');
% ----------------------------------------------------------------

  return;
  
%=====================================================
function [strin]=swapString(strin)
%swapString

  k = 2*fix(length(strin)/2);
  for i=1:2:k,
    tmp=strin(i);
    strin(i)=strin(i+1);
    strin(i+1)=tmp;
  end;
  
  return;
  
  
%=====================================================
function [y]=swapShort(x)
%swapShort

  xx = sprintf('%04s',dec2hex(x));
  y = hex2dec([xx(3:4) xx(1:2)]);

  return;
  
%=====================================================
function [y]=swapLong(x)
%swapLong

  if(x<=65535), 
    xx = sprintf('%04s0000',dec2hex(x));
    y = hex2dec([xx(7:8) xx(5:6) xx(3:4) xx(1:2)]);
  else,
    xx = sprintf('%08s',dec2hex(x));
    y = hex2dec([xx(7:8) xx(5:6) xx(3:4) xx(1:2)]);
  end;

  return;
  
% ==================================================
%  doesn't really do much...  should return status...
%   but don't want to change above code.

function [status]=chk_read(count)
        
     if count == 0,
         % error('Error reading header - End of file?');
         status = -1;
     else
         status = 0;
     end

     return;
   
     
% =====================================================
   
  