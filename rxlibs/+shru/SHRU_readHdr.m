function [Data,t,header1]=SHRU_readHdr(filename,recs,chns,fixed_gain,drhs)
% ----------------------------------------------------------------------------------------
%     [data,t0,header] = SHRU_getdata(filename,recs,chns)
%
% Retreat SHRU records from a given file
%
%   Input
%   filename: data file name 
%   recs: record numbers, starting from 0
%   chns: channel numbers, startinf from 0
%
%   Output
%   data: data from the specified records (each column is the data on one channel
%   t0: the beginning time, t0.yr and t0.yday
%   header: the first hearder of the specified records
%
%  By Y.-T. Lin @ Ocean Acoustic Lab WHOI in Aug 2009
%
% -----------------------------------------------------------------------------

recs = 0;
chns = 1;
fixed_gain = [];
drhs = [];

Data = [];  % default if not set
t =[];
header1 = [];

if ~exist('fixed_gain','var')||isempty(fixed_gain),
    fixed_gain = 20;  % default linear fixed gain 20(~26 dB)
                      % linear fixed gain 2 = ~6 dB
end

% open shru file
fid = fopen(filename,'rb','ieee-be');       % big endian for shru
if (fid < 0)
    error(['Cannot open ' filename ]);
end

% read headers
if ~exist('drhs','var')||isempty(drhs),
    [drhs] = shru.SHRU_getAllDRH(fid);
end
recs = recs+1;  % offset the variable
chns = chns+1; chns = chns(:).';
nch = drhs.ch;   % number of channels
if any(chns>nch),
    fclose(fid);
    error('No channel#%s. Only %d channels!!', num2str(chns(chns>nch)-1), nch)
end
if any(recs>length(drhs)),
    fclose(fid);
    error('No record#%s. Only %d records!!', num2str(recs(recs>length(drhs))-1), length(drhs))
end

header1 = drhs(recs(1));  % output the first header
bytes_hdr = 1024;

% ------------------------------------------
% calculate how many bytes we need to skip to start reading in data
skip_bytes = 0;
for ii = 1:recs(1);
    skip_bytes = skip_bytes + drhs(ii).reclen;
end
skip_bytes = skip_bytes - drhs(ii).reclen;

% skip bytes
[status] = fseek(fid,skip_bytes,'bof');
if (status < 0),
    fclose(fid);
    error('Error: Something bad happened in the file (%s)...\n',filename);
end

% ------------------------------------------
% read in data
spts = drhs(recs(1)).npts;
Data = nan(length(chns),spts*length(recs));
for ii = 1:length(recs);

    if spts ~= drhs(recs(ii)).npts, 
        fclose(fid);
        error('Error: Something bad happened in the file (%s)...\n',filename);
    end

    % skip record header
    [status] = fseek(fid,bytes_hdr,'cof');
    if (status < 0)
        fclose(fid);
        error('Error: Something bad happened in the file (%s)...\n',filename);
    end

    % Get data record, all channels
    [data, count]=fread(fid,[nch,spts],'short'); % read 1 record of data
    if (count ~= nch*spts)
        fclose(fid);
        error('Error: Something bad happened in the file (%s)...\n',filename);
    end

    % save desired data to be returned.
    data = data(chns,:);

    % Now we clip off the last two bits as a gain (actually an exponent)
    data=data/4;
    gain=4*(data-floor(data));        % mant=floor(data);   "floor" is required due to the nature of negative binary numbers 
    gain=(2*(ones(length(chns),spts))).^(3*gain);        % exp=gain;
    data=floor(data)./gain;

    % convert the unit data to voltage (from keith)
    if length(fixed_gain)>1, fixed_gain = fixed_gain(chns); end
    ADC_halfscale = 2.5;  % ADC half scale volts (+/- half scale is ADC i/p range)
    ADC_maxvalue = 8192; % ADC maximum halfscale o/p value, half the 2's complement range
    % data(abs(data)>=ADC_maxvalue-1) = NaN; 
    norm_factor = ADC_halfscale/ADC_maxvalue./fixed_gain;
    if length(fixed_gain)>1, 
        data = data.*repmat(norm_factor(:),[1 spts]); 
    else
        data = data*norm_factor; 
    end
    
    
    Data(:,(1:spts)+(ii-1)*spts) = data; 

end

fclose(fid);

% return a column vector
Data = Data.';

if nargout > 1,
    % get beginning time
    TM = shru.SHRU_gettime(header1);
    t.yr = TM.yr; 
    t.yday = TM.yday;
end

return