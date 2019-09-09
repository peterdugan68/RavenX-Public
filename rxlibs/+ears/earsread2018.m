function [pcm] = earsread2018(fname, blk)
% 
%   Usage:
%       [pcm] = earsread(fname, blk)
%
%   input
%       fname - EARS file
%         blk - read block
% 
%   output:
%       pcm - pcm data, range [-1..1]
% 
% Copyright 2013-2019 Cornell Lab of Ornithology
%   PDugan, based on memmap FileSignal JZollweg and EARS sensor info

intsize = 16;
[~, ~, endian] = computer;

if strcmp(endian, 'L')
    machineformat = 'ieee-be';
else
    machineformat = 'ieee-le';
end


fd = fopen(fname{1}, 'r',machineformat );
if (fd < 0)
    fprintf('File not present: %s\n', filename);
    return
end
fseek(fd,12,'bof');
pcm = fread(fd, [250, Inf], '250*int16', 12, machineformat);  % read all data blocks, skip headers
pcm = reshape(pcm, [numel(pcm),1]);


try
    if nargin == 2
        pcm = pcm(blk(1):blk(2),1);  %return the block requested
    end
catch ME
    if strcmp(ME.identifier, 'MATLAB:badsubscript')
        pcm = [];  % cannot gaurentee the data
        warning('earsread2018 %s', ME.identifier);
    else 
        rethrow(ME);
    end
end

normfac = 2^(1 - intsize);
pcm = bsxfun(@times, double(pcm), normfac);   % scale result

fclose(fd);
end

