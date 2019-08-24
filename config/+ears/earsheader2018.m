function fileobj = earsheader2018(fileobj)
% 
% fileobj = earsheader2018(fileobj)
%
%   input
%       fileobj - FileSignal Object 
% 
% This function is based on JZollweg ReadHeader
%
% Copyright 2013-2019 Cornell Lab of Ornithology
%   PDugan, extracxted code from FileSignal ReadHeader
%   JZollweg, added case for EARS
%   Add EARS dev per JAZ - PJD 6/26/2019
%   Add code to deal with corrupted EARS files  8/15/2019
%   PJD - Need to verify the block that handles the error case

% Open file
filename = fileobj.fileName{1};
filetype = fileobj.fileType;

machineformat = 'ieee-be';

fd = fopen(filename, 'r', machineformat);
if (fd < 0)
    fprintf('File not present: %s\n', filename);
    return
end

[x,n] = fread(fd, 12, 'uint8');
if n<12 || x(1)>9 || x(2) ~= 1
    fclose(fd);
    fprintf('File is not an EARS file in recognized format; can''t read it: %s\n', filename);
    return
end
format = char(x(1:4).');
timestamp = x(7:12);
frewind(fd);

% Read format section
cont = true;
while cont
    x = fread(fd, 4, 'char').';
    [len, n] = fread(fd, 1, 'uint32');
    if n < 1
        iReadError(fd, filename);
    end
    if strcmp(char(x), format)
        cont = false;
    else
        fseek(fd, len, 0);
    end
end

offset = 0;
% Convert timestamp from first packet
timestamp(1) = mod(timestamp(1), 16);
conversion = 256.^(5:-1:0); % 44 bit number from clock
RefClk = 31997.66;
RefClk = 32000;

clock = conversion*timestamp/RefClk/86400;
fileobj.startTime = clock+735965;  % Epoch = 2015-01-01
fileobj.dateVector{1}(1, :) = datevec(fileobj.startTime);

% pjd make offset the length of the header, realistically there
% are other header in the file, but we'll skip offset+ fpp
% (frames per packet) to get to the next header, this logic is
% built into earsread() routine.
offset = 12;  % header offset
fpp = 250;  % number of frames per packet

nc = 1;
ss = 16;
dtype = 'int16';
fseek(fd, 0, 'eof');
bytes = ftell(fd);
if mod(bytes, 512) % pjd make sure we have proper size file
    fprintf('EARS file %s appears to be truncated\nm', filename);
end
nf = (bytes/512);  % pjd number of packets are whole
nf = nf*fpp;  % compute number of total frames, minus the header bytes
% Convert timestamp from last packet
fseek(fd, -506, 'eof');  % pjd fseek to last packet, just before time-stammp
endTimestamp = fread(fd, 6, 'uint8');  %pjd read timestamp  6 bytes
endTimestamp(1) = mod(endTimestamp(1), 16);  % pjd gets rid of first 4 bits
endClock = conversion*endTimestamp/32000/86400;  % timer 32 kHz, end clock in days
if endClock < clock  % File is corrupt; find good part.
    
    iReadError(fd, filename);
    return
    
    %                 % pjd here bcs file is corrupt
    %                 frewind(fd);
    %                 data = fread(fd, [12, Inf], '12*uint8', 500);  % read all headers, read 12 bytes, skip 500, output is 12 rows x Inf coliumns
    %                 x = data(7:12, :);  % Each column has data for one timestamp, each column is time stamp for a packet
    %                 x(1, :) = mod(x(1, :), 16); %start time stamp conversion
    %                 timestamps = conversion*x/32000/86400; % row of timestamps, single row x N packet-time-stamps
    %                 delta_t = diff(timestamps);  % get diff of all time-stampes
    %                 index = find(delta_t<0, 1, 'first');  % find first bad one
    %                 nf = index-1;   % number of good packets is one minus the last bad one.
    %                 nf = nf*fpp;  % compute number of total good frames, minus the header bytes
    %                 endClock = timestamps(nf); % redfine endClock than bad time stamp
end
% sr = (nf-1)/(endClock - clock)/86400;  % compute sample rate (numFrame/packet)*(Packet/second)
sr = 192026; % needs to be constant
nbyte = 2; % pjd 2 byte frames
dy = nbyte*8;
dtype = ['int', num2str(dy)];

fclose(fd);

% Put properties into FileSignal object
fileobj.numChannels(1) = nc;
fileobj.numFrames(1) = nf;
fileobj.sampleSize = ss;
fileobj.sampleRate = sr;
fileobj.dataType = dtype;
fileobj.dataOffset = offset;
duration = nf/sr;   % number of seconds
fileobj.endTime(1) = fileobj.startTime(1) + duration/86400;
fileobj.dateVector{1}(2, :) = datevec(fileobj.endTime(1));
return
end

function iReadError(fd, filename)
fclose(fd);
fprintf('Unexpected end of file while reading %s\n', filename);
end




% %Read header (first 12 bytes)
% % record=0;
% fseek(fd,512*record,'bof');
% [header,count1] = fread(fd,12,'uchar');
% fpoint = ftell(fd);			%Get file pointer position for later
% %fpoint=512;
% %Decode timestamp
% dum = bitshift(header(7),-4);
% dum = bitshift(dum,4);
% %dum = bitcmp(dum,8);
% %new release
% dum=bitcmp(dum,'uint8');
% a = bitand(dum,header(7));
%
% timecode = header(12) + header(11)*2^8 + header(10)*2^16 + header(9)*2^24 + header(8)*2^32 + a*2^40;
%
% timecode = timecode / 32000.;			%convert from 32kHz clock to sec
% T = datetime(timecode,'ConvertFrom',...
%     'epochtime','Epoch','2015-01-01');
%
% %Decode day for year determination
% timecode = timecode / (60*60*24);	%variable "timecode" is now in days
% %%!!
%
% jday0 = fix(timecode);
%
% %variable "jday0" is number of days from 0000Z Jan 1 2000
% %convert jday0 to Year and Julian day (variables "jyear" and "jday")
%
% jyear = fix(jday0/365); 					%number of years since 1 Jan 2000
% dumyear = jyear + 2;
% datyear = mod(dumyear,4); 				%flag: 0 for data year = leap year
% leap = fix(dumyear/4);  				% number of leap years (counting data year)
%
% %data year is a leap year: do not count as a leap year past
% if  datyear == 0
%     leap = leap - 1;
% end
%
% dum=rem(jday0,365);  						%maximum Julian day of data year
%
% %Calculate actual year and Julian day
% if leap < dum
%     %changed from 2000 to 2015
%     jyear = 2015 + jyear;
%     jday = dum - leap;
% else		%Account for Julian day near beginning of data year if necessary
%     jyear = 2015 + jyear -1;
%     if (datyear + 1) == 1 %year before data year is leap year
%         jday = dum - leap + 366;
%     else
%         jday = dum - leap + 365;
%     end
% end
%
% %decode hours
% timecode = (timecode - jday0)*24;
%
% %adjust for offset (assume linear error)
% timecode = (jday *24 + timecode)*3600;	%convert to seconds
% %timecode = timecode + (toffset*(timecode - synctime)/tottime);	%do adjustment
%
% %Decode day
% timecode = timecode / (60*60*24);	%variable "timecode" is now in days
% jday = fix(timecode);
%
% %Decode hours
% timecode = (timecode - jday)*24;
% jhour = fix(timecode);
%
% %Decode minutes
% timecode = (timecode - jhour)*60;
% jmin = fix(timecode);
%
% %Decode seconds
% jsec = (timecode - jmin)*60;
%
% %Make initial jday == 1 NOT == 0 !!!
% jday = jday +1;


