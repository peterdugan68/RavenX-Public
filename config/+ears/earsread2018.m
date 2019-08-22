function [pcm] = earsread2018(fname, blk)
%
%   Usage:
%       [pcm] = earsread(fname, blk)
%
intsize = 16;
[~, ~, endian] = computer;

machineformat = 'ieee-be';
fd = fopen(fname{1}, 'r',machineformat );
if (fd < 0)
    fprintf('File not present: %s\n', filename);
    return
end
fseek(fd,12,'bof');
pcm = fread(fd, [250, Inf], '250*int16', 12, machineformat);  % read all data blocks, skip headers

pcm = reshape(pcm, [prod(size(pcm)),1]);

% if strcmp(endian, 'L')
%     pcm = bitshift(s, 8) + bitshift(s, -8);
% else
%     pcm = s;
% end

% pcm = typecast(pcm(:), 'int16');


try
    if nargin == 2
        pcm = pcm([blk(1):blk(2)],1);  %return the block requested
    end
catch ME
    if strcmp(ME.identifier, 'MATLAB:badsubscript')
        pcm = [];  % cannot gaurentee the data
        warning(sprintf('earsread2018 %s', ME.identifier));
    else 
        rethrow(ME);
    end
end

normfac = 2^(1 - intsize);
pcm = bsxfun(@times, double(pcm), normfac);   % scale result

fclose(fd);
end

